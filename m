Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBAD24C7AD
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgHTWTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgHTWTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:19:05 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BFFC061385;
        Thu, 20 Aug 2020 15:19:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v4so3845082ljd.0;
        Thu, 20 Aug 2020 15:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0imhsJFcMUXMsdMT+Qu7R6pZfNM8N7tXzIrnGHdxQNY=;
        b=mUHfQZqAD11JFmWln/zSvn07ks3unOON9SGeU6Ed7pnB8HhenCB1m5hOM8pAefYua2
         CdrUlLcADyW9bxAZvIPjDbM+gnJJrW2TBM4XdkdjjzhsSGRXCLSYWftp7zODJp2P/bt4
         1vRSE57IZ0nXUdtRpNxHMTP8fXjG+fOmVQG8plnfqRza86H+7/iKHscgbIyCXOVOXZ1U
         mYOUGHnN3XxF6V1/WK/AcFsnCPOFCXhFCe/Pmnaj7G481QihsyYpXkmZN/5DjvxY6TPr
         RoWG1e/y6UlaCj+XWshDpf2qmfDQMt5T/HXBXk4FUNlMbjCMMVX861bmAY1UDbkvmuRh
         npug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0imhsJFcMUXMsdMT+Qu7R6pZfNM8N7tXzIrnGHdxQNY=;
        b=RyVI4IjBGOnhYZoWYAUmjIqIy6Fm1/OBwp60S8lS46aN8iTEJ4WFA765hivhbqi48o
         BaBm2ZW2DAUpwXJARm0FnrleLKVWuf4S97xpTTSyQZj+ZHBqfxY48BiZa3CbNHaQy7l4
         RDjuVv8WbHVVLSXmU9+zqFpcn0UDjP0bYcx5/IHpvzMwbZ9t1Zh1uRmryhxhFLgMh9k/
         6paVPk/Q2zqdQDRUm8KIOjNsTiNoVe4fEUHFuE1WFWMnEhjOvhzcC2dibxqQCQU3zGLY
         Xfb2C+QwmmLhu6cRbxGTUUYg2OlIDcK4b+rEv/2FvxwHhCLqNQ0tVGeS/6bSvTL205b3
         EBmw==
X-Gm-Message-State: AOAM530Vjq4h1V9RDd/kfui2ngg5nSu3AdtBzHOpx7C4hnPq2lYsIwpt
        lg4Id4/RNGZlHUMquCozhkqUIbE7L8Q/79ux5uc=
X-Google-Smtp-Source: ABdhPJyf1SGEdwHlOLbypYAHLx3aSCxGJ4H14IscDud57cmHpHIf56cdP8uOQX66Y1qYyao25Cj7pRVWzMGl05d1jF0=
X-Received: by 2002:a2e:968c:: with SMTP id q12mr50234lji.51.1597961943208;
 Thu, 20 Aug 2020 15:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com> <87lficrm2v.fsf@cloudflare.com>
 <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com> <87k0xtsj91.fsf@cloudflare.com>
In-Reply-To: <87k0xtsj91.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Aug 2020 15:18:51 -0700
Message-ID: <CAADnVQ+MXozV0ZFNYmK5ehVzvktXDcrAq8Q1Z9COWnXcACOXWQ@mail.gmail.com>
Subject: Re: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 3:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Aug 18, 2020 at 08:19 PM CEST, Alexei Starovoitov wrote:
> > On Tue, Aug 18, 2020 at 8:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>          :                      rcu_read_lock();
> >>          :                      run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
> >>     0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
> >>          :                      if (run_array) {
> >>     0.00 :   ffffffff817f862c:       test   %rsi,%rsi
> >>     0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lookup+0x2c9>
> >>          :                      struct bpf_sk_lookup_kern ctx = {
> >>     1.05 :   ffffffff817f8635:       xor    %eax,%eax
> >>     0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
> >>     0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
> >>     0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
> >>    18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
> >>     1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
> >>     0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
> >>     0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
> >>     0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
> >>     1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
> >>     0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
> >>     0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
> >>          :                      .sport          = sport,
> >>          :                      .dport          = dport,
> >>          :                      };
> >
> > Such heavy hit to zero init 56-byte structure is surprising.
> > There are two 4-byte holes in this struct. You can try to pack it and
> > make sure that 'rep stoq' is used instead of 'rep stos' (8 byte at a time vs 4).
>
> Thanks for the tip. I'll give it a try.
>
> > Long term we should probably stop doing *_kern style of ctx passing
> > into bpf progs.
> > We have BTF, CO-RE and freplace now. This old style of memset *_kern and manual
> > ctx conversion has performance implications and annoying copy-paste of ctx
> > conversion routines.
> > For this particular case instead of introducing udp4_lookup_run_bpf()
> > and copying registers into stack we could have used freplace of
> > udp4_lib_lookup2.
> > More verifier work needed, of course.
> > My main point that existing approach "lets prep args for bpf prog to
> > run" that is used
> > pretty much in every bpf hook is no longer necessary.
>
> Andrii has also suggested leveraging BTF [0], but to expose the *_kern
> struct directly to BPF prog instead of emitting ctx access instructions.
>
> What I'm curious about is if we get rid of prepping args and ctx
> conversion, then how do we limit what memory BPF prog can access?
>
> Say, I'm passing a struct sock * to my BPF prog. If it's not a tracing
> prog, then I don't want it to have access to everything that is
> reachable from struct sock *. This is where this approach currently
> breaks down for me.

Why do you want to limit it?
Time after time we keep extending structs in uapi/bpf.h because new
use cases are coming up. Just let the prog access everything.
