Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8793449E82C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244211AbiA0Q4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:56:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiA0Q4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:56:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0590AB800E2;
        Thu, 27 Jan 2022 16:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8B8C340E4;
        Thu, 27 Jan 2022 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643302588;
        bh=Jbbt90GOScnUkca96ukAtB0TEYFj51dYwo1DO4Rum0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oOnw0x/alJ+ho6f0ec8wuvxvo+ON2SwStZQNk4Z/kIs99P7+vMIBiC5LpUsHsY+0K
         p4PyoVSDtL3sRD+obH6dyEo5QEamQznXpOA0hwaQ/Dd53MX6nL7euiOkwQko+JZtNE
         AMXfKPbIC9WPgz0cMGYm0iFCkHOjMYOAFk+mLyxILf6zyOtlIC3mNgfdgskIr7kLjj
         J/FkEam5mfZFJoUd9hfArJyBZAosejauzDBHaAQWo1/OwA1IHzHuKT5XxuNhFtoDd7
         j4Hw2/RCLTJ8gpHGXKc2zOBWuU84LeOCIsiSFiKuWXIQCq/6rY0ZcnruwzOVPM/rke
         mbbxhf7UEKehg==
Date:   Thu, 27 Jan 2022 08:56:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <20220127085627.70b31e30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YfK9uV0BviEiemDi@lunn.ch>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
        <YfK9uV0BviEiemDi@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 16:43:53 +0100 Andrew Lunn wrote:
> On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > The weakest link of usbnet devices is the USB cable. Currently there is
> > no way to automatically detect cable related issues except of analyzing
> > kernel log, which would differ depending on the USB host controller.
> > 
> > The Ethernet packet counter could potentially show evidence of some USB
> > related issues, but can be Ethernet related problem as well.  
> 
> I don't know the usbnet drivers very well. A quick look suggests they
> don't support statistics via ethtool -S. So you could make use of that
> to return statistics about USB error events.

On using devlink health - it is great when you want to attach some extra
info to the error report. If you're just counting different types of
errors seems like an overkill.

> However, GregKH point still stands, maybe such statistics should be
> made for all USB devices, and be available in /sys/bus/usb/devices/*
