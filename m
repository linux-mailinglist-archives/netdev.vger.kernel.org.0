Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47E470B28
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbhLJUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234222AbhLJUAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639166200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yXvAR6cl/lyPXT2PTp3HC1gTL6/TDYTyWxTK228C0lI=;
        b=DA8fbxXDs59UKHp0IPHpCvuQqEne+Qf1bRSkOipm2S1tQrNy8FwMVYK5OT6iLyTTYSLjVF
        xdvR0FvkL8aoNJ4vkWRYh/L3Fr3nl11aXmlxlh9HExlfcMbVxrKuxRRKKl0zOWFlyE4pY7
        gtAaE5t6Uijjj0KXKa+c150/E0RWE7o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-5ocOjPxDOL62HKsSgizNNA-1; Fri, 10 Dec 2021 14:56:40 -0500
X-MC-Unique: 5ocOjPxDOL62HKsSgizNNA-1
Received: by mail-wr1-f72.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so2701340wro.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:56:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXvAR6cl/lyPXT2PTp3HC1gTL6/TDYTyWxTK228C0lI=;
        b=eXcDWeVg/mNMZWHlIpzNyunygnvKOYexESq3C3/Ai3qOWRBbg03P3+SocqDFiw+DgB
         tlAal7B/MPbXxBHnFGn4AS7HhqcpbaZE8zURK8MCHaIXJhcGk9pvEDMLoAr7xoWf/1+c
         ykRj1erm08zBkhCfixRXozey1NA6IJh6lt00QTdU/6awC/puknzAKYbwUo0tt4XSAp74
         TESCJq8cwzf55GvYOCKxph3AczGDFqD1Ms+Kby5bgE0smYdDA7HTwouLsbCof+CXJ0zo
         Nnlqa0xEO29ZJfaxFcCJh7gHy5HQv6EH+mVqkAW834bqHprTarTSH5DquLVKSP/rNhlY
         aLLg==
X-Gm-Message-State: AOAM531tbuKu9z8xY6FXXHp9qYW2W4NPL6S8jk6g+ZiGu9L9u0qWxIft
        J9OASxeJ1tGZYJyqNPe/wDIqH5DVNrA977fTt47WD+aenldKvmQFmHbagr6SYbcp0rOFtr/Jxm1
        Rtt3RTirf6eoX/EhO
X-Received: by 2002:a1c:2047:: with SMTP id g68mr19943982wmg.181.1639166198655;
        Fri, 10 Dec 2021 11:56:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFnYtVjMhk6OyVoPiz+z17hs2upLK7r+SImcO36EalRMu5GHOOTSJVkp4olgvGgjh3yGu4jQ==
X-Received: by 2002:a1c:2047:: with SMTP id g68mr19943970wmg.181.1639166198524;
        Fri, 10 Dec 2021 11:56:38 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p13sm12611182wmi.0.2021.12.10.11.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:56:38 -0800 (PST)
Date:   Fri, 10 Dec 2021 20:56:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 1/2] bareudp: Remove bareudp_dev_create()
Message-ID: <dd676419694f4a0ede3e53460d998b525f29c333.1639166064.git.gnault@redhat.com>
References: <cover.1639166064.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1639166064.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no user for this function.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 34 ----------------------------------
 include/net/bareudp.h |  4 ----
 2 files changed, 38 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index edffc3489a12..fb71a0753385 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -721,40 +721,6 @@ static struct rtnl_link_ops bareudp_link_ops __read_mostly = {
 	.fill_info      = bareudp_fill_info,
 };
 
-struct net_device *bareudp_dev_create(struct net *net, const char *name,
-				      u8 name_assign_type,
-				      struct bareudp_conf *conf)
-{
-	struct nlattr *tb[IFLA_MAX + 1];
-	struct net_device *dev;
-	int err;
-
-	memset(tb, 0, sizeof(tb));
-	dev = rtnl_create_link(net, name, name_assign_type,
-			       &bareudp_link_ops, tb, NULL);
-	if (IS_ERR(dev))
-		return dev;
-
-	err = bareudp_configure(net, dev, conf);
-	if (err) {
-		free_netdev(dev);
-		return ERR_PTR(err);
-	}
-	err = dev_set_mtu(dev, IP_MAX_MTU - BAREUDP_BASE_HLEN);
-	if (err)
-		goto err;
-
-	err = rtnl_configure_link(dev, NULL);
-	if (err < 0)
-		goto err;
-
-	return dev;
-err:
-	bareudp_dellink(dev, NULL);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL_GPL(bareudp_dev_create);
-
 static __net_init int bareudp_init_net(struct net *net)
 {
 	struct bareudp_net *bn = net_generic(net, bareudp_net_id);
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index dc65a0d71d9b..8f07a91e0f25 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -14,10 +14,6 @@ struct bareudp_conf {
 	bool multi_proto_mode;
 };
 
-struct net_device *bareudp_dev_create(struct net *net, const char *name,
-				      u8 name_assign_type,
-				      struct bareudp_conf *info);
-
 static inline bool netif_is_bareudp(const struct net_device *dev)
 {
 	return dev->rtnl_link_ops &&
-- 
2.21.3

