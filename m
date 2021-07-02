Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092703BA41A
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhGBSz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:55:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhGBSz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QnxHrZH5TWL1N06AJbrxLJ9YI1K5/doFSo4SvZ/a5v8=; b=oZfr/Y05JNnbwsqEHoTG0CNjXN
        6NSOX3Z/ovRFT/4f6pTD8jAKA55rQtPqe0fKozZFWUgD8pVy9yksiwLY5h2jnwFF52FQKBa/koJ+P
        CLzmAAg//Ffe5hoz+TeVRTmucg4A5WoM3T490kHGlIhZdr0L4kZ3TWYnVyD7U1cMX/2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lzOHL-00Bx8K-4c; Fri, 02 Jul 2021 20:52:43 +0200
Date:   Fri, 2 Jul 2021 20:52:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [RFC net-next 0/4] Marvell Prestera add policer support
Message-ID: <YN9ge12XzhZCdBNj@lunn.ch>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702182915.1035-1-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 09:29:11PM +0300, Vadym Kochan wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Offload action police when keyed to a flower classifier.
> Only rate and burst is supported for now. The conform-exceed
> drop is assumed as a default value.
> 
> Policer support requires FW 3.1 version. Because there are some FW ABI
> differences in ACL rule messages between 3.0 and 3.1 so added separate
> "_ext" struct version with separate HW helper.

This driver is less than a year old, and it is on its third ABI break?
It is accumulating more and more cruft as you need to handle old and
new messages. Maybe you should take a harder look into your crystal
ball and try to figure out an ABI which you can use for 12 months or
more? Or just directly address the hardware, and skip the firmware?

      Andrew
