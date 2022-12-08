Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629BC646B41
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLHJBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLHJA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:00:58 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141134874C;
        Thu,  8 Dec 2022 01:00:58 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso4020636pjt.0;
        Thu, 08 Dec 2022 01:00:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gnfeenGHSX8pxGcDHDGsgu5jtWy1vtL2VR1fK04qMGU=;
        b=0+3NAgORvJfV2qMO3lsVn+H3Lqjdoqrb7AmM3DiJFy0jS58oKrf/zhFiC7/uc03CGI
         xOeY5msMsMNqGSx8gVsg5SvpQtVbCetLzkae8X3t7L2Uxa3FKuBrBapLmglCSbF8rlrI
         Rrh2v30VjcGLAdspYJLhKZ6A3ND0O5d1ODWut35u9qAFtqXbJeXT4qCBY5Q4Nr+ZYmZ/
         4sdrte7qg5W7/SL2wjLbJGWI1y5t6m/MpM0uUhpkFy5q/k0VqLaO6eMHQerB++ybv+dp
         HJkNevC6AVrIlAbtdPonQbAmaPaAhZxOFMDjhjV+EdU1fuwdWF2A2BcxuoSxq0hOZXA/
         1tOQ==
X-Gm-Message-State: ANoB5pn98sgA59AO+uIwrrWojjlYBwc8y551g0piXsOFHAVo90tQZHUF
        zEpjjrssnLtppy+FMc/HGSXkYAULG5HVumNakKY=
X-Google-Smtp-Source: AA0mqf659+OdeqLrf+FQ+LZZtgdCdNVN8yytNzkVh+PKns/Z4xwYuquj032CQR+ovzq7ynBjBRLwhOyGjC4yQm2+kIg=
X-Received: by 2002:a17:903:452:b0:189:6574:7ac2 with SMTP id
 iw18-20020a170903045200b0018965747ac2mr64198640plb.65.1670490057258; Thu, 08
 Dec 2022 01:00:57 -0800 (PST)
MIME-Version: 1.0
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr> <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
In-Reply-To: <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 8 Dec 2022 18:00:46 +0900
Message-ID: <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
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
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
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

On Mon. 5 Dec. 2022 at 17:39, Oliver Neukum <oneukum@suse.com> wrote:
> On 03.12.22 14:31, Vincent Mailhol wrote:
> > The core sets the usb_interface to NULL in [1]. Also setting it to
> > NULL in usb_driver::disconnects() is at best useless, at worse risky.
>
> Hi,
>
> I am afraid there is a major issue with your series of patches.
> The drivers you are removing this from often have a subsequent check
> for the data they got from usb_get_intfdata() being NULL.

ACK, but I do not see the connection.

> That pattern is taken from drivers like btusb or CDC-ACM

Where does CDC-ACM set *his* interface to NULL? Looking at:

  https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/class/cdc-acm.c#L1531

I can see that cdc-acm sets acm->control and acm->data to NULL in his
disconnect(), but it doesn't set its own usb_interface to NULL.

> which claim secondary interfaces disconnect() will be called a second time
> for.

Are you saying that the disconnect() of those CAN USB drivers is being
called twice? I do not see this in the source code. The only caller of
usb_driver::disconnect() I can see is:

  https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L458

> In addition, a driver can use setting intfdata to NULL as a flag
> for disconnect() having proceeded to a point where certain things
> can no longer be safely done.

Any reference that a driver can do that? This pattern seems racy.

By the way, I did check all the drivers:

  * ems_usb: intf is only used in ems_usb_probe() and
ems_usb_disconnect() functions.

  * esd_usb: intf is only used in the esd_usb_probe(),
    esd_usb_probe_one_net() (which is part of probing),
    esd_usb_disconnect() and a couple of sysfs functions (which only
    use intf to get a pointer to struct esd_usb).

  * gs_usb: intf is used several time but only to retrive struct
    usb_device. This seems useless, I will sent this patch to remove
    it:
    https://lore.kernel.org/linux-can/20221208081142.16936-3-mailhol.vincent@wanadoo.fr/
    Aside of that, intf is only used in gs_usb_probe(),
    gs_make_candev() (which is part of probing) and
    gs_usb_disconnect() functions.

  * kvaser_usb: intf is only used in kvaser_usb_probe() and
    kvaser_usb_disconnect() functions.

  * mcba_usb: intf is only used in mcba_usb_probe() and
    mcba_usb_disconnect() functions.

  * ucan: intf is only used in ucan_probe() and
    ucan_disconnect(). struct ucan_priv also has a pointer to intf but
    it is never used. I sent this patch to remove it:
    https://lore.kernel.org/linux-can/20221208081142.16936-2-mailhol.vincent@wanadoo.fr/

  * usb_8dev: intf is only used in usb_8dev_probe() and
    usb_8dev_disconnect().

With no significant use of intf outside of the probe() and
disconnect(), there is definitely no such "use intf as a flag" in any
of these drivers.

> You need to check for that in every driver
> you remove this code from and if you decide that it can safely be removed,

What makes you assume that I didn't check this in the first place? Or
do you see something I missed?

> which is likely, then please also remove checks like this:
>
>         struct ems_usb *dev = usb_get_intfdata(intf);
>
>         usb_set_intfdata(intf, NULL);
>
>         if (dev) {
>                 unregister_netdev(dev->netdev);

How is the if (dev) check related? There is no correlation between
setting intf to NULL and dev not being NULL.

I think dev is never NULL, but I did not assess that dev could not be NULL.

> Either it can be called a second time, then you need to leave it
> as is,

Really?! The first thing disconnect() does is calling
usb_get_intfdata(intf) which dereferences intf without checking if it
is NULL, c.f.:

  https://elixir.bootlin.com/linux/v6.0/source/include/linux/usb.h#L265

Then it sets intf to NULL.

The second time you call disconnect(), the usb_get_intfdata(intf)
would be a NULL pointer dereference.

> or the check for NULL is superfluous. But only removing setting
> the pointer to NULL never makes sense.


Yours sincerely,
Vincent Mailhol
