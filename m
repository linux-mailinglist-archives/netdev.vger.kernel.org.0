Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B3135FF8
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388397AbgAISE5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 13:04:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:11162 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgAISE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 13:04:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 10:04:56 -0800
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223407819"
Received: from unknown (HELO localhost) ([10.24.12.101])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 10:04:56 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BN8PR12MB32663AE71CBF7CF0258C86D7D3390@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan> <87lfr9axm8.fsf@linux.intel.com> <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com> <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com> <BN8PR12MB32663AE71CBF7CF0258C86D7D3390@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Andre Guedes <andre.guedes@linux.intel.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Po Liu <po.liu@nxp.com>,
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
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Message-ID: <157859309589.47157.8012794523971663624@aguedesl-mac01.local>
User-Agent: alot/0.8.1
Date:   Thu, 09 Jan 2020 10:04:55 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

Quoting Jose Abreu (2020-01-09 00:59:24)
> From: Andre Guedes <andre.guedes@linux.intel.com>
> Date: Jan/09/2020, 01:07:37 (UTC+00:00)
> 
> > After reading all this great discussion and revisiting the 802.1Q and 802.3br
> > specs, I'm now leaning towards to not coupling Frame Preemption support under
> > taprio qdisc. Besides what have been discussed, Annex S.2 from 802.1Q-2018
> > foresees FP without EST so it makes me feel like we should keep them separate.
> 
> I agree that EST and FP can be used individually. But how can you 
> specify the hold and release commands for gates without changing taprio qdisc user space API ?

The 'hold' and 'release' are operations from the GCL, which is part of EST. So
they should still be specified via taprio. No changing in the user space API is
required since these operations are already supported in taprio API. What is
missing today is just the 'tc' side of it, which you already have a patch for
it.

> > Regarding the FP configuration knobs, the following seems reasonable to me:
> >     * Enable/disable FP feature
> >     * Preemptable queue mapping
> >     * Fragment size multiplier
> > 
> > I'm not sure about the knob 'timers (hold/release)' described in the quotes
> > above. I couldn't find a match in the specs. If it refers to 'holdAdvance' and
> > 'releaseAdvance' parameters described in 802.1Q-2018, I believe they are not
> > configurable. Do we know any hardware where they are configurable?
> 
> Synopsys' HW supports reconfiguring these parameters. They are, however, 
> fixed independently of Queues. i.e. all queues will have same holdAdvance / releaseAdvance.

Good to know. Is the datasheet publicly available? If so, could you please
point me to it?  I'd like to learn more about the FP knobs provided by
different HW.

Regards,

Andre
