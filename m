Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A106AA61F
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCDAMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCDAMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:47 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1920D3D;
        Fri,  3 Mar 2023 16:12:46 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id nf5so2909565qvb.5;
        Fri, 03 Mar 2023 16:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWJ28UY4iLQdzHNxIZYl4ipNRNAO6xCEZ7X8+ikWSWw=;
        b=plb9RvYXgNpihupQiTpUZCp3TZZEWnuNmutuvlxZlRvhFjK48LMDHZfpIUCp8PHOVG
         msILcKO+92UpyrgfmKFJ2Bt3NqBLGxfRemjwZvp0msAMVeAGlzjQeYLGfzeQFfivCUI9
         SLwRPwisaIDbDNSZehKkavU0JDaw1JzaACApd28+pBw0BlVklHLaHH867bRLA6RjzgJW
         +kqO0O96jGkqPgPTBLSBlvshr5emMo/uR700gCvmdKLc8FzRWg/6s212hcHAp54Tccvg
         0XM2dwnVWHVvBEcs2M2aXD0/T7DZ9GOITLcM8BRgVKf+taKzL1TUn9LG18dWVFDeXJZl
         32sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWJ28UY4iLQdzHNxIZYl4ipNRNAO6xCEZ7X8+ikWSWw=;
        b=c9SrE796aVWb5DzmDyKpDn787fXhv57THWvIlyQB5+e5j4PNe/wI7c6YDNGoAQaAxI
         fBpslCB3QngvPu8w03ynW2d9jf7ml+57GI5kSnihMbIGRmABypvzCFBTLerHKAndK9xS
         1zFgpefqCEcSM5vB2KZTTyrStcw+b5SgvNdl8psyBx3OWLWRmDFZmnddmn0pMPfMaV3C
         4f4lGiHpuy6w2nPyvPaL7HI6F3XKdjrSt91q7fEUb7DmgxY57H990+ujwkAQb/tuUtEt
         sAu5ypQWtkFuslxD6qTXytVJPQDCcI8EaaK33QZMZ3PqEEteaATDhbGMPAc1fcOSDqYx
         ryRw==
X-Gm-Message-State: AO0yUKU1y9nPYGN7StUcXd3bc+7EZJePTRDDeV/VH7/zFn04yJukVsJS
        Ic7GCE0E3x+2EkxV6za2eZ6zETZNoJ2BvA==
X-Google-Smtp-Source: AK7set8CXh/w6X9apZgVAkYrb6+erIV3I9gmymlYUSotCqbqmfDD79dg+W4yWtg6rh+C0S1HAE7Rpg==
X-Received: by 2002:a05:6214:260d:b0:53a:5812:143c with SMTP id gu13-20020a056214260d00b0053a5812143cmr7153449qvb.20.1677888765608;
        Fri, 03 Mar 2023 16:12:45 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 1/6] netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
Date:   Fri,  3 Mar 2023 19:12:37 -0500
Message-Id: <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
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

When checking Hop-by-hop option header, if the option data is in
nonlinear area, it should do pskb_may_pull instead of discarding
the skb as a bad IPv6 packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 6b07f30675bb..5cd3e4c35123 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -45,14 +45,18 @@
  */
 static int br_nf_check_hbh_len(struct sk_buff *skb)
 {
-	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
+	int len, off = sizeof(struct ipv6hdr);
+	unsigned char *nh;
 	u32 pkt_len;
-	const unsigned char *nh = skb_network_header(skb);
-	int off = raw - nh;
-	int len = (raw[1] + 1) << 3;
 
-	if ((raw + len) - skb->data > skb_headlen(skb))
+	if (!pskb_may_pull(skb, off + 8))
 		goto bad;
+	nh = (u8 *)(ipv6_hdr(skb) + 1);
+	len = (nh[1] + 1) << 3;
+
+	if (!pskb_may_pull(skb, off + len))
+		goto bad;
+	nh = skb_network_header(skb);
 
 	off += 2;
 	len -= 2;
-- 
2.39.1

