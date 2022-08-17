Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCFE596F3C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbiHQNHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239729AbiHQNHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:07:24 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72B4DF35
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhtVasnt6znlcm993S/fTMA7QbYSKWmUoNcqjFVhnqDPyZLHoPrXgEhzqJ6HDkUz6rQ0WCMgtRfSRrqRDPhZXAs65odI/m+nU1xLxOJkfdmQeq14lTfrbri4piBaBHlYs6Oh8OR9fuThNZi4G8YhlVLRku09OygFuwULR9C4v9vtR/jFWWb91mfte4Y+6CZYBDUsg443dbVqjQB67UZnbXXF16q2GKfnrQUas44NdquzjD4AzddTKbICywQ4X4Jk0cdbVBQtH1WQf4MWQuwa17RYg8oMaUPTLWa/h/hz2xn5qAaS7nRu0Uvk74CVWO2wvnXG6kWUSeMP4sCDnwREOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xYBLSx0bJGA5jPY0CFSxmzX6DlLcobVb+3t06zV3co=;
 b=dWNCDAO9zsXiasGq+O7+rBodJRWGKfYuusvsN9WPn7rOjK8sT4D9zHhdsO2WYKna7N3niB+Qmzy3HiLkueHRmCxPbMUq7HhqLBC+7MlqbPNXZ3EbRg7yiYXijeb00wbj7dOd5wyV/Bc2jS9hxhBFephtA0tdFnZ00JsDOr03RtlDMe8hWjKOLnzMEClubil+s1NWQYFbH4vwNqKbNGTGT9biyan/LcckI6gUqhJBaKb2F0y1rgbVMQLVJSHVmFQ5FvbD7U0E22YfN87E0lb3POxMGSuk7J4nAbKDHslI6zeN6gfPOtMLj2A9NT7WyEkt4oBrWp1vBQhzhqBtVU6WHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xYBLSx0bJGA5jPY0CFSxmzX6DlLcobVb+3t06zV3co=;
 b=hl+mqIJJLrrWe8C4FXzwHpf9RdVvr3psxOmKKwLIzg3o5UD8tqmySyX6YI5DcG3xAHtrLuw/x5IeV975IwdXyTf6UEZyrrNevnDAY0uR6oUvlzs4h4JZlRzeMXUWLLcduL/7xXSWweLq6qUb7+/TOxGHY4bC8QVIrO1F0feifv0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4555.eurprd04.prod.outlook.com (2603:10a6:5:33::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 13:05:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 13:05:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct ocelot_stat_layout
 array indexable
Thread-Topic: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Thread-Index: AQHYsXet4txs5KEUy0mU0hPxnOpCE62yp00AgABIogCAACEwgA==
Date:   Wed, 17 Aug 2022 13:05:32 +0000
Message-ID: <20220817130531.5zludhgmobkdjc32@skbuf>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com> <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
In-Reply-To: <20220817110644.bhvzl7fslq2l6g23@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a3ba23a-7482-4e31-781e-08da80512a90
x-ms-traffictypediagnostic: DB7PR04MB4555:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NJY4d93csw3B9xo2v5jGUFA2EZvdRxGMU93UC9LsiKLbaz5vG+lofpcOj0aFcKhP0m5le6tEwcH5HiedKchc8L8S27xricoqu0kTHm+e+kdASIKyeBrO9BQMBkkKnnhrL9HYpzowsIX7XHVYg9J/LoMbClwJUV5IdpCn4XYbdBr98MtKndRKfGCIJN2hdzQPH8CoD5pCyDIWY9dIr4mldSdVnBd0LRztikOrS2ps5wj99m4c9ulIyS+/l/Q5jQrcpbaMszjorc9IEwdOP4ba+J2+kjGyt+XutWNCT3ayDvjs/q+4/5gFrrApKnPFcno/SrO4SNy4CTgTJzAZjr7KXt19sRscpyxp0e+AGygr/YhY/5+n3XRRFmKycfCu7tulmCKm1Wfqsy8+fOGZldLQwkVoRk0Es3Qsvyb5otU0ccOw2NpSex0pLF3a0VL2sLQV+PEmXfiFGl+ZVnv4u2/7hJaQAR//XxTJmbXwvlIUsWylDbWfGySKSx1po6va6mWIWcev8o953t7OwdRGOZz7/8LbgNdB3pSNo8vZgnYP+9u4bKuWiKkY5MGJj2LqNDoCU+FD8uVc0giFMfHlhIe2d9zD4gA5K8pZUciv/r6Bzi43fhBGhLVkJ/O6BGge9UyfIEuHqypwMKMIeBkuBsgUz8gp4T/7jCJb2EbTjTNxRkTiby8nLZy/TnYnDrH9D9z7v8j4qkutk4y8IJ1k/Sgt3B7YCeQmHsvc/05gSGFRAHgU9J+YIhZ9a/JnKS8VPgFaVNCAG2nlJjsz7sUHWHbw/X9uNcvX2ZJ9XmcwzeMq3cI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(9686003)(6512007)(6506007)(26005)(86362001)(38070700005)(1076003)(186003)(33716001)(38100700002)(122000001)(83380400001)(71200400001)(7416002)(5660300002)(44832011)(478600001)(6486002)(66946007)(64756008)(8936002)(76116006)(41300700001)(8676002)(4326008)(66446008)(66476007)(66556008)(2906002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c121VtDGeOdMgvvKaRCTKKUlELKGAWpOJvvYr/AZnjbiktOUthpL67OhyL5R?=
 =?us-ascii?Q?U9gE0e2dDSUV3nj5tROgUdpEb5iiruqrWJut4v7JFO449HrPU9/4WIPjlOZj?=
 =?us-ascii?Q?EHZlswoLvIULVsbYa0C5OXaazvZomT+EeLtwSUgOWjyzF0TB9nOmM7hs6GiS?=
 =?us-ascii?Q?SFfZBhKjpwy5HsUrjxplPglfcDRDIMPS4nXVrTeWLKj5JlbmBACNQNTe5UWd?=
 =?us-ascii?Q?ZkhouK1kFdeOMmjaHfHu5IXdmq8zjQLQXS9Zk0MMnd9LUapJBDp4BN5ra8Wu?=
 =?us-ascii?Q?6akNVN3eh8riEFmwyf9GceHSBtos1AQFFfzfwjEA43Y2TqPaDbfDY21i/Jvh?=
 =?us-ascii?Q?9BjVdm5UobeWu5uHRbkZHJjIrfgEwbaU2+aGdVdlDnTC5M872j8DPddZ/MAb?=
 =?us-ascii?Q?x/E72ZcSg9WHjKbuNW7ZIlzRJ3WkxAuNuWAfacxE0TXboA+iFvcnrJ5oXQ1B?=
 =?us-ascii?Q?Zvo4cPTxAfjgdsS148LusewX1dOWTpSmbe3c8yxa1iFql83SRTXTZW8TXbGP?=
 =?us-ascii?Q?tPtH1aQ/UYiZQa1EeFu6KuehubkRLccmjaeTUPkgyqdAxi7OKCCd7KRCqP3s?=
 =?us-ascii?Q?gOGUFaGA9WL8PkWBFHhrLy/Cs8jGnYSFGLhkbhAH9VIlzrEanq3V9s9lnwBP?=
 =?us-ascii?Q?sCEwjmureuEbnO472QJ7tgXyInVmToxajiGT32QnhdJL6wgMtXjTmIqG/N8j?=
 =?us-ascii?Q?QwloSNjaYtPc1PBavtB+on6FeGSkK/C0VGKeKW/sXX57RyTpVVeSoOUhR5/h?=
 =?us-ascii?Q?LJ6bheALCLyvuzzhE/oNJNBGqh0EYCRIVBqsiddg75UnIoDu5iV2wDb2WfJO?=
 =?us-ascii?Q?QzaCYWHlG1rBN/niO0923qD+Op+OzlAIDgaLF8APBUguJ0JMhKCibtoAjOqO?=
 =?us-ascii?Q?HpxGUrwW7hxmAV3Msjij5R9FvTl0xi0QVb4njJDbuG/S7JZBKJvXy3mI7+BH?=
 =?us-ascii?Q?AQ16O9S8gBKfp5uJuknfHoySqYKtRfw6Be0kaknKAPLz6vqO/pY3bWUA0PTA?=
 =?us-ascii?Q?LE1lp7yORZLApCD0GxzBsX+4x99miOs++Wc4c/v6lpN0/qN4m041+dFgdsZ9?=
 =?us-ascii?Q?YyYXI5H5NsddDmnOBub/42RZT2s+aq90zmClaoMuNYLrosdp9f1/8P8ISrJq?=
 =?us-ascii?Q?r4HORb9sSTYxhdFXukjmqYukFvwbSTNs736yfZQLxLWQicYJ/qIvx6NsfJGW?=
 =?us-ascii?Q?LdCIEoHuZw0OqWvwpdEManGvm8bV0L1NrFfie9o19QaHqXydWfepPpG0eowq?=
 =?us-ascii?Q?9AVIoeV4OFNVTTJM1xwtpN+XeMkAYRq/KPZEf2x61vvvZGHEglp6N6kFm8AL?=
 =?us-ascii?Q?vi0B55gcVfz9pGpPVWT+8cW56s+dc1kM7rz3LWxH3Ewfl4oDtIdjXVn0Hc1A?=
 =?us-ascii?Q?HNiazs4ECZ0UtPLNXe2DgRLlZPtT7XwAnF9mQgt0GaDqxnF1Uxo0HrFPu5N7?=
 =?us-ascii?Q?rAnEsoHUTnIADaL0eyPnDxBNqTOJiyUUiVhMH8tWm1ZqLnxUE8Ra2HOiEFDB?=
 =?us-ascii?Q?nS1OO+lCpyypdVEs9BdRwQJwqDNgs39AXHN9ojiydfk13i9jXXIhdy+Hq+6Y?=
 =?us-ascii?Q?jUTXygAF2JTAs04diVmZ7Owp4pa/tltTpyLro5BPRFOh2f+Xa2j/KJ73134M?=
 =?us-ascii?Q?ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9049A092A6010A4A8BB05905BAA461B7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3ba23a-7482-4e31-781e-08da80512a90
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 13:05:32.0695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OsLZMO6KSp+OjuKuCvlT7h6TGCrFbCKKZWy1LpEg1OX35KDRG1XlgP+oOaXBrFqyDApYB03y6Zgf7xyqs9itDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4555
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 02:06:44PM +0300, Vladimir Oltean wrote:
> I think in practice this means that ocelot_prepare_stats_regions() would
> need to be modified to first sort the ocelot_stat_layout array by "reg"
> value (to keep bulking efficient), and then, I think I'd have to keep to
> introduce another array of u32 *ocelot->stat_indices (to keep specific
> indexing possible). Then I'd have to go through one extra layer of
> indirection; RX_OCTETS would be available at
>=20
> ocelot->stats[port * OCELOT_NUM_STATS + ocelot->stat_indices[OCELOT_STAT_=
RX_OCTETS]].
>=20
> (I can wrap this behind a helper, of course)
>=20
> This is a bit complicated, but I'm not aware of something simpler that
> would do what you want and what I want. What are your thoughts?

Or simpler, we can keep enum ocelot_stat sorted in ascending order of
the associated SYS_COUNT_* register addresses. That should be very much
possible, we just need to add a comment to watch out for that. Between
switch revisions, the counter relative ordering won't differ. It's just
that RX and TX counters have a larger space between each other.=
