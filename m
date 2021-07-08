Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0003C18AF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhGHRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhGHRzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:55:52 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E71EC06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 10:53:09 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id i4so2756856qvq.10
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 10:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cwxf7KEJLH0aH3P6Bk/LrPnmtc+hrdUpVwR6xUgQ4IQ=;
        b=J1RLSIOgi4uJxM6mRcqJNhUm3aT0HGueiUa9P/RPhhNeZ9f43HAodnXZjyuxTD8NW5
         EJNiGb6lnR+KCJc3rrZWee4KK1ve51y/K7Zl8/QkMMwWLmTEW1VxBDnkpdP7hkKlZJRz
         zHaIBQjXcT64oHcaE5C3+vdKCI2P65dA/5X3CgEn5aCVQxdh+kW7V1OWK2F27DbMf1jq
         uRSwjXaQ8FCIVzmJQycJHvMDVjjcZJZLSNo9tJU9wviRPhblDolVhP+FzBSMnZvvgpUS
         K47axkcrLkG8lf7nY3X8ikQelII+mGu+b4QcqgepwbFAtw78WT2/BmcQBwS1kbtP1Pdw
         pagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Cwxf7KEJLH0aH3P6Bk/LrPnmtc+hrdUpVwR6xUgQ4IQ=;
        b=aT+hcOzE6opaqs6KdWJTKZANsDyghBr1lyPSVPC+1PVGyTBLN+coAzSohz7OY6D9Ms
         Xw84Tnk5rnuRD2flhBKKJk/NhmbvHFUOXW0lnBsX2jYrSdVHk4IeP/aioFKTAfjvq53s
         anHFNZLub9oqk0JN9TTQj+hLdkSOZ48Mq689a6NmsQLFlbdl26FI7gQfEeAiZKY3kChV
         X4HcWyC53G02jNGvzxsIRZNHQOoG4L8iFmgS6Kwx2IUJPuAh1KsBhBRItEAvTv29ZMCX
         ykup1MM/PdgAXWbcXE5BDqmfy6i4GOEuvCQtYqieRPggldXma3vXJ4jt34Kfx0cx/vZS
         nFDQ==
X-Gm-Message-State: AOAM531Rf1xC8qqD6uDu9FYMBS0pwebqwzG8e6xOxgNJ9jcU6RmmXuZE
        7lsMBaEGDnSLfQlgRlNrfBXosw==
X-Google-Smtp-Source: ABdhPJwnmCJQBIGBmtHW4MBoUCFtTNyBcPS3Eh6JmcXJfb/PX7fs8KDcUjsvkfXdsMpEeUnPU3Vebw==
X-Received: by 2002:a05:6214:15d0:: with SMTP id p16mr31133720qvz.21.1625766788233;
        Thu, 08 Jul 2021 10:53:08 -0700 (PDT)
Received: from iron-maiden.localnet (50-200-151-121-static.hfc.comcastbusiness.net. [50.200.151.121])
        by smtp.gmail.com with ESMTPSA id m189sm1278171qkd.107.2021.07.08.10.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 10:53:08 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     davem@davemloft.net, Joe Perches <joe@perches.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Subject: [PATCH net-next v2] drivers: net: Remove undefined XXXDEBUG on driver sb1000
Date:   Thu, 08 Jul 2021 13:53:07 -0400
Message-ID: <12806725.dW097sEU6C@iron-maiden>
Organization: Virginia Tech
In-Reply-To: <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
References: <1884900.usQuhbGJ8B@iron-maiden> <5183009.Sb9uPGUboI@iron-maiden> <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XXXDEBUG isn't defined anywhere so these can be deleted from this file.

Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
---
 drivers/net/sb1000.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index e88af978f63c..a7a6bd7ef015 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -759,9 +759,6 @@ sb1000_rx(struct net_device *dev)
 	ioaddr = dev->base_addr;
 
 	insw(ioaddr, (unsigned short*) st, 1);
-#ifdef XXXDEBUG
-printk("cm0: received: %02x %02x\n", st[0], st[1]);
-#endif /* XXXDEBUG */
 	lp->rx_frames++;
 
 	/* decide if it is a good or bad frame */
@@ -804,9 +801,6 @@ printk("cm0: received: %02x %02x\n", st[0], st[1]);
 	if (st[0] & 0x40) {
 		/* get data length */
 		insw(ioaddr, buffer, NewDatagramHeaderSize / 2);
-#ifdef XXXDEBUG
-printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
-#endif /* XXXDEBUG */
 		if (buffer[0] != NewDatagramHeaderSkip) {
 			if (sb1000_debug > 1)
 				printk(KERN_WARNING "%s: new datagram header skip error: "
-- 
2.25.1



