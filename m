Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAAAF09E4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfKEWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:53:49 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35748 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbfKEWxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:53:49 -0500
Received: by mail-io1-f67.google.com with SMTP id x21so9025367iol.2
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKrTY3jlhLhmcjIphEDeO/pwSWZP0KVGNK4YR5g382c=;
        b=szDMLvDU+0kkk/UNmRCcB+f9LDg+r5VPT78f13aALNx1rUnk43S0aypbUzXBiCENXb
         b6PqkkQNZiBEwlWqjvI54u7IuMkaSSlXwiH1ku9iXlINJPP/2yp8hcTgUQwFxwpM2mp0
         2947V+fsV+vICrzcN6SoXeOpCT2r21Kv0UCN1cRaiownUQW6S2i6uusDzCIrR9hE5+C/
         GIoAVgJ3zPndb6+UFRWLUfOhPszlACL6vKNGm+sAGLdGD1IJCkt891UYSaYNWt5CDOCW
         v9Hkyr/ZWnxuK3HW9Jzn+8jN2+zq2pci1jBDZi33uQYiW0iyON13BCb+ybZxJ+Tc8qZo
         T7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKrTY3jlhLhmcjIphEDeO/pwSWZP0KVGNK4YR5g382c=;
        b=N2UBm1GAb996NbpzWM8kBnsndjstc1DqWpz4cTtGc9nlO6BtC+aV42KhMnYH/8ginD
         TYLUyN4/YzBZE3dpWlBC6pRaQAuaWGuEKXyfLSznRUiUb9i+zMifZ4HHIYkoCfmUZrZG
         qkqgnBd+o4v3jawXPPCv3nRhbWLmTQTgQ1By7zyOzTd3Y6OBvdtb0vIyrf6mI9ZoW4K6
         EJhsc5Yow3Yl1bcsvya6MDolkjGVeZgObwAD46rgCjFgZ2QsaD9C1tGIzhQSjfPfVvEs
         +3wAC5KFT6+OC7CWprtawA6LID/T7He0Kq+i1n7qSyOBbeRYCb2ATs2D8gO+nwAW4Xtj
         l48w==
X-Gm-Message-State: APjAAAUMnOy5KaHaAyvmFcIBkxnb4VakD05vvjDdas/oacFHq0eJzUo5
        qE4buw+2K/jdurYV7jy60vZgdsWvzwl5dCjsUoUAdw==
X-Google-Smtp-Source: APXvYqw+s4RwFTBPQu/+4LpQIFo/7wObpctplDoL4UY7qayrt7aKxwUP8iEIxsgR0nLp5ZEgmT0J7Fca/bM/JhVLIF4=
X-Received: by 2002:a5d:9059:: with SMTP id v25mr28913926ioq.58.1572994428253;
 Tue, 05 Nov 2019 14:53:48 -0800 (PST)
MIME-Version: 1.0
References: <20191105031315.90137-1-edumazet@google.com> <20191105031315.90137-3-edumazet@google.com>
 <20191105144857.3c8d531a@cakuba.netronome.com>
In-Reply-To: <20191105144857.3c8d531a@cakuba.netronome.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 5 Nov 2019 14:53:36 -0800
Message-ID: <CANn89iL8ox5P8MrMBCGssz7g2euPieTPK3Vx9Lxo93eVAoE7mg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net_sched: extend packet counter to 64bit
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 2:49 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon,  4 Nov 2019 19:13:14 -0800, Eric Dumazet wrote:
> > diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
> > index 5f3889e7ec1bb8b5148e9c552dd222b7f1c077d8..1424e02cef90c0139a175933577f1b8537bce51a 100644
> > --- a/include/net/gen_stats.h
> > +++ b/include/net/gen_stats.h
> > @@ -10,8 +10,8 @@
> >  /* Note: this used to be in include/uapi/linux/gen_stats.h */
> >  struct gnet_stats_basic_packed {
> >       __u64   bytes;
> > -     __u32   packets;
> > -} __attribute__ ((packed));
> > +     __u64   packets;
> > +};
>
> nit: if there needs to be a respin for other reason perhaps worth
> s/__u/u/ as this is no longer a uAPI structure?

Yes, I had this in my mind, we have __u32 all over the places, with a
mix of u32/__u32 in some classes :/

Thanks.
