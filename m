Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8905470B29
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243348AbhLJUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243382AbhLJUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639166204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IAtNdaPKfQErP2uprt6b6x17dyKkU9ocY/5wmrkDVtA=;
        b=FBne4AUbCBx96aQZTNN0U5TH58AbOz17Ie1DZIm0eECl8mMe/zckSC21Z9StM4i//Jc0HB
        3L663lULxqi7OhBxxmHyLZ0lHz38rEAt2NNdXP+y4zQNcrvt2U5NS1YLvQGYH/KG56FxDn
        8qwVOhQcHXPA1LBUUj75tVnvIzlXZw0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-S0voRJvFOhure_W1Pff8Zw-1; Fri, 10 Dec 2021 14:56:43 -0500
X-MC-Unique: S0voRJvFOhure_W1Pff8Zw-1
Received: by mail-wm1-f69.google.com with SMTP id y141-20020a1c7d93000000b0033c2ae3583fso5442089wmc.5
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:56:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IAtNdaPKfQErP2uprt6b6x17dyKkU9ocY/5wmrkDVtA=;
        b=zwkwuLQUp7KW/7TjYSy8AzKcPmvWeZOpNiIHM9nuJrSDgaq8uaW+ZftcoIW32MLU65
         TQ26fZbTvSozFAsEmF190H6sVBhdd/me1XwlKLIZ+grkICVPslXurK72k3mCRRrmDMdd
         5NtGLcVZ144L3NyW5hGA80VXjmN6md7sMxPuJjfddyj3cdDpJTow0f4y4u/R5pfrLTm0
         5I10Od9RayoFH5h38O6DlF/X2H58I39Lu9Pmmup2dxDvlUVhHLlSvo2oJtyG+PSdIVBY
         FwcipVNJCbGo1anqMfYmr7S3P9z+VBRQt5RdWeO3g0mR37RItOvlS+8XTW56k56nR+w8
         LbTA==
X-Gm-Message-State: AOAM533FXgG5G60OJywOrWKhalWVxss0KBAhwE4tobECZUbpnuFHhePI
        5QX3NCa/koSLd4laqRdFoLcEULjg2tRmSM5zAvXAOc0h7p1RRmwJdbVuJk4XNLOSZgYhNk6zqRE
        ET9CMSoBjL6Dw+ZEJ
X-Received: by 2002:a5d:69ce:: with SMTP id s14mr16437528wrw.25.1639166201712;
        Fri, 10 Dec 2021 11:56:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQLpYeSNxImb969v4lGIeL8tEo4j5rMDdOAk9IAbt8wGC+AQiamUhlN4vDrwMWu3IwnE56Fw==
X-Received: by 2002:a5d:69ce:: with SMTP id s14mr16437514wrw.25.1639166201566;
        Fri, 10 Dec 2021 11:56:41 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h15sm340280wrt.104.2021.12.10.11.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:56:41 -0800 (PST)
Date:   Fri, 10 Dec 2021 20:56:39 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 2/2] bareudp: Move definition of struct bareudp_conf
 to bareudp.c
Message-ID: <55d093863056201b96c08cc95dee8cf50886555e.1639166064.git.gnault@redhat.com>
References: <cover.1639166064.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1639166064.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This structure is used only in bareudp.c.

While there, adjust include files: we need netdevice.h, not skbuff.h.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 7 +++++++
 include/net/bareudp.h | 9 +--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index fb71a0753385..f80330361399 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -38,6 +38,13 @@ struct bareudp_net {
 	struct list_head        bareudp_list;
 };
 
+struct bareudp_conf {
+	__be16 ethertype;
+	__be16 port;
+	u16 sport_min;
+	bool multi_proto_mode;
+};
+
 /* Pseudo network device */
 struct bareudp_dev {
 	struct net         *net;        /* netns for packet i/o */
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index 8f07a91e0f25..17610c8d6361 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -3,17 +3,10 @@
 #ifndef __NET_BAREUDP_H
 #define __NET_BAREUDP_H
 
+#include <linux/netdevice.h>
 #include <linux/types.h>
-#include <linux/skbuff.h>
 #include <net/rtnetlink.h>
 
-struct bareudp_conf {
-	__be16 ethertype;
-	__be16 port;
-	u16 sport_min;
-	bool multi_proto_mode;
-};
-
 static inline bool netif_is_bareudp(const struct net_device *dev)
 {
 	return dev->rtnl_link_ops &&
-- 
2.21.3

