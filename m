Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A5678E2E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjAXCUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbjAXCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:21 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9383A863
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:16 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id d16so12033066qtw.8
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=FAxTplsM/3PPgwSrxP3nOz9ZC849BUTbdkeJk1x+ZdXev2HtpAV7E+Oiot1mD/I2G9
         SMsFuVlwLEaVDvHwuBoNFIjAwTqx8eV63GK46dFVm0ularUgvMB37UIde7gvGMvzvINp
         KL+Lz71+9rz/7PLaE/Ib5o5jVIgVxPMo6TnIc8E+yRyO7dBd8IRId907QjI2c7cn9HWr
         F5I4c+LKuV0mZB/zNPSB5WPgkazOLsoaWX53zChZYXZiU71qW8ccY+rF1YUcnkJWJij5
         W/7GjfDsTLFgbcHr1Ls+bc7ibUyk0MZqhFVyJxhu8ULGZACUHXVVZIpCCZEnwrbSFRA3
         TvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=DOWsm5EewA9d4eSF+DuOI2R+SQXQQyarQyNvd2MEmZnXXrTK0KVUrEq5yfGQItQQhP
         UnzCLZfgFEMMWJtgghW2mlrM2OgR5rmakqUJ9iKsk31yX1MZUggaxTXVVKdaZlE5NLIS
         A20uF//SDEk2EpzCnuZGgh1xfurxCxXL6zSUY0iyhry4fZRY9p4E4ilGDDzCA+rOe2kt
         M8AnKyWTXindManZWI10NBGLfokPdMPeJFTKpDTf7jWonXd1IIfuT66JU1OTsgc6dYz4
         w+uk8EmvbeiSpoyDoudQcGGXL4G/mZJ6XZr4zRJgpyO+q7dPca0o1cfIb7BvvVGRffFY
         JYhw==
X-Gm-Message-State: AFqh2kpcT2wWaY9ZtEtf891sFEB/+EB7M2SQDqakOD/SbZiYpV5tnQBN
        CVbBeCJw4+LZXs++yTPQwAXdY7Kjl+/fVQ==
X-Google-Smtp-Source: AMrXdXs4rt2yXIFk00wZFebZOd6k8SUvA96YTdATTHeIK4jKnjjsG1cqZyorXD0a0v8GUX0r3DiNfg==
X-Received: by 2002:ac8:734a:0:b0:3b6:471f:3e88 with SMTP id q10-20020ac8734a000000b003b6471f3e88mr34398019qtp.50.1674526815156;
        Mon, 23 Jan 2023 18:20:15 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:14 -0800 (PST)
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
Subject: [PATCHv2 net-next 07/10] ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
Date:   Mon, 23 Jan 2023 21:20:01 -0500
Message-Id: <fab665f877b591c9c568d5b7ae84b6017dfe8115.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
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

ipvlan devices calls netif_inherit_tso_max() to get the tso_max_size/segs
from the lower device, so when lower device supports BIG TCP, the ipvlan
devices support it too. We also should consider its iph tot_len accessing.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index bb1c298c1e78..460b3d4f2245 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -157,7 +157,7 @@ void *ipvlan_get_L3_hdr(struct ipvl_port *port, struct sk_buff *skb, int *type)
 			return NULL;
 
 		ip4h = ip_hdr(skb);
-		pktlen = ntohs(ip4h->tot_len);
+		pktlen = skb_ip_totlen(skb);
 		if (ip4h->ihl < 5 || ip4h->version != 4)
 			return NULL;
 		if (skb->len < pktlen || pktlen < (ip4h->ihl * 4))
-- 
2.31.1

