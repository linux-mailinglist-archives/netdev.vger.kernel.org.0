Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A70725A38D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgIBDBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgIBDBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:32 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E28C061249;
        Tue,  1 Sep 2020 20:01:31 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w16so617183qkj.7;
        Tue, 01 Sep 2020 20:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HbcXYxfwsiuTEtFnozpwnac7NHrDPEIjX3Balg7ij5I=;
        b=OZppQQjHnQptu/cGNYQh/AGEcitJ6KxnMzHWsU7aNkmW39VUtuPg3Ehe32ShlgQPUR
         8XLvNA9kg+GoTn4qsKjpd1PhSSxNG6HTBaJAV25yJ+Ciht7CzdISw2xbvNd4nBh1McoT
         wvcPhooNqXxdG4BG+nG2RccuLZbkG9JY+lZ6GlN24PaAsF5SaOspTqSbJyMDsYJdNzak
         8DmgTGoG0tnXVwaHtTYEnyYku9+Ya8u6Noj8mXwYc6WV2GHpTdlrUWv/2CqnAEM9DcC5
         d6L9wx6g1Kbrqy9ahw661EUaeFdVItKMJrjGSvUDLgfZv0xVM/52CwYW8D5LcZwyubZb
         oAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HbcXYxfwsiuTEtFnozpwnac7NHrDPEIjX3Balg7ij5I=;
        b=gIuL3pf+grW9YLY+vCHauxnFITk2Ao9bEWoSwDSCAEYFn1dl1IpTi8iPDgYkrtd4FB
         XLvHVnnCDPscD7gYZFNC2wNd8RwQFGcknpwRCAT5Ijrd0pr79/aTtc0hBKNgVog1c20L
         DpaHJY9JCcNvd+ATxru7xPiYCX0/hz0O7Vj2KMdfeVha/fSmc+Whd2XTMV2NYS8lFobR
         o0dXkjZAsodK8cQsEPZQFd9h2yhI9WJTG1VA05f1bU75A7iKLPBi5hM48p6dbkFKANTB
         Y/lInFhDprq/JZRUIirmSnqPtwPdAVDOgqhCTEDwU2EojTaeuPNRRtDUmILy6eacW/vq
         CuPQ==
X-Gm-Message-State: AOAM530fBIE+2xMYt97rsyuaItxxjwBYvGQ+NSJ8rtF0wdzm0UwL1QWJ
        cmvpEPqPMsYhFrL2L3DIRYk=
X-Google-Smtp-Source: ABdhPJyzODGst4eI+hBA2eZYxWwagr/jeIoIBUTb8AsSf9e8AJzFnvQn8JPc5R1ddRQJ8zIki2AlSg==
X-Received: by 2002:a37:78b:: with SMTP id 133mr4940375qkh.107.1599015691159;
        Tue, 01 Sep 2020 20:01:31 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id i14sm4450941qkn.53.2020.09.01.20.01.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 861D527C005A;
        Tue,  1 Sep 2020 23:01:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:29 -0400
X-ME-Sender: <xms:CQtPX85rgvIkKxbvRsPctQZ6d5QC7d3xHMnPuBmG7SSlMqd7Ahr0wA>
    <xme:CQtPX94WQbzvvU8lMuVZxIdAcBy-klwjzwXzrRCUTd3i2VK-N-NmiuDMER5wwbmlK
    1oNPKP-i72SUXfebw>
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
X-ME-Proxy: <xmx:CQtPX7eISjL73HC2QXxvV8SOuk5ROiwWtU3dqgPySREYf_8SSbegWA>
    <xmx:CQtPXxIMKGAI40-XxBMVciO1Xcw3qmalFUi-VN8ECsaI-lLCDNmHXw>
    <xmx:CQtPXwIUweSQVIhm1PJdd9KwUpytPNfk6hQNiMN2ZZxbCbjfcQHA-g>
    <xmx:CQtPX95ZZFPXyfCgIA31FId6PzAd0CzDV2LKOVOkOVYBEcFNx-TFNae2VZk>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E92653280059;
        Tue,  1 Sep 2020 23:01:28 -0400 (EDT)
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
Subject: [RFC v2 06/11] hv: hyperv.h: Introduce some hvpfn helper functions
Date:   Wed,  2 Sep 2020 11:01:02 +0800
Message-Id: <20200902030107.33380-7-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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
 include/linux/hyperv.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 6f4831212979..54e84ba6b554 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1687,4 +1687,8 @@ static inline unsigned long virt_to_hvpfn(void *addr)
 	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
+#define offset_in_hvpage(ptr)	((unsigned long)(ptr) & ~HV_HYP_PAGE_MASK)
+#define HVPFN_UP(x)	(((x) + HV_HYP_PAGE_SIZE-1) >> HV_HYP_PAGE_SHIFT)
+#define page_to_hvpfn(page)	((page_to_pfn(page) << PAGE_SHIFT) >> HV_HYP_PAGE_SHIFT)
+
 #endif /* _HYPERV_H */
-- 
2.28.0

