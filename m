Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF2125A3AA
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgIBDCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgIBDB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:29 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AC7C061247;
        Tue,  1 Sep 2020 20:01:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f2so3104202qkh.3;
        Tue, 01 Sep 2020 20:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CqVajLbzBylhgfGAcsTOQbCfA2sTjaEeoT2LMxZ+IiM=;
        b=jld6SluI6OirNLpb7nRYuLVFV2MzNpTQmjffzTGNNuASZdrNv1+RNjqKyKOurdgTIf
         C7I6mMcQWKrqbvBhfo0tO6ygjl+6O+4dBbc8poKvOrtJnC1Ha478I1oVOV457pK6DNvE
         pvJRn20U7akfNgWbTiCV239+TcdQrcsZOidJnjqJY6e3r0DakTl9OIcietLHVasOwjzI
         bYx6/EVCkQz7ln0FGnDW43lHdQPa3C9KYB2ptqXwkbY3+r1I2Gos4WnjRoDpDVR5Oyxu
         8StcPpWimNY2m3ZLSoFmTNtHIHFNqK1VLikc3GDhjLz0caXPmICSkU/yFe19v89xiAmc
         t2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CqVajLbzBylhgfGAcsTOQbCfA2sTjaEeoT2LMxZ+IiM=;
        b=KE3+kYVkbvK1naVn8ORtaQoPttAhCHAAAYhCFykmgFqSNHo2mg8P6kLFuIrnn502gm
         zjfGXtlSvxdW1SxoLGGAWZ+w/XoIF1UYR5t15i+WDx/IILB+NONr0p5AN8FE+fjJqyw4
         xh3bpMwD7h8zJeK9AJDCBwSpwu8FMHRcSNHI6syj3udKJDBofq9rEu5zhx0S9Uwue0M0
         g2Uk3xHckH5pK2gd5nukIbe0jO7YXyPSL0krEY5h+kbRcJf1CNpaIAzloZPMlMQad5Ct
         zge6t0Fs0qoP8qe4QYZTilAE7vAbrOBBf8qsSWjnRAKS2B+o9HQsx5PICR8y5RhhpI1A
         EdsQ==
X-Gm-Message-State: AOAM532uaiCtgKgUV6pyZz9sqIZkTpMmY4HEVI4bcMFt4Yib8f/LmIoJ
        C7tZhOCU427hjes6CcT0YHU=
X-Google-Smtp-Source: ABdhPJya4ett/bfDlaTnH2O/YYL/8kcaS4O0DBORp/3rRnG3PiHuGHF9pqq4Z5QFg6r4TiHYiLpIBg==
X-Received: by 2002:a37:7a44:: with SMTP id v65mr4813046qkc.420.1599015687688;
        Tue, 01 Sep 2020 20:01:27 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id t186sm3744445qkc.98.2020.09.01.20.01.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:26 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id D272527C005A;
        Tue,  1 Sep 2020 23:01:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:25 -0400
X-ME-Sender: <xms:BQtPX_i3sg81qiBGgK_Mgct_iYTGkOzACcKN-NECJS75_l-4CoTvIg>
    <xme:BQtPX8BA9zB8d8VzwBMyMF400BdpGfZx8sS2q9qSCt2PDvEF1hZDuUWysKJ6r3xf7
    H_CkHuU4l3mAqzA3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:BQtPX_Fp0yXWQtPYcGftUg-1TZ-rX568bfIUbFj-pJ5c-RqOsgU2-A>
    <xmx:BQtPX8QNQvnkyCgozuRQB51cRghNsFLHUpBIC6TXMipjCiHq5c2sRw>
    <xmx:BQtPX8y4cV5S3xuVQH7FLiBqdxMXj_wdvPoTejUSrvPUxorOy8DFtA>
    <xmx:BQtPX4BqrqnjGChB1OrrBiKXRCH_DIWf4QynRlZNBWnhr0PK7TxoOk_hB5k>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 42B243280063;
        Tue,  1 Sep 2020 23:01:25 -0400 (EDT)
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
Subject: [RFC v2 04/11] Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
Date:   Wed,  2 Sep 2020 11:01:00 +0800
Message-Id: <20200902030107.33380-5-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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

