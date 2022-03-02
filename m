Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50224CA9F6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbiCBQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241289AbiCBQSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:18:14 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54BADFF6;
        Wed,  2 Mar 2022 08:17:30 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id z4so2029171pgh.12;
        Wed, 02 Mar 2022 08:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NEIR/7K1s5SDBS74dA3+Y+CfCaE7Ky5QycYBnqqINX0=;
        b=Ha+XagQsMacjhkbXnL64JKc+CZBwxnYxmXFTox8j+vtCx6mMcSdUrx/nunnzr3GKrJ
         aswA8xCKNLW8R79BwUzLvnrcG+QeASYfeSYk5hl4AlycJqGREAUqXae1nhMW3AU6+N4e
         DoODIgvR6VfBGmU+Eex59FweaJlVTBBKcQf8VAv2AV4MRGPdPukMJUoqepNeYIGeXEmx
         +oIsiMJqXt+1wJF5yS+63YhiGNdOzMMJTAsmNIljzYhadrxLADevHSVOjZij8YYcBusH
         JhmUVPhdeR3k1N4ETiBKmwmL+9d/dKdSmLtaddBparxepmra6iV24sudQBtc954ff8gp
         Jtrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NEIR/7K1s5SDBS74dA3+Y+CfCaE7Ky5QycYBnqqINX0=;
        b=EvEyUyHyXhzIo8EkpYB5FYABCZR7I6ZxoOzQRurAvS05APDiGYnDN1qteUv7EvJTZ1
         pR6BE49SUhFIZdLMkFQZtoXEaoi9yXo2RcmKh0zDTuvvUfzZD7BP5BgANcNpZsKF5R4D
         RSa8c9pNoo1vmbam3IQxTGmC/mOq3eEZoMP9pIo0TeKwngxmGXrVaNUC+/2PTG1EI0cV
         UKy0WYGoTcMSDA06uJBtJTOghudG2/VCeB+joJyIagZXStSH8MSq/VaDBpC5nE3rFd9j
         VjVLUln/n1rdcY6bSpNEF98U4g9MznFMo2Ch0LFuFTsd0yhx/+b4bdn0upyR2VZ8CzkL
         Uczg==
X-Gm-Message-State: AOAM533QqISlDnUO2fNHROTJgEDNxJbGpx4xGS6qGtpZBz5Ue0ZMpNs6
        0RFAkVZiwKxlvxHIexJmLVv8LH9oz2Y=
X-Google-Smtp-Source: ABdhPJzIcUsRPPvxop3yyNgUUT2Wrry/q9exPCghkTe3ylpYlLe+sowBJqGGcANUGkZO1W0j8uoJvw==
X-Received: by 2002:a05:6a00:1a8b:b0:4e1:4151:6637 with SMTP id e11-20020a056a001a8b00b004e141516637mr33883387pfv.23.1646237850250;
        Wed, 02 Mar 2022 08:17:30 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7e41:847f:4bb0:a922])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b004f1063290basm21771704pfu.15.2022.03.02.08.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:17:29 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] bpf, sockmap: Do not ignore orig_len parameter
Date:   Wed,  2 Mar 2022 08:17:22 -0800
Message-Id: <20220302161723.3910001-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
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

From: Eric Dumazet <edumazet@google.com>

Currently, sk_psock_verdict_recv() returns skb->len

This is problematic because tcp_read_sock() might have
passed orig_len < skb->len, due to the presence of TCP urgent data.

This causes an infinite loop from tcp_read_sock()

Followup patch will make tcp_read_sock() more robust vs bad actors.

Fixes: ef5659280eb1 ("bpf, sockmap: Allow skipping sk_skb parser program")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8eb671c827f90f1f3d2514163fc82998c9906cb6..929a2b096b04e01b85bff0a69209413abe86102d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1153,7 +1153,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
-	int len = skb->len;
+	int len = orig_len;
 
 	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
 	skb = skb_clone(skb, GFP_ATOMIC);
-- 
2.35.1.574.g5d30c73bfb-goog

