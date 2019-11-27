Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE0A10B30F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfK0QTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:19:06 -0500
Received: from mail-vs1-f41.google.com ([209.85.217.41]:36731 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0QTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:19:05 -0500
Received: by mail-vs1-f41.google.com with SMTP id m5so10885169vsj.3
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l6t5AsqVo9sjZTwv1Tc6avG/LYKLI/L5JbRAsDeM7UQ=;
        b=pocZJtlRhuWzWfepyeuwnzD1sfnM12gGeOdMZmVF8BwXXRPjtN8zg5bVq2kgLAFhqQ
         sisdSDQeX40HLCeDMBJfqPqpO7EoeKjn41gejmUzOMHga9WZPlm9HFMA5NfEobimghh4
         fH1E9QbDYiUlrK8Iv/kmRfUZLOWY/s5AvoAhauBe5CP1xewbFfgbUMFZNWF07uY2B7yV
         pIxlGbF3kK8v+jL8bGViPGk5MDuxzNCTg47pF+jCl9JQIFZLGigvmccdkePLXZ2VB5br
         kUrkRNEbgie6rqWXPVLwHejKPq44ndEIY3AmRofz6Ta293Vz4x/DOpv0dS5E/LqwxdvT
         OGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l6t5AsqVo9sjZTwv1Tc6avG/LYKLI/L5JbRAsDeM7UQ=;
        b=H22zx5JEJwNDoWVhhE2L7vn+AauVK3YYco3Wwqxlp7mJTt+IHKLVhfHer9qKWYa1cS
         z3KHEhVo6Gu0lnCTSQI6a8nYZIT77vBL7A0UHj50dF3eCaxL1sPS9jvIpjTTNCoNMiiO
         9KieAyuKXH9B4rH6LzInul41GjfQmDS/aXVq3hUFv2Hq7Hrcs9iwxIAhqMnY3gaVrp8d
         ax1ZbEWBXkD4yOZ2W833Jfj9W8WOQ0WBXcBcVUtqSROfqCiEmp+39JvzTATwYhHcp8EX
         4r+gAGsmz1xx16WLDcz0x2rbxkSXcACgiU5V0G5wyI2/wp74Fc+cLm4pgyxaVw+G4XiX
         mEGw==
X-Gm-Message-State: APjAAAXhjfJaHktY+pNwNM8FS3EDOhQO8agTZorvYHk4rYvBRowv3bQF
        vg1T9JZ9zezKzwTLKkwhUX1E795zXKb6VKOpNiILCQ==
X-Google-Smtp-Source: APXvYqz/NCFyn6wXW32wMi2OdWJLNxra1AblAtr2uKylniZSH5Vbckc0WZfzrwlT2EkasYzl/qseEBk5tLYZ+h+c/cA=
X-Received: by 2002:a67:ec82:: with SMTP id h2mr2386431vsp.96.1574871544340;
 Wed, 27 Nov 2019 08:19:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
 <CANP3RGfAT199GyqWC7Wbr2983jO1vaJ1YJBSSXtFJmGJaY+wiQ@mail.gmail.com>
In-Reply-To: <CANP3RGfAT199GyqWC7Wbr2983jO1vaJ1YJBSSXtFJmGJaY+wiQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 27 Nov 2019 08:18:53 -0800
Message-ID: <CANP3RGfLkxodi=SB3KuS+Vhv==Akb0Ep16qNkXd+h4x23PaG=Q@mail.gmail.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 8:09 AM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> On Wed, Nov 27, 2019 at 6:08 AM Marek Majkowski <marek@cloudflare.com> wr=
ote:
> >
> > Morning,
> >
> > In my applications I need something like a connectx()[1] syscall. On
> > Linux I can get quite far with using bind-before-connect and
> > IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.
> >
> > For various UDP applications I'm establishing connected sockets from
> > specific 2-tuple. This is working fine with bind-before-connect, but
> > in UDP it creates a slight race condition. It's possible the socket
> > will receive packet from arbitrary source after bind():
> >
> > s =3D socket(SOCK_DGRAM)
> > s.bind((192.0.2.1, 1703))
> > # here be dragons
> > s.connect((198.18.0.1, 58910))
> >
> > For the short amount of time after bind() and before connect(), the
> > socket may receive packets from any peer. For situations when I don't
> > need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
> > issue. This code is fine:
> >
> > s =3D socket(SOCK_DGRAM)
> > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > s.bind((192.0.2.1, 0))
> > s.connect((198.18.0.1, 58910))
> >
> > But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
> > selected. It seems natural to expand the scope of
> > IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:
> >
> > s =3D socket(SOCK_DGRAM)
> > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > s.bind((192.0.2.1, 1703))
> > s.connect((198.18.0.1, 58910))
> >
> > I would like such code to delay the binding to port 1703 up until the
> > connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
> > sockets anyway. This raises a couple of questions though:
> >
> >  - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
> > number in the bind!
> >
> >  - Where to store the source port in __inet_bind. Neither
> > inet->inet_sport nor inet->inet_num seem like correct places to store
> > the user-passed source port hint. The alternative is to introduce
> > yet-another field onto inet_sock struct, but that is wasteful.
> >
> > Suggestions?
> >
> > Marek
> >
> > [1] https://www.unix.com/man-page/mojave/2/connectx/
>
> attack BPF socket filter drop all, then bind, then connect, then replace =
it.

Although I guess perhaps you'd consider dropping the packets to be bad...?
Then I think you might be able to do the same trick with
SO_BINDTODEVICE("dummy0") instead of bpf and then SO_BINDTODEVICE("")
That unfortunately requires privs though.
