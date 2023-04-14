Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC68B6E19E6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjDNB6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDNB6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:58:46 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E6E3C15;
        Thu, 13 Apr 2023 18:58:44 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id bs12so4110372vsb.1;
        Thu, 13 Apr 2023 18:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681437523; x=1684029523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dl2518gfS/Q1UTQTLUFTF13BLaNUhIq99/jZxFoVTE8=;
        b=dbFOmnvXWendtqHNWAnIIVQIAq5jJpuLDcEXgMFqI9KaQWq7P5E/IYMfFyG4lMrryj
         GWiDAIG7yiXx2GbkQLiJcfm4WP7f+TG/jGVIdYV4/kv7atqDhOZwQiQEEhLBFxEJyNNJ
         Uf0nPRy0nNqI7zzcmYYtMATxZgrJhhcrCAWm0USCkRQvkzupQVv5xNqjv00vGBGzSE2Q
         zU2QSSe4VhBo9fed9Z8lkZpM4K/6vsxBRt2jyGtFITzTK1Z3nvQ0gj/IY2wt7L4ugiog
         xaGZQ+lkOAvAYeCxylJ7eET8v7HZVcFKyXIbKBsD9gkpBaDNBRcLaAtdYGlp12okckka
         JRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681437523; x=1684029523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dl2518gfS/Q1UTQTLUFTF13BLaNUhIq99/jZxFoVTE8=;
        b=M9/Aqie5qRcpA8PFnzrnOe7NxNCodM+qwdu8qK5gYyVq2Hq/FJwjc6Ps5w7uh5cLbZ
         Y/OFx1e2bkuRIeLD05/V8SZNakFx5yLWy2Mt6pfyau1mjSwfiaHz3zIk/yMQtxO9xRNO
         Rfxk9bQXg9HkAh124kW7NMjqdBmjRArnBDowF4gqBbj9CKBrgiWxTW/jm1Nwkqgaei3l
         60P8TnSHFVXg6Qz0Zwf+JxizaNGeTdQInM/VR/Y+ykmKL/cSD2KE9JutOeg39Lf3YcBV
         KoD3UOTD38CXS1scCYJ+DU47J6e+w1/9bHImYGqHUaHLOTZKNJi1BT9ryXuaest/9Qtk
         xMtA==
X-Gm-Message-State: AAQBX9dWqLf9nlajDB5Of7HzDSKu5zd74PnkwptHgaNlKiIHruI9m6qP
        4jAiEPt7fnDED6wBKZ0sTaihH5UcRpA4PJDIV0M=
X-Google-Smtp-Source: AKy350aH2AiuehJLLHPE1eL6DWbiGgRPxKkogH1PjK+GLiQpdjGXhs2/nf2wZfpm5URgPMnp+kW/pzZBtynhNAxrCSM=
X-Received: by 2002:a67:d496:0:b0:42e:3c2e:10bd with SMTP id
 g22-20020a67d496000000b0042e3c2e10bdmr590487vsj.1.1681437523577; Thu, 13 Apr
 2023 18:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com> <d2519ce3-e49b-a544-b79d-42905f4a2a9a@ssi.bg>
In-Reply-To: <d2519ce3-e49b-a544-b79d-42905f4a2a9a@ssi.bg>
From:   Abhijeet Rastogi <abhijeet.1989@gmail.com>
Date:   Thu, 13 Apr 2023 18:58:06 -0700
Message-ID: <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon, Andrea and Julian,

I really appreciate you taking the time to respond to my patch. Some follow up
questions that I'll appreciate a response for.

@Simon Horman
>In any case, I think this patch is an improvement on the current situation.

+1 to this. I wanted to add that, we're not changing the defaults
here, the default still stays at 2^12. If a kernel user changes the
default, they probably already know what the limitations are, so I
personally don't think it is a big concern.

@Andrea Claudi
>for the record, RHEL ships with CONFIG_IP_VS_TAB_BITS set to 12 as
default.

Sorry, I should have been clearer. RHEL ships with the same default,
yes, but it doesn't have the range check, at least, on the version I'm
using right now (3.10.0-1160.62.1.el7.x86_64).

On this version, I'm able to load with bit size 30, 31 gives me error
regarding allocating memory (64GB host) and anything beyond 31 is
mysteriously switched to a lower number. The following dmesg on my
host confirms that the bitsize 30 worked, which is not possible
without a patch on the current kernel version.

"[Fri Apr 14 01:14:51 2023] IPVS: Connection hash table configured (size=1073741
824, memory=16777216Kbytes)"

@Julian Anastasov,
>This is not a limit of number of connections. I prefer
not to allow value above 24 without adding checks for the
available memory,

Interesting that you brought up that number 24, that is exactly what
we use in production today. One IPVS node is able to handle spikes of
10M active connections without issues. This patch idea originated as
my company is migrating from the ancient RHEL version to a somewhat
newer CentOS (5.* kernel) and noticed that we were unable to load the
ip_vs kernel module with anything greater than 20 bits. Another
motivation for kernel upgrade is utilizing maglev to reduce table size
but that's out of context in this discussion.

My request is, can we increase the range from 20 to something larger?
If 31 seems a bit excessive, maybe, we can settle for something like
[8,30] or even lower. With conn_tab_bits=30, it allocates 16GB at
initialization time, it is not entirely absurd by today's standards.

I can revise my patch to a lower range as you guys see fit.

--
Cheers,
Abhijeet (https://abhi.host)
