Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3E16474BD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiLHQ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiLHQ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:20 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6177681E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:19 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr11so895863qtb.7
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckD+oQOkvtcBW2v6IgPx3t6Z++GU5WuLf3uNigi16zU=;
        b=m07fyFRL3ybsYtl+k2i7yQeWWeliA3EmxYfD3WNdGRhky5Ak+9b0/J+DxtN8rrNyms
         Z13dsfR5inPidPyQkUuVvzGDiIS+YsVX++JyuQJCztR1HdycMEiIsl+41b+J/yKbR4dV
         MOvmfYaPi0fKKMlWioyyoTXLqrbQPkTU2DvyWo6FZvC6TzJmTvJzppiq8DCd1Xud/oXn
         EHMmYX/e4jtgQFsiERcDR2FOGbQ/k7gjLo00E0s1wqM7V2Rbw6R+4z8h4QsKA/cGBZni
         Da5iNf+sP2ikxFxjmD1iZWMcLwvQktER5GiNpIU2AAPnMwngwuX9coA/IIhFGJLABP9o
         bjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckD+oQOkvtcBW2v6IgPx3t6Z++GU5WuLf3uNigi16zU=;
        b=JklgGKzmqgaHCNvYl+5v3wlird9YHqYSMjlbhgKpkXmkX7KxonYShXZuLjgnMm2Ne6
         iQt5Hj9SGxusNPcWTtbffZng2/3tsTgIOZ4xStR7jaIxvX4q41/+1HbHf88n5tBlJfpV
         te9lFehPcackPC2U9dX5iD3T83EgzIEdWNebyU26JExaItmQWUwIzsn11a83EKA0N0Fs
         xsgFKGAoM7iQ2lxzlctrs3MMUhMiCYf6TXvYd7xYiNvvUtohbcWYrI01uYADA4wdbZAO
         KGnUkpa7rcGWKuNDMyPRIwkjr6qcYQqQCKh36JfD/yWwhhPeSH+S1nVgwZscWcQCHOqg
         ybyQ==
X-Gm-Message-State: ANoB5plxWZ1Rv9qxMyn1trPtuDgsxg77saAMZmboocAWWfyAb3nYbZLr
        zbLDNrwbq+JBUzJNCrWY8VsGYjkQljC8/Q==
X-Google-Smtp-Source: AA0mqf6xiN8/POGk21IaDAe6iRqyWKZSORJ2ufmTfSphwHXw+YrwBAeuSviSXci1NMkm2RQdq3uzOw==
X-Received: by 2002:a05:622a:5913:b0:3a7:f84f:3c80 with SMTP id ga19-20020a05622a591300b003a7f84f3c80mr2607708qtb.51.1670518577953;
        Thu, 08 Dec 2022 08:56:17 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:17 -0800 (PST)
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
Subject: [PATCHv4 net-next 2/5] openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
Date:   Thu,  8 Dec 2022 11:56:09 -0500
Message-Id: <e6293f5de8e0c8e3d39d4636385433245e00f4d3.1670518439.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
References: <cover.1670518439.git.lucien.xin@gmail.com>
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

