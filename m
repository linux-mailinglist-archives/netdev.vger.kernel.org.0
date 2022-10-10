Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5305F9FF2
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJJOLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJJOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:10:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D974315B;
        Mon, 10 Oct 2022 07:10:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id o21so25098433ejm.11;
        Mon, 10 Oct 2022 07:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w9Sep1FhPUIPIoXioHs9+pk94Hb9lvILbmueT4032e0=;
        b=S4cbVz8T6Q0hTnXEb2+AjHRsT9dZ7OdPvpVFBzUnTMQqJTnUN+bPSy93t1IK+1qoGZ
         R+BUuwfQXWDR4i//vO940XWkEEPs3vGqWLZeE03pNuA1FfDMUsr1Q4Ag+TLnaYbZVDl5
         03tcA3LqpSb9VzF2sPvd8yAH2Th1Nb27A3xbElYck82oIqvnVKhhe0V6BFpd68n2Rnvh
         Ki/0NQ5o4CFI+0WhiuxfYKBHLDlk4dJ6Jpcfk6e6OEhnjKkA7bNTOGuHETlQM0yKTHM9
         uoIwXiKawaH964l/W6HaOLG2+PwmbbNPO7jfdmDXMdLMgkH6WnK0Vb4e8pm4MnTh6WmA
         ARKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w9Sep1FhPUIPIoXioHs9+pk94Hb9lvILbmueT4032e0=;
        b=ceWvCf4k6HOSBx+uOP/5o99rEq9usWAP6txTcBmrS/aTxD7yUeRBF2GOkl2VZM5WIL
         +ckOoFB+6UIo/FCFDd6Oo2vMNVEz/JqK3LwTQ0owVCSOmY+rpR4oUA0GShsKhf6RdxAW
         T26KxUn4BjYuUDzHmAp5kCn4Vi8jib95lz7S9nL50xLANHoXcu/tEGuT2Fr9Rntz4CM5
         6WG26nOTs9tjld/PhM5p8IxKzKxaC3uCTcEVEgEi18U38DCM49AQhkYlOVL3WsEWBa4b
         Fgza/naELV2uXI1SxgfhtzTjtBASxq7q7H2mzr5Z5NO+fpyCcH+YSPNWDfJpfFFAwLVO
         MDPA==
X-Gm-Message-State: ACrzQf1QK3aEFcIgyU3LLGnGm/Sj5N0TmobcK++jxt22T/eSX1yEOufj
        TS2Pvx4z2LFfxtePJ7xeF/k8oi2TfC0ddgn0V8s=
X-Google-Smtp-Source: AMsMyM7vj2idf8qCGmq5pHXFfTJJE06yan+PvzLIFVMd7H0RUut1ahfNLE5j0vKCBI8n71vGYQU2iGFV7qiaD1CyPLk=
X-Received: by 2002:a17:907:6e87:b0:782:2d55:f996 with SMTP id
 sh7-20020a1709076e8700b007822d55f996mr14864571ejc.502.1665411040152; Mon, 10
 Oct 2022 07:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
 <CAHC9VhRmghJcZeUM6NS6J24tBOBxrZckwc2DqbqqqYif8hzopA@mail.gmail.com>
 <CAADnVQKe+wivnEMF99P27s9rCaOcFQcHFS5Ys+fAcF=mZS_eww@mail.gmail.com> <CAHC9VhQCU4wHCEF1MXm1dN_e4vqpK_Mny5Wnp8UHfaFU6rn4UA@mail.gmail.com>
In-Reply-To: <CAHC9VhQCU4wHCEF1MXm1dN_e4vqpK_Mny5Wnp8UHfaFU6rn4UA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 Oct 2022 07:10:28 -0700
Message-ID: <CAADnVQKFON8jfrQB6wkVT4hn8UKLOFVQU4hes-XUr0P7gdvC+g@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Paul Moore <paul@paul-moore.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 6:29 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Oct 10, 2022 at 2:19 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Sun, Oct 9, 2022 at 3:01 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Fri, Oct 7, 2022 at 5:55 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Fri, Oct 7, 2022 at 1:06 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > > On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > > >
> > > > > > > > Hi Martin,
> > > > > > > >
> > > > > > > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > > > > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > > > > > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > > > > > > sockptr_t:user field to avoid having to update the LSM hook and
> > > > > > > > implementations.  I think that's fine, especially as you note that
> > > > > > > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > > > > > > it would be good to harden this case to prevent someone from calling
> > > > > > > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > > > > > > something like this?
> > > > > > > >
> > > > > > > >   static int sk_getsockopt(...)
> > > > > > > >   {
> > > > > > > >     /* ... */
> > > > > > > >     case SO_PEERSEC:
> > > > > > > >       if (optval.is_kernel || optlen.is_kernel)
> > > > > > > >         return -EINVAL;
> > > > > > > >       return security_socket_getpeersec_stream(...);
> > > > > > > >     /* ... */
> > > > > > > >   }
> > > > > > >
> > > > > > > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > > > > > > fixed soon ...
> > > > > >
> > > > > > 'fixed' ?
> > > > > > I don't see any bug.
> > > > > > Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
> > > > >
> > > > > Prior to the change it was impossible to call
> > > > > sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
> > > > > with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
> > > > > with a kernel address space pointer and cause problems.
> > > >
> > > > No. It's not possible. There is no path in the kernel that
> > > > can do that.
> > >
> > > If we look at the very next sentence in my last reply you see that I
> > > acknowledge that there may be no callers that currently do that, but
> > > it seems like an easy mistake for someone to make.  I've seen kernel
> > > coding errors similar to this in the past, it seems like a reasonable
> > > thing to protect against, especially considering it is well outside of
> > > any performance critical path.
> > >
> > > > > Perhaps there
> > > > > are no callers in the kernel that do such a thing at the moment, but
> > > > > it seems like an easy mistake for someone to make, and the code to
> > > > > catch it is both trivial and out of any critical path.
> > > >
> > > > Not easy at all.
> > > > There is only way place in the whole kernel that does:
> > > >                 return sk_getsockopt(sk, SOL_SOCKET, optname,
> > > >                                      KERNEL_SOCKPTR(optval),
> > > >                                      KERNEL_SOCKPTR(optlen));
> > > >
> > > > and there is an allowlist of optname-s right in front of it.
> > > > SO_PEERSEC is not there.
> > > > For security_socket_getpeersec_stream to be called with kernel
> > > > address the developer would need to add SO_PEERSEC to that allowlist.
> > > > Which will be trivially caught during the code review.
> > >
> > > A couple of things come to mind ... First, the concern isn't the
> > > existing caller(s), as mentioned above, but future callers.  Second,
> > > while the kernel code review process is good, the number of serious
> > > kernel bugs that have passed uncaught through the code review process
> > > is staggering.
> > >
> > > > > This is one of those cases where preventing a future problem is easy,
> > > > > I think it would be foolish of us to ignore it.
> > > >
> > > > Disagree. It's just a typical example of defensive programming
> > > > which I'm strongly against.
> > >
> > > That's a pretty bold statement, good luck with that.
> > >
> > > > By that argument we should be checking all pointers for NULL
> > > > "because it's easy to do".
> > >
> > > That's not the argument being made here, but based on your previous
> > > statements of trusting code review to catch bugs and your opposition
> > > to defensive programming it seems pretty unlikely we're going to find
> > > common ground.
> > >
> > > I'll take care of this in the LSM tree.
> >
> > Are you saying you'll add a patch to sk_getsockopt
> > in net/core/sock.c without going through net or bpf trees?
> > Paul, you're crossing the line.
>
> I believe my exact comment was "I'll take care of this in the LSM
> tree."  I haven't thought tpo hard about the details yet, but thinking
> quickly I can imagine several different approaches with varying levels
> of change required in sk_getsockopt(); it would be premature to
> comment much beyond that.  It also looks like David Laight has similar
> concerns, so it's possible he might work on resolving this too,
> discussions are (obviously) ongoing.
>
> As far as crossing a line is concerned, I suggest you first look in
> the mirror with respect to changes in the security/ subdir that did
> not go through one of the LSM trees.  There are quite a few patches
> from netdev/bpf that have touched security/ without going through a
> LSM tree or getting a Reviewed-by/Acked-by/etc. from a LSM developer.
> In fact I don't even have to go back a year and I see at least one
> patch that touches code under security/ that was committed by you
> without any LSM developer reviews/acks/etc.

Since you're going to take patches to sock.c despite objections
please make sure to add my Nack and see you at the next merge window.
Enough of this useless thread that destroyed trust and respect
over complete non-issue.
