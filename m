Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042156E04EE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDMCyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDMCy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:54:28 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA1172BB;
        Wed, 12 Apr 2023 19:54:08 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id m21so3983502qtg.0;
        Wed, 12 Apr 2023 19:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681354447; x=1683946447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g2t5C+Nqj4QS3C0XZLg8gc9PHSRT4VaS9b09a++MWfk=;
        b=H5gJphsHAwIoG8F8IPocWHucXUa0g+vKZlyeNJfcuM+wEr4heqtpncoeeAB33F7gfx
         lZxuGAZW35YekqqYReHof63AKHDroMAJZ8QsY8utmhXD6xcvCEwnikYHzR+RXvResyWT
         0HOk5vTOb0IMSTzR9KMOyRtsdVYtgKkAdpOrlkDg7ma4MQi5pgn9HnKCxWznt3uFEIoC
         bXBPQXNJ2HM5153hERc5B4DQDrTBoVb11VhnmXv6qoOJ1vZhsbjs5BdtM/qoedXn17vL
         B8YOmgB6qWZ/fhsJhMN/F99aMam6f7+EjnaixmqO/+YLTLOnXw/7YwWvsDuAejdM4oKR
         ic0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681354447; x=1683946447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g2t5C+Nqj4QS3C0XZLg8gc9PHSRT4VaS9b09a++MWfk=;
        b=YJF2/0JG8Y0X2d7WoTI1nDNr/4zossoda6edx0sGgjvF5gN3oX52kXsqgTR3saC6OU
         VNcwcpmFYi1FtakpWLXS/Igs/gPrP8M6LOdAUcFVHvgunDd6XHEUcD3/tgrmIycch+Up
         7e/SOX5zAZzC/HLGnI0CXCmFammWE3hSR2dE+1bVyn4dmT1S84vvJ7321Z7wXWbGyw3y
         Wj8gyK+rbxlBKVG3SLCQA4EWVJkBUPXR4EDwOA+gaoXEifiUGkkZw70Dp/pudDAabGAF
         31ebuiEWRI9HnGwC52PgXG90EeXM75T/ZAMl5M6rcOd/MWF/pNJfnNjWjb1+2CYdVw+E
         wHnQ==
X-Gm-Message-State: AAQBX9fKkqfbfHaGj1oWpz2imvxobWgOuANRWsxn7EFnmitI7ZiUrJvr
        ENupFYgqbWRl/ehiZM46bFE=
X-Google-Smtp-Source: AKy350Y7fjHmntc5+39FLCvIUjdSvhmE5e5Nve36uzWoEdKWr2JZpM0/lPusvIymRwunVDmDUsn59A==
X-Received: by 2002:ac8:5d89:0:b0:3e8:38fc:e8cf with SMTP id d9-20020ac85d89000000b003e838fce8cfmr1071357qtx.22.1681354447124;
        Wed, 12 Apr 2023 19:54:07 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:c:fe2:5400:4ff:fe65:32a4])
        by smtp.gmail.com with ESMTPSA id m9-20020ac807c9000000b003b9a73cd120sm188728qth.17.2023.04.12.19.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:54:06 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
Date:   Thu, 13 Apr 2023 02:53:50 +0000
Message-Id: <20230413025350.79809-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Ingress bandwidth limit is useful in some scenarios, for example, for the
TCP-based service, there may be lots of clients connecting it, so it is
not wise to limit the clients' egress. After limiting the server-side's
ingress, it will lower the send rate of the client by lowering the TCP
cwnd if the ingress bandwidth limit is reached. If we don't limit it,
the clients will continue sending requests at a high rate.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c785319..da6b196 100644
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

