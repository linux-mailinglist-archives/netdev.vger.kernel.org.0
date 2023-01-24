Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06558678E2C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjAXCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjAXCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:20 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F3C1E286
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:12 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id m26so2345652qtp.9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=JEbO0L6QmkJ84uRIJyJmGcSxtLuSNQ+XTahlXJ2le+LybaCgUEuXuY5Lm2RE6bJGbX
         myeenra7wpnH/Ym4moXjnaJ7L5zOC8JZ9ikIHqJN6vT8oH2JWprbJz4lmYPfbLervY4S
         8u0MTA2n3KZo80Bbz8+vXx/zgRw9i0U49cnJp40hKQV6pLfiy7lmysm7r3UtOBGX+C0v
         eEakUBhNzAsNUjtdwXzg3xgWlNymB+cAtLZ4xTk/NMisHiajuXhdKx2jv8F0sG1ChqGw
         IC0sBi5XWM3PWJUM7CMR/++COaaOV6uo0od1TDse8nMoYyAIl7rgEVZ3lapDsqXHigsB
         A+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=m+xla9SVCVKrQ4G0a+oNHMLFAV3Wo17mxeiCkgxb6Ph5y0nreC/YUr6MuYE3Q2pJFk
         m6jHg6j3mXwHL7EW8vZJy384efVE6BRqySo8hQSQvOyDwvI5qMk3T9DJD/MZGXGWsYo5
         a9WU1zYxOHPgL2uQc3llAw6zz1lx4Y8lOekWdDWOhFTqOLCrujUl8LOsusEPtWFDwEcq
         BvsmitLVFxpf9NtSsWoTqSZyk5X45DFGzY89xbULBRj5GmieDczpMVrZnaeOCfGZ5wuS
         fjTUQbiC6x5h/W5hIm0Ptr4/luCRASlOi4D0D5JguDLL/y/A/b9kI65/UdxnByPKgu24
         2C2Q==
X-Gm-Message-State: AFqh2kqEuIAASZNbJlItpunHlDWQGELwe4I8oyx206yHmN2rhqeKkHbl
        prNNWJeygkIW5WyosYwwQByqQLKzd8tvtw==
X-Google-Smtp-Source: AMrXdXvDvU2eW2bO3+H9ANDtSxOcMEFLLTI1c7jxZfxQcFd8JQnAkchM9pep1T/Hlw2pjcbd5hxNyw==
X-Received: by 2002:ac8:70d5:0:b0:3ad:903d:3ed4 with SMTP id g21-20020ac870d5000000b003ad903d3ed4mr34600294qtp.59.1674526811290;
        Mon, 23 Jan 2023 18:20:11 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:11 -0800 (PST)
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
Subject: [PATCHv2 net-next 04/10] net: sched: use skb_ip_totlen and iph_totlen
Date:   Mon, 23 Jan 2023 21:19:58 -0500
Message-Id: <9f5bfbbe60dc9a7a70eceb76350de0c25b3bda09.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
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

There are 1 action and 1 qdisc that may process IPv4 TCP GSO packets
and access iph->tot_len, replace them with skb_ip_totlen() and
iph_totlen() accordingly.

Note that we don't need to replace the one in tcf_csum_ipv4(), as it
will return for TCP GSO packets in tcf_csum_ipv4_tcp().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c   | 2 +-
 net/sched/sch_cake.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..d68bb5dbf0dc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -707,7 +707,7 @@ static int tcf_ct_skb_network_trim(struct sk_buff *skb, int family)
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
 		len = sizeof(struct ipv6hdr)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 3ed0c3342189..7970217b565a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1209,7 +1209,7 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 			    iph_check->daddr != iph->daddr)
 				continue;
 
-			seglen = ntohs(iph_check->tot_len) -
+			seglen = iph_totlen(skb, iph_check) -
 				       (4 * iph_check->ihl);
 		} else if (iph_check->version == 6) {
 			ipv6h = (struct ipv6hdr *)iph;
-- 
2.31.1

