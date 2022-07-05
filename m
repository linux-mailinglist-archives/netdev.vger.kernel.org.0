Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3F567702
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiGES6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiGES6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:58:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1847F1F2D4;
        Tue,  5 Jul 2022 11:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qZ2WlJMPplKX5hD7/ytSPU+PApsdSlrWaoNdjz1LRz4=; b=H4m64xxvn/PDDZ4J1IXvojRhaz
        mTahq53NWWB8NnCBdcSI61nm5EuqE1DphksCjYYd208+6LkHeGd8NGTztH58x7sEKckiR4fVr4tjs
        e7iWNcxrcJ7GQ3JR6atkk3hgpEWyOFfH6Yad1NBN9XucN0wl1xC+LXcBPpj58CgvM71M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o8nk1-009OaC-MM; Tue, 05 Jul 2022 20:57:45 +0200
Date:   Tue, 5 Jul 2022 20:57:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "saravanak@google.com" <saravanak@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Message-ID: <YsSJqb9pPFcrIvrU@lunn.ch>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch>
 <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the review.  I want to get your thoughts on the outline of
> the generic solution. Is the current approach fine and we can extend it
> for all shared MDIO use cases/ or do we see any limitations?
>  
> a) Figure out if the MDIO bus is shared.  (new binding or reuse existing)
> b) If the MDIO bus is shared based on DT property then figure out if the 
> MDIO producer platform device is probed. If not, defer MDIO consumer
> MDIO bus registration.

I actually think you need to talk to the core device model people and
those who support suspend/resume.

It seems like there should be a way to declare a dependency, probably
a probe time, so the core will just do the right things. I don't see
why MDIO busses should be the first to have this problem, so i expect
there already exists a solution.

	Andrew
