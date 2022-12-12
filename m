Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D9649BCA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiLLKNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiLLKNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:13:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139B110DE;
        Mon, 12 Dec 2022 02:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zrS33GIxb8SI89B79yoHCpMHF6IZ4yfmm7uKp66NxsI=; b=hKitPnzJx9Up9shqu8onbwjZ40
        KRuS5OBzr2TL9lD8vYdMFie0d0CwRe3Faa+jhcV40XBspHUSW8jUzFb19jw3nnmB0BskeGYA7hvOV
        xEJyjV+GYWQeahcUHa60zqd4Ek25qsF1IQO+3pkdI6wyF4Eyo3GA2iTQLJhFATjvmiqI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4fmd-0054IW-Sv; Mon, 12 Dec 2022 11:11:39 +0100
Date:   Mon, 12 Dec 2022 11:11:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Message-ID: <Y5b+W+bphtD+9chT@lunn.ch>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
 <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Y49M++waEHLm0hEA@lunn.ch>
 <CO1PR11MB4771F8AA1CCAD01EAE797E59E2E29@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771F8AA1CCAD01EAE797E59E2E29@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > content is safe
> > 
> > > > > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > > > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > > > -             return 0;
> > > > > -
> > > >
> > > > Why are you removing this ?
> > > >
> > >
> > > I got review comment from Richard in v2 as below, making it as consistent
> > by checking ptp_clock. So removed it in next revision.
> > >
> > > " > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> > > > {
> > > >         struct lan8814_shared_priv *shared = phydev->shared->priv;
> > > >
> > > >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > >             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > >                 return 0;
> > >
> > > It is weird to use macros here, but not before calling ptp_clock_register.
> > > Make it consistent by checking shared->ptp_clock instead.
> > > That is also better form."
> > 
> > O.K. If Richard said this fine.

Since Richard wants this removed, i would just remove it. The object
code saving is probably not much.

     Andrew
