Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7BA4E6485
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350693AbiCXN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350704AbiCXN6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:58:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115F3AC050
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:12 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s72so3896302pgc.5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C9IFYkBGuzKbL28L1rHzFqw4YhVBXw9SnxPDKRTeCl0=;
        b=ZDnKo8pvdMNduuF+lU4NDjChbSzvTibwMNeESnQfLWMT1WxMleFk3N4ansFkOXlIRC
         EpMfeFhj0s5wJ5uXTSFRrJF15KbEZNS4kpuP51AEQ2ryl1sbiL0H8z9ttGk9Z68xI4mf
         ZdDyJ0gu0EM6zZC44KSRmOyFkbYWX/jnNNLFQfHpO3HnMSCAAyh54ccBLDfWJ0Uiu4PE
         aqeXLOit+lU1BBRVGhx2e5Ncu5u5cVSlrlieACC88SKfl1jhowAhNHDruuEHbqRUBLdg
         jNkA/wWFbndwUsKRlU0jmH7AM2aTg6ZLUofbWYecP9VBZeEwqRUKAg/dKLyZlct+SfK/
         rnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9IFYkBGuzKbL28L1rHzFqw4YhVBXw9SnxPDKRTeCl0=;
        b=srxU3DbaUI1n1O/GYFyxowImlDRv1scx8V/TQMJl91QQVAwUuMa+RyIBDc44wAEB+y
         2yxa2n/spihQpnYhFdv4erSXDUJgvFeZM1OQuYyAcNT8Cx/yLGznHBWn6y6AzlV4GdzS
         kDTlcDum5Ua012XCnWpZG/aYZRXoB0FdUpwc/rSpUaVs17OAtpRV60XfKulsGEdO7xJO
         zCLjmLwD0Dwq7Emqc3KV3Fxt9KgHQtZ0mBIaZpseBg+XczMGdk/b+vulL2hNFZEz3AAI
         yLZuLReC1LGpi0tnq2QHBNgvT/sOaSz6KSG7fOpuT9d+nF6+RKHbQjwUEQN2Fhm/rkQQ
         P4Yw==
X-Gm-Message-State: AOAM533XEfHv7R0wT91K0ElyeB0E6FR2W1WQQgUwkK6R1KBG9kCRCirq
        e0WcdFOtDzSoVn7rzVxSVND7+YVFdY3V9g==
X-Google-Smtp-Source: ABdhPJzOTzTvGPULs0PSeVyiFgJsEiy3o8SZBJc8YGypSYEPM/4DMHtHraF/D8ISqZ9OLqDHkt96fw==
X-Received: by 2002:a63:4a09:0:b0:382:597:3d0d with SMTP id x9-20020a634a09000000b0038205973d0dmr4207398pga.18.1648130231255;
        Thu, 24 Mar 2022 06:57:11 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2a0900b001c6e540fb6asm3282991pjd.13.2022.03.24.06.57.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 06:57:10 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net v6 1/2] net: core: set skb useful vars in __bpf_tx_skb
Date:   Thu, 24 Mar 2022 21:56:52 +0800
Message-Id: <20220324135653.2189-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
References: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
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

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We may use bpf_redirect to redirect the packets to other
netdevice (e.g. ifb) in ingress or egress path.

The target netdevice may check the *skb_iif, *redirected
and *from_ingress. For example, if skb_iif or redirected
is 0, ifb will drop the packets.

Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index a7044e98765e..c1f45d2e6b0a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,7 +2107,15 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 	}
 
 	skb->dev = dev;
+	/* The target netdevice (e.g. ifb) may use the:
+	 * - redirected
+	 * - from_ingress
+	 */
+#ifdef CONFIG_NET_CLS_ACT
+	skb_set_redirected(skb, skb->tc_at_ingress);
+#else
 	skb_clear_tstamp(skb);
+#endif
 
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
-- 
2.27.0

