Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560702651EE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgIJVFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731063AbgIJOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:37:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2690C0617A9;
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ay8so6532250edb.8;
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8HvRoiCT6Kaqw+ME0No79Ijetq5cFPuTsghNfxraGwU=;
        b=nUxVcG8/Gc71+4ot2A2Swhq1iHl5I5udIPQA5pErGqnEZcNyUf/HZVQqQqCohsrxzn
         5cyDq7J56l7uFC0o2cj7YN1PoGuVFh7yqFbJ7iWrPT347WXmOVmFTwvpUtGLy7JXESll
         8/YNkAbKEh22aN2uPfGV656lszd48mEZuuoyIJqvOynJpsKoolic0DdiX1khR5k/09fF
         xMGnXkMj1Jz7+55GFmHszF/42TLtQO3wg6BLZRCyTF4z6ZTLKY5Uu1P8Zs4+eN74SIsT
         ISomZMNoJvDbRDkqsk+mDo0Uwa8AdajBskyTH88+9FVf25WlpAHJWFIKWSmjqt+UvkDB
         l5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8HvRoiCT6Kaqw+ME0No79Ijetq5cFPuTsghNfxraGwU=;
        b=GyfBFSnjfXRgcH663axb+NcMDPkxPZcFI64pMpmrOhy4KVMTNypX6oHLMfYI2UnTYw
         8igjAUyaUJs7DR9JTRZg+5rccOYR09wVAaAu8iakky/G/nRb+4bG6LPKH3HhfHgOtdWb
         5vWmgOPaLb57xFt9iDQ8OjmukPVCAIzCCRvp4Us0eoQ1RxSdxcmKLCe+gtYeHvAqYSdq
         dYF8Q9DwbGryMUSAQOKLgvb4vAjFQhNXPZMKEjC3vdUX+ryf47ngBzChDHDllWsj4/+Y
         yRryFZwpxZQ4X4IdjMLq7bjXsB61gy2lTUJpalwLPChylXwwfzmQinPsZT+mN28aYb/m
         apLw==
X-Gm-Message-State: AOAM530D7NuTBPgMA+fZwlETlDkVm2kcmRwFe6tt0aY/w/cq88wRSDwn
        yJ5wOQPUDjpK0XGDLsVAiTs=
X-Google-Smtp-Source: ABdhPJwNXgGLyf78LllCxiKYdXIqr7RFMl9vsJSHfdNs3cPpKF5gm4SQXM9MIAPD1KxMYSw9WhyOOA==
X-Received: by 2002:aa7:c987:: with SMTP id c7mr9890667edt.385.1599748525404;
        Thu, 10 Sep 2020 07:35:25 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id e16sm7311945ejk.68.2020.09.10.07.35.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:24 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 5BC2827C00A3;
        Thu, 10 Sep 2020 10:35:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:21 -0400
X-ME-Sender: <xms:qTlaX-gM8Ru-FxewhZyXlYl-UwXC6Y0CFCg0p8Jy3EcPlsPh5ENknw>
    <xme:qTlaX_AKEdWXcDEEq3tON-e2IwnVTi6ySPNJmOwJ1DzCPxM97lw305JXqvvS6pTkp
    6CtUYmrWoHCnZeUrw>
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
X-ME-Proxy: <xmx:qTlaX2GgtTTN8eFG5oCuvPw2QOuzdK0bc_vU_OaN-Bm97GbaWecroQ>
    <xmx:qTlaX3Tbu9sAvwzGETMjhs5oW8ioJFDg15SXhOCtHAYmdQ3bYvl4oQ>
    <xmx:qTlaX7xsWnnmPsqpY8f8y2Vg75B-bM_7lc2XQwLx5nqwjXgSKHaCCA>
    <xmx:qTlaXyi7Nng2jgVb-9M1_der89Caf2YGcJenFZ2SGDi5wMUD4_99rrxZNuY>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92ED73280059;
        Thu, 10 Sep 2020 10:35:20 -0400 (EDT)
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
Subject: [PATCH v3 10/11] Driver: hv: util: Make ringbuffer at least take two pages
Date:   Thu, 10 Sep 2020 22:34:54 +0800
Message-Id: <20200910143455.109293-11-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
least 2 * PAGE_SIZE: one page for the header and at least one page of
the data part (because of the alignment requirement for double mapping).

So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
using vmbus_open() to establish the vmbus connection.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/hv_util.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index a4e8d96513c2..3996c16568a3 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -500,6 +500,14 @@ static void heartbeat_onchannelcallback(void *context)
 	}
 }
 
+/*
+ * The size of each ring should be at least 2 * PAGE_SIZE, because we need one
+ * page for the header and at least another page (because of the alignment
+ * requirement for double mapping) for data part.
+ */
+#define HV_UTIL_RING_SEND_SIZE max(4 * HV_HYP_PAGE_SIZE, 2 * PAGE_SIZE)
+#define HV_UTIL_RING_RECV_SIZE max(4 * HV_HYP_PAGE_SIZE, 2 * PAGE_SIZE)
+
 static int util_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -530,8 +538,8 @@ static int util_probe(struct hv_device *dev,
 
 	hv_set_drvdata(dev, srv);
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	if (ret)
 		goto error;
@@ -590,8 +598,8 @@ static int util_resume(struct hv_device *dev)
 			return ret;
 	}
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	return ret;
 }
-- 
2.28.0

