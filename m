Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A99C634282
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiKVRcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiKVRcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:31 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B3226F9
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:27 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id h7so9957942qvs.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irbCUI+JGKYlV7sUk2tQBJOk/S1b6jPdBvzJuPnafIw=;
        b=iFnG9uIpHZMzdz2uil4c+swhR7bkZ6pZg6TNapRBoankCuOzVKIs+xVTOowGpo4NCd
         K6ygdrCYrOwsqRRNPyJ24lCflHpH1OiQPkGr1KU5XnqsPfMktvxzqTVqt9PKElkkSQRv
         z4jHSczKKbqx7S3KokQWvwqBa/Eb0ceIotnqAtmbgOkH6EPw4tXK88jhJjF1cs+PBkjz
         Eb9LmyyrwRw1uR+KUMwuqT/K9QNKir/f+NYQ+dQgdUJMFkb9WsjT7a0yTcUBker5b3zD
         PIfPYHr/k8/VEbJoQrS2zmB+zYjnfR4y7cd5jl2ZnNBW4ci/yN8MOzilXgvkQca1S2dy
         UOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irbCUI+JGKYlV7sUk2tQBJOk/S1b6jPdBvzJuPnafIw=;
        b=Y+XB7amNrZ7yCjAYL1xGLD3JbfiOYDU6VVBGdk9JR81zrx5k210I51OlqGl8LyvGNl
         hctgtWcIP+ynH5bGgaXgxSc7PaiR2CLbD2xV5HbC7V9I+rYLZWP6QaFsYz3+FKOXHhJO
         IFw6YwYabG2YbaLx2fp4d1T1e3DDt6S074drmcmI6csKjpQdQPVKmXRBQ/IWq33ppiHP
         uyAFHAsEMYFoJJpJteEnws/yk4ZHfisHpvQYqRRw+XGxtqSm5v9T2+u3QOpWAAsqs5kr
         A6stWTsxbUOaN80VzFewiU7PHdfzPRLnYl36Us7W1Co25Ns3WLUnLLcgokxG/8wg71gQ
         zKww==
X-Gm-Message-State: ANoB5pnhvCrkM5ZLOENUEu4oHo3DVi/lCvRj+3SiQPjQQgxfnCqEgU/X
        Tpj3vNG8WZfcsyvRxhugdomHzPYBBRHf3A==
X-Google-Smtp-Source: AA0mqf6L87geLyQsdkfKNT6/lMB7OMlCrtqZAX35ajBxS0aeKZ+5J8wN03OjaA7UdRDq0iTg76kg4A==
X-Received: by 2002:a05:6214:3311:b0:4bb:8572:999f with SMTP id mo17-20020a056214331100b004bb8572999fmr3621906qvb.6.1669138346253;
        Tue, 22 Nov 2022 09:32:26 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:25 -0800 (PST)
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
Subject: [PATCHv2 net-next 2/5] openvswitch: return NF_ACCEPT when OVS_CT_NAT is net set in info nat
Date:   Tue, 22 Nov 2022 12:32:18 -0500
Message-Id: <834a564cfccd63c3700003d3f9986136a3350d63.1669138256.git.lucien.xin@gmail.com>
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

Either OVS_CT_SRC_NAT or OVS_CT_DST_NAT is set, OVS_CT_NAT must be
set in info->nat. Thus, if OVS_CT_NAT is not set in info->nat, it
will definitely not do NAT but returns NF_ACCEPT in ovs_ct_nat().

This patch changes nothing funcational but only makes this return
earlier in ovs_ct_nat() to keep consistent with TC's processing
in tcf_ct_act_nat().

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4c5e5a6475af..cc643a556ea1 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -816,6 +816,9 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	enum nf_nat_manip_type maniptype;
 	int err;
 
+	if (!(info->nat & OVS_CT_NAT))
+		return NF_ACCEPT;
+
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
 		return NF_ACCEPT;   /* Can't NAT. */
@@ -825,8 +828,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	 * Make sure new expected connections (IP_CT_RELATED) are NATted only
 	 * when committing.
 	 */
-	if (info->nat & OVS_CT_NAT && ctinfo != IP_CT_NEW &&
-	    ct->status & IPS_NAT_MASK &&
+	if (ctinfo != IP_CT_NEW && ct->status & IPS_NAT_MASK &&
 	    (ctinfo != IP_CT_RELATED || info->commit)) {
 		/* NAT an established or related connection like before. */
 		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
-- 
2.31.1

