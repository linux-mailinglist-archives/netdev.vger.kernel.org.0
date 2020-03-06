Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5217C483
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCFReT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:34:19 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45754 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFReS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 12:34:18 -0500
Received: by mail-qk1-f193.google.com with SMTP id z12so3019946qkg.12
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 09:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9iXnTXkoGFhQUol/W+rdWLl/5ChlK9yt0cmxdRBJ3c=;
        b=Xh/fN/i5kGVcaw/0azSplxmG8yxkacb+P9xpOnwDuZCr1P3fV2uNpvEPPn0H9SoZG4
         ao+Z9EUl06XfzOpzdv7RpAAJ0wosszU8ASQtvuZM2k+2aZ4FMyRpGdvSsb4gfD9yicFS
         q2QNFLiPdlVZla0bFhUo9APW6bFs+FSvyeNrbGlgNMbDnIGRlyR1KWiN8xj813cUP8xD
         hithzXtUwbJYRxTt1u6L7BjUoFzcGRissfTIqiN1OsKr3/YFnrSk4A2W1xGyr6uaroZk
         OrurUWobG/fRF5N9pMbZO0thIMP2n9JpQUJVTK/LX42hCpNfCZ7nUsTqkWm6OGtNraHQ
         zDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9iXnTXkoGFhQUol/W+rdWLl/5ChlK9yt0cmxdRBJ3c=;
        b=aU5qBvIBjTeVn3FAgCydHzcW/Mi0GMis8Oy8Rx+DzlO8igC4GTZ2AICtH6FxLh6Igh
         3DBrD+bo2dG6BOaOM5nV8KJCEKOZN8wxRKqCRWMwOXisMOa4j78ukGUwS/O9FG9/GZSx
         KhVoN4d62dFdyFusXTg0jMhbDw4M9PQbzf5Dv3ZbvcsxrGG5NzvvW7DFruANLgdlrNIM
         b0WJSx/knFxLPcTsQVBgF+u4puI4e8WEcBC9hNRfITJoADe/hHvxvh1ciEvlZd3ygK+a
         +UpR2ONnETUXmA+q7tfZhC1Oy9fn2n7P7m3lUz1UT6lDeckZHhg/nBqT0VW5R+XjLZ8v
         LyeQ==
X-Gm-Message-State: ANhLgQ2v05LpUSVjanP/9IsLPjMc6kdXP6EQnP2yYsKf7Op05pp0Qr26
        Up5LSnknLyl4bkk7u4IgRZYs7yhd2izUx3Jv+k+a8A==
X-Google-Smtp-Source: ADFU+vuK25acNQDMR/FrwH8IkK14YR6EkiTNaDdtt/wnFZxnOyPoNNt8JWSN/fCUgW6hb35+vemPuzC/LB/f8HDfLHo=
X-Received: by 2002:a37:ef14:: with SMTP id j20mr2795259qkk.43.1583516057510;
 Fri, 06 Mar 2020 09:34:17 -0800 (PST)
MIME-Version: 1.0
References: <767580d8-1c93-907b-609c-4c1c049b7c42@pengutronix.de>
 <20200226.202326.295871777946911500.davem@davemloft.net> <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
 <20200302.111249.471862054833131096.davem@davemloft.net> <03ff979e-a621-c9a3-9be3-13677c147f91@pengutronix.de>
In-Reply-To: <03ff979e-a621-c9a3-9be3-13677c147f91@pengutronix.de>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 6 Mar 2020 18:34:05 +0100
Message-ID: <CACT4Y+brat=HBcptYy_=13ny40TuM=Y2XNUXja_zH4Z1Mwen4w@mail.gmail.com>
Subject: Re: [PATCH] bonding: do not enslave CAN devices
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 6, 2020 at 3:12 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 3/2/20 8:12 PM, David Miller wrote:
> > From: Oliver Hartkopp <socketcan@hartkopp.net>
> > Date: Mon, 2 Mar 2020 09:45:41 +0100
> >
> >> I don't know yet whether it makes sense to have CAN bonding/team
> >> devices. But if so we would need some more investigation. For now
> >> disabling CAN interfaces for bonding/team devices seems to be
> >> reasonable.
> >
> > Every single interesting device that falls into a special use case
> > like CAN is going to be tempted to add a similar check.
> >
> > I don't want to set this precedence.
> >
> > Check that the devices you get passed are actually CAN devices, it's
> > easy, just compare the netdev_ops and make sure they equal the CAN
> > ones.
>
> Sorry, I'm not really sure how to implement this check.
>
> Should I maintain a list of all netdev_ops of all the CAN devices (=
> whitelist) and the compare against that list? Having a global list of
> pointers to network devices remind me of the old days of kernel-2.4.

I think Dave means something like this:

$ grep "netdev_ops == " drivers/net/*/*.c net/*/*.c
drivers/net/hyperv/netvsc_drv.c: if (event_dev->netdev_ops == &device_ops)
drivers/net/ppp/ppp_generic.c: if (dev->netdev_ops == &ppp_netdev_ops)
net/dsa/slave.c: return dev->netdev_ops == &dsa_slave_netdev_ops;
net/openvswitch/vport-internal_dev.c: return netdev->netdev_ops ==
&internal_dev_netdev_ops;
