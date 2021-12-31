Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8999948248E
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhLaPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:31:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhLaPbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 10:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U9a1w8qQol8LUEcy9upSTRK+gPb4JQKArJVCCPnWXF4=; b=ffDpJxDklWi+1z/NVi3q1kGxbk
        IMoFAAf/eDhGsamw5K/pKD2egVHbAHZqPRNtxsPbfhUzguaup9YqWXZKBoxBsANnlLrc4Wum7jWRY
        lPpSoutkXdE3Dygyb1OBCn1GhzAxsp1nouTqdYNOiZ5SuDuHNe2eRoWDUuctvEayHiuU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n3JsX-000ETa-8v; Fri, 31 Dec 2021 16:31:37 +0100
Date:   Fri, 31 Dec 2021 16:31:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <Yc8iWYHLS5XQ9TLd@lunn.ch>
References: <20211230230740.GA1510894@euler>
 <Yc7bBLupVUQC9b3X@piout.net>
 <20211231150651.GA1657469@euler>
 <Yc8fGODCp2BmvszE@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc8fGODCp2BmvszE@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > sysctl -w net.ipv6.conf.swp3.autoconf=0
> > 
> > That sounds very promising! Sorry you had to fix my system config, but
> > glad that this all makes perfect sense. 
> > 

Hi Alexandre

> 
> Let me know if this works ;) The bottom line being that you should
> probably disable ipv6 autoconf on individual interfaces and then enable
> it on the bridge.

Does this also stop the interface getting a link local IPv6 address
based on its MAC address?

e.g. my wifi interface has MAC address b8:ae:ed:78:ef:9d and gets an
IPv6 address

inet6 fe80::baae:edff:fe78:ef9d/64 scope link 

It will also perform duplicate address detection, DAD, when the
interface is brought up. That is probably hard to see with tcpdump on
the host, since it happens very quickly, but a link peer should see
the packets.

    Andrew
