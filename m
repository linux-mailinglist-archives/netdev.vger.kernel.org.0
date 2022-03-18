Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B114DDF8E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbiCRRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiCRRD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A822F24F6;
        Fri, 18 Mar 2022 10:02:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95816194E;
        Fri, 18 Mar 2022 17:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6483C340E8;
        Fri, 18 Mar 2022 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647622928;
        bh=LREVx0CEjDiwXN+7s+FZ6wJlHOR7TqwE6glrPEjuHhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ibqLpzsHwIGlTYR+0lxhFY7XWSSOIodRRBxwfM/J2+f6k8DaImqWwXbZ+g/Xwo5/z
         YWlo0GRzs0raZ3fwSipVomtGCEuMS+QvFBMvbVEwJr0Tsc5jfEzrgMlQOUeiKXupJ5
         rEmFbF2dUEXahrRp0FLd+XTuOCoi6OxSXBo6JlACeJjsjOQ85Bubs9ERYuGjxqC5XB
         WbrfuFx1eYm5fpYWl7ALCMOC+mMjK54A9Wg4KidZvkGkz5vuyhdLgGeg4BARkXDWJl
         80F+cS5XDJS5cy41p0/cl5a8PNkpbvLYXDgDkA5oJxDQ2WLLZoxVME3nbQPjuPQkPN
         UvWVOBBmOUTtg==
Date:   Fri, 18 Mar 2022 10:02:01 -0700
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
Message-ID: <20220318100201.630c70bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 17:00:46 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> In order to allow the I2C subsystem to be usable with fwnode, add
> some functions to retrieve an i2c_adapter from a fwnode and use
> these functions in both i2c mux and sfp. ACPI and device-tree are
> handled to allow these modifications to work with both descriptions.
>=20
> This series is a subset of the one that was first submitted as a larger
> series to add swnode support [1]. In this one, it will be focused on
> fwnode support only since it seems to have reach a consensus that
> adding fwnode to subsystems makes sense.
>=20
> [1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.com/T/

Sorry to jump ahead but would be great to split it up so that every
subsystem could apply its patches without risking conflicts, once
consensus has been reached.
