Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53736AF7AB
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjCGVbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCGVbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:37 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278D35849A;
        Tue,  7 Mar 2023 13:31:36 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id ne1so9875744qvb.9;
        Tue, 07 Mar 2023 13:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uR5PleXq3LjItpttm0fNa6NbIkqQPJZjrKTMGwB87kI=;
        b=NELzoh+VxKU1GW1YiHoFgVpLaf4QF/XIJn5RPw6pbcMhUB9t1yXmpO4oHqd3ivg0Pd
         PqDStIrJSblmG+LyPtp8nzA54a34xfj4jGib0KAqNsM2ROqB5F41S7cMvvL9Q+DVlI/n
         JZ9hKto14a8B23LCvPb7gngXcjDqcWm5eAxg4pmgMhqIqsHr2iRV/M9cdk8AOk1LoQzX
         UjYr1tCrIsURiGvIVKPGAR/fc6HDSfMuy8Xj6PVp2VL/baMRJrP1JuFOT58VLStCXNmg
         Pr0c+XbIPENdegaflVETd3PofTuiNXdvc87/pqTaEX6HXZcoHVxktDR43ZAFKqbi0Pfc
         qYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uR5PleXq3LjItpttm0fNa6NbIkqQPJZjrKTMGwB87kI=;
        b=HtQ2xZWyCCnOZEKV6OniUbKZIAXIpczhWjJkBl6iAZgEEiOvUkrShv0q6XQIP+hC2b
         IINmERQNKKFQh8VQ0bc93hqwI/KLIsQBO6zwtjGrpGDClEGfj3D2ugC01qBiTTxk0LJY
         N930COaeDHJ36NnLQGe+tcu7aYm2VLUtTCHQcS3ijgbErLUy/1/FK7vAEAe+cbtoNS9o
         LCklmxMvjlvXq9b9ZIk6KHLrRAQGFTK2IcaW3EhLtudRInDncqFBr+yRpZbTlAJoaSrx
         OWzlfvRLOZpdxRz85FcicvAVOe1huwMeARDPuwMdhcGjR5sQ7/Y805RoWxhZP+xsHtsS
         EV9A==
X-Gm-Message-State: AO0yUKWIlMBMeV87vNDsEtg/soBB2cMWJ12wN/zdFs7cF+Ijrvd0FD2X
        IaiE/6JTrHdS0YN1Xdu85/vkmBmqRq8DXA==
X-Google-Smtp-Source: AK7set+qSLYW48OfgiFsnrkFXCbJKrevbDD9p/ZIaO8AU/oCYixzGkd1Qgh2BUPEM51jf5EGqnRL/Q==
X-Received: by 2002:a05:6214:c46:b0:56e:a756:912 with SMTP id r6-20020a0562140c4600b0056ea7560912mr24262145qvj.52.1678224695035;
        Tue, 07 Mar 2023 13:31:35 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:34 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 nf-next 1/6] netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
Date:   Tue,  7 Mar 2023 16:31:27 -0500
Message-Id: <1395e96f22b8eb3abb0593af644ac687ac746591.1678224658.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678224658.git.lucien.xin@gmail.com>
References: <cover.1678224658.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When checking Hop-by-hop option header, if the option data is in
nonlinear area, it should do pskb_may_pull instead of discarding
the skb as a bad IPv6 packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
---
 net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 6b07f30675bb..afd1c718b683 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -45,14 +45,18 @@
  */
 static int br_nf_check_hbh_len(struct sk_buff *skb)
 {
-	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
 	u32 pkt_len;
-	const unsigned char *nh = skb_network_header(skb);
-	int off = raw - nh;
-	int len = (raw[1] + 1) << 3;
 
-	if ((raw + len) - skb->data > skb_headlen(skb))
+	if (!pskb_may_pull(skb, off + 8))
 		goto bad;
+	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
+	len = (nh[1] + 1) << 3;
+
+	if (!pskb_may_pull(skb, off + len))
+		goto bad;
+	nh = skb_network_header(skb);
 
 	off += 2;
 	len -= 2;
-- 
2.39.1

