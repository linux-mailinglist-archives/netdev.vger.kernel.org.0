Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A13369C62
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbhDWWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 18:04:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:25665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232429AbhDWWEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 18:04:41 -0400
IronPort-SDR: T09eh/B26D2waHB2hFfhQRWrSL0IisKvwDwqWFao2aV3CexPOvcpHPfz9kbLfjBRZ45xUOd1/u
 eK5lX1WtnBdw==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="281466192"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="281466192"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 15:04:01 -0700
IronPort-SDR: Rd8rbBj41QlgCAjE6WWLxorMGiSv/EMASm3WL1f/0BUYG+IWaUpfSkwRD3JQ2QM57beq0HpL3h
 NbdHQ9dGl20w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="424371105"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 23 Apr 2021 15:04:00 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 23 Apr 2021 15:04:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 23 Apr 2021 15:03:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 23 Apr 2021 15:03:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 23 Apr 2021 15:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIxII1IYTHYO7GamffMeQRqAZ8hQGfIdh0zBTt2Z/lA5GFOxDaYAT/c9gkcm9LArBaFv+rHagqjx4KlT85Mimiy3hu4iH3FegxJgsTjPnCZBWbSHpAw6fq8ypFfuou7UHPebr9ofYF52+CXk82n38sjqiSCMtNojmz22cEjj7vpkhDoxIbfxxNiwEaCfLqe8n2idtWl5QTJj5TA8XpcNNFUbJRp9w3YI4EcI3ayyczKazVHh4BTZyRjHf70Jtn2Elg5/Q5m0239LCRh/kxK6mNmX4D+WRbrSgnUmqhCielc05NJWL40l9N8z2rjUJdye8eYOXiqQebN2AVj/0ziDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yd2NdfGAn8JqwZyX9SoXDwqUhXegldKx5D9HNg4Bu60=;
 b=YTQBdK6w27SpT61gniRm6rHUaL2tFPFx9l5OE4AVi20FEpvu/ZGJRCa+awzPAMtphvw5R42ksrtOY12ZuKaNfbgfDb0EE+3Z6F3sU0hET9k2w5lg5TARu2bsUlksuz0tS751/4deJL3v6e/m4l9sH3Rije50KnaRe7NJrWNfq+f79Ji2HBT8pATYsKu0zANuqAJWO6qIE1LT4zJCpnS9ylSkiteAQ/WmhpI1CaMF3DOnFVi6KF6ezpx15F92YH0Tn1SbF4dV7S3+ZrYBiFm2SeMtPMpo53vTPb4AefnyvmBChP+GL+KoN9L9qex0W7VOocl2nklbTiDQMMS4gC5tRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yd2NdfGAn8JqwZyX9SoXDwqUhXegldKx5D9HNg4Bu60=;
 b=JHy/EQ2vVFaRoBJNaGXC/Bx0gSq7bETqHSf8hRsH5LHH6VhkmCp4X3rwI+3PQenTv8MzM0g5/KEFchgUhJ5VspxzalWlCOTATUKlpbOI77QIfFSm0HnF9YNXTFZPbt1HYLIrvmcmQvcfsXw/l0vT6yV1H+H26+cTiV9JzruN2+A=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR1101MB2320.namprd11.prod.outlook.com (2603:10b6:301:53::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 22:03:58 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c19:a154:82ac:30ad%5]) with mapi id 15.20.4065.024; Fri, 23 Apr 2021
 22:03:58 +0000
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
Thread-Index: AQHXN8w75Vo0bmfsFEyfZYnEbB76e6rBNbyAgAAK1lCAAAXiAIAAkBXggACSDYCAAD4QMA==
Date:   Fri, 23 Apr 2021 22:03:58 +0000
Message-ID: <CO1PR11MB4771248BAF7FF5EF4331F688D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
 <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423005308.wnhpxryw6emgohaa@skbuf>
 <CO1PR11MB47716991AAEA525773FEAFC8D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423181133.cl5ooguhdm5rfbch@skbuf>
In-Reply-To: <20210423181133.cl5ooguhdm5rfbch@skbuf>
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
x-ms-office365-filtering-correlation-id: 5ddb435f-c107-449f-166d-08d906a3b226
x-ms-traffictypediagnostic: MWHPR1101MB2320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2320839A70E886A8ACC19777D5459@MWHPR1101MB2320.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dcByOoH2AE7V9SorrmwevdibXLruPFqeUurV4UMFsVSwXf+hADescm1TTyghAdWGRiqGDAbwoQHXJyAtwzV/NKMV674XLK6Swk2nVreVQTc3ptUqRIQvzAIcxYdgyAVe3LFTvPhrps/OHnQYK2ytGYPJ8atTrZKwFK5NJb5htdjEusecBpaKMt2YGyISIxDbWMF9ESqW1HDcc35ULxMyB9LqYySPsnByhjk8YRuMot19NjW0TfgyMbfEXyZNLYHYSAZFpO6ZQyzcWdBYzFKI7chDoxqBsYddkc+WBBsuG9fsQCZI4dBNaRbPn64FNhHL2Uc4NwG6Bjvv6JZ55W19i9ZcPvtMgoBpRT3YvzlK6+pEcEWRraxRDhcKHC4V3gobAtQXdPAem3HdtFAkiHNrrx62Ft6Bcw5UXN/r/lY3B9v40MGVAO1J7/Zgg1FOKEsmKTuKUq1aZvu9wqC0s2A5li0LkRADZ0vpjV4mNnuEDrvnsfCCZwISDKymG/VEWwkK3YJT8eMUD6Pap1YUVxu3gI2mvqd7qDeMhWvhByMqNIMw8UZhDpc3lQHEuUyVxB4IXH4gmMcwvSOHX+p1CaOhJ/qky+kK2SWB0Z2tH/dDmwE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(478600001)(66446008)(76116006)(9686003)(66946007)(86362001)(64756008)(83380400001)(66556008)(38100700002)(66476007)(71200400001)(122000001)(33656002)(55016002)(52536014)(7416002)(53546011)(316002)(54906003)(8936002)(5660300002)(8676002)(6916009)(26005)(186003)(7696005)(4326008)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E8KLtZjEXcpbgJX3xcxgWYntCJ/owbQOSvXPBhRwL4MWnXdsYb3AJ4DBWQ5O?=
 =?us-ascii?Q?KQXr3EGrn3mboiPOCbxJkcg1QN3R0BRAPBviWLylcD+FQ+aefg90TyBw9c7U?=
 =?us-ascii?Q?Qys6W048ngdu0i9OkGnCaXm495T8h0EjIeZSJCmYEPC+kSRWqqRogChgFKh9?=
 =?us-ascii?Q?IVrJSKqjcbgQEmXzxZd5XID/eTOvSMDR+oORksiIEEAW7Ql4M6Zb1JtMW1l2?=
 =?us-ascii?Q?VsHnuQVBPqGIkAUjfvSMI02quIHfCuWxesycNrvr+FIyXsLrI2EIOmr23ZiH?=
 =?us-ascii?Q?irdeUtNpQ9l1hSruwpXcK8ZZ69F1NDMqVHr1JWIeUa/yjcU7mpK/G3gYrnmu?=
 =?us-ascii?Q?QcP1/J7x0FjlympgyGkBqzEv3T2vTxh+iwtm7ZkgrW7UgZrsf7CfzG95cQab?=
 =?us-ascii?Q?FJmxYvbJVD6/okpeKIxNaDHlKiucquxeEkOMA9yR4197a6CTvKm2CtUI7BHB?=
 =?us-ascii?Q?rDdm6zd7CBXDE6UYy3Jq1+86fkWC7VYjVBLfJfdf43afnTbeJ9wESYXpg2LT?=
 =?us-ascii?Q?eK6zJUse0i6wZSm9B1mj1GzH/U2JzbziERWUabZZ8gsqDxKaiwW9kLFB5eZI?=
 =?us-ascii?Q?2QjdIhEdykCfFh/WHYUWtOS39IaFSZu8mo2kt6aj6faaEsMJ2M5q6CaSZd6U?=
 =?us-ascii?Q?75z7e2Toa9i+eENdDx0/EAq6+l0kKT65+IXy1f3pdipOIpcDp++IJIk7DYgs?=
 =?us-ascii?Q?KwP5INmmZQWP3e6wiFYvMvTWoUIpI8mgq4dCLMzsRsCTuFt6cMMahE1Nk5j5?=
 =?us-ascii?Q?PYwLnTE6zeFD1UKIrdkIYtu68PQzM9N0zxatAJx8uzxWh+HRF/FDad1bDzPp?=
 =?us-ascii?Q?NRl0giTckcC9AUznPOF1JPveFuFDWH7eXnit3EgigoY6X91tA//qkYvdN3j5?=
 =?us-ascii?Q?cIhvSzEkvT/tehkWkmcABVmeyG4pOhurMKggW4yeWJCvz8yJc/XGDNDkn0T0?=
 =?us-ascii?Q?oRxYrlb8ErGTIUP7lBOmeXk2tP/DD407A3xoNdn5oKjGFvZ3ldAEHJoAzalN?=
 =?us-ascii?Q?Uhh1FDbU2+NlrIh2PQfXMPc96zwa+6VyhJdrq2kL+GaARGGfdvCxmlQaAA6S?=
 =?us-ascii?Q?pRVAHFFWhg8XYx1sgdMgRBQMQDcsdhYmgMsx6UO5YBldC1ERXOSttUlQrOIy?=
 =?us-ascii?Q?J/kKXQAb79ZROKG2z5oj8xVWMjhAznH9TRKiTXZYsCnq+9v4K23DnXjjLksZ?=
 =?us-ascii?Q?x6iRds8bDQts/pp/KluC5+eQcvPAfKiL1SiQ7kHD43IEA2tMNzfr95r0tGwJ?=
 =?us-ascii?Q?vXZXnKx2TQylhkbWJsaaJqz5v6Vy18HicA1bwRa8iShdXE8dfRwU7hcEy6jF?=
 =?us-ascii?Q?rpVtuMrCNWNAZiUFqbsLKTEs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddb435f-c107-449f-166d-08d906a3b226
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 22:03:58.6926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +1CyrQIB/lupHe36LODnyjZEg0pss8i+RjL+0yptuui7eu7L3lfNYMV/5W90McYtKyH/q8OcIoVWlBhZZyX4oMt5X8jSrYCy0j+w+YpKMNy9UYVlOP/rJ0sGw2uyX9+c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2320
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Saturday, April 24, 2021 2:12 AM
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
> On Fri, Apr 23, 2021 at 09:30:07AM +0000, Ismail, Mohammad Athari wrote:
> > Hi Vladimir,
> >
> > > -----Original Message-----
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > Sent: Friday, April 23, 2021 8:53 AM
> > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > > Jakub Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > > Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > > <linux@armlinux.org.uk>; Ong, Boon Leong <boon.leong.ong@intel.com>;
> > > Voon, Weifeng <weifeng.voon@intel.com>; Wong, Vee Khee
> > > <vee.khee.wong@intel.com>; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet
> > > for 10/100Mbps
> > >
> > > On Fri, Apr 23, 2021 at 12:45:25AM +0000, Ismail, Mohammad Athari wro=
te:
> > > > Hi Vladimir,
> > > >
> > > > > -----Original Message-----
> > > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > > Sent: Friday, April 23, 2021 7:53 AM
> > > > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > > > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > > > > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > > > > Jakub Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > > > > Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > > > > <linux@armlinux.org.uk>; Ong, Boon Leong
> > > > > <boon.leong.ong@intel.com>; Voon, Weifeng
> > > > > <weifeng.voon@intel.com>; Wong, Vee Khee
> > > > > <vee.khee.wong@intel.com>; netdev@vger.kernel.org;
> > > > > linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption
> > > > > packet for 10/100Mbps
> > > > >
> > > > > Hi Mohammad,
> > > > >
> > > > > On Fri, Apr 23, 2021 at 07:06:45AM +0800,
> > > > > mohammad.athari.ismail@intel.com
> > > > > wrote:
> > > > > > From: Mohammad Athari Bin Ismail
> > > > > > <mohammad.athari.ismail@intel.com>
> > > > > >
> > > > > > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption
> > > > > > packet for 10/100Mbps by default. This setting doesn`t impact
> > > > > > pre-emption capability for other speeds.
> > > > > >
> > > > > > Signed-off-by: Mohammad Athari Bin Ismail
> > > > > > <mohammad.athari.ismail@intel.com>
> > > > > > ---
> > > > >
> > > > > What is a "pre-emption packet"?
> > > >
> > > > In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used
> > > > to differentiate between MAC Frame packet, Express Packet,
> > > > Non-fragmented Normal Frame Packet, First Fragment of Preemptable
> > > > Packet, Intermediate Fragment of Preemptable Packet and Last
> > > > Fragment of Preemptable Packet.
> > >
> > > Citation needed, which clause are you referring to?
> >
> > Cited from IEEE802.3-2018 Clause 99.3.
>=20
> Aha, you know that what you just said is not what's in the "MAC Merge sub=
layer"
> clause, right? There is no such thing as "pre-emption packet"
> in the standard, this is a made-up name, maybe preemptable packets, but t=
he
> definition of preemptable packets is not that, hence my question.
>=20

Thank you for the knowledge sharing. My guess, this "pre-emption packet" mi=
ght be referring to "preamble" byte in Ethernet frame.=20

> > >
> > > >
> > > > This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare
> > > > Cores Ethernet PCS Databook is to allow the IP to properly
> > > > receive/transmit pre-emption packets in SGMII 10M/100M Modes.
> > >
> > > Shouldn't everything be handled at the MAC merge sublayer? What
> > > business does the PCS have in frame preemption?
> >
> > There is no further detail explained in the databook w.r.t to
> > VR_MII_DIG_CTRL1 bit-6(PRE_EMP). The only statement it mentions is
> > "This bit should be set to 1 to allow the DWC_xpcs to properly
> > receive/transmit pre-emption packets in SGMII 10M/100M Modes".
>=20
> Correct, I see this too. I asked our hardware design team, and at least o=
n NXP
> LS1028A (no Synopsys PCS), the PCS layer has nothing to do with frame
> preemption, as mentioned.
>=20
> But indeed, I do see this obscure bit in the Digital Control 1 register t=
oo, I've no
> idea what it does. I'll ask around. Odd anyway. If you have to set it, yo=
u have to
> set it, I guess. But it is interesting to see why is it even a configurab=
le bit, why it
> is not enabled by default, what is the drawback of enabling it?!

The databook states that the default value is 0. We don`t see any drawback =
of enabling it. As the databook mentions that, enabling the bit will allow =
SGMII 10/100M to receive/transmit preamble properly, so I think it is recom=
mended to enable it for IP that support SGMII 10/100M speed.

>=20
> > >
> > > Also, I know it's easy to forget, but Vinicius' patch series for
> > > supporting frame preemption via ethtool wasn't accepted yet. How are =
you
> testing this?
> >
> > For stmmac Kernel driver, frame pre-emption capability is already
> > supported. For iproute2 (tc command), we are using custom patch based
> > on Vinicius patch.
>=20
> Don't you want to help contributing the ethtool netlink support to the ma=
inline
> kernel though? :)

We are working with Vinicius to have ethtool support for frame pre-emption.=
=20
