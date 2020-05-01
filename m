Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290D91C129C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgEANKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:10:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36104 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgEANKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 09:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=epYZ8625OdaPkYhAPH2Lj1e6GWDE1IHj6c5aXkWtv5Y=; b=1ua4vY3vijIeSqFImxxAXFdTSN
        def6W0YovmMNsz81ZJHqL+YR7vJg5ZzRnkpG6osiNYPDJe/IhvTgwCLUrQxQ6iVeaV1PyyCHee8iF
        eaE07RKDsrtNOqQsxoSvwRk1GD9g8V7TWWV57ErTiuIuEwBFfomXROW1EM4x/p7LL9vY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUVR5-000XPB-6V; Fri, 01 May 2020 15:10:35 +0200
Date:   Fri, 1 May 2020 15:10:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Allen <allen.pais@oracle.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Net: [DSA]: dsa-loop kernel panic
Message-ID: <20200501131035.GA128166@lunn.ch>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:54:15AM +0530, Allen wrote:
> Hi,
> 
> $ rmmod dsa-loop
> [   50.688935] Unable to handle kernel read from unreadable memory at
> virtual address 0000000000000040

> [   50.718185] pstate: 60400005 (nZCv daif +PAN -UAO)
> [   50.719274] pc : __dev_set_rx_mode+0x48/0xa0

ffff8000113adb60 <__dev_set_rx_mode>:

Function starts at ffff8000113adb60, the instruction with problems is
ffff8000113adb60+48.

{
ffff8000113adb60:       a9bd7bfd        stp     x29, x30, [sp,#-48]!
ffff8000113adb64:       910003fd        mov     x29, sp
ffff8000113adb68:       a90153f3        stp     x19, x20, [sp,#16]
ffff8000113adb6c:       f90013f5        str     x21, [sp,#32]
ffff8000113adb70:       aa0003f3        mov     x19, x0
ffff8000113adb74:       aa1e03e0        mov     x0, x30
ffff8000113adb78:       94000000        bl      0 <_mcount>
                        ffff8000113adb78: R_AARCH64_CALL26      _mcount
        if (!(dev->flags&IFF_UP))
ffff8000113adb7c:       b9422a60        ldr     w0, [x19,#552]
        const struct net_device_ops *ops = dev->netdev_ops;
ffff8000113adb80:       f940fa74        ldr     x20, [x19,#496]
        if (!(dev->flags&IFF_UP))
ffff8000113adb84:       360001a0        tbz     w0, #0, ffff8000113adbb8
<__dev_set_rx_mode+0x58>
ffff8000113adb88:       f9402260        ldr     x0, [x19,#64]
        if (!netif_device_present(dev))
ffff8000113adb8c:       36080160        tbz     w0, #1, ffff8000113adbb8
<__dev_set_rx_mode+0x58>
        if (!(dev->priv_flags & IFF_UNICAST_FLT)) {
ffff8000113adb90:       b9422e60        ldr     w0, [x19,#556]
ffff8000113adb94:       376000a0        tbnz    w0, #12, ffff8000113adba8
<__dev_set_rx_mode+0x48>
                if (!netdev_uc_empty(dev) && !dev->uc_promisc) {
ffff8000113adb98:       b9429275        ldr     w21, [x19,#656]
ffff8000113adb9c:       35000175        cbnz    w21, ffff8000113adbc8
<__dev_set_rx_mode+0x68>
                } else if (netdev_uc_empty(dev) && dev->uc_promisc) {
ffff8000113adba0:       3949f660        ldrb    w0, [x19,#637]
ffff8000113adba4:       35000220        cbnz    w0, ffff8000113adbe8 <__dev_set_rx_mode+0x88>
        if (ops->ndo_set_rx_mode)
ffff8000113adba8:       f9402281        ldr     x1, [x20,#64]

Which suggests ops is NULL. The #64 also matches with

> [   50.688935] Unable to handle kernel read from unreadable memory at
> virtual address 0000000000000040

How did dev->netdev_ops become NULL?

Odd

	Andrew
