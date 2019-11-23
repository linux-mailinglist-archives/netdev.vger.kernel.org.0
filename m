Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D551080B2
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKWVEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:04:52 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53182 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKWVEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:04:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so11187360wme.2;
        Sat, 23 Nov 2019 13:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=B4L4Pfo4rpcpOUx/OybOJ8g0Fxx8N1fe9jCWdz/sqNQ=;
        b=EDJYYI6p7ncCS6VGIedn7jyw+dN5o9jTjoV8O/BheFltaoPhtvPBhNCqKEPJ3M45Bk
         3Xey+QtfJaYDBv1U1Gx4u28JKCDgBuE84mdvjAvjW/cywtm26cZT+4l/JK6Rcpm7Guse
         3gOPKJSUIzaDCjj/kvchNp4+lcaRxhcBsaFz19X8fyxWqk6lc/hxeolOf4nKq9qAzNIs
         QgicN4d+Q0S6u44qYEmMCpzdzFy9JWD5YhKtsp6HzKNE0nvBNp5+tGpiCa1hcX8pwvv9
         ul4NquULZWtVom5ATTY+VJs9j7t7ZlxTzcSvzg1ZFnBuTKRWvbXAXUkMZG5LT+m2g/RA
         0tgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=B4L4Pfo4rpcpOUx/OybOJ8g0Fxx8N1fe9jCWdz/sqNQ=;
        b=beAWEmIVXwSqGQJGnUbPwIu0DKqBQwYrLLrRri1KPs/q4ByVnHfnVk5JqFL3y6s8p0
         NpQiSEREbC3+NiFzMFtSSRSqXBIv3ugUHHbWbzcsKBRcMLxQVJqOczJwHLgXH5w+bi4o
         j/vRzUH52/hEZrAF8deebGxtzSwWbgai8wzPdMiHJFizGOAZocOCru8yDhBC0gBqyanO
         hUWheb3U6xw8XUyV6B+d/JdFgK1Xfqw6s8pjMjv2tLrkVLzHvJxJGcR06JD0hc39q4Di
         koiJ7LvOBCCIJa/LHZEWUBD2RpbaCXIIp6lq8rqNA5Kcl0CT2fCKuaONORIMD1x63Lgu
         XgDQ==
X-Gm-Message-State: APjAAAXrLRFHDhiSn9bnfMqXWk9RTJsaaUVpohsen2huOUShPUFk9f8O
        NV3U276++KNqbaFBnU0RciqkCEcg
X-Google-Smtp-Source: APXvYqyIHNH4JcdrJW0SRV1lTtP8ss9twLDiJmqih5JP8tIQs1OJ4xvZJfgq119jTKRewrNKK5ExYg==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr23521335wmc.28.1574543089690;
        Sat, 23 Nov 2019 13:04:49 -0800 (PST)
Received: from spectre (dslb-088-065-249-135.088.065.pools.vodafone-ip.de. [88.65.249.135])
        by smtp.gmail.com with ESMTPSA id o189sm3170400wmo.23.2019.11.23.13.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 13:04:49 -0800 (PST)
Date:   Sat, 23 Nov 2019 22:04:47 +0100
From:   "Andreas K. Besslein" <besslein.andreas@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oneukum@suse.com, davem@davemloft.net
Subject: [PATCH net] ax88179_178a: add ethtool_op_get_ts_info()
Message-ID: <20191123210447.GA8933@spectre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables the use of SW timestamping.

ax88179_178a uses the usbnet transmit function usbnet_start_xmit() which
implements software timestamping. ax88179_178a overrides ethtool_ops but
missed to set .get_ts_info. This caused SOF_TIMESTAMPING_TX_SOFTWARE
capapility to be not available.

Signed-off-by: Andreas K. Besslein <besslein.andreas@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index daa54486ab09..8bc44c3f7c45 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -827,6 +827,7 @@ static const struct ethtool_ops ax88179_ethtool_ops = {
 	.nway_reset		= usbnet_nway_reset,
 	.get_link_ksettings	= ax88179_get_link_ksettings,
 	.set_link_ksettings	= ax88179_set_link_ksettings,
+	.get_ts_info		= ethtool_op_get_ts_info,
 };
 
 static void ax88179_set_multicast(struct net_device *net)
-- 
2.20.1

