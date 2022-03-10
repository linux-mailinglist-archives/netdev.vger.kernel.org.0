Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC54D554C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344673AbiCJX07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344659AbiCJX05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:26:57 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CE0199E3D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:25:55 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z4so5966013pgh.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ejJjmdbNGVk0Ojn9gs31SAw6IuTYvfqq7ug7NCCkkt4=;
        b=onIx2e9X0TzzdYS9bDwjnzCQL6eZTBbf+XJonIjFE7H559YPkcY+EhmcsSUTYccP7P
         SJhQkA9/eitkZ6RjDtU8Casbh0s5w49mbQFTWLMchOLcU7UVtTkD54CeHJL02skXriet
         PElVeFd230TUHFlwda1A5LSJhaSTD+Bxgbibu/IKEXmZ3J+nggAKvfIS3QhoOtknOwKs
         QKEIoTVTIi/ZmcjBt6AMvlUYOomvLKkOEmN2AJpl/yhf31HAVBpWthxNzm7juMSUt8dw
         DXE48U7DiDyM87kNgix+yq6u8HeLPvQ6BLJxv/YvFub9TgJMoM1intVwQvSH9rQM+b2Q
         9MVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ejJjmdbNGVk0Ojn9gs31SAw6IuTYvfqq7ug7NCCkkt4=;
        b=r1NCEgfApQ2dqiDdHbjsaw27jA7sPnZkd7be+HTy/kOfw7mPvgI0zy1U1lV0dnEVfu
         SUGeRLeyky+ouOPNS15YAek2Z84TiGivW0Q/su8ewqRoBaUOfNR8mmwGRmTXg7ilgfO4
         /CynUzm6ylAvDppTmTY5u6nzYBdZxVg4cSqc+Woo+6NWPFvGMHu97AwYayr9V4pBWDsh
         DInsxlsAPiiptPXUkzd6WxUzhto5eClsR/U34MqBL8dRx7sH0QZ7yn4if0dqTs6HjLWl
         MaK0Ly3F1V/SOw7uQvuAEE4PsynCkuvziE2Tz3QeLKV6QFNdIePQzZwwwBmvR4M2uPAE
         YUzA==
X-Gm-Message-State: AOAM53010Gx+kO1ZmxdtGP5igEz1Ha11ftPtk9T33WKAfHH0MAnfG4RE
        lgs+rOhxX6Li+YBA7LKrgcdeYQ==
X-Google-Smtp-Source: ABdhPJzv6gLDrKCUJmstikLr5c12MnrtNWMmsWP1SNNEHRV+MGXn9BOQlivb1Lqc4nAFEDZ9B4Opyg==
X-Received: by 2002:a05:6a02:10a:b0:37f:f691:b094 with SMTP id bg10-20020a056a02010a00b0037ff691b094mr5995278pgb.184.1646954755255;
        Thu, 10 Mar 2022 15:25:55 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a4cc400b001bf0d92e1c7sm6995703pjh.41.2022.03.10.15.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 15:25:54 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     kuba@kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Subject: [PATCH v3] net: ipv6: fix skb_over_panic in __ip6_append_data
Date:   Thu, 10 Mar 2022 15:25:38 -0800
Message-Id: <20220310232538.1044947-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
References: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a kernel bug in the ipv6 stack:
LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
The reproducer triggers it by sending a crafted message via sendmmsg()
call, which triggers skb_over_panic, and crashes the kernel:

skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
dev:<NULL>

Update the check that prevents an invalid packet with MTU equall to the
fregment header size to eat up all the space for payload.

The reproducer can be found here:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2: Instead of updating the alloclen add a check that prevents
    an invalid packet with MTU equall to the fregment header size
    to eat up all the space for payload.
    Fix suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>

v3: Update existing check outside of the while loop.
---
 net/ipv6/ip6_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4788f6b37053..194832663d85 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1476,8 +1476,8 @@ static int __ip6_append_data(struct sock *sk,
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
-	if (mtu < fragheaderlen ||
-	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+	if (mtu <= fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen <= sizeof(struct frag_hdr))
 		goto emsgsize;
 
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-- 
2.35.1

