Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE6926BAF2
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgIPDsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIPDse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:34 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D27C06178A;
        Tue, 15 Sep 2020 20:48:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id o16so6790347qkj.10;
        Tue, 15 Sep 2020 20:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j16Iklf9MmgFYnbkWqW3PNIyedVb8alTWX44QgyaL7E=;
        b=FfrEn+4Z2NXwigQ7ggA/s2WfH2OFH4gBzRrMCcc/PuwcqMHzzWLFJMyUpEJTuRSuTn
         yLyBuGhbHbYHao8DAM9pi1wh0jd4xDHuFAwyLvNGRwOn4AlYRmSiE0m7ekPrEpsd8Mg/
         EZl0UNTGrJ0WPfKCqBAfKXJRoIqAg7JKviaiTLTZWScc/vdEApqolx3c37dy2m2D8TMw
         AtYRF3kvi/L0ga8V7rOiqunBf/2CYacExtTRw7AV0oTbg4G/sVbt3FgXz7j1p9fnQO+p
         JXmRw+eZ41kxuUIRrbKjicO9McxLvzczeCN/eE9gwgqfPlb69H1n3/I1FnSxjotfvhRs
         CZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j16Iklf9MmgFYnbkWqW3PNIyedVb8alTWX44QgyaL7E=;
        b=Xg+C7wMr7DDIFyPicGh6wSWV8tyyV4yoe0f579yPAPM+q3Bt4TQrMCOIJbKz0r9nrJ
         mRumKlEsfeAGUHzOdkWeyVAon0uRNPBhl1mqvdVzEe80ohJIJtgUPLONFeqpNmXROEl/
         MkbsdiiiaEzSe4pBSZIhmiswFLjqAYLlAsVBG2nhQKxsLQklm4E27A1n5GXk8R5TKuza
         jyNr1EV+Jj7J1uq7zvnur2CrG7WYBENXN8mrO5w1gJLKx0ASVvTnRVh4+lyH37VeGsd5
         hsYFLkuvuT1UFe5aRX2Znl+2Nv0/nf8VOf2hXSC8y82BXMvsv3jhjZ+swE1RFi50Mg5t
         h9Vw==
X-Gm-Message-State: AOAM532iQm5sthTWy1cf4aXSiaonXtTpXBuSJyXgDLmHSqEH1GBHuZJZ
        kD448n+pcEtR5awMrzAMu1Y=
X-Google-Smtp-Source: ABdhPJyehyW2t+353+Uka/nk8pKVZ8DoJkZh/bwYwA2IiXYWpvLm6gGEangbyeoPUQMAh4RQujn85w==
X-Received: by 2002:a37:6813:: with SMTP id d19mr20952903qkc.143.1600228111814;
        Tue, 15 Sep 2020 20:48:31 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id x3sm18761306qta.53.2020.09.15.20.48.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:31 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4211D27C0054;
        Tue, 15 Sep 2020 23:48:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:30 -0400
X-ME-Sender: <xms:DothX2K1gWEtce5YXm-dOzyZhBBwF_8CuFgRHqLdkmF_whtk-zh8CQ>
    <xme:DothX-JifodpXH3i3gx6daIW4LDqV6vRbjRfz-dzJTLCmXSO3RMzRNKvml9mV6vT5
    FEKM7Ms-EgOBiIRqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:DothX2t-X1lJ3bpavFywTDF0Yw4HWdpGoHGIZE5VLSPNszW2L_JI4g>
    <xmx:DothX7ZhxHJ9R6M2D4KQPPcrVdvpltWEstrWCH2upHCsYWdNCkIv-w>
    <xmx:DothX9bicnF5WwDFyIoLunGUbSpdwjuwSdrXa3Fq-OdvZX08VmqUWQ>
    <xmx:DothX6IoNxBJ3Vw25hFD_DUzotmUoawJjQ315UQVtC_2fXUrs4piosPkXxE>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 828C1306467E;
        Tue, 15 Sep 2020 23:48:29 -0400 (EDT)
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
Subject: [PATCH v4 04/11] Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
Date:   Wed, 16 Sep 2020 11:48:10 +0800
Message-Id: <20200916034817.30282-5-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the base_*_gpa should use the guest page number in Hyper-V page, so
use HV_HYP_PAGE instead of PAGE.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 7499079f4077..8ac8bbf5b5aa 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -165,7 +165,7 @@ void hv_synic_enable_regs(unsigned int cpu)
 	hv_get_simp(simp.as_uint64);
 	simp.simp_enabled = 1;
 	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
-		>> PAGE_SHIFT;
+		>> HV_HYP_PAGE_SHIFT;
 
 	hv_set_simp(simp.as_uint64);
 
@@ -173,7 +173,7 @@ void hv_synic_enable_regs(unsigned int cpu)
 	hv_get_siefp(siefp.as_uint64);
 	siefp.siefp_enabled = 1;
 	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
-		>> PAGE_SHIFT;
+		>> HV_HYP_PAGE_SHIFT;
 
 	hv_set_siefp(siefp.as_uint64);
 
-- 
2.28.0

