Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3C6AA5DB
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCCXwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCCXwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:52:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0821865479;
        Fri,  3 Mar 2023 15:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA8D618CB;
        Fri,  3 Mar 2023 23:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3CEC433EF;
        Fri,  3 Mar 2023 23:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677887539;
        bh=Jmrj/iKDWzzgD7xtWeQj8EIfUptfnvPqo2teGdKzKow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UAdmfVRSyMphUcN/oGDQZpdzQoo49H1qhPSvZXnpGTepleb0CK1Szk218GYcac3AV
         fwScos3/CK/ZwY353yRQaLzybIkaa+vIUQaR0GSyR9BSxKvooFw8RVsve4sKzdvUmn
         +i86fL+8DND7SOvOmm1BUKp0nx92TwOOG7JCE6GpAoMcZ8N3d5p+sQUaOo7DcDy/cZ
         WIaikb0gQ/YSqs/7xsv3fVU0HcQEwZcrQRAhmMtz4rH07oHByLt6G9FoYa7GjsrNWR
         veD1aErQxmmhI37+Q+yaHRQcsdQtdhFGAU0FIG7QOiWIuHiQ3NQvfvq9KvKNZz9Z4h
         W/t+Bn26hexSA==
Date:   Fri, 3 Mar 2023 15:52:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: Re: [PATCH v2 2/4] net: Expose available time stamping layers to
 user space.
Message-ID: <20230303155217.012337b8@kernel.org>
In-Reply-To: <20230303164248.499286-3-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
        <20230303164248.499286-3-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Mar 2023 17:42:39 +0100 K=C3=B6ry Maincent wrote:
> Time stamping on network packets may happen either in the MAC or in
> the PHY, but not both.  In preparation for making the choice
> selectable, expose both the current and available layers via sysfs.

Ethtool, please, no sysfs.
