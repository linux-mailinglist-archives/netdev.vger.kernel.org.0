Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5634D4DB2
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbiCJP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiCJP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:58:15 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80085.outbound.protection.outlook.com [40.107.8.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B7C156785;
        Thu, 10 Mar 2022 07:57:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTpYLLV+DYl3RFvRybzBoKzrtzZ2TdG+FA07fMOEVd+ub864IqDbwb/Dha/NsWyvzZWja7H6lYPXWfnF1vPP4pchkKe/9pf/wM+jhnFAN3Dxdemp+4qQruxQhFUb8wFl3Ezuh6I3EPaYQpb1nem8gHbQ5NvQhnSfRBDgVyR0P2tEKPe605sUsgnWltP/zNM0kRN8seIheUTPwi9MtqrUQ20HmhzhURfSwZS+4rWkeF7zGUTdsAKhd9FB6YL6XWabCNG8QSpfaVSTpPWDi63W29mJx7jIyO7xhbz0VH5POCetsnphmVpeQVBCjZVziY+17JtscBzAUZgi/yXZJn7oGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsxEApI6hPYcyN/1X46ZhAmvn/zeVISHDEcN3VM3FNc=;
 b=lBnlB93vg9od4CMfBiRALVcCDVgYHR/G6ejLQ8gJ5Lea5pcMw0Gi1Qa4Dlm2Slw6If2NmhwBr82rNmGYrylTsXbetqdAzv6cz6UCSEaeBEgc0bb7wksDlbD/HFt6KrJP3vis2SBcWaQBY39kTV7B1jcxCvxuDTcTFCfxgaINadSaMpBISMmuhNYDY/W42PKDvGm/REXlDaXqPVOrARnLdz2fVtibtvvocJH3ZnUEeCEybAoP7CMRiM5y9eggPKF1K/tH5KHG9/iKjuJyXa20N7iKtXxJ9X5kkTPK9zmkfD9m3IdxB8UD5IaR9ez9BObI0mdQVeW1kcayNcmE2A6EBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsxEApI6hPYcyN/1X46ZhAmvn/zeVISHDEcN3VM3FNc=;
 b=QVhh+29YggP23xaiXKSiTIm/mxRhDBIOpTwpmvAaCTf5ubPJhi/CE/EE2VHAoRQLsUgd/ecMQ4PIhh+QTIqqTcUQgnmmLIcWnJ3/mPhw5HrWK1cLhL8nyJTlF4i6qeEqzPh9uzDWGcJNQrFBJLQpd/YrMXXkfuQlF2BG60DdC/Q=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR0401MB2560.eurprd04.prod.outlook.com (2603:10a6:800:58::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 15:57:10 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 15:57:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Hongxing Zhu <hongxing.zhu@nxp.com>
Subject: Re: [PATCH net-next v3 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Thread-Topic: [PATCH net-next v3 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Thread-Index: AQHYNI53+CR564NygkStQtKc0yUlqay4t4sAgAAOVoA=
Date:   Thu, 10 Mar 2022 15:57:10 +0000
Message-ID: <20220310155709.xfbqjspok2duka3n@skbuf>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-8-ioana.ciornei@nxp.com>
 <YioTznpNwldCnJpm@shell.armlinux.org.uk>
In-Reply-To: <YioTznpNwldCnJpm@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c419575-7f86-4f90-9f93-08da02aea2e4
x-ms-traffictypediagnostic: VI1PR0401MB2560:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB2560ED374E1FBB6C5E5BD48CE00B9@VI1PR0401MB2560.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Af4vmasqHg0BtyMIgOEniOpHVkwNHKNnX7TRGm+Dx3toG/R10XJ68f2BPf6frnldBhQRE+FXCBjl3AlRLiN52Y5r2JO/aYMT/N4eUb6jnoP7J486zfCp+c1QehF9oK0jeRClRrj+pOdZ+ahizXfgrXqDAyWYLAY1XpoXLxwWy7zjQM7UoudFQuhcP5Fdsufz3HKkWcPP0JsENCZbRaLi6BGm8nOtWF+Z7CAbNrlY4DeHNa2ZhZkE998AnasRhRtfnPX23vnzSXhpSk1lb0pWKHAPeBSoFEs6gfz37cSY5z7+Jy+amNGMrVzxq4Ks9+SB72306SS5csGNTfeN/TWJmBRKXa8WhvjaqI1+ykKlNiJxHFOPfosHfWYG46ndIGEMEldKUYZeh35kwJY3A8+8rKrPlRB2Lk/cVDEFZTcudqexJpHgNHNa8ni6+S3Vlp4lgtnqKvyNKHmycmvEf3/9hgMJlfl2RBCMoMXBqPPN738n5r9rMEquJHTisYCLiKH2LhPQz2hfHD0oWHGIct8SxXBY5p1HyxHOzsWa0cKcnRrnfvK72TOeIQDoCp3Ewina6dCYe8aOb992lUB/3NR/4BkD2u6sg94GnucPD3UqbnvvKYq08VgEFUgKZO5qlzGCGOQhOcsoE0ouh3JdFphHmKHM3NLJAVhyLxIbK8EJFgKICaMwbJcI0PMuM9emKB/dXzZhDY0jADeWQnQdK0sdDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(64756008)(66556008)(8676002)(6512007)(6506007)(83380400001)(66946007)(33716001)(66446008)(9686003)(76116006)(38070700005)(6486002)(44832011)(54906003)(86362001)(71200400001)(91956017)(4326008)(38100700002)(5660300002)(7416002)(8936002)(498600001)(2906002)(1076003)(26005)(186003)(122000001)(66476007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qDQHg9qWTCZSEZCt5gcmGJeK0RLdtyICuwPbNXg05KTHdBxf9/v/kgjW/ch6?=
 =?us-ascii?Q?b5Aj4ZHy/Fg8NG8CUSxdiun5Y643TWMKEvghQ3bXUcqj1+Ixae+mkfxhH1bP?=
 =?us-ascii?Q?1yxBoI4X28M6c5/N0VRa54cYU3QYZFP71QBMXRx7ENxDzgzydGXTD/DT97pH?=
 =?us-ascii?Q?4OmcUcFqzrhiECGKFF2Dm2Rt4u47lxQXEBVFOqaYxjWQk+Lcssw86oFeKVTj?=
 =?us-ascii?Q?L1fydvc2lnT6IE+e3mz8oSdLeI5x82dru14+EJvfljjLpyFS99q2rZeEpdlt?=
 =?us-ascii?Q?qYRkKOoRG05YHnYfn8w8br3ZKmavj2wkhzcJd4aZC/IOxZB0c3/80qBEELXM?=
 =?us-ascii?Q?3XSXaD58w3j6ppV+J08asZvd48csw6TVkbeUdZvE0ox4MzB+widO1KOjIVgi?=
 =?us-ascii?Q?6r+0c9i4MGojyG0aaMfetbides0/xkh+7Koo2SeYTa/li6sR/HeFDZ0Mll1o?=
 =?us-ascii?Q?NrEVoHaNXkTAHXbvpn8hJufo/b6ubCVBf/hsir8rik4XhoXIhjF8yjmEL06s?=
 =?us-ascii?Q?657DJKma+OHTzmYX6fElKBC4jECEZoT+Mh05cY00SWWiHJECSsa3HekPm1U2?=
 =?us-ascii?Q?HYM1DJ/ifr14hhqvkIYtXkpw6psSGxKoWlAzwLDSymwUWsGONqVgWX6mfGi2?=
 =?us-ascii?Q?4sJxknUlMTGRnKhHsbhHNQxPnUQbnefMtMpIG1CYgFOnIyvfWxKPukJEe8UH?=
 =?us-ascii?Q?+9oR+n/4JGLfwow7BP0jCA8tXsTqzRP6Zg6qdueurHL2o0x4d1hFbUVJu5tR?=
 =?us-ascii?Q?su+C63CpuXkvn9HjQ5Dx0q6Pjicc/SYbN00DwvFoKuCCKWciABWhX/qmLOTK?=
 =?us-ascii?Q?Cihy13zidrv5xKp9EgNCfex9QdrrLAEz/Y9E/WyYSkdixV4YjbnnPux3/s1V?=
 =?us-ascii?Q?ok2uoKABpjsGeUIgsoVnW5cScW3eE1MfwoIA6i8wILLBy4agMaE7BaXX3JxN?=
 =?us-ascii?Q?nIjxioIpJi2DFU2VECZsq5O9v4BpbpEioR+UlbOqhXxMDI6DNZK9o7MtrALP?=
 =?us-ascii?Q?W9NEZs4fj7Ri9N2EFPnjy8I9T5UAdrLKDnTscwzYK/BlfpMNfqyYr1aiYheR?=
 =?us-ascii?Q?qdrklAdT3BpjYWRHTczRHif6TiMmB4wivZw1x74iGr4APtAGdJWOMHQoaA+m?=
 =?us-ascii?Q?eeL/182HwIZnU+AvsLag99nnWqqMGViZrB6cseirm90iqK9TwMGk6TgxPEJ3?=
 =?us-ascii?Q?f+qitZLeht1So9tqKmsj9jKtJ0hr+Kf9cwJv3NHcBR3LBPuzQveKuBW57AZS?=
 =?us-ascii?Q?MFfi1ZLA/qLX7WI0kmaSpUbkWSbobGLSj9Z7OXd0goqYyzdZv5dwCJhSoAy+?=
 =?us-ascii?Q?nvGRxEQ1UzkE9rYIoZoVGPeGnNbi74jTw91cKGFa+Bm80XV/ou+uITprrTD5?=
 =?us-ascii?Q?vQaYNoROxwwtsgkUvq/j7ILyuu3V5EzuhxXKy/OTT14lsJYP3/ISthrbybWP?=
 =?us-ascii?Q?n3DgFgk+MJkclIPVmilo84FiDgdINOpYnoAMdOgb6aGz8bIn+tWvvhE4onVi?=
 =?us-ascii?Q?Et/9o0ql6gavvYO/RHYPKdjCEzzkb9lqhT5LpmwgPVdU8CRhJvJRQIEyT67t?=
 =?us-ascii?Q?wpRGoqIgA8sBNhHeA+9GDGGoTNTGwG9Gq375S91/C5DwWUAgTliHiY+OaeTl?=
 =?us-ascii?Q?JkmOkCA1XvtORq3bOQQXfZQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EEA4656546607F4489E4BB4C1C06EE7C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c419575-7f86-4f90-9f93-08da02aea2e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 15:57:10.5710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hx6AKUtsOoaD4ev2KM5KWdKAquTh3UvE7+bduUwLKAOMgkQq5nXUVqZ7NjCHf/Wk3q78OVyLvXjrxDM+ypXTBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 03:05:50PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 10, 2022 at 04:51:59PM +0200, Ioana Ciornei wrote:
> > This patch integrates the dpaa2-eth driver with the generic PHY
> > infrastructure in order to search, find and reconfigure the SerDes lane=
s
> > in case of a protocol change.
> >=20
> > On the .mac_config() callback, the phy_set_mode_ext() API is called so
> > that the Lynx 28G SerDes PHY driver can change the lane's configuration=
.
> > In the same phylink callback the MC firmware is called so that it
> > reconfigures the MAC side to run using the new protocol.
> >=20
> > The consumer drivers - dpaa2-eth and dpaa2-switch - are updated to call
> > the dpaa2_mac_start/stop functions newly added which will
> > power_on/power_off the associated SerDes lane.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Looks better, there's a minor thing that I missed, sorry:
>=20
> > +	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> > +	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> > +	    is_of_node(dpmac_node)) {
> > +		serdes_phy =3D of_phy_get(to_of_node(dpmac_node), NULL);
> > +
> > +		if (IS_ERR(serdes_phy)) {
> > +			if (PTR_ERR(serdes_phy) =3D=3D -ENODEV)
> > +				serdes_phy =3D NULL;
> > +			else
> > +				return PTR_ERR(serdes_phy);
> > +		} else {
> > +			phy_init(serdes_phy);
> > +		}
>=20
> Would:
> 		if (PTR_ERR(serdes_phy) =3D=3D -ENODEV)
> 			serdes_phy =3D NULL;
> 		else if (IS_ERR(serdes_phy))
> 			return PTR_ERR(serdes_phy);
> 		else
> 			phy_init(serdes_phy);
>=20

Yes, it wouldn't be an if inside another if statement.

> be neater? There is no need to check IS_ERR() before testing PTR_ERR().
> One may also prefer the pointer-comparison approach:
>=20
> 		if (serdes_phy =3D=3D ERR_PTR(-ENODEV))
>=20
> to remove any question about PTR_ERR(p) on a !IS_ERR(p) value too, but
> it really doesn't make any difference.
>=20
> I suspect this is just a code formatting issue, I'd think the compiler
> would generate reasonable code either way, so as I said above, it's
> quite minor.
>=20

As you said, since it's quite minor I am going to wait to see if more
comments will appear, if not I am going to fix this up in another patch.

Thanks!=
