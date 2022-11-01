Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0366143A4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiKAD1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiKAD1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:27:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D3ADBC;
        Mon, 31 Oct 2022 20:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4610461492;
        Tue,  1 Nov 2022 03:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6460DC433C1;
        Tue,  1 Nov 2022 03:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667273235;
        bh=L1IBfjfOFq+K/Esb8RP5PXa3qyj94RhKpco9HpxQFME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=quk4O123zcz3700lWnblwDjK1+wgfK1BaKs8DKQ3jkhpFqIDRmaWNwvy4BO56YC4K
         dLrSowxkX+Q96zXZ0jjRUYw+a9XbcJJQth2AvcJlrXgR2PscHADPPtnO6F9pQenmej
         0AHIdPHyamPfmoiVTUr/az8EmWY83wsfg/MZv6uLRe/2mH5l/U5hyhyF1fea39D7wP
         NEBy2Dntzrd04orSA5sYNq7BqMGcB5COmRPMAdo2hzF7j50TOM6lKtJ97M4BbWHfC8
         u9SWOhKIX3JOPl49L0yNuNHi0qrAysxFBhFZ8AUkx+0a/YlfaaYisQpO8bYKqZznlk
         Rln8bEm40sfBg==
Date:   Mon, 31 Oct 2022 20:27:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Message-ID: <20221031202714.1eada551@kernel.org>
In-Reply-To: <20221031154406.259857-1-mkl@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 16:43:52 +0100 Marc Kleine-Budde wrote:
> The first 7 patches are by Stephane Grosjean and Lukas Magel and
> target the peak_usb driver. Support for flashing a user defined device
> ID via the ethtool flash interface is added. A read only sysfs

nit: ethtool eeprom set != ethtool flash

> attribute for that value is added to distinguish between devices via
> udev.

So the user can write an arbitrary u32 value into flash which then
persistently pops up in sysfs across reboots (as a custom attribute
called "user_devid")?

I don't know.. the whole thing strikes me as odd. Greg do you have any
feelings about such.. solutions?

patches 5 and 6 here:
https://lore.kernel.org/all/20221031154406.259857-1-mkl@pengutronix.de/
