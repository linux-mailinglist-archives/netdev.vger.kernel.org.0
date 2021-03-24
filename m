Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235FC346FEE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 04:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhCXDJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 23:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbhCXDJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 23:09:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2997C061763;
        Tue, 23 Mar 2021 20:09:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c204so16313635pfc.4;
        Tue, 23 Mar 2021 20:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bc2FiSN+yOqigR65WiugdvNBgGNKbOFXdu0xvhGCgiU=;
        b=glIaeC3o5D3uBTZgI/0FaRKF2bFtqxK+BogpaZIexHo8GWltUWf1LfzXh0Ool6aH3/
         w0iadkkDMh2b6JYRQcvqKiGyo2UiOFHUXkZxcy8SDYL/Oo3Jz0tXoBEiu+btvDhg8tQV
         Nezriv83GvC+iH3zqyZqWNAR/DQWYd2MM+YYTp+gLsHkCPlx47Cn4Z1GexflUrQtpUWp
         WCuSkj/yRqMnK20j88BY7JK3aPeuaY2gQeGiMvLiHBIvG+Brho63jk2ghbf2xivE8pgc
         17nXSNwYj9sQ7yy0cejahKc2AV6Tqhd6eavHkb+FzpAT2qGqOn0gvL0GAPwkd4+jzI1r
         8D0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bc2FiSN+yOqigR65WiugdvNBgGNKbOFXdu0xvhGCgiU=;
        b=MY5nk4+fvY1TIPWN+IMH2eXMFzWA4OKAJVLBKSJtjrmJKdOhNwY6457YH511we7VYz
         YdF9eNo2JNP14FcTC4H2rzmIiyVM22DCfe1Kh96oF4McUKrMnopapkDVBN8GfzQXvbqV
         hFi9gHA0MsDQUx7bSjQU0nDR0q5heoQbBJuw3KyPCLe9R7vzhNTKKdYvUV8I9dNdgcvT
         s/ltRDZt8WlkO+oFk+LrAuJWYUiVGcpTfK2MI/8KHgxhrKeOdyBhapwBPR7w4UdOFM3R
         8FT63EsONwP7/eI6P9vsmJVv20/Yg1ViYq3d1qFGvgTcqgCu/aen+Slylkt5tl1s9yVG
         0pwA==
X-Gm-Message-State: AOAM531OwiIKkT5oTY9xpA2zG+fNpqvBXfKrUSDJUSJUm7W5Ql6tH9TV
        fgre7kwXsixGQVH96ckM+iNXuBrUIEOPLg==
X-Google-Smtp-Source: ABdhPJzAU8/k4Nd9+ELAZIA6CRnz4yDzsSZvcVlylYHWS1f2zbguh7J5yGx7G7OXd8Nezo6odSUEPQ==
X-Received: by 2002:aa7:9e43:0:b029:1f3:a2b3:d9fd with SMTP id z3-20020aa79e430000b02901f3a2b3d9fdmr1258739pfq.74.1616555372293;
        Tue, 23 Mar 2021 20:09:32 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id f6sm554966pfk.11.2021.03.23.20.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 20:09:31 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune@gmail.com, Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH 1/2] net: ipv4: route.c: add likely() statements
Date:   Wed, 24 Mar 2021 11:09:22 +0800
Message-Id: <20210324030923.17203-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add likely() statements in ipv4_confirm_neigh() for 'rt->rt_gw_family
== AF_INET'.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fa68c2612252..5762d9bc671c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 	struct net_device *dev = dst->dev;
 	const __be32 *pkey = daddr;
 
-	if (rt->rt_gw_family == AF_INET) {
+	if (likely(rt->rt_gw_family == AF_INET)) {
 		pkey = (const __be32 *)&rt->rt_gw4;
 	} else if (rt->rt_gw_family == AF_INET6) {
 		return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
-- 
2.29.0

