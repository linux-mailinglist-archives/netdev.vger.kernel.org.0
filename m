Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69D2581844
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiGZRVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZRVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:21:33 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D9B6417
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgkyTeIVUxmtKTjhA7/Kcp3i65rWiWgv7JVUvUlZH2Lg8ecQ4z6v4S8zbx6ewKbBoSQmYzvUrzLIaO0F3E7WxrB5Ypu8SjtejVWWGMPUAyTT029NFUEAm1m7jYKodqZQkaOZmhFnvohICf0BAvfeK4RPa9ZS3QbaTTj+W9ev/nwyuGVHkXD7hbGMgZdk54IKI70Q/uis7EiNQIlBVHS9e8CYhXYsbJup3tGNxLewuuFJRRVlmqq/FaYlkFb+wFkJeySF5cXc9wlPbuPsPFyeCPhjot8tPKgYTjqc8cP/JNBsm800oOdbMzB2CJsNm59REI2dpv1lGJNrW5o7hhTppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hApXwk7G8ma5jk6ed98UUfK1uYd/MYUNkNjPM80Dx0k=;
 b=PluzwimgfJYu/m+OEkAqRD+r2+j9cRsKDvdsFYdYKByGruuMaW9nyTKVy1kW4cTcSOTPZWU3v6s/QsekYUiQ/yvgAesWtdg2Poc3SiEw+n/e8YcyK+QiYhpxUcLJWmQzCiEocegd8PNkf+3kWVJq+iF+E3pukJ38StoPIysbtzOdAjDVQxKicSorz5TtXCOEBPIJcOBQHZittzcaxKD6nycz4nQ0UtgBHIO2xfYjFZowm2FlxFS5GjWqzAjIDpS2NmTbsrX+4W03Wqf/2MV6l2+s07z+pbbMTx3i+R8s1bMotZS5EQI+XCnqKTjjv+EemDCtg+hOgGyNlSkIxv1kpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hApXwk7G8ma5jk6ed98UUfK1uYd/MYUNkNjPM80Dx0k=;
 b=lkcTPgs9xpdkd1DWuH7mohfZHTTqEwQX/qWYJllkqYHHznDSvbrSqQzxPFHmWNeDsi4gt5hxIjGS1yi8+I8wN6nb9Sdk6K08JRfQo4ur6QzkwTlFQc04eywo/5EIAGtPrFmflHC7QGiZCqI7ICRwAFCu1nUv6GhqHwLbc+Vd2Dk=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB5876.eurprd04.prod.outlook.com (2603:10a6:208:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Tue, 26 Jul
 2022 17:21:29 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::c8f2:4b12:f7ac:3609]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::c8f2:4b12:f7ac:3609%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 17:21:29 +0000
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
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAIABMN2AgABlhQCABKhugIAAHr0AgAx97gCAACSfAA==
Date:   Tue, 26 Jul 2022 17:21:28 +0000
Message-ID: <20220726172128.tvxibakadwnf76cq@skbuf>
References: <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
 <20220708120950.54ga22nvy3ge5lio@skbuf>
 <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
 <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
 <20220714151210.himfkljfrho57v6e@skbuf>
 <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
 <20220715152640.srkhncx3cqfcn2vc@skbuf>
 <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
 <20220718162434.72fqamkv4v274tny@skbuf>
 <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
In-Reply-To: <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a61aa66f-283f-470b-30c0-08da6f2b46d4
x-ms-traffictypediagnostic: AM0PR04MB5876:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GW3bOsaYbGgoZWQtiiFnpNjvORedSQZavPp+hRQzAzAs2q4wPMpGLBZpJitacMSagMJrMGC8SQLv46w/wiANRqB0CX8LLLm0hK80PX/ZX5TPE+XyOUtqO1GZYkuDYbyMC4WRdXkdtag8T+Wk57Wm+57Ik6bg43XC/klDzxe7Tgz5ttycIEj6tYfgIMNhguVa1IQhitsg9xxGzWRb6Cs4K2WqhO2dVtOtnR1YMZFQ6njizfEmJzZiiRE+ZOTkUQbFOulag4rS6LXVP8bxtrNI+ltKQOYnEsKe3hRe3N7iJ9qxgEvF8523H7+V3yodJNtYWyuIIxSXI+80UPHhHhw0evowuwWyHBusUWJ8Xn7cNFJP0lrjlFkOaqbMGvddWg60RsTJF7xSGkYAOseKF59/SCXzJ0jdMgB/hDr8/dTxVuWSID/LauZfBJwpspdaVdu6WzRpmQRVfNObLeQMJ8G40KcSOjoQZruIqJwOCABjlr4HjmuFHPXwfyz+jvrM+T6nvNNihsr6Tw2eUUfrVyasIr7w2z/tVip6o4uN94WUTefKJ0a143n0UAEEiMo6LnBzCO9vQjfQBZgdnlB/GOuPPf/WF9PBo5V1ZkUKmi6WbE4h5eCLLsaQoP8/aUlZYE47pswo/r5Wr4cW247hMtCjvWxPbTaQF1GRzDgvaZHDLkPXRo3MNsgIqEZgdK6fKeB0K6xtMWhse497/zZxN661xcfqtsXa+gW6i82D/8OfaiDDECtAcfhQ5rnxvNyamzeQkTQpN4TPDLGp6M8Ok8E7Lgu/D8Paxv3+xJf25uxmoVoCd/vnhgnNVQU6BhwVvdnVO0vmscjX4RbD+BVYbz/13w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(396003)(39860400002)(346002)(376002)(6512007)(41300700001)(71200400001)(91956017)(86362001)(478600001)(26005)(6486002)(6506007)(9686003)(2906002)(66556008)(966005)(8936002)(44832011)(7416002)(5660300002)(83380400001)(122000001)(1076003)(38100700002)(186003)(8676002)(38070700005)(33716001)(66476007)(54906003)(6916009)(66446008)(4326008)(316002)(76116006)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k2lclYJeru6uZpDa02A06XjxYEkSRbBpk128+/YjeQ3NoKL//Bz6Ydirqn5+?=
 =?us-ascii?Q?kVWiJP4+4TZv7CxdGN1HlCqotwB3yHmZbZIOz3Axqa2P3PdbSwwC+q8t17LY?=
 =?us-ascii?Q?ee567QAD5evPEsrHlTiYZj/jae/Gc3vrrbZpiWdwASMQbv53MJJqJWvHGdLw?=
 =?us-ascii?Q?HGiPCTiZax8GesypPVeynIg/MAdMxFc1M4SRwXXTWA3+/ytiFWArLZJmVzc3?=
 =?us-ascii?Q?N98z+3gFQ0fnhdh8270RjXooygV24ZN8v19Ad4i7EfRMehYCLZs8ucBmQXSu?=
 =?us-ascii?Q?pLOYl2Vy2u7UmDSHW48mLmZqOTviqGiW1K5FFdxQF26YXul5dSuk3VOWWL1j?=
 =?us-ascii?Q?/YslP6FJi4AuPjj1AVbzGD1KGSF6JpQ4I6ci3n4CqhA0XROtlWxMPqy5mW+F?=
 =?us-ascii?Q?xWYRQPj2IOBuf3Ugu6SYj8YduX90FwZOt6nk468qrgpdJSkt188sfpM1vXg0?=
 =?us-ascii?Q?44vFxupdzArMCeLPF9AUougFpDVXSiw/LffNzoBsAHGC5JCVmHtZy/65nm/7?=
 =?us-ascii?Q?/BNIe1s/hVTP3ufECwAIyRe3JSlQ33fbnnrF8VDGVhGWEj6ZD3ArFWnxJRjF?=
 =?us-ascii?Q?rxNo4RoG4otTJtPklfPYiwkeKSTTPjZQWtzvwDXSpBkHJZcROGdnhF/+CMd0?=
 =?us-ascii?Q?js3AfFIFSZhC3j4cb0EapzsWEE9nIUQivfDkgNFE6RZRix6eKPF6TMzK563K?=
 =?us-ascii?Q?YRnAeOjcGB6YQh2Yp3jU+f+lCaw1Lb75iFVZesffGtB+5dTqfXqy6b4bEdle?=
 =?us-ascii?Q?xtLbOlPzR/DZ1XKWbwD+XonuTD+JylYHF0T0QPI4cOCgELgN81HgHatDCelr?=
 =?us-ascii?Q?t6ZT2fdEBE0W6OXg3x6KV9LKa1ekWRYrHq/F+JkxqdPJmSWlF5LTtDBcL1W+?=
 =?us-ascii?Q?w/6XkUMu3tERAvGzAqwYpXW77euil35AECkTuz634t9mPbLxY0a3wfKNHSAg?=
 =?us-ascii?Q?tF3h5WaQV5LvyAIvFScGpYkJoWHykM0O2GIn0BQnCU50ScOeOpFZXIjZXkkN?=
 =?us-ascii?Q?bk385gH37gmY5hrNi+PXwYfsljyzBJrDk7HIhzPtLvkWwA6x+Yw1BZr9nyM5?=
 =?us-ascii?Q?hx1QMNhYxOk2a0VhO6FtC1UQVa5MCx1NYLCFETRTr/Tvmv+8Gb4fuDpxR7Da?=
 =?us-ascii?Q?/4Xio3g5C1Dqi/u1tXoIjjpQtGnxH2SCC7LJwb8MmDBEX623sj4zobiIlWHR?=
 =?us-ascii?Q?aTLiEhfHRVGcUBUWGe7xJkYUpEcD9B94jGJ+hXcYO1kJXEYXirtteP1ZHbOK?=
 =?us-ascii?Q?ELF0jI2FMOeZJo0ZC4kGdZWnnAvmmRPnmc1cdeDfLSV8MtwVc95xyqx59E7m?=
 =?us-ascii?Q?xMsvos9qTXKpz9Ve0AtXeaNWiT7SdRF1HYKfbAED9AjTmnfXdql2luxA3S9J?=
 =?us-ascii?Q?lxg+8ahBrsBTO0rxcMNyDFUbrZpAc2jGANuMs3P0o9XjFlDot/HX8KZ658hs?=
 =?us-ascii?Q?bqHijnDMaP8hwdtfpWEPehP+wQLr+/r/AakDjTeC13p5HyCH3S7P5dtky7A6?=
 =?us-ascii?Q?J02gB6km8P4rloqLwnEpDtL1ZxOHwNKmgAmJVaW5wRcw5tgJnk25/wbr/8T5?=
 =?us-ascii?Q?3jPt8JOPfxsfUazuWu6LkQZH0hXpHL/0rA1+vBTJgwbKVyX/cVBLUdBUDwIF?=
 =?us-ascii?Q?JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32877B9E5CEBEF438A4EAE3D558B97F0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a61aa66f-283f-470b-30c0-08da6f2b46d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 17:21:28.8778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C6G228lJw3w6owUu+oXKBIFI+46z/E3CKMczhif9TTSw/OqwZ90B/N4The+um/QDLBcLz1Qp+Go8sBxlMX/+Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5876
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

On Tue, Jul 26, 2022 at 03:10:24PM +0000, Arun.Ramadoss@microchip.com wrote=
:
> I tried to update the ksz code and tested after applying this patch
> series. Following are the observation,
>=20
(...)
> In summary, only for pvid 1 below patch is working. Initially I tried
> with pvid 0, 21, 4095, it were not working, only for pvid 1 it is
> working. Kindly suggest whether any changes to be done in patch or
> testing methodology.

What are you saying exactly that you tried with pvid 0, 21, 4095?
Do you mean
(a) you changed the vlan_default_pvid of the bridge to these values, or
(b) you edited "u16 pvid =3D 1" in ksz_commit_pvid() to "u16 pvid =3D 0" (o=
r 21, 4095 etc)?

Either way, the fundamental reason why neither was going to work is the
same, although the explanation is going to be slightly different.

What vlan_default_pvid means is what the bridge layer uses as a pvid
value for VLAN-aware ports. The value of 0 is special and it means
"don't add a PVID at all". It's the same as if you compiled your kernel
with CONFIG_BRIDGE_VLAN_FILTERING=3Dn.

The problem is that you're not making a difference between the bridge
PVID and the hardware PVID.

See, things don't work due to the line highlighted below:

static int ksz_commit_pvid(struct dsa_switch *ds, int port)
{
	struct dsa_port *dp =3D dsa_to_port(ds, port);
	struct net_device *br =3D dsa_port_bridge_dev_get(dp);
	struct ksz_device *dev =3D ds->priv;
	bool drop_untagged =3D false;
	struct ksz_port *p;
	u16 pvid =3D 1;       /* bridge vlan unaware pvid */   <--- this line

	p =3D &dev->ports[port];

	if (br && br_vlan_enabled(br)) {
		pvid =3D p->bridge_pvid.vid;
		drop_untagged =3D !p->bridge_pvid.valid;
	}

	ksz_set_pvid(dev, port, pvid);

	if (dev->dev_ops->drop_untagged)
		dev->dev_ops->drop_untagged(dev, port, drop_untagged);

	return 0;
}

You can't just gingerly say that the PVID is 1, then rely on some other
code (the bridge layer) to actually _add_ VLAN 1 to your VLAN database,
and expect things to work (as you've noticed, they don't, when the
bridge doesn't add this VLAN).

If I'm following along properly, and *there is some guesswork involved*,
VLAN-unaware bridging only works with the KSZ driver if you have
CONFIG_BRIDGE_VLAN_FILTERING enabled. If you don't, nobody adds any VLAN
to your VLAN table, and (this is the guessing part) the VLAN table of
these switches is by default empty.

You need to pick a VLAN that you use for the address database of a VLAN
unaware bridge, and manage it by yourself. That means, add logic to the
driver to add said VLAN ID to the VLAN table, and deny other layers
(DSA's port_vlan_add) from touching it.

That's why some other drivers use VLAN 4095 and/or 0 for that purpose,
because they don't need to deny these VIDs from the bridge layer,
because 'bridge vlan add' already fails for VID 0 and 4095 (IEEE 802.1Q
defines them as having reserved values).

This is done for example in mt7530_setup_vlan0() in mt7530, managed by
tag_8021q for sja1105, or ocelot_port_bridge_join() -> ocelot_add_vlan_unaw=
are_pvid()
-> ocelot_vlan_unaware_pvid() in the case of the felix driver.
mt7530 has nothing to reject, while sja1105 rejects private VLANs in
sja1105_bridge_vlan_add() and felix in ocelot_vlan_prepare() - see
OCELOT_RSV_VLAN_RANGE_START.

Now don't take anything of what I've said too literal, because I'm a
complete non-expert for KSZ switches, and the way in which you enforce
isolation of address databases is completely hardware-specific.

Of course what I've told you above relies on cropping some VLANs from
what the bridge layer can use (and then you need to make sure that
somebody from the outside can't 'attack' you by sending a packet with
VLAN 4095 on a port from a VLAN-aware bridge, and your switch thinks
that it should process it in the forwarding domain of a VLAN-unaware
bridge that *actually* uses VID 4095 as part of your private driver
implementation). So the approach of cropping VLANs to use privately is
not optimal, and does need care to implement properly.

I advise you to read back starting from this thread with Qingfang about
how address database isolation was implemented for mt7530.
There, we ended up using transparent mode for standalone ports (VLAN
table is not looked up at all, packets default to one FID), and fallback
mode for VLAN-unaware bridge ports (packets default to another FID).
So that can be extended to allocate a FID for each VLAN unaware bridge,
without cropping more and more VLANs, just mapping the ports of each
VLAN unaware bridge to a different FID.
https://lore.kernel.org/all/20210730175139.518992-1-dqfext@gmail.com/

Some experimentation needs to be done to find the optimum configuration
for this hardware. At the very least, what I care to see is, in this order:
(1) a driver that makes sure the private VLANs it uses are present in
    the VLAN table
(2) a driver that only changes the hardware PVID when it should, i.e.
    not when it's VLAN-unaware and the bridge changes the VLAN-aware PVID
(3) a driver that separates the address databases of standalone ports
    from that of VLAN-unaware bridge ports
(4) a driver which separates the address databases of *each* VLAN-unaware
    bridge from each other

For the purposes of my change, I only need (1) and (2), but I strongly
suggest you to look into (3) and (4) as well. Some selftests (which I'd
very much like for the KSZ driver to pass!) rely on (3) working properly.

Sorry for not diving into KSZ hardware documentation, I wrote this email
in a bit of a hurry.=
