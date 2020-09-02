Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A825A395
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgIBDCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgIBDBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:41 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389C5C061244;
        Tue,  1 Sep 2020 20:01:41 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id n10so2622969qtv.3;
        Tue, 01 Sep 2020 20:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WGcFYnsjK23fcOf7m3ThWWICMlTjqTdhEG1f75QZ+OA=;
        b=YOo4unJu5nOav+nG6jqFvE2CVTE52u4HHe8TAmEbidyyHvCjKMHf8kg2IPT387b3/d
         8rv8ytbGmq2gwSl/bwPQEFKMHgnW9cbYif3iwEp0JgVhOQVsQVr/doFlev0BWN2gjwyi
         haN5+/CdQ8UCE8I1J330gZjibQ31DzV4tJJ+ibvoGURqMwMtMOib6qjLpIMFMrhGcCj0
         QpkuJccByYOI8ujsJ9x57fVPY36+RT+7ROmJFZiJ8iwlKJhb1lUSo2iVTQE3zOL6GdBe
         DAQVYVq1ps3w6OBGbRCK1j7POrr70xPI6ZkVFsPP+hBOGvl0R0R80i/eYVuvnezzjVq3
         z4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGcFYnsjK23fcOf7m3ThWWICMlTjqTdhEG1f75QZ+OA=;
        b=VDQMLiLek/Aea0sa0oT92pHUMgDg7g3s0ffM1y2IPOx5pCSwqzT1wfbZFsusjvEIH2
         FzdicL/4rmp6kpLlh66bUnv+DGvYLgaOXzYbtsbj8y7+GXRMuqpLUmk8RH6Thh/yBNG0
         L+dWKvYmi3fRwU/CGbfqjrVgxRrhxSbvLFnE9mAIX8Z/vB9CT4FOBo+T+2OQpsV+1BR6
         rSI7o0XDQ/4Zmj4AF29sguMCLQxnmWHoFpiqGwTfNKxwpC/LNNrQZxXp2f2Gnf3t7N8d
         KD75ERjAeKNLbj6RktIabWCp+4xhc/GeeufrMfk6ZGN0jNiwEbiVRtJBYudmEcsvwaol
         2A4Q==
X-Gm-Message-State: AOAM530erg5VPkQ1EFLqPBNJcacpRxorh434hZgWfgJmTLrPwtFXvcPI
        u1CCRI9vZjE2qW0cb3Ouzr8=
X-Google-Smtp-Source: ABdhPJxf40ejt0XqIHKsnoLsul4FO9P/HNNpomn1KLUTMI/rj8pVyeuQZvCM6sjg+f8ACaU0jUz/Jg==
X-Received: by 2002:ac8:3876:: with SMTP id r51mr5090876qtb.181.1599015700524;
        Tue, 01 Sep 2020 20:01:40 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id x124sm3448976qkd.72.2020.09.01.20.01.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:40 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id D936227C005A;
        Tue,  1 Sep 2020 23:01:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:38 -0400
X-ME-Sender: <xms:EgtPXzEfCdt9QhqfckN5ckH2wp9FA1_w-AqW7Zve__o8GD0W_HR7vw>
    <xme:EgtPXwVqCvxmDwU3jLuIHjvl9Vd4f_vmypBKOiMon_U7abqu5kjfIw70MfMdFnM7g
    bqYlWXCzuj3ABv1xA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhho
    mhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghe
    dtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhes
    fhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:EgtPX1L6q7X2nuOBedI_REu_jdXpNn47XBCTDQWPwG-z-j0gDqn1gg>
    <xmx:EgtPXxGtmgEvm1_Q2Aml0ddk9EtdMf7PVk_1-fYESar5vmVO10AjZg>
    <xmx:EgtPX5W6SCwRBdh1dGkYIzTYogkcJDmljTCFGAqE_BhbD27amF7Kzw>
    <xmx:EgtPX6WaqnIvcQw8njO3gteJZ4HqY3vxS2V-88H1plioE_yArTUgmdRtWwU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CEAD3280065;
        Tue,  1 Sep 2020 23:01:38 -0400 (EDT)
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
Subject: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Date:   Wed,  2 Sep 2020 11:01:07 +0800
Message-Id: <20200902030107.33380-12-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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
 drivers/scsi/storvsc_drv.c | 60 ++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f5f5dc863a4..3f6610717d4e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1739,23 +1739,71 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	payload_sz = sizeof(cmd_request->mpb);
 
 	if (sg_count) {
-		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
+		unsigned int hvpg_idx = 0;
+		unsigned int j = 0;
+		unsigned long hvpg_offset = sgl->offset & ~HV_HYP_PAGE_MASK;
+		unsigned int hvpg_count = HVPFN_UP(hvpg_offset + length);
 
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
+		 */
 		payload->range.len = length;
-		payload->range.offset = sgl[0].offset;
+		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
+		hvpg_idx = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
 
 		cur_sgl = sgl;
-		for (i = 0; i < sg_count; i++) {
-			payload->range.pfn_array[i] =
-				page_to_pfn(sg_page((cur_sgl)));
+		for (i = 0, j = 0; i < sg_count; i++) {
+			/*
+			 * "PAGE_SIZE / HV_HYP_PAGE_SIZE - hvpg_idx" is the #
+			 * of HV_HYP_PAGEs in the current PAGE.
+			 *
+			 * "hvpg_count - j" is the # of unhandled HV_HYP_PAGEs.
+			 *
+			 * As shown in the following, the minimal of both is
+			 * the # of HV_HYP_PAGEs, we need to handle in this
+			 * PAGE.
+			 *
+			 * |------------------ PAGE ----------------------|
+			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
+			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
+			 *           ^                     ^
+			 *         hvpg_idx                |
+			 *           ^                     |
+			 *           +---(hvpg_count - j)--+
+			 *
+			 * or
+			 *
+			 * |------------------ PAGE ----------------------|
+			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
+			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
+			 *           ^                                           ^
+			 *         hvpg_idx                                      |
+			 *           ^                                           |
+			 *           +---(hvpg_count - j)------------------------+
+			 */
+			unsigned int nr_hvpg = min((unsigned int)(PAGE_SIZE / HV_HYP_PAGE_SIZE) - hvpg_idx,
+						   hvpg_count - j);
+			unsigned int k;
+
+			for (k = 0; k < nr_hvpg; k++) {
+				payload->range.pfn_array[j] =
+					page_to_hvpfn(sg_page((cur_sgl))) + hvpg_idx + k;
+				j++;
+			}
 			cur_sgl = sg_next(cur_sgl);
+			hvpg_idx = 0;
 		}
 	}
 
-- 
2.28.0

