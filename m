Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA263CD65
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiK3CbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiK3CbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:31:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D366B386;
        Tue, 29 Nov 2022 18:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29AA7619B3;
        Wed, 30 Nov 2022 02:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AE5C433D6;
        Wed, 30 Nov 2022 02:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669775463;
        bh=b+3JXoB1sxTN6Zr6Yv7abFfG2xs7x/MsL6RvCM34yZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iOgQ5dplzUw0VChcokj9bxcv5DA1H603KU7c2CSIw/pg+C2WOBI11b6Grimhwickf
         a2X4+fTq0qYV2DTJPD+ByQzpfVLgOJ+tIZa9o6DDEkOHPvZCwgTtZVnGu/ijIX2rSN
         Q4Z9vePuAcv7ek5UrIzLD1n/xrOlfb7tagNhK1ZY/LaBwXTXpUKu6ydNZTA0JUGxpE
         bM42EpzsvEmBCwAc5UnwYUIA6PhA3EfjlwlGEzZcklEcbOJtmCkI5uDw5jR/V/Bv5b
         ONBts1oXFO2LT+TiTm8/yXIRCWjo5EM+zlwAguRLQrWpk1Te622NzHRDB3DvLCxucn
         dK8SuSogszNow==
Date:   Tue, 29 Nov 2022 18:31:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 5/6] can: etas_es58x: report the firmware version
 through ethtool
Message-ID: <20221129183102.1983375c@kernel.org>
In-Reply-To: <CAMZ6RqJU5hm=HniJ59aGvHyaWboa7ZHv+9nSbzGxoY-cCfxMag@mail.gmail.com>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
        <20221128142857.07cb5d88@kicinski-fedora-PC1C0HJN>
        <CAMZ6RqJU5hm=HniJ59aGvHyaWboa7ZHv+9nSbzGxoY-cCfxMag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 02:12:27 +0900 Vincent MAILHOL wrote:
> I was not aware of this one. Thank you for pointing this out.
> If I correctly understand, devlink_compat_running_version() is
> supposed to allow ethtool to retrieve the firmware version from
> devlink, right?

Yes.

> Currently it does not work. I guess it is because I am not using
> SET_NETDEV_DEVLINK_PORT()? I initially thought that this was optional.

It's optional but breaks the linking hence the fallback can't kick in.
I guess "optional-ity" is a spectrum :)

> I will continue to investigate and see if it is possible to completely
> remove the .get_drvinfo() callback.
