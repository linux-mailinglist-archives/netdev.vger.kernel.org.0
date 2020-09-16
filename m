Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560EB26BB16
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgIPDuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgIPDsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0E1C06174A;
        Tue, 15 Sep 2020 20:48:36 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so6816533qka.5;
        Tue, 15 Sep 2020 20:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cfdZosb2wz8tjTjhVSyQ0JhRneNprQvsTD85NoPjnkk=;
        b=THHMBkUuWe3CpLtWWCIBCupKKVhyM0gFpQrCn1bQlsK9fdCpZopv0KrayjdEoD/N7m
         SKhxoNDSYE2CFUxdUec4hTvbmu1+rCx/ikRh24Optq75ZeOA5uXeAMRHDVGk3a+hP9LJ
         7Ny6kFTPdo+fEiASMClKvxAsdRvjEcoh6HLVrXgGA4WdjLyJwjmRyaPg2n869COCktQS
         l9yB+frm1QewFmtBc0cdx8w6QY/UX7r3igfOl7+BHr52F+8AfP29GhUqKqOyuXMP9wOZ
         xbvxV8hySYsC7ZDkiqlCFAIb6l+WI3J/06CCo4pSje7TP9La6mFLtQeHxtsRPsaNMVkv
         SC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cfdZosb2wz8tjTjhVSyQ0JhRneNprQvsTD85NoPjnkk=;
        b=gRKykArm1LiJnp1MM4K41k22q/X/1m48O1Mm59+3e7L7cmf7jG7VB7Ritykbu6bz/h
         s9SkHPegD5IQ2P6XEWgl/3T05sBXrGXTk36Ss5qbSH7SvsIK3/LjamYnQ11zv8uPxNHh
         equc8EQAIANQGRpyYz4f/VEoURrjdnXOWmy5jT8ICUXq+RiaLsI1UF3x/Z7E2MWvHIxu
         NIIv8tSN6tSJoxrZENpi5STgRlkcRHZxI9iDLgqUgsi3cfBMijMNsHzamdbquUp2qCnD
         DikvvnZa/I0ekxzyx745Nlsb4x0R1o0krg2+n6CWFHbzA/JMsBBEMUUls4/7Tpu9H3eK
         bX5Q==
X-Gm-Message-State: AOAM530vNIu5FUQUih9DrYNY5sIgPjm5izuNNEX2wCBymCd+UMjdjyIa
        rI3KU1wPpzDIxwwE+ozh68U=
X-Google-Smtp-Source: ABdhPJzCAN6dS3vCbPFQn5fElDxXwYt0QjHIlnA98x3BqLCh7Xl5WgLZUNxavfj9nY9Ky2jTWKogiQ==
X-Received: by 2002:a37:a602:: with SMTP id p2mr21332909qke.254.1600228115497;
        Tue, 15 Sep 2020 20:48:35 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id g12sm18491619qke.90.2020.09.15.20.48.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0D21227C0054;
        Tue, 15 Sep 2020 23:48:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:34 -0400
X-ME-Sender: <xms:EYthX_w4mV67hISrYhAnNVdd8K_jiDCHesD91j0ZJl_x-aiNq1IF-w>
    <xme:EYthX3THtUh0T0jgI2hz0bx_NdxvbNtFI1ubp6wpUZeCfF7ARI72Gri0Ch-mSa1ti
    Ucte0m-UadVAzqFeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:EYthX5V86LQkNR5zLODirhtEHeCrczZoDvx8EDlRmPju4PtXAmRo5A>
    <xmx:EYthX5hVKjvpMyJdiHQOlME2U4QSIl_OTR1WzMVA1VPkzbomwpY-hw>
    <xmx:EYthXxDGUC4BmR-ERD0uOBU8UwdsCMYhSXlLYDCEu89tAoxYkmujJw>
    <xmx:EothXzyB6sjpJJZXRFwZhjg4KOov3PlF1UaxpsE617NTz9pmtXUneQ-oSgc>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 618BA328005A;
        Tue, 15 Sep 2020 23:48:33 -0400 (EDT)
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
Subject: [PATCH v4 06/11] hv: hyperv.h: Introduce some hvpfn helper functions
Date:   Wed, 16 Sep 2020 11:48:12 +0800
Message-Id: <20200916034817.30282-7-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 include/linux/hyperv.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 83456dc181a8..1ce131f29f3b 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1691,4 +1691,9 @@ static inline unsigned long virt_to_hvpfn(void *addr)
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

