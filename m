Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB265AC50B
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiIDPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 11:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiIDPlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 11:41:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602DE26546;
        Sun,  4 Sep 2022 08:41:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3LSMnTPMLkWnWsEEIFYTkiVyUkvSks9nBo1oVSupVv6IWBfjcFEERte4RXujre5rep7V88Bq7rD/ZD48I3fYNqGDTu0t4/7D80w6dRycGLJQvTvInf3/5nd568lFceJGj8l21kljK5Bs08k3D2KGeVCbrk25ZFmbARYQwo+2IRNgevEzeNxqmHpAf6iyR6wdJaNJiqGG8snce6kCmyLie1gtZ9HnSnJ9DoVmot9g+eqO/A8qJ/YyHfaKfHjaFPnpvpyd9b4ijJ9j58ykfPY9Ye+SmrD7UgVM1HBdbULUiB7GVCfHz0IIwBbvJTlf/1kAZ+rNfK0Mg/wB3JqsWomJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYmiNF+sAspc6ENRJHT6R0FUadvlovMUYZYYMDHgp5U=;
 b=PqFDllu7AUuYw8zua/4XOFYdz6MEPw7/OYT9UxCrvc+Vi6bjuHvobOIMWdOfmiCpg5ub8uRu3R6ha2Bp0mCPTA/vOsQyYf8qFoDYoDb7lHjLoAe3Mdtq06goFwS5MgQrfHU5mHtXXh1rbL52GxMuDlcRzTlXvHpLFl7ZXCdlXgOAIlQ+a6Jp9tURzbyUL28Ezi7mAUAXGaMQhjX4xxctJu2vp1vcAycB0yR8FbdWKdfiStjU1x/gHO5QVsLRQEB47f/Fcp+usYfoNVvgiVsV6sY/ivbD0u8ftcNZXmxVR/b4YN5UTIFIhUisx0QKyLXFiolRI6I9mxMF9ctBLQ53vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYmiNF+sAspc6ENRJHT6R0FUadvlovMUYZYYMDHgp5U=;
 b=TGNhuKHbYM652Y48b7+N/mlosFGUM77/xN7ZXIF+nV5ZGLyfsS27OwEkgszowLeccOyzLs44R8UQSBbdNnyDRGWgwTivWR7pqrCKaKBV9dDZmZ1uCbMXElw940YX7ko9y2woDrwsuhILriHUfKcMoD5dl5YkDPCbT+i6WTjqHqA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5667.eurprd04.prod.outlook.com (2603:10a6:208:12e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Sun, 4 Sep
 2022 15:41:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Sun, 4 Sep 2022
 15:41:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Topic: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Index: AQHYvKsLmg9+Fvc+3E2TksPGMZq+1a3L9Q+AgAEQ6QCAAmo6gA==
Date:   Sun, 4 Sep 2022 15:41:15 +0000
Message-ID: <20220904154115.oybr524635lfrgqp@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <20220902103145.faccoawnaqh6cn3r@skbuf> <20220903044832.125984e2@thinkpad>
In-Reply-To: <20220903044832.125984e2@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1119a6e-dcd9-4c23-7a09-08da8e8be770
x-ms-traffictypediagnostic: AM0PR04MB5667:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hj6hq63ly2FUPmc45MR+6GtXPrgKe6zcL7zHP8NkCJbaI6YQ4jK61hVq0+2aQ+n0IOZQvIV7FDTfqspWDkggP3yMxySSm2t719YRkP28Gn5kLjngh1etci+68OgtFVyQoktIOWNWo+JYwDOmSFMWhuHT5OL27wR5SbeSOgGkAlUD4htnkEjDrGSTwCgWbc4Lt8SvFNL8ZuzymvMkVir+d7OnSVOtkidgmY76OOKCVY9cbgkWRjnYh6k+RHJH1RfP0PVV8wt4yiM+2+YFRbVUeQc46tBWO1Mds2T9AJJwCIjsrHEY90QWTiNsNwgYbe+UxkyRh7Qp4CA+fQ7al4TPGhGu8QTYlK1igbaRxI4MsLiHFsR51AyTfTqwYT4/LDZPbL+v1Lbc9RNgcXkaUkm3ZQxFPe16MBflPJ63exy0QJnAwlJIKmbQv2gObeOugaeEPvyIdL4OkcJPnjZYHaxyAXv+17i7wavKEPjyjJ0Dfumz2GFkFSAWdJqfNn2Cxom8rVtJVKNLFQ2yyw8XqivsrHGY3Y6feswQRxqh0X6aqTsQvvwGaz5ZpL/ZO+xfOeqfvdEOOWvptxSisPUqNp86qXDdcfnBPdLIAjYRbFDu7q1kizk5eYJVy/87tyducDKi8L+0OHo9r+nGsM9mrOLtdYYcy0wA2zoz3hpDaWV6HDc3g+kEwb6fd6VmjA6FqWCGhqWPbmfx3DF0tCIz/17zmV/RmKPjB89msZEuQLN1cerGwSGDmRDSGF8ReIOrUbjPOJ0ZPyO0ZRNCJDTgjBZ65ml66p0uDbbaLJSCFfu+HooBR1kjbDGjoYrQEhUGmyOZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(122000001)(38100700002)(86362001)(66446008)(66476007)(66556008)(64756008)(66946007)(76116006)(8676002)(91956017)(4326008)(316002)(38070700005)(66574015)(186003)(83380400001)(9686003)(6512007)(6506007)(26005)(41300700001)(6486002)(478600001)(71200400001)(33716001)(54906003)(6916009)(2906002)(44832011)(1076003)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?TvQqzMXEsAPAMh6pzpa5t/YhMxKkxexRIKprQDwHxvZiMqe0a/A8iym3?=
 =?Windows-1252?Q?mOCKQR5c+olZQcFzNaLwZoYmFhsNDQ/RNA4RASbKarnoGjuqWhETE7dB?=
 =?Windows-1252?Q?B20bYPwCwQWDd1VRuANcaGkfMbPXMmVItO8A5REnViP3/woguBR9Lgwv?=
 =?Windows-1252?Q?YkUwMnsPQpXS1P0C6kVtH0VDJVmrPoRE+QjRmcZ6bhwLDtynuAtMA957?=
 =?Windows-1252?Q?Zl9hhoIm2XUE/55y/3orXKf1g0izpuRvvpYgySroPwbIa9YZZ1PXt/cf?=
 =?Windows-1252?Q?+NRyEtjawu6DBke+R/Tq+I+uBKCNamEl4kZ6T8a2T4Ia2wjYQxy5388s?=
 =?Windows-1252?Q?sLR6ZyJYEdtWP4t9vqyEFEk9XkLr+Diyv57W8Yu8CjXWItzL8lQ3nm4t?=
 =?Windows-1252?Q?GxmfFdPAJummgI0weGgQaxIpxEj3ISMQ9uJXxVfiXyjZo5tlJlOCYcrc?=
 =?Windows-1252?Q?3UEmCO1PikBfoYge3SjpKnjs6oTIfUR3hIUhI73AWjKiiCqmK4nTZxLK?=
 =?Windows-1252?Q?W6GJiLZ42Vd11mhrZBydcktAGRVWDfXBWZvWzY5vpBgeEwu5Wsc4/Pbn?=
 =?Windows-1252?Q?VRGnn+lnSvlxtaKsvkVXFJ5yyKLBD87bSzbPsnVEXqkpwd+U/PpX3S9+?=
 =?Windows-1252?Q?Nfl0ntmb1+rbeq77hNE3Gk4K6ubCC71xC5Rx1PfuFJEb5CaG4NPPiwOG?=
 =?Windows-1252?Q?aplKXvdJ2Gb/Q4tXFVlhFvc6SO1sqXIXtuzZvbxRxDpxsL0LyM5Ea42f?=
 =?Windows-1252?Q?si9rFp6qvLCznYYWZ8bGBZOB44ko8Dnjjl2tEL6JPaudnfWx7ElOhn7m?=
 =?Windows-1252?Q?QIMxsf1PGLL87bKG1H7tthEVOuRVN9NBjE/DCzKQTs7zyDIprU6TSGxf?=
 =?Windows-1252?Q?J6bCVYd6k8dU5VSYuAAQQ5V6YKoaVcSH+H/HbHyCSl93kpWV/5L0g/N4?=
 =?Windows-1252?Q?Vrzb84N13Hg7QgKhE+voongwRkb8mjGD0YUNCUjnv5rRu7F/JexhsY5K?=
 =?Windows-1252?Q?WhiXUsSq4L3328PaMB+MwsJEiWExrOEYd96sjrpvy9wrQalK20R0cMPk?=
 =?Windows-1252?Q?ElPofcR1z1L674Xk15VGmNF0kYd80GcGWN8cKYWc9l+n2q92K0zJXbtS?=
 =?Windows-1252?Q?MwHjWbav7vm4L4+n28aSAAI0FmG2S029ABLaVv0+a7inz2tYATa9RL/J?=
 =?Windows-1252?Q?TVsmd/gYdcIcF59bL9cSKgofpw30KEkKtzkSC5NBVLDwpiA2LEDfV3Em?=
 =?Windows-1252?Q?3TzN44amYLftTWz8hOtjoVNUw485ZA0jbbf/XF0HVd8X07LIOuQS5VmJ?=
 =?Windows-1252?Q?BVsq372A/FJuxEnfcvJZgkunYIlzB4ZjsuiEVRIFLPKbJR2dsF+QtlVO?=
 =?Windows-1252?Q?fKL/zUx5A35P1gbBMXDqQrnKNZNbCR5t9LXv2MdaFfMII/5HXaQ7VSaR?=
 =?Windows-1252?Q?mwKfvWcrDgrCC/FVTsPSWtUopIZu0yik7lS33UwtFDvuugoYsLGSDW8s?=
 =?Windows-1252?Q?Xal61N1O4uBo7hQjJ+TLCBvojnPLTMrVwamsaLKE7kcZmoTXYazlHrgR?=
 =?Windows-1252?Q?I/zxrtiqLMzGLT/NPISGQ9J75RljxTnZ53QB7WNWUCXEz1Z8im1R3Aap?=
 =?Windows-1252?Q?lYUwzbN8mePvRqbYQ9A2OsxVRqvmHKi0z8iXZZ50lAsz40IsfvvQo4tT?=
 =?Windows-1252?Q?FtfWXh/c8NvyII7Nt4yeCen+KRG55bxwOw8+VLVS+Gzo9+EnTfGe2Q?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <666F378CBF03D34E9CCBA5726861B393@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1119a6e-dcd9-4c23-7a09-08da8e8be770
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2022 15:41:16.0540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 31e7BqD/YtspTMA//pu0xnzIJi7wLhudn0f2YrTLD+MB1Ay2DyaX/3KIEdek6L7UqhpIMQB6Ssya9YRE/f/W6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5667
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 03, 2022 at 04:48:32AM +0200, Marek Beh=FAn wrote:
> My opinion is that it would be better to add new DSA specific netlink
> operations instead of using the existing iflink as I did in the that
> patch.

Ok, I'll send out the iproute2 patch today.

> I think that DSA should have it's own IP subcommands. Using the
> standard, already existing API, is not sufficient for more complex
> configurations/DSA routing settings. Consider DSA where there are
> multiple switches and the switches are connected via multiple ports:
>=20
> +----------+   +---------------+   +---------+
> |     eth0 <---> sw0p0   sw0p2 <---> sw1p0
> | cpu      |   |               |   |        ....
> |     eth1 <---> sw0p1   s20p3 <---> sw1p1
> +----------+   +---------------+   +---------+
>=20
> The routing is more complicated in this scenario.

This is so problematic that I don't even know where to start.

Does anyone do this? What do they want to achieve? How do they want the
system to behave?

Let's push your example even one step further:

 +----------+   +---------------+   +---------------+   +---------+
 |     eth0 <---> sw0p0   sw0p2 <---> sw1p0   sw1p2 <---> sw2p0
 | cpu      |   |               |   |               |   |        ....
 |     eth1 <---> sw0p1   sw0p3 <---> sw1p1   sw1p3 <---> sw2p1
 +----------+   +---------------+   +---------------+   +---------+

With our current DT bindings, DSA (cascade) ports would need to contain
links to all DSA ports of indirectly connected switches, because this is
what the dst->rtable expects.

	switch@0 {
		reg =3D <0>;
		dsa,member =3D <0 0>;

		ethernet-ports {
			port@0 {
				reg =3D <0>;
				ethernet =3D <&eth0>;
			};

			port@1 {
				reg =3D <1>;
				ethernet =3D <&eth1>;
			};

			sw0p2: port@2 {
				reg =3D <2>;
				link =3D <&sw1p0>, <&sw2p0>, <&sw2p1>;
			};

			sw0p3: port@3 {
				reg =3D <3>;
				link =3D <&sw1p1>, <&sw2p0>, <&sw2p1>;
			};
		};
	};

	switch@1 {
		reg =3D <1>;
		dsa,member =3D <0 1>;

		ethernet-ports {
			sw1p0: port@0 {
				reg =3D <0>;
				link =3D <&sw0p2>;
			};

			sw1p1: port@1 {
				reg =3D <1>;
				link =3D <&sw0p3>;
			};

			sw1p2: port@2 {
				reg =3D <2>;
				link =3D <&sw2p0>;
			};

			sw1p3: port@3 {
				reg =3D <3>;
				link =3D <&sw2p1>;
			};
		};
	};

	switch@2 {
		reg =3D <2>;
		dsa,member =3D <0 2>;

		ethernet-ports {
			port@0 {
				reg =3D <0>;
				link =3D <&sw1p2>, <&sw0p2>, <&sw0p3>;
			};

			port@1 {
				reg =3D <1>;
				link =3D <&sw1p3>, <&sw0p2>, <&sw0p3>;
			};
		};
	};

> The old API is not sufficient.

There is no "old API" to speak of, because none of this is exposed.
So, 'insufficient' is an understatement. Furthermore, the rtnl_link_ops
are exposed per *user* port, we still gain zero control of the
dst->rtable.

The main consumer of the dst->rtable is this:

/* Return the local port used to reach an arbitrary switch device */
static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int devi=
ce)
{
	struct dsa_switch_tree *dst =3D ds->dst;
	struct dsa_link *dl;

	list_for_each_entry(dl, &dst->rtable, list)
		if (dl->dp->ds =3D=3D ds && dl->link_dp->ds->index =3D=3D device)
			return dl->dp->index;

	return ds->num_ports;
}

Notice the singular *the* local port. So it would currently return the
local cascade port from the first dsa_link added to the rtable (in turn,
the first port which has a 'link' OF node description to a cascade port
of @device). If there are any further dsa_links between a cascade port
of this switch and a cascade port of that switch, they are ignored
(which is a good thing in terms of compatibility between old kernels and
new device trees, but still raises questions).

For each of the functions in the call graph below, we need to determine
exactly what we need to make behave differently (consider a potential
second, third, fourth dsa_link, and how to expose this structure):

                             dsa_port_host_address_match
                              |
                              |  dsa_port_host_vlan_match
                              |   |
                              v   v
                  dsa_switch_is_upstream_of
                  |                        |
                  |                        |
                  | mv88e6xxx_lag_sync_map |
                  v            |           |
          dsa_is_upstream_port |           |
                          |    |           |
   mv88e6xxx_port_vlan    |    |           |
              |           |    |           |
              v           |    |           |
dsa_switch_upstream_port  |    |           |
                     |    |    |           |
                     |    |    |           |
 plenty of drivers   |    |    |           |
               |     |    |    |           |
               v     v    v    |           |
           dsa_upstream_port   |           |
                       |       |           |
                       v       v           |
                     dsa_towards_port      |
                                   |       |
                                   |       |
                                   v       v
                              dsa_routing_port=
