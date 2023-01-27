Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EDE67EA2D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbjA0QAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjA0QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:06 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E12486268
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:02 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v19so4329415qtq.13
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=qiKeqXjwPpwW1JVF88Ste6Pnpftt1spzfTCFWCrfYIfszzkSkPhlkzzPAw/QOo1bTN
         EHEcInvld4LEI9dzfUhaaA9lqC4j7B+apapvqsMNOrbxbt2Clmq6HqZiHQn5IqofAtMX
         UOB1hgDWLezIrcNifBsNPM7+xcu0+KM3lcmCyQS2eugPuoG5flWYHN/om2FHlec/PfNM
         6m5XxnlOCMgqWWmmNcnkfv8vsQCoiw/q057xIjCk2UX9megtIwHhHiMOjugahCO1y19R
         GC6zutREr06sX0vatmkrpudmAvlE3xtZP/KOvQGrdyaBfuM972Z3w0ClvzwW232i32yi
         LuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=TVtgvze/Z9VWlMaG3qlfgcDRO4WAQGPhAq5+s/wKW7dooyzGMd5AAtrMWiq8iIpVTl
         gA9Os/kudO9y6rnpHTNLoAm3yzIDJZWymNI1CDx0Ln47K8Fbz+TvrGHdxVzYSz413TbX
         6+4iD5slzypeKFiQUkcVkzO3Jfs9w4FI5zXG6sqFHlvOU6teyVAIhEFtHHAwRi+pN94f
         mi4b3xbmEA8ogYNnWdb8hqv6o89wTTnMiGWQ0l1ISWgr53HTOKfNvNm6CZ5J/nuW8KXS
         /jVpo+LDFUejlUj1lEeMKj63jvWJTLaE3tLMd2tNyfSGzT1CllE0bcMWbLnM+n+hldR5
         YnWA==
X-Gm-Message-State: AO0yUKWQWu3QRgPhtmADomdEYOvi1tBZ2GFKUxXTw4iz+UobUNp9sIX8
        gWn7+skIYjsHy8Wa8xZEIRVG3MbRSe7TGw==
X-Google-Smtp-Source: AK7set/dB5zjQgOckPD3E9XfGBUJMl3cKOwBWbL2Px8NIFKKvxGq2XBUc7yprWRcZjT9kBiCTDUGAQ==
X-Received: by 2002:a05:622a:11d6:b0:3b8:2175:fd06 with SMTP id n22-20020a05622a11d600b003b82175fd06mr5231342qtk.62.1674835202030;
        Fri, 27 Jan 2023 08:00:02 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:01 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv3 net-next 03/10] openvswitch: use skb_ip_totlen in conntrack
Date:   Fri, 27 Jan 2023 10:59:49 -0500
Message-Id: <297d80ee701093f58c340e88e6fb8d05fd0d2052.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

IPv4 GSO packets may get processed in ovs_skb_network_trim(),
and we need to use skb_ip_totlen() to get iph totlen.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c8b137649ca4..2172930b1f17 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1103,7 +1103,7 @@ static int ovs_skb_network_trim(struct sk_buff *skb)
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case htons(ETH_P_IPV6):
 		len = sizeof(struct ipv6hdr)
-- 
2.31.1

