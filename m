Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF2F4E3016
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352231AbiCUSiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352240AbiCUSiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:38:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E181661;
        Mon, 21 Mar 2022 11:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E21F8CE1AEB;
        Mon, 21 Mar 2022 18:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F935C340F2;
        Mon, 21 Mar 2022 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647887799;
        bh=L4/pb0C+x3zLGknw3l+VTjgkqap8FhmEleEySHiDF8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cdwwN42An54vRnJV3Zt6TSOetV1Xc7QPyxuYnzVQRstdts/+9tBw/vN/5o6vxRPvP
         ijbMZhW+aAGq1xldOFxPyodaYfplB1eSxJ0CS2Mo7dz61U7nYflvTyt+G1aAqAZvEM
         HRLwECd5PLAm43kKYR+/qnK3rdcNX5vEWy0iSaIRID8XnsVwtzM8oYo68gghHVyhzO
         nlgYOJIChXUDInILMsW/DDnGxQLziSw91MgLfsBNiIPtE/GvOF/tMJE28f1YZpliUF
         M06GU7erfFw8jNJaM8Yg6uOv+nYgQQ092LPWDaz6lqrXOl/EW6eGQ9ulqv6DyvBDw3
         eEsqSN4fURNnQ==
Date:   Mon, 21 Mar 2022 11:36:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] introduce fwnode in the I2C subsystem
Message-ID: <20220321113634.56d6fe2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321115634.5f4b8bd4@fixe.home>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318100201.630c70bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220321115634.5f4b8bd4@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 11:56:34 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> Le Fri, 18 Mar 2022 10:02:01 -0700,
> Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :
>=20
> > On Fri, 18 Mar 2022 17:00:46 +0100 Cl=C3=A9ment L=C3=A9ger wrote: =20
> > > In order to allow the I2C subsystem to be usable with fwnode, add
> > > some functions to retrieve an i2c_adapter from a fwnode and use
> > > these functions in both i2c mux and sfp. ACPI and device-tree are
> > > handled to allow these modifications to work with both descriptions.
> > >=20
> > > This series is a subset of the one that was first submitted as a larg=
er
> > > series to add swnode support [1]. In this one, it will be focused on
> > > fwnode support only since it seems to have reach a consensus that
> > > adding fwnode to subsystems makes sense.
> > >=20
> > > [1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.co=
m/T/   =20
> >=20
> > Sorry to jump ahead but would be great to split it up so that every
> > subsystem could apply its patches without risking conflicts, once
> > consensus has been reached. =20
>=20
> Hi Jakub,
>=20
> Ok, to be clear, you would like a series which contains all the
> "base" fwnode functions that I'm going to add to be sent separately
> right ? And then also split i2c/net stuff that was sent in this series ?

I'm mostly concerned about conflicts, so if you can get the entire
series into 5.18 before the merge window is over then consider it=20
acked. If it doesn't make 5.18 looks like you'd need to send patches=20
1 and 2 as a PR so that both the i2c and net trees can pull it.=20
Once pulled send patch 6 out to net-next. Does that make sense?
