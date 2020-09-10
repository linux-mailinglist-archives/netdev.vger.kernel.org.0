Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B7626481B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIJOjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731019AbgIJOfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:23 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10ECC0617A3;
        Thu, 10 Sep 2020 07:35:19 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id nw23so9063267ejb.4;
        Thu, 10 Sep 2020 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KCYaWwcvDjz/OmO+LXtbRJ6LszuyteB8m/JYCI1W1Mk=;
        b=PLMSr5mhrZi80kquG3UTKc10L5Ed+nu36WWw+z2lZB7jY2NtSZwMDvRpv3TuwllizR
         7wpc1iofk2ZoyyDJwpWceFzTiHn90TWZgiZ045Rqz/ctDq5xo9epE09YznVy4EY1BmCs
         l2St/n4EQLGLl4Irlj/CjiNUTGWsQjI0pEg6F+baJPziJDFYBOwuCCOyMb+xCs9CEFvu
         9KFGfkT69xlzT78AdIbRIVXoCrdn7bCNxNeWDPtg/woOLBOGoZLIKsWAlBjbsXvCsg9/
         +ESlgsmFyeGx507Da/rJqBOVrFWssFaCbV59079oaLVMMMb6jhwsRiqhXjYp00Drq8eS
         JdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCYaWwcvDjz/OmO+LXtbRJ6LszuyteB8m/JYCI1W1Mk=;
        b=UFEPDaW6+yZMFx6m0VsNz3MGpAwL6M01lCF9AbqLIjFd63jnlOiw5djUQvdTIPokW3
         VHmxa+Vyv/WzdOTxr2SEOnyD7j43evAls5fS/lI86MXSaDa0UJ4YQZtQIWxiRD6THmWN
         bAJLAf2VKkdvTOG53mLFImXh7ZuiLo3x+AllljfJ05YnflmrDrNHPaHgqRjD8b9mplFw
         qNA8sImuiwgO9O/xK4HaS71jXLVHsGygYDog/+ooCpxRm+5AKKYfhIISJKs5CzDrL72/
         7RdEVaio6ZEY4Oz+W2hQfcrkPv+OP8EXky2dFoJPf1j6s82Z5lRnX/+bbaLC4AHaJthY
         KAfA==
X-Gm-Message-State: AOAM532OKeSERX9CGPVjdviG55sYo/xPyfeuQYo69cztuMbQJwywpaeQ
        iwII9gjap6tv8/JWgpadtTA=
X-Google-Smtp-Source: ABdhPJzWHmRORR4s5GPtiMxYzRL7RIeJHACIEt31sw6plEpoQQDbSHFzrwWgxYbTiAiLDLiHODRGHA==
X-Received: by 2002:a17:906:e4f:: with SMTP id q15mr9640896eji.155.1599748518392;
        Thu, 10 Sep 2020 07:35:18 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id ot19sm6825559ejb.121.2020.09.10.07.35.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:17 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id CE39C27C00A2;
        Thu, 10 Sep 2020 10:35:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:13 -0400
X-ME-Sender: <xms:oTlaX8LSfERbecu5P4Y3VnX8QDSTfUIGezI8Hipxv2LnPtz7F4DBPg>
    <xme:oTlaX8IkTh1tJF26F5X221FUudtaV7u56qa6z1D_VKOQW2Lmh0L4mwdo_h5rkdvG_
    ECZe3GDzwCWnxUEXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:oTlaX8tKhMX0KlXUF85wFnPzW9q02D2iV3z0nFlfNh75RGMaWwXWZw>
    <xmx:oTlaX5amjTY7Rkksn5WCySfesXGC-eH8Vs3Dz60JGqN1ty073ZFy0Q>
    <xmx:oTlaXzZ2hmDQiNVFuEI1gHCMoz1HeGK-QKZrR6fgxUOJ1Lq-hcO6gw>
    <xmx:oTlaXwJ27AAct8MQcnQ5XmCc0ME2n0zxJ-szRB9WVJWXntdGTOzVGz5uryA>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 106293280059;
        Thu, 10 Sep 2020 10:35:13 -0400 (EDT)
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
Subject: [PATCH v3 06/11] hv: hyperv.h: Introduce some hvpfn helper functions
Date:   Thu, 10 Sep 2020 22:34:50 +0800
Message-Id: <20200910143455.109293-7-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a guest communicate with the hypervisor, it must use HV_HYP_PAGE to
calculate PFN, so introduce a few hvpfn helper functions as the
counterpart of the page helper functions. This is the preparation for
supporting guest whose PAGE_SIZE is not 4k.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/hyperv.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 6f4831212979..00c09d2ff9ad 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1687,4 +1687,9 @@ static inline unsigned long virt_to_hvpfn(void *addr)
 	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
+#define NR_HV_HYP_PAGES_IN_PAGE	(PAGE_SIZE / HV_HYP_PAGE_SIZE)
+#define offset_in_hvpage(ptr)	((unsigned long)(ptr) & ~HV_HYP_PAGE_MASK)
+#define HVPFN_UP(x)	(((x) + HV_HYP_PAGE_SIZE-1) >> HV_HYP_PAGE_SHIFT)
+#define page_to_hvpfn(page)	(page_to_pfn(page) * NR_HV_HYP_PAGES_IN_PAGE)
+
 #endif /* _HYPERV_H */
-- 
2.28.0

