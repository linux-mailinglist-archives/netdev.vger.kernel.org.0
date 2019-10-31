Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139ADEA91C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfJaCJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:09:46 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:47004 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfJaCJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id e66so5188058qkf.13;
        Wed, 30 Oct 2019 19:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MCaeEL/78MnjFFwuHJ0AYNxPqsK2pIIoZSumh2mRdY8=;
        b=pzQcnJ/Xh2T0A3D9AJizp8dc8rBAwm9kBW/jWELzn7TQ+ijlpc7rJIVDGV8iGTyCM6
         DDgGzI8++Pdmbl15KcLpciH+dQznaIfhAqy2G1BEbE/PawE0PT128x2XLrIB+M+0Ce4O
         sPetXiQ33gWMgFQ5PW59KMxtSCF9uk+3i2lAHLvxB4hDAEbpZWPB5Gvue2LgZAJUedsq
         z9WB0M3G2Sowi2ylAvlgRyhRRGvXFWfhvHGP8hJeudKCqxiJeh0OoUFjPafuwPP0wz2J
         QLQ+BgbP2b8yRCM4J5ZP9d58sMfFqOkxjyS3C/vQT8hZEA0v+o09pvFb+MWWxehs8nEY
         YV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MCaeEL/78MnjFFwuHJ0AYNxPqsK2pIIoZSumh2mRdY8=;
        b=unhL2sW27EhPCreDcY3irYqj0IEhtMPhtKVakoaJ8GKqyOZibEcWTUJ0pmRteN69be
         bzFlCFBgxYHP6E6cyXjpk2prrVE2lSWjFaL7QN98AgSoZ5iafq2AsSUVWVIuBdVT8YF8
         7s1O1LU9/mPZ7F6AJSEcJYadI5D1cGUyIcEgeXFucz55gFSVpHXOEWfFA0DnnRSvnXPO
         63pDXxjrdHi82snMqiODkY9k6w+aYhmfGmzXcaz33v7pZcPEA6s0zvyOOxrnHLSzW7GZ
         taPoIqWNQh8HOdslnHMRKO9t4qfL+82h58YBUfOAK967591gCeUq9Cjy/a5PME85+b5Y
         ZiEw==
X-Gm-Message-State: APjAAAUtxb+8EbUIjIcm7uHqzb45TfjkXZAgAAIl65o/j95jEo1Luz7i
        T/wuXaYGNs6QpTXoKwiYW3iecOJ9
X-Google-Smtp-Source: APXvYqzlJ+bsfAeTLe7GONP10dKvBoz4JLulDtj9Uzceme12BMx1CFBTy3fR8nBfdkL2KrSkJvYNPQ==
X-Received: by 2002:a37:4dd1:: with SMTP id a200mr3051041qkb.419.1572487783999;
        Wed, 30 Oct 2019 19:09:43 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c17sm305597qkg.135.2019.10.30.19.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:43 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: dsa: tag_8021q: clarify index limitation
Date:   Wed, 30 Oct 2019 22:09:19 -0400
Message-Id: <20191031020919.139872-8-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there's no restriction from the DSA core side regarding
the switch IDs and port numbers, only tag_8021q which is currently
reserving 3 bits for the switch ID and 4 bits for the port number, has
limitation for these values. Update their descriptions to reflect that.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/tag_8021q.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index bf91fc55fc44..bc5cb91bf052 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -31,15 +31,14 @@
  *	Must be transmitted as zero and ignored on receive.
  *
  * SWITCH_ID - VID[8:6]:
- *	Index of switch within DSA tree. Must be between 0 and
- *	DSA_MAX_SWITCHES - 1.
+ *	Index of switch within DSA tree. Must be between 0 and 7.
  *
  * RSV - VID[5:4]:
  *	To be used for further expansion of PORT or for other purposes.
  *	Must be transmitted as zero and ignored on receive.
  *
  * PORT - VID[3:0]:
- *	Index of switch port. Must be between 0 and DSA_MAX_PORTS - 1.
+ *	Index of switch port. Must be between 0 and 15.
  */
 
 #define DSA_8021Q_DIR_SHIFT		10
-- 
2.23.0

