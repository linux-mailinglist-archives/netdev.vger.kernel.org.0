Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21820989D
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 04:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389514AbgFYCt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 22:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389357AbgFYCt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 22:49:57 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35ABC061573;
        Wed, 24 Jun 2020 19:49:55 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c30so153740qka.10;
        Wed, 24 Jun 2020 19:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=5lXjeiOsBG8uhpS7ADjeldJYydP2WlIiNtg79CXwmCw=;
        b=qX/ZX608fv7NpAvxxHzMOLRstQFILAXA3k/9MGX52siF/ZeawE2D1ZvM8e4I7qYTl9
         skx6mJ2pWPpRAXAucnpTWkcTEav0gMaXYK/h1ro1UXLv1F7GHw7diX/LPMlEno6y5NOM
         W1BKa8cW43b1HXkxWC01Pcdt2d1icUI5qCOpWUOD3yj51PFX2tTjy7Sz7iIGCIH9/PhH
         FTsfF14KjjPWrp2xm5zd+w21ax3vzIpelIQghr71b3Lwmf23xZ8hTyehaP4z4/xw7Ezl
         4S4nk+z7w/Egea/zL94vnRM5dJfcGk+iwoxQhUVmucOta1jBcyWcLblc+QOo1/+ra5WJ
         Oh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=5lXjeiOsBG8uhpS7ADjeldJYydP2WlIiNtg79CXwmCw=;
        b=CsQ2YRTbjuTnDAmDTaLbITM4slu4DA7eRvrPeODrwKoP5qNNJZdBFMYN+vWcQsbV4E
         t09sZW1Z9yDZgTQK4hCZd+4bnxY0EXSXpKhm+y/px3Xk8G1Odx+fvJl0kJYXrUP/KwH5
         r4RnfDiPxEP8NDyXe0Ho+tT7rEutFxmF/OhjXA3pY/Po8T+vR2xw0xHbSzAnqjwyVK4y
         mlN7mgxfL2/xLj1SLEsLcSq9HZgmmQWqdPSrBH25Mre/M/MMRu2V0wY8eamBwdlwFdC0
         Or43GtF9aplgmAuPOtOvRyUmNmv6BGYHNUoi1FLmbIfzdGqiaT+QArDous/gJ+4RKXB7
         +eaA==
X-Gm-Message-State: AOAM532OSshGZKwWxUG1xCvxE0i1nsjNKQ/2Z6bbQmWXYi5aWyCAUJB/
        wy/Gh2hhG3RNBPZr4seVClc=
X-Google-Smtp-Source: ABdhPJz9Kir3cc0loPW9ZyiKJcJAxyg/+Y2eCStO0p4ztcdGUzkkew0qG4pZb4iIqxqtlqUQBJQWNg==
X-Received: by 2002:ae9:f40b:: with SMTP id y11mr28509038qkl.107.1593053394833;
        Wed, 24 Jun 2020 19:49:54 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b4f5:b2c7:27bb:8a39])
        by smtp.googlemail.com with ESMTPSA id v69sm4744823qkb.96.2020.06.24.19.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:49:54 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] Remove redundant null check in rt_mt6
Date:   Wed, 24 Jun 2020 22:49:48 -0400
Message-Id: <20200625024949.3963-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rh cannot be NULL here since its already checked above
assignment and is being dereferenced before. Remove the
redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/netfilter/ip6t_rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index f633dc84ca3f..733c83d38b30 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -89,8 +89,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((rtinfo->flags & IP6T_RT_RES) &&
 		   (((const struct rt0_hdr *)rh)->reserved)));
 
-	ret = (rh != NULL) &&
-	      (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
 	      (!(rtinfo->flags & IP6T_RT_LEN) ||
-- 
2.17.1

