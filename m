Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2681B265220
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgIJVIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbgIJOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:19 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A025C0617A1;
        Thu, 10 Sep 2020 07:35:17 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c10so6550316edk.6;
        Thu, 10 Sep 2020 07:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CqVajLbzBylhgfGAcsTOQbCfA2sTjaEeoT2LMxZ+IiM=;
        b=XBOuVfCpG1rZMmR8+fzX2Iw0HyxjJyHpHSUZ13UXZNNaNP2MkaNQ5naNzlJnQr69MW
         txU08URc4XylmgF4L3W+Lbe9IVn0CWmYAQjTIVmhwm2VRGuMysnKzLIp2tWA4TR+4QUR
         f6PPWMysmhTzSbGNqoXtzjrfZxy6hLPieCB+zF/9UlCQEKVjGWHh6Z4BMy5VSCFhXc6N
         l/ieOxJHGv53pm8Ok+aySt4J/0GV3EQepNRybxtebZIqxALpwm7jXvPMxrC/OBs7WJdn
         n6DAxVWK4h4E1Fk5c4rz/gEi58CZYEtfZHINaFM+a93Vg3d0Pxc/kX0jOdeb1DbBnxXA
         3e4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CqVajLbzBylhgfGAcsTOQbCfA2sTjaEeoT2LMxZ+IiM=;
        b=OYCGQ4Ss405f5vjIkmxhY6ThjiVfLp0Y25fCNSsHqMmRYf3Ihxw+PUv0xPPXe4nTr5
         okCCHvCqWbO617Y22A/3Nle+YtO91fj/DN6itb6mCfP62g0FkP8d4NbOb/O5eL3jJSRG
         U9WpXdUGg4rsY0pKfzoLEHNuHXbVoNBl1PqlndlTWf6zb3kK0kn00uAPGOUUifkBSDGq
         sr6oSn5BJONUjxY/a02s4W8IL2j9gwIuSSBw8XNY00N6wZqyuibv29m76Y50tZOXkuBC
         uh6lETHMUumbLFSnGNIptITnXsDRXCefE3Cm5rW3mt+476Y7iao2+/leK/h0AosR69QW
         YeuQ==
X-Gm-Message-State: AOAM533uyzt8tXHiFE0lN6zsSDWslzwVnxpja1zoI68bvDXTn83yElD/
        k1VUfTbEOqeI9mEUS7Wwrdo=
X-Google-Smtp-Source: ABdhPJw2J6znE3xmbVz2se2YcLJ0No17Heg3y5yq6t4TgIrRRQk+Flrj2jGaX1lvFVts919IEO5+cg==
X-Received: by 2002:aa7:dcc1:: with SMTP id w1mr9281936edu.360.1599748515729;
        Thu, 10 Sep 2020 07:35:15 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id m14sm7647191ejn.8.2020.09.10.07.35.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id DFAB827C00A4;
        Thu, 10 Sep 2020 10:35:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:09 -0400
X-ME-Sender: <xms:nTlaXycIk9c1V30GYRYQD7LGT4vNFbJJb11yC7uf6bSca5mSyOVFew>
    <xme:nTlaX8Oe14Dxi7auU4ZlZmrTIAlJQPakSpF3KaUD3irp8RZ2MkUYvL_WPuvKQJrTD
    ZaNWeW5B8L90ky4Lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:nTlaXzgjlgElV5qAdyb5fav0nK2VSx58wTDpFTORKxASyRbB8u8kRA>
    <xmx:nTlaX_-6FN1UUx_hxhodsVGe-ltTn32xau1u9EPzfzLI4qS8OzssZA>
    <xmx:nTlaX-t8LIMgIw0vxfY7RUMuOOFmANjNfWctojCW-uY1ree9kfAnkA>
    <xmx:nTlaX-dByvsZfukcCTrY0ao4LC9B5nCg-LnbNWBkwlbfL2YbQtsK3eCr9Ug>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 284573064683;
        Thu, 10 Sep 2020 10:35:09 -0400 (EDT)
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
Subject: [PATCH v3 04/11] Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
Date:   Thu, 10 Sep 2020 22:34:48 +0800
Message-Id: <20200910143455.109293-5-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the base_*_gpa should use the guest page number in Hyper-V page, so
use HV_HYP_PAGE instead of PAGE.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
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

