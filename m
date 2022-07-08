Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C19556B961
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiGHMKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiGHMKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:10:02 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF5C9FE13
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 05:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOiCZUssq2KREFQci2sMOoKEotTr8aoJGKQJZFb7ws6+jZOZP5OFRIpL0rT4Ow02PeFm//y9GbEFcqeg/CkEgmNh2QmNqAmIyF0MWPJKBHeq68Gw1gwQ5+EA8ifZY6dw5qCJJahsG6g0El0xSPl0StBUtg3xgRocmICQ1SwhUdSMRBQYUoZ9WxuQbwRllFjVFd9b8g6fzpkbR56MOpTi2rE7INPO71kcNoeK+6LUqmzcibWn0TGhGOBJ6WB18Wd4oD8trRkt8kBRgr0U7WhK2nUE4qTTfOJFpEuv0fOikuIw4onfa/dP4s2lGQ9erccOHVo2Jeq1FQrqr4KeP40a1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofBMwaIqA2yGhyTH45PSngAooSEWCK+LRdCw4Cbv8vw=;
 b=FpqjWoMf1OkXz4Ybe9HOnTwj0AcDlBYi0R5S8J5uD/kbgCt6cALVH06ndpjnfGZZhNaZoG2rNYgq2A2OopImkmMO0ZTVdNLJslGFDb8knztoXHM2X3HEld/vJa7oYp4sxCFzhZ4WAMnld0CinQ0htvRavGubBLQiqSrq6hwt3fENmCB7L9EAxciP6CxvlT0lTZJZLONVNhxkFJhK/Hhx7VsWTThdnTpCD+4c/T6VyESg5ZCNS7OZawyzzhtvW7G5K0rPkKtJJgfN9r1w7tnmQ6gTaHKuCOPHZTztFoMGBBLHLTVCjewogmx8jfHonvq51Cy2shGG2czGld8skJfGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofBMwaIqA2yGhyTH45PSngAooSEWCK+LRdCw4Cbv8vw=;
 b=X4ZWecTM2yilt/xo5aezacYIOGcCnptBrkH5BlbtLXV/EkuE017HYX04U86Y0XbZIXOHR/D1CXyye6aplXdNWbXoqEotopkKAw5DnwUa2k1jp3HKS54GrZoGNZVgs+4VX9MHw4VQlAcXmgUzpnUaAcY9ToPeE10L9TNcQtWrJ8s=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM6PR04MB5382.eurprd04.prod.outlook.com (2603:10a6:20b:96::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 12:09:52 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 12:09:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAA==
Date:   Fri, 8 Jul 2022 12:09:51 +0000
Message-ID: <20220708120950.54ga22nvy3ge5lio@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
 <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf>
 <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
In-Reply-To: <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e91a212c-f6a9-4bf7-6985-08da60dac327
x-ms-traffictypediagnostic: AM6PR04MB5382:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ddYmE5W3YO4yQLgVHD8Ld68wL5vNLCE5Ab+bblGjqY7LyelPYgV7XYQwFph8XhOR1iTum2IVlrhZjvxQ83cnrGvw8l/DanETyreRXsd5r63YzLSAYzsVokPZ1ThJYiOB+MXNNFI3cQszZVX+kc37gosFOdjtMzVY+a92IHVVOUfXuCI1vX8zChe93AvH8XrjFTyUeGHbTJiMV2Yx3WcY3QyhvD568QqCjh5XUaYuuG92yzcYk3symwIDxZXnySWz0gJUicIYzr0FSIRR6BC576e+E5FMF3CyBvPo5ngilesxO52NNN1vvJNQvLgZeXh0Iu7cOV9BW/fiARfRCnML1X4Fk7sIzOOJ+DW80n9mho+3MdBLSxsporru7HUYrXK/RtFGKlHiLF8sCwQxAqx4hUxI3zlPPJBkztxwLn1qv8vWVaCdxgKMeYOmlhyeebNka0ONw1CQkbZudC5ugArAdvzgN4ocNAkpb2elesD5hW4p/uCQJg7WX+Y/IDvs67KVkk8gzE0uBhYGKp1RYyIppzf4EeeSTa6K5d4YGl/Xu6OvVfzc0ZlMnU9SwJuORzAjeIwiji4OGPgA+H7F6eBtaXQOoioY/ofUaG++NeyIlUYwzJD1KFBQpybtqArD780XNf0ytJNI8NPZeJLnnyDQ7BfWPL2Q2ThWsqwoe9P1jtYyw5c+Ch7j1nPOTeUmcX+IxyGNEqyo79WyyTZszMieI83ZE+1psf7gN68AT6pGvGGkGdnjpaP5VkDpW4xwUvU3xi10T1LKMM0aEexlGz97HnVOeglT87hlvx/vRZqCnWuxOOUvnwLDvh0lKNFzuk77vF/2ps+IHMflEOzpntt8xjM60U+6KpTIxYdNPegKkitN6l9vLJiid5FdgyeJyWZ8s+t2m7vb6RUI+Nw3xbhdaHCBz5LF2iaWy/+0ny9Fb4w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(66946007)(66446008)(91956017)(41300700001)(33716001)(64756008)(966005)(6486002)(7416002)(44832011)(71200400001)(8676002)(478600001)(86362001)(4326008)(8936002)(66556008)(5660300002)(76116006)(66476007)(38070700005)(6916009)(6512007)(38100700002)(316002)(186003)(122000001)(83380400001)(54906003)(6506007)(26005)(9686003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c3UL4r324eDqr1xNng2PuSdzYVQEHv7Oq2wymhKkoZnloWNwJYAiCDEBSm5/?=
 =?us-ascii?Q?XNTU+4gWh6bnRGqPPJlcgn6YMl2Hd8kKVDD5oZsxuBcnl4Z2eH3GnsGv4X6T?=
 =?us-ascii?Q?2hEBVRSMMhU7tev3z43J0ht4lLeLTXOP3c5LsGF3GSkn/EQ2WKt+wuj2Vw9D?=
 =?us-ascii?Q?eLeYjiPZkCE9m5afckJ2g1Tucridk8r+OLaXPpWPYipBzHhG3sd1RdoPh4nl?=
 =?us-ascii?Q?aU7kvexf1nINVugTfyfDZpln6N/AWQwVYsj+B0XvFjoSS4K0h0dqMb3mlJcz?=
 =?us-ascii?Q?FCqesigjhip76NrSN1ZEGNtdgQ1dBVtBFR1dtlYTVITm26OFxlYQ3V3vtPB0?=
 =?us-ascii?Q?H7x8S4FtrdUym9Uz5+lMg0XY7V7LfD1M0n/IruyOl1kY/t2hMQY9foEXMQqX?=
 =?us-ascii?Q?z4GANxnmtwsX7tOPLkYbCwwkHVypskusJWJ88XoNOJlEMkf6Wjkk+hp/RbYn?=
 =?us-ascii?Q?5BsNVcJDACCH6meia5ctx4NpxtTsUKh6EKSXgsfm2ua3GUA/29xG/V7zWmPa?=
 =?us-ascii?Q?fnxcse2lJtUG2i2BztyOt8Zz1TaQsAckgFljO9yu2NGZCjHWCNalIGQeF2P4?=
 =?us-ascii?Q?TwzEx4YfmW/9fggVU5qmXHAD/1dr+W5s8bAgm+M99XYdk8a65IMKiRpFSium?=
 =?us-ascii?Q?cqIZv6wWqtpbywGy1nnHM15HBSTnTJicq58PwZyCYbtjArIjXvDdt7kPGY2M?=
 =?us-ascii?Q?5laFuiP7pZhn4zKPxyLRs4N4rXKttnVGGlv6r2K/Pyi4ikOpjN+Ra+s5vOkD?=
 =?us-ascii?Q?bkH6TU+Zh0zDzRD6Bn80EIw1Ra0aEZuyYekzpOggU5b3+X2SDkO0x+ZH+4hP?=
 =?us-ascii?Q?QzTPTvrtEMN8arf23b4zxFPeDvts7VZxkRmNlFhY0iF4+a9y3tYXhhk3SG3l?=
 =?us-ascii?Q?p41XlleVQqb8D463KM63DahvKV2IYa4fgE8tlF+Syo6Bc8BME0kxPjUwq74Z?=
 =?us-ascii?Q?IpoB4EzYmzub8xqE7yGZ4xjfdt+w1ypzx7T7IzigmMB5VnbMsC5nvHTIHeai?=
 =?us-ascii?Q?1qg0ZP1odPtJmMPtJNNSXb2tpIYxra4v6KRcttQlzX1RA1K1+XSMcmsrQhkZ?=
 =?us-ascii?Q?xDQOgcZqH68d7fXOAnhwX+hOit0SMBiHGmg0+sQVAp1mqo4zq0puK9mo8tGq?=
 =?us-ascii?Q?pU8Toas/s/hvvz2QY1QaGS/wdRGzIyqgWAExnRC0bA800DZZ4HL4cCZZTEHq?=
 =?us-ascii?Q?+ihfvVqMufcyVNKDxNQ5PQC8xa/ENaOG0LmaiV/3ZhOp4O2E8WZGpsGucYPo?=
 =?us-ascii?Q?OIDwg+X94YTKh+rHdUaydOaA9Nk+Iwyt5l18ynuj48S7/hMh3/9wMkZJYesF?=
 =?us-ascii?Q?Bosa1/Gy4nxzUodxPcFMsvoddwvDtKcz2X89AyAOArmGMsJHT9FHBk5YRLyf?=
 =?us-ascii?Q?im/fpZHH2thSNjG/zVEREG/vCaZl+5khbSeiy055gFgdMxcDHzw0FJSUOaJ5?=
 =?us-ascii?Q?5IyJXqZn7RYssfJlRi5yqQ274N5KBzNC9f0srGjg5uMMA1bWVJNpmuRpuphQ?=
 =?us-ascii?Q?IGPirV6l4zdzgvIWoKnfrqT2Sg0Yw0Kh47ustFSsPBQ1sxBGa9O/pRl6ILDy?=
 =?us-ascii?Q?RArKcDjqObN/NACxgi8xuH8Hzxu701DbJO1tIyiOPXFddJEjWck8O/ETALtE?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3B40B21041D614E9AB23A7D8CA9FB0A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91a212c-f6a9-4bf7-6985-08da60dac327
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 12:09:51.9311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g18NHDdN+n1GJVlKK8KV8hrrillucH3gxDKLrMSSkFu/zqiwPel98ArJ5Hf0vVlbjxMLL4eIKVjE2vn/p9AK4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5382
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 12:00:33PM +0200, Martin Blumenstingl wrote:
> That made me look at another selftest and indeed: most of the
> local_termination.sh tests are passing (albeit after having to make
> some changes to the selftest scripts, I'll provide patches for these
> soon)
>=20
> None (zero) of the tests from bridge_vlan_unaware.sh and only a single
> test from bridge_vlan_aware.sh ("Externally learned FDB entry - ageing
> & roaming") are passing for me on GSWIP.
> Also most of the ethtool.sh tests are failing (ping always reports
> "Destination Host Unreachable").

I don't recall having run ethtool.sh, so I don't know what's the status
there.

> I guess most (or at least more) of these are supposed to pass? Do you
> want me to open another thread for this or is it fine to reply here?

So yes, the intention is for the selftests to pass, but I wouldn't be
surprised if they don't. They didn't when I started this effort for the
ocelot/felix DSA driver either, it's most likely that individual drivers
will need changes, that's kind of the whole point of having selftests,
to have implementations that are uniform in terms of behavior.
For the ocelot driver, the tests symlinked in the DSA folder do pass
(with the exception of the locked port test, which isn't implemented,
and the bridge local_termination.sh tests, but that's a bridge problem
and not a driver problem). I should have a remote setup and I should be
able to repeat some tests if necessary.

I think it would be a good idea to create a new email thread with the
relevant DSA maintainers for selftest status on GSWIP. You'll need to
gather some information on what exactly fails when things fail.
The way I prefer to do this is to run the test itself with "bash -x
./bridge_vlan_unaware.sh swp0 swp1 swp2 swp3", analyze a bit where
things get stuck, then edit the script, put a "bash" command after the
failing portion, and run the selftest again; this gives me a subshell
with all the VRFs configured from which I have more control and can
re-run the commands that just failed (I copy them from right above,
they're visible when run with bash -x). Then I try to manually check
counters, tcpdump, things like that.

> > I'm not familiar with OpenWrt, sorry, I don't know what netifd does.
> netifd is the network configuration daemon, it takes the network
> configuration (from OpenWrts configuration files/format) and sets up
> the corresponding interfaces and manages things like pppoe.

Thanks for the summary, I meant that I don't know what netifd does to
make loopback IP networking work in this case. Anyway it's not the
center point of the topic, as long as the interfaces used by the
kselftests are not managed by netifd or another network management
program.

> > > I'm thinking of packaging the selftests as OpenWrt package and also
> > > providing all needed dependencies as OpenWrt packages.
> > > I think (or I hope, not sure yet) the ping interval is just a matter
> > > of a busybox config option.
> >
> > I think it depends on busybox version. At least the latest one
> > https://github.com/mirror/busybox/blob/master/networking/ping.c#L970
> > seems to support fractions of a second as intervals, I didn't see any
> > restriction to sub-second values. In any case, the iputils version
> > certainly does work.
> Yes, there's a duration library inside busybox which by default only
> takes integer values (it can be configured to use floats though).
> I pushed my work in progress OpenWrt package to a branch, making use
> of the iputils version: [0]
> Compressed initramfs size is below 10M and uncompressed at 22M. My
> device under test has 128M of RAM and that seems to be enough to run
> mausezahn as well as any other tool that was run so far. So I am not
> particularly concerned about storage size (anything with 32M flash or
> more will do - 16M could be a bit tight in the end but will still work
> I guess).
>=20
>=20
> Best regards,
> Martin
>=20
>=20
> [0] https://github.com/xdarklight/openwrt-packages/commits/wip-kernel-sel=
ftests-net-forwarding-20220707

Sounds good then.=
