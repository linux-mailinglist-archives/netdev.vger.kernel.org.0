Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5596839D23F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 01:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhFFXko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 19:40:44 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:37748 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhFFXkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 19:40:43 -0400
Received: by mail-pl1-f175.google.com with SMTP id u7so7646421plq.4;
        Sun, 06 Jun 2021 16:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46M8XUzBewi0sCNBK0KRAjsw23b8WmSZifhRY13uplo=;
        b=IxSTG/9CxihA3FV+Rvyh7+Pw9UIF9J+HU19uvBIYgLRTotVYxKT8wuLI0/+gdSRlHP
         Y8SIi4NDt4bJSZV+is7Nj76KEAVBwnubFHujrgDbXh670MlA2vz632qk7C2CqynKnz0w
         apmy7lM5sIpu7OENQXUq+dG0+Xsh4qB+RxEuUJAa8eGxSruX9bli2Two4Abpa6OLA8C8
         g/jtYjxk+5oa0Hr5e4Ykr/QfaxGGmdv8zlx1RbwBhvK4QQ4sdrha4SVnwdGttAe3L199
         Gonj4aj3jQ+EVMFvRPHDVbu3V1EhNzuCXT1TZEUtC80ijG0O4Xky9ZjSmKTJ5RtzfCmJ
         1LSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46M8XUzBewi0sCNBK0KRAjsw23b8WmSZifhRY13uplo=;
        b=YCTuI71caBUkqcQ2CQyku0GemQ9GL8fvV3zNFnVLTIdmBtW+g6PQDvOKMFocn02GH9
         ISdZAufHw56G/ZoMGfPHQpfz6LM1o1ql0cHgut2YrnpT1k/bZByJoRMvs/2z6gIry2mv
         LKK/8kFIZHwQedLe95Lh2MgxHuVki5WEief4hmpgi0jD1CDSCnVvyNs+PFgukkVxaBfk
         0hnC46vDq6Y8xx5pasIPLDsecvFzRbQWdXeopM9VVcBOuSY5PHZhFJrv2UpiK2GS8T6d
         SNbw90mEQ4TyXwqYhsBQhrP0hCX0H/G2WMdL58BfML1p75l/gBYTaTybhEhqsiNfEGpu
         cnSw==
X-Gm-Message-State: AOAM532a+1TtwIgl+LvWxYYfqTCHb/5paDuqidB5COCdMP08ebahb0Dj
        LZzNWMS8ysFXavQa8JfMbDrdeEnuz2zB+4tmIOE=
X-Google-Smtp-Source: ABdhPJxG6A/lquocSRhAAjKeIItcxd+ESbK3kN1pvz6Jns+jdGKGqexan1uoPCDrG5Rbg++j7Y3CZYbui3f3HdgSY8U=
X-Received: by 2002:a17:90a:8816:: with SMTP id s22mr3022962pjn.231.1623022660101;
 Sun, 06 Jun 2021 16:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com>
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 6 Jun 2021 16:37:28 -0700
Message-ID: <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is the first RFC version.
>
> This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> introduces fd based ownership for such TC filters. Netlink cannot delete or
> replace such filters, but the bpf_link is severed on indirect destruction of the
> filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> that filters remain attached beyond process lifetime, the usual bpf_link fd
> pinning approach can be used.

I have some troubles understanding this. So... why TC filter is so special
here that it deserves such a special treatment?

The reason why I ask is that none of other bpf links actually create any
object, they merely attach bpf program to an existing object. For example,
netns bpf_link does not create an netns, cgroup bpf_link does not create
a cgroup either. So, why TC filter is so lucky to be the first one requires
creating an object?

Is it because there is no fd associated with any TC object?  Or what?
TC object, like all other netlink stuffs, is not fs based, hence does not
have an fd. Or maybe you don't need an fd at all? Since at least xdp
bpf_link is associated with a netdev which does not have an fd either.

>
> The individual patches contain more details and comments, but the overall kernel
> API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
> merged recently. This means that we start by always setting direct action mode,
> protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
> options in the future, they can be easily exposed through the bpf_link API in
> the future.

As you already see, this fits really oddly into TC infrastructure, because
TC qdisc/filter/action are a whole subsystem, here you are trying to punch
a hole in the middle. ;) This usually indicates that we are going in a wrong
direction, maybe your case is an exception, but I can't find anything to justify
it in your cover letter.

Even if you really want to go down this path (I still double), you probably
want to explore whether there is any generic way to associate a TC object
with an fd, because we have TC bpf action and we will have TC bpf qdisc
too, I don't see any bpf_cls is more special than them.

Thanks.
