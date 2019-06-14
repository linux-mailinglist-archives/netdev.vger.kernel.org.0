Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CEC45FF3
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfFNOEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:04:02 -0400
Received: from mail-eopbgr140049.outbound.protection.outlook.com ([40.107.14.49]:3298
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727123AbfFNOEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 10:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukf44bf1XqoVm87/MIRIEZkT2f5rQCHTO9iIw8Qc2Ro=;
 b=PEL5kBKM5zeyAeW2pNHIePoFwOnojuJJ4b5SbKjv/TZncAq+CPNK45soE7IpxVYgMUYlVyeIpvsEZoQmyAGQ1CXE1e8/qx8YSq9mvF2W2Ccow+CSotOeIDD0GvuptvV4IeHN8iWvHOfdStgJ9zrTgfEj1cqBlQekbkUj/1STN8Q=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3712.eurprd04.prod.outlook.com (52.134.15.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 14:03:59 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 14:03:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Valentin-catalin Neacsu <valentin-catalin.neacsu@nxp.com>
Subject: RE: [PATCH RFC 2/6] dpaa2-eth: add support for new link state APIs
Thread-Topic: [PATCH RFC 2/6] dpaa2-eth: add support for new link state APIs
Thread-Index: AQHVIkOh3KM7qC7o8E2+6896w0vbWKaaVMwAgADDs5A=
Date:   Fri, 14 Jun 2019 14:03:59 +0000
Message-ID: <VI1PR0402MB2800CB7ABB8DE4472A80D586E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-3-git-send-email-ioana.ciornei@nxp.com>
 <20190614010114.GB28822@lunn.ch>
In-Reply-To: <20190614010114.GB28822@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cc0f044-af00-41d2-f49e-08d6f0d12600
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3712;
x-ms-traffictypediagnostic: VI1PR0402MB3712:
x-microsoft-antispam-prvs: <VI1PR0402MB371206DF0EAD8702CAAC4E1EE0EE0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(52314003)(74316002)(71190400001)(54906003)(4326008)(2906002)(229853002)(76116006)(73956011)(6116002)(3846002)(446003)(476003)(25786009)(14454004)(478600001)(6246003)(6436002)(71200400001)(11346002)(86362001)(6916009)(316002)(76176011)(52536014)(33656002)(66066001)(6506007)(99286004)(53936002)(7696005)(68736007)(81166006)(44832011)(8936002)(26005)(66446008)(66476007)(64756008)(81156014)(66556008)(8676002)(9686003)(66946007)(55016002)(486006)(102836004)(5660300002)(186003)(14444005)(305945005)(256004)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3712;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4XPjy4cGiMXzKDv1D8zqszMetwJCBoMV1ui01iIpjWJH38PSR6Cmiu3soikudlPJygCTmb1T70DG0sjOveQb3y3pXdTo3ojbJ88it8EkzGgbOpT5XO6TtLuCZySvRZ5TM+WxvoL/GZFRNLHNCoRUwHbRp0v/7YdfeGDcrmeFkwCDwmquc9e6xmSWfCM5s6G3Xleu2e8h9YCzpO5Ktl4T2pnWdrXqCh5BYxvLWACPQZMlijHr7gDT4EH60H9GaQ/JZMqhfyTIoSA3Op8t1VmfL+mr1d+Eq320ZKGrxm6Ii4PAOviQ7KOlx+YS3C8oZbSNpUPRtvLwKlS+9Vz1BqOso6DTBlT+cLDZg3EG8kKQSgazGbQOPUz6cnWWsYIKgN5LlMeX9meLXbZ9ew0mz5sgqOxXod3Hj7Hl4uVZPIetbXI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc0f044-af00-41d2-f49e-08d6f0d12600
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 14:03:59.4780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC 2/6] dpaa2-eth: add support for new link state AP=
Is
>=20
> >  /**
> > + * Advertised link speeds
> > + */
> > +#define DPNI_ADVERTISED_10BASET_FULL           BIT_ULL(0)
> > +#define DPNI_ADVERTISED_100BASET_FULL          BIT_ULL(1)
> > +#define DPNI_ADVERTISED_1000BASET_FULL         BIT_ULL(2)
> > +#define DPNI_ADVERTISED_10000BASET_FULL        BIT_ULL(4)
>=20
> So 10 Half and 100Half are not supported by the PHYs you use?  What happe=
ns if
> somebody does connect a PHY which supports these speeds? Do you need to
> change the firmware? I suppose you do anyway, since it is the firmware wh=
ich is
> driving the PHY.

First of all, if the firmware had access to the open-source PHY driver code=
, the design wouldn't have been like this. But as it is, the DPMAC object/d=
river is used squarely as a way to gather this information from the PHY lib=
rary.

Half duplex modes are not supported in our MAC. This is why the firmware do=
es not export any advertisement bits for these modes.
If somebody connects a PHY which supports 10 Half and 100Half modes, the in=
tersection of the MAC capabilities and the PHY one's will be only the Full =
duplex modes.

>=20
> >  struct dpni_link_state {
> >  	u32	rate;
> >  	u64	options;
> > +	u64	supported;
> > +	u64	advertising;
> >  	int	up;
> > +	int	state_valid;
> >  };
>=20
> Does the firmware report Pause? Asym Pause? EEE? Is this part of options?=
 Can
> you control the advertisement of these options?

The firmware knows about conveying the pause and asym pause configuration f=
rom/to the mac driver.

EEE is not a feature supported by our MAC so there is no configuration knob=
 for this.

--
Ioana

>=20
>      Andrew
