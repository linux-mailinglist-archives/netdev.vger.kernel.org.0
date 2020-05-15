Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A141D42FF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgEOBgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgEOBgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:36:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC30CC061A0C;
        Thu, 14 May 2020 18:36:11 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p21so213490pgm.13;
        Thu, 14 May 2020 18:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0VjQ+Ma3qI88glsLS8F0bIG67DtfNMG5fSLchrZlPkw=;
        b=BZH27tzHemzdhmeAt5qyR6/wV3Rep0NuG5yApKqgOQnaClXU3DcmTpxeToHmrIa15l
         e/VU6aF7VhSU4G6nrw4DsMvQvfQn5gePKL/mL5Ip1KjkVJequxf52sqv4NWsvQrlyzIl
         VQ8GsWnQ2KmNG4nUelqamCKaGM4nwe7OEROb4Mv33JGjGkhx/Ed70ZHgjJ2UAt3HbgWe
         gLdBaa0JYh2H8FCFSy8Q3WEBJ7mcUCNK81II+EB30V2TJ8KFGzjS98HFmUz0+cNkAmBM
         cuxIoNM2qoSTz/bTGviWjKAFqNQXMd2af7Xrp6THTo6nXJN9TexjHiE7l9BAYNLlpGpL
         0dkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0VjQ+Ma3qI88glsLS8F0bIG67DtfNMG5fSLchrZlPkw=;
        b=cJQx1RAZoznZUE6ejbNl7fo1/0PsBR730EKUdkZNhAqhl81rwqaXhO0yT2uZrdruz6
         zqL93cxbEYpuwyAZgb2Xo7JuqetynVLHk4GE1bHPN+t8hHPH8rLq6xl8Va51DNP5IqhQ
         9/vqXeltauQ1iMjBbF5jmQKRvFBb9Pq/UnMhmhuf8jurpppqosluFbV3e0cq00mU3jFC
         mrKDm2u9W3XPKFpaujCT1NprReQz7jEi+lPbXPja+n+BObTim5z9IJeflkEKM3iR5Qtx
         tQs5iGLZehvqkGZ9yDJ4VJhg9rVgTzJxUyTpHxMKfIvhyhMHO8G9KKNc6THE2uUNAkkb
         RXJQ==
X-Gm-Message-State: AOAM531oQopCifUVCbdgJeXsj/oS1mkG9bF0YLr3zdXrEe7PV3JCHpx+
        AhaqKLAI14yCP1boDLYl10vF/ZHnAwF4NQ==
X-Google-Smtp-Source: ABdhPJwCVmlezSMh86iw6O5zaChvYnG2ARTIL31CVxt25Oq99Z82FRfutcz2tDRog+5lMGN4YEQxKQ==
X-Received: by 2002:a63:482:: with SMTP id 124mr880335pge.169.1589506571419;
        Thu, 14 May 2020 18:36:11 -0700 (PDT)
Received: from T480s.vmware.com (toroon0411w-lp130-03-174-95-146-183.dsl.bell.ca. [174.95.146.183])
        by smtp.googlemail.com with ESMTPSA id e12sm364701pgi.40.2020.05.14.18.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 18:36:10 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     kim.andrewsy@gmail.com, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:IPVS),
        lvs-devel@vger.kernel.org (open list:IPVS),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] netfilter/ipvs: expire no destination UDP connections when expire_nodest_conn=1
Date:   Thu, 14 May 2020 21:35:56 -0400
Message-Id: <20200515013556.5582-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When expire_nodest_conn=1 and an IPVS destination is deleted, IPVS
doesn't expire connections with the IP_VS_CONN_F_ONE_PACKET flag set (any
UDP connection). If there are many UDP packets to a virtual server from a
single client and a destination is deleted, many packets are silently
dropped whenever an existing connection entry with the same source port
exists. This patch ensures IPVS also expires UDP connections when a
packet matches an existing connection with no destinations.

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..f0535586fe75 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2116,8 +2116,7 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 		else
 			ip_vs_conn_put(cp);
 
-		if (sysctl_expire_nodest_conn(ipvs) &&
-		    !(flags & IP_VS_CONN_F_ONE_PACKET)) {
+		if (sysctl_expire_nodest_conn(ipvs)) {
 			/* try to expire the connection immediately */
 			ip_vs_conn_expire_now(cp);
 		}
-- 
2.20.1

