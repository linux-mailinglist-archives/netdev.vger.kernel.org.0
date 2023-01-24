Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4569678E2A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjAXCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjAXCUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:11 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8512ED71
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:11 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id e8so12065924qts.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=M5whCo+EorC2KH3+gyM9f5QtfjcgVf5eLMaExNLnhG/P97spEkrQJ5dBj7yeqjFaQe
         vBo3Rflwm4y7gHujuJmgrcz72XDsWyXB8e3xXMBnSZxBMqLOu9JsqMCseK6OEVfJr6lA
         vX1FSNfe/UGdUKNl/8I7y9lJjkgfBIsoj7MO0olDqpCAbZIhDdnMUqZQUnghjmekvsbL
         WJsltFC9PgE0lAE1Ev8sSaonWEdN3GSZ4eKqbMEDd3LvQKlOptoR6IpI/rgmNqy/8Jui
         Gr9a2fKPQ0ZXygwCu/cSDA/FBu9gPGgjKocQojdzyIAhBMIzvMd5kpCFT6nIXXu51TKD
         VtTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=IG0nMcSnT8W0gxx9sZ7HBAYMQmh542O8ndNwP1VmTXyiVCq/F3W3iQP7xi+tUWP5uD
         AyOI6JHQ/fJRpqx6blhpuPSlo/2TpIg6ygbJab18xbNfFs0GO4cDadTDJHOK9hVkG+WX
         YF6kqndk19CVubBUy7ZhuIC/daQhxfjbQgmvRhPcpdVw1qIxwFcdfb8m7VDH/jFQMjjR
         +Rx7/58jOh0yUx9R29SC2J0n9bM5/+RObT2vQ2UlVnbTuQPFBiii0JkLx2ZwWoglz87H
         ZYpH7VsK4djVyKLOzZ5IsRFBaELfvn+mrByDEh6znHdhUORK+t3wCdT1NxwadlWsbe4B
         Fy/A==
X-Gm-Message-State: AFqh2kr34vZejDEQjCmBFnOhZLd2c9gSsVGW19RY2OGoSh72jf3Rz2nl
        /bUQd5nUttRzdVIBIIDvxWk0dgj39iAtHw==
X-Google-Smtp-Source: AMrXdXtsDoTrZnS42k6nsxlRnLbyzvS4emJL3m13rqDagCWBeJP7vT/qbi/4B+mP4xDUUDnJFIqCag==
X-Received: by 2002:a05:622a:18a9:b0:3b6:9b37:e03d with SMTP id v41-20020a05622a18a900b003b69b37e03dmr28343167qtc.53.1674526810060;
        Mon, 23 Jan 2023 18:20:10 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:09 -0800 (PST)
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
Subject: [PATCHv2 net-next 03/10] openvswitch: use skb_ip_totlen in conntrack
Date:   Mon, 23 Jan 2023 21:19:57 -0500
Message-Id: <5ec147c1cd8737dc6ba78ef5e4bfd7bf3963611d.1674526718.git.lucien.xin@gmail.com>
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

