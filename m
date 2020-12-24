Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7B72E240A
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 04:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgLXDWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 22:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgLXDV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 22:21:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E30EC061794;
        Wed, 23 Dec 2020 19:21:19 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so774442pgl.10;
        Wed, 23 Dec 2020 19:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fLyH75XG6Wmzd+2wrXyTN5Uo0F1DMeQJARxHlPuP6sc=;
        b=UTIOHIEVvNb6XSXtWB3bAJnO7fZhtp0vBO+34Oyn23WUqr5uRdznZ3czuFXh2tIpbY
         58t2783NcHZGFJxDcu6NRKEt5qkoz3qy6D+tNrJbydJaaknY200ZKqgrMC7Jm1W6EWYV
         8RZg670gszb51+w89+Hi3ji0SU5VUbP1RusVzv/WRofnPQbjok1AHomI74IPgpoyKaMM
         TN9mTSwLsUJz2MuxQAWx3gsXqO9hxjY0i500GuVUFDMqylbccw8DOJglplCkKqVLxbnG
         vZ7uOFSOPRG/SJ0IN7suRH9FjmBZkcVigyPgQhEqzuNngTqPevSTh6HQ3EH41ZmTrOBi
         JKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fLyH75XG6Wmzd+2wrXyTN5Uo0F1DMeQJARxHlPuP6sc=;
        b=qYAC8T7THR/Uqt+w9JIrG7QssvlvZ+t8Jxbcjz7AnMJY+VzP0+0l1xLMDA6fnSOKhZ
         kri56feBS/tKwnMnHgBp2xxppui9pUjsU0tZzsPff8AtH5HYcKqqWs8Du43lUToT0DgU
         9AsII5jqMe7a3gVztYnIsBBQ7mYdA9ud1jtwtZH1byhUhSab8ecjS0HMfnDQB/T5zABm
         MxJbaitaAxr1dm2SvIzjsEVM7MSwniWHV2yjMK+56jszm0OZQfagfuTNaHotsf6vqXmp
         Ui+meGew8gR0G33cWc/2XMB0X/1Kfq3FLl/F52w8wK5oVGojRJ3FTE7SJVcv53v8Tb8A
         WtfQ==
X-Gm-Message-State: AOAM531p+Gg4aZni1rdPBaoSSAcydVd2t+OzVQMKZuAmI4Treg7i2Q0W
        lmfqAcmxBefN2wKzkwW0xIdmaV2kav3fGQ==
X-Google-Smtp-Source: ABdhPJwg2xSyIuYOaEycUufOSiSkSb0cs3q/L4f2raPLjYLzPI/nSTxMkjUeidZKO3wdhpJFHbsT4A==
X-Received: by 2002:a62:63c5:0:b029:1a9:3a46:7d32 with SMTP id x188-20020a6263c50000b02901a93a467d32mr26580023pfb.39.1608780078929;
        Wed, 23 Dec 2020 19:21:18 -0800 (PST)
Received: from localhost ([2601:647:5e00:17f0:9f6f:76e5:8291:c7e1])
        by smtp.gmail.com with ESMTPSA id a131sm18468728pfd.171.2020.12.23.19.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 19:21:18 -0800 (PST)
Sender: Roland Dreier <roland.dreier@gmail.com>
From:   Roland Dreier <roland@kernel.org>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] CDC-NCM: remove "connected" log message
Date:   Wed, 23 Dec 2020 19:21:16 -0800
Message-Id: <20201224032116.2453938-1-roland@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cdc_ncm driver passes network connection notifications up to
usbnet_link_change(), which is the right place for any logging.
Remove the netdev_info() duplicating this from the driver itself.

This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
(ID 20f4:e02b) adapter from spamming the kernel log with

    cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected

messages every 60 msec or so.

Signed-off-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index a45fcc44facf..50d3a4e6d445 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1850,9 +1850,6 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		netif_info(dev, link, dev->net,
-			   "network connection: %sconnected\n",
-			   !!event->wValue ? "" : "dis");
 		usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 
-- 
2.29.2

