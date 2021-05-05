Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75F33747F6
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhEES1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhEES1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:27:14 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF743C061574;
        Wed,  5 May 2021 11:26:17 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id m9so3953875ybm.3;
        Wed, 05 May 2021 11:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+l/giID162YkmfJhZa5buIKPUEhcQTCmhJqvDXiCWU=;
        b=S6YYNa4uBmZgAuD9X1mr3pbPH53S/sC583SU1p2o8oP8ZoUpfpigeS+CCkawRs5ZYT
         U21XIrMtZfP6q0CAsy4IC23fF5IwBwhY5uE0g0K6BYpNetNOmIlxmoC8Qc9qP8cRhzz5
         Rn5FchgDdx/OqXVvkPU+oEJFJ40YC8cuYVbd7tmEWYB6KwJHD49XSwHVusEu+NYxeuOC
         QoztqmMc6B1x4ZufLLeuKQSw9ql+HmekAz7YpKRbKXsaEPfkAsSEJwyvgQHBVvOnSyfP
         QiwEkRfwFEq61E1X3XJ/V8woEPo4soKeC2qIpDjt0Tv1n9++0q7gkGRebULZgE1UhNmi
         jptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+l/giID162YkmfJhZa5buIKPUEhcQTCmhJqvDXiCWU=;
        b=GuJUxinm+PGwno0c9KVLU9KXFmvRs9mY2O2EwhWvvCkAvFWRflyWlYYz5AUCHdzeA3
         pK/uxvkJql7VkP7iDX1Cb5ffXVwpewV2RkVGEnxmlbF5F2uh+catu9zmEdlpSz3tIhdY
         a35vmGWoijmwaF5xLjb1UtGpH4CsX8rsxBRd/d3U+NR2yjdcy2Ub3E5A74U1xZZ85hnA
         CC5AwvZpMBpT0vOaZ/A3vAewJ1BHSP4Md0LhVurCicD+y4o2ivpXBB4UrDJhXvFE7Vle
         iXKWYuX04xhCj1ibSd4bDwqrrPjzX7SKN+XFM9KoOH1GLqgd7O/TFxhDPtstSMUHbAxl
         QsKA==
X-Gm-Message-State: AOAM530eferNNQamCmG9V3lJb6jEAOxAqcP0Y/wD1d8nscOLufYIb078
        sRTjF6ltV7n5q2ZnaUNM+w5D7Ela2uHyyHW0Jbk5tKgUV5c=
X-Google-Smtp-Source: ABdhPJw/o+nlKC+GGXdAhIGw1+unQmrpjLJJpj/6uKgyVkzVkRMjOvyTSRimzl7rekkF6KlYtplLknFVkbzx28WTlUY=
X-Received: by 2002:a5b:286:: with SMTP id x6mr71494ybl.347.1620239177095;
 Wed, 05 May 2021 11:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
In-Reply-To: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 May 2021 11:26:06 -0700
Message-ID: <CAEf4BzYSDv17nWRPd0RfnjuUsJSwQOx_79ubrGvX6aGyGzA1Ow@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/2] bpf, sockmap fixes
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 3:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> This addresses an issue found while reviewing latest round of sock
> map patches and an issue reported from CI via Andrii. After this
> CI ./test_maps is stable for me.
>
> The CI discovered issue was introduced by over correcting our
> previously broken memory accounting. After the fix, "bpf, sockmap:
> Avoid returning unneeded EAGAIN when redirecting to self" we fixed
> a dropped packet and a missing fwd_alloc calculations, but pushed
> it too far back into the packet pipeline creating an issue in the
> unlikely case socket tear down happens with an enqueued skb. See
> patch for details.
>
> Tested with usual suspects: test_sockmap, test_maps, test_progs
> and test_progs-no_alu32.
>
> v2: drop skb_orphan its not necessary and use sk directly instead
>     of using psock->sk both suggested by Cong
>
> ---

It might be that this didn't fix all the issues. We just got another
sockmap timeout in test_maps ([0]).

  [0] https://travis-ci.com/github/kernel-patches/bpf/builds/224971212

>
> John Fastabend (2):
>       bpf, sockmap: fix sk->prot unhash op reset
>       bpf, sockmap: fix incorrect fwd_alloc accounting
>
>
>  net/core/skmsg.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> --
>
