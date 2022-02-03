Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5641B4A8CC3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353887AbiBCTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241750AbiBCTy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:54:58 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E658C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:54:58 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id p5so12142973ybd.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPNU7J+/3w4DhXKcO0WJyLtPcPjba9kfQaHUhUfYOdE=;
        b=ZiXC+Mz6s96JxK1TclBveZkm73bHNHAyWplcrjeM11xweJHlqPk+WquFaiFME9Gnf5
         YECTvlAVaMqoPlRIczIRU464SunzbJfWyU34wZHmj99j9XX1p3l/1jfHIwiSb7edN8/o
         GLo8kBH3tU3lE0cKlZTJNjHNjZBK530xtJmtruWd/eJO0VFm3EtTFMQaUk453zTbfO5R
         DDRmhPwXmJu89XNWUZVi2NOx6L5O2E5h7xHjtHxLKWeF2xDcJoFbqs228Gvsq1vwTQFT
         AlTCP/JkPdq2LB9wLHLVrMEDhfsIXKn6XzV4LDneqbHqhMSxQzmE1uIH1Jolv5Ql5/YJ
         D/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPNU7J+/3w4DhXKcO0WJyLtPcPjba9kfQaHUhUfYOdE=;
        b=PTBWaCoP+XIivMjGCE1bw4HzJdJlGRBARTyqPGjPN6HqNQ3JlHLgWD/rBYhniZD0/F
         6FSW2zc3Z3tBzLr2YA492dZ+0eQCwyOZ/SiNCRCIu6f9ReLWpK42BrC5pBiSxcmkqoWj
         zqks8b4eDAkJ82VxPjceHtoIXvt2Mdn3Dg9rEPU0c+YbEqnYrpsFP9/8yJHQ2WdavHKf
         VbNOcpPWRl1NHNGtpDFBtn6EHuI+qsDQCwhPL/ly8za2apClsUzDdaYu5VC1IP5oJrgE
         KRRHWWsSjuqQcRoFm8PMgZHyHkfQT5EQmCPj7lsXk9AFH940OZzggjP8nsm7Epkzh/Ff
         Hciw==
X-Gm-Message-State: AOAM531AWojht5gsXyXGKXagU85SpazopJMZGVvnxijnEEFbwwuogeKE
        24GptSpxYEDo31YRe+RQGIwxDZFWPFM+l5F/8N6TiFt/ksq2dGnonmY=
X-Google-Smtp-Source: ABdhPJzgQVe5PELKeMID9hHUSndRDhr7G3g2XAHXtLIvnwzNzGLOADLoWqwMYvYyWrsqEUJA7jyjdaAxdHwy2Kax3cw=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr48668893ybb.156.1643918096799;
 Thu, 03 Feb 2022 11:54:56 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com> <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
 <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
 <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
 <20220203111802.1575416e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89iL3_6Vkj6Gq8vuMmC=pbAS+Zbe4hFaXgSEpyKhzfgh+dQ@mail.gmail.com>
In-Reply-To: <CANn89iL3_6Vkj6Gq8vuMmC=pbAS+Zbe4hFaXgSEpyKhzfgh+dQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:54:45 -0800
Message-ID: <CANn89iKMa5fT3HhKdO2K=WFxwBsRBr_HN=sxPDqX-MJvWyoz5Q@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:20 AM Eric Dumazet <edumazet@google.com> wrote:

>
> Another issue with CONFIG_ options is that they are integer.
>
> Trying the following did not work
>
> #define MAX_SKB_FRAGS  ((unsigned long)CONFIG_MAX_SKB_FRAGS)
>
> Because in some places we have
>
> #if    (   MAX_SKB_FRAGS > ...)
>
> (MAX_SKB_FRAGS is UL currently, making it an integer might cause some
> signed/unsigned operations buggy)

I came to something like this, clearly this a bit ugly.

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 08c12c41c5a5907dccc7389f396394d8132d962e..cc3cac3ee109f95c8a51eb90ba4a3bf7bebe86eb
100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -323,7 +323,15 @@ enum skb_drop_reason {
        SKB_DROP_REASON_MAX,
 };

+#ifdef CONFIG_MAX_SKB_FRAGS_17
+#define MAX_SKB_FRAGS 17UL
+#endif
+#ifdef CONFIG_MAX_SKB_FRAGS_25
+#define MAX_SKB_FRAGS 25UL
+#endif
+#ifdef CONFIG_MAX_SKB_FRAGS_45
 #define MAX_SKB_FRAGS 45UL
+#endif

 extern int sysctl_max_skb_frags;

diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0287de3c32040eee03b60114c6e6d150bc..d91027a654c2aad7bfa55152ef81c882bf394aff
100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -253,6 +253,29 @@ config PCPU_DEV_REFCNT
          network device refcount are using per cpu variables if this
option is set.
          This can be forced to N to detect underflows (with a
performance drop).

+choice
+       prompt "Maximum number of fragments per skb_shared_info"
+       default MAX_SKB_FRAGS_17
+
+config MAX_SKB_FRAGS_17
+       bool "17 fragments per skb_shared_info"
+       help
+         Some drivers have assumptions about MAX_SKB_FRAGS being 17.
+         Until they are fixed, it is safe to adopt the old limit.
+
+config MAX_SKB_FRAGS_25
+       bool "25 fragments per skb_shared_info"
+       help
+         Helps BIG TCP workloads, but might expose bugs in some legacy drivers.
+
+config MAX_SKB_FRAGS_45
+       bool "45 fragments per skb_shared_info"
+       help
+         Helps BIG TCP workloads, but might expose bugs in some legacy drivers.
+         This also increase memory overhead of small packets.
+
+endchoice
+
 config RPS
        bool
        depends on SMP && SYSFS
