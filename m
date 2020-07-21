Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC72274C2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgGUBmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgGUBmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:12 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3AEC0619D5;
        Mon, 20 Jul 2020 18:42:12 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 11so8379932qkn.2;
        Mon, 20 Jul 2020 18:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u2Atj0Wbt7mub3xfeOzi2/XzJb4taKVgA2PwyukxOzM=;
        b=NIBrO2jI5v/1ozjUsawGijUoqYKW+gNjM1JQ6U0MUA0gi62nvdd6Eb178R1VhYoR6z
         JCh7jTT9Xqj4xD4xdcujV6FEsN8hXx/8gWdDk4fe7kMiTkhjDeJhXPE0WZn05wBWuHUi
         ZC3MSUTkLn4PharQOKyl3CTAVeIr1CfJBBRD08ow9Qngq2g2uiBG6qQffr9+CIR4CRO6
         YeTOWi05katH85rWjtQY6Db90392SQ5/ly/I7rGerxGQX8iPOsUWN+kLRsIMoTNFTzYC
         KtKcc7hCFKnh09xMoXta79S2S1ngqK+TgHwOdv7AmIE/TxO861OTGpXyDIXOeDSSTnZa
         eFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2Atj0Wbt7mub3xfeOzi2/XzJb4taKVgA2PwyukxOzM=;
        b=fjYMOwuxUKOZa3rauLAo5OCscOGBHolAcqDlHrprtfpOyGeIG4L7GQZiK4g9d59jgs
         jlvnde8TM8uynqYyZ6bODZZszvakVYk2YHIHdeanAE15j+yKfWDMTZm2uNc43IPZ+2HJ
         WFXeSpr0Xod0ppREln5GyaoN3n4GH9p+3UbMd1omzZUcQRAncdC2Adf6m13MkT5X722p
         FfG6GQDNRWQyybr9Q9FyoIZFQPHZBbKHpx/Fg0T/jaOje8CvTM7eKp925fSCNalxCu/+
         VqequQID+dst1+wvMFkYdYBOwv3x//55zzJV8MN5sdt5h1am4fEGq/sRwdV7nMxDlvEn
         G/Xw==
X-Gm-Message-State: AOAM533QvmTSzai9Q9X/MBrv3SXezb7X1En4kzhhPAGqho9ckl4Njvvi
        0cmRGrDsiqAZQLcnFWm23A4=
X-Google-Smtp-Source: ABdhPJxzLDJKSuKgbM1LhvHt9POP1m4UaCFUZ6bACPSPIEsWeHJYBeGQ2r8eP8mrZctmtDSHqnlxPA==
X-Received: by 2002:a37:c93:: with SMTP id 141mr4480301qkm.416.1595295731591;
        Mon, 20 Jul 2020 18:42:11 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id 19sm1232748qke.44.2020.07.20.18.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:11 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 85CAE27C0054;
        Mon, 20 Jul 2020 21:42:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:10 -0400
X-ME-Sender: <xms:8kcWX5WPtzlWhrFotGwWN9uqEvp2Vfi7nUO13ICjJwKiXfX9HvJ64Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:8kcWX5kcelmU8uzjUCtpPM7vowktSUHJirBNCT9eC8cXQBbZg5yLbw>
    <xmx:8kcWX1b7G9ES8h4YuPhbmQHOYY4ps8bO5ZGBuqIUahSza3QGAS7zbA>
    <xmx:8kcWX8Wz5Li4_01L-JSwxAGFT7a_zUDDeATZJFFSRbyDdAlcD7nNVA>
    <xmx:8kcWX48Y1yyaNy4CBkm_1xD5l9R_PzNqyhSFDCF6tY7HSDg9NIcAzOpgmWk>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02D33306005F;
        Mon, 20 Jul 2020 21:42:09 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Date:   Tue, 21 Jul 2020 09:41:35 +0800
Message-Id: <20200721014135.84140-12-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZE
as the unit for page related data. For storvsc, the data is
vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in unit
of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cmnd
into Hyper-V pages in vmbus_packet_mpb_array.

This patch does the conversion by dividing pages in sglist into Hyper-V
pages, offset and indexes in vmbus_packet_mpb_array are recalculated
accordingly.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fb41636519ee..c54d25f279bc 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1561,7 +1561,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
 	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
-	int i;
+	int i, j, k;
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
@@ -1569,6 +1569,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmbus_packet_mpb_array  *payload;
 	u32 payload_sz;
 	u32 length;
+	int subpage_idx = 0;
+	unsigned int hvpg_count = 0;
 
 	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
 		/*
@@ -1643,23 +1645,36 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	payload_sz = sizeof(cmd_request->mpb);
 
 	if (sg_count) {
-		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
+		hvpg_count = sg_count * (PAGE_SIZE / HV_HYP_PAGE_SIZE);
+		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
 
-			payload_sz = (sg_count * sizeof(u64) +
+			payload_sz = (hvpg_count * sizeof(u64) +
 				      sizeof(struct vmbus_packet_mpb_array));
 			payload = kzalloc(payload_sz, GFP_ATOMIC);
 			if (!payload)
 				return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 
+		/*
+		 * sgl is a list of PAGEs, and payload->range.pfn_array
+		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
+		 * page size that Hyper-V uses, so here we need to divide PAGEs
+		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
+		 */
 		payload->range.len = length;
-		payload->range.offset = sgl[0].offset;
+		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
+		subpage_idx = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
 
 		cur_sgl = sgl;
+		k = 0;
 		for (i = 0; i < sg_count; i++) {
-			payload->range.pfn_array[i] =
-				page_to_pfn(sg_page((cur_sgl)));
+			for (j = subpage_idx; j < (PAGE_SIZE / HV_HYP_PAGE_SIZE); j++) {
+				payload->range.pfn_array[k] =
+					page_to_hvpfn(sg_page((cur_sgl))) + j;
+				k++;
+			}
 			cur_sgl = sg_next(cur_sgl);
+			subpage_idx = 0;
 		}
 	}
 
-- 
2.27.0

