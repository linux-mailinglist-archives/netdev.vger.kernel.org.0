Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B554DC858
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiCQOH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiCQOHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:07:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B525122232;
        Thu, 17 Mar 2022 07:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647525961; x=1679061961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WyIgvspQhf/CWwmJmV9DuJtBRSa+lu1xsA1u/xKmtYk=;
  b=pXvtN12X59gfFlhaAj2KO2b8Sd2XA+Apjjg+eX9aqYU8ELKTjToHnnr5
   pBCk0vhZQFJTI+Ol0xzRZBY9QqYtIVVydqCdbgRWmfCcTi7+OAezTepPo
   +Yc5XX3jdCvStvCBSbPrCBMqKFjpX2EsKP38mAh+tnVmweR8c2tC2QJGX
   FannnVKZpKvcDu3nfAneEk2KJz9fZqBF7av2FngrZMiwZPPJZciJp9hh/
   8Y3HB+QGasq+L957YF0M4weh9kQctOZ6VXT6pvAv8UR+0UmvyTIFDeYUC
   uzeCTRSKDDYQeKoVbfWUa3fTQvwIxbkj6xmq/LIC5Sv/zTK6CBg9J4EyJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="157263183"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 07:06:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 07:06:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 07:06:00 -0700
Date:   Thu, 17 Mar 2022 15:05:59 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <patchwork-bot+netdevbpf@kernel.org>,
        <Divya.Koppera@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <hkallweit1@gmail.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <madhuri.sripada@microchip.com>,
        <manohar.puri@microchip.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <20220317140559.f52cuvw6gswyrfn6@den-dk-m31684h>
References: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <20220317121650.934899-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220317121650.934899-1-michael@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Mar 17, 2022 at 01:16:50PM +0100, Michael Walle wrote:
> From: patchwork-bot+netdevbpf@kernel.org
> > Here is the summary with links:
> >   - [net-next,1/3] net: phy: micrel: Fix concurrent register access
> >     https://git.kernel.org/netdev/net-next/c/4488f6b61480
> >   - [net-next,2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
> >     https://git.kernel.org/netdev/net-next/c/2358dd3fd325
> >   - [net-next,3/3] net: phy: micrel: 1588 support for LAN8814 phy
> >     https://git.kernel.org/netdev/net-next/c/ece19502834d
> 
> I'm almost afraid to ask.. but will this series be reverted (or
> the device tree bindings patch)? There were quite a few remarks, even
> about the naming of the properties. So, will it be part of the next
> kernel release or will it be reverted?
Thanks for bringing this up - was about to ask myself.

Not sure what is the normal procedure here.

If not reverted, we can do a patch to remove the dt-bindings (and also
the code in the driver using them). Also, a few other minor comments was
given and we can fix those.

The elefant in the room is the 'lan8814_latencies' structure containing
the default latency values in the driver, which Richard is unhappy with.

Russell indicated that he prefere having these numbers in the driver
rather than hiding them in firmware (lan8814 does not have firmware, so
not an option).

Andrew sugegsted adding additional APIs to let ptp4l control if
time-stamps should be calibrated in HW/Kernel or in userspace. Likely
something like that can be done - but I did not get the impression that
this is what Richard would like to see either.

Also, I would like drivers to come with default latency numbers which
are good enough for most (and the rest will need to calibrate and
compensate further using the hooks and handles in userspace).

What would you like to see - believe you will also be a user of this?

-- 
/Allan
