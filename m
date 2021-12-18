Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85028479BC5
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 17:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhLRQpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 11:45:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhLRQpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 11:45:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PR4ph8S8njbd3DQIRCqFxzRBA3eckMdxE8wDGpAEIFQ=; b=Scz6yxZBMYddPUUmsAaDxnuhy3
        3+RBlJPLbZ06E6ARDEMvGGTa+NUTWxXsHukZEKFXgwjDTO4YoJZSzPrnLzQty08gP/u7czDfGAq6H
        rg7j4hjbet6xMqUMbqA2urB75cqatqCFk1YUOfqrPFb8Uf634jOPtVKylV9ZsZaM7ff0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mycpZ-00Guk2-0Q; Sat, 18 Dec 2021 17:45:09 +0100
Date:   Sat, 18 Dec 2021 17:45:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     netdev@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
Message-ID: <Yb4QFDQ0rFfFsT+Y@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 03:45:08PM +0000, Martyn Welch wrote:
> I've had some reports of the smsc95xx driver failing to work for the
> ODROID-X2 and ODROID-U3 since a049a30fc27c was merged (also backported
> to 5.15.y stable branch, which I believe is what those affected by this
> are using).
> 
> Since then we have performed a number of tests, here's what we've found
> so far:
> 
> ODROID-U3 (built-in LAN9730):
> 
>  - No errors reported from smsc95xx driver, however networking broken
>    (can not perform DHCP via NetworkManager, Fedora user space).
> 
>  - Networking starts working if device forced into promiscuous mode
>    (Gabriel noticed this whilst running tcpdump)
> 
> 
> ODROID-X2 (built in LAN9514):
> 
>  - Networking not brought up (Using Debian Buster and Bullseye with
> traditional `/etc/network/interfaces` approach).
> 
>  - As with Odroid-u3, works when running in promiscuous mode.

Hi Martyn

Promisc mode is really odd, given what

commit a049a30fc27c1cb2e12889bbdbd463dbf750103a
Author: Martyn Welch <martyn.welch@collabora.com>
Date:   Mon Nov 22 18:44:45 2021 +0000

    net: usb: Correct PHY handling of smsc95xx

does. Has it been confirmed this is really the patch which causes
the problem?

Does mii-tool -vvv how any difference between the working and broken
case?

Can you also confirm the same PHY driver is used before/after this
patch. There is a chance one is using a specific PHY driver and the
other genphy.

    Andrew
