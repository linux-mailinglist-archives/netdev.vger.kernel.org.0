Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A853967EA2F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbjA0QAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjA0QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:06 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34B97B40C
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:03 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id x5so4358483qti.3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=p5WBTbSkUIO8MH1J5V29oBhslUnc+3cM6mJhV2w/sKXaxhtFGXR7CCAEFda9n+WuJR
         qKy+kyyCS53/GjxaPGSXFq8jYHWEN+c1CxKD4N5w9YepGQkiWm0ALbT1Pixkinn/e/OV
         7YKLGjE/L93bPno/klQeMnU6Wq8kRYQpmyRN/zOk+S2bJMGSgEpp+9kSLRG9XAzhCWy6
         AWw8PuzHmrHHRl91pzBcC11zb4Iq+3XsMTuglJGTSVb9NGo4yyYFYFJjfaItRyV6nKnX
         7kW/uuqQgVuKZ8KDgCVBP16H09DbiWUtya6LJ2YqjLsjJK4HGKJlmDT4TBAuz9QmHD1u
         C/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV8oKg/2RyjtLIY7E/4LxV+Y00Cwz/EH5dgxKXOqfWQ=;
        b=cLMyCXdlLlg0TZ25nEisLp141DxLhLNy3EL2UvSqTqQ33G+fzHW3m/kyDt1xwo+Nqr
         i5ULebP5UBe9fr8exFQ1hDFWgij3TYnX9hdIeyxrFNRy4YEY6gxfzyVqKR3sD5Yy1dEe
         p70SQiHzQYjh/8v9e9BGZSXi8zu/sMaSj8+4emDMJvSk3TQkb2IWfH7aftito7YyoFrd
         vEHPqc+wcJNHZ/lEMpJkuErIxCLYifjFXSsPiZPJBv8gVdzUq3D+BHyU7aXQP4dy8+aY
         Wtkf7dihA6o1tHG4KJT1aEDIeMgeQ8AY+ML+W0bDrG7PaZfce3nrtSVO+1yWa9l6Tgx6
         ZzGQ==
X-Gm-Message-State: AFqh2krfBffhMuMb+dwXQE8g6w3PSJMVEHrRVdANUfjgcrrlB6bqRryC
        a8NmDLoPeTNHg7Hq/5nXfi56f7xtojOPCQ==
X-Google-Smtp-Source: AMrXdXt2Km6nxtyMoYV+b6VzlTHHS3lRImsBYNJ2Iac4VymkpZT+mOotPjf2KhZVOtskUGWpV53EaA==
X-Received: by 2002:a05:622a:5917:b0:3b6:2c11:ec76 with SMTP id ga23-20020a05622a591700b003b62c11ec76mr65480788qtb.52.1674835203230;
        Fri, 27 Jan 2023 08:00:03 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:02 -0800 (PST)
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
Subject: [PATCHv3 net-next 04/10] net: sched: use skb_ip_totlen and iph_totlen
Date:   Fri, 27 Jan 2023 10:59:50 -0500
Message-Id: <5f3d4ec30f3ae239f24bd05d7fc495a794ef42f2.1674835106.git.lucien.xin@gmail.com>
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

