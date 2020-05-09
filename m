Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785161CC16A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEIMtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgEIMtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:49:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73BEC061A0C;
        Sat,  9 May 2020 05:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ofKctXoH+m0Fuga5hDoLoGrcO5F7LTTcAmCfOo9W42Y=; b=lNsNpV+RcKH1Qn1rBTs5f8+rU
        68IqQuKpdatZdVlW7YhUTxVgK9SqODJiqutdr1KWEd7G/5bE++/3GcQ6m7yILOVf863J4u/HMxwFo
        kARNkY1UmQrgupIXrLOPXJxTdoq4GzprmkKmwAUXQ9Td0VJoGtSERY6kJonpRIV/kOiD7rGFr3kQZ
        P1E1g9d+rRpY0IwzgHtJFr7QTZFUBA2dZOake/tEAUUZZqnCbEih5Yn0GZaCY3YhZAig5s1/qFF/T
        hVGG15CbxeenQIkNhnJ2QYReFGBKfbtcRJmVcc3MQbQBnkopfsd68tBV0TKqQ2QZK5MKayqas+HUn
        CTOloW3nQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38016)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXOuO-0003qz-Ck; Sat, 09 May 2020 13:48:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXOuJ-0002rh-R8; Sat, 09 May 2020 13:48:43 +0100
Date:   Sat, 9 May 2020 13:48:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Message-ID: <20200509124843.GC1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk>
 <20200509141644.29861e96@windsurf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509141644.29861e96@windsurf.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 02:16:44PM +0200, Thomas Petazzoni wrote:
> Hello,
> 
> On Sat, 9 May 2020 12:45:18 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > Looking at the timeline here, it looks like Matteo raised the issue
> > very quickly after the patch was sent on the 14th April, and despite
> > following up on it, despite me following up on it, bootlin have
> > remained quiet.
> 
> Unfortunately, we are no longer actively working on Marvell platform
> support at the moment. We might have a look on a best effort basis, but
> this is potentially a non-trivial issue, so I'm not sure when we will
> have the chance to investigate and fix this.

That may be the case, but that doesn't excuse the fact that we have a
regression and we need to do something.

Please can you suggest how we resolve this regression prior to
5.7-final?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
