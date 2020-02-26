Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B994F170C7F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgBZXVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgBZXVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:21:50 -0500
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 344972467A;
        Wed, 26 Feb 2020 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582759309;
        bh=4kwyzbpvr7vWE8Rkz8OM3tUfLuGWTzQAoQSRn1f9Hmw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RTkxKDy742BMtUAGOmkOR0J/iLqcLXNbRaMYj0C47tLLHTy3YMY8aNCAfQ7dDFt/C
         EusJMyCCHnDWmCQ6s5453dMUzYks2YVFnjssRKLiMaw/CpW2DRpq9aSh7Dh2nAnTVY
         m/NaPBPUvwsAHUwmXNtqys7WouLplNGFeMRGjni0=
Received: by mail-lj1-f174.google.com with SMTP id q8so1060965ljj.11;
        Wed, 26 Feb 2020 15:21:49 -0800 (PST)
X-Gm-Message-State: ANhLgQ1c49D8UK44w4yyWyOBxVRBDrwaP0k5Cs+JXRbWHws7OjLueZuU
        Fr+2AxEqoWV/ijCz4pyYPD87Bi75EV25X6RJK/w=
X-Google-Smtp-Source: ADFU+vutSYHS0t5xWLgqz0d3MzeugrytSNZKCn//PAkP05hUICsFD3/z1fiyvVKFuobzenRP7ETgHM0Rqbxlef+VEa0=
X-Received: by 2002:a2e:804b:: with SMTP id p11mr812292ljg.235.1582759307352;
 Wed, 26 Feb 2020 15:21:47 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-11-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-11-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:21:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7B9cH+593sA8hfCEziGcxyxvT9iMx8NYHZKnOUxkR8rg@mail.gmail.com>
Message-ID: <CAPhsuW7B9cH+593sA8hfCEziGcxyxvT9iMx8NYHZKnOUxkR8rg@mail.gmail.com>
Subject: Re: [PATCH 10/18] bpf: Re-initialize lnode in bpf_ksym_del
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When bpf_prog is removed from kallsyms it's on the way
> out to be removed, so we don't care about lnode state.
>
> However the bpf_ksym_del will be used also by bpf_trampoline
> and bpf_dispatcher objects, which stay allocated even when
> they are not in kallsyms list, hence the lnode re-init.
>
> The list_del_rcu commentary states that we need to call
> synchronize_rcu, before we can change/re-init the list_head
> pointers.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
