Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8244523B510
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 08:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHDGgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 02:36:15 -0400
Received: from mail-eopbgr140073.outbound.protection.outlook.com ([40.107.14.73]:27778
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgHDGgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 02:36:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3OVUlov3Iu8MgVh+PTyOCqrnVTNCqPyNlAhiDtQrdyW1Jepz/gcT3u+CrJxLIpXEsVvYIFLZcFzb2ceSH57ytO9Rhu6yxaJWwUYDrBLqNIqnEPZb70qonb01suu4HCXg5ndfJ7HCF5QLskSwIYMoBq0R3SWopycgBIc07rtJM8KWMeilXhA3ZuwYQdQgCntb/XNgFp0FLBH4Dz/BHxVkv1dMYwmLnoyHTiqYciIDBo4FP8z9pza6J95/X7v18i/P99nw3v1fjYPWafm1qzy0Fx2ODvo/ldN6Hdhqd30I9HGShpnDVn2h+pRifIE2ZoAgNhfRdsuFruzjgAj1tMErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBgRgYhXuWUBpjtbOI0hy7g5HoeulDhj+jpR0lmXINk=;
 b=TG26LZ+SnI85dFeG2ciXb+H/K+2oDp3aGduqTeLzAadaATrMeN2vicDkT+TYsYy89wEIoK1u9lIaT0yBvBhdPlb7UempYDBWbReN6dF+B3NeibU4zdK6EbTjBMOkQN8+fsfkvZLe9KTkDufOdRf4SAdcI5s/F2japZddEIQsJ7MvxQrdN7+M4OywdvQq6oqI8RhiS4K1qIL11QszoZYrIVGqu2CGKeuaE2ZO8CONG6TsUzewrIur5rbAXcK2vzmSdjwnsq8SubRgHBNdLZOHl3ORbshcxNMGNxhp7YnZj/PPmok7IOK0rYq8/jcGQ9YOAU2XD+j0WOJJG2LLQoclgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBgRgYhXuWUBpjtbOI0hy7g5HoeulDhj+jpR0lmXINk=;
 b=b4wVgE0z04+ysZiwJ8cjrwslv65C2RACxHXtdLqjuUn5c0tkhemt1qmHcDvfN6DRUbfOxKiF62SR6VCHn28w/IxH/Sm1LlAT8yw83zPkDoUAJL6fWfsgft0ilVOCGDgtnaVkDfosY8qOXSMprNk9cAEinAhldCkLNy91aWrSmm8=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VE1PR04MB6592.eurprd04.prod.outlook.com (2603:10a6:803:124::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Tue, 4 Aug
 2020 06:36:10 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 06:36:10 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWZltTjJoiQZyRB0ahxfHbav3IXakm9cqAgACG/8A=
Date:   Tue, 4 Aug 2020 06:36:10 +0000
Message-ID: <VI1PR04MB51039B32C580321D99B8DEE8E14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
        <20200730102505.27039-3-hongbo.wang@nxp.com>
 <20200803.145843.2285407129021498421.davem@davemloft.net>
In-Reply-To: <20200803.145843.2285407129021498421.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9dc8e492-3ecf-4291-f3a3-08d83840ad06
x-ms-traffictypediagnostic: VE1PR04MB6592:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB65925EC42434E4E924BA5811E14A0@VE1PR04MB6592.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTukOEO4xRdU7RDvCoDuFCYYbSgRqyg2s4/eFbGWbsdJVyoPcZi+Ub5atCtbPSE/YTbQVTQgSV9yrWh6Z5L5bk5eBwTgjDH66X29GCGMxdMzYwrv3bfuNBDHWx/h19BNtLLmAXMbtLB6NZYT6Hq8CZHsLW2tMr2hz7D4e2I7N3ZYj7BRj39h1B7SMkTNJinCM2oqym/B84hsf0bhih1Mdmbho3H710SzClTZ/sWRZ4n0uYEv4wCgdS3Vo9NGc4TuJTrGpZ++vgIyzHRZGicnQ3iw++ebdI6WTLBy2gfInHK81qNd4xeHAOi2lBG8l4TiFlMWYS/vaJLLHwJIRc1NJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(83380400001)(55016002)(26005)(6506007)(33656002)(5660300002)(7696005)(2906002)(52536014)(6916009)(7416002)(86362001)(9686003)(478600001)(186003)(71200400001)(316002)(66476007)(76116006)(64756008)(66946007)(8936002)(54906003)(8676002)(4326008)(44832011)(66556008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xf+v+lTOY1dCALEwXpyqWT/peRY9rZ88W8zm+JTM1Dgcs98tdrdt9IDsXFEBwRu1/i7/B8ydTOjmhPxepQeWbEessrPQzg5tZtzYTHmMXGce7+ahHBCvdMUpnz33+TUGtQk1c84K55KFAU1Rcasu6yYlFtNyOhmWQ78gyPd4Vh4/+w0dVH4FBZgOhOkb5EcUvVY+vnWYcWfg5VYusGTQjEwyaeehzTbldjksF9YQNLE+BLq+c4U79W8l2gxzMIuG6wwVjMKGBg7NCHSfRFTxCBtdhi9uO0c7MBw14IQGD5M9dnJswl9oKAO+fI/4qKghZoBgtV9/CZKZLP2RMLqLLDETu3H/2k9bJydF0zdAjpZiFCNV+31pkKR4K77UEM1BG+0LVA9988X6OWufP+cXMPNdGQe1+sO8V218DVLrOiKbGQqKovsgIj40umxOOf9NF4Mp9sCrYsMBGoaaEZyyBjrbATykoqNPpLDhVcNuvz8WgAvtLmQ9GAMPDhLUvHQH6qM8zqxseOV1NFaTVyXCOo6O7A53Jx54Z524VxrSG93mtltUm53ayM8Dj1L9hkPcIq0me33upxF8oX/3xg2JkmFLrdbxKIrAdJ12jKezmD8+UzKfvrYZSzgOj0ov4kNZg+KgM0I3TT9tXY7+iais9w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc8e492-3ecf-4291-f3a3-08d83840ad06
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 06:36:10.2882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +WF1xHJTG+taBEkXl5oGe9IuQ6+nWGeJT1zbAiwpJxks5RpmJ8McS4FKyo0RUmBn9jVHUU9InyXpBvJFsVsbaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     if (vlan->proto =3D=3D ETH_P_8021AD) {
> > +             ocelot->enable_qinq =3D true;
> > +             ocelot_port->qinq_mode =3D true;
> > +     }
>  ...
> > +     if (vlan->proto =3D=3D ETH_P_8021AD) {
> > +             ocelot->enable_qinq =3D false;
> > +             ocelot_port->qinq_mode =3D false;
> > +     }
> > +
>=20
> I don't understand how this can work just by using a boolean to track the
> state.
>=20
> This won't work properly if you are handling multiple QinQ VLAN entries.
>=20
> Also, I need Andrew and Florian to review and ACK the DSA layer changes t=
hat
> add the protocol value to the device notifier block.

Hi David,
Thanks for reply.

When setting bridge's VLAN protocol to 802.1AD by the command "ip link set =
br0 type bridge vlan_protocol 802.1ad", it will call dsa_slave_vlan_rx_add(=
dev, proto, vid) for every port in the bridge, the parameter vid is port's =
pvid 1,
if pvid's proto is 802.1AD, I will enable switch's enable_qinq, and the rel=
ated port's qinq_mode,

When there are multiple QinQ VLAN entries, If one VLAN's proto is 802.1AD, =
I will enable switch and the related port into QinQ mode.

Thanks,
hongbo

