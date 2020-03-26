Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DF194799
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCZTk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:40:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41503 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:40:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id t16so2551628plr.8;
        Thu, 26 Mar 2020 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HPuxdzkNqLhQ3fR4K6trK8HciMyFIxhzicL4Cb7qcio=;
        b=JOxBI8DCOorhzDHSsG5draNC3B3YA2fK+zQX1qhLKL34alNsnDK08uhQKkzUxYRam0
         n3Z9W2Xhl/eSDxQ3aR4Fs75uAyjgnz+pyGmB/K1+razRUaJ7C6lCdk7bT+IYiS54Px9P
         lllGtxE02SMC7BeDR/6EH5Uk4bwZmSVlVNCjLqSuESdxeXgrqJ/vS/Kd+GdfAiXJG5Rl
         HiNsj7W0rpYbUrvXRWVkQHSFWGGzMWY4BQ+tFBSdCxTCZfWmtZkT9JvS+Y4Y65ht9Q49
         TvUPY5fXsECNKsucFR6TrnycsuQzt8lDtIeaRUOchP1vcOOvQ09wmMtoEmKBsnjCYkaF
         nLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HPuxdzkNqLhQ3fR4K6trK8HciMyFIxhzicL4Cb7qcio=;
        b=AplmewcnGk3RzVug5g3gbIGWWsHMWEwKwWS0By+iUviaGOaGpwCXWmyeEdMcoLLgAL
         a7484/ceipiHFGe/D5ebNvJ+fkyuQIyLzafwj0UAt7mb1qCojk7uVrjz6D/h6J2FZFBA
         btnEO8kTwfK/O/aY+MQ+FK9h00h5yuTfukZM4c2MKmK5j/Q0OwJc31xgh53Kw8/HfUli
         zYujjwZbsCV89e6LDWgJF/TwH2FziKVga/A+0OcBsNuOzD5tFL8LZ/OowmMr83NEjikw
         l3ptRw680CN1ut/U2xP5L4BRmBYZsN8Pbq3lHFNZGn9q+oxN+98yoLSqrdz1OsDNrOz1
         KuLg==
X-Gm-Message-State: ANhLgQ3TgTwQUL2dJXNWZXtbePt0TtwmeYZbLlygHS/XQ/ne1ghywIXc
        K8M7t9y+Dacn9UZM2xErXsI=
X-Google-Smtp-Source: ADFU+vv6mkckeowZNju+x2RhpAIHT1ILBxnCrIRu4fmAU14QnDRISc+beyxgPwlhEAsPwxDeTVqesA==
X-Received: by 2002:a17:90a:5218:: with SMTP id v24mr1722611pjh.90.1585251654782;
        Thu, 26 Mar 2020 12:40:54 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id a71sm2364519pfa.162.2020.03.26.12.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 12:40:53 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:40:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200326194050.d5cjetvhzlhyiesb@ast-mbp>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:13:23PM -0700, Jakub Kicinski wrote:
> >
> > Now for XDP. It has same flawed model. And even if it seems to you
> > that it's not a big issue, and even if Jakub thinks we are trying to
> > solve non-existing problem, it is a real problem and a real concern
> > from people that have to support XDP in production with many
> 
> More than happy to talk to those folks, and see the tickets.

Jakub, you repeatedly demonstrated lack of understanding of what
bpf_link is despite multiple attempts from me, Andrii and others.
At this point I don't believe in your good intent.
Your repeated attacks on BPF in every thread are out of control.
I kept ignoring your insults for long time, but I cannot do this anymore.
Please find other threads to contribute your opinions.
They are not welcomed here.

> > well-meaning developers developing BPF applications independently.
> 
> There is one single program which can be attached to the XDP hook, 
> the "everybody attaches their program model" does not apply.
> 
> TW agent should just listen on netlink notifications to see if someone
> replaced its program.

This is dumbest idea I've heard in a long time.
May be kernel shouldn't have done ACLs and did notifications only
when file is accessed by a task that shouldn't have accessed it?
Same level of craziness.
