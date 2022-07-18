Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD46F578750
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbiGRQZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiGRQYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:24:39 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C40828710
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7X9vAy55Urr2e06nF9GFK8zUm++My3/H6y9MAIX16FgFfvHrKyGs3zZCLindv0V/PatGPs1+gIAnjDKa2xa7m6C5ficzrwleGBuNbSP3LCbli0TYAoDnu2zEhQ+tqifFZgJBcgnkTU3v6BqMMRHcFiHz3uYy3g5I5S6LbDcVnZgW/DUgf2XUeH6n9b3/jPBTBEjRx28ayVdnn2TX3s2oaAMaUPPUTcUS5e4WjtWCVBdESdzh/neQ/YKF2f86QyigUGn0YYb5ec9pH8xVH8veAMl4PUGV7SRwn3ftB4efnPXpdzUYXBo7ZaH58M/DMikVZGQTBkDyoVnonV5ofbsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0F5vrU0rTbIfc8VW4HOt5QdSd+g07oakPwhiTy6YuQ=;
 b=G9ySd4/sSfrHlfGcSo6mStKRmgiEEBz+w1B7ZjOzkSGfgSo4Ec03BgWzsQjL2ZFx125L1Kc6Z8a+WuyDtQq0unTrGLMse1Ds5btdNqUADFe2ieqaE+nowSgsJRDyRY/7nSLCEI/RXLOKkrjidncnar1yhTcjYXmxEUnfnjjg/9F+LieUoWaqwiBX80UxxNduYiokaTjTKO3YAqyuMgod5z358FLSxml89+ePCNvoWWBBWCkB1y0h/BFIaegA5RgJf6gnFNBm0eYNTJzC0aDnlto2/nkVz8A2oFMC8wHjxNzLhHXiYkqOOCHvu2sa9ZAVE/DCC3of7fyC7DeWu1peKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0F5vrU0rTbIfc8VW4HOt5QdSd+g07oakPwhiTy6YuQ=;
 b=cRZSnn+s7Yh6rRJpU593eR/KzgrFTWNog+ksNubhjLHAcjnmgoHasZOKsEG4gp+VWDHTgnH4ZNCge7I+lsE8Pj03iPlR1coflXS9fTsHIJLcHimoAqvxaNAiLDiqGLK+punHTb6s8yEu6emrdaO+ifPFxrDPcFc/fqT1xogV70Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7679.eurprd04.prod.outlook.com (2603:10a6:102:e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:24:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:24:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAIABMN2AgABlhQCABKhugIAAHr0A
Date:   Mon, 18 Jul 2022 16:24:35 +0000
Message-ID: <20220718162434.72fqamkv4v274tny@skbuf>
References: <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf>
 <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
 <20220708120950.54ga22nvy3ge5lio@skbuf>
 <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
 <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
 <20220714151210.himfkljfrho57v6e@skbuf>
 <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
 <20220715152640.srkhncx3cqfcn2vc@skbuf>
 <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
In-Reply-To: <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ca786c4-fec4-4441-5080-08da68da00c1
x-ms-traffictypediagnostic: PA4PR04MB7679:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7andHS9dI023Xsu8KYuW0HcqKkIzmBIDCSJVgXw5BGCj3obs61X1HPdy7ZaOnDbbxihXZO7QjAWEnNdLskYBFOkoOihJ6Cl6U7GGdlyH0zP6OasbEI/9Y9VLJoh3TBsHrR6E7YT128zgBf3W9/zG4bfp8YO1f5dsET2aQZh2IQ7rq/0tTkaj+kX+rMt+TsF52PGWZ8/MLyw2zetDlxrsz2m4z7gXutZJpDdPxedvunqupO9R+8PdWW6mNXx6Up5AU7OcR1z5SLH+rjsGRQ0wojSf7aQR5ZbqHFZYjtl2rSaqmmznnEWKK9IFF+Kpc+fA/kmOBoalxYKtXdkTcOXiqNgPuftvN/NJZYrSU0lOpAbhMl9POgkX4qWM4YpgF/7WaJJaezAcKKEGvV/Z8B3rrh0oxHFaRIqbpFk9eTAlKvov6gJpRlBBu0dgRwz3AMilpWMcimsVnonmOFGN9b4EapC5ixkauyx1offnvgHmjsXe43NlxbrlFnZwyxA+uv2RzA0ciTkj3OK9B6AZkWPexu254Yl81a8FzKG+ARgEwrpQG6LKYiupksTxujljIBkZOxRQhb6f3c1TwCOi4ouPEFaDXt2tLLLP2XYQRq+Db84Ka+5pNgNv07E2VzroiiAb60KQlNISzSF/7aqNhePsvPWTxP7aVQkzNrJQvju4uw3Cr77ZkwjPzcOkgYyaIOQJsUwiOp/gJqMd0VM/roHIShQaDVKbghr662PSwGgvoPPyZfkE+ZDzEbNqb+2BFBN8F+FhT1yQTyAvsgFQgE4RQMIND0KMy3pIH2IAb6V4fysVF/krIA5OvjYlZZFiISJcxFGl8TKRPb8GLZhWo+NNMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(6486002)(966005)(41300700001)(6506007)(122000001)(6916009)(316002)(86362001)(38070700005)(9686003)(6512007)(26005)(83380400001)(71200400001)(54906003)(186003)(1076003)(66446008)(4326008)(33716001)(76116006)(64756008)(44832011)(5660300002)(8936002)(91956017)(66946007)(7416002)(8676002)(66476007)(66556008)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VJC1KynUD8iL00lgrTOJX0sP8TM2PCTxwvwMhw1MzK7AggF3uPlh7wYR7wBi?=
 =?us-ascii?Q?QHvM2UZuWVlgXHEHBF0ucqdL6cB0gG4UOGLUuY0nBGWDtEIr7ki2qTg4/I7O?=
 =?us-ascii?Q?Tj5qWG3MCEy6lMCm1JaHantQl0Ew3ithjBGRGB7GwdtI3HWgIn9Q0EqvvdIZ?=
 =?us-ascii?Q?6+KCU2E4Wotc7inwp/IIfsz3plpnbJF0BmokzMgMx6XjDEfCvAznbpy2cWDk?=
 =?us-ascii?Q?Cl3kF3j1sRa5nn5BR/h73lRDot30VrqGnOAcBv5osfp+WpW2cV0XhM+W3tok?=
 =?us-ascii?Q?j9DfNy1efTPfV8bdYK/JsS8R+ZiZxKQdtX3WQKrj1nQ+4CkJJiDRv3ll8BSu?=
 =?us-ascii?Q?O2OqlatjeIbbMINckKAAY1FSsyojP8Ea3zTUgM9jSpsNZXpLV1+imdT5/1ru?=
 =?us-ascii?Q?0gCOVaktjHpDiVZ0TCVmvtZMytjGMkEzzLPK4BkqI/tEW+NCmszewQBbKHXw?=
 =?us-ascii?Q?kjrwOlzaA6m2O1YKDvKVOU6bmtSMn0HjF7tlSP0IiG8aaI6BUlzcDd3/jWRQ?=
 =?us-ascii?Q?iIWmDFk5IiK66e5v1uTXZ0bIflwp4WU5xZHzBNMa8bRg+oNhTBLuRkACSQgW?=
 =?us-ascii?Q?OWeaNSlFOheLTvPwZpq5Yf6/CgXM/QRpT6KNoK+ALWbGRf+WiG+CxGnGC2Ob?=
 =?us-ascii?Q?w0765IRfIxE/OtOza13zbQmBvrq1bjmaX3MROSsvFu9iRXC9oFdwG+crA0wJ?=
 =?us-ascii?Q?kS1xU6UlEcXOMloqbSAyXuwbAPiMC/jWplUObIMAhQbixalaXU7giNukrzVT?=
 =?us-ascii?Q?/oMquVaSH/me6gJK8FbB/8B3mehhtk8gToGaEXWE00f2efqq2M1XFIr0kjPi?=
 =?us-ascii?Q?WCgTEOPAl4hv3cTn27IlLOy/sOY4KwsFWEz+uxqjpk5OExRbldt2HE697MKR?=
 =?us-ascii?Q?OZ/keJKQb+78hUDXRirh7nK/r/wGegxfgDXlZ1kyOE9aPfKbswjfaZJxFs+z?=
 =?us-ascii?Q?n0pA48sdM6ILGyw1Sda7cBNAJyQKpJ9HdzTfwLgtyj8LAvPUbm3mZjeFGaoM?=
 =?us-ascii?Q?E3wgdyZMe8zGLn8qdK6c3hPyVSM7elI9waGgoVqtlP6V48cySHepz1nfMycU?=
 =?us-ascii?Q?qMV3m6tN4ONbqpJ4Th7UWJFU+3LohQsYcOnjUGdQsNLUqyK+4bYFlXp5ueus?=
 =?us-ascii?Q?tdeyhH+xMscLLg2XFWcnFCKIikdInBc1GT9h2rm9gsz1C2BGvoC0Pd5+OVqV?=
 =?us-ascii?Q?1Yt5UuZ1B90N77sJeqUkX92yzowL14AUM1clVm4WzQsFKasPf+oSKW0wW8tQ?=
 =?us-ascii?Q?ZD+OwxNEJ6CD3ByyjpvJZmhdY++uqBypIw8uWZObf85m4PO3MIk9luSVbogm?=
 =?us-ascii?Q?PUIpJDDoi3FAVcBFL90pbdpz2zsf2aHlZxRi8ARdqJatNWKVwq8L+JfoJdCr?=
 =?us-ascii?Q?3y+B/3OcO0+Ahs2vL7yfi9Nqc/hcwcfyNL3xpKj2nwmn28RWCIjHVAR8VQqm?=
 =?us-ascii?Q?4hXMfDnWk3FOPqNVqb9pCecdhe3ZOBmVJI9hLCskKEdIqcTfBMD2aGmNNxCs?=
 =?us-ascii?Q?SJ1zJK+vGpntSPGugny4ZQN2kIyv33z3oD79/55RmFD4uYIX4440HGTvI5xQ?=
 =?us-ascii?Q?5VepqTA1Rvtr/h3IFqDvqz9kgIJabdNhsN6IJh1wCwRcVbMXGp9jAVJvdQ36?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E4AEEAA4B4C1044A0BED419B8B16A93@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca786c4-fec4-4441-5080-08da68da00c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:24:35.0862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qrqeBvvgBu97df8tzRkT1bX107XJviVv4sZjEo1sSlmAsp6pVlMt1C1Kbe/jLLNIYrAA+Vtb/wO8pudO+IGOeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7679
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Mon, Jul 18, 2022 at 02:34:33PM +0000, Arun.Ramadoss@microchip.com wrote=
:
> Hi Vladimir,
> There was a mistake in our testing on the latest code base of net-next.
> Today we tried in the latest net-next and following are the
> observation.
>
> Scenario 1: Before applying the patch
> ------------------------------
> ip link set dev br0 type bridge vlan_filtering 0
>
> bridge vlan add vid 10 dev lan1 pvid untagged
> bridge vlan add vid 10 dev lan2 pvid untagged

"bridge vlan add" on lan2 was never part of the test instructions.

>
> We got warning skipping configuration of VLAN and ksz_port_vlan_add()
> is not called.
>
> Packet is received in Host2 when transmitted from Host1. So there is no
> breakage in the forwarding.

Nonetheless it's good to know that the control scenario behaves as
expected, i.e. the VLANs are skipped while VLAN-unaware (and therefore,
the port hardware PVID remains what it was).

> Scenario 2: After applying the patch
> ----------------------------
> ip link set dev br0 type bridge vlan_filtering 0
>
> bridge vlan add vid 10 dev lan1 pvid untagged
>
> --> Packet is not received in the Host2

The problem is exactly here. The driver should pass packets at this stage.
This is because the bridge is still VLAN-unaware, despite its VLAN-aware
pvid VLAN having been changed from 1 (vlan_default_pvid) to 10.

> bridge vlan add vid 10 dev lan2 pvid untagged
>
> --> packet is received in the Host2

This only goes to prove that the VLAN in which the switch processes
traffic while VLAN-unaware is the PVID of the port. So when the PVID on
the ingress and egress ports matches, forwarding is naturally restored.

> bridge vlan del vid 10 dev lan1
>
> --> packet is received in the Host2
>
> bridge vlan del vid 10 dev lan2
>
> --> packet is received in the Host2
>
>  * Let us know, do we need to test anything further on this.

Yes, now you need to go fix the driver :) Please read the comments from
this patch and the series in general (including cover letter), they
point to similar issues in other drivers and to commits which have
solved them. I need the ksz driver to work properly before I can delete
the configure_vlan_while_not_filtering workaround. Generally speaking,
the PVID needs to be committed to hardware based on a smarter logic, see
this for example (and all the places from which it is called):

static int mv88e6xxx_port_commit_pvid(struct mv88e6xxx_chip *chip, int port=
)
{
	struct dsa_port *dp =3D dsa_to_port(chip->ds, port);
	struct net_device *br =3D dsa_port_bridge_dev_get(dp);
	struct mv88e6xxx_port *p =3D &chip->ports[port];
	u16 pvid =3D MV88E6XXX_VID_STANDALONE; // Dedicated PVID for standalone mo=
de
	bool drop_untagged =3D false;
	int err;

	if (br) {
		if (br_vlan_enabled(br)) {
			pvid =3D p->bridge_pvid.vid; // PVID is inherited from bridge only if th=
e bridge is *currently* VLAN-aware
			drop_untagged =3D !p->bridge_pvid.valid;
		} else {
			pvid =3D MV88E6XXX_VID_BRIDGED; // Dedicated PVID for VLAN-unaware bridg=
ing
		}
	}

	err =3D mv88e6xxx_port_set_pvid(chip, port, pvid);
	if (err)
		return err;

	return mv88e6xxx_port_drop_untagged(chip, port, drop_untagged);
}

Additionally, DaveM has just merged some DSA documentation updates which
I think are very relevant to this discussion. See the new "Address database=
s"
chapter for a review of how things are supposed to actually work when
done carefully:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documen=
tation/networking/dsa/dsa.rst#n730

Thanks!=
