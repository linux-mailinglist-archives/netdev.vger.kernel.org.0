Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA5663B5E7
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiK1Xau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiK1Xar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:30:47 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4464032066;
        Mon, 28 Nov 2022 15:30:46 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so10502869pjo.3;
        Mon, 28 Nov 2022 15:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ChtFtrRuodDH/glhfn1Qnds7vhl+8UrGChHJeSIkbLE=;
        b=XqhgI85HYhCpZv6bh5Ai74HV5VxWm/wcYtPEL+lcwggoXyH5kdskxSvdOb5fpIdU1s
         0w5L19S2NxN8NXkDvxsriX3jf2AgjLpPgQQlhEqVXW7mCHvzAEt39DN3NN5MveeAqQ96
         SFvGTHj4azIJO0vcV7bW1yyIaeIMrnXiXR41RIXszEDJFc5URdhrFh08G20bPxkLVTNO
         onJmSbSJdGmd5Bw//RPK2+BbuBvc/aR27ytOm5xxArMqok1SSusQbC//psxClsa5eM32
         j4QTrLC7gL1rVMHtFoILB/rzJldXi4wYhX6cUuvmfs6W5OrNhhqtb+XT+owrNOfTqhEO
         JYrg==
X-Gm-Message-State: ANoB5plgV3gyHsNhpwuWGcGbfw/9THP2UWmo2rZGjybVdBoIedUq9fon
        W5n3gJDbAuIHQPXUywurcWegfsdac5HhZYTLiPL2meusklcRqA==
X-Google-Smtp-Source: AA0mqf4KurkCGILVWnutf4o803oh/Sx3WYqvakG/gIg8+s+EdMu1Sq92uwpXuj0UzowKo1ZYt54x+/0uKiFNqRGu28E=
X-Received: by 2002:a17:903:452:b0:189:6574:7ac2 with SMTP id
 iw18-20020a170903045200b0018965747ac2mr20120313plb.65.1669678245655; Mon, 28
 Nov 2022 15:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch> <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
 <Y4OD70GD4KnoRk0k@rowland.harvard.edu> <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
 <CAMZ6RqKS0sUFZWQfmRU6q2ivWEUFD06uiQekDr=u94L3uij3yQ@mail.gmail.com> <Y4TYzgOczlegG7OK@rowland.harvard.edu>
In-Reply-To: <Y4TYzgOczlegG7OK@rowland.harvard.edu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 08:30:34 +0900
Message-ID: <CAMZ6RqKuGC8eyMb45x_oVBTQ0M707JhL-oUs34+8c267cKovAw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 00:50, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, Nov 28, 2022 at 02:32:23PM +0900, Vincent MAILHOL wrote:
> > On Mon. 28 Nov. 2022 at 10:34, Vincent MAILHOL
> > <mailhol.vincent@wanadoo.fr> wrote:
> > > On Mon. 28 Nov. 2022 at 00:41, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > > On Sun, Nov 27, 2022 at 02:10:32PM +0900, Vincent MAILHOL wrote:
> > > > > > Should devlink_free() be after usb_set_inftdata()?
> > > > >
> > > > > A look at
> > > > >   $ git grep -W "usb_set_intfdata(.*NULL)"
> > > > >
> > > > > shows that the two patterns (freeing before or after
> > > > > usb_set_intfdata()) coexist.
> > > > >
> > > > > You are raising an important question here. usb_set_intfdata() does
> > > > > not have documentation that freeing before it is risky. And the
> > > > > documentation of usb_driver::disconnect says that:
> > > > >   "@disconnect: Called when the interface is no longer accessible,
> > > > >    usually because its device has been (or is being) disconnected
> > > > >    or the driver module is being unloaded."
> > > > >   Ref: https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/usb.h#L1130
> > > > >
> > > > > So the interface no longer being accessible makes me assume that the
> > > > > order does not matter. If it indeed matters, then this is a foot gun
> > > > > and there is some clean-up work waiting for us on many drivers.
> > > > >
> > > > > @Greg, any thoughts on whether or not the order of usb_set_intfdata()
> > > > > and resource freeing matters or not?
> > > >
> > > > In fact, drivers don't have to call usb_set_intfdata(NULL) at all; the
> > > > USB core does it for them after the ->disconnect() callback returns.
> > >
> > > Interesting. This fact is widely unknown, cf:
> > >   $ git grep "usb_set_intfdata(.*NULL)" | wc -l
> > >   215
> > >
> > > I will do some clean-up later on, at least for the CAN USB drivers.
> > >
> > > > But if a driver does make the call, it should be careful to ensure that
> > > > the call happens _after_ the driver is finished using the interface-data
> > > > pointer.  For example, after all outstanding URBs have completed, if the
> > > > completion handlers will need to call usb_get_intfdata().
> > >
> > > ACK. I understand that it should be called *after* the completion of
> > > any ongoing task.
> > >
> > > My question was more on:
> > >
> > >         devlink_free(priv_to_devlink(es58x_dev));
> > >         usb_set_intfdata(intf, NULL);
> > >
> > > VS.
> > >
> > >         usb_set_intfdata(intf, NULL);
> > >         devlink_free(priv_to_devlink(es58x_dev));
> > >
> > > From your comments, I understand that both are fine.
> >
> > Do we agree that the usb-skeleton is doing it wrong?
> >   https://elixir.bootlin.com/linux/latest/source/drivers/usb/usb-skeleton.c#L567
> > usb_set_intfdata(interface, NULL) is called before deregistering the
> > interface and terminating the outstanding URBs!
>
> Going through the usb-skeleton.c source code, you will find that
> usb_get_intfdata() is called from only a few routines:
>
>         skel_open()
>         skel_disconnect()
>         skel_suspend()
>         skel_pre_reset()
>         skel_post_reset()
>
> Of those, all but the first are called only by the USB core and they are
> mutually exclusive with disconnect processing (except for
> skel_disconnect() itself, of course).  So they don't matter.
>
> The first, skel_open(), can be called as a result of actions by the
> user, so the driver needs to ensure that this can't happen after it
> clears the interface-data pointer.  The user can open the device file at
> any time before the minor number is given back, so it is not proper to
> call usb_set_intfdata(interface, NULL) before usb_deregister_dev() --
> but the driver does exactly this!
>
> (Well, it's not quite that bad.  skel_open() does check whether the
> interface-data pointer value it gets from usb_get_intfdata() is NULL.
> But it's still a race.)
>
> So yes, the current code is wrong.  And in fact, it will still be wrong
> even after the usb_set_intfdata(interface, NULL) line is removed,
> because there is no synchronization between skel_open() and
> skel_disconnect().

ACK. I did not look outside of skel_disconnect(). Regardless, I think
that removing the usb_set_intdata(interface, NULL) is still one step
in the good direction despite the other synchronisation issues. I sent
a patch for that which Greg already pick-up:
  https://git.kernel.org/gregkh/usb/c/c568f8bb41a4

>It is possible for skel_disconnect() to run to
> completion and the USB core to clear the interface-data pointer all
> while skel_open() is running.  The driver needs a static private mutex
> to synchronize opens with unregistrations.  (This is a general
> phenomenon, true of all drivers that have a user interface such as a
> device file.)
>
> The driver _does_ have a per-instance mutex, dev->io_mutex, to
> synchronize I/O with disconnects.  But that's separate from
> synchronizing opens with unregistrations, because at open time the
> driver doesn't yet know the address of the private data structure or
> even if the structure is still allocated.  So obviously it can't use a
> mutex that is embedded within the private data structure for this
> purpose.

ACK. However, I have other priorities, I will not invest more time to
dig in the usb-skeleton.c

Thank you for the answer! That was a long but interesting diversion
from the initial topic :)


Yours sincerely,
Vincent Mailhol
