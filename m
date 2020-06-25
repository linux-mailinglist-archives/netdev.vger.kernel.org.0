Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA3209898
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 04:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgFYCqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 22:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYCqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 22:46:12 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50566C061573;
        Wed, 24 Jun 2020 19:46:11 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v19so3513166qtq.10;
        Wed, 24 Jun 2020 19:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=cQpEhmFPDYIC8mHow/3VbX8CkkK2TboHR1C2syFtHGs=;
        b=TabtkjAEw+mPYUxy5YE0yd0B08a/Xj8LtVTOmbSl43x5K6ULaRgZhfqywSDGqW88OP
         CJ38ulDxKmymVU5sJmlKwF+kFe4+yBhvgjXckaB2XMBOiRG8M4TpqZYYhZDvwRDerWBh
         Viu0tWB3KmNolM7S8tE90tz6IhkaGfc6ZLb8r3DVSXJ8z5FSdGy9aF4wOwzJK3jIeUcF
         GsOBwujmN/BJMmNFFEQZ0lx3VbHONvGjn+Ezl6cfNPRvi6DKMYPKLf1uFXXXiP8vyz2t
         qW5ku2qFeLXIEnCcKDfuat2eBRJX0o2gVIslvZ+0yh0exrT99s81w3SGfQw6c9qpOffI
         54OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=cQpEhmFPDYIC8mHow/3VbX8CkkK2TboHR1C2syFtHGs=;
        b=FaWxbWQADronh6XXrZeyXwzVUBOrbDCNlQo1nY50+s5gU9IJ+EaKR+yc7DAM+AG2VW
         e7gjvB0D/5jfJ+0SMW0Q+jiFx42MJuxOpfR7Q+JyMIz9fJegqYL8HfR9v6xKM7d8Yitc
         DDE7cKyC2xsk6h7HkIrX8HhP6mD9F7U7W20BvxQlOGy4M3MPIf7TvmJbXstjl7K6pyYS
         8ymrIGYGVyvG2fLmr8Ic46l4znI9SET412dSAJrnwUpSDMzZcI3vD2YGID161UMAGgeZ
         pDy3ep/iZ99ybkqnLFQ0T6k3pd7nu8Ci6Nh2nIel9wYsmEtbXVJNt7e/WtQ08a928Zpu
         1c/w==
X-Gm-Message-State: AOAM532xaoYHw+YcaStAHTwdP0xxDhpKjZ1yvEzWYqly8MvLdl43+k4f
        Z36etvaYc+TaZcHm9amfxTg=
X-Google-Smtp-Source: ABdhPJxNn0AzNExJhT2K7CybQTpfKoFtIFgRBK0papWcKvhCdZCuN1h5oKAMtj5Hi/qx6fh5r7M9Qg==
X-Received: by 2002:ac8:1013:: with SMTP id z19mr29840585qti.130.1593053170544;
        Wed, 24 Jun 2020 19:46:10 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b4f5:b2c7:27bb:8a39])
        by smtp.googlemail.com with ESMTPSA id y54sm5240187qtj.28.2020.06.24.19.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:46:10 -0700 (PDT)
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
Subject: [PATCH] [net/ipv6] Remove redundant null check in hbh_mt6
Date:   Wed, 24 Jun 2020 22:46:04 -0400
Message-Id: <20200625024605.2881-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

oh cannot be NULL since its already checked above after
assignment and is being dereferenced before. Remove the
redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/netfilter/ip6t_hbh.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 467b2a86031b..e7a3fb9355ee 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -86,8 +86,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		  ((optinfo->hdrlen == hdrlen) ^
 		   !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
 
-	ret = (oh != NULL) &&
-	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	ret = (!(optinfo->flags & IP6T_OPTS_LEN) ||
 	       ((optinfo->hdrlen == hdrlen) ^
 		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
 
-- 
2.17.1

