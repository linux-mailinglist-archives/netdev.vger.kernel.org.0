Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F80C4DCEDB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbiCQTb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238030AbiCQTbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:31:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF406220FD5;
        Thu, 17 Mar 2022 12:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647545408; x=1679081408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IagItVMT2rUUwCmK8ANP5MZ4EDtOTPxf97HiwqLwsGw=;
  b=OqQhSXFWKEjmMkydURFBQjIxO/DQu1AxV5BeFiKeCzvL0JPflgrPqYQZ
   QMO+iFYSpYEzWqMvgBaBr9goL1nsiYN08AUTmqYStrTzKUsd0aeKBhtEy
   NYG/kicWaDPlO5PCu9yagg8JNJznG/PTmP4Fau3FZY0XXcIEyr5NYEPXb
   87mY5lXmjL7WWesANdUxMHVY0NuD4O0VcD6NyxBtopbq8y9nmkqX9jxss
   JBwU2SO1vK7MUjaJrgJvG1PKonsN35LQQ7bWSXag3mqHvn5uAAr4ithrT
   CVBqzPgVmGiffE01PR536NFde6E9Yg/qTwHbmbl8QY6ymizRooJJ52qj0
   A==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="156845369"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 12:30:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 12:30:06 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 12:30:06 -0700
Date:   Thu, 17 Mar 2022 20:30:05 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Michael Walle <michael@walle.cc>,
        <patchwork-bot+netdevbpf@kernel.org>,
        <Divya.Koppera@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <madhuri.sripada@microchip.com>, <manohar.puri@microchip.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <20220317193005.q7kna75jpmy5ysw5@den-dk-m31684h>
References: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <20220317121650.934899-1-michael@walle.cc>
 <20220317140559.f52cuvw6gswyrfn6@den-dk-m31684h>
 <YjNH+jahuTwDyVso@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YjNH+jahuTwDyVso@lunn.ch>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:38:50PM +0100, Andrew Lunn wrote:
> On Thu, Mar 17, 2022 at 03:05:59PM +0100, Allan W. Nielsen wrote:
> > Hi,
> >
> > On Thu, Mar 17, 2022 at 01:16:50PM +0100, Michael Walle wrote:
> > > From: patchwork-bot+netdevbpf@kernel.org
> > > > Here is the summary with links:
> > > >   - [net-next,1/3] net: phy: micrel: Fix concurrent register access
> > > >     https://git.kernel.org/netdev/net-next/c/4488f6b61480
> > > >   - [net-next,2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
> > > >     https://git.kernel.org/netdev/net-next/c/2358dd3fd325
> > > >   - [net-next,3/3] net: phy: micrel: 1588 support for LAN8814 phy
> > > >     https://git.kernel.org/netdev/net-next/c/ece19502834d
> > >
> > > I'm almost afraid to ask.. but will this series be reverted (or
> > > the device tree bindings patch)? There were quite a few remarks, even
> > > about the naming of the properties. So, will it be part of the next
> > > kernel release or will it be reverted?
> > Thanks for bringing this up - was about to ask myself.
> >
> > Not sure what is the normal procedure here.
> 
> I assume this is in net-next. So we have two weeks of the merge window
> followed by around 7 weeks of the -rc in order to clean this up. It is
> only when the code is released in a final kernel does it become an
> ABI.
> 
> > If not reverted, we can do a patch to remove the dt-bindings (and also
> > the code in the driver using them). Also, a few other minor comments was
> > given and we can fix those.
> 
> Patches would be good. Ideally the patches would be posted in the next
> couple of weeks, even if we do have a lot longer.
> 
> > The elefant in the room is the 'lan8814_latencies' structure containing
> > the default latency values in the driver, which Richard is unhappy with.
> 
> The important thing is getting the ABI fixed. So the DT properties
> need to be removed, etc.
We will do that.

> To some extend the corrections are ABI. If the corrections change the
> user space configuration also needs to change when trying to get the
> best out of the hardware. So depending on how long the elefant is
> around, it might make sense to actually do a revert, or at minimum
> disabling PTP, so time can be spent implementing new APIs or whatever
> is decided.
ACK.

> So i would suggest a two pronged attach:
> 
> Fixup patchs
> Try to bring the discussion to a close and implement whatever is decided.
Make sense - we will do the fix-ups and try restart the dicussion.

-- 
/Allan
