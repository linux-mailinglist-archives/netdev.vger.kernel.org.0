Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D230289E19
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgJJDvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:51:22 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:55456
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730940AbgJJDlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 23:41:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvyifT+X8LGVFvSMZnys+fcvTstV8a/ioaXloUuQPUsa3EMk3PtxR3FNW3jLENTqWWZtwY+cbZvwiTM5CtY1UuFQpjLGnAmbC3VkbPwbG52lqc0d3MTXsO4/pUaRai6C3rv+c2keosrhcWnVqUYjtE5Mg34t1lXB+ycTxfmZ9/F02u5ckXAeroNZi5hyW58KTFmf2HZnfn51oH4Z6UA35B3bUup6J+1Trw07tUFS6xP2zVettfZSDFmfz5tURwMOiC9QVKxXF93W6heY9QVhCh9CnXncmhr2zjd2rO4u9txg7SR332qlt6150C8mHkZF7sIIXCFvWtME9p2V8dsbHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcry3nBBho+uT29wHRAreZYa+snF+ZX6bzJhdnHJq3c=;
 b=HTQq4xZm3s7kWNpbK694Xyb6xI006fYx6c5+xZLq2y721Hla/Q/N7fmtyG+MOsNXDJ6IRU0Znk5ce7DwlpRx51pS5Uabkq4vrFy2FrvUO3m6SuxJ0aCQgr+ZD8IWaYz0Lj/piyZ8xQs/TZKIItpthh9kmN6+QgbJ8Dolbg+6TK/I6GzK8DGmUt0eGsugO9o9PEC9CnDzUlEgEz4k44UlvcwlxNNUr2v8cJ8rVX80fZIT3AfMKFtdlXyxrXcP+U/uH/wd7IFk32MTGIjWfBpgQLJSg9pIhi7bRlwpsrfytU6hN7WE9qw4vohNu6kNM/I3Xk2l63gwUgI6ce+tC4Mzyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcry3nBBho+uT29wHRAreZYa+snF+ZX6bzJhdnHJq3c=;
 b=WDkrFKHIhxLHE3N81y/Rd84gUOk9mqQmAxs+107PRV7e7syjpPXStj2c8XOYCFHFwI52QATLlabivQ1cFnRqzi3MjgPKvHRDzcueIayn4HYsWB9XCylLj3YWT6GLqUkII3S+2lx9D4EhIZuObfzngvG5YAqHRiAjIwyWH4LP9nw=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB5966.eurprd04.prod.outlook.com (2603:10a6:803:d7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Sat, 10 Oct
 2020 03:22:40 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3455.026; Sat, 10 Oct 2020
 03:22:40 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Subject: RE: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWjA46YADFMZ9LUEuuxHMi/AxAAKlrCEcAgAAAYCCAAAxFgIABBM0QgCM96oCAAPejQA==
Date:   Sat, 10 Oct 2020 03:22:40 +0000
Message-ID: <VI1PR04MB567734ED11EA66266072148FE1090@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
 <20200916100024.lqlrqeuefudvgkxt@skbuf>
 <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20200916104539.4bmimpmnrcsicamg@skbuf>
 <VI1PR04MB567793A76FE2EBECFC6D8E76E13E0@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20201009122947.nvhye4hvcha3tljh@skbuf>
In-Reply-To: <20201009122947.nvhye4hvcha3tljh@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a4209173-029a-45cc-a189-08d86ccbbeae
x-ms-traffictypediagnostic: VI1PR04MB5966:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5966DFCE8DE525DD0F67ACE6E1090@VI1PR04MB5966.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DWai3KqISXdboTPW6m7SCzIZfFHJwfhcWrLrFLN5qj3jQJfmodXl1ETOpyczQVPYyT9asfz1McdF1q1K6KjJsfvPcEkLZYJm8jaDCZVnr5G4O4nFAt0zszJaVE1hgw6i92LrODU4fHcqLxbvFqFL/6C+q+wc56DDyoYNjlW5nK1LEV3w9XG93Byi/lPyt3ZQi5xwy5Q+jPbhBiHGOaYDE6MBJtltxFbHuZw911Ln729lev7//+iVTlrO2TbelxFsWFudx8IJjZ0+TI5dvcskD60EPvF6ULnfs2AcG8o3FtR5FJdPdCTRuQfpikF8LN4/zqKfEcLdsvKgj4wApOcn3K8r2rnhzljK4PQOA/c/MZA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39850400004)(376002)(396003)(66476007)(76116006)(66946007)(66446008)(71200400001)(64756008)(66556008)(33656002)(5660300002)(8676002)(6916009)(316002)(45080400002)(9686003)(54906003)(966005)(83380400001)(44832011)(86362001)(478600001)(52536014)(55016002)(2906002)(6506007)(7696005)(4326008)(186003)(26005)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZrB6uwm0teOyof2kydEvnvZTVOonwU5fJRc6i0VTjycTpheeix6Z7MgkBxmGfw+svEgePga8mvsEKJV3GT/vrWG48zDa9+Kj/uxrVXU0kGhvlfa9Z+u8NPGi7FQ8eRaqbyfvHpaHPKXzgnj+H5aVn+78udWQVTBoT25oFHOHQdOqqZ4PAwChSjLGL3aEQDtdBz6AT36R1qVPKSfW0CBLbzAn7wmI4Rpi+zoLvGAdD0SmOjG9QbXvTFnMB95IPqn3cfI6V1ZG2yDDvhLN3HSCUjKY7REUPxxNzI06O8RAstK0PmT7hzSulxxpvyJ6GduqjQ84Mq/Y06msaYWSfgpWPiSjwm/2mhuIAaOb3UP8Gtn+bRF/D8X8HiL3OESFM61w0aeM7Ugnj7+rz4tTPGLgI7J31uJp7dSKWrt5lAvwLIwQHjBLmEHBqoBTgRHjwfdr4tASdNWk8Xs3qWwMzDYn7JeyvD5Q42ef0oduqZlEB78haBBYSKtQ3i6/XyRA8jJL5Znw4UMK2AGhbmWD1EMRGkodxrDzuaQIqts+nuNYW5VG2Qo61ALD0IE2QtpHWqKESB/HTv46EdHXui/MMHInvNFhaq7kqOiyh2aow+ZnWp+AQdbi3OArWfvJzRal2FmYFXbsmrbG9drNrEMMh1tjDA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4209173-029a-45cc-a189-08d86ccbbeae
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2020 03:22:40.4642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mJLVFhGna0mQIEwb/MDIDy2jwFFqGszZpmZsNuH7ggKxkUbpnsIvVy2wrtEWp+4try+COMoI3gR/o0HARo1UuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vladimir,

>=20
> I asked this on the Microchip Support portal:
>=20
> -----------------------------[cut here]-----------------------------
>=20
> VLAN filtering only on specific TPID
> ------------------------------------
>=20
> I would like to configure a port with the following behavior:
> - The VLAN table should contain 802.1ad VLANs 1 and 10. VLAN ingress
> filtering
>   should be enabled.
> - An untagged frame on ingress should be classified to 802.1ad (TAG_TYPE=
=3D1)
>   VLAN ID 1 (the port-based VLAN). The frame should be accepted because
> 802.1ad
>   VLAN 1 is in the VLAN table.
> - An ingress frame with 802.1Q (0x8100) header VLAN ID 100 should be
> classified
>   to 802.1ad (TAG_TYPE=3D1) VLAN ID 1 (the port-based VLAN). The frame
> should be
>   accepted because 802.1ad VLAN 1 is in the VLAN table.
> - An ingress frame with 802.1ad (0x88a8) header VLAN ID 10 should be
> classified
>   to 802.1ad (TAG_TYPE=3D1) VLAN ID 10. The frame should be accepted
> because
>   802.1ad VLAN 10 is in the VLAN table.
> - An ingress frame with 802.1ad (0x88a8) header VLAN ID 100 should be
>   classified to 802.1ad (TAG_TYPE=3D1) VLAN ID 100. The frame should be
> dropped
>   because 802.1ad VLAN 100 is not in the VLAN table.
> How do I configure the switch to obtain this behavior? This is not what t=
he
> "Provider Bridges and Q-in-Q Operation" chapter in the reference manual i=
s
> explaining how to do. Instead, that chapter suggests to make
> VLAN_CFG.VLAN_AWARE_ENA =3D 0. But I don't want to do this, because I nee=
d
> to be able to drop the frames with 802.1ad VLAN ID 100 in the example abo=
ve.
>=20
> -----------------------------[cut here]-----------------------------
>=20
> Judging from the fact that I received no answer whatsoever, I can only de=
duce
> that offloading an 8021ad bridge, at least one that has the semantics tha=
t
> Toshiaki Makita described here,
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k=
ern
> el.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fnetdev%2Fnet-next.git%2F
> commit%2F%3Fid%3D1a0b20b257326523ec2a6cb51dd6f26ef179eb84&amp;
> data=3D02%7C01%7Chongbo.wang%40nxp.com%7Cdcfd5e5df4e24455726408d
> 86c4f0493%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6373784
> 33917654330&amp;sdata=3Dkk8WnA0iH9E5yPrLKC8BwSInD6jqm0qGftJ8Jw1Etk
> 8%3D&amp;reserved=3D0
> is not possible with this hardware.
>=20
> So I think there's little left to do here.
>=20
> If it helps, I am fairly certain that the sja1105 can offer the requested=
 services,
> if you play a little bit with the TPID and TPID2 values. Maybe that's a p=
ath
> forward for your patches, if you still want to add the generic support in
> switchdev and in DSA.
>=20

Thanks for your suggestion,
I will research the related code, and will optimize my patches.

Thanks,
hongbo


