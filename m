Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE24368A03
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbhDWAqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:46:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:13059 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhDWAqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 20:46:06 -0400
IronPort-SDR: ol5LhqLsoIjQutXzcNMvgrNgDri1HvYM/VOgOMxf84Y5YDc/zcSE/Rpf8xoUCONPNbDQDkddTI
 xRVWtuH9D2bg==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="257303786"
X-IronPort-AV: E=Sophos;i="5.82,244,1613462400"; 
   d="scan'208";a="257303786"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 17:45:30 -0700
IronPort-SDR: RxXBExsZcfU3Zr77VtIpFyad6Rm7byUVx82gEhh76rDNEwdEpzpc0O7scqo+5FyA42Pm4ZQVsp
 fja4LP0XKdAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,244,1613462400"; 
   d="scan'208";a="535389455"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 17:45:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 17:45:29 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 17:45:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 22 Apr 2021 17:45:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 22 Apr 2021 17:45:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGn5dMnCVUuOIvuTb5OtHTV4TsyVPuopO517X2YX4j1FetRhezOqscxDRN/9YeXfwPwYKDHB8N1XuNrlLJtV2Hw4uZpwtgqiFxeRRSTO5ctsntGty12sohdJQy13gBQ1/OHnhi0JbiJ+7nRdvbnsdOw7xhj8w2JLfXGeSlKnnyuIzgxEKiypP371G00BkstgQWZdpiOk054/wgy1DamP1+1+m8ngdP6m/ewn7MVDrAYrjnxBclYFFLGJn+LXsy0WuJxH/qQBPpUqPCVN/2HFzW6YuCIL/vv9TAAjFF9n1CV+C9TnTqnhS+t+r9DsLAV4j55kBULGOQbloIxUyRaP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fw6p60hGp/V3ytoyJOPSOcI+hL/lF+61mrhG8kBSwE=;
 b=ZzqqTE86xpO1BcUMYkMjzY1R3EiRg+hGsmxi/0FabGIzsYk7eBoItghJ1ATdb1fnm5+s4EV4ddriiva6cP8J+OW6GJaahWL3UKRmzCkqCKkhlyVZmPwi84BhK+d9pEYbr4ysjCj+pX6/r8AocS/DGRoRWaPi3J/XtbnWPqjZpji7ZufkzjBZILxH1wMcKxlgpzJBGXV46nwZDAO67D7tGj23EIh0AOp/6fBum6aeJh0lnW8fQ9h5QCTrsO1i/1yBCjTUDfhzJA8/MS+yt+4aX+fLzvziQavk7KshkIQ8JebSXh03Zpj9Z4g0iKl6cWN04tx3FGbCN74IR/+VT7pv7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fw6p60hGp/V3ytoyJOPSOcI+hL/lF+61mrhG8kBSwE=;
 b=hfSw70y9AOgHsgjBj0VN7T5WYQrll9igUsi0K7I/Y9jSBTeaP/UYtP+AupWNphqNCVD77VjmMGG2BQP0i14Lc8T6xY0xor5alEc6zbUpUbIMGp2Jm6n5OClD8BhhAigBOvYU9W3PSSANJyDnRgXyTsTs0fy+5/iPGNPgFOiZ95s=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR1101MB2142.namprd11.prod.outlook.com (2603:10b6:301:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Fri, 23 Apr
 2021 00:45:26 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad%5]) with mapi id 15.20.4065.020; Fri, 23 Apr 2021
 00:45:26 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Thread-Topic: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Thread-Index: AQHXN8w75Vo0bmfsFEyfZYnEbB76e6rBNbyAgAAK1lA=
Date:   Fri, 23 Apr 2021 00:45:25 +0000
Message-ID: <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
In-Reply-To: <20210422235317.erltirtrxnva5o2d@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.200.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23bb684c-3eae-460a-9ded-08d905f115d9
x-ms-traffictypediagnostic: MWHPR1101MB2142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB21429BE48E64E92515D784FED5459@MWHPR1101MB2142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AxIeJATYcPujGW+NaT6s36FKcvRJNetSytY+tRe+KyECuxCEedekFppWzCiD6R4y4Cy2F6t3vllK1HN9hP9Y+OPaYHIFjPPTvII86Pio6FQ5F3GPOJo/jZsm7nyEh5oYRzo1e7uF3fTpVbnr08ILz78DIlCaCf2WrvK+NR3o6FqAq0IOzi35LYF9RAJ92RYDBc6Az/pvSRT0ARUsc2TqTJn8YFM6Ppf3Rfvf+7ENfL/ttP04s5VCiVzQlhrl2AP1ImkdCduZLGqSN3z/N9JGGnN5NbtIAewiT+P0ufHp1t5yZVhlJz55btqzYRdVCMiJEQ3vgd3lI6HjtWh2T0AY7TgmchidmavwHek43vu5H5yXwJ2j8joXoMRUsXckXcxL5dgS0BK+GLwc9clsTn8k7Io4n/MQojvuDoCzfacZbzqX1Gi2q5FREz4hPLY1caNIeOiO0GmcO8Hdd3nByRJ7WmUEb+Krm4AdzmTRcjavV0EooqJWow2mCGOzuZ0/6uMUorhqtAGoJpNKpmzKbCznOL+CLGlxuq7Z4Q+fVrmwOYz40wpDihINCWegukIgPysFqrdY96Eq+XHWGgvkxYH9V6zw/tdR24nh1E5Fieg1ZLg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(9686003)(66946007)(76116006)(53546011)(316002)(52536014)(8936002)(71200400001)(33656002)(83380400001)(6506007)(66556008)(26005)(4326008)(8676002)(2906002)(7416002)(38100700002)(55016002)(122000001)(7696005)(5660300002)(6916009)(86362001)(54906003)(478600001)(186003)(64756008)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9ITlgXRtk7uVxj4EPLtbpSsYZeRqfetiniYBjPXqmaxUuRj8n+KjP6nCLGPI?=
 =?us-ascii?Q?m0edVFhFZzNwTWKTeQwGbOV8/Tj+dDyMFW2aONmPX01jtxx1tj7Cjnjmn5iI?=
 =?us-ascii?Q?Ltt6la14kRKwN8zOKCVZ/03rYHfKbxyhUBRBKpT6p3yN/nKMa5A4emYTjQjp?=
 =?us-ascii?Q?i38LZE1nY8awnpAS7fGcOdcySNgvsxZMTOL8qpIHBfFnnAL8YzGnildmwFB5?=
 =?us-ascii?Q?3bh8C23kITyHAR55cND1D84SYYNfsjTcdPq8IdbMs5zFF6SwXpDWPlL+dC24?=
 =?us-ascii?Q?lPL5QvqcOWv2FpI62wqnBXLF4DccWzpn8VQjWKJ3R8B8v81NZUqmFrkvzZtO?=
 =?us-ascii?Q?BApc2z1Ezok4LVUhJu9bHcERz16ynKhgwte5nCPTczljCrdGpIVdg8Da5hzx?=
 =?us-ascii?Q?yklQxhO5t6RhQ3BJ0TlDCyczBZZ2/PcE/ODhqEH7Ajz0Zt51P/kT3jmezI0V?=
 =?us-ascii?Q?jWsd5UG7UGxst/FoZgCYfV+tE+9UfUQmHn03GgO7VPZZUZCavQbW/vUvJo5s?=
 =?us-ascii?Q?xE3jR7eEIck8G4MXPf32NlOFV/42e6eboqlavJVW7brtzsdEiCPuzEH/FEcS?=
 =?us-ascii?Q?HTBgKfOJNeyY3PDwCplZvPt/poHEaKAxkCMOuPaz6o7c7qO3ypcye92iLiOp?=
 =?us-ascii?Q?6dMKJFgXXwJN+cdViRpuDsI0LNnkfgE5Xlic+cUWfT91pXy+3SmwJURqttnl?=
 =?us-ascii?Q?JdT3daBZL1o9FMUvmxx963c+7zfnVArs8y3Zk52lkR4p8Hz22bXYP7DruJBz?=
 =?us-ascii?Q?os98DFcQOb9r1HZVTAjt3FQOdxN4S2GlEKB1GfjEpBxrYuc5TPjy0N5+QWqQ?=
 =?us-ascii?Q?UIItrLUBHW7smuoM0j69t5bSnxpOa1oDIZ0LNB0sh0ObID6P7IyhlvDyL7MM?=
 =?us-ascii?Q?ARx3Ax/aGmhK1gStT3oS+GK5l3rzr2bZ5a42w9EXaMujIHn+1J4k1JVVoqTl?=
 =?us-ascii?Q?K6LGy5vZn2odQyYknE806J7OeXNpAo2Zh1juWatSocvwj0HSvTAc3T9Zovif?=
 =?us-ascii?Q?80JwgpjIXIOMAnwWte0kw1Xb3jXKh2XgMBuuLtdF+so776joeLmz6ZqEvdcE?=
 =?us-ascii?Q?rJRD2eSqdq2weLR7oYqnwUX4sIA3O3n/Fh3lz/nw0gh5gP6DGhI5qzKjH539?=
 =?us-ascii?Q?f/f3j1Tk63BmJoaH/IfbNeHQrRkTrzuu6UM0GFLTQPAmHePE021NtAUPrS2I?=
 =?us-ascii?Q?p4Pq9viuv7f+lvnviaWxi85CCYaf/0Nrx2m/rCjaMoJ48M2ZPVL8Rc6TpG4r?=
 =?us-ascii?Q?t0CSHLJPkqlNdPwNwa6Cp/UDSuhY3rhGgDgjkAvKHAgEQsXooFZxHdtUTwsT?=
 =?us-ascii?Q?DpeWRJrOG+JyfVyZC6TtXuLZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bb684c-3eae-460a-9ded-08d905f115d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 00:45:26.0162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+t3BJ4xrzGyC36dcgr/3dNzldMLH9GqETbJsURYhnhldBOY89kIzNSyhopj5/Ap5p2GnlCw6ZpMY201PK8uJ5RYHKx3qFsUYd3A2yYhOhyAInVLHKH6pPO9DwzX1Skd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2142
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Friday, April 23, 2021 7:53 AM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Ong, Boon
> Leong <boon.leong.ong@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Wong, Vee Khee <vee.khee.wong@intel.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
> 10/100Mbps
>=20
> Hi Mohammad,
>=20
> On Fri, Apr 23, 2021 at 07:06:45AM +0800, mohammad.athari.ismail@intel.co=
m
> wrote:
> > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> >
> > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet for
> > 10/100Mbps by default. This setting doesn`t impact pre-emption
> > capability for other speeds.
> >
> > Signed-off-by: Mohammad Athari Bin Ismail
> > <mohammad.athari.ismail@intel.com>
> > ---
>=20
> What is a "pre-emption packet"?

In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used to differe=
ntiate between MAC Frame packet, Express Packet, Non-fragmented Normal Fram=
e Packet, First Fragment of Preemptable Packet, Intermediate Fragment of Pr=
eemptable Packet and Last Fragment of Preemptable Packet.=20

This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare Cores Ethe=
rnet PCS Databook is to allow the IP to properly receive/transmit pre-empti=
on packets in SGMII 10M/100M Modes.

Thanks.
