Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CF14DDF6D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiCRQ5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiCRQ5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:57:15 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57362B963F;
        Fri, 18 Mar 2022 09:55:55 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 70F3D1C0008;
        Fri, 18 Mar 2022 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647622554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VTm3WCGd+Gc+MnbF+RGD9FPstNQafRl1ZXxnP/UfLeA=;
        b=H+LZHHVcv37ltIFe0vaPUCcnLIH+W2pJCsEpVmfs6KlTVbfIz3LRb4dWlfcqGDEj0mPHYT
        2eiYJ+wPS0aytxDkN3ocUrgRDCv4pmDQlaWMO0qlwF0p/S8M+qNCSseX5Xqc78j/HGekVc
        KkHKQVeLcRkVMaD/5usyLbTGPYeFRQBWoJsESUlf5pToSTMQNzMxsZ8y5o2gnibzHWfrj8
        ymaXPGKPB+IDdcrm/GAdP2mM95Nnqw6rInIImkq5CDTvmxGLtOUdGnWHp3eRR7oTefe6KL
        w6SM9BcBYSHoF5JfQLBgRpJoiiGjDfW+C9uHBpzCUF0tphPST41yqW3pFWeGbQ==
Date:   Fri, 18 Mar 2022 17:54:29 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/6] i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
Message-ID: <20220318175402.1e62503d@fixe.home>
In-Reply-To: <YjSzc/Eek8NvqEN6@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318160059.328208-3-clement.leger@bootlin.com>
        <YjSzc/Eek8NvqEN6@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 18 Mar 2022 18:29:39 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Fri, Mar 18, 2022 at 05:00:48PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add fwnode_find_i2c_adapter_by_node() which allows to retrieve a i2c
> > adapter using a fwnode. Since dev_fwnode() uses the fwnode provided by
> > the of_node member of the device, this will also work for devices were
> > the of_node has been set and not the fwnode field.
>=20
> > +	/* For ACPI device node, we do not want to match the parent */ =20
>=20
> Why?
> Neither commit message nor this comment does not answer to this question.
>=20

Yes you are right. This is done to keep the existing behavior that is
applied by i2c_acpi_find_adapter_by_handle() which only checks the
device node and not the parent one. Using the same behavior than for DT
would add some unwanted behavior in I2C device lookup for ACPI.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
