Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB09433EB53
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCQIWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhCQIVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:21:37 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25739C06174A;
        Wed, 17 Mar 2021 01:21:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id si25so1173125ejb.1;
        Wed, 17 Mar 2021 01:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5TUXB0SjDDMLLiaDUwy96EVYsflhGnsLiJ2CfUbnN4U=;
        b=sNYvp/CJVFmdyfeyM1yCZa3fY7VK6UYfm7nFFbFBhANpuUvq75GWcqPIh9EgLjWyvs
         KQNcQ2hem9oq9aBdoNY7jgx4aFf40mV0XQ0Wph/a5cvfrKXRl6hwsrsjc1PV/dswHVlR
         UJbVdToLwxGtrKatkeEplo0r77qzxAGv8OP3PN7AhbeC1qBX7kQ8q24PDfNiCFSwxGAY
         R6QBSbaRC8oBhF3kVot5BNMCOBokaC2BUyW/DgwFmQAahTJbMHa/9EB6evPGImQUm3IY
         0a5XNBnWZm5LgDY26dDu2Wmo6qCG7PH3TNyYiXj3UvFrYRQmuBc+NIkgu46leLUtRhEx
         eqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5TUXB0SjDDMLLiaDUwy96EVYsflhGnsLiJ2CfUbnN4U=;
        b=osk8HOTzhVqTdqSAyiyUzfjt88SoXqosEIpOd2UT+uIPrn1zLoQOqJxKfDPSeNfofe
         ZgM8WAxSwSv4oj0qvYv3IFbYRFxCwX0H/IUd//Ncz2rg26q6LJ8eil2rCV1FBjz7LXK/
         Talvd0WAH/WX/A+IoAmFV7jsnfE0ulDeKBblAcZlmix632zESCnfXak3pVxKU6xEExrU
         uAPALgWHf7VCwlmQKoG72aMk3EB7yzgshdqUeRWcB/4PVU97dDV0v2Ot5aTBJaqKJgWk
         lnv7JYrxA99hNd1wCsNfqsMXPQ90L8lGJlTmJx7dNguKpsmewDJhztxTCJPhFqr9YX5G
         6YUw==
X-Gm-Message-State: AOAM532bBLzk2nICUL1VvT0heuhHM1wYSk4hcwmwKef/yE9SLLxmaOga
        BF9K6pM2izpNQFLQuG2+ynJZ7zf7kIj9SNwRcRk=
X-Google-Smtp-Source: ABdhPJyI/rvF9EWYrEvJdt3XJpPME5ivMWQi/KgfDRKxG8mtlORq7Po6+GftCqS8ndIyVEN6hcLsAAgx7zOu4mjyoYc=
X-Received: by 2002:a17:907:20f5:: with SMTP id rh21mr33990690ejb.27.1615969286949;
 Wed, 17 Mar 2021 01:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net>
In-Reply-To: <20210317013758.GA134033@roeck-us.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 17 Mar 2021 16:21:14 +0800
Message-ID: <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
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

Hello,

On Wed, Mar 17, 2021 at 9:38 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, Mar 17, 2021 at 01:02:51AM +0200, Andy Shevchenko wrote:
> > On Wednesday, March 17, 2021, Guenter Roeck <linux@roeck-us.net> wrote:
> >
...
>
> The problem is in net/packet/af_packet.c:packet_recvmsg(). This function,
> as well as all other rcvmsg functions, is declared as
>
> static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>                           int flags)
>
> MSG_CMSG_COMPAT (0x80000000) is set in flags, meaning its value is negative.
> This is then evaluated in
>
>        if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
>                 goto out;
>
> If any of those flags is declared as BIT() and thus long, flags is
> sign-extended to long. Since it is negative, its upper 32 bits will be set,
> the if statement evaluates as true, and the function bails out.
>
> This is relatively easy to fix here with, for example,
>
>         if ((unsigned int)flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
>                 goto out;
>
> but that is just a hack, and it doesn't solve the real problem:
> Each function in struct proto_ops which passes flags passes it as int
> (see include/linux/net.h:struct proto_ops). Each such function, if
> called with MSG_CMSG_COMPAT set, will fail a match against
> ~(MSG_anything) if MSG_anything is declared as BIT() or long.
>
> As it turns out, I was kind of lucky to catch the problem: So far I have
> seen it only on mips64 kernels with N32 userspace.
>
> Guenter

 Wow, now the usages of 'msg_flag' really puzzle me. Seems that
it is used as 'unsigned int' somewhere, but 'int' somewhere
else.

As I found, It is used as 'int' in 'netlink_recvmsg()',
'io_sr_msg->msg_flags', 'atalk_sendmsg()',
'dn_recvmsg()',  'proto_ops->recvmsg()', etc.

So what should I do? Revert this patch? Or fix the usages of 'flags'?
Or change the type of MSG_* to 'unsigned int'? I prefer the last
one(the usages of 'flags' can be fixed too, maybe later).


Thanks!
Menglong Dong
