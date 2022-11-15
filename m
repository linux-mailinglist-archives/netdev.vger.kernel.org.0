Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7000629E13
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiKOPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238464AbiKOPvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:05 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C29210565
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:01 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id z17so9712581qki.11
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNsIsgsiY9aSMzVAbHWx1gLoq3RWmANOWSvcUJFgLio=;
        b=V5bGokaeY96ku5yT5KwbgGIJNgAdpcRvS1vP5sS9YcOAhrxKhWP3fD2skwmoxsEsQ9
         Ey7pbZWXXjTVzGfQoqE7Bbqd+OYp4X1+A1yC8AJNXo0fNP4ZbXYv4WybkNbrjh7wrWp7
         VuCSjhnvVMtO/MGfRuFnmQzt7LlogqiGBt9uTIKgPScZWG0uUdGFgoTgJ5Y5XYxFqDAp
         sH1apzJPd2vfOFWqC/oR21WMf4GPtPb6M6S/Srg3V0hSkjt3EHswjyzAiRqAfbB9cA7w
         RFvdGEJpXB8sUsS8QNclK3slSlF57SphONWyvafFr9T/4ae84C5ObPuGkfhu6n1pxJId
         HGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNsIsgsiY9aSMzVAbHWx1gLoq3RWmANOWSvcUJFgLio=;
        b=XaLzMOSkiaRQ+sirbEWJxzFIAhYE+UiIdNlotexSp2AxZZbY0iSx497qDChqa3augb
         gvdlqiUl79G9h0xraezh27qr3F1GChA2bR/3NuYR2+DcB0wXukPKVMWxjW7D0J/W57wF
         nqrG88vvICD8iA5BgqUOQ4bGELPO5eA6uEkkgwrirrsVHZcjUvGhdB1cbVt9UYaEZFL7
         5DHBhRjndBUqhd+QFAWs0iBbZ9ebfygmpmGnNDNhc0BPSMc5lMJZPD1dfGMT4h6Bzf6T
         lzMmE2OCEtrLGIAQd3hr3J6POyDpbSl3HCVXQOTc6fyvUCLIYD6qeNMxTrnA0l5oO5hG
         cKvw==
X-Gm-Message-State: ANoB5pmLmtW7B/RBzXkmhT6d+obo5oJCWrWZRPWP+NjE1ZXuYODc6SD4
        eImyySbBawHh/o6VajpIgR5c8dM1dIycog==
X-Google-Smtp-Source: AA0mqf6yKbEBsHzn++92ogZNpe2DZX8s5dZ4raBdgFp6L7ZK2QUAsVTMK1pyI/YqCcY+VTXpaaSJ9Q==
X-Received: by 2002:a05:620a:1f9:b0:6fa:2240:7c02 with SMTP id x25-20020a05620a01f900b006fa22407c02mr16211292qkn.561.1668527460065;
        Tue, 15 Nov 2022 07:51:00 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006eeb3165554sm8244351qkp.19.2022.11.15.07.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:50:59 -0800 (PST)
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
Subject: [PATCH net-next 1/5] openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
Date:   Tue, 15 Nov 2022 10:50:53 -0500
Message-Id: <83692c116f1d5d5ee03ce8386b32cced78c9a022.1668527318.git.lucien.xin@gmail.com>
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

The calls to ovs_ct_nat_execute() are as below:

  ovs_ct_execute()
    ovs_ct_lookup()
      __ovs_ct_lookup()
        ovs_ct_nat()
          ovs_ct_nat_execute()
    ovs_ct_commit()
      __ovs_ct_lookup()
        ovs_ct_nat()
          ovs_ct_nat_execute()

and since skb_pull_rcsum() and skb_push_rcsum() are already
called in ovs_ct_execute(), there's no need to do it again
in ovs_ct_nat_execute().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4348321856af..4c5e5a6475af 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -735,10 +735,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      const struct nf_nat_range2 *range,
 			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
 {
-	int hooknum, nh_off, err = NF_ACCEPT;
-
-	nh_off = skb_network_offset(skb);
-	skb_pull_rcsum(skb, nh_off);
+	int hooknum, err = NF_ACCEPT;
 
 	/* See HOOK2MANIP(). */
 	if (maniptype == NF_NAT_MANIP_SRC)
@@ -755,7 +752,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   hooknum))
 				err = NF_DROP;
-			goto push;
+			goto out;
 		} else if (IS_ENABLED(CONFIG_IPV6) &&
 			   skb->protocol == htons(ETH_P_IPV6)) {
 			__be16 frag_off;
@@ -770,7 +767,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 								     hooknum,
 								     hdrlen))
 					err = NF_DROP;
-				goto push;
+				goto out;
 			}
 		}
 		/* Non-ICMP, fall thru to initialize if needed. */
@@ -788,7 +785,7 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 				? nf_nat_setup_info(ct, range, maniptype)
 				: nf_nat_alloc_null_binding(ct, hooknum);
 			if (err != NF_ACCEPT)
-				goto push;
+				goto out;
 		}
 		break;
 
@@ -798,13 +795,11 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 
 	default:
 		err = NF_DROP;
-		goto push;
+		goto out;
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
-push:
-	skb_push_rcsum(skb, nh_off);
-
+out:
 	/* Update the flow key if NAT successful. */
 	if (err == NF_ACCEPT)
 		ovs_nat_update_key(key, skb, maniptype);
-- 
2.31.1

