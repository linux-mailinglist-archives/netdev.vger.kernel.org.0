Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438723D7925
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhG0O4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhG0O4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 10:56:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE1361AA4;
        Tue, 27 Jul 2021 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627397771;
        bh=JohFgpvZpYgI1oDPw3fS6pED2AHqX7hLN34A0K0VzMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ufK7WvIIaCyiudliHbJs6cFQ0vodpH9y0dunj7p6b1x45die/DCKxASC8AqZw0U9N
         dTutJPvc//eThb7Z7hbQyFCX61KJ7D0IM7QtguK+czcluqy/vrBJB/O0zhLf56RIJl
         b2PSQj/vDNal0+fOcad+kby3W+DuzjXJm1eJZK1607KXK4gTVhLoIkSET2XGj05xIL
         vLbN7v1GD6Bt44HgdyrgO/R4V8cj1PcOVue9g/IxMWfPXTKgWygY8PAM5KiahV4TO1
         qzzF4Wfj5UljDHKptWJDDCgDQ7IYTt4qxcOYxhyjbxjdIqsMtjuyk6FIXFf71fk0FE
         tEJJ4IPbczN6g==
Date:   Tue, 27 Jul 2021 16:56:05 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210727165605.5c8ddb68@thinkpad>
In-Reply-To: <20210727081528.9816-1-michael@walle.cc>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, 27 Jul 2021 10:15:28 +0200
Michael Walle <michael@walle.cc> wrote:

> Why do we have to distiguish between LEDs connected to the PHY and LEDs
> connected to the MAC at all? Why not just name it ethN either if its behind
> the PHY or the MAC? Does it really matter from the users POV?

Because
1. network interfaces can be renamed
2. network interfaces can be moved between network namespaces. The LED
   subsystem is agnostic to network namespaces
So it can for example happen that within a network namespace you
have only one interface, eth0, but in /sys/class/leds you would see
  eth0:green:activity
  eth1:green:activity
So you would know that there are at least 2 network interfaces on the
system, and also with renaming it can happen that the first LED is not
in fact connected to the eth0 interface in your network namespace.

Marek
