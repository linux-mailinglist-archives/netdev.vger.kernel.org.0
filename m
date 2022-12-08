Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1035D64736A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLHPpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLHPpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:45:08 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE015E9FB;
        Thu,  8 Dec 2022 07:45:03 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso6019738pjb.1;
        Thu, 08 Dec 2022 07:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9um/CJ6zRIOkXvilsnHll/Sh2DZ2yqw/uWXa4YFjEDM=;
        b=ppKMzZtR7U2SX3eLo2jxEZm1jMYhkoNMcmIlktkQ1QdUm+vfTi1IxZPm6Ro595eveB
         aT1FBP7APhP9bYSxtCEZYw/cvLfqODc77Y/MONqraHS6i//3K0zWKwzih/Ip9cquqmsr
         UUm76O24CdgUNXrj+JkOE9E+1i4XMolQHH0fjemd46d9sN+WfP0h33+t7puZ7d/FidSK
         N5rxzif8eOUEnPcveMqqZILyM24pS8GZDJDReLoSUv4rfeNCtcfO/VcpQe7qW1QnvDwV
         ul84vNy64lUItDP8TmBsCAa3hnzo145yy6C/hAfwUzELPAqYpVUsvHxqcaZTca6X+yfM
         ALfA==
X-Gm-Message-State: ANoB5plFcWlNRtM63UAwNi39uCDnFL9YrzdRv9QX/DEYnDn0IHS9A7Dm
        eL3uJS+oAQbhRl9fm8srg1tDo3r/4d96u2j//AU=
X-Google-Smtp-Source: AA0mqf6d8iiQ2ayQhca4bS8hOGwqFNQT8shEYRovzQD9oxZO/Qf7LC7I1Q483nsmWAVUcRRF92ihGjULWFpXF9ExaqA=
X-Received: by 2002:a17:903:452:b0:189:6574:7ac2 with SMTP id
 iw18-20020a170903045200b0018965747ac2mr64784125plb.65.1670514303196; Thu, 08
 Dec 2022 07:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com> <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
 <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com>
In-Reply-To: <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 9 Dec 2022 00:44:51 +0900
Message-ID: <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
Subject: Re: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in
 drivers' disconnect()
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?Q?Christoph_M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 8 Dec. 2022 at 20:04, Oliver Neukum <oneukum@suse.com> wrote:
> On 08.12.22 10:00, Vincent MAILHOL wrote:
> > On Mon. 5 Dec. 2022 at 17:39, Oliver Neukum <oneukum@suse.com> wrote:
> >> On 03.12.22 14:31, Vincent Mailhol wrote:
>
> Good Morning!

Good night! (different time zone :))

> > ACK, but I do not see the connection.
> Well, useless checks are bad. In particular, we should always
> make it clear whether a pointer may or may not be NULL.
> That is, I have no problem with what you were trying to do
> with your patch set. It is a good idea and possibly slightly
> overdue. The problem is the method.
>
> > I can see that cdc-acm sets acm->control and acm->data to NULL in his
> > disconnect(), but it doesn't set its own usb_interface to NULL.
>
> You don't have to, but you can. I was explaining the two patterns for doing so.
>
> >> which claim secondary interfaces disconnect() will be called a second time
> >> for.
> >
> > Are you saying that the disconnect() of those CAN USB drivers is being
> > called twice? I do not see this in the source code. The only caller of
> > usb_driver::disconnect() I can see is:
> >
> >    https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L458
>
> If they use usb_claim_interface(), yes it is called twice. Once per
> interface. That is in the case of ACM once for the originally probed
> interface and a second time for the claimed interface.
> But not necessarily in that order, as you can be kicked off an interface
> via sysfs. Yet you need to cease operations as soon as you are disconnected
> from any interface. That is annoying because it means you cannot use a
> refcount. From that stems the widespread use of intfdata as a flag.

Thank you for the details! I better understand this part now.

> >> In addition, a driver can use setting intfdata to NULL as a flag
> >> for disconnect() having proceeded to a point where certain things
> >> can no longer be safely done.
> >
> > Any reference that a driver can do that? This pattern seems racy.
>
> Technically that is exactly what drivers that use usb_claim_interface()
> do. You free everything at the first call and use intfdata as a flag
> to prevent a double free.
> The race is prevented by usbcore locking, which guarantees that probe()
> and disconnect() have mutual exclusion.
> If you use intfdata in sysfs, yes additional locking is needed.

ACK for the mutual exclusion. My question was about what you said in
your previous message:

| In addition, a driver can use setting intfdata to NULL as a flag
| for *disconnect() having proceeded to a point* where certain things
| can no longer be safely done.

How do you check that disconnect() has proceeded *to a given point*
using intf without being racy? You can check if it has already
completed once but not check how far it has proceeded, right?

> > What makes you assume that I didn't check this in the first place? Or
> > do you see something I missed?
>
> That you did not put it into the changelogs.
> That reads like the drivers are doing something obsolete or stupid.
> They do not. They copied something that is necessary only under
> some circumstances.
>
> And that you did not remove the checks.
>
> >> which is likely, then please also remove checks like this:
> >>
> >>          struct ems_usb *dev = usb_get_intfdata(intf);
> >>
> >>          usb_set_intfdata(intf, NULL);
> >>
> >>          if (dev) {
>
> Here. If you have a driver that uses usb_claim_interface().
> You need this check or you unregister an already unregistered
> netdev.

Sorry, but with all my best intentions, I still do not get it. During
the second iteration, inft is NULL and:

        /* equivalent to dev = intf->dev.data. Because intf is NULL,
         * this is a NULL pointer dereference */
        struct ems_usb *dev = usb_get_intfdata(intf);

        /* OK, intf is already NULL */
        usb_set_intfdata(intf, NULL);

        /* follows a NULL pointer dereference so this is undefined
         * behaviour */
       if (dev) {

How is this a valid check that you entered the function for the second
time? If intf is the flag, you should check intf, not dev? Something
like this:

        struct ems_usb *dev;

        if (!intf)
                return;

        dev = usb_get_intfdata(intf);
        /* ... */

I just can not see the connection between intf being NULL and the if
(dev) check. All I see is some undefined behaviour, sorry.

> The way this disconnect() method is coded is extremely defensive.
> Most drivers do not need this check. But it is never
> wrong in the strict sense.
>
> Hence doing a mass removal with a change log that does
> not say that this driver is using only a single interface
> hence the check can be dropped to reduce code size
> is not good.
>
>         Regards
>                 Oliver
