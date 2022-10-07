Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC95F8058
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJGVzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJGVzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:55:40 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203CAA5701;
        Fri,  7 Oct 2022 14:55:35 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ot12so14056844ejb.1;
        Fri, 07 Oct 2022 14:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bL6Ak5H09U4S+Zi1JkNWbIYx87jdydRMPmWHkn6vK/w=;
        b=Y706H0GOJhZ7Gon4KbJgWnbNacILzsNQtkf8QI+f3DsqXmlpb4qTaulfNTPfcadvUR
         Eor7xteScanx6qnVke2V3xYp89/BRgVZu9GZTO6Jx33zZYthyFdl0T0p7kXPmRd2wskL
         E2wNYEW+R1KYFDeUHiAChgQzAw1qoMCG+jM3wjxix6Z7unW0x9iV6SnjsCyYyRPATB6L
         /OZ3gZ4iJkRu/mgqudFWCzoHoyUZxK/k9DlpzGID5b9FqhXGpGQiGFgMz05A1IULwCTX
         qBeY7szcCNrpRIHCYoLX7kmFyRzlscXgkwFNMJ+uthNI9Ruv5P+lQnnep0VN4mrnElYq
         5myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bL6Ak5H09U4S+Zi1JkNWbIYx87jdydRMPmWHkn6vK/w=;
        b=yVZkBDnZnBPbl25JnY7j1DRNdfEZvGYLc49DqOBLKTBElcTIViZW3b7gGYTp9X9dGZ
         XDC+1sKU+Bo7zaueoL/WCgQB/gTyHoE9gaxl/Zv2Q2wHJwgZk3OleT5dlAj7YdwJ1PPg
         W/giSctAiBh4aBPKPJrMqmNW3j3dviI9nU8DTmOTb6VcCeD61+0w+Ai1llYI3qjBkneL
         i8hEEqnpFwljs9rSQVeS0X43VnVPdThCnRfjQqzhDeokp52YIst0UbXPh0VTxSSV2ue+
         Wy2cPh1wrkVQfC1siFizhUeKljCMzuoNPdho4keVmHjcC4GOtFpIlr8BBpVJl4ZQ6RRA
         w0lA==
X-Gm-Message-State: ACrzQf0DEgjSfJHlDNVfp2HlKPjt7J4QJC764BWbez6ReSP3IZGtSRBN
        yZzKTMUy3HlvKtGmaZRYo+lBiyeqGZnMlvvGisqFQv0apaY=
X-Google-Smtp-Source: AMsMyM7kk5o5QxWBEHe6uZTqnP+cWLvaL+QMSa7AFJXRTfkmaac9dVZZqbAxjyvrBJ8jJv5Q+3+gzc3DMYH58Su/8ic=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr5696459ejb.633.1665179733473; Fri, 07
 Oct 2022 14:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com> <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
In-Reply-To: <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Oct 2022 14:55:21 -0700
Message-ID: <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Paul Moore <paul@paul-moore.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
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

On Fri, Oct 7, 2022 at 1:06 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >
> > > > Hi Martin,
> > > >
> > > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > > sockptr_t:user field to avoid having to update the LSM hook and
> > > > implementations.  I think that's fine, especially as you note that
> > > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > > it would be good to harden this case to prevent someone from calling
> > > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > > something like this?
> > > >
> > > >   static int sk_getsockopt(...)
> > > >   {
> > > >     /* ... */
> > > >     case SO_PEERSEC:
> > > >       if (optval.is_kernel || optlen.is_kernel)
> > > >         return -EINVAL;
> > > >       return security_socket_getpeersec_stream(...);
> > > >     /* ... */
> > > >   }
> > >
> > > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > > fixed soon ...
> >
> > 'fixed' ?
> > I don't see any bug.
> > Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.
>
> Prior to the change it was impossible to call
> sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
> with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
> with a kernel address space pointer and cause problems.

No. It's not possible. There is no path in the kernel that
can do that.

> Perhaps there
> are no callers in the kernel that do such a thing at the moment, but
> it seems like an easy mistake for someone to make, and the code to
> catch it is both trivial and out of any critical path.

Not easy at all.
There is only way place in the whole kernel that does:
                return sk_getsockopt(sk, SOL_SOCKET, optname,
                                     KERNEL_SOCKPTR(optval),
                                     KERNEL_SOCKPTR(optlen));

and there is an allowlist of optname-s right in front of it.
SO_PEERSEC is not there.
For security_socket_getpeersec_stream to be called with kernel
address the developer would need to add SO_PEERSEC to that allowlist.
Which will be trivially caught during the code review.

> This is one of those cases where preventing a future problem is easy,
> I think it would be foolish of us to ignore it.

Disagree. It's just a typical example of defensive programming
which I'm strongly against.
By that argument we should be checking all pointers for NULL
"because it's easy to do".
