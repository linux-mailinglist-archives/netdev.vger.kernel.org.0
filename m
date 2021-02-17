Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929B031D593
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhBQGzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhBQGzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:55:39 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECABC061574;
        Tue, 16 Feb 2021 22:54:59 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id a24so6905625plm.11;
        Tue, 16 Feb 2021 22:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3o1Cr10hbB5eArafHXQS+SZhvH+Fl6pjSwLdmv19yI8=;
        b=e6DUdg2tYt8I0qXVFtJbalBA/Q9QhLhviUGkqMRxM7LnYaAa4Tn/Wz6OjDi+Ey857v
         zBlVmQoEwwepMtrVnP1ygR+BrSESQTKzr607AEylOkMQckSg9oCOUuukUElZ24NGPFdn
         YY5LNfUz6QOqHOVAtCBYF+P3S0knmdU6OxlyTqT07PXqrcyJVXSKB0pdXCk1dQ2Gl4lB
         P7bsNSK7Tg4qV5mDmxbI2xOlCyDwSQYyYLXWSd/fG/rkLCaV4FpNuPFS2350IIG41A8G
         RfKg4eZWlTiCEHa2f+Sjr/5xa3CipdZL/3fkf2UKWkklS/6PKPmSj3vdKFB79gjktxHC
         SHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3o1Cr10hbB5eArafHXQS+SZhvH+Fl6pjSwLdmv19yI8=;
        b=Z1lXtoVEj9qE6VgRdgfyDgj8uuEwrfzm95PRvYeqGwAA3DKcCqH4qz0DY+MkyEzkK9
         guH4f8AvEa/diechLM0EPXw1z4uNyIP9ejGU/ZefQ7yOUsnMTZeM7XrMpoytTuPLxviU
         OEBttRLiPCx4y8T5Iuh4bEHJhjGaWaPGpk/L4PdWJeusk8ptT7KNVAfAAVjrJD6Cbjzp
         tFqKfCPKNEBvuXuRwPdNZFWv2cb6LWuIqcpEZfoT+L+wLNYH+aOvrWPrIOaVKodhaqmJ
         jsIyj5Y+ICQi2chSv/90bEvjioDHQLRURfWYiZvIMTv/rSYZTQXN+bJga6Ikiq845LzZ
         acXA==
X-Gm-Message-State: AOAM532yJeRDn22JW+qhh9PZI0J5gp/S9NWXyeB2uLo2Q8dm/qmmdVx0
        GHarLoC1k0y2tELkK5kBm6paRFKX3GqVJA==
X-Google-Smtp-Source: ABdhPJx6WOLOqrHANscOpjJicUZuXCi5qK5O629iF9FhDbjDl2eMB2xvPV1pAHdsRXdF4GwolOYGXA==
X-Received: by 2002:a17:902:6846:b029:e3:8217:8eed with SMTP id f6-20020a1709026846b02900e382178eedmr1262363pln.60.1613544898872;
        Tue, 16 Feb 2021 22:54:58 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id c18sm1165114pgm.88.2021.02.16.22.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 22:54:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     andy.shevchenko@gmail.com, kuba@kernel.org
Cc:     davem@davemloft.net, axboe@kernel.dk, herbert@gondor.apana.org.au,
        viro@zeniv.linux.org.uk, dong.menglong@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 net-next] net: socket: use BIT() for MSG_*
Date:   Wed, 17 Feb 2021 14:54:27 +0800
Message-Id: <20210217065427.122943-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The bit mask for MSG_* seems a little confused here. Replace it
with BIT() to make it clear to understand.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
v4:
- CC netdev
v3:
- move changelog here
v2:
- use BIT() instead of BIT_MASK()
---
 include/linux/socket.h | 71 ++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 385894b4a8bb..e88859f38cd0 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -283,42 +283,45 @@ struct ucred {
    Added those for 1003.1g not all are supported yet
  */
 
-#define MSG_OOB		1
-#define MSG_PEEK	2
-#define MSG_DONTROUTE	4
-#define MSG_TRYHARD     4       /* Synonym for MSG_DONTROUTE for DECnet */
-#define MSG_CTRUNC	8
-#define MSG_PROBE	0x10	/* Do not send. Only probe path f.e. for MTU */
-#define MSG_TRUNC	0x20
-#define MSG_DONTWAIT	0x40	/* Nonblocking io		 */
-#define MSG_EOR         0x80	/* End of record */
-#define MSG_WAITALL	0x100	/* Wait for a full request */
-#define MSG_FIN         0x200
-#define MSG_SYN		0x400
-#define MSG_CONFIRM	0x800	/* Confirm path validity */
-#define MSG_RST		0x1000
-#define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
-#define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
-#define MSG_MORE	0x8000	/* Sender will send more */
-#define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
-#define MSG_SENDPAGE_NOPOLICY 0x10000 /* sendpage() internal : do no apply policy */
-#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
-#define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
-#define MSG_EOF         MSG_FIN
-#define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
-#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
-					  * plain text and require encryption
-					  */
-
-#define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
-#define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
-#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
-					   descriptor received through
-					   SCM_RIGHTS */
+#define MSG_OOB		BIT(0)
+#define MSG_PEEK	BIT(1)
+#define MSG_DONTROUTE	BIT(2)
+#define MSG_TRYHARD	BIT(2)	/* Synonym for MSG_DONTROUTE for DECnet		*/
+#define MSG_CTRUNC	BIT(3)
+#define MSG_PROBE	BIT(4)	/* Do not send. Only probe path f.e. for MTU	*/
+#define MSG_TRUNC	BIT(5)
+#define MSG_DONTWAIT	BIT(6)	/* Nonblocking io		*/
+#define MSG_EOR		BIT(7)	/* End of record		*/
+#define MSG_WAITALL	BIT(8)	/* Wait for a full request	*/
+#define MSG_FIN		BIT(9)
+#define MSG_SYN		BIT(10)
+#define MSG_CONFIRM	BIT(11)	/* Confirm path validity	*/
+#define MSG_RST		BIT(12)
+#define MSG_ERRQUEUE	BIT(13)	/* Fetch message from error queue */
+#define MSG_NOSIGNAL	BIT(14)	/* Do not generate SIGPIPE	*/
+#define MSG_MORE	BIT(15)	/* Sender will send more	*/
+#define MSG_WAITFORONE	BIT(16)	/* recvmmsg(): block until 1+ packets avail */
+#define MSG_SENDPAGE_NOPOLICY	BIT(16)	/* sendpage() internal : do no apply policy */
+#define MSG_SENDPAGE_NOTLAST	BIT(17)	/* sendpage() internal : not the last page  */
+#define MSG_BATCH	BIT(18)		/* sendmmsg(): more messages coming */
+#define MSG_EOF		MSG_FIN
+#define MSG_NO_SHARED_FRAGS	BIT(19)	/* sendpage() internal : page frags
+					 * are not shared
+					 */
+#define MSG_SENDPAGE_DECRYPTED	BIT(20)	/* sendpage() internal : page may carry
+					 * plain text and require encryption
+					 */
+
+#define MSG_ZEROCOPY	BIT(26)		/* Use user data in kernel path */
+#define MSG_FASTOPEN	BIT(29)		/* Send data in TCP SYN */
+#define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
+					 * descriptor received through
+					 * SCM_RIGHTS
+					 */
 #if defined(CONFIG_COMPAT)
-#define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
+#define MSG_CMSG_COMPAT	BIT(31)	/* This message needs 32 bit fixups */
 #else
-#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
+#define MSG_CMSG_COMPAT	0	/* We never have 32 bit fixups */
 #endif
 
 
-- 
2.30.0

