Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCA3393D1C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 08:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhE1Gbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 02:31:36 -0400
Received: from mail.nic.cz ([217.31.204.67]:53928 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhE1Gbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 02:31:34 -0400
Received: from dellmb (unknown [IPv6:2001:1488:fffe:6:be02:5020:4be2:aff5])
        by mail.nic.cz (Postfix) with ESMTPSA id E270613FEA3;
        Fri, 28 May 2021 08:29:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1622183399; bh=S/850/d0O/WBVm/qTe5VEQcTqYoossm4geqAKZMVHXQ=;
        h=Date:From:To;
        b=wAdycggjicIgHSAPf0kRlAtXczSf7PiX3OGmbMeiHN1BxXpyUtscoAsu7rk0nPSPU
         B6gyUV2U6cn6aMSloPjEkcjhqmJvgazuUJkjyRAOsVttJwSmuRBT2VW0YYxrpIkJ/l
         cKhnXf+bSFYGVBdLEDb1pJf5UZciJvsa31lzVITw=
Date:   Fri, 28 May 2021 08:28:52 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 3/5] leds: trigger: netdev: move trigger data
 structure to global include dir
Message-ID: <20210528082852.62070024@dellmb>
In-Reply-To: <YK/NValApLWUEHYG@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
        <20210526180020.13557-4-kabel@kernel.org>
        <YK/NValApLWUEHYG@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 18:48:21 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, May 26, 2021 at 08:00:18PM +0200, Marek Beh=C3=BAn wrote:
> > In preparation for HW offloading of netdev trigger, move struct
> > led_trigger_data into global include directory, into file
> > linux/ledtrig.h, so that drivers wanting to offload the trigger can
> > see the requested settings.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > ---
> >  drivers/leds/trigger/ledtrig-netdev.c | 23 +---------------
> >  include/linux/ledtrig.h               | 38
> > +++++++++++++++++++++++++++ =20
>=20
> I'm wondering how this is going to scale, if we have a lot of triggers
> which can be offloaded. Rather than try to pack them all into
> one header, would it make more sense to add
>=20
> include/linux/led/ledtrig-netdev.h
>=20
> 	Andrew

Hmm, I guess you are right. Also when looking at a LED controller
driver we could immediately see which triggers this driver can offload,
when looking at headers included.
