Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95122634281
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiKVRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiKVRc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:28 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C46FBA3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:26 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id w9so9710548qtv.13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVIDfxCODPdx++YobuW8f3Hee3mDgW+C5XbR0XhhwoY=;
        b=V41mlPDKnbKDK3vpxtYJRktBWm+awVyT7iogM2Lgqgy2rWjbnqhN/oXJffD0HmUD+l
         5Y2sTFcsn10rpRt3DrLr5C+ZDgc0Ak7e6AGQXCftcF5vlO/7xrOefM9oblvFENs0OsJc
         mfWt7H4cbbd9Eh95I5LpXAX6SZa7c7lj0hJ0BcJRHBHui/BAAT57+2OF0f7OYIfQfjNA
         oFWn8PN0HWeuqrmc+7+P7eZMUaryL/VSlDvIi8q/eAahoupYSAqiiPgPVybnm55C6IP6
         CXUCET+2l0PWfbG1SprUq7fePz0b4DZDy4kTTnoi3vkfOEhEwEWtdeCWHqZzF9LhNPfz
         lXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVIDfxCODPdx++YobuW8f3Hee3mDgW+C5XbR0XhhwoY=;
        b=7S0lPpJ1pfxbuY9JU4vGbP46mauJXstaF3o2IOgELXWT6CMyzDVpT8ABVNnjxSXwxM
         i6jkGHTnxVHE0AVDREDWEXIX/AkZWdJvs5foqOGsyZdfySnhpkY7v4841pkGVfBrgiwk
         0ffBpga1GuvE2qmoudQD1X7NLmCoD30lziuPKrD4gAjFjNlKv1j9uF/FbSMLFjeo4eQu
         Lf2WlHu6x8KH9AREcLWx1vqvtwAETd0d8c4WDamEmPM5GDds3SdiSfcEOqmG8YWJPLbf
         pMMj4s49619TfrIRSLc7J2ewZ+iRcqZ4tLtSbKoeyFSZrP9Zw72uZ9S94gHA3AngifR6
         kbYQ==
X-Gm-Message-State: ANoB5plHAqNm2ztA39par8QaSnGkzPrAkOBR8sOaMfmuBnVwc5GUYYXX
        j5sBG8INbCD0yMg9JQikQnsZMcHecLigkA==
X-Google-Smtp-Source: AA0mqf6H99zOAJXubUzWSuxnDW9YVzMQMJvvAoctvShVpJH+cw4QnaJDeSXmyRpOZa0+lPV17ldmiQ==
X-Received: by 2002:ac8:7dcf:0:b0:3a5:6652:4414 with SMTP id c15-20020ac87dcf000000b003a566524414mr6250060qte.645.1669138344917;
        Tue, 22 Nov 2022 09:32:24 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:24 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
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
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 1/5] openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
Date:   Tue, 22 Nov 2022 12:32:17 -0500
Message-Id: <4cb57a11007f9c2b9f4d92f8a022eb34318cd5e8.1669138256.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1669138256.git.lucien.xin@gmail.com>
References: <cover.1669138256.git.lucien.xin@gmail.com>
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

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Acked-by: Aaron Conole <aconole@redhat.com>
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

