Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543CE2274D8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgGUBmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgGUBmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:03 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D12C061794;
        Mon, 20 Jul 2020 18:42:03 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g13so15033175qtv.8;
        Mon, 20 Jul 2020 18:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J3OHNM9zOYfQV2dG1GUcbEevN0jecbySISLynxXJOhc=;
        b=ZplvFcBMRUhUdrfEbS+kLjhrAFP/cazjPwN7eLIJFcrP7U38pyrgYOmcG8DUgznpHL
         75/vFLnHFUaGEvXs2YhjW21fOpn/XsFCyWaSxwlPq4+72xUQb/rygDhs1ERSVjXboqdC
         AwPMM4EoQoHxeriYgQFE3ffQBZOxuVweyHdrSLhNsT+epQX2I7ANVjFuwUnjN/alPKAl
         LyHIQQ60EJh195yPDngyvTSy4KW/kM4JRVRvYmZ6VcdDiS1nXCYbxpmiilfXgDTbXJws
         UXuJalzLHWR0IW+/eSbNGg22xGCgeu63OD8XwIAS+3Ul5IHnFT+KtGMItdtB8/37ZWKt
         Nnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J3OHNM9zOYfQV2dG1GUcbEevN0jecbySISLynxXJOhc=;
        b=hEiochWEGB5OCtE+gdOQA6ZdpCZ8kYLxRvOvrpBk6LGszO65Cii57i/v44M+t51JpO
         3OJNn6ynJBXHelX0IwW6N1RlyV8v1ho0GJnMH8EoN2xcL0ddtYUNZeU4O2iV1wtnZcUC
         v4SPg8aDRlWbNPFT0dV24I8rUMjdOrpPsmuSn00s760Tv9h8Cuo3YqVl0kwBoUPLu0bP
         hJMckplvWjUWIEHoDg1ztBmbaa2TA0rIea0tyTe9sHw0wHXZ3O6jKSxremk7uG1iB+Sq
         q5QDrVcCv8pvELjtpzWJE3HgJdluRMDMbMv6kLfA0flerNsIkUZoV/7G4DghXax48U7X
         EFmw==
X-Gm-Message-State: AOAM533vtFPMVZ5npRREfYU6UOPN2as2crxdg7vMkn+N+g4pZGtpc9d/
        RdcHu/COstAvzqvGU1LbO/E=
X-Google-Smtp-Source: ABdhPJzzPpsaFzrLMFbqT9vsoHMAK7a9Inlgzyrf05eKs8xDqZwxojFn5V1GU7KPnE9MmCCSmImQTQ==
X-Received: by 2002:ac8:7a9a:: with SMTP id x26mr26409510qtr.161.1595295722576;
        Mon, 20 Jul 2020 18:42:02 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id d8sm1270243qkl.118.2020.07.20.18.42.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:02 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 6D62627C0054;
        Mon, 20 Jul 2020 21:42:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:01 -0400
X-ME-Sender: <xms:6UcWX63B5S4JXfGWWzAatodifi9Igz-L2v0PTlNac9Mdq-EyUySqmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:6UcWX9EARz0W_ZSXmxtMTi29PT_Bd-EQQHrAKBPryKBJMkOchOkwzg>
    <xmx:6UcWXy53A9h1vjTNq1fPNJHibg-s5HFBLSnwePHJYJCvbTONM9-9MA>
    <xmx:6UcWX71-2B11Ve3Q4jpEF_Zqi_4fPqnNj_qRB4ojKgoCtZrOiOTeZQ>
    <xmx:6UcWX6frUUKgWhsjsyaxyl3sZ2nj3W_HzbVD7fQhO3AsVVpoExTYWy6gjz8>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF1C93280059;
        Mon, 20 Jul 2020 21:42:00 -0400 (EDT)
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
Subject: [RFC 06/11] hv: hyperv.h: Introduce some hvpfn helper functions
Date:   Tue, 21 Jul 2020 09:41:30 +0800
Message-Id: <20200721014135.84140-7-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
index eda8e5f9a49d..b34d94b1f659 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1703,4 +1703,8 @@ static inline unsigned long virt_to_hvpfn(void *addr)
 	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
+#define offset_in_hvpage(ptr)	((unsigned long)(ptr) & ~HV_HYP_PAGE_MASK)
+#define HVPFN_UP(x)	(((x) + HV_HYP_PAGE_SIZE-1) >> HV_HYP_PAGE_SHIFT)
+#define page_to_hvpfn(page)	((page_to_pfn(page) << PAGE_SHIFT) >> HV_HYP_PAGE_SHIFT)
+
 #endif /* _HYPERV_H */
-- 
2.27.0

