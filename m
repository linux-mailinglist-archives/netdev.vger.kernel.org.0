Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95A2400B9
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 03:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHJBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 21:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgHJBvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 21:51:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718D9C061756;
        Sun,  9 Aug 2020 18:51:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so4051883pgf.0;
        Sun, 09 Aug 2020 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=HVElGSlwlATYgy539/6WzioP4UyRz/qtpYOyAnLXtrM=;
        b=qZRvWI55Nf+L8hoMF+w0JtC8hOskVkbBTTBz9U4OFlN3CUWlg3E97c4OKka25dv1ed
         wllkw1Ldka1fA3zMgriTCNjotAdi2JGgdqbugeUlrEpuSpsMjyygBpUJPA8wN2fghoRb
         ZEbjjkTcLoDzG4Y+GI9qXlHTslDZSpNYwHNqlCBHm+y/gsITbGlon48ICQ3ljw1zMRc/
         GUnycfNAAcs/swOXzQjfGH7OwV8QmXKSW/EhpN1UFKl6dHieFXd8TG2mcSI5mF0EqgYT
         HbyfKLObMwZhc6hshprcfOIN/Dn78MykPrOELDXY3lv528G8hUFQ5+gQSGEMP7ozqw10
         JiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=HVElGSlwlATYgy539/6WzioP4UyRz/qtpYOyAnLXtrM=;
        b=IgjAAytVyBhvOI4rnZ055DTxJz0SpO7puqK2OW0EF0uBYWsDivYCqttWsIShwXbyqQ
         yT0SQQ1Zq0nKeya5A+L2Geda6QIMpe0TqSwYxFsSPbWI/cfCT7tugItW88IYG7K1rJ7x
         pYEKGewfeQbUvE/PWlbR5K+DJeNuRcCgNmTlj+OfWHSRSH3UOHIxrHACZBIfD0aziTUK
         rok5SIiihDAKRA4wV9vLx8/Eg3pgzrPXLnbOP62maUgoIPjabNadRzUQYnb9yWNo32vg
         oPwHvUJqF326U4t4VfMJv4G6I7Cr0WV/01EWVqRKIgzCsCvuAN0bUs2Wuqlh3FXHM8oy
         +6bg==
X-Gm-Message-State: AOAM5333GC5UksDGZ28T4vbtpcSf8NMk9Gu9U2D2fJnr5xDKWkSLdnpk
        erhfw0VrB55BLs+7Bja7ed5PPeqi
X-Google-Smtp-Source: ABdhPJxLRTecHQQbovtcVyeRVmloLQY2UOecijW08IeMzc4QRQwoEc/GU972KzWaHawkpdWK/m/btw==
X-Received: by 2002:a65:63c8:: with SMTP id n8mr20029351pgv.232.1597024264317;
        Sun, 09 Aug 2020 18:51:04 -0700 (PDT)
Received: from oppo (69-172-89-151.static.imsbiz.com. [69.172.89.151])
        by smtp.gmail.com with ESMTPSA id a7sm10651374pfd.194.2020.08.09.18.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2020 18:51:03 -0700 (PDT)
Date:   Mon, 10 Aug 2020 09:51:00 +0800
From:   Qingyu Li <ieatmuttonchuan@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/nfc/rawsock.c: add CAP_NET_RAW check.
Message-ID: <20200810015100.GA11939@oppo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a raw AF_NFC socket, CAP_NET_RAW needs to be checked first.

Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>
---
 net/nfc/rawsock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index ba5ffd3badd3..b5c867fe3232 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -332,10 +332,13 @@ static int rawsock_create(struct net *net, struct socket *sock,
 	if ((sock->type != SOCK_SEQPACKET) && (sock->type != SOCK_RAW))
 		return -ESOCKTNOSUPPORT;
 
-	if (sock->type == SOCK_RAW)
+	if (sock->type == SOCK_RAW) {
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
-	else
+	} else {
 		sock->ops = &rawsock_ops;
+	}
 
 	sk = sk_alloc(net, PF_NFC, GFP_ATOMIC, nfc_proto->proto, kern);
 	if (!sk)
-- 
2.17.1

