Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC535F983F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 08:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiJJGTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 02:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiJJGTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 02:19:19 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4A4550B4;
        Sun,  9 Oct 2022 23:19:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bj12so22628208ejb.13;
        Sun, 09 Oct 2022 23:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8mqAXYi4S/wAFQDTtenr5odzbbxuTlpc9KMT2eoTLuc=;
        b=EmXuSHZctXdqlReVJ4tsE36oTdDjfLhNwN9wy4upaYfLjX6VHnbKhwYiOG4IxWkTVi
         SHo/uQEXlRtyDOMgMU3ssU0lmzN+tDfBJQolFlBEQ6/ZSTQnzvHJle8I4nwBOB6W8Thl
         oI0WgcD+ZtR4hO3pBeNpPgcLQwLtV8TsEgW+zFNGeNi93YZso3qed2zl1iy+SjMCdKcc
         ZGYZrtEblZREQYBZT5bD+OAmB+xfT6K+xwOIpnEMzm3y6uD/Uaxl8KVS5VYQXJ+Psgsi
         YfZzFhY6CHR2l6VsIj8Rhxy+Gfb1tEFA6K8rj6mFIn2YVHV4MwuaN2equKwfm4GmuBYM
         YAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mqAXYi4S/wAFQDTtenr5odzbbxuTlpc9KMT2eoTLuc=;
        b=KFfW+dCGIjp236fiT/oosmloeKMbCT+vohpURTO7Sit07vkicMRRIUs2Wfb6RWKepI
         RIZdOEDyh/7dQSniRTToD79ZFJyw6OeelXzDVu5dhvuSZ9bHOTKCaeqN9eB6pseEVm5v
         U3m2rN7phOKeZVTjbQnUPEW9ROnSNfekE9DRDTnuJwGUa/ludjiQo7HbeJxjI7DneVBR
         rUFVAegoSOyEy+GaWXW2hjrB1ePdQxQ0gqPaNaNmIgzoKkfVnMjr2px77Qc/D3clm8KV
         rOVJCJmpoJS0iqdoegH4ir7WHX7BQKEQTWAlQkeFPoADP90sBfpEkEGIGLUJYcO9CNUQ
         NFxA==
X-Gm-Message-State: ACrzQf1fWuWmmf9WoB/dJA5kRwbArP2FKgs4i+rjSiQnXJ0EApp2og5n
        Ulzqxk8uC91Sx+ikmmt1HX/G3ERTO5UnRD0/f0kWCWHbvvXxBg==
X-Google-Smtp-Source: AMsMyM7SlcjPhB/zptkFTHDFxPpnoXWkFC5FMDjS6oajEVEq+d4nMtFmluq3teGdGultGz3UehihL+ZDrPYunEikoAM=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr13618924ejb.633.1665382751443; Sun, 09
 Oct 2022 23:19:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com> <CAHC9VhRmghJcZeUM6NS6J24tBOBxrZckwc2DqbqqqYif8hzopA@mail.gmail.com>
In-Reply-To: <CAHC9VhRmghJcZeUM6NS6J24tBOBxrZckwc2DqbqqqYif8hzopA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 9 Oct 2022 23:19:00 -0700
Message-ID: <CAADnVQKe+wivnEMF99P27s9rCaOcFQcHFS5Ys+fAcF=mZS_eww@mail.gmail.com>
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

On Sun, Oct 9, 2022 at 3:01 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Fri, Oct 7, 2022 at 5:55 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Fri, Oct 7, 2022 at 1:06 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > > >
> > > > > > Hi Martin,
> > > > > >
> > > > > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > > > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > > > > sockptr_t:user field to avoid having to update the LSM hook and
> > > > > > implementations.  I think that's fine, especially as you note that
> > > > > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > > > > it would be good to harden this case to prevent someone from calling
> > > > > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > > > > something like this?
> > > > > >
> > > > > >   static int sk_getsockopt(...)
> > > > > >   {
> > > > > >     /* ... */
> > > > > >     case SO_PEERSEC:
> > > > > >       if (optval.is_kernel || optlen.is_kernel)
> > > > > >         return -EINVAL;
> > > > > >       return security_socket_getpeersec_stream(...);
> > > > > >     /* ... */
> > > > > >   }
> > > > >
> > > > > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > > > > fixed soon ...
> > > >
> > > > 'fixed' ?
> > > > I don't see any bug.
> > > > Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
> > >
> > > Prior to the change it was impossible to call
> > > sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
> > > with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
> > > with a kernel address space pointer and cause problems.
> >
> > No. It's not possible. There is no path in the kernel that
> > can do that.
>
> If we look at the very next sentence in my last reply you see that I
> acknowledge that there may be no callers that currently do that, but
> it seems like an easy mistake for someone to make.  I've seen kernel
> coding errors similar to this in the past, it seems like a reasonable
> thing to protect against, especially considering it is well outside of
> any performance critical path.
>
> > > Perhaps there
> > > are no callers in the kernel that do such a thing at the moment, but
> > > it seems like an easy mistake for someone to make, and the code to
> > > catch it is both trivial and out of any critical path.
> >
> > Not easy at all.
> > There is only way place in the whole kernel that does:
> >                 return sk_getsockopt(sk, SOL_SOCKET, optname,
> >                                      KERNEL_SOCKPTR(optval),
> >                                      KERNEL_SOCKPTR(optlen));
> >
> > and there is an allowlist of optname-s right in front of it.
> > SO_PEERSEC is not there.
> > For security_socket_getpeersec_stream to be called with kernel
> > address the developer would need to add SO_PEERSEC to that allowlist.
> > Which will be trivially caught during the code review.
>
> A couple of things come to mind ... First, the concern isn't the
> existing caller(s), as mentioned above, but future callers.  Second,
> while the kernel code review process is good, the number of serious
> kernel bugs that have passed uncaught through the code review process
> is staggering.
>
> > > This is one of those cases where preventing a future problem is easy,
> > > I think it would be foolish of us to ignore it.
> >
> > Disagree. It's just a typical example of defensive programming
> > which I'm strongly against.
>
> That's a pretty bold statement, good luck with that.
>
> > By that argument we should be checking all pointers for NULL
> > "because it's easy to do".
>
> That's not the argument being made here, but based on your previous
> statements of trusting code review to catch bugs and your opposition
> to defensive programming it seems pretty unlikely we're going to find
> common ground.
>
> I'll take care of this in the LSM tree.

Are you saying you'll add a patch to sk_getsockopt
in net/core/sock.c without going through net or bpf trees?
Paul, you're crossing the line.
