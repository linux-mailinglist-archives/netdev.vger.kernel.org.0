Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFA766A8F7
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjANDbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjANDbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:42 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E498B772
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:41 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id a25so13544457qto.10
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=kkknBSAa4sBQriVuJ3s516KogNx/mlxfizuf7MqT+STFV13JZK0Mh5AYDqmGI/S5iA
         lM+wuuH7MF5RBTBJGIIpZqfdEeDLrsfhP3tVeuEybdfo4n2uPk2axR15pBFKoGAi4fRW
         uVQ+NTazYbGt3LqeVv0plBb5OJe0vcfgpdgz93p9G/m9hvJWjyRbD8OwgKC9s0sP7WvB
         WUTW3z7i6fUKgYiA7FK+UTjejTW1YPYKGlwteB5wNwPKP3AncQsYL4P/DhnqGK3hcwKu
         8tyqm0YQbzCllZtKG+XtNqfJMezH9Z9Q+KeJiOLhejULaWxdzRmR/p4YM3ujRBK7k+e5
         o+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hndcFGcKXsUPoSfBcORkIp1PbmWGWJK7GRgLe6RV99s=;
        b=URi7pnXRpgdve4lE4NrXemfgKImv6j+5gQGHf2cxGGP4NEirhujjapv+Jsu/GaL0+3
         newqaG9QeMCKW9kZ4Lo7loHdallOSbg3+RLxN0RfudLazAbdakmWNBYO1U9f7o1ZSm6y
         WQK1NCSTgYpr7xoc+23xnc/+qXxNCO8KsCg3n9clb1FzjjwxpNg9ZLPqRkV9Gs1CS3W3
         UmyHowFMXLoBJgflkqI3UEZlxKriBh54qy9GEnpUIbwFrT/+oIN99KWTJHjQv5M06dKu
         DQ5uBorSio+rmsjFVZ+HA1aVRl3emCqZHY+b3XKYUNgToyRtDU/pLyfztz2zO4XVkCd6
         0xeg==
X-Gm-Message-State: AFqh2komvpEzV/23czk/WljHwJ2Tlax5Kv1KrTjsAJSEvjX05qxNoH3C
        zFlLeT9V+HYhYD9nuqUjl5OzzeEbX5tOVg==
X-Google-Smtp-Source: AMrXdXtl97xpSNXGMGadsqubakPe+i2CafDv0qEmbxSVRKPO6BDgFsdTIDhA6LvfsmwDYVWbnSCexQ==
X-Received: by 2002:a05:622a:1b0c:b0:3b1:e55e:5203 with SMTP id bb12-20020a05622a1b0c00b003b1e55e5203mr9674865qtb.27.1673667100640;
        Fri, 13 Jan 2023 19:31:40 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:40 -0800 (PST)
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
Subject: [PATCH net-next 03/10] openvswitch: use skb_ip_totlen in conntrack
Date:   Fri, 13 Jan 2023 22:31:27 -0500
Message-Id: <ed7648eb6bab66d6c45ae6826d2597b59e2d842a.1673666803.git.lucien.xin@gmail.com>
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

