Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3B29513E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503308AbgJUQ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 12:59:18 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2831 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503290AbgJUQ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 12:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603299553; x=1634835553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gv8zeiN6SuGFQ/VMgl/Nsqse/mSIqJnzICPQ/4DBg5s=;
  b=c9gl3B+SHHx7ybySDydQdIY1gSJ9+ZMuwgbUBULGclA3ekgya+qKiCKD
   3bbz8JLrHtF4uou833tQoc40w6NC7wdUQQua6I3xPAD00dk+CsENnVI7M
   +r7ZXOA9QFrhjAGAAhneR/CCHA7FmH82NGvOHJ+1G4ktX1hplPLMZymF2
   Yiqwnck9vDqi4jykcYaYyNUisDZnoTHqint5K4A9sshybJNy8WCh2crsr
   TWaTu+2kjuwheiu5gMM7N+TP1adiUPdKrFfF0bbzrxFLHAhzgvvAnu0dV
   qv3UBtK0c11qRvg0I4lROKL0Ao99tXQuYcGDubRSfRKakrxMRAEpkmy03
   Q==;
IronPort-SDR: YqqHvhrwDSHLgjLdGmxCgE61Mb2GDH/LRpkDT5+Gr73l2iB1wqW2pYIMkENCazJyWJHN0GEkn2
 1WH2Ad/x0U2Z9eJ3Hu0mjhFMgHCvoC8xpeYZkkg9hTdIK6zZ5l89ZT+ZB2t/Y524m99rgqQzV6
 IYMGp9C3lz1XEUMS/E0sduJFv9htxivZbE8GBZN2mXxO1INPI/6dt9N/tyDh1INfl9UQDb8Q3c
 qtUP3EyUCD+dZ9Vo7ee6vOIA0GSjs9IgZDfVPHNeFBXs3JsTqPny6X1iApw1JeC4Qlrf0BunBW
 UJU=
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="90945691"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Oct 2020 09:59:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 21 Oct 2020 09:59:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 21 Oct 2020 09:59:12 -0700
Date:   Wed, 21 Oct 2020 18:59:11 +0200
From:   "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandru Marginean" <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "Mingkai Hu" <mingkai.hu@nxp.com>
Subject: Re: [PATCH v1 net-next 2/5] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Message-ID: <20201021165911.7aj4ksqqj4cof2tb@soft-dev16>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
 <20201020072321.36921-3-xiaoliang.yang_1@nxp.com>
 <20201020232713.vyu3afhnhicf6xn2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201020232713.vyu3afhnhicf6xn2@skbuf>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/20/2020 23:27, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Oct 20, 2020 at 03:23:18PM +0800, Xiaoliang Yang wrote:
> > VSC9959 supports Per-Stream Filtering and Policing(PSFP), which is
> > processing after VCAP blocks. We set this block on chain 30000 and
> > set vcap IS2 chain to goto PSFP chain if hardware support.
> >
> > An example set is:
> >       > tc filter add dev swp0 ingress chain 21000 flower
> >               skip_sw action goto chain 30000
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
> 
> I will defer to Microchip people whether 30000 is a good chain number
> for TSN offloads. Do you have other ingress VCAPs that you would like to
> number 30000?

We see no problems with using ingress chain 30000 for PSFP.
-- 
Joergen Andreasen, Microchip
