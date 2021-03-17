Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085E733ED1D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCQJgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCQJgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:36:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204FEC06174A;
        Wed, 17 Mar 2021 02:36:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u18so481656plc.12;
        Wed, 17 Mar 2021 02:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/UwIMPoiNTEqVW0NAKbZeVG8BLAecJh/rLT+yCxwwI=;
        b=UMka2ac9aQY4VVpveKW1x+nSPk6NcsEi5BJzvbH7+H44Z3SXFiehVbQ7b1YGwlfOiS
         2U/I/6nxgvUW4soT2SXb898IFTfd79zmKeCDHfRO/GiyO/dFCGZ19LiKkIeJny8lOe8L
         gmvWvd9qmFQ2VjWJb+fFZ0o92nFFcDHHkhU2ksX9SxLqfmuSi0WRLJa7XJo7loyMwgDI
         GXWmM9X5xinTGeZBO2rSJwQF14e8CI/tymix7biwY5je41SWfFt7zM0imdClCl/wvnc8
         RyLOEFVjsdKGNNHC+cHk9uRXR4JXVB+yfCwQcjekLOKGkk8X/Y1jyjh/b4IoRHcY5vvt
         SiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/UwIMPoiNTEqVW0NAKbZeVG8BLAecJh/rLT+yCxwwI=;
        b=ST2JoPOO1VPeKSGjPaUy/YZxmqIi03UNK3tud6rwcvBrfiNzD20EsroolK5HaiJdul
         Y34bFf3I6RRTpU2tklPCnLDsFPViKFP7IpTxmW1kPy14bUCaUrHbo86ZrpCcKAg/Iugv
         DzOaYDRJ9J1zCOhASCXDZvTQ9MBzRFCAQ7gHHAufLQLUMgckB36dG64lIuTLjNW+ZduP
         ccac26HL+J6IOn6bYx0ziv+vkfAMJ5yaLoL26IYRaBom9zrAbIUvKE6+TZY/ZwVfqlRr
         9RGEXilOU426TQTnGCa1+qLPowH97GMtGM31lrXAONBfcUxQCxMgHVHfzl+1vGYMLiJO
         o0Og==
X-Gm-Message-State: AOAM532bWjr55p3XHtegJDxOGQdlWuQ4HRbToDSqCWCDgE86tQxdUXaZ
        AoNFwHi5uVBOYhPtkXPHAGxtmzQeTO5f1KdGexM=
X-Google-Smtp-Source: ABdhPJy8lTvDxNpJseFrB/g8WC6xXJd25OBlaebo7gfMhZfooldUWzMtKuIO2o1MfQx8jrw1mLZL5BG7Vg+9vTMQr3Y=
X-Received: by 2002:a17:90a:e454:: with SMTP id jp20mr3851271pjb.129.1615973778514;
 Wed, 17 Mar 2021 02:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net> <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
In-Reply-To: <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 17 Mar 2021 11:36:02 +0200
Message-ID: <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 10:21 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
> On Wed, Mar 17, 2021 at 9:38 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > On Wed, Mar 17, 2021 at 01:02:51AM +0200, Andy Shevchenko wrote:
> > > On Wednesday, March 17, 2021, Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> ...
> >
> > The problem is in net/packet/af_packet.c:packet_recvmsg(). This function,
> > as well as all other rcvmsg functions, is declared as
> >
> > static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> >                           int flags)
> >
> > MSG_CMSG_COMPAT (0x80000000) is set in flags, meaning its value is negative.
> > This is then evaluated in
> >
> >        if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
> >                 goto out;
> >
> > If any of those flags is declared as BIT() and thus long, flags is
> > sign-extended to long. Since it is negative, its upper 32 bits will be set,
> > the if statement evaluates as true, and the function bails out.
> >
> > This is relatively easy to fix here with, for example,
> >
> >         if ((unsigned int)flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
> >                 goto out;
> >
> > but that is just a hack, and it doesn't solve the real problem:
> > Each function in struct proto_ops which passes flags passes it as int
> > (see include/linux/net.h:struct proto_ops). Each such function, if
> > called with MSG_CMSG_COMPAT set, will fail a match against
> > ~(MSG_anything) if MSG_anything is declared as BIT() or long.
> >
> > As it turns out, I was kind of lucky to catch the problem: So far I have
> > seen it only on mips64 kernels with N32 userspace.
> >
> > Guenter
>
>  Wow, now the usages of 'msg_flag' really puzzle me. Seems that
> it is used as 'unsigned int' somewhere, but 'int' somewhere
> else.
>
> As I found, It is used as 'int' in 'netlink_recvmsg()',
> 'io_sr_msg->msg_flags', 'atalk_sendmsg()',
> 'dn_recvmsg()',  'proto_ops->recvmsg()', etc.
>
> So what should I do? Revert this patch? Or fix the usages of 'flags'?
> Or change the type of MSG_* to 'unsigned int'? I prefer the last
> one(the usages of 'flags' can be fixed too, maybe later).

The problematic code is negation of the flags when it's done in
operations like &.
It maybe fixed by swapping positions of the arguments, i.e. ~(FOO |
BAR) & flags.

All this is a beast called "integer promotions" in the C standard.

The best is to try to get flags to be unsigned. By how invasive it may be?

-- 
With Best Regards,
Andy Shevchenko
