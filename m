Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339B86285FD
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbiKNQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238030AbiKNQu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:50:27 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3452F67D;
        Mon, 14 Nov 2022 08:49:16 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso11237018pjc.2;
        Mon, 14 Nov 2022 08:49:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mzxDj+mA+La36bwra6nbOYkYl8KiO9soSvMTuQsXDE=;
        b=lju5IcZYyZjggJDhNyl3d1E4q2R3IZEvxlcaW4t7teeIq8uwwew3cqQeIV4MfR1/6l
         Fk+TqvFprS1lVwnf1ps19/jCAi4phUkk9YQbq6M2XFPeEKh3B2yEYv9Ug94bt9cCmSQh
         1knT5qB49FgvjdHGj1wgGPzDKn1no1ZFD17wPpq96gH4kGEKOBeR5yDC9wDmkVCo/yYH
         wipbpQKQihg6NnwbOryzMmTJLqu8wK0tMziOmIBxUKMrqASYul0MsXNxSqRiZ2RAnXcu
         ewDPCWT46bngOEO33YMWuv33StI178OFf7up4JM1/NZ90qQgOZrrwiAYUZi5xpnv/V9u
         RxaA==
X-Gm-Message-State: ANoB5pnuPsbkD5m0QYaZtJXVgCs0z3cOgq9HsvH2LHJ5TU8JRzloGIYG
        hYO4r5N2LVma+f4Fr4qC6BJITHaSSVA/d8o4/0BL6Gi8mnI=
X-Google-Smtp-Source: AA0mqf6XAxehGJwMf5feUmqitNO/qqOsBOB6BHIcUE4Pj6QUzQ5gohUxuEE1OtexiIrmiFVLX1+DMIQFoQwUFWFmAhQ=
X-Received: by 2002:a17:902:ed41:b0:175:105a:3087 with SMTP id
 y1-20020a170902ed4100b00175105a3087mr141889plb.65.1668444556100; Mon, 14 Nov
 2022 08:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr> <Y3Ef4K5lbilY3EQT@lunn.ch>
In-Reply-To: <Y3Ef4K5lbilY3EQT@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 15 Nov 2022 01:49:04 +0900
Message-ID: <CAMZ6RqLjcxDG_yCK3dfYr2dWb7sddRPMDGwXRy62c6WHDH5=Gw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] can: etas_es58x: report firmware, bootloader and
 hardware version
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
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

On Mon. 14 Nov. 2022 at 02:03, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Nov 13, 2022 at 01:01:05PM +0900, Vincent Mailhol wrote:
> > The goal of this series is to report the firmware version, the
> > bootloader version and the hardware revision of ETAS ES58x
> > devices.
> >
> > These are already reported in the kernel log but this isn't best
> > practise. Remove the kernel log and instead export all these in
> > sysfs. In addition, the firmware version is also reported through
> > ethtool.
>
> Sorry to only comment on version 3, rather than version 1. I don't
> normally look at CAN patches.

Actually, I only started to CC linux-usb mailing from version 2.
Regardless, thanks a lot, this is a valuable feedback.

> Have you considered using devlink?
>
> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-info.html

I have not thought about this (I simply did not know the existence of
this feature). A first quick look makes me think it is a good idea. I
will continue to investigate.

> fw and asic.id would cover two of your properties. Maybe talk to Jiri
> about the bootloader. It might make sense to add it is a new common
> property, or to use a custom property.

I will try to report the firmware version and the hardware version in
a first step and then see what we can do for the bootloader.

> devlink has the advantage of being a well defined, standardised API,
> rather than just random, per device sys files.

ACK.

> There might also be other interesting features in devlink, once you
> have basic support. Many Ethernet switch drivers use devlink regions
> to dump all the registers, for example.

I am aware of ethtool_drvinfo (which I implemented in the last patch
of this series to report the firmware version).
Do you have any reference of how to dump the other registers?

> Since there is a bootloader, i
> assume the firmware is upgradeable? devlink supports that.

True, it is upgradeable, however, I do not have an environment to test
for upgrades so there are no plans right now to develop an upgrade
feature.


Yours sincerely,
Vincent Mailhol
