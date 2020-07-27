Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF36B22E6C1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 09:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgG0HkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 03:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgG0HkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 03:40:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D207C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 00:40:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc9so8771676pjb.2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 00:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2xuQNpxpe74Ey1Qd5408yn3bz5TDxj78Bu6GpKmObVc=;
        b=FEfN1EbTsdFX5nBtF9lJVVd3A6DG3eICj1JekMLND49BxuD8emsU0dp9jI6F4XWT84
         ErnA/qEOI5fowcahfVAGPAEm5HqjLg1WGJJEGL4TniY4J176mkVYx6moAN/FrufmJnmc
         R3w3X3ci3C4M/OKlr6wBTJfJ9S4k9SHWf/atR2cubU3sEG1EVoL6cYljU1VIaW0yplA+
         Cn9zpvgaj37x/tmnrXlqkalYzrffVd5gJkhjkBCaXvnliKms4RIkJ8s7/gVqLONJW5tl
         7JaVs5hV52f6uaYWY7uQaWM4UazqQka2pnmNK+q+zwB7yvaV9y4LYcUtpvMIAjZEDhxY
         OE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2xuQNpxpe74Ey1Qd5408yn3bz5TDxj78Bu6GpKmObVc=;
        b=TgsnENMK+q0rZ7Cw2KhmIIeftWdrnTUuX1O0BXwVVQu761HBsT4q9ocekYB+5OPzsC
         bRME+Hy3oLTtcGLfH13RNVqRWBRXuxj3M16E1S2gwzWoh/IZ98YkWDqJYqZb5UfsM1c9
         tpsMTrotmBkBpAWq+2y/ETNWf9+ey1FqSCNI74qVAfAwdMWvJBbly+74anlSJ790AtCa
         l3c7s8JBHxt1qUlwXuEnTL/H0veOZyXMfzU0eyaDVCLLjVDIChLODcIw+9y3x3Qe8Es7
         xh7hPrVi6I+CadTjlMHHyDKWBc1vDAZlDKCc0zrFM6+FxcG6VuqkslHigWSz18mKdwFw
         W2Mg==
X-Gm-Message-State: AOAM531jGPADHHmYj75EMlAVVcMEmOfb0YKySBANigOnMrzNtnCzbHP9
        894gzrjmKdVKjZHf57fVmooNr/jJ
X-Google-Smtp-Source: ABdhPJyThI9Qod6yq8+AUqymUTTJlcYQFSfRQ0nBd1CRyCgis3ygxN2+N5dc+HB/n7P0+k3gj5PMEQ==
X-Received: by 2002:a17:902:6b0c:: with SMTP id o12mr18502194plk.321.1595835602484;
        Mon, 27 Jul 2020 00:40:02 -0700 (PDT)
Received: from martin-VirtualBox.apac.nsn-net.net ([157.46.170.3])
        by smtp.gmail.com with ESMTPSA id m20sm13706542pgn.62.2020.07.27.00.40.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 00:40:01 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next] net: Removed the device type check to add mpls support for devices
Date:   Mon, 27 Jul 2020 13:09:19 +0530
Message-Id: <1595835559-2797-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

MPLS has no dependency with the device type of underlying devices.
Hence the device type check to add mpls support for devices can be
avoided.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/mpls/af_mpls.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index fd30ea61336e..6fdd0c9f865a 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1584,21 +1584,10 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	unsigned int flags;
 
 	if (event == NETDEV_REGISTER) {
+		mdev = mpls_add_dev(dev);
+		if (IS_ERR(mdev))
+			return notifier_from_errno(PTR_ERR(mdev));
 
-		/* For now just support Ethernet, IPGRE, IP6GRE, SIT and
-		 * IPIP devices
-		 */
-		if (dev->type == ARPHRD_ETHER ||
-		    dev->type == ARPHRD_LOOPBACK ||
-		    dev->type == ARPHRD_IPGRE ||
-		    dev->type == ARPHRD_IP6GRE ||
-		    dev->type == ARPHRD_SIT ||
-		    dev->type == ARPHRD_TUNNEL ||
-		    dev->type == ARPHRD_TUNNEL6) {
-			mdev = mpls_add_dev(dev);
-			if (IS_ERR(mdev))
-				return notifier_from_errno(PTR_ERR(mdev));
-		}
 		return NOTIFY_OK;
 	}
 
-- 
2.18.4

