Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9036D4D7603
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 16:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiCMPIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 11:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiCMPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 11:08:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F20158E4E;
        Sun, 13 Mar 2022 08:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QlF97qmxXnAaxgE12EIsUUm/KvgzzcZ7O7tV7qAZxfY=; b=qBWFRN1bKjm0eLmZBrgEE6IUWG
        Zws5E9eOk7aVjWwM2JpdWxtZXzNohInlnsBHqXaSmOOYLx/yHHlCNSAZW71ejMo30Zg7DCnJYxjp1
        lQAFw3vuskpeZQoRnAui9ywjA97bJOfWfzmbsmluWLL480vSTvXbsU59Bcrg7IhjeWr0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTPoa-00AdFF-Di; Sun, 13 Mar 2022 16:07:24 +0100
Date:   Sun, 13 Mar 2022 16:07:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Woojung.Huh@microchip.com, linux@armlinux.org.uk,
        Horatiu.Vultur@microchip.com, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <Yi4IrO4Qcm1KVMaa@lunn.ch>
References: <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
 <Yiz8z3UPqNANa5zA@lunn.ch>
 <20220313024646.GC29538@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313024646.GC29538@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 06:46:46PM -0800, Richard Cochran wrote:
> On Sat, Mar 12, 2022 at 09:04:31PM +0100, Andrew Lunn wrote:
> > Do these get passed to the kernel so the hardware can act on them, or
> > are they used purely in userspace by ptp4l?
> 
> user space only.
>  
> > If they has passed to the kernel, could we provide a getter as well as
> > a setter, so the defaults hard coded in the driver can be read back?
> 
> Any hard coded defaults in the kernel are a nuisance.
> 
> I mean, do you want user space to say,
> 
>    "okay, so I know the correct value is X.  But the drivers may offer
>    random values according to kernel version.  So, I'll read out the
>    driver value Y, and then apply X-Y."
> 
> Insanity.

No, i would not suggests that at all.

You quoted the man page and it says the default it zero. If there was
an API to ask the driver what correction it is doing, and an API to
offload the delay correction to the hardware, i would simply remove
the comment about the default being zero. If these calls return
-EOPNOTSUPP, then user space stays the same, and does actually use a
default of 0. If offload is supported, you can show the user the
current absolute values, and allow the user to set the absolute
values.

Anyway, it is clear you don't want the driver doing any correction, so
lets stop this discussion.

     Andrew
