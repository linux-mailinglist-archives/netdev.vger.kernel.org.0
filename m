Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7973012E648
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 13:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgABMyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 07:54:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgABMyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 07:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O6e4CuOBxyrYTSDbzpg+4CY5EG8a5QAk50cY/URZTIo=; b=vSBfzZ3nkjaeybChC0/tEtSYD9
        dqBXCnBbxJ3bl0+uyZ6wrEi5p0BZA0EIpqYSbLnfXj4awaXBvWl51HXkoZGDaLIQ83UDFBB7uKX8r
        Ek2TYdMWXZB0CGdv/MS1KAsedUyFY6E6zDOI2h6JK/x3AEJEn+0YVEXkPkCqLXwdO/50=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1imzzV-000607-CH; Thu, 02 Jan 2020 13:54:17 +0100
Date:   Thu, 2 Jan 2020 13:54:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200102125417.GA22789@lunn.ch>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
 <20200101173014.GZ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101173014.GZ25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> # tcpdump -enXXi $host_dsa_interface
> 
> Here's an example ping packet received over the vlan with the above
> configuration, captured from the host DSA interface (ether mac
> addresses obfuscated):
> 
>         0x0000:  DDDD DDDD DDDD SSSS SSSS SSSS dada 0000  .PC.....[h:.....
>                                                ^^^^^^^^^
>         0x0010:  c020 0000 8100 0080 0800 4500 0054 ec40  ..........E..T.@
>                  ^^^^^^^^^ ^^^^^^^^^ ^^^^
>         0x0020:  4000 4001 c314 c0a8 0502 c0a8 0501 0800  @.@.............
>         0x0030:  8784 0c85 0001 32c8 0c5e 0000 0000 59fc  ......2..^....Y.
>         0x0040:  0c00 0000 0000 1011 1213 1415 1617 1819  ................
>         0x0050:  1a1b 1c1d 1e1f 2021 2223 2425 2627 2829  .......!"#$%&'()
>         0x0060:  2a2b 2c2d 2e2f 3031 3233 3435 3637       *+,-./01234567
> 
> dada 0000 c020 0000	- EDSA tag
> 8100 0080		- VLAN ethertype, vlan id
> 0800			- IPv4 ethertype, and what follows is the ipv4
> 			  packet.
> 
> That way it would be possible to know whether the DSA switch is
> forwarding the packets, and in what manner it's forwarding them.

Hi Russell

Try upgrading your tcpdump and pcap library. It now understands DSA
headers, will dump them in a semi human readable way, and also the
rest of the frame.

     Andrew
