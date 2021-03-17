Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4134B33E647
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCQBib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCQBiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 21:38:13 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7AAC06174A;
        Tue, 16 Mar 2021 18:38:01 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so310611oto.2;
        Tue, 16 Mar 2021 18:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ygJ0qGMlZLdyRRUICYstxcV17G5DTyYvHgZcVYxiHc4=;
        b=hlays0fm13sewi1zSN6YvfIDRfmL4+7hMs+9qNwSJb8YpxnkR87NPck3T4vH8gd4ep
         RjY5OW0eAkP0mcv8GMS4bstWli8jih9VQoAjimteQGQX9sdSigrMglwwKMPETBLZnBpq
         5nO15OA7JwHNGYoSKh4gQNdv0sOD64ZvEDjprwrVwezsSvQ8OPiO50m+IGCu9ZZmhraX
         256H72HGA/MbW5z2xRKRFA/JRMsJl56U+S9V76LdU7DlGt0bYZ6LBjk8ctDKDMiRXjRp
         s4aVKXFgmgu4wq3SGcRllaazz7B7ljp6yz5u5EUQsNRKsp06eFN9c8ensYEiwiYSNRfV
         17jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ygJ0qGMlZLdyRRUICYstxcV17G5DTyYvHgZcVYxiHc4=;
        b=LrolSoyxWs8Q4CzSUFz1EgzXbaH4gstq4cH7Cs3yeCyZpFDW7TEF9xG43g/CDZelB0
         MGkoPXkHAz2d47a9Iu/8VONkicn+OvGmHMIpL52WnQ758d0ddCNZKi2/OsIwGSpiVECr
         2BllBeoY4LUlJuPNCAU4fy7D/OiS1GmblWYrpQBpQvP++8XmaxEorXSGYSuIkPI0DsrN
         bvmzgZCvroa6NIeWXzaApUpUNg9fa0wA0qYh78LQLv4klhp7zz1lUftoGSLFFzyxNZr+
         4O6YVvgsKqP6kSD+FRlVq0xTlaL7g4koHOiU88BfdD/kigcXDTQBGNSFvA94i7qJcr46
         QoNw==
X-Gm-Message-State: AOAM533hhXzHe5HXLdS39Ya+3F5+V6PUi2OxAERT8YS6E6HKrkxhjhsc
        p/pkq5/gbKb0N0x2bBHJQWo=
X-Google-Smtp-Source: ABdhPJy6vqZE3keXM2WxPxzCZ3xB+weik4lNstb18TIjnfbUssen5oangjtnu+p5Is9/wg9XmLX1qQ==
X-Received: by 2002:a9d:1ca1:: with SMTP id l33mr1315358ota.368.1615945081112;
        Tue, 16 Mar 2021 18:38:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m8sm8105519otl.50.2021.03.16.18.37.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 18:38:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 18:37:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Message-ID: <20210317013758.GA134033@roeck-us.net>
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net>
 <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 01:02:51AM +0200, Andy Shevchenko wrote:
> On Wednesday, March 17, 2021, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Hi,
> >
> > On Tue, Mar 09, 2021 at 05:51:35PM -0800, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <dong.menglong@zte.com.cn>
> > >
> > > The bit mask for MSG_* seems a little confused here. Replace it
> > > with BIT() to make it clear to understand.
> > >
> > > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> >
> > I must admit that I am a bit puzzled,
> 
> 
> I have checked the values and don’t see a problem. So, the only difference
> is the type int vs. unsigned long. I think this simply reveals an issue
> somewhere in the code.
> 
The problem is in net/packet/af_packet.c:packet_recvmsg(). This function,
as well as all other rcvmsg functions, is declared as

static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
                          int flags)

MSG_CMSG_COMPAT (0x80000000) is set in flags, meaning its value is negative.
This is then evaluated in

       if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
                goto out;

If any of those flags is declared as BIT() and thus long, flags is
sign-extended to long. Since it is negative, its upper 32 bits will be set,
the if statement evaluates as true, and the function bails out.

This is relatively easy to fix here with, for example,

        if ((unsigned int)flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
                goto out;

but that is just a hack, and it doesn't solve the real problem:
Each function in struct proto_ops which passes flags passes it as int
(see include/linux/net.h:struct proto_ops). Each such function, if
called with MSG_CMSG_COMPAT set, will fail a match against
~(MSG_anything) if MSG_anything is declared as BIT() or long.

As it turns out, I was kind of lucky to catch the problem: So far I have
seen it only on mips64 kernels with N32 userspace.

Guenter
