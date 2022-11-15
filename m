Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB55A629E14
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiKOPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbiKOPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:06 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75501FD2E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:02 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id g10so9728461qkl.6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUi86z/NVTiwGRNW4R1ZL+vB4OqCDoTZN1oi8dFBlq0=;
        b=USNF4UViS4+Lov7Xx71uuMZ+PULGJPQcjy93/io/jtiIvtLeytN5g9G82pwJ7GMa6c
         D+RYmc80solR0qPnz2zLq4LX0h/HXCFr+Mjmdw7MlHEnoR+vSUVK68JVroY6eGG+MN6O
         VRBZSo3dfGX5Xh4192e20LuDDiu35p+Nk03iw4dY7deSrgZ4tFNeLTh/LUv2W8y15JDf
         CgcQc+yvlgP9ptwU6doGRvek0Wl9rFmHC9YXRDciru3Z/z/DQsbEDsgq1i3nf5vSnGLY
         G60Z4ck4wvgsWzLa47tiD9GyhG98BtuDkOGtoLBITe4SLexDrIEjsCE2evNrL4acLUmv
         mrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUi86z/NVTiwGRNW4R1ZL+vB4OqCDoTZN1oi8dFBlq0=;
        b=j3KbZAPxM0bdOOE+Guf46+p67NdqeDH+Zn5lNf3+RXVEVTo3QLXRGznJmIl2nTVpUP
         dtqLyCvcLsMSeHvadHB2x7DKbIyMPDk+vqseGGLFUkB5j01W62idZdwz/u7P3rzSqzjS
         GKJ/gCqQbQ+RMVnQz7FLxiBVpEpL9TUyKimFe3rplcR2RegL7s6FtzEH4wFCINkXCYfM
         TLMomGJW0ftsvmsFSUzDdPo3Cc+NzI9WsnO95uGqNrD0odlUIUtQOciN4cqdUOQI0glF
         WyXDJ149hXB4FHnQr73IF0vyCqZ0KTEIhBvcrt/vlGul39UeAzVfH8jaWK7ci+ClzqY2
         NFIA==
X-Gm-Message-State: ANoB5plBwNWXFNyl44XLJ112iIcHEis8yVWjfcn8oPsmIbOE/bJlxOxr
        dUtRvPyARr+Ng27oCJl+LlLVZxnIyWsalA==
X-Google-Smtp-Source: AA0mqf7mqjVDS/u8xeXKRpBMx/Yz7LA7T+iAG/N4zZaBnd9tPU/NcJpQC4Q9D4VcdYp5vL0FLihJjg==
X-Received: by 2002:a05:620a:1d51:b0:6ee:d622:5f28 with SMTP id dm17-20020a05620a1d5100b006eed6225f28mr14874910qkb.682.1668527461200;
        Tue, 15 Nov 2022 07:51:01 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006eeb3165554sm8244351qkp.19.2022.11.15.07.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:51:00 -0800 (PST)
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
Subject: [PATCH net-next 2/5] openvswitch: return NF_ACCEPT when OVS_CT_NAT is net set in info nat
Date:   Tue, 15 Nov 2022 10:50:54 -0500
Message-Id: <8c17d8ea9547254180031510a3160fcd97ac945f.1668527318.git.lucien.xin@gmail.com>
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

Either OVS_CT_SRC_NAT or OVS_CT_DST_NAT is set, OVS_CT_NAT must be
set in info->nat. Thus, if OVS_CT_NAT is not set in info->nat, it
will definitely not do NAT but returns NF_ACCEPT in ovs_ct_nat().

This patch changes nothing funcational but only makes this return
earlier in ovs_ct_nat() to keep consistent with TC's processing
in tcf_ct_act_nat().

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

