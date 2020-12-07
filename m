Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE762D0B89
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgLGIOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:14:14 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:58418 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgLGION (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 03:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607328853; x=1638864853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lyvoZglFnJty2Ptrt8qqn4PrsEF1NEv+5hHYWjUDdg8=;
  b=PilU8jBqg1lgkRxYb0DSbVjuAxnZMs6gFY0zHOncnSu2zVLhG1XwAZpF
   9rW6jug2HXBDpj2i4x5X90Uh1WyuD9hINq47dXB96wp9ZMnaYv5ZH6AyP
   4Cc5MrwtpN6Uht4LBU2wjsMjxDQxg8ycu/b0wMIDHfA4tTcbuhZe8a6bQ
   Yk+Fv4nEdaClVZxgLF+5bhUKofRA1YNDrLla/+h8uGzdSM47iuGs5dZNN
   XdU3qLpBjRhUE1hhR+AWmZ1gmxrWgzJWUQD43URjSSYfW2LK8xtF2Tsx0
   +7NXqMdKfprUWkJH75NwuPIDab19stClz5v+FtYwV1LDtg9zrtPfu3N6t
   w==;
IronPort-SDR: FkdIyWkTIt8kxn4MoG81U8mbP2jJacm3fl1+zLNU4P4jyzn+X7PVkN2uFTBBSuAKAwLAjfSJlT
 cJBz2ASTZT5jm9uv6krmCwRr/mo6BLs8a/fbZeEg0Js/c9Dmlfd6ZmNiHQVXz+s1jLxR+m8iZ5
 p6bsrg1zZLwAx6dJUrJbIc+RA4+5E1+XtNHrsN5x3kjM+Mppv61S0hNMD6w9jYbRiUwHRjxHgQ
 yrJH6SHFmXyG8TCjBnuA/+SAs6ZKosm581G6PoDNF7Sr7EfNrvqey3i77STkF4bGPyFQni2lOF
 DIA=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="36385437"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 01:13:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 01:13:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 7 Dec 2020 01:13:06 -0700
Date:   Mon, 7 Dec 2020 09:13:05 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201207081305.urojcsaw27eqnag2@mchp-dev-shegelun>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
 <20201204141606.GH74177@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201204141606.GH74177@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.12.2020 15:16, Alexandre Belloni wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On 03/12/2020 22:52:53+0100, Andrew Lunn wrote:
>> > +   if (macro->serdestype == SPX5_SDT_6G) {
>> > +           value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
>> > +           analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> > +   } else if (macro->serdestype == SPX5_SDT_10G) {
>> > +           value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
>> > +           analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> > +   } else {
>> > +           value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
>> > +           analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
>> > +   }
>> > +   /* Link up is when analog_sd == 0 */
>> > +   return analog_sd;
>> > +}
>>
>> What i have not yet seen is how this code plugs together with
>> phylink_pcs_ops?
>>
>> Can this hardware also be used for SATA, USB? As far as i understand,
>> the Marvell Comphy is multi-purpose, it is used for networking, USB,
>> and SATA, etc. Making it a generic PHY then makes sense, because
>> different subsystems need to use it.
>>
>> But it looks like this is for networking only? So i'm wondering if it
>> belongs in driver/net/pcs and it should be accessed using
>> phylink_pcs_ops?
>>
>
>Ocelot had PCie on the phys, doesn't Sparx5 have it?

Yes Ocelot has that, but on Sparx5 the PCIe is separate...

>
>--
>Alexandre Belloni, Bootlin
>Embedded Linux and Kernel engineering
>https://bootlin.com

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
