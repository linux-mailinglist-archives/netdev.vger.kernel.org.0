Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7C6C60E7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCWHhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjCWHhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:37:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65331F940
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 00:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679557018; x=1711093018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oME3sK48Www6EH3pPAUZlkrGcGu1+D5q1NsgJcAKE38=;
  b=XNUlPH2SQJROGWcrHxrvK1n4fHbsBgZ8WAJ/osSYL1XeZRkIOqxOaXTv
   lbpZi/4U0iYp4CnjTMpKuziEk/2js/bPxHlmGf+/nqSvEPI4JQSGrMqfi
   2k2kV5Ysu1paqyxYqZ1Cow769v5/aurpFAbu6Lvh5uEpquSMkPgyDNFNJ
   0gVsFyzzMSpNp3oRGXrD1+M1RPDE84jFWF39sIZZsYnkL9osVybKbRCcO
   eOuQ8tatvPsSILwWIw3Y8ZnjfbDVWErsIv+AebesAN2RBHEIgKImvTwdA
   Cr2UTzpZ24atoqRH3bBIGU/B/8JrFad2iR4fgCJotobzc5Z1rE4MnXkZH
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,283,1673938800"; 
   d="scan'208";a="206831531"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 00:36:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 00:36:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 00:36:56 -0700
Date:   Thu, 23 Mar 2023 08:36:55 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Liang He <windhl@126.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <david.daney@cavium.com>
Subject: Re: [PATCH] net: mdio: thunder: Add missing fwnode_handle_put()
Message-ID: <20230323073655.mppg4ty6qcqcpdmp@soft-dev3-1>
References: <20230322062057.1857614-1-windhl@126.com>
 <20230322085538.pn57j2b5dyxizb4o@soft-dev3-1>
 <21d42d91.1283.1870c2c39cf.Coremail.windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <21d42d91.1283.1870c2c39cf.Coremail.windhl@126.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/23/2023 09:53, Liang He wrote:
> 
> At 2023-03-22 16:55:38, "Horatiu Vultur" <horatiu.vultur@microchip.com> wrote:
> >The 03/22/2023 14:20, Liang He wrote:
> >>
> >> In device_for_each_child_node(), we should add fwnode_handle_put()
> >> when break out of the iteration device_for_each_child_node()
> >> as it will automatically increase and decrease the refcounter.
> >
> >Don't forget to mention the tree which you are targeting.
> >It shoud be something like:
> >"[PATCH net] net: mdio: thunder: Add missing fwnode_handle_put()" and
> >you can achieve this using option --subject-prefix when you create your
> >patch:
> >git format-patch ... --subject-prefix "PATCH net"
> >
> 
> Thanks for your reply and advise, I will add it in my future patches.
> 
> >
> >>
> >> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> >> Signed-off-by: Liang He <windhl@126.com>
> >> ---
> >>  drivers/net/mdio/mdio-thunder.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
> >> index 822d2cdd2f35..394b864aaa37 100644
> >> --- a/drivers/net/mdio/mdio-thunder.c
> >> +++ b/drivers/net/mdio/mdio-thunder.c
> >> @@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
> >>                 if (i >= ARRAY_SIZE(nexus->buses))
> >>                         break;
> >>         }
> >> +       fwnode_handle_put(fwn);
> >
> >Can you declare only 1 mdio bus in the DT under this pci device?
> >Because in that case, I don't think this is correct, because then
> >'device_for_each_child_node' will exit before all 4 mdio buses are probed.
> >And according to the comments for 'fwnode_handle_put' you need to use
> >with break or return.
> >
> 
> In fact, the fwnode_handle_put(fwn) consider the NULL-check of fwn, and
> there are only break, not return, so I think it can work in this case.
> However, if you prefer to add fwnode_handle_put before break, I can
> send a new patch.

You are right, fwnode_handle_put checks for NULL.
It is up too you how you prefer.

> 
> Thanks,
> Liang
> 
> >>         return 0;
> >>
> >>  err_release_regions:
> >> --
> >> 2.25.1
> >>
> >
> >--
> >/Horatiu

-- 
/Horatiu
