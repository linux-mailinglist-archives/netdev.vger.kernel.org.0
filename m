Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD345F9F60
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJJN3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJJN3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:29:07 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD955F10E
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:29:06 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-134072c15c1so9227646fac.2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mzvA3GuKrTPaufJ9RRmdBpe4ogpV/znai6MlSebDlfc=;
        b=2rSwVF2fnNKaIhwmcrNwKvHhgHXExgI9TO9R3Z4jdCBHE8mj+T9kGzcUR2bx+w/kbL
         dICO1X6vryavxpN2dq0ltjuh8AaN13eKOTxUdqGKvK2RYsNc0JweJX8IRU4Gfl1anROR
         OCxp1Z4QPahG2IrU79NdTWo6bJ3ipR/mSwF9+nMU4To1mB6Tdcmpz1po/NujmuYRxDy1
         aQbhCOM+87M/NGDljymx5Zyw4wYxBuM3e8SOPxa1f0d+nLJYOvMNhJtTY5nGi7KBx3aJ
         vmC7XnbbYPiyRDVthUkLHAb9njXRn9Z0FkD5H7LjPPc5RM4xRBLSZmiBOJg8Oa3dT3NQ
         YSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mzvA3GuKrTPaufJ9RRmdBpe4ogpV/znai6MlSebDlfc=;
        b=ouwouOHCCm+gU581FXhNwt3Se1/k2JMsrMkFutSs0FlzgPHk+e7MQQjehLKMhzdXZz
         Gook9AX4CfXFpEifrp1H5UoqXN1WVlHXRge0BfPzVKVi3I6wBUa5IMNRcQ3iLLZi/RHP
         ZoLqRmSxs7VcftUSakVurKbNzDPeWWXZE4LSd7UiK0gr6EeEGwHI/mGbn00aiCo3c7rH
         liKehQVc1BprcULgxgjWWcXrQsylakkp1INTNHPap97etW9F0sC0H+ZJpwv8AskAz9c7
         qvLd9B3IY+yu4jiGSVRpc+FSvuRE9ykofnfAhoElhI+TMoPuWkYQG2WROQQoXQrkj0HJ
         r79w==
X-Gm-Message-State: ACrzQf2KYyKvC/fBfbY/71jdSYwJSpXt6dffdPP6BMllwTvuRfFDYkJw
        HklJNO4bgYsQ41J1WLoAFZvIKxhUZPsjVRMht0H1
X-Google-Smtp-Source: AMsMyM5Uj2vSeOJ4FKvCx0L0Q+XdpaMXk0fUzplu3qADACsyQC5MB4xeOiuaCjzVawvgv0y1GzPPlpcgogXdC4CRjMI=
X-Received: by 2002:a05:6870:9612:b0:136:66cc:6d5a with SMTP id
 d18-20020a056870961200b0013666cc6d5amr4986184oaq.172.1665408545775; Mon, 10
 Oct 2022 06:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
 <CAHC9VhRmghJcZeUM6NS6J24tBOBxrZckwc2DqbqqqYif8hzopA@mail.gmail.com> <CAADnVQKe+wivnEMF99P27s9rCaOcFQcHFS5Ys+fAcF=mZS_eww@mail.gmail.com>
In-Reply-To: <CAADnVQKe+wivnEMF99P27s9rCaOcFQcHFS5Ys+fAcF=mZS_eww@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 10 Oct 2022 09:28:54 -0400
Message-ID: <CAHC9VhQCU4wHCEF1MXm1dN_e4vqpK_Mny5Wnp8UHfaFU6rn4UA@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 2:19 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Sun, Oct 9, 2022 at 3:01 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Oct 7, 2022 at 5:55 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Fri, Oct 7, 2022 at 1:06 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > >
> > > > > > > Hi Martin,
> > > > > > >
> > > > > > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > > > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > > > > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > > > > > sockptr_t:user field to avoid having to update the LSM hook and
> > > > > > > implementations.  I think that's fine, especially as you note that
> > > > > > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > > > > > it would be good to harden this case to prevent someone from calling
> > > > > > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > > > > > something like this?
> > > > > > >
> > > > > > >   static int sk_getsockopt(...)
> > > > > > >   {
> > > > > > >     /* ... */
> > > > > > >     case SO_PEERSEC:
> > > > > > >       if (optval.is_kernel || optlen.is_kernel)
> > > > > > >         return -EINVAL;
> > > > > > >       return security_socket_getpeersec_stream(...);
> > > > > > >     /* ... */
> > > > > > >   }
> > > > > >
> > > > > > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > > > > > fixed soon ...
> > > > >
> > > > > 'fixed' ?
> > > > > I don't see any bug.
> > > > > Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
> > > >
> > > > Prior to the change it was impossible to call
> > > > sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
> > > > with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
> > > > with a kernel address space pointer and cause problems.
> > >
> > > No. It's not possible. There is no path in the kernel that
> > > can do that.
> >
> > If we look at the very next sentence in my last reply you see that I
> > acknowledge that there may be no callers that currently do that, but
> > it seems like an easy mistake for someone to make.  I've seen kernel
> > coding errors similar to this in the past, it seems like a reasonable
> > thing to protect against, especially considering it is well outside of
> > any performance critical path.
> >
> > > > Perhaps there
> > > > are no callers in the kernel that do such a thing at the moment, but
> > > > it seems like an easy mistake for someone to make, and the code to
> > > > catch it is both trivial and out of any critical path.
> > >
> > > Not easy at all.
> > > There is only way place in the whole kernel that does:
> > >                 return sk_getsockopt(sk, SOL_SOCKET, optname,
> > >                                      KERNEL_SOCKPTR(optval),
> > >                                      KERNEL_SOCKPTR(optlen));
> > >
> > > and there is an allowlist of optname-s right in front of it.
> > > SO_PEERSEC is not there.
> > > For security_socket_getpeersec_stream to be called with kernel
> > > address the developer would need to add SO_PEERSEC to that allowlist.
> > > Which will be trivially caught during the code review.
> >
> > A couple of things come to mind ... First, the concern isn't the
> > existing caller(s), as mentioned above, but future callers.  Second,
> > while the kernel code review process is good, the number of serious
> > kernel bugs that have passed uncaught through the code review process
> > is staggering.
> >
> > > > This is one of those cases where preventing a future problem is easy,
> > > > I think it would be foolish of us to ignore it.
> > >
> > > Disagree. It's just a typical example of defensive programming
> > > which I'm strongly against.
> >
> > That's a pretty bold statement, good luck with that.
> >
> > > By that argument we should be checking all pointers for NULL
> > > "because it's easy to do".
> >
> > That's not the argument being made here, but based on your previous
> > statements of trusting code review to catch bugs and your opposition
> > to defensive programming it seems pretty unlikely we're going to find
> > common ground.
> >
> > I'll take care of this in the LSM tree.
>
> Are you saying you'll add a patch to sk_getsockopt
> in net/core/sock.c without going through net or bpf trees?
> Paul, you're crossing the line.

I believe my exact comment was "I'll take care of this in the LSM
tree."  I haven't thought tpo hard about the details yet, but thinking
quickly I can imagine several different approaches with varying levels
of change required in sk_getsockopt(); it would be premature to
comment much beyond that.  It also looks like David Laight has similar
concerns, so it's possible he might work on resolving this too,
discussions are (obviously) ongoing.

As far as crossing a line is concerned, I suggest you first look in
the mirror with respect to changes in the security/ subdir that did
not go through one of the LSM trees.  There are quite a few patches
from netdev/bpf that have touched security/ without going through a
LSM tree or getting a Reviewed-by/Acked-by/etc. from a LSM developer.
In fact I don't even have to go back a year and I see at least one
patch that touches code under security/ that was committed by you
without any LSM developer reviews/acks/etc.

-- 
paul-moore.com
