Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5378666A8FB
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjANDcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjANDbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:53 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1EE8CD26
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:46 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id x7so10601137qtv.13
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=LFrS7zj769EHwdknEtlyFvOpwWfofaoyDyoLqQWkZzR4OCvO8iJ0XtlJ97YO7o2fHI
         S33qFiMZ4+hpBSn+EwT+ZwZXbV9T2ACQ0Z9rbWJcLXwdQNkjYqYP5jkAHvANM+zzT0Fu
         /0g8N3woESbsy5oBaH+zOZ9Prk7MCyWqhEnlXsA9PvwsDqZoKaYvWEQTviOb+TefNfL6
         NL/7ls39Ds5pX0lmHp4C2hw24C1T7+8DQpMdLC1tpOksevfpBplhv6IRZa56vvh9HyxG
         MZ3dhEq/uCP9qMwNUHcL47ETqFoeK2E2OwYsROmVfQhk/kmmRXdPVHaKVOFWlRiVhSsR
         NQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=NwsDXzbAFvs4OkFD7pZpT7sxeVwXxjrWCdDIlnm+Sq6L1txkjlElJzG1UU77pGb1qs
         BjN5tBoqNWy6Gv189LBKL96L76Z+H7tN83wQITWO7FH1ldlqIPkBTuRDa5Cxfj5TlQt/
         CKOPy9Cfix/021EAx9qnlUA0tgcqGPTRo5VOjsoBxDlWFIHVyV6qTxoJoUqqLedrxCwF
         nDEAdtnyLlZwOsVQgqbb98zUFoKJqX+2Hl82J4tEGtrL+xPjYIoG6p5GVfvlxCPYyt0i
         2eBbRw8rsHG9C3Zr0q2Jjr8Me8zDocDzbwlz3FlqZjJO9ayDlKC4OJJze2cqPYC/z4MK
         Lq6w==
X-Gm-Message-State: AFqh2koun6lMtAPezHsMdoSdqfJT/lsHZbFB4sNQ+HZioApzp3IztU1u
        hz9+QP9Vk9GGvc+zIHBmLQyEf0QbQXTFiQ==
X-Google-Smtp-Source: AMrXdXvxDb5dxWxjpKV9I6CR32xajaRAAxg2/I8rPg0h7JPDgxJieIIofZvjUH84QK+z+xW1G9FNFA==
X-Received: by 2002:ac8:5155:0:b0:3ab:c5c5:5f3f with SMTP id h21-20020ac85155000000b003abc5c55f3fmr22403566qtn.64.1673667105798;
        Fri, 13 Jan 2023 19:31:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:45 -0800 (PST)
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
Subject: [PATCH net-next 07/10] ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
Date:   Fri, 13 Jan 2023 22:31:31 -0500
Message-Id: <4c928020ac456799782101ff90a402054db8fe6e.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
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

