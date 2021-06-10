Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612523A2BCA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFJMn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:43:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhFJMn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 08:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fYZOkkqyGXk8JYKQg4+wXZffVcyqp6AA7a9W28AH5c0=; b=cwod/ROhT7dqe5F485qk6xUjBX
        Ms5LwknrYrkc2TrbQmnpilaN9Jvg74rib3eyuOosO+zhkisVrd2a6hjlAExXekGdljQyE+YtUyRxd
        vKU7W/AunYaMSyRtOseVks8bZ++ZUOs/n0d6LmuNX0r7dGF3d4XV4xu6A+ckb84DP7M4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrJzu-008evV-Sv; Thu, 10 Jun 2021 14:41:22 +0200
Date:   Thu, 10 Jun 2021 14:41:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Message-ID: <YMIIcgKjIH5V+Exf@lunn.ch>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:
> Storm control (BUM) provides a mechanism to limit rate of ingress
> port traffic (matched by type). Devlink port parameter API is used:
> driver registers a set of per-port parameters that can be accessed to both
> get/set per-port per-type rate limit.
> Add new FW command - RATE_LIMIT_MODE_SET.

Hi Oleksandr

Just expanding on the two comments you already received about this.

We often see people miss that switchdev is about. It is not about
writing switch drivers. It is about writing network stack
accelerators. You take a feature of the Linux network stack and you
accelerate it by offloading it to the hardware. So look around the
network stack and see how you configure it to perform rate limiting of
broadcast traffic ingress. Once you have found a suitable mechanism,
accelerate it via offloading.

If you find Linux has no way to perform a feature the hardware could
accelerate, you first need to add a pure software version of that
feature to the network stack, and then add acceleration support for
it.


	   Andrew
