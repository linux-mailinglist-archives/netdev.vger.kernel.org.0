Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A2D3ACC77
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhFRNnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:43:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233904AbhFRNnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 09:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=78qpKeNOzP/NAiEhB003K9aO28jOhCI8hGIf6ql5ius=; b=NzC8w6hiC2xjfYYW9YbyuUHhXq
        zVLU0VY8iMe3blpC9TTcef5XD5TdYf/gBOYyVgS/hRWlKlud97SvoZnR4uePoO6t67cO1NhbjVk6g
        JuuBeRME8DpU/cD0Z8eDTbdmoWxOLUov6rwmvU9uP2o9cgvTGaOjd8t3t1F8mpaWkgKA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1luEkd-00A4hL-T6; Fri, 18 Jun 2021 15:41:39 +0200
Date:   Fri, 18 Jun 2021 15:41:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <YMyikxsdqNi8V5zG@lunn.ch>
References: <20210617154206.GA17555@plvision.eu>
 <YMt8GvxSen6gB7y+@lunn.ch>
 <20210617165824.GA5220@plvision.eu>
 <YMv0WEchRT25GC0Q@lunn.ch>
 <20210618095824.GA21805@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618095824.GA21805@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I just picked some from the git log:
> 
>     48237834129d ("QCA: Update Bluetooth firmware for QCA6174")
> 
> this just updates the binary and description says that it updates
> to v26.
> 
> Not sure if it is good example.

The filename is qca/rampatch_usb_00000302.bin. If you look at
drivers/bluetooth/btusb.c you can see that 00000302 is the version of
the ROM in the device which is being patched. So there is no
expectation of knowing the firmware version from the firmware
filename.

> But anyway, I agree with you that better if new changes also reflects
> the FW binary name (version) so it will be easy to find out which FW binary
> have or not particular features.
> 
> So I think better to add new FW 3.1 binary ?

Probably. But please consider your whole upgrade story. You are
changing the firmware version quite frequently. How do end users cope
with this? Is the driver going to support 3.1, 3.0 and 2.0? Or just
3.1 and 2.0?

Do you have more features in firmware 3.1 you need to add driver
support for? Or can we expect a 3.2 in a few weeks time? What are your
users expectations at the moment? It could be, you don't consider the
driver has enough features at the moment that anybody other than early
adopters playing with it would consider using it. That you don't
expect real use of it for another six months, or a year. If that is
true, you probably can be a bit more disruptive at the moment. But
when you have a production ready driver, you really do need to
consider how your users deal with upgrades, keeping the firmware
version stable for a longer period of time.

	Andrew
