Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446124EEEF1
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346714AbiDAON1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346706AbiDAONY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:13:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9084C5C641;
        Fri,  1 Apr 2022 07:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648822296; x=1680358296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oR155vuc+E55A131IrM2oF6LW3I3FCsWE5dYbfq7kQI=;
  b=D3wDClp3ZKye1HI1REETEESnYeUcyilZJE+ivLlW2XUtbrTVFj6ianXV
   Dgxxwf0zCPKGVNL8JPBjWmxJZOm02GaBuNb+piM602J+8nEVztwUdsRdd
   Cdf+hUMTfkJBPZNaisWtyc0lD+7ngCHiMm8uikt9DlmphMGDv++g5U2Pg
   WDg28oCjuhu99KybHCBYfW+3WaSmE5vcmGDskY9eB41M4jJnqqdzV3EU1
   GogBTMcvLzj4mjT0/Kha6Vjqt77F/LEuA7YH4JVEWQVsUZ6XkD0wEEAZR
   BXKj/W/gkbCokV1aHcvldA//KEy/5oRCJTX6yHok0JzOZV3lnldvE862L
   g==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="158540795"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 07:11:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 07:11:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Apr 2022 07:11:34 -0700
Date:   Fri, 1 Apr 2022 16:11:20 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <Divya.Koppera@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net v2 0/3] net: phy: micrel: Remove latencies support
 lan8814
Message-ID: <20220401141120.imsolvsl2xpnnf4q@lx-anielsen>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
 <Ykb2yoXHib6l9gkT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <Ykb2yoXHib6l9gkT@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.04.2022 14:57, Andrew Lunn wrote:
>On Fri, Apr 01, 2022 at 01:05:19PM +0200, Horatiu Vultur wrote:
>> Remove the latencies support both from the PHY driver and from the DT.
>> The IP already has some default latencies values which can be used to get
>> decent results. It has the following values(defined in ns):
>> rx-1000mbit: 429
>> tx-1000mbit: 201
>> rx-100mbit:  2346
>> tx-100mbit:  705
>
>So one alternative option here is that ptp4l looks at
>
>/sys/class/net/<ifname>/phydev/phy_id
>
>to identify the PHY, listens to netlink messages to determine the link
>speed and then applies the correction itself in user space. That gives
>you a pretty generic solution, works for any existing PHY and pretty
>much any existing kernel version.  And if you want board specific
>values you can override them in the ptp4l configuration file.
I think it is good to have both options. If you want PTP4L to compensate
in user-space, do not call the tunable, if you want to HW to compensate,
call the tunable (this is useful both for users using ptp4l and other
ptpimplementations).

If system behaves strange, it is easy to see what delays has been
applied.

We are planning on creating a small proejct, which go through all PHYs
in the current system. It shall check a config file to see if the user
has configured interface specific numbers, then apply them, other wise
see if we have default numbers based on the PHY-ID (like you describe).

Idea is to run this at boot as a one-off. It will apply the adjustments
on all speeds, all capable PHYs regardless of they PHY-Timestamping is
used or not.

BTW: If there is a desire, we can add a flag to this tool which can set
all the delay-values to zero.

Just for the record: It is not that I do not like PTP4L - it is by far
the best PTP implementation I have seen. But I'm keen on having a
solution that also works for non-ptp4l users.

/Allan

