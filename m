Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E472E26BAF5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIPDt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgIPDsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:46 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A573BC06178A;
        Tue, 15 Sep 2020 20:48:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q63so6830459qkf.3;
        Tue, 15 Sep 2020 20:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O4H82gItvXsuYW5jJfzm4UzNO1dqSANo/WeqLh46S/o=;
        b=haKl8fBKAWHbKvPgFv/YznINeUm7GWb4TybvmZrzIzJD+OVLlD82t/hRidSfgGMqNa
         Wevqedezby/Zx2yr6JWcrtuJXPun+YtgBGYhi8fUY0ikc/aF8ag5LwDDKKiD01RRhid3
         0YFoFFSIFTZFYne2dpyD2wHgxakEo39CDeGmoSA2AuBbanRuhuRMlBjyaL+9aJEdOCE1
         UyIfgYjBGBRqebjc3OZNvM5LuqsfUNfVpORcDN09jPE933JpiYUdTIIDY9HF4FqJzCg6
         jn9lg2aL1/h+8gu2p6x8uH90QoHCKsuPHwsEiV6dd3oVbMvuAfFLBmKYnm6ASO4BKR/O
         hvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O4H82gItvXsuYW5jJfzm4UzNO1dqSANo/WeqLh46S/o=;
        b=oUNieWN8kUeVsC0dc++ECf94O8AEd1Wvkoa25iJ/yzP1FrjdJe6a9UGqZnZI8AxABK
         WUDLKGUITFgkv7q1jnasRuEENPvXBDmI2B0RbnnPCEOnF3C+TQ8jIH1aor/R9EcpyQ+s
         cVCBiotgK12WLPT+UFinbk3K/KMlT8ncF+DPghaMpR18APOioYWC6fNoAM9o7UPRm9hC
         LCPE4/WKeB1qXKfRGWVp5pjAWDma1BzNXqIyMG3JWKCsPvvD24h0uDreyBKHryYVAFyJ
         asqcCx9LdinNXbVYopUrZNBBKUOqYNU/1xqh3D2R3eER9lDNummlBdNsaWgFilOkI/V8
         Xi/Q==
X-Gm-Message-State: AOAM5327LeA7tjStAHlqGGBDUVImq8VhQIiGC/uWzZ5oYuMC4gjr73YZ
        QDs9H98SexE6DSXRBxPmQ0A=
X-Google-Smtp-Source: ABdhPJzuLBp5jXkuB9HZIlQcHs4aGKyg3m421lOq53ZrBST3VLy0Slu3ZIzy2hkg6Ozp7N5u/GZ1EQ==
X-Received: by 2002:a05:620a:1341:: with SMTP id c1mr20286325qkl.460.1600228124936;
        Tue, 15 Sep 2020 20:48:44 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id z29sm18606041qtj.79.2020.09.15.20.48.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:44 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id A42DA27C0054;
        Tue, 15 Sep 2020 23:48:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:43 -0400
X-ME-Sender: <xms:G4thX1uxuO02wZ3pnuP4YYE7thr3gQyZIxa02MFRyzhufuFtMKhvlg>
    <xme:G4thX-dh1djB0D7w8PN09gTUVRcT0Mppv5bt91Q5MThH2YvFyMWYndJ_gLCDwEGce
    dvb0BqcwgAOV5EqJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:G4thX4yRJJNK8iiUq4ar7RK4zw6lX6Scs4XsZJpQB3AcrJgqvVO5Uw>
    <xmx:G4thX8MsSVurwqaBgWJo_SMWLa4PsorzM0iyC3jTouQYNXi5ZK9uiw>
    <xmx:G4thX18FZza6-7zB4llPrZfrvhacE2YgYAxefXM7oZNpQ6tZXy5WzA>
    <xmx:G4thXxuVIMNjTT7qoqg_QbguidS-1tleNR8MQNo_fQy0mNQ_u7HbTXWUjP0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2CE53064682;
        Tue, 15 Sep 2020 23:48:42 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v4 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Date:   Wed, 16 Sep 2020 11:48:17 +0800
Message-Id: <20200916034817.30282-12-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 56 +++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f5f5dc863a4..0c65fbd41035 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1739,23 +1739,65 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	payload_sz = sizeof(cmd_request->mpb);
 
 	if (sg_count) {
-		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
+		unsigned int hvpgoff = 0;
+		unsigned long offset_in_hvpg = sgl->offset & ~HV_HYP_PAGE_MASK;
+		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
+		u64 hvpfn;
 
-			payload_sz = (sg_count * sizeof(u64) +
+		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
+
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
+		 * Besides, payload->range.offset should be the offset in one
+		 * HV_HYP_PAGE.
+		 */
 		payload->range.len = length;
-		payload->range.offset = sgl[0].offset;
+		payload->range.offset = offset_in_hvpg;
+		hvpgoff = sgl->offset >> HV_HYP_PAGE_SHIFT;
 
 		cur_sgl = sgl;
-		for (i = 0; i < sg_count; i++) {
-			payload->range.pfn_array[i] =
-				page_to_pfn(sg_page((cur_sgl)));
-			cur_sgl = sg_next(cur_sgl);
+		for (i = 0; i < hvpg_count; i++) {
+			/*
+			 * 'i' is the index of hv pages in the payload and
+			 * 'hvpgoff' is the offset (in hv pages) of the first
+			 * hv page in the the first page. The relationship
+			 * between the sum of 'i' and 'hvpgoff' and the offset
+			 * (in hv pages) in a payload page ('hvpgoff_in_page')
+			 * is as follow:
+			 *
+			 * |------------------ PAGE -------------------|
+			 * |   NR_HV_HYP_PAGES_IN_PAGE hvpgs in total  |
+			 * |hvpg|hvpg| ...              |hvpg|... |hvpg|
+			 * ^         ^                                 ^                 ^
+			 * +-hvpgoff-+                                 +-hvpgoff_in_page-+
+			 *           ^                                                   |
+			 *           +--------------------- i ---------------------------+
+			 */
+			unsigned int hvpgoff_in_page =
+				(i + hvpgoff) % NR_HV_HYP_PAGES_IN_PAGE;
+
+			/*
+			 * Two cases that we need to fetch a page:
+			 * 1) i == 0, the first step or
+			 * 2) hvpgoff_in_page == 0, when we reach the boundary
+			 *    of a page.
+			 */
+			if (hvpgoff_in_page == 0 || i == 0) {
+				hvpfn = page_to_hvpfn(sg_page(cur_sgl));
+				cur_sgl = sg_next(cur_sgl);
+			}
+
+			payload->range.pfn_array[i] = hvpfn + hvpgoff_in_page;
 		}
 	}
 
-- 
2.28.0

