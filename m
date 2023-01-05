Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAC65F639
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbjAEVvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbjAEVu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:50:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79FA63199;
        Thu,  5 Jan 2023 13:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672955395; x=1704491395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GWLfTS968CloPMevtoM4MSviKK8lba7mNlv0zXAMW2M=;
  b=l4Kacu2Xe5LHBsXCDWh6lINbxECnboldEbE/eyui48eD63Vj5s/jkUu7
   rjb90Drb9FyUEwJ1NDXBLyV1J9oSWVpXj9p/6akWlg+rAHheNb1stX9F1
   UgBLno5HuVDhjh63bePss5hF11q2eNwAty19JEsKmMqqQ980Ja/yfXQ5G
   rvWQMSpFMZHOKTnMmXuRZPE5gqJi78CmG2yFKl+hUMUDYeEqjQGUQ3rdr
   eKD+Ir+kITrPzI1HJ86EQ/TguB7YeFCWuYmwegruEvJiUHSwA6vikz734
   vHv69FWoSL6AH+aIHSM1AtXajs0uYkXdCYJVyICZ/5GN8TMEE6pHrd8bS
   g==;
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="194503577"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 14:49:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 14:49:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Thu, 5 Jan 2023 14:49:53 -0700
Date:   Thu, 5 Jan 2023 22:55:12 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <daniel.machon@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <olteanv@gmail.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20230105215512.uck2gy4hyd2z7hq4@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <dff03705f3c81962246731ad188d9d3d@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <dff03705f3c81962246731ad188d9d3d@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/05/2023 16:09, Michael Walle wrote:
> 
> Hi,

Hi Michael,

> 
> > > Also, if the answer to my question above is yes, and ptp should
> > > have worked on eth0 before, this is a regression then.
> > 
> > OK, I can see your point.
> > With the following diff, you should see the same behaviour as before:
> > ---
> > diff --git
> > a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > index 904f5a3f636d3..538f4b76cf97a 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > @@ -91,8 +91,6 @@ lan966x_vcap_is2_get_port_keysets(struct net_device
> > *dev, int lookup,
> > 
> >         /* Check if the port keyset selection is enabled */
> >         val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
> > -       if (!ANA_VCAP_S2_CFG_ENA_GET(val))
> > -               return -ENOENT;
> > 
> >         /* Collect all keysets for the port in a list */
> >         if (l3_proto == ETH_P_ALL)
> 
> Any news on this? Apart from the patches which would change the
> need to use some tc magic, this should be a separate fixes patch,
> right?

My colleague Steen, has sent a patch series here [1].
This allows to PTP rules in HW without any tc commands.

[1] https://lore.kernel.org/lkml/20230105081335.1261636-1-steen.hegelund@microchip.com/T/

> 
> -michael

-- 
/Horatiu
