Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926796CBE1B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjC1LvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjC1LvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:51:12 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710AB4EE7;
        Tue, 28 Mar 2023 04:51:11 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a5so11577747qto.6;
        Tue, 28 Mar 2023 04:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680004270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AvPaHNstAk8NaFn8ceUI/B1bRd8Qv6rcPFoP0UGHZwI=;
        b=pcB77RCIWcFCOE6akpAKpuY61NVXIQmVKAKxfSX1VrNHmWGrTIc77qxqx7ZgfA1cX4
         jlwqAa637cQD1+3iBhqEuZYAn1MfETL5CpT0glZRPXxmHWdhXHPG0Hg1J+UckBWqbGvl
         cGZNHou8zEs4HLZAxS1Sugzw7g8qIvHU/D/Wwfpqw1QqlZMnFuvNLKW71ezAUR6RNY5d
         P7la5f9FkmyoYMliy11r6p8eb2it1zyfI13+mEtC2MQZSlaqs3yDdATh82HqTw9OO3I/
         /ufYaxWcwJ4Z/zkFEaCpd7AIYARMRtr4L1ljtdLyDcZTavRKAFB9JTn+owQ17itcAn29
         vcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680004270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvPaHNstAk8NaFn8ceUI/B1bRd8Qv6rcPFoP0UGHZwI=;
        b=5ro1EyzDdPWg7Tjdof9zI2xFWi8DAB56V+T30ZxEHPj9UxoMNWzIaUcdhnLK64GFvw
         ht55VkGC3rekWKuOGS6t4llG4NW2akTTezYplHFvjJKmpYD2anCTckquSzt7mC/LpKYa
         KqXTOwGbzm3yjV6PBNeQCQCqthaZ+XKpIpsjJjGEZYsGkRnkZfTiG3649Mkk6Af6+Yoi
         dbav9PGURn8Inz1tOkn84whqLKtlH/KQ3YY9a/nD+uiuIZSNLgSa3oduoMESJBO1dJaS
         ejM2eSD6yDQY6pA3j0QhTawotexOI8cpiLjNkp9muHCAi0UDyGzcWYnFJQtRt1uU1VUt
         VHFQ==
X-Gm-Message-State: AO0yUKXzYVrXQ10vzJ3/aFsGybpyDIyiSvwTMy2jy1tB6hEhr3C7E5q7
        GNwyIJVBG6gpVgq7yf4fUjw=
X-Google-Smtp-Source: AK7set91A88WfhhIENa0IRxAejver5WHDU0AoBZOdceCvBfnc7XQK2w1E9mICtZcdvLEcxactGYtfw==
X-Received: by 2002:a05:622a:170b:b0:3e3:7e24:a35a with SMTP id h11-20020a05622a170b00b003e37e24a35amr24949264qtk.9.1680004270484;
        Tue, 28 Mar 2023 04:51:10 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:5:5c17:5400:4ff:fe5e:f4cc])
        by smtp.gmail.com with ESMTPSA id m15-20020ac8688f000000b003e4e9aba4b3sm1352734qtq.73.2023.03.28.04.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:51:10 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [RFC PATCH net-next] bpf, net: support redirecting to ifb with bpf
Date:   Tue, 28 Mar 2023 11:51:05 +0000
Message-Id: <20230328115105.13553-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our container environment, we are using EDT-bpf to limit the egress
bandwidth. EDT-bpf can be used to limit egress only, but can't be used
to limit ingress. Some of our users also want to limit the ingress
bandwidth. But after applying EDT-bpf, which is based on clsact qdisc,
it is impossible to limit the ingress bandwidth currently, due to some
reasons,
1). We can't add ingress qdisc
The ingress qdisc can't coexist with clsact qdisc as clsact has both
ingress and egress handler. So our traditional method to limit ingress
bandwidth can't work any more.
2). We can't redirect ingress packet to ifb with bpf
By trying to analyze if it is possible to redirect the ingress packet to
ifb with a bpf program, we find that the ifb device is not supported by
bpf redirect yet.

This patch tries to resolve it by supporting redirecting to ifb with bpf
program.

There're some other users who want to resolve this issue as well. By
searching it in the lore, it shows that Jesper[1] and Tonghao[2] used to
propose similar solution. This proposal is almost the same with Jesper's
proposal, so I add Jesper's Co-developed-by here.

[1]. https://lore.kernel.org/bpf/160650040800.2890576.9811290366501747109.stgit@firesoul/
[2]. https://lore.kernel.org/netdev/20220324135653.2189-1-xiangxia.m.yue@gmail.com/

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 18dc8d7..3e63f6b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3956,6 +3956,7 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* No need to push/pop skb's mac_header here on egress! */
+		skb_set_redirected(skb, skb->tc_at_ingress);
 		skb_do_redirect(skb);
 		*ret = NET_XMIT_SUCCESS;
 		return NULL;
@@ -5138,6 +5139,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 		 * redirecting to another netdev
 		 */
 		__skb_push(skb, skb->mac_len);
+		skb_set_redirected(skb, skb->tc_at_ingress);
 		if (skb_do_redirect(skb) == -EAGAIN) {
 			__skb_pull(skb, skb->mac_len);
 			*another = true;
-- 
1.8.3.1

