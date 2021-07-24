Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698543D48E9
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGXQxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:53:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGXQxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 12:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/jZ6Wby+hW1/SgAu/1GtyWyRk62rtJMaPwSQ9wbcqtk=; b=zL
        89XaiDtAfz79K5D5QGnpUZAy5Da3N3Xw3LZNSzbaJFvEiyUSOGOJ9NjIj3jv6Tphn28TIQ3lfWGlx
        +8mPK9Z1IAP2FKLI0fQ6sfyOJMIJG1jrUkuRn/uCQxOdftuZAoKdz6BsQvBZ/xOBeUn3q4hVz3ywD
        /75t+CiJqUgOOHM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m7LXT-00EeGr-Lo; Sat, 24 Jul 2021 19:34:15 +0200
Date:   Sat, 24 Jul 2021 19:34:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YPxPF2TFSDX8QNEv@lunn.ch>
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch>
 <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> root@dali:~# ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
> DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group
> default qlen 10
>     link/can
> 3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode
> DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group
> default qlen 1000
>     link/sit 0.0.0.0 brd 0.0.0.0
> 5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue
> state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> 6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> 7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> 8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> 9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff

I would suggest you configure all the interfaces up. I've made the
stupid mistake of thinking the right most RJ-45 socket is lan1 when it
is in fact dmz, etc. If you configure them all up, you should see
kernel messages if any go up, and you can see LOWER_UP, etc.

What does the link peer think? Does it think there is link? I think
for this generation of switch, the PHYs by default are enabled and
will perform autoneg, even if the interface is down. But if the
interface is down, phylib will not be monitoring it, and so you don't
see any kernel messages.

You might want to enable dbg prints in driver/nets/phy/phy.c, so you
can see the state machine changes.

    Andrew
