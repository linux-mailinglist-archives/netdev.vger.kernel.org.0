Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395EF2A8F86
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgKFGkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgKFGkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 01:40:03 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B90208C3;
        Fri,  6 Nov 2020 06:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604644802;
        bh=GiGPlmQaMcWU78QAEwNQ8arJ3uGNdhsDjCSsXzQo0EU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xAaknuNp+Jc/V7QEqbPG2MzFpa+LF3GMXI3qklPch4NU5atemKMikTkSJfXMItf5I
         Bh2qP1Q9W7rgZi6TyNlzopO3Tx6aA/59trfC3l0lQeLH92M4bQu/C1oqepRX3QamNr
         ep0pjhCvc8G2GNYjjjTAMyfmkDw5mBpoV3ERTrGY=
Date:   Fri, 6 Nov 2020 07:39:47 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201106073947.6328280d@kernel.org>
In-Reply-To: <21f6ca0a96d640558633d6296b81271a@realtek.com>
References: <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
        <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf>
        <20201104112511.78643f6e@kernel.org>
        <20201104113545.0428f3fe@kernel.org>
        <20201104110059.whkku3zlck6spnzj@skbuf>
        <20201104121053.44fae8c7@kernel.org>
        <20201104121424.th4v6b3ucjhro5d3@skbuf>
        <20201105105418.555d6e54@kernel.org>
        <20201105105642.pgdxxlytpindj5fq@skbuf>
        <21f6ca0a96d640558633d6296b81271a@realtek.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 03:01:22 +0000
Hayes Wang <hayeswang@realtek.com> wrote:

> Vladimir Oltean <olteanv@gmail.com>
> > Sent: Thursday, November 5, 2020 6:57 PM
> > On Thu, Nov 05, 2020 at 10:54:18AM +0100, Marek Beh=C3=BAn wrote: =20
> > > I thought that static inline functions are preferred to macros, since
> > > compiler warns better if they are used incorrectly... =20
> >=20
> > Citation needed. Also, how do static inline functions wrapped in macros
> > (i.e. your patch) stack up against your claim about better warnings?
> > I guess ease of maintainership should prevail here, and Hayes should
> > have the final word. I don't really have any stake here. =20
>=20
> I agree with Vladimir Oltean.
>=20
> I prefer to the way of easy maintaining.
> I don't understand the advantage which you discuss.
> However, if I am not familiar with the code, this patch
> would let me take more time to find out the declarations
> of these functions. This make it harder to trace the code.

Hi Hayes,

just to be clear:
Are you against defining these functions via macros?
If so, I can simply rewrite this so that it does not use macros...

Or are you against implementing these functions themselves? Should I
abandon this at all?

BTW, what about patch 5/5 which introduces *_modify helpers?
Patch 5/5 simplifies the driver a lot, IMO, changing this

  ocp_data =3D usb_ocp_read_word(tp, USB_PM_CTRL_STATUS);
  ocp_data &=3D ~RESUME_INDICATE;
  usb_ocp_write_word(tp, USB_PM_CTRL_STATUS, ocp_data);

into this

  usb_ocp_modify_word(tp, USB_PM_CTRL_STATUS, RESUME_INDICATE, 0);

Marek

