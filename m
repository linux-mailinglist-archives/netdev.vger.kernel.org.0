Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4345F5B2A01
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIHXP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIHXP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:15:56 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78A7B1B8D;
        Thu,  8 Sep 2022 16:15:55 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id x3so58512qkn.5;
        Thu, 08 Sep 2022 16:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MlhnWP7ey0aRvA15+oNfZLaURLs2EkPM1ZLYxQmv3zs=;
        b=Ykw6VUj12Epd82J0HG6/59kvFPyl6clziGlDNs/83MyQX7vSGfllr9cWtRe0prRoD9
         LyqtDnGEk4mJP4qQTSSNZQJhBKaYKxNoR7wKtHYqBeqZTM6+1cGLc42yJLDsLnVGddrQ
         ETtL3H11txbATZJMiO2DUDGBLrBfsoIMHdUiBZLm95wY6SApjIt+vBleyMch1f8NVVvD
         9SMjRr2QqBtIE6bdriqRUqxhWhcf0H0maazgTvFtZTLcmhBlqjAHyCIOHfmlg1/FoAfz
         VIijLWB5Ye7lNdI2LESOJLVNSbgUuVa+grm+ZQE5GiO1laLJUNbqlSJcrXcUlXLz2TtR
         G7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MlhnWP7ey0aRvA15+oNfZLaURLs2EkPM1ZLYxQmv3zs=;
        b=uYbFq9ZTTjVOmxX9HYAGIaAR8xnbSlU52VpprZokMa+2AayRVD8CVPiY5PGsiCP0JA
         YzMTA/paofmeqmohRw3GOa9zTLlbW+PvNmrjE49yqUW2HyqBmUo16nf9f5a8aVDlWnFR
         cF2zZvEIkJFeQF+t3WiqDo5ItZ5mv7V8hM5+VljSC/mMOE5OG6KXB1yhXkSoc9iv/4ZQ
         9sXQTGAsT9Jo05g5MkvJj0fjkQYC3Db1/Ivi2K6i0CkwH4D3PJde4Pu3+ngsHjpnLb5x
         A+NxgDzh5Ndyhhvy8+MELvKHmtsGVC7ZH2//M6MuXNrgTkp2PUmViebkNYOlv9G09cHO
         ooyg==
X-Gm-Message-State: ACgBeo2XpQ8j4zq5+z4DjHwdKtqSrZtta4RL61+XkZurvUdAz1rg2yKh
        r9xAY/BqEJczqZHaxNPQ5dQ9oR2pgA==
X-Google-Smtp-Source: AA6agR4Io04Wfi0JujSmtHYwI26uCjhiVk12ETiJlfYWLj7n8Wpojnv1/TWF22qYzBEYDbsZ6Rc16g==
X-Received: by 2002:a05:620a:102e:b0:6cb:d59c:812f with SMTP id a14-20020a05620a102e00b006cbd59c812fmr3278843qkk.232.1662678955062;
        Thu, 08 Sep 2022 16:15:55 -0700 (PDT)
Received: from bytedance.attlocal.net ([130.44.215.155])
        by smtp.gmail.com with ESMTPSA id n72-20020a37274b000000b006cbc40f4b36sm92134qkn.39.2022.09.08.16.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 16:15:54 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net] tcp: Use WARN_ON_ONCE() in tcp_read_skb()
Date:   Thu,  8 Sep 2022 16:15:23 -0700
Message-Id: <20220908231523.8977-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87r1169hs2.fsf@cloudflare.com>
References: <87r1169hs2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Prevent tcp_read_skb() from flooding the syslog.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8230be00ecca..9251c99d3cfd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1766,7 +1766,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		return 0;
 
 	__skb_unlink(skb, &sk->sk_receive_queue);
-	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 	copied = recv_actor(sk, skb);
 	if (copied >= 0) {
 		seq += copied;
-- 
2.20.1

