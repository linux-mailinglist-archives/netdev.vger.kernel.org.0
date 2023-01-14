Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57D66A8F9
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjANDb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjANDbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:46 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195E58CBD7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:45 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id bp44so20804639qtb.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=oA+Jub8yHXoclflpjjy+ecn59yRkkOLgcFZ8ctq1qVBBA5dMRJaoyBj40MqY1DSI0o
         fu8Vz6i/o7RLO4yGy90ixo7uZX2n5E/2RD4Wvt3lv0wMIY0YMxyscOum+/LjDW7sQ/lb
         KJunNSJ4tHkR4U7BA0B5uVtcUjPCf5eT6PpqdLXcUizAUCqbETcvEkHd2DtTJEYu0tBh
         gfGGKDzl+opmsMykeiQ2UDJ1RDMXjHk1z+DmtOjcxiQS1qo04kSVeWXmMhzNaABiSwKG
         dYfSAxj3FVjPPoYS91L8Nng1s8rLA6iwIYLmYRkD/PsVS/82k3cguJjdolYj5Eq+qd5A
         Iesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=jL3bbpp/VFAWxhQGJ9l7tz0t2KPx/auf7j3XBGHjlkJoLtxQIWBuG0kbojUq4LOMsb
         LXinV3L/xpGp8dqtlS2aSOFa/eULjBqDrDHBj4m1I9hru+TIXxHrIYg3KAt6fohtVjxK
         Gj7s1R+BnwjserYrB9TS42y0k+8OzAjJXbkBCfwkE3BQCSsxj6ocGSVK52GjrOX2liFV
         HALr4QVEz/tOuHDiqABQFX358ubDR75FK+b8lwfeyW/lPf4e9E9fIFIa9Or65WiV+duH
         Luac/Jd+fnTGKiWLne9vZtMsx2lIcRQAPTGMA2W5dVlDakd7qlluhTM5QpXjtV5P24aJ
         CJ2Q==
X-Gm-Message-State: AFqh2kp50PoNX6kR4ZzX9BIAiZOHXRmtTQX5IvZK6nm8CVQTtndO/Ta4
        DZUSxqpuZUIgzPRqzFiBvBQS72KW2NVfaA==
X-Google-Smtp-Source: AMrXdXtHggqVN9FnGDpzXP/QDmGLdCxVq0RfQufcT4MuvDgEkGoErx5gGJBE10nYE5gcMljvICtGug==
X-Received: by 2002:a05:622a:a015:b0:3ad:797e:7314 with SMTP id jt21-20020a05622aa01500b003ad797e7314mr26095257qtb.1.1673667104578;
        Fri, 13 Jan 2023 19:31:44 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:44 -0800 (PST)
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
Subject: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
Date:   Fri, 13 Jan 2023 22:31:30 -0500
Message-Id: <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
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

It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
the iph->tot_len update should use iph_set_totlen().

Note that for these non GSO packets, the new iph tot_len with extra
iph option len added may become greater than 65535, the old process
will cast it and set iph->tot_len to it, which is a bug. In theory,
iph options shouldn't be added for these big packets in here, a fix
may be needed here in the future. For now this patch is only to set
iph->tot_len to 0 when it happens.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 6cd3b6c559f0..79ae7204e8ed 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2222,7 +2222,7 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
 		memset((char *)(iph + 1) + buf_len, 0, opt_len - buf_len);
 	if (len_delta != 0) {
 		iph->ihl = 5 + (opt_len >> 2);
-		iph->tot_len = htons(skb->len);
+		iph_set_totlen(iph, skb->len);
 	}
 	ip_send_check(iph);
 
-- 
2.31.1

