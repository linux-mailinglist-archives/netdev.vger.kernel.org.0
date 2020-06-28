Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D420C8BE
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 17:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgF1Pky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 11:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgF1Pky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 11:40:54 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F28C03E979;
        Sun, 28 Jun 2020 08:40:54 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t25so10819146lji.12;
        Sun, 28 Jun 2020 08:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HarAlCwkF8vycmbAHhvY+j2zfx6VqJcDXojxN9P70YM=;
        b=KYPNsOZqWLJ2rQsDuMy01cwUz2FM1jZknJRHkAjPh06+ZXp8Ny52TY6BSF0jw3Ad11
         R3AGewzbR7A4KSdB3bOQh8V2tmuUpDN0r26MLSCKeMnoMA+lS/Q1Huw8gV3k/pvs9FoZ
         tS9wLC16+gf61DhluaSQmn5CrE9y+CysXm+nz4KLjJgt4+39RvKoN7N5RltlsrJFR0iB
         L6LACKaAKGWbJWEleDhwp4cjsxkpDnxKhXV2xy62MjmCyOgbzQEtLAcNFNYW0AM3nTxK
         GEN35fWW3/BV7XX7z+hm91fXGErxh+le0PUd2w4lG0VT9lQGkQxRdONp6aNOGHQBDowN
         dq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HarAlCwkF8vycmbAHhvY+j2zfx6VqJcDXojxN9P70YM=;
        b=FhmyJR4FgkbHc3Mnq4NEbAo6yW1dla4gfrxArK/zphg2Ji9jcG09Tmmo0Y0qZ4gbAy
         nLuJB+JdzsJ9R00VTBGIx07igYbCaB5yz+jUbJwk83wo8IHDf3VjUWkPjUedQUqj3rTO
         /rug3wA+TNXNYauR5UErXJDvmMScSrvFzf4zYvW8k2vbVI5Tkov4IHGxguvjoAF57clg
         4+YZYoa8p/Bna1y+yWUY7LRPT9PAqdXBZnED0jkIqAh/AhR3LexpClO5tPj6XZ2JM+j2
         kilOCkDcOtIdT9ELjSfb7/Ze6vPT9qG476qEtd6GUgg7VMEjnED2FE5advTlF3mQZW//
         5z2A==
X-Gm-Message-State: AOAM5332GzCLzEgG9h1zLVp5qxWrSnJj7oYBBFyt8Yk/gZnaLlS6m7ZY
        09lyJ6ET1VPwYXNmRr+3WlLRa6wk7rpYYKtq8Oc=
X-Google-Smtp-Source: ABdhPJyYCCY9odZ98IgDnOOrtmExRX89Tkxvkfq4Jl8K9sZRyy4BAeGYN47EvtKIuksgqbNyWB3lQpMwN31NUNeLOvc=
X-Received: by 2002:a05:651c:308:: with SMTP id a8mr4638241ljp.2.1593358852386;
 Sun, 28 Jun 2020 08:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
In-Reply-To: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Jun 2020 08:40:41 -0700
Message-ID: <CAADnVQLJo6PFBm8USM1gbAxFMTE297XbDtvhuFTUYPdJG9WpaA@mail.gmail.com>
Subject: Re: [bpf PATCH v2 0/3] Sockmap RCU splat fix
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Fix a splat introduced by recent changes to avoid skipping ingress policy
> when kTLS is enabled. The RCU splat was introduced because in the non-TLS
> case the caller is wrapped in an rcu_read_lock/unlock. But, in the TLS
> case we have a reference to the psock and the caller did not wrap its
> call in rcu_read_lock/unlock.
>
> To fix extend the RCU section to include the redirect case which was
> missed. From v1->v2 I changed the location a bit to simplify the code
> some. See patch 1.
>
> But, then Martin asked why it was not needed in the non-TLS case. The
> answer for patch 1 was, as stated above, because the caller has the
> rcu read lock. However, there was still a missing case where a BPF
> user could in-theory line up a set of parameters to hit a case
> where the code was entered from strparser side from a different context
> then the initial caller. To hit this user would need a parser program
> to return value greater than skb->len then an ENOMEM error could happen
> in the strparser codepath triggering strparser to retry from a workqueue
> and without rcu_read_lock original caller used. See patch 2 for details.
>
> Finally, we don't actually have any selftests for parser returning a
> value geater than skb->len so add one in patch 3. This is especially
> needed because at least I don't have any code that uses the parser
> to return value greater than skb->len. So I wouldn't have caught any
> errors here in my own testing.
>
> Thanks, John
>
> v1->v2: simplify code in patch 1 some and add patches 2 and 3.

Applied. Thanks
