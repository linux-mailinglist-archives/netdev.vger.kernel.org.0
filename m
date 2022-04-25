Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C262C50E450
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242838AbiDYP05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242810AbiDYP04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:26:56 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3B4E124A
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:23:52 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id h7so4325748ybj.1
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZd5EczkiGolyHz5oEhmG3wS2R1SFCBG80Ty4+Hqe/Y=;
        b=GcboBtoiKJtIAtpmX3AM3BFMDpK5D38mI7ywJfCiWDm4k2edplCfHaCLEeePZG1c8c
         RrSsK+NIDYhEmaB2MDE0+wSrXHr8LQfDfaI9UOnEdwteobsoUvXq1EZcKVo1sWKs6WbB
         feArJIXcNSU6TZR/ECZc41dV+83hSS6c3Hz3JJeo1MsKenLZTgrLzDZUD1He2II29+Ta
         ihY9jk5aqOkMJksYhVjGWP3lcdPASIPGxPm5wl9+Cz0qarjk3eSZM55C08gZF26XQLNn
         M5gKlruOj79UPwrl+BglX75cXqIVnuSvcJwPTMRAJ21WtqsNZbZ4OBgzieuOejAhZ1YD
         wRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZd5EczkiGolyHz5oEhmG3wS2R1SFCBG80Ty4+Hqe/Y=;
        b=4lAqlTuNwPx1rU7nUD70ixZLB3msirph8qMCdD+YEYSeGxX+/hW/QD5d7QgIQHidSz
         +99dfb5gpjv+4Tq8IvROvyfzQMtIgVuzW5+xovg7sgjUyBRq350RSq5lAdImAKW5hBc7
         jiD6Qxztspae0rQIj9d54L64vSfzIXEIC3/hc/RtVvsQJayC7t7I6TKk4U7M/u2u8mUU
         As4RBuiD99FEFB0o76TxFGJVOPQceUNp7kBFSoffVExFxOTFtO1/S9hu596HMw4LCNMV
         gbg0EDUeaSHgR0CuOs5aarB0SqoxXyaholqFrGbjmD1tYx5RxFCOJ9yp0k1CK+EVMtWv
         Jfhw==
X-Gm-Message-State: AOAM533qVarJYrRW6xSDlYF/VXV1hkI3mC3BU8VdwMZ6Hx25D8uGhHTD
        jOiGtvJvkCH2Dp5l1pCYKFUR7rd3l1V4Xcv3PtVocQ==
X-Google-Smtp-Source: ABdhPJxV6g+y5nHfcRBllZjQaubOgiLxY2wa47b9YbV6qUtn4EzoIF/m3VGazpK8z7zqaeAE1dTwvL+zEv9GMqHsGhg=
X-Received: by 2002:a05:6902:72f:b0:63d:6201:fa73 with SMTP id
 l15-20020a056902072f00b0063d6201fa73mr2453543ybt.55.1650900230816; Mon, 25
 Apr 2022 08:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de> <20220425074146.1fa27d5f@kernel.org>
 <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
 <20220425080057.0fc4ef66@kernel.org> <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
 <CAG48ez0nw7coDXYozaUOTThWLkHWZuKVUpMosY2hgVSSfeM4Pw@mail.gmail.com>
In-Reply-To: <CAG48ez0nw7coDXYozaUOTThWLkHWZuKVUpMosY2hgVSSfeM4Pw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 08:23:39 -0700
Message-ID: <CANn89iLSmXqtrTT799naEDW-FnNRQoZv+Uo6N49-MSUxAZYwYQ@mail.gmail.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Jann Horn <jannh@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Lukas Wunner <lukas@wunner.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 8:19 AM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Apr 25, 2022 at 5:13 PM Eric Dumazet <edumazet@google.com> wrote:
> > On Mon, Apr 25, 2022 at 8:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon, 25 Apr 2022 16:49:34 +0200 Jann Horn wrote:
> > > > > Doesn't mean we should make it legal. We can add a warning to catch
> > > > > abuses.
> > > >
> > > > That was the idea with
> > > > https://lore.kernel.org/netdev/20220128014303.2334568-1-jannh@google.com/,
> > > > but I didn't get any replies when I asked what the precise semantics
> > > > of dev_hold() are supposed to be
> > > > (https://lore.kernel.org/netdev/CAG48ez1-OyZETvrYAfaHicYW1LbrQUVp=C0EukSWqZrYMej73w@mail.gmail.com/),
> > > > so I don't know how to proceed...
> > >
> > > Yeah, I think after you pointed out that the netdev per cpu refcounting
> > > is fundamentally broken everybody decided to hit themselves with the
> > > obliviate spell :S
> >
> > dev_hold() has been an increment of a refcount, and dev_put() a decrement.
> >
> > Not sure why it is fundamentally broken.
>
> Well, it's not quite a refcount. It's a count that can be incremented
> and decremented but can't be read while the device is alive, and then
> at some point it turns into a count that can be read and decremented
> but can't be incremented (see
> https://lore.kernel.org/netdev/CAG48ez1-OyZETvrYAfaHicYW1LbrQUVp=C0EukSWqZrYMej73w@mail.gmail.com/).
> Normal refcounts allow anyone who is holding a reference to add
> another reference.

On a live netdev nothing wants to read the 'current refcount'.
We basically do not care.

>
> > There are specific steps at device dismantles making sure no more
> > users can dev_hold()
>
> So you're saying it's intentional that even if you're already holding
> a dev_hold() reference, you may not be allowed to call dev_hold()
> again?

I think you can/should not.
We might add a test in dev_hold() and catch offenders.

Then add a new api, (dev_hold() is void and can not propagate an
error), and eventually
fix offenders.
