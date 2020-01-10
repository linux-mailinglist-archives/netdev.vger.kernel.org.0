Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A9137837
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgAJU72 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 15:59:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:49938 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgAJU72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 15:59:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 12:59:27 -0800
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208";a="216793425"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.13.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 12:59:26 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+h21hr9ApvPSYigcS0WkFVg0+Od=G+ZVxkV7GvdaNbDmCmiCA@mail.gmail.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan> <87lfr9axm8.fsf@linux.intel.com> <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com> <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com> <CA+h21hr9ApvPSYigcS0WkFVg0+Od=G+ZVxkV7GvdaNbDmCmiCA@mail.gmail.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Message-ID: <157868996635.61655.11306531040262384025@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Fri, 10 Jan 2020 12:59:26 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Quoting Vladimir Oltean (2020-01-10 08:02:45)
> > I'm not sure about the knob 'timers (hold/release)' described in the quotes
> > above. I couldn't find a match in the specs. If it refers to 'holdAdvance' and
> > 'releaseAdvance' parameters described in 802.1Q-2018, I believe they are not
> > configurable. Do we know any hardware where they are configurable?
> >
> 
> On NXP LS1028A, HOLD_ADVANCE is configurable on both ENETC and the
> Felix switch (its default value is 127 bytes). Same as Synopsys, it is
> a global setting and not per queue or per GCL entry.
> RELEASE_ADVANCE is not configurable.
> Regardless, I am not sure if there is any value in configuring this
> knob. Remember that the minimum guard band size still needs to be
> twice as large as the minimum Ethernet frame size.

Not adding this knob now sounds reasonable to me too, but let's consider it in
the design so we can easily add it later, in case we need it.

Regards,

Andre
