Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85AD4BB438
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiBRIcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:32:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiBRIco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:32:44 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC425EA6;
        Fri, 18 Feb 2022 00:32:28 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y11so1771984pfi.11;
        Fri, 18 Feb 2022 00:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgdlyhNIvtAukMCB9p+w3nagDPuFMbvyfD2Rz3/nNMQ=;
        b=qXyadzniFJOfhRBYAKfqrSomXBnkvK/Ai3Oflic3yqBYaekSjrGhSXYElON5LYhZ5m
         s4Z+y+r+jvLVsvrgl+nm0Ed7ovIF6AQDmguNllxJSvywMA4KZ/1kKzLCkShhy3NNRJ5g
         oldQ0aR6TzehoPtZDUvHHOXkcn28k5S6BhXi1Bj3num2rfNODvHCNnvOUs0TYl5b2DfS
         6JpPAktdLF0pNaJydzdxmhW91C9n526Eu/mz9s8jZoSrK/aVRvRTXw/DkErOz/LADNcC
         ZZO84CBPg90UWaHRH/vjKwRPYmlH2F6+EKpJ5xyuTtMelWoyKULeuPDyt8Oih9U1IwWB
         8MPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgdlyhNIvtAukMCB9p+w3nagDPuFMbvyfD2Rz3/nNMQ=;
        b=YXIq5zn4iq+vrqZ6Ah21Htds9MNfqFMdXG1p9uArA7SBQ8sPFrMDKzNu5/SRQq/vj4
         0Ohs15PUBbPKDWuHGzNjcfhWKkkOPz+PHpndsSwNO+R0lVJBJ7CS6xGBjPZQeoXrdPlL
         rdXW3TJaaWwwUBz2CSHnpTsmhgjwJbJdjB0hbrjIsMiymfcQAsosb8eu/c8oLY8ylYkH
         IWGQ2zQh7c4VHtiOyEuhjLUgFpcA0wVeK2F1mdv46wHt05VPsTD6xV+8pCGfdMGbi17D
         vgRyET5koBNsT7+OahlDUnBkoaF+Lt2i34gguqlMwIYRp9cdCb5IcQgVCm1+ubj6lW0f
         lOtg==
X-Gm-Message-State: AOAM532WIbk+M4Nrh6GMbBvzvGD7qFDtsbDN2QaXWeF53qjagDJ0Af0c
        LAhqyzg6SwfkD0yyAoKQAEI=
X-Google-Smtp-Source: ABdhPJyT0dh3bXiuZ71M4x+8NPtNL7vA/3YVOxWQ+/iLO9jYZMnaNjGZosV9F2uZ9cH2zqt1AoNumQ==
X-Received: by 2002:a05:6a00:1591:b0:4f0:ef0b:dc24 with SMTP id u17-20020a056a00159100b004f0ef0bdc24mr1102419pfk.2.1645173147717;
        Fri, 18 Feb 2022 00:32:27 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:32:27 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next v2 1/9] net: tcp: introduce tcp_drop_reason()
Date:   Fri, 18 Feb 2022 16:31:25 +0800
Message-Id: <20220218083133.18031-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

For TCP protocol, tcp_drop() is used to free the skb when it needs
to be dropped. To make use of kfree_skb_reason() and pass the drop
reason to it, introduce the function tcp_drop_reason(). Meanwhile,
make tcp_drop() an inline call to tcp_drop_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af94a6d22a9d..0a2740add404 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4684,10 +4684,16 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
+			    enum skb_drop_reason reason)
 {
 	sk_drops_add(sk, skb);
-	__kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
+}
+
+static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
+{
+	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 /* This one checks to see if we can put data from the
-- 
2.34.1

