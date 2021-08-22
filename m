Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F853F409B
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 19:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhHVRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 13:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhHVRFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 13:05:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC27EC061575;
        Sun, 22 Aug 2021 10:04:28 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s25so9662836edw.0;
        Sun, 22 Aug 2021 10:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUhcEqU+ZOQSh1pqtcVaDKol4jZl9qqosLL03IwQCwI=;
        b=SRURG8Ghxgf5zrl/KaywI4BeZ6O6ZKJ/YWBoWfw95lgv1yIX38ujGtFadm/yWGRWyY
         pA4q+PMZ6hT/63AyNXzHJaprwRpH9aZm1lVXZSS1Gt3PjfhyONRPF78zB0pLI+yqZoFz
         3h9J88w6UdMWzKCX0vC53H+ZLfYxiatFuVYIDpgdLhhX8kPi/Vzfz6Uz2zEvuuraokd/
         wfZacbH06ThR+6r6RltOisIArPam00kaYeBBvzau99L0q7Qnzs363rz3v972bDFn0iUW
         4d79ghP8VPvnpIJnHMIGPfgS86dlfxc+FPCIwghszS7BdxxmsYeRpRpTre46L7/ljTCF
         BfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUhcEqU+ZOQSh1pqtcVaDKol4jZl9qqosLL03IwQCwI=;
        b=QcOARvrn+6ix/rlazamaHrz4zIdxg5kOUP8IB2IiESej6HIeaobbxXBZUH3Ao3rG9L
         ceBgNXtSoWrO1CO9yUKy32h7wdLbM9qkUHHc5EB4cAKMt5rxAU+7a22zzMin3A3xYFUC
         LR4d48eNSXyrk1r5sTWH0FScNcV8oM9h/v24jJn30pra4X3Z8sM0jJX/CEtfiiJTub6Z
         aX25K3VHIf1q3ZVUd8K/l1RiRDaOk8oaYPVUdZjBJe9x6oXtETdHUmZvUZ6cwa7jTZRm
         qLKimDkYCkNllXLmFMbDuuDNKbq4R/j6nd4PluzFdUKdW+j+punE1YfaFCLnJQ5idgAh
         3RVQ==
X-Gm-Message-State: AOAM5302LOAZL3KcYctSqjB5lj1yBF0En/ZLWbfhhI+EAAv6zc7u5mZC
        xNdDJxWJUWfTgB4xwCVDMCv/WKVtA8NF50FCeV0=
X-Google-Smtp-Source: ABdhPJz+Rhplwjyhy1l+jgu+LHSgx/fM/lmZPSaoqLXETlHorGhUoDm8C4GnJ9XjXSJoeidJAjOsVAEUOZbjqO5Eqpo=
X-Received: by 2002:aa7:d681:: with SMTP id d1mr33905628edr.186.1629651867490;
 Sun, 22 Aug 2021 10:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com> <77f3e358-c75e-b0bf-ca87-6f8297f5593c@virtuozzo.com>
 <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
 <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com> <ff75b068-8165-a45c-0026-8b8f1c745213@virtuozzo.com>
In-Reply-To: <ff75b068-8165-a45c-0026-8b8f1c745213@virtuozzo.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Sun, 22 Aug 2021 10:04:16 -0700
Message-ID: <CALMXkpZVkqFDKiCa4yHV0yJ7qEESqzcanu4mrWTNvc9jm=gxcw@mail.gmail.com>
Subject: Re: [PATCH NET v4 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vasily,

On Fri, Aug 20, 2021 at 11:21 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> On 8/21/21 1:44 AM, Christoph Paasch wrote:
> > (resend without html - thanks gmail web-interface...)
> > On Fri, Aug 20, 2021 at 3:41 PM Christoph Paasch
> >> AFAICS, this is because pskb_expand_head (called from
> >> skb_expand_head) is not adjusting skb->truesize when skb->sk is set
> >> (which I guess is the case in this particular scenario). I'm not
> >> sure what the proper fix would be though...
>
> Could you please elaborate?
> it seems to me skb_realloc_headroom used before my patch called pskb_expand_head() too
> and did not adjusted skb->truesize too. Am I missed something perhaps?
>
> The only difference in my patch is that skb_clone can be not called,
> though I do not understand how this can affect skb->truesize.

I *believe* that the difference is that after skb_clone() skb->sk is
NULL and thus truesize will be adjusted.

I will try to confirm that with some more debugging.


Christoph

>
> Thank you,
>         Vasily Averin
