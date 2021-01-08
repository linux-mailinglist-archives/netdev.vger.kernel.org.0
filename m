Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311922EEEF6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 09:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbhAHI6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 03:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbhAHI6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 03:58:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE68C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 00:58:01 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j16so10502598edr.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 00:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bKQ/ttMUrhimZQGoKMRNf+2UEFx85PaZVm57Q1Ut674=;
        b=Ah/MiDiAhe8WbIYRWDrw8rUfvBVmqSyUJmOiITxwGfsxvSsMaIv7kylUNi6TsifBx6
         I2otpg+ltft5ju2NXRL1DxdYQLgFYmLUeV0/CfXAGcHVIDEdGlUt0QATAwsHVp8CT21T
         gNT/Ox9lNUnRJp0/ijG0kXz5FjAnp90xGTGRupcohKEStfD9rmtVaagREdwhcIAk/a4V
         S3oXN9WOf++a3SCzj1xC/vrTECF5Vkm5LQMqbVV6rEe7dxoq0+ifSw4X/cRsQ0sVFTEa
         OeZdr7V/FNa8GdQcnmmod1M1L2oCQp0SSsZQnGT4McgQSvE+QI1bojOGy6qVZ1JTCmL8
         +jpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bKQ/ttMUrhimZQGoKMRNf+2UEFx85PaZVm57Q1Ut674=;
        b=NVMz4MqQjoD5aym8lVUvlEjx/8KFeQ9mzQza0c4uRImY3K52POzsHCaOjQn7yGg+Qb
         5naEWLG7clyVeUQsMyquFvQ7d0vaB0NnA1rq/obbR2G0t7GtqsH3aKWsYx89O75PDktu
         oIi/8X29+RY8mHxI49rUdg0JyxLze2UdaT6uwUVeZp9/GgmnDIFzs8N5kQhU0VhQ8EtP
         Dx7pQz9fuokfdqiR3rw5xMVk0flgUHq5h2hfex3vFrcBflYGBKsKoQ5lIrTY3HwstKgP
         W9G+JyVkyGJ0whBwxT2pRiJtZPX5JPewenthbeUNJ04Ze3LpnF4offRQ5A3SDWNC5AH8
         CR8w==
X-Gm-Message-State: AOAM532F/dvLZo9tzkbv4T1vuQTt4onCwJg6fuvSljr9JUaQ5GVImSJ+
        g9g1wmqmP7vvDSaFncG0QQD/97IAMkc=
X-Google-Smtp-Source: ABdhPJzQp5oLIxB/CjPexDpRA7deMYEyc82hLkZqhi4g7sp1TTB93lBKwhMpXcr0LhBYZFYlfHNYCQ==
X-Received: by 2002:a50:fc96:: with SMTP id f22mr4757882edq.162.1610096280180;
        Fri, 08 Jan 2021 00:58:00 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lz17sm3303865ejb.19.2021.01.08.00.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 00:57:59 -0800 (PST)
Date:   Fri, 8 Jan 2021 10:57:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
Message-ID: <20210108085758.yvokxncj3twrsxko@skbuf>
References: <20210107094951.1772183-1-olteanv@gmail.com>
 <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
 <20210107113313.q4e42cj6jigmdmbs@skbuf>
 <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
 <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 07:59:37PM -0800, Saeed Mahameed wrote:
> On Thu, 2021-01-07 at 13:58 +0100, Eric Dumazet wrote:
> > On Thu, Jan 7, 2021 at 12:33 PM Vladimir Oltean <olteanv@gmail.com>
> > wrote:
> > > On Thu, Jan 07, 2021 at 12:18:28PM +0100, Eric Dumazet wrote:
> > > > What a mess really.
> > >
> > > Thanks, that's at least _some_ feedback :)
> >
> > Yeah, I was on PTO for the last two weeks.
> >
> > > > You chose to keep the assumption that ndo_get_stats() would not
> > > > fail,
> > > > since we were providing the needed storage from callers.
> > > >
> > > > If ndo_get_stats() are now allowed to sleep, and presumably
> > > > allocate
> > > > memory, we need to make sure
> > > > we report potential errors back to the user.
> > > >
> > > > I think your patch series is mostly good, but I would prefer not
> > > > hiding errors and always report them to user space.
> > > > And no, netdev_err() is not appropriate, we do not want tools to
> > > > look
> > > > at syslog to guess something went wrong.
> > >
> > > Well, there are only 22 dev_get_stats callers in the kernel, so I
> > > assume
> > > that after the conversion to return void, I can do another
> > > conversion to
> > > return int, and then I can convert the ndo_get_stats64 method to
> > > return
> > > int too. I will keep the plain ndo_get_stats still void (no reason
> > > not
> > > to).
> > >
> > > > Last point about drivers having to go to slow path, talking to
> > > > firmware : Make sure that malicious/innocent users
> > > > reading /proc/net/dev from many threads in parallel wont brick
> > > > these devices.
> > > >
> > > > Maybe they implicitly _relied_ on the fact that firmware was
> > > > gently
> > > > read every second and results were cached from a work queue or
> > > > something.
> > >
> > > How? I don't understand how I can make sure of that.
> >
> > Your patches do not attempt to change these drivers, but I guess your
> > cover letter might send to driver maintainers incentive to get rid of
> > their
> > logic, that is all.
> >
> > We might simply warn maintainers and ask them to test their future
> > changes
> > with tests using 1000 concurrent theads reading /proc/net/dev
> >
> > > There is an effort initiated by Jakub to standardize the ethtool
> > > statistics. My objection was that you can't expect that to happen
> > > unless
> > > dev_get_stats is sleepable just like ethtool -S is. So I think the
> > > same
> > > reasoning should apply to ethtool -S too, really.
> >
> > I think we all agree on the principles, once we make sure to not
> > add more pressure on RTNL. It seems you addressed our feedback, all
> > is fine.
> >
>
> Eric, about two years ago you were totally against sleeping in
> ndo_get_stats, what happened ? :)
> https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/

I believe that what is different this time is that DSA switches are
typically connected over a slow and bottlenecked bus (so periodic
driver-level readouts would only make things worse for phc2sys and
such other latency-sensitive programs), plus they are offloading
interfaces for forwarding (so software-based counters could never be
accurate). Support those, and supporting firmware-based high-speed
devices will come as a nice side-effect.
FWIW that discussion took place here:
https://patchwork.ozlabs.org/project/netdev/patch/20201125193740.36825-3-george.mccollister@gmail.com/

> My approach to solve this was much simpler and didn't require  a new
> mutex nor RTNL lock, all i did is to reduce the rcu critical section to
> not include the call to the driver by simply holding the netdev via
> dev_hold()

I feel this is a call for the bonding maintainers to make. If they're
willing to replace rtnl_dereference with bond_dereference throughout the
whole driver, and reduce other guys' amount of work when other NDOs
start losing the rtnl_mutex too, then I can't see what's wrong with my
approach (despite not being "as simple"). If they think that update-side
protection of the slaves array is just fine the way it is, then I
suppose that RCU protection + dev_hold is indeed all that I can do.
