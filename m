Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E727045000C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhKOIlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhKOIlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:41:16 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F6AC061746;
        Mon, 15 Nov 2021 00:38:20 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id d11so33836830ljg.8;
        Mon, 15 Nov 2021 00:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5BO6zupXKsq7QxwcvI+ZE0fQUmmRHhVHR5EykOjogIQ=;
        b=eCxb09vAsBlDE2SDJArcqnAOet8mEGHcTLJFtsburnUVRDUd5/jTwmzvJkkV4nMfje
         /S04ouHtVNbTJ4Xn1SjF9kJO80blQwp4cbIQsQC63Ie9NRPsPUuxRSTeyG+dk7cdR/5T
         K99l7t51UNPFRC8ovf7oVm7jRcUfYJeGn2YuUMbaJ4wwxttiULYbvOLz1IVbL/p+lH9v
         oys+yue0TJ1wGojTyetM2J4vDmCc4uexGCaqo9NqdniKDWv6bnAS/kqQaMief8t2x9SS
         0MfFU7JKJ6/jmILUsYBmuOAwWNA1DZdfrvPEJ0s0vh1J0gtOvBL+5n2+KXLA4FIki45I
         +A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5BO6zupXKsq7QxwcvI+ZE0fQUmmRHhVHR5EykOjogIQ=;
        b=ykb51liP1OoQrC9nCjP9IY2zrpVYTl5BIDeI/ZE73s16sEbSceb8sAbvBwKbq+AXPY
         isxW5iK7avP257yjGYd16xfqIgKWr4S5lqgfn3FQAlAAZI9tdrj4eAL6j3JENIwq38YO
         CIZLxJKlDxSHB8iacsAhRN/IZ6Bqeo+R5DpnaUcYpi/37a1vvW/MMCinYTu8tdQJdW7V
         kF/0Xpa1CY8jWKr4EOPK0RX2TuGvWpOPC8ULTs/ypwdXZu9v3bGNAn3YXQXQT/t/XWue
         OvLAkqmf5G7FKJEp8omXOrLjsL27+nxhEfpe+7Ew0JZJbOTvNxLag5cbFevuewb6XZqu
         GrBQ==
X-Gm-Message-State: AOAM530z00VV0+CudWaIfeSWgVK6PAaEz5FTeeOqS9Oj0FWkcNwOFdRw
        GLofpRm36rBQUu5okViB+RA=
X-Google-Smtp-Source: ABdhPJzZVk/Og28FR7o4EgCwydyOJJTERcZJyzie5FipEwjoYb/sP9+fiQ5SMZq2AVJ9QZvNsQY7vQ==
X-Received: by 2002:a2e:81da:: with SMTP id s26mr35794403ljg.94.1636965498874;
        Mon, 15 Nov 2021 00:38:18 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id r5sm1440797lji.132.2021.11.15.00.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 00:38:18 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v3] can: etas_es58x: fix error handling
Date:   Mon, 15 Nov 2021 11:37:56 +0300
Message-Id: <20211115083756.25971-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <YZIWT9ATzN611n43@hovoldconsulting.com>
References: <YZIWT9ATzN611n43@hovoldconsulting.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When register_candev() fails there are 2 possible device states:
NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
for calling unregister_candev(), because of following checks in
unregister_netdevice_many():

	if (dev->reg_state == NETREG_UNINITIALIZED)
		WARN_ON(1);
...
	BUG_ON(dev->reg_state != NETREG_REGISTERED);

To avoid possible BUG_ON or WARN_ON let's free current netdev before
returning from es58x_init_netdev() and leave others (registered)
net devices for es58x_free_netdevs().

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v3:
	- Moved back es58x_dev->netdev[channel_idx] initialization,
	  since it's unsafe to intialize it _after_ register_candev()
	  call. Thanks to Johan Hovold <johan@kernel.org> for spotting
	  it

Changes in v2:
	- Fixed Fixes: tag
	- Moved es58x_dev->netdev[channel_idx] initialization at the end
	  of the function

---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a..41c721f2fbbe 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2098,8 +2098,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		free_candev(netdev);
+		es58x_dev->netdev[channel_idx] = NULL;
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
-- 
2.33.1

