Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB6C500044
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiDMUwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiDMUwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:52:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9501C186CA;
        Wed, 13 Apr 2022 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V4A9Rs7bB/h1uq+i/sHrpZ6VvmBcDLShFIi74ImLuhI=; b=GuWpCKCbl2fyx5u3DPBuIgUWDK
        kHuYn9AqqDOKljYsW7Fi3X79JqxdpxRfFzu0flVFb0lbLz0nBUhmVz06t6ldvla2ogkE2rY6ZSrI1
        5KxcyvMtcmrPAI0rzF4QFrHzErMXeiMcJQ0uA/ylRySGb08m8D6/dguDuce5sC61BdOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nejw1-00FjNW-4v; Wed, 13 Apr 2022 22:49:53 +0200
Date:   Wed, 13 Apr 2022 22:49:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Message-ID: <Ylc3ca1k1IZUhFxZ@lunn.ch>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413200841.4nmnv2qgapqhfnx3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 08:08:41PM +0000, Vladimir Oltean wrote:
> I've copied a bunch of new people to this email.
> 
> TL;DR: Kurt/George/Andrew, on your systems with hellcreek/xrs700x/mv88e6060,
> does the DSA master declare any of the following features as "on"?
> 
> ethtool -k eth0 | grep tx-checksum-ip

Zii-devel-c, which uses a FEC as master:

root@zii-devel-c:~# ethtool -k eth1 | grep tx-checksum-ip
	tx-checksum-ipv4: off [fixed]
	tx-checksum-ip-generic: off [fixed]
	tx-checksum-ipv6: off [fixed]

370RD is a Marvell reference design, using mvneta as the master

andrew@370rd:~$ /usr/sbin/ethtool -k eth1 | grep tx-checksum-ip
	tx-checksum-ipv4: on
	tx-checksum-ip-generic: off [fixed]
	tx-checksum-ipv6: on

WRT1900AC is a WiFi access point, also mvneta

root@wrt1900ac:~# ethtool -k eth0 | grep tx-checksum-ip
        tx-checksum-ipv4: on
        tx-checksum-ip-generic: off [fixed]
        tx-checksum-ipv6: on

I have one more system i can check, using a Marvell Kirkwood SoC using
the mv643xx as master. I need to blow the dust off it first, i've not
booted it in years.

    Andrew
