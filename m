Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3802274CF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgGUBmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgGUBmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:11 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EEEC061794;
        Mon, 20 Jul 2020 18:42:10 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id d27so15034925qtg.4;
        Mon, 20 Jul 2020 18:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xkjJqCA8YZaaNIBsGoxFL3NuJEwbh2dJ4VQ8Tg5P7Z4=;
        b=Zop0mPg0OtPu+HEBKd4RV0b8PD3u6dBBhssMnc4fJQxD76x9xt4+obrL1iQHQQ4tJF
         oGPcU0bg+dDsHJN7sDMcEguu6vlngmK8LpwiwTLo8bxwIpcstrU8o5iPUXR7lSW4368d
         F+wOHRgl7R7d7gtpDAmLXRuRfCwS1FJoaUyjp68RNOyb8rd7GzkEbx9hLeBL/SNBJcBN
         BoUWipSItJngLPABWL41mU4BPdjpYKucx2UhJKKDVeu5cSlntE2Rg2pX+v/bOGvNMBRA
         KYEQVunS3M6IrGewWIQaKWashpzXXj2EGUGEaQFQ1juvPMkxENF0lV8QcRCg+6ime5jz
         Byyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xkjJqCA8YZaaNIBsGoxFL3NuJEwbh2dJ4VQ8Tg5P7Z4=;
        b=BmgKxh07tI+A+wIE/u1eRF9zDh/n8HfKK57Jg/Hn3GpgzFdj/wp7Kzd2Y3ikDJdwbq
         v7fZXR0NG2ifoCQKT0oEeVIcg5o7lRNBz4Jel73UcDEfSEVfSUx406hQXyBeW4kDyu2Y
         dh6cALmeg7GR3glf994pDjk2zve+XqX4lbit4j0FDUUO1xSRwgc2PknFoGJ6ZfVRzP5j
         T8fHnU68KJGB6sABgw1WnbsSkDoCgbn2rJVVLs61DBmQWrWeykgkcxCbNX30OW9qKEAZ
         wHoRGOXtsYklptEIGzO+uqm3JslD/B48QVXLayxHignsxa8ovGKZzagVpUdmngsAWhYL
         Iygw==
X-Gm-Message-State: AOAM530PABgFdn5e8bwug6fPJKcIXTaMdKzREF0Ri2Ww3fKUtjntB/DB
        cy5tgWKX5SO5juKkQEcKciw=
X-Google-Smtp-Source: ABdhPJyVH14I3938Qst+xsZJVFXgCcXexPLIY9zYTYKY2/RK1Q+QgT/7gpuyZkaL58XU8XVJoD2wxg==
X-Received: by 2002:ac8:154:: with SMTP id f20mr25116256qtg.331.1595295729829;
        Mon, 20 Jul 2020 18:42:09 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id s24sm21969705qtb.63.2020.07.20.18.42.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:09 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id A0C8727C0054;
        Mon, 20 Jul 2020 21:42:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:08 -0400
X-ME-Sender: <xms:8EcWX4GEJ_Ej8GgyY0TcapdGhrJjktZ2xnicri9tsn1b6NlUza-onQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:8EcWXxVtwXvuCAR8kU59rp0Iy4U7HpzQkNX_5FA3J76uhALKnCXUXA>
    <xmx:8EcWXyKoGDb3JjefZKSl0Ffgji5fmWUqtB3flGpwmqizdp7cyxh_Pg>
    <xmx:8EcWX6GOye_UaUeG-tKEMWF7BA9nNJwwEWdujgchd-X2CPylAqge_g>
    <xmx:8EcWX_uxBrswW14bMuhPXyB1smBXQ3piR_wdhWXVRgAJOa8xfDl5USpRA_s>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3456130600A3;
        Mon, 20 Jul 2020 21:42:08 -0400 (EDT)
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
Subject: [RFC 10/11] Driver: hv: util: Make ringbuffer at least take two pages
Date:   Tue, 21 Jul 2020 09:41:34 +0800
Message-Id: <20200721014135.84140-11-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
index 92ee0fe4c919..73a77bead2be 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -461,6 +461,14 @@ static void heartbeat_onchannelcallback(void *context)
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
@@ -491,8 +499,8 @@ static int util_probe(struct hv_device *dev,
 
 	hv_set_drvdata(dev, srv);
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	if (ret)
 		goto error;
@@ -551,8 +559,8 @@ static int util_resume(struct hv_device *dev)
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
2.27.0

