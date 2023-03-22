Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7671D6C5A81
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCVXfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCVXfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:35:46 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D7E234FB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 16:35:44 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c19so24796267qtn.13
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 16:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679528143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1TcgHZ2xQVnxuAiwBC4tGBAmL/RkXYQSNK6o2LGLSpU=;
        b=dXeEqPNZUqk18Xxz2OqUsTQDD178eeCo+mGCLV2B7t/Sr27amN0Ob7YX2R2J9kkcU5
         mcmb1KBXepJMtyMx++g459eSV90zQ1QGRKylgYpR9ygFpcMyIwn2okFOm8864Yk4n/7r
         eI7VAU1fqAxj4Zj7eoDl9vDiXDmXr+tZjeamx7mbZdGLSCryQxxXfi7XfJitXXby/bOO
         wJlXBCUYcROubkJGs9ENn3UTaO56HwOpZy/CLtcIhSL4tkYbMsUYGd9oXdpSjtxXdYSK
         pw8JnJhcTIQ3NRo7keectYgtqwn/c4kYEQuwW9zl1Wa4y9PusRFkKqO3C5DcETEj4q5u
         5jwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679528143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1TcgHZ2xQVnxuAiwBC4tGBAmL/RkXYQSNK6o2LGLSpU=;
        b=vUC8yd7QLV8Q2QFOsiKvagxiJ+Y9wBQWn6DL1fYB6gJq0R0f7SwzY4vxtTu+3ZgNCb
         j6/cYFCF93uvvr9PqtNR355+r4WLs1VJtbccPqz3csE+ihYNL92+Fs9p+fK/GFtTt0fD
         IDTbKtvQWLrhu1EKk4wYMFuvXUoEy56eMRleP9g6+HT9+DamlhZ/plS3zcxHwEuchWoA
         rsCk1dyIWLAFZg7HZUinR7vTsHOc3XZZM4sJ9pzoYa8jK6GzJjgp/PwXqeP6etSK9/bD
         sFPSSphHPeNUofRMZt4yCmk32nUQLYTwyp7rT9isC/jO2V/Aq6hjrfdAUPPnDQegVemc
         hxEg==
X-Gm-Message-State: AO0yUKVLYU8IVPiaNewPkLu4KxXui5nZUxX4WLJDKtGZSIicOPFySbrE
        YxUBK2JaNOZWVBedQ15d+XU04rAvVshuvw==
X-Google-Smtp-Source: AK7set8cLenHFWTrkzvLHtm4oku88iesDXVOqAWXYGMhnnc29RsjuB/GQueZV/iy+majzpe8zc/FCw==
X-Received: by 2002:ac8:5cc4:0:b0:3b8:6db0:7565 with SMTP id s4-20020ac85cc4000000b003b86db07565mr9881751qta.11.1679528143452;
        Wed, 22 Mar 2023 16:35:43 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 69-20020a370c48000000b00746777fd176sm5834205qkm.26.2023.03.22.16.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 16:35:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] ipv6: prevent router_solicitations for team port
Date:   Wed, 22 Mar 2023 19:35:41 -0400
Message-Id: <7c052c3bdf8c1ac48833ace66725adf1f9794711.1679528141.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue fixed for bonding in commit c2edacf80e15 ("bonding / ipv6: no
addrconf for slaves separately from master") also exists in team driver.
However, we can't just disable ipv6 addrconf for team ports, as 'teamd'
will need it when nsns_ping watch is used in the user space.

Instead of preventing ipv6 addrconf, this patch only prevents RS packets
for team ports, as it did in commit b52e1cce31ca ("ipv6: Don't send rs
packets to the interface of ARPHRD_TUNNEL").

Note that we do not prevent DAD packets, to avoid the changes getting
intricate / hacky. Also, usually sysctl dad_transmits is set to 1 and
only 1 DAD packet will be sent, and by now no libteam user complains
about DAD packets on team ports, unlike RS packets.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 31e0097878c5..3797917237d0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4223,7 +4223,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
 		  (dev->flags & IFF_LOOPBACK) == 0 &&
-		  (dev->type != ARPHRD_TUNNEL);
+		  (dev->type != ARPHRD_TUNNEL) &&
+		  !netif_is_team_port(dev);
 	read_unlock_bh(&ifp->idev->lock);
 
 	/* While dad is in progress mld report's source address is in6_addrany.
-- 
2.39.1

