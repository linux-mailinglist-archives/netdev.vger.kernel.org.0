Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1367F957
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbjA1P7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbjA1P6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:55 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45163401A
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:45 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o5so6546996qtr.11
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=Nf5WzrdVRjj1JZEc88Jb9MRW3O2fqDrxAjneWJrm39mErcA3ywJyq94XmXq3rlrOOB
         UZqpnWjM56Aaup6kE9oH+J0RSOSSRpHjnaLBakNrGmzWeeQHNV9LkopV38xaRH0vbvYr
         R7qcdjm1BXaqLVJzfNQN6pS0UcoZvGB6DMklcFiEKdUfv/HkocfzhGcWi798mfnrs7sC
         Zl9vqxM17JNVu7nbO7CJe26IeID+R9fZsSAO9rLneMp3qNcm77EIokBoizXCXYlHunI8
         cy/OEgyhEnmVYVFsRTgpgBuz5uHIqlihaMm9Ij8lVWHVfyvl2JHsNm46UG2rlhGeVqP+
         wKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=zw/NwNeNnetagUS9Kc4AgE1vVXkD2NRVVi1n/iamFfE5bxZOWzV3QulRXlQnjNgylc
         AmnLAaScFXHaEn6rRqWjgqIALNSP8kw2Szy5zexeLpe07ytov+r4BS/JfDILcjMNBxRn
         1n+IWAlfHDPF8mD96OMorCSMrPNzJwKfvCaOWJZevfWB/WfCgSi/06Ns7EVgHzKB8vSi
         ELkUn36Ol4JBa4ghlU57wYfwo7NBDido/Le7lC2/N+4M7U3SvVnthoznQgnqx9HYwBwk
         x12XATEFJqWmIZHdbc8vq4+iltYCKUcAVsbVE49N5czXEqdO8Zy4iNwp52+D0MV5hoGt
         1UhA==
X-Gm-Message-State: AFqh2kp20eSH8hqv+Fs44ZcllU5htengf230/9ttIW70wBHYQj7i3g2Y
        Yj1HnOq6pIOgvJurkORhp+4giMIBXrErtg==
X-Google-Smtp-Source: AMrXdXu+n9BuV4pLHUpLj+kizgdRahvETZsjNFV0/rKBbcs0pArGRdUmone/I2Rel1SYEgJsRk5XcQ==
X-Received: by 2002:ac8:7341:0:b0:3b6:334b:2cb7 with SMTP id q1-20020ac87341000000b003b6334b2cb7mr66061716qtp.19.1674921524560;
        Sat, 28 Jan 2023 07:58:44 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:44 -0800 (PST)
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
Subject: [PATCHv4 net-next 03/10] openvswitch: use skb_ip_totlen in conntrack
Date:   Sat, 28 Jan 2023 10:58:32 -0500
Message-Id: <8ea56cf09856cedfa4c7a3f6e266c84723de8544.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
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

