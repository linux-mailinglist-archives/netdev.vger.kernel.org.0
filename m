Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9273224AF2
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgGRL01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgGRL01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:26:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3318C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 04:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4iLSsAfx3v7HuF1YfetgEuWt/hEp+GHhjhLNHBisZw8=; b=f8uuvuGqjfBycruiqIzLzBpAn
        YBi5llP8pXR3anxNOprolnl9nRQXxWm2EicTLZGMmIX4RyHF6TEOoa/iL45p8AnReoLsXCpdgAB5O
        AxtB6dDf+Sa4KBpks381EwJBkIuoDt9WAOdWinswtTC+mXC/kjGofQj99WJQW5DdkZLvGjK6zK6ne
        6ltgxpXuVOtL8drJuF1Jje2TkK+GrLZntBZp3V3GskyqhrV1gU+NVBn5kUx98mX+vsEtRkV/gVDpB
        6gffbeXR3G1xk/WZACCHX9hIYHIMERYnDmgiH5dqwqOJV2N+qljnYonM9l0iULo91FlnGZ7N7eTlm
        +8B7cmEcg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41040)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwkz1-0001ZP-Qb; Sat, 18 Jul 2020 12:26:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwkyy-0002ta-Oc; Sat, 18 Jul 2020 12:26:20 +0100
Date:   Sat, 18 Jul 2020 12:26:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200718112620.GP1551@shell.armlinux.org.uk>
References: <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk>
 <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk>
 <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
 <20200718085028.GN1551@shell.armlinux.org.uk>
 <CAOAjy5SewXHQVnywzin-2LiqWyPcjTvG9zzaiVRtwfCG=jU1Kw@mail.gmail.com>
 <20200718101259.GO1551@shell.armlinux.org.uk>
 <CAOAjy5SDgAeF7=mQWByGTFUsctkuAUpwhbaTzNWcsebbyof+gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5SDgAeF7=mQWByGTFUsctkuAUpwhbaTzNWcsebbyof+gQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 11:21:26AM +0000, Martin Rowe wrote:
> On Sat, 18 Jul 2020 at 10:13, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > Okay, on top of those changes, please also add this:
> 
> "in-band-status" plus your chip.c patch works; I can now ping from the GT 8K.

Great, and your kernel messages and debug all correlates correctly.
It looks like we have two latent bugs to fix here, both of which
were uncovered by Andrew's change.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
