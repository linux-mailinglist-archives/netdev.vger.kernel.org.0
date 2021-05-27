Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6939346A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhE0Q6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:58:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhE0Q6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 12:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=N3TYPpCOOX03ucB7DxVD89066n/4xIN2SwjxTuNf8YM=; b=aG
        QNVrHlherCBtEM7KcOdGLuLlcwxrLlicY9zcsbp4nJzZ+itLWS5qk4RT3Q09LPPDBkwD87EqbayuN
        ifu4VzDxT+DhLTeOsVhOcS/UstiIOc6V2Yu0NZQ6BvfeB7Agtkbj9fAHK9PKrZZOtHvHmsyvzuavA
        IW3lxVzIrXPg/no=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmJJt-006Zzb-9g; Thu, 27 May 2021 18:57:17 +0200
Date:   Thu, 27 May 2021 18:57:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 4/5] leds: trigger: netdev: support HW offloading
Message-ID: <YK/PbY/a0plxvzh+@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
 <20210526180020.13557-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210526180020.13557-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 08:00:19PM +0200, Marek Behún wrote:
> Add support for HW offloading of the netdev trigger.
> 
> We need to export the netdev_led_trigger variable so that drivers may
> check whether the LED is set to this trigger.

Without seeing the driver side, it is not obvious to me why this is
needed. Please add the driver changes to this patchset, so we can
fully see how the API works.

> -static struct led_trigger netdev_led_trigger = {
> +struct led_trigger netdev_led_trigger = {
>  	.name = "netdev",
>  	.activate = netdev_trig_activate,
>  	.deactivate = netdev_trig_deactivate,
>  	.groups = netdev_trig_groups,
>  };
> +EXPORT_SYMBOL_GPL(netdev_led_trigger);

If these are going to be exported, maybe they should be made const to
protect them a bit?

	Andrew
