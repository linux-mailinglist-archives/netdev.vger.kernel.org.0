Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9423D26BAFD
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIPDuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgIPDsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:45 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCEFC061788;
        Tue, 15 Sep 2020 20:48:45 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id z18so2865035qvp.6;
        Tue, 15 Sep 2020 20:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPzYc5oOvMVdMHVpg+qxDCWW0PFGNi+WRPFIeIhdQ+4=;
        b=UBmUL5imT2j/cAef5pU2ubcootYalanp00Q0SOtR0X1Mfwyx/vG8QDzJ4eJixQwFH9
         Jw8PfJ9WABmZt/3E4kyhm5eqlc2U4XMDczru8aSqgWLzNIxXY8fhxi4MT3JsQYC13yJe
         dQ04rZcX1+sdntILqxBpJrd3X3MRzAaSGbyRCDY09IjGS82Rv0X/WAa///spAWDgtVXT
         Ww0gIASu1wMqkbVhh9C7wu5FdxXGq5ByKaM++yx6X0blwyr3r/Q0/ZkI6aA4nBfpQq7V
         w7JoNxYdw5pGoT7JvRMV4VPzveKBft5Ej8Ck2+wI7hpF+0tE8NdbDEO0z/6UKziiw7go
         nVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPzYc5oOvMVdMHVpg+qxDCWW0PFGNi+WRPFIeIhdQ+4=;
        b=h1huBabXjP2pJVHmo1d31xwJ7+QKgJ7Fn3MyEuLthDrW9GU7gvkHiTc5iiL+4v/xOT
         ZK5oXeCogZUKGfZSasHCgk/G+G+hCWIl1u21WPRX3bcb/IPDCdMDHa91O+Zn+9oM6nCE
         1uFmruDi/1PNPvrMU+/GdLAVT+A4cFsm1bUEniinqbgZ+i2kLvJ5aXdM+6CVBKWuefBF
         U+rU4nGoiM6g9hoBzx1iMKyQQ2UFzEcGoZ5Ads9fiju7qMAO5r2ASXMBMi9arSIA2kKm
         VHo/H4vhvzUsi0oPE1paKxG3jf7afC8Q/RJDyoIAxhFpGZY0nkcspJhEA+vSdvyLYwqa
         kqIw==
X-Gm-Message-State: AOAM5328Om3L4uG0pmYHwN5WGsFBire43+xqV8A9RWWOw1R8BMe1QA65
        Ml1nJTox9aWN51psfYf+aAA=
X-Google-Smtp-Source: ABdhPJxw67/g8JIwHipwsztQj6OaLWAJc9TPPhurLPhDJ/oaP1keV/t4sSDY07GQIzhJunNP79tamQ==
X-Received: by 2002:ad4:4b34:: with SMTP id s20mr5039311qvw.51.1600228123063;
        Tue, 15 Sep 2020 20:48:43 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id s10sm97289qkg.61.2020.09.15.20.48.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:42 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id B6B6527C0054;
        Tue, 15 Sep 2020 23:48:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:41 -0400
X-ME-Sender: <xms:GYthX-iGBiWrSvJm-qM_nbgNONFww9NtJj8ad1uM7JYTfEv0DOH4-g>
    <xme:GYthX_D80Xb5oFFjcwYpp7O_1OSn4ht3tn9KA9vJSsnKHphELETtSywMP95idwTaR
    Vgy6JJNvR8h0mPK9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:GYthX2GqSIWTr9kROFlont6O1Ymjq6B7jzobYRkIw_U89EiBKDin9g>
    <xmx:GYthX3QdU30AWloRFpfQPAZpY25BokzmSk-wnUs4qJWwLjVnvTt_OA>
    <xmx:GYthX7yGDQRRoCCknXEKzlQfO1pwIsP3CTez4hei5fHg8lpljO4Pcw>
    <xmx:GYthXyg1kasTs2J5ce1ceKsNvUGpvTOHpxzpBXYLby-_SkBH0bRMAlxxXf0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16516328005E;
        Tue, 15 Sep 2020 23:48:41 -0400 (EDT)
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
Subject: [PATCH v4 10/11] Driver: hv: util: Use VMBUS_RING_SIZE() for ringbuffer sizes
Date:   Wed, 16 Sep 2020 11:48:16 +0800
Message-Id: <20200916034817.30282-11-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a Hyper-V vmbus, the size of the ringbuffer has two requirements:

1)	it has to take one PAGE_SIZE for the header

2)	it has to be PAGE_SIZE aligned so that double-mapping can work

VMBUS_RING_SIZE() could calculate a correct ringbuffer size which
fulfills both requirements, therefore use it to make sure vmbus work
when PAGE_SIZE != HV_HYP_PAGE_SIZE (4K).

Note that since the argument for VMBUS_RING_SIZE() is the size of
payload (data part), so it will be minus 4k (the size of header when
PAGE_SIZE = 4k) than the original value to keep the ringbuffer total
size unchanged when PAGE_SIZE = 4k.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: Michael Kelley <mikelley@microsoft.com>

---
Michael,

I drop your Reviewed-by tag because of the page align issue. Could you
review this updated version? Thanks!

Regards,
Boqun


 drivers/hv/hv_util.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index a4e8d96513c2..05566ecdbe4b 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -500,6 +500,9 @@ static void heartbeat_onchannelcallback(void *context)
 	}
 }
 
+#define HV_UTIL_RING_SEND_SIZE VMBUS_RING_SIZE(3 * HV_HYP_PAGE_SIZE)
+#define HV_UTIL_RING_RECV_SIZE VMBUS_RING_SIZE(3 * HV_HYP_PAGE_SIZE)
+
 static int util_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -530,8 +533,8 @@ static int util_probe(struct hv_device *dev,
 
 	hv_set_drvdata(dev, srv);
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	if (ret)
 		goto error;
@@ -590,8 +593,8 @@ static int util_resume(struct hv_device *dev)
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

