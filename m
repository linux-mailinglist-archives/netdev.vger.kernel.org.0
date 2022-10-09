Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07E25F8F57
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJIWB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiJIWBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:01:23 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C731EEDF
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 15:01:22 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id d22-20020a4a5216000000b0047f740d5847so6884734oob.13
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 15:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uCRLYNKaUNlApcpDFpNyoRTJy58BtqMBs8QGQONvN8k=;
        b=vGC2eDM3rEem/eh/5h8SDEjqOetEl07JAHYwzB9ONsarnjg7j3usGYgj54DnxwISnN
         zJb7uM4oIhyXpc84kXLleo7oYgPeZpggHIhpAlSud3HZ+U8x6UCb2MJeKWUn0dNtvMHX
         QiKZgUNGZE+TTEp2USGjQEhcGrmonl4I+UQObvkjIBPrQ8GTLtkAlELA9o+0NpFbf195
         uiZyfI6RadwMh8lW2i3BEf1VXZAopWlsLrS8w3sO11x2uEEsltqe7N6BDaT2NNxFtr8d
         /X/CODbWkumcwphx0PQANx9dRTxEyZz62XHdzRqo5GlxUGiD4yhC+jyizLgCaPqXHe6/
         dRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCRLYNKaUNlApcpDFpNyoRTJy58BtqMBs8QGQONvN8k=;
        b=6A1v7mNuEfxmDwnfPYneDvIGkcvC94EiIpmOYs/nQDFrd6yi+ERIgh6NF3GFLvw8Tg
         JDT7HIPIaaj8Sr3qNN+HNiPDpoUlJliIVaUAHavCga/aCY0WneqsZr9q8iZv+WUEAE/E
         4zUNIZ0LkYzSz0mWIuVnduWkbTqtGHDudY8gQ0+nHe02Pb/AoVbuteemF+jVhY9OmkNg
         j9yqnQCfn5QPPVvyrfIpfierTeMirClLs59eOUbCOgD629bGfWkzIPl9wjx/725VVs/J
         JuffSYINk8MwtD1DXSx02wwVU7SPOjGu2accWNJU+WaY8u0hnwHNGJiFxhWT24x4tjoi
         BKIg==
X-Gm-Message-State: ACrzQf3n7uV9x2oJ7KKr8PyC/erZdIJIwOt6SDDoiWWNpf+8XEl2WGaC
        XoIagveLOpaBsm8TedAVdZPglWmcI/6M+Mw+ULKt
X-Google-Smtp-Source: AMsMyM4asPKdAkOMP82nbVM7coRwFd3bhcIe35xgsbLTxbleHkmJxrxhoowiCfpYkkfMYzO+c4pIpcQeh1JWVfTh1ws=
X-Received: by 2002:a05:6830:6403:b0:661:9295:af6b with SMTP id
 cj3-20020a056830640300b006619295af6bmr2613406otb.287.1665352881919; Sun, 09
 Oct 2022 15:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com> <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
In-Reply-To: <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 9 Oct 2022 18:01:10 -0400
Message-ID: <CAHC9VhRmghJcZeUM6NS6J24tBOBxrZckwc2DqbqqqYif8hzopA@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 7, 2022 at 5:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Fri, Oct 7, 2022 at 1:06 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > >
> > > > > Hi Martin,
> > > > >
> > > > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > > > sockptr_t:user field to avoid having to update the LSM hook and
> > > > > implementations.  I think that's fine, especially as you note that
> > > > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > > > it would be good to harden this case to prevent someone from calling
> > > > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > > > something like this?
> > > > >
> > > > >   static int sk_getsockopt(...)
> > > > >   {
> > > > >     /* ... */
> > > > >     case SO_PEERSEC:
> > > > >       if (optval.is_kernel || optlen.is_kernel)
> > > > >         return -EINVAL;
> > > > >       return security_socket_getpeersec_stream(...);
> > > > >     /* ... */
> > > > >   }
> > > >
> > > > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > > > fixed soon ...
> > >
> > > 'fixed' ?
> > > I don't see any bug.
> > > Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
> >
> > Prior to the change it was impossible to call
> > sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
> > with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
> > with a kernel address space pointer and cause problems.
>
> No. It's not possible. There is no path in the kernel that
> can do that.

If we look at the very next sentence in my last reply you see that I
acknowledge that there may be no callers that currently do that, but
it seems like an easy mistake for someone to make.  I've seen kernel
coding errors similar to this in the past, it seems like a reasonable
thing to protect against, especially considering it is well outside of
any performance critical path.

> > Perhaps there
> > are no callers in the kernel that do such a thing at the moment, but
> > it seems like an easy mistake for someone to make, and the code to
> > catch it is both trivial and out of any critical path.
>
> Not easy at all.
> There is only way place in the whole kernel that does:
>                 return sk_getsockopt(sk, SOL_SOCKET, optname,
>                                      KERNEL_SOCKPTR(optval),
>                                      KERNEL_SOCKPTR(optlen));
>
> and there is an allowlist of optname-s right in front of it.
> SO_PEERSEC is not there.
> For security_socket_getpeersec_stream to be called with kernel
> address the developer would need to add SO_PEERSEC to that allowlist.
> Which will be trivially caught during the code review.

A couple of things come to mind ... First, the concern isn't the
existing caller(s), as mentioned above, but future callers.  Second,
while the kernel code review process is good, the number of serious
kernel bugs that have passed uncaught through the code review process
is staggering.

> > This is one of those cases where preventing a future problem is easy,
> > I think it would be foolish of us to ignore it.
>
> Disagree. It's just a typical example of defensive programming
> which I'm strongly against.

That's a pretty bold statement, good luck with that.

> By that argument we should be checking all pointers for NULL
> "because it's easy to do".

That's not the argument being made here, but based on your previous
statements of trusting code review to catch bugs and your opposition
to defensive programming it seems pretty unlikely we're going to find
common ground.

I'll take care of this in the LSM tree.

-- 
paul-moore.com
