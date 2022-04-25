Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DCA50EB9D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiDYWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343590AbiDYVmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:42:37 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9248212862D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:39:31 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id y2so10603481ybi.7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3WJUY4MK6yqjvdIXl0I1q/5WszzzjbzcFFqzxBl3plQ=;
        b=miZxWVfczpNjqLUvVUos5Bd+gLvP70yfKeNo4EVOL341GJjn7Pzj4nPyRSDT8PbS7T
         SWGXyXvnQMxNDtVF0zE3odGQFZ+O9hAJu4TvkbDd6JPba0UzJaagSCrqFo5FPt3IrP3/
         UcTN7T0GaYEjs9yKoJP9nX5tKw6/XQlPDlhqdIfLqcoT/cSrN1ZmkhvDM9IUtnnuuGtL
         axKYv8g8ACKhrIX5TF8LHbctluBr5s8PADd8QJIeJTgtpiPtN6zWzX0UU5DntDkWf8Hd
         AoElyPrN0DjOXA06BCdGnARH4o0nBk1nYrDCbD7CWf2ILW8IyMi7vcsZqQnGQse6Sv17
         p5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3WJUY4MK6yqjvdIXl0I1q/5WszzzjbzcFFqzxBl3plQ=;
        b=ZoGkwpW5kvJrYgnB6J4Fx36usRIBiCiGoXkZdqwOPTZXR98Bt66tQ7xMACKHZ0d79Q
         6y6j+Mwo3KAZmlGtxWOYPMi9Ya8TaO2nV9y+2M+DmDwJJ14pKGPxTuc053S9T8kvBJPy
         nEylCxk703oMoutZ3C5rQ1Jh6UZMr7gG4xwswtcn0cqgr36wf0eWqla6w+JsVJp3AoVe
         NXs6P3dwNsetFynLSnQ/DhagBXcMVsRdLFOrVEe6fD7VgHbETDdoNKUm6ArSuBQwTeJ1
         MZ96LF35I2nCmPRT9AuO+RAn/0dGgCAe6/OFsgxnpHrYoHf4qutZuW+QzTHmLm0DQXsk
         /2NA==
X-Gm-Message-State: AOAM533U4sBJgG1eIdNn/z8y/0nxCXSJtX+wj3v8aPcjmZExych/beKS
        PBBxFGzl9MdJ9JaZm9LKoWgL6Iastw3eaAj0OPsoVQ==
X-Google-Smtp-Source: ABdhPJwYX8KAvi0eC4OjElamEyvYkV7gyA/jp1P3cLyGPIy1ci6990BYicukKktaIquS+ODjHd4fqNkwVAzVFJ5OTq4=
X-Received: by 2002:a05:6902:72f:b0:63d:6201:fa73 with SMTP id
 l15-20020a056902072f00b0063d6201fa73mr4001734ybt.55.1650922770495; Mon, 25
 Apr 2022 14:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de> <20220425074146.1fa27d5f@kernel.org> <20220425211822.GA22629@wunner.de>
In-Reply-To: <20220425211822.GA22629@wunner.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 14:39:18 -0700
Message-ID: <CANn89iLSgbA7s9AxDVnDG_0bAq6crKwm6xwfXo8cUH+b=8c+4Q@mail.gmail.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 2:18 PM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Mon, Apr 25, 2022 at 07:41:46AM -0700, Jakub Kicinski wrote:
> > On Sat, 23 Apr 2022 18:07:23 +0200 Lukas Wunner wrote:
> > > > Looking at the original report it looks like the issue could be
> > > > resolved with a more usb-specific change: e.g. it looks like
> > > > usbnet_defer_kevent() is not acquiring a dev reference as it should.
> > > >
> > > > Have you considered that path?
> > >
> > > First of all, the diffstat of the patch shows this is an opportunity
> > > to reduce LoC as well as simplify and speed up device teardown.
> > >
> > > Second, the approach you're proposing won't work if a driver calls
> > > netif_carrier_on/off() after unregister_netdev().
> > >
> > > It seems prudent to prevent such a misbehavior in *any* driver,
> > > not just usbnet.  usbnet may not be the only one doing it wrong.
> > > Jann pointed out that there are more syzbot reports related
> > > to a UAF in linkwatch:
> > >
> > > https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot
> > >
> > > Third, I think an API which schedules work, invisibly to the driver,
> > > is dangerous and misguided.  If it is illegal to call
> > > netif_carrier_on/off() for an unregistered but not yet freed netdev,
> > > catch that in core networking code and don't expect drivers to respect
> > > a rule which isn't even documented.
> >
> > Doesn't mean we should make it legal. We can add a warning to catch
> > abuses.
>
> That would be inconsequent, considering that netif_carrier_on/off()
> do not warn for a reg_state of NETREG_UNINITIALIZED.
>

Yes, only 1500 calls to audit ;)

I guess we could start adding WARN_ON_ONCE(), then wait for a few
syzbot/users reports to fix offenders...

commit b47300168e770b60ab96c8924854c3b0eb4260eb
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Nov 19 15:33:54 2008 -0800

    net: Do not fire linkwatch events until the device is registered.

    Several device drivers try to do things like netif_carrier_off()
    before register_netdev() is invoked.  This is bogus, but too many
    drivers do this to fix them all up in one go.

    Reported-by: Folkert van Heusden <folkert@vanheusden.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
