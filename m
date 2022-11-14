Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB5462839E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbiKNPPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiKNPPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:15:39 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B71B4B9;
        Mon, 14 Nov 2022 07:15:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5qp0qdxD7JHeOhTYFmGiJwJr3cf7/Fl6d1yYL1WZGKMtJkY0/DMIcv/+GlrowDNxugtg/nP1xj2UGsVc8b1pVNqiyeL+eL4NdDfheC9gZxTtiK+3jByoUcPo4Zo9OzYAJu8cfwnEMLzCZXVMQS53YLJQUTL3XoS2GyTmyPLZ4wuIzrGyx1rg4pOPQsJONkxvKZynSApGeCLLYZY6qtVWio8zCAxSmr+dNJQxCNrcVzjtYJKX/C3zysv2QqRVmImnolxkORX6EWIo9WtbMhYuQfug1DYvIect2DOi9eCmYHNVQ6asGqTXVoBIzDtT6L8JoEN+hCeQqZjEQRCrjIykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlxMmpiW5xJXSoFag4P/gJmWQeSPD2e7ElJZVvKmNhM=;
 b=LZdCb8mBCwQPmDvMV8ncmvCiiMzfTkbkiZ5OyGN96sxrK5RlQipuo800Dhd1o9AFOKuPWLwjMOLNcowoBt1/HUB369WF21RwWPS9eXa26CDCcU/bQYW5UF/3eCxvQd+z5DVhi/x8SwvIW5YkGBIlV9o2cWzXGYLSWd2fm0+WuAydmMOtZ5MF8X2eUymZ2ckL9n3xLiTvuM+7SyzfGYk6rokFmtLVj27mM/tyawRzB5FtJb5WaYez7ddGHBw5cFjcZMceuLeSRhE9AN9UTW1riOs1eTApLiREjGsdxAfiLOVlWEcjskgXtjHMZtkJ4jae3rgcEI1YCSZtTTB7i3xAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlxMmpiW5xJXSoFag4P/gJmWQeSPD2e7ElJZVvKmNhM=;
 b=UdD6DGjQkiWFdwL+t1il/dOaRqLKQuBZsc4KEByuuVSl4xMyM9djBd/SaVXD/9lojpGk+XXItMe0Mm4Z2SM0CrycF5A7LkUyecjS4zMToPZ0doLaxhTRDexcJRTC3H/M5SO71JNyCMzPSXSvwA6ICwFgL+bQ3mgaO7BcwFcyv9o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8355.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Mon, 14 Nov
 2022 15:15:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:15:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Topic: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Index: AQHY9g8iL4WNmd41D0+zI2HGRNCF864+i8WA
Date:   Mon, 14 Nov 2022 15:15:36 +0000
Message-ID: <20221114151535.k7rknwmy3erslfwo@skbuf>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
In-Reply-To: <20221111204924.1442282-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB8355:EE_
x-ms-office365-filtering-correlation-id: 69cfa636-7989-4a13-3fb9-08dac65314e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26WoNyPZinHZbzbXXKyavcKyv2DoVWbCfG/SbXNN0bcB8o3uC3Vm0wAMHkUQhoVsuNKgn6DaLri/YEm/9CdTsOSCpWpIIU1yCXOdOUysSUFZaNVnAd7rjsWVfTizsP8om8S4sUTWAxnr8VDdjtuechfGQFP4D46+gkI5IK8L0yJT5JVgHWE23dlwpc8frYdtqEE2tccpCl0VA/t3iznhUEagqsHtlz7m/x33gkpOrkLknTkgru3jYIIbrY5BNxwXDxMi6rz5DhOI3rZons8ZmWQXhmy378pI7emPskaOxs1cnejaNnMhpOgJWxgm8B5m2EzrPtV+izVk3ahBwCcrOZTl3Bhc4OnLSPJshfRoFK4mZ5keeEO8W9I6rmfGoWT8T+sQWULmUhT7Ih3XMsXj962t1CWHDTVd1+e8ptDItUxIE5+o8HN9tzMZZLSkYcdiuay3AJbH9BotO1yFqIwjKncmF+U8endy9K3t8R9sslD8Qlh0pY3vUsrkRFpmYopFDXVLp2zkW3wIEUvY0Ju5YgXjEhKI+goroR5MW1XC3/4fb9/ABlTPtCfKG53Giw8a8EksFCGdudVvcedcMYNiOucMh1FmBtKDz47oe41OVCJuFADdQ682YttUYocMDs8NCwKEF20glMu6UR5PhsGzRL7cmnqT/Hpxvt33vBAkKcBMcqLNF/ZJXq3caYOhsx+A9B/oh2BKtymzs1o7W1DqgJHtKgyp5fqiO744CvBl4TESEJ8zllhIRtxBnbEKZduN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199015)(6512007)(26005)(478600001)(6506007)(9686003)(71200400001)(6916009)(186003)(1076003)(76116006)(316002)(8676002)(64756008)(41300700001)(4326008)(6486002)(66946007)(66446008)(66476007)(66556008)(91956017)(38100700002)(38070700005)(122000001)(86362001)(5660300002)(54906003)(44832011)(33716001)(2906002)(8936002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pwqcPEqHzBQ9cR3/3PR3VNZ4R3ecrkmuE7W3WaSvspHC/Vu7rXDVzHclif8C?=
 =?us-ascii?Q?MVKeTaWF6T8XP/YM7O5PdLY8lGN7Y44YsBBICKzzJ2L50ieSdkTk3za4TYon?=
 =?us-ascii?Q?eV2hVMVFvUCCPmyYt5MleAuigM6iHkvEbP2qK7uYIrS5+QJ4i4JYQN6QDEEN?=
 =?us-ascii?Q?nKEnuYqQnczrVcSKbhyy2MbNlKtmTC2YJaMjJtq8PI5z+HjSxV4QfwUCMfrw?=
 =?us-ascii?Q?zhIgPiiRet9L9LS7Y5MzOnTh89ngFrE3TnnwZHNCAqIX3xHBh2Ohq2ItOVlu?=
 =?us-ascii?Q?UWEIuBQPmJfah4RjTgo5P+RJH267lJBxyMeegx4DS8USq6VbOQxJ/53XPlkY?=
 =?us-ascii?Q?z8ccds1QSVWkomMre/KUorTuHEJaEDtjpEy/Oq6M5tlaDyuIZlKfAoOiXXgZ?=
 =?us-ascii?Q?v0xaCbwGOPM2Ra70synXjKKyrm1RXVw9h97/YWVyo2KuVeQD85pUkiRISw9k?=
 =?us-ascii?Q?nC9Gch7rLN1S1NDQg7FRRZ6xiSBqoANXltNdVWwkcoSTJyoYfeE0gIPEaaMI?=
 =?us-ascii?Q?jjWyvg3wvSfCtkgJsRvCzkNW2XcC64WZVVWCXTAZSecYpvBpfXnv5s9QwGhZ?=
 =?us-ascii?Q?S+6PNbOeCLmFTvghQvmMspwmEOsZTvJqQD0psBUgv9wxM8eCmTY1Jd01sKXJ?=
 =?us-ascii?Q?p37hYc1+dqVWgDvlTbicLxoiuA5V+4lcMvFSzm/G0vQYGWYxVbuCx2SgJtzj?=
 =?us-ascii?Q?AZllA6d3GbiOGlJF/W0LlxxfEx5TZkqW3s/Q3QtQsTkU+wgwEodvMGw8EgqV?=
 =?us-ascii?Q?4cqUqAOvCFGx/Uh2L1E7xWLXPuJufugbS5cps5eaHNThV3kh3Z/4SG8mh16V?=
 =?us-ascii?Q?9syEOseCRGd5z05YfstuBFk28MW0IBN9p/4zXHhYeuBRBC3X/lD9nGY2p0Zz?=
 =?us-ascii?Q?S2JkGbslLngW9lZOlUBEdu9QrHhWqp0PRUDc8YtL8vAGOfOKdTL5ltGkdTXY?=
 =?us-ascii?Q?embhI6PKsAiY5//bdGCpUv6RVrJN9Aieq5UCv0dYFsSy3JsZcqmTOBkr5Pa6?=
 =?us-ascii?Q?WwItndq1/t35MR2Eb3b2RaLbB8qq+uRrmEFDQlrrnjkRlFMksj+24xrag7OV?=
 =?us-ascii?Q?5D/p5kMjldFIPv8DygchjREMJDFubhxLKNPL2C4uPifDmENnsdqEh7hPK13Q?=
 =?us-ascii?Q?YPZDYL2dwBxZN2Ic4NPu3hPI17DHf+jqnGKBwZjylqyChFU3POdeIfzcyOe1?=
 =?us-ascii?Q?SxwKrfqlitNHga9cW5nfj83aYfStFxFwgetYmxRUtZCYkNF491XBMG3aV0oq?=
 =?us-ascii?Q?QE1JVHYb1Tz0aydNir4dnMdzntyfUERy3w6NsaWHqUBP3nw/fVSa9z/2AUE0?=
 =?us-ascii?Q?T7geDwLgJk/NItx8sj2D0YxhIO6xAbvCcnvnOvycfiyq8wK+wBusO2cCFu1U?=
 =?us-ascii?Q?3Qfo1/dXWDUrniBbZOmEW3is6xnj/KmSLtLen4EKPs0RygXFbdOYMIXVLsbA?=
 =?us-ascii?Q?j1/cUJNJc6z++zi58MT01ceuf84UbAH7sZ1+sovc9kHZ4Pu/CqDYuBTS2CZK?=
 =?us-ascii?Q?z3Fo3/9QLGa9DWLQDvI02mgVgVUYCy7uhkmbSF7kMSZgZoucYh7cJPvTQPkW?=
 =?us-ascii?Q?aThV/82Tna6TDaRrrqBJgUpOgarAewn9XlW9yrxPrrcM0x2HFcsr3aA58Gyv?=
 =?us-ascii?Q?uA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19AA01A37D380E4A8EA210DB0EF56EB3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cfa636-7989-4a13-3fb9-08dac65314e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:15:36.0703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DUMDEUv4Quu6Q7e58WHbX5njbbJTV0gKAZC4N+ON7nj2IvgPGdz60eP9mSpmd/wFQvE/0vRrxoVredXw+k6Pmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8355
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Fri, Nov 11, 2022 at 12:49:23PM -0800, Colin Foster wrote:
> Ever since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
> definitions between all drivers") the stats_layout entry in ocelot and
> felix drivers have become redundant. Remove the unnecessary code.
>=20
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

(please also the Microchip development list, people do seem to follow it
and do respond sometimes)

Before saying anything about this patch set, I wanted to check what's
the status with my downstream patches for the MAC Merge Layer counters.

There, vsc9959_stats_layout would get expanded to look like this:

static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STAT=
S] =3D {
	OCELOT_COMMON_STATS,
	OCELOT_STAT(RX_ASSEMBLY_ERRS),
	OCELOT_STAT(RX_SMD_ERRS),
	OCELOT_STAT(RX_ASSEMBLY_OK),
	OCELOT_STAT(RX_MERGE_FRAGMENTS),
	OCELOT_STAT(TX_MERGE_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_OCTETS),
	OCELOT_STAT(RX_PMAC_UNICAST),
	OCELOT_STAT(RX_PMAC_MULTICAST),
	OCELOT_STAT(RX_PMAC_BROADCAST),
	OCELOT_STAT(RX_PMAC_SHORTS),
	OCELOT_STAT(RX_PMAC_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_JABBERS),
	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
	OCELOT_STAT(RX_PMAC_SYM_ERRS),
	OCELOT_STAT(RX_PMAC_64),
	OCELOT_STAT(RX_PMAC_65_127),
	OCELOT_STAT(RX_PMAC_128_255),
	OCELOT_STAT(RX_PMAC_256_511),
	OCELOT_STAT(RX_PMAC_512_1023),
	OCELOT_STAT(RX_PMAC_1024_1526),
	OCELOT_STAT(RX_PMAC_1527_MAX),
	OCELOT_STAT(RX_PMAC_PAUSE),
	OCELOT_STAT(RX_PMAC_CONTROL),
	OCELOT_STAT(RX_PMAC_LONGS),
	OCELOT_STAT(TX_PMAC_OCTETS),
	OCELOT_STAT(TX_PMAC_UNICAST),
	OCELOT_STAT(TX_PMAC_MULTICAST),
	OCELOT_STAT(TX_PMAC_BROADCAST),
	OCELOT_STAT(TX_PMAC_PAUSE),
	OCELOT_STAT(TX_PMAC_64),
	OCELOT_STAT(TX_PMAC_65_127),
	OCELOT_STAT(TX_PMAC_128_255),
	OCELOT_STAT(TX_PMAC_256_511),
	OCELOT_STAT(TX_PMAC_512_1023),
	OCELOT_STAT(TX_PMAC_1024_1526),
	OCELOT_STAT(TX_PMAC_1527_MAX),
};

The issue is that not all Ocelot family switches support the MAC merge
layer. Namely, only vsc9959 does.

With your removal of the ability to have a custom per-switch stats layout,
the only remaining thing for vsc9959 to do is to add a "bool mm_supported"
to the common struct ocelot, and all the above extra stats will only be rea=
d
from the common code in ocelot_stats.c only if mm_supported is set to true.

What do you think, is this acceptable?=
