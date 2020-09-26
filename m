Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A582798AE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgIZLUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 07:20:05 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6844 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZLUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 07:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601119204; x=1632655204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A0U/sr4vt/ziUMkFLZ5dkBWER2rtLcGn4oExQ3N6YVI=;
  b=WSVCQnUxgj4QWRGwFoiVx0YirPaUfz5xa9jHI793hhTMmb7Zp6imgeig
   hGRPdvzRSAzlDgomTV2ztto9kIP0+Mkj9sRHcpDNEH4BsiY++LOWWZvMX
   BhctnsghdLw9PeuWJcwiK0XYrBeBVh+XXryhy6xW3oOealj5aBBT9jRKS
   pov2eYTHMBNRBT09QZtv+2GMinaGJIUR+gA1TVw5aKSavX7aYJJvnp6Bd
   BNt+kzkZq4Bw5EmB016OEPiBefT6QUW0eRyCHgje46SEkdmDXOoplbohh
   BFZS7/UpXEausPLk/DSTr/XAsoA9ruIf4z7cQXYzyWAMoYMYLrTRs27d/
   A==;
IronPort-SDR: HaepiYyM/Kg9geIS2EfbDC+uHqMveggEsHskeFAebH8+A3u5uDZrrlmPjQzZmrUOfNk0jkc6Kl
 Rdq2J+F+Vr1NYwNsABDmnHel+WEaF0wpooMx4lOhQb/DXWUNQk51zy3zm4nWFjr7Um/eUfTSxj
 abMmfrV8MVFC2l9GdYifoF01cmY6QI8VOrQGA9nspwDl0GSBgz2didIy6xiRrNFRahRQRmCm0z
 Ehx3Aix1RYpid08y3fWsHj3le18OAICkG4Zkr6Xks5jryKQzO+UhO9NzPN7AQ+qtVY0OXIirLG
 Jtc=
X-IronPort-AV: E=Sophos;i="5.77,305,1596524400"; 
   d="scan'208";a="93278762"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Sep 2020 04:20:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 26 Sep 2020 04:20:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 26 Sep 2020 04:20:03 -0700
Date:   Sat, 26 Sep 2020 13:20:02 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "James Hogan" <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        <hongbo.wang@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200926112002.i6zpwi26ong2hu4q@soft-dev3.localdomain>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
 <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
 <20200924233949.lof7iduyfgjdxajv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200924233949.lof7iduyfgjdxajv@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/25/2020 02:39, Vladimir Oltean wrote:
> 
Hi Vladimir,

> Hi Horatiu,
> 
> On Thu, Apr 23, 2020 at 10:29:48AM +0200, Horatiu Vultur wrote:
> > > > +static const struct vcap_props vcap_is2 = {
> > > > +       .name = "IS2",
> > > > +       .tg_width = 2,
> > > > +       .sw_count = 4,
> > > > +       .entry_count = VCAP_IS2_CNT,
> > > > +       .entry_words = BITS_TO_32BIT(VCAP_IS2_ENTRY_WIDTH),
> > > > +       .entry_width = VCAP_IS2_ENTRY_WIDTH,
> > > > +       .action_count = (VCAP_IS2_CNT + VCAP_PORT_CNT + 2),
> > > > +       .action_words = BITS_TO_32BIT(VCAP_IS2_ACTION_WIDTH),
> > > > +       .action_width = (VCAP_IS2_ACTION_WIDTH),
> > > > +       .action_type_width = 1,
> > > > +       .action_table = {
> > > > +               {
> > > > +                       .width = (IS2_AO_ACL_ID + IS2_AL_ACL_ID),
> > > > +                       .count = 2
> > > > +               },
> > > > +               {
> > > > +                       .width = 6,
> > > > +                       .count = 4
> > > > +               },
> > > > +       },
> > > > +       .counter_words = BITS_TO_32BIT(4 * ENTRY_WIDTH),
> > > > +       .counter_width = ENTRY_WIDTH,
> > > > +};
> 
> Coming again to this patch, I'm having a very hard time understanding
> how VCAP_IS2_ENTRY_WIDTH is derived and what it represents, especially
> since the VCAP_CONST_ENTRY_WIDTH register reads something different.
> Could you please explain?

To be honest, I don't remember precisely. I will need to setup a board
and see exactly. But from what I remember:
- according to this[1] in chapter 3.8.6, table 71. It says that the full
  entry of IS2 is 384. And this 384 represent a full entry. In this row,
  can be also sub entries like: half entry and quater entries. And each
  entry has 2 bits that describes the entry type. So if you have 2 bits
  for each possible entry then you have 8 bits describing each type. One
  observation is even if you have a full entry each pair of 2 bits
  describing the type needs to be set that is a full entry. Maybe if you
  have a look at Figure 30, it would be a little bit more clear. Even
  there is a register called VCAP_TG_DAT that information is storred
  internally in the VCAP_ENTRY_DAT.
- so having those in mind, then VCAP_IS2_ENTRY_WIDTH is the full entry
  length - 8 bits. 384 - 8 = 376.
- then if I remember correctly then VCAP_CONST_ENTRY_WIDTH should be
  384? or 12 if it is counting the words.

Does it make sense or am I completly off?

> 
> Thanks,
> -Vladimir

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf

-- 
/Horatiu
