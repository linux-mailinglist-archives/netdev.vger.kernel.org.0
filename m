Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1D629E15
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbiKOPv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbiKOPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:06 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32E010CF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:04 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ml12so10079142qvb.0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftc4nyJPCQ5yv+ESZ/mwBO5w+pMaoMwclsSo3pRBP2Y=;
        b=LZeJCsribPeANSan0QrIQkXsX8a85sRH9RttUv/apw8/i3bKAi/BDMLN7FWXZ6v3B2
         0d8kpMCBR0GNLt7zWyIOy9UBAxSS2iY6QRnxYUcpnKUbmwJdrKkSTsaANF7bUW97FKgI
         ZMDlJ3Dz1lGjpk43xxJMrozSSRkxP66VCWy2crmQwrnxB2O8N9wK8tJWBx28idLcXFDU
         UEvYmeJ/z365uCV8avlQHSSoAj+WAKjL/TkZS/3LXAf0LNywgnTikxxhNBjE0YB15ckQ
         kDjkrk3qEzRj17fEQBhqsuLHQn5R/GKv/pkrohzffVKVZTkVJ4urN6LK1sw8Qvxwo6Yi
         Jj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ftc4nyJPCQ5yv+ESZ/mwBO5w+pMaoMwclsSo3pRBP2Y=;
        b=K+lEMhjU3W4ZeWslrFSJE12kIAUx7bciMUEf5LFac43+eG/rxsV5hnwKcpvlWowiNm
         QpdvQ1EmHGeVanXroEblse+wp3Fgi81I1HI0c5yhUi9pvWMXcir4lugOPF7qj+FNvQfz
         gY99Gp5lt44QMA57PrbkTC0j5xYPDXbDYbg4jRIhaytUxOC/pDF86qeHUQiTVfQhyAcZ
         wlAh3BMHaX6wg8tZ2LynESD/CzvPaQuJsXzyGZEi25Uz/N+AaMTyr9m6si+ORbB1F+Bt
         OSpgGmwswomQsaLQlRSjLASsRu8CVMf6cN8XON/gXg+3I/1LjOhn/dlxI5ixd2FOIZbB
         aW5w==
X-Gm-Message-State: ANoB5pkS3IscVOT6Z1AzjHVHnQ8A3ZNlm/AQnniut4FYbQ+o3DREdhqv
        mpMOLnna8U93muGH0JIOOqfKyOvR4JDu2w==
X-Google-Smtp-Source: AA0mqf4F41TxPxZha+8HTIZ0VpHGrvr6vK6P6wwwfHyc3Ye/ieD3L3CGapqz8NZYPhV1qr24BPNHSA==
X-Received: by 2002:a0c:fb07:0:b0:4b9:a12:1286 with SMTP id c7-20020a0cfb07000000b004b90a121286mr17256971qvp.50.1668527463678;
        Tue, 15 Nov 2022 07:51:03 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006eeb3165554sm8244351qkp.19.2022.11.15.07.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:51:03 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 4/5] net: sched: update the nat flag for icmp error packets in ct_nat_execute
Date:   Tue, 15 Nov 2022 10:50:56 -0500
Message-Id: <6d407551f0a1bb96a273299dbc2cd2657c160c82.1668527318.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668527318.git.lucien.xin@gmail.com>
References: <cover.1668527318.git.lucien.xin@gmail.com>
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

In ovs_ct_nat_execute(), the packet flow key nat flags are updated
when it processes ICMP(v6) error packets translation successfully.

In ct_nat_execute() when processing ICMP(v6) error packets translation
successfully, it should have done the same in ct_nat_execute() to set
post_ct_s/dnat flag, which will be used to update flow key nat flags
in OVS module later.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 8869b3ef6642..c7782c9a6ab6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -936,13 +936,13 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+out:
 	if (err == NF_ACCEPT) {
 		if (maniptype == NF_NAT_MANIP_SRC)
 			tc_skb_cb(skb)->post_ct_snat = 1;
 		if (maniptype == NF_NAT_MANIP_DST)
 			tc_skb_cb(skb)->post_ct_dnat = 1;
 	}
-out:
 	return err;
 }
 #endif /* CONFIG_NF_NAT */
-- 
2.31.1

