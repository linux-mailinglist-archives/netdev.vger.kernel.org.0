Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6D104929
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfKUDU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:20:58 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:23927
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbfKUDUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 22:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUJuBM8BYB6Mu3XI/WUBLp7D9qyjt8S3IuiwPDUcfSiotcTwJZhwLJUzse0i2eLWaiIaXCJA+JnA1mm7qjKWbkneL+7ncrvw+2a0Ee4h9oYIADVTJkkcugtpL7U0O76DQ+49kACud4PkzvBHK1QkuY7w0wx3g8P8W0HaAW9cgBJQSFUecblfr1Wpi/yNHM2wa+PDceJUQy3m+rn7LXamKgStiy051m8fbWWD64MQGZV6syuw7RQZ8KE5EKmcIFF3BtcG822F/ZSRzMiUVUJSqmaKfBrsp9z7RhoaoOWN3bpYQejwRn3koNuZFTM2Y4hVVpEzmnI/rcdJG1DPZoOa7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx+xw5D7jcLNgdJaElcbjtQFbpXOw+kYzWpiVcfndig=;
 b=EdRrp9E8UhI0wXQwjSWYOh3IwyOZ0pcHnIhRCi8NMqKXXUSrLFSj7ImCbGlUkTyO0R5FVSCod/f7xxQMpmzk2acZdPX42Ep2gkjUodoAxPDlbnrTA/EWyW449wGZAbUG6Ta+w5C3LIa2lIvvdiB2+1A2WfObUk3fm7sjOLyCCFcwTKo4uQVn+d+Gsd2u0W2/oZi0ZG7P8ojvYoRifbAKcvqutEIFVmKNQLASCgC4MdIAa0OCsiZWQQSTi1PSNcTtLN3LNI4u0V+RnlvX3X0zILKuoRYvDisFMTPJfyy2T+NY2lGS2XftGozt8zfu8y4o6ZguBcPJFw/OCOlh0x4OGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx+xw5D7jcLNgdJaElcbjtQFbpXOw+kYzWpiVcfndig=;
 b=aLCkKRRLRuP/UUUE7gopDcmGKHFPRWEOl2WuZHhnrDG5z+KhBmneqfbCHJ2tdiXG5mSxzQUi4UjjX9VPJ1rNIdEEZereJMKF63m4gfhe1Vt/bi3jIUhlctXY8cxVN7g0Ns8Q63fIM68dQqx+Dss+Q9T4F6AeGzzDZr83ZQzpYPk=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2239.eurprd04.prod.outlook.com (10.169.137.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Thu, 21 Nov 2019 03:20:52 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2d81:2d60:747c:d0ad]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2d81:2d60:747c:d0ad%3]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 03:20:52 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH 4/5] net: dsa: ocelot: define PTP registers for
 felix_vsc9959
Thread-Topic: [PATCH 4/5] net: dsa: ocelot: define PTP registers for
 felix_vsc9959
Thread-Index: AQHVn3vSY/KsOZonWkm2r/FvazO1Z6eU7Z0AgAAHawA=
Date:   Thu, 21 Nov 2019 03:20:52 +0000
Message-ID: <VI1PR0401MB2237B04F05439429F3D66D44F84E0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-5-yangbo.lu@nxp.com> <20191121024928.GN18325@lunn.ch>
In-Reply-To: <20191121024928.GN18325@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 499f0ae1-b349-4b40-31a9-08d76e31d046
x-ms-traffictypediagnostic: VI1PR0401MB2239:|VI1PR0401MB2239:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB223981D6C7CDAD4E1D5F5EBCF84E0@VI1PR0401MB2239.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(189003)(199004)(13464003)(476003)(102836004)(66476007)(316002)(99286004)(53546011)(76176011)(52536014)(8936002)(6506007)(14454004)(2906002)(66446008)(7696005)(6436002)(446003)(66556008)(54906003)(64756008)(478600001)(66946007)(66066001)(11346002)(55016002)(5660300002)(486006)(76116006)(71190400001)(33656002)(71200400001)(7736002)(186003)(305945005)(6916009)(8676002)(25786009)(81156014)(9686003)(4326008)(26005)(74316002)(256004)(229853002)(86362001)(6246003)(81166006)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2239;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ob81FPXXNge1lCYfYcnEt7kIaLiIfahFzR/gQBdXT4RV7SeL1KaJiDZppJvnl7vAGRS1ZrzwNG2h22NWdT2ZgX4I++7Oq7UpqiIgoKeFhIniTnm7bao+IZzP/UN69UE2ttyEe4yIlKuTIQx6euNdrkNV1FvvzDDPRV32z3QxIcC0LxXAwNBriha2+E0MSKFPhDVjMj5NMt9KLuW4Em4IsYqxRruRE1aNeHrATPEjU3OzxAE5SLYgRiAlfC7ezVwAVBMOP7CQkUsbNEnKTDYpsd4mU8SAGoMKdMmTOV4fOgO1jHkLonv9xCLi+b0KCxAq1XutlGu0vp/c4cp1J7geOJCxwQ+al0z8NQc132FZaghL/sjreuEDDKz8+q9bWyJZjLGRN5c1aZJIHWnl2YxY9GXho/OalwuEew3DnbPNvaEf3Jf68m13GziKeyFGt3xE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499f0ae1-b349-4b40-31a9-08d76e31d046
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 03:20:52.1379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: weus83DnHkL4MnY9HB6blV4vyr8OLsCQ8k3vkVuQltYJwccV9trWpOtPP2r7/m9kuzU9B+m7O+uk9oZs4lG4ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2239
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, November 21, 2019 10:49 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; Microchip Linux Driver Support
> <UNGLinuxDriver@microchip.com>; David S . Miller <davem@davemloft.net>;
> Vladimir Oltean <vladimir.oltean@nxp.com>; Claudiu Manoil
> <claudiu.manoil@nxp.com>; Vivien Didelot <vivien.didelot@gmail.com>;
> Florian Fainelli <f.fainelli@gmail.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH 4/5] net: dsa: ocelot: define PTP registers for
> felix_vsc9959
>=20
> > +static const u32 vsc9959_ptp_regmap[] =3D {
> > +	REG(PTP_PIN_CFG,                   0x000000),
> > +	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> > +	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> > +	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> > +	REG(PTP_CFG_MISC,                  0x0000a0),
> > +	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> > +	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> > +};
> > +
>=20
> > +	[PTP] =3D {
> > +		.start	=3D 0x0090000,
> > +		.end	=3D 0x00900cb,
> > +		.name	=3D "ptp",
> > +	},
>=20
> Seems like an odd end value. Is the last word used for something else?
>=20
> Also, the last regmap register you defined is 0xa8. So could end actually=
 be
> 900ab?

[Y.b. Lu] The PTP registers range is from 0x0090000 to 0x00900cb according =
to reference manual.
The patch has only defined the registers which ocelot driver is using now, =
not all registers in vsc9959_ptp_regmap.

In the future, as new features will be added, I think more registers will b=
e added to use.
Thanks.
>=20
> 	 Andrew
