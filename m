Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D782651F5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgIJVEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731167AbgIJOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:37:23 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93810C0617AB;
        Thu, 10 Sep 2020 07:35:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so9040781ejo.9;
        Thu, 10 Sep 2020 07:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3i3qXMnhJ5Pfez9h/HWjHE3nazk6XcC2fJXvr78eKk=;
        b=XE1hxXcFnJJOnwWXrIxwiW2HrxFHccyG+wLSuBNlS110t5JdPOcFyuEcDzcAwGqwsf
         kg30G7OmWlEzmZGb5s4ub+rjsJNugFWL3WYd9CXPjwnwWVOpB9+Uz5IFkGPFqQGGQ6yS
         O2jVO3oEye1D8vvqdHXK9lNam/rw4NQeUQilGtWUQ4zBd6whelBB4rgUSQym+GsqQnf4
         WWsg/8mRRUxrQ9qn1KaKR1Ida8UPPRVpl/5iqiafbFQXAADPWkd4xDaSPbRyeOhh4CIQ
         modZoQeFhDCNMbyuMcrOza3HAH2wMa/dU5qq3FuaDuvbuM21pP75apRskyKwjhgiMcYz
         HuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3i3qXMnhJ5Pfez9h/HWjHE3nazk6XcC2fJXvr78eKk=;
        b=TbaK9FbHvYVtzoS3fXCwQ0jiAG4j8MsWeiCnNiDZDuHahghfzqe+b1KqKu9F9UNSCL
         CWa9eG5f5t81kCK2SH3DOBIkn/kY2zL9XkABE1F/HLtjpBSZHxI13Ddhezri8otTIhXJ
         RNn825P9RhUxrCPrM2WebZvyrZi3uwAZA3nMPyxWT8DCSVhZZjUfaRG9NTRKEDvE6WiH
         MR5fSi915PtclTWaaEha3GPzQHwMSTmAj5r62ua3l7NU9sTxoh+KtJacqJ9Uta3xDcnG
         U3yIBntPRQiA8SFL3SpPozXcb8ctubhhWf8PLHmPciIEDrueBJkGw0HjyIRkDyqKUEX4
         //Gw==
X-Gm-Message-State: AOAM5331f9Fo8zqXD3zfU5Jh39iC2gCtBRdjcqakj2V9RI1r5Ry5Fp+K
        uTvgSJw5wGOtnbQvmBZ9JEs=
X-Google-Smtp-Source: ABdhPJzK8qE8+S3d6bWZO57JfOB2xqDtq4ntdMlxomIVjovtPXSzMq9l3+nxOhieFaaCFSpmkfiFnw==
X-Received: by 2002:a17:906:24d6:: with SMTP id f22mr8828364ejb.85.1599748526997;
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id l10sm7466796edr.12.2020.09.10.07.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3A4A827C00A1;
        Thu, 10 Sep 2020 10:35:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:23 -0400
X-ME-Sender: <xms:qzlaX2QvWxEkTCC2tui21cV517yBUkBYIcAPqkac3WkIKTRr8Dt3kg>
    <xme:qzlaX7whjQAkRTdLrm400vh4FhUPYaV9uGsu_zBg67Lg3aSxdgGxaIo_lyU0nJvdb
    N9nKNQNc_sYDLZs2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:qzlaXz2dFiF-XVT6Xa7SerHC87GJdLPpdDRIYF8NLMWx-iSTJz5tVw>
    <xmx:qzlaXyAtBYeQvz735bPXqVmK7YFKVgtpxcGb2UmF2eBaQdU1K40CPQ>
    <xmx:qzlaX_i6grllRqMzAioAYnIzJQgvUh7L_TS4jFr1qCBLBr0_8JjQxQ>
    <xmx:qzlaX6TLLzI22LvgOTgTc5C9eSB2SCYOLJpbj9kGY48iNyMhY4jsla5LFiM>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 779C03280065;
        Thu, 10 Sep 2020 10:35:22 -0400 (EDT)
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
Subject: [PATCH v3 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Date:   Thu, 10 Sep 2020 22:34:55 +0800
Message-Id: <20200910143455.109293-12-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
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
 drivers/scsi/storvsc_drv.c | 54 +++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f5f5dc863a4..119b76ca24a1 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1739,23 +1739,63 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	payload_sz = sizeof(cmd_request->mpb);
 
 	if (sg_count) {
-		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
+		unsigned int hvpgoff = 0;
+		unsigned long hvpg_offset = sgl->offset & ~HV_HYP_PAGE_MASK;
+		unsigned int hvpg_count = HVPFN_UP(hvpg_offset + length);
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
+		 */
 		payload->range.len = length;
-		payload->range.offset = sgl[0].offset;
+		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
+		hvpgoff = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
 
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

