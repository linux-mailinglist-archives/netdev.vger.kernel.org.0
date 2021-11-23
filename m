Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1E45A426
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhKWN5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:57:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhKWN5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 08:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ylnmSm77t+ov3pgDOwOBhL1yIxfl6alYfbSXEakC9lc=; b=AX
        GL/kI9xHo3D7y3w6QjLZ2pjSK1al8adOnbafDDaUw+NKGwMowXMy3H6J7E2/J4/CCygA1l1eBFiMB
        j1HRwfF/Jj8bXoX06TSrxd3aSv9Fm9FHVeZpftOINr9reekzTKjCUFbzyNY6xu+tHo12Ffxx+tuB4
        371C9sNaaRVSjk8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpWFd-00EPqc-MF; Tue, 23 Nov 2021 14:54:25 +0100
Date:   Tue, 23 Nov 2021 14:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YZzykR2rcXnu/Hzx@lunn.ch>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch>
 <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
 <YZxqLi7/JDN9mQoK@lunn.ch>
 <0a9e959a-bcd1-f649-b4cd-bd0f65fc71aa@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a9e959a-bcd1-f649-b4cd-bd0f65fc71aa@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Hi Andrew,
> > > 
> > >      Use default mdio configure, After module compilation, mdio alias configure
> > > is following and it doesn't match
> > > 
> > >      the match phy dev(mdio dev)  uevent, because the mdio alias configure
> > > "0000000101000001000011111001????"  include "?" and
> > A PHY ID generally break up into 3 parts.
> > 
> > The OUI of the manufacture.
> > The device.
> > The revision
> > 
> > The ? means these bits don't matter. Those correspond to the
> > revision. Generally, a driver can driver any revision of the PHY,
> > which is why those bits don't matter.
> > 
> > So when a driver probes with the id 00000001010000010000111110010110
> > we expect user space to find the best match, performing wildcard
> > expansion. So the ? will match anything.
> > 
> > Since this is worked for a long time, do you have an example where it
> > is broken? If so, which PHY driver? If it is broken, no driver is
> > loaded, or the wrong driver is loaded, i expect it is a bug in a
> > specific driver. And we should fix that bug in the specific driver.
> > 
> >       Andrew
> 
> Hi Andrew,
> 
> The string like "0000000101000001000011111001????" dont't match any mdio driver, and i said it include "? that "?" doesn't match any driver, in addition that include Binary digit
> like "0000000101000001000011111001", that binary digit doesn't match any driver, that should use Hexadecimal for phy id, and I test on some platform, not only a platform, it isn't some
> specifi driver issue, it is gerneral issue. please you note.  that phy driver match phy device must use whole string "MODALIAS=xxxyyzz", not partial match.

Please give a concrete example. Show us udev logs of it not working,
it failing to find a match.

	Andrew
