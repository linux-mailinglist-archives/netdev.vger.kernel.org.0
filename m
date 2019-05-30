Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338AC3045C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfE3V5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:57:48 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53424 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfE3V5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:57:47 -0400
Received: by mail-it1-f195.google.com with SMTP id m141so12534112ita.3
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=89hZMmezA5w3jZYmfuhYUi1+Is13nZJN6LeR0xoSleo=;
        b=GLKTJijDjlMRvcXrPX5Ns9+quvhGmeECbBgUylrrom0ejvIyJD6gChGM0TiYg5HY77
         Co6mBGwZr+ClVODBpYYpcxPzcurFNp4ntxk7UProPyh+LlrcAiAds2wGk0vJgUGF88nT
         uxm/+DCsouKK7EDv5zLSuna/aiXpHIThX4/YAx/SH5vKkp04GXLr9AReqCMm38VT7AcV
         4XchkTPAR6p0wDPdickX7YDu+kSTM+s+6MdQgKN4NNN3xlmfo4O/p9uPNumeWoPqHFJR
         saa4nTrvcTg5FF5w0iX+Yc760B4VWoCoj7z9y0odV9KX8WBhvmp5TYmQghGwhi0u4mu3
         NCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=89hZMmezA5w3jZYmfuhYUi1+Is13nZJN6LeR0xoSleo=;
        b=Li8IN0JCh/5TO+45YdeQTVhOZqJN9wpuPGYNKtUwxmrTE6hlw0juxu7mToQSJ1OYZM
         lkIeR74c2mzdhUlPhUQllP1Xgc6WTcIUVDljSZEKIVhViBplj15nJYRWPCJwMIIwf/b8
         70vhhc1sHEKV3xHLLCbUo9pUR5x6Ud11vRinMcmOamkPi+LSrep10TLw++1ql1+p4ONL
         Uxw1TXiOWuEHVQY1ZB13Rnw7oMwbgZcKz1GfEHHpYwvmvYgrsLKdgUI4IuG4G1ipdl+c
         OXNvpsDG/aQfjFxDeKJCgBtWUT/YHBG7ZtrieIK0mU6n1APWIInkmb2vHbtGbMcoDctw
         a0pA==
X-Gm-Message-State: APjAAAXCYskbt+JSeeDEvt1A/6XjAbDRUEnV/4iUDUGW/VbXjIhY/Smq
        Ll3qFI3zU7buqVM99I8coQPPGg==
X-Google-Smtp-Source: APXvYqxGrZdOzpplGLW3jnXq9Gxfa2Fimr4iisJ2OndEhMcKwA9idABAiMd3LYhJRWTej6FhDaobeA==
X-Received: by 2002:a05:660c:392:: with SMTP id x18mr4397893itj.89.1559253052281;
        Thu, 30 May 2019 14:50:52 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:51 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 1/6] seg6: Fix TLV definitions
Date:   Thu, 30 May 2019 14:50:16 -0700
Message-Id: <1559253021-16772-2-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definitions of TLVs in uapi/linux/seg6.h are incorrect and
incomplete. Fix this.

TLV constants are defined for PAD1, PADN, and HMAC (the three defined in
draft-ietf-6man-segment-routing-header-19). The other TLV are unused and
not correct so they are removed.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/seg6.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/seg6.h b/include/uapi/linux/seg6.h
index 286e8d6..a69ce16 100644
--- a/include/uapi/linux/seg6.h
+++ b/include/uapi/linux/seg6.h
@@ -38,10 +38,8 @@ struct ipv6_sr_hdr {
 #define SR6_FLAG1_ALERT		(1 << 4)
 #define SR6_FLAG1_HMAC		(1 << 3)
 
-#define SR6_TLV_INGRESS		1
-#define SR6_TLV_EGRESS		2
-#define SR6_TLV_OPAQUE		3
-#define SR6_TLV_PADDING		4
+#define SR6_TLV_PAD1		0
+#define SR6_TLV_PADDING		1
 #define SR6_TLV_HMAC		5
 
 #define sr_has_hmac(srh) ((srh)->flags & SR6_FLAG1_HMAC)
-- 
2.7.4

