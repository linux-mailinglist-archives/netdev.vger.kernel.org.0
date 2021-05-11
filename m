Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B1379EC7
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhEKEor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhEKEoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:44:32 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD9FC061760
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so472551wmb.3
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsCvJr4vTwPoE7/DTp7x7jVKKhNxBO/CRiZz1em8k+w=;
        b=JSBkBA/fZRmJSu3Y9xq3akl7ED6Tvpe7AvXz1yQrByhsaur23klSnr6Gyq5VVkOF/P
         ehiDxkgCwHbnHX/mXBNSZtuuk7bsIIRGAiQ4j3jut6l8HNUKQNHAopo2HuU2VL5zei60
         JWVu8C+wV0DiXbMmrKqq77WXG2qN+YjSeDXpu87UOw8Uk9c2CBK5DaS+yiamWcO4kRFR
         eWmoNtLNlfEI/s1QDxveZYkjyxgFod5GgIjU4xSpwEEoUEKLpYx2FaOMj94DXNvUUu4Y
         MuzNETQ0sy/X7KcHezWttVz3VxYGEu9aQaUaC9vgboklMJdAAEP3UHyzzWyc75VQnZ2B
         1WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsCvJr4vTwPoE7/DTp7x7jVKKhNxBO/CRiZz1em8k+w=;
        b=N7P/8DJNm160GbUBaPhnsf+0FnWA7d0KzTEIm0nG72j3mbgm7B5wPCEBq3S6KUrv4r
         sv68iqcdehLgzNpOk+hy1gIkMhMuq3MtquyfuVuISYVpPzFeBAI1Vl8zVGF7Q0gBWrVq
         KCEEE8Iq38OOHLcrm463XErENbntJ9vwXc4GpNwYlFZghK25ImgeCU1xXdDz5gbzqQ4i
         CbrTD9FPBnemeiPFIF1ZkZAykTjX90sv7QqHe3DtoFKdoaGl9I0Wh5z0r/QuaMhRsNdh
         Uh/Q5mWw1jEfEcC90Y/uPiHlh7zJPIba6Go/hUN1PxZ6KYY6xLxmmjk8FV5w4HUEucUR
         eqHg==
X-Gm-Message-State: AOAM533E+fdkIh75xhtkUBiMDkuIIK/wbhUSSRaZgunJNNWyH8Rvx/uz
        XYod+vWjtADo0/IRnrAZTiRl0A==
X-Google-Smtp-Source: ABdhPJzxeGzw+4yEOHbL5HDKHJ+qupAsDGcMzwF55Eut8wUC/I5FZbSmyp0K0X27fWEs54GfArqysw==
X-Received: by 2002:a1c:545c:: with SMTP id p28mr3073820wmi.118.1620708205432;
        Mon, 10 May 2021 21:43:25 -0700 (PDT)
Received: from f1.Home (bzq-79-180-42-161.red.bezeqint.net. [79.180.42.161])
        by smtp.gmail.com with ESMTPSA id a9sm22360520wmj.1.2021.05.10.21.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:43:25 -0700 (PDT)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com
Subject: [PATCH 4/4] tun: indicate support for USO feature
Date:   Tue, 11 May 2021 07:42:53 +0300
Message-Id: <20210511044253.469034-5-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210511044253.469034-1-yuri.benditovich@daynix.com>
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 84f832806313..a35054f9d941 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2812,7 +2812,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 			arg &= ~(TUN_F_TSO4|TUN_F_TSO6);
 		}
 
-		arg &= ~TUN_F_UFO;
+		arg &= ~(TUN_F_UFO|TUN_F_USO);
 	}
 
 	/* This gives the user a way to test for new features in future by
-- 
2.26.3

