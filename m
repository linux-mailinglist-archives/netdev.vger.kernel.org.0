Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0D644F9F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLFXb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLFXbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:31:23 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4046242F57
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:31:22 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id q10so11546241qvt.10
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckD+oQOkvtcBW2v6IgPx3t6Z++GU5WuLf3uNigi16zU=;
        b=AqIeabWw/jsvI/L+7OnPLKX6PNuzQw3loQ0vCUm3uS+axFCa/0LJjDMe70Vj4/yzhs
         I6j5csOauADbZxMsq9vIuZYGXkJ0k+bHO4ROOcZkrXbzu+p+VoQS9UsYXg/KKuwCY358
         59ZySsbw0tdCfMHeEFAvpR5ZmSGPqjqr3HEtQngQUoww0i3EhjShNTRDZAzmHSCfldV3
         NhMHPr20PTJIMQxV7qYy7nhEx63QCT4wkhnnnUCR4ANTHfOW8iMv+P58AjG34LCY/tfp
         W2VghawXGcp2g3Qk4hSMjC++on+iMpZ/je2BxDVdQ8SWRh4Luqyj2/2JSgoV0hjPOREz
         QHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckD+oQOkvtcBW2v6IgPx3t6Z++GU5WuLf3uNigi16zU=;
        b=1AhxILHVn/VnrcmFsvSna9bJGo/N8Oa9R2pYhFoonGYLPjKlody6Kc/dJFSGOIvHee
         DZvK+mMdkeq8pts3YxYojoIC5RxP0o5tJoZokY5hisL2lA2bgn9mkiKZC0ByXTBDaZdR
         L6mS/xQ3wTSbFeRCDbMpk3qhMZUw9HkX5UP8X4EXkRBKWk98AoQvKkcNd/reWSRv7J6l
         EVfUrMLxmydYJh/o9PxoBLO4GEoagyln3y9J79OwlR5F7iFej5Hs83ibx7Fi8K4r411z
         a8K0c3l30plv6GXpXZerDgN3AKlje9cNxENib6H3L6YO/tKcbAETil0ksd69zBE7UkFb
         /8qg==
X-Gm-Message-State: ANoB5pl226py4RbF/lWiTu0Wo1PGrh5E340esmNltvicG9mEMJT3+jm5
        h6nWybUMqMMYuKqByHPTCdW5BVBa7+ZmKA==
X-Google-Smtp-Source: AA0mqf5ru8WTJB3TdFfgIg9oA2ZO0To/PTj1qGXrnn/lJUt/lpwt/g3jO2fsF6WZVPxJ2EYvxenuCA==
X-Received: by 2002:a0c:9091:0:b0:4bb:7920:eed4 with SMTP id p17-20020a0c9091000000b004bb7920eed4mr82743228qvp.90.1670369481144;
        Tue, 06 Dec 2022 15:31:21 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006f8665f483fsm16590231qko.85.2022.12.06.15.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:31:20 -0800 (PST)
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
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv3 net-next 2/5] openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
Date:   Tue,  6 Dec 2022 18:31:13 -0500
Message-Id: <31308d79f10fc8804941ea9acbe0844521832074.1670369327.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670369327.git.lucien.xin@gmail.com>
References: <cover.1670369327.git.lucien.xin@gmail.com>
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
index dff093a10d6d..5ea74270da46 100644
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

