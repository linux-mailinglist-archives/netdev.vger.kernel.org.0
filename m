Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3A599D18
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbiHSNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348496AbiHSNsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:48:03 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF7FF997C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 06:48:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUpdYPTJLx2x5bP78uEOY68Ecoq1v73ZAcKSvHXoeSwk6/0yr7hZ2yBzdhC7beF6jFN6mt6K99JSWQ1shHOKv2ZXCgvheKJhDV2TOZ/ciZZJtkWZU6l323yq4oRjIWYOGHwPyLG00m+04W+l2sOP2rNS7h5pBWu8Pqx34NBayuV4fnFQQluF8Az2sryOBRtrNAUNuYHryJvg4Ienfk1FeNy79ecFEHKJDfH6U0HqtoQk7yiZH7EV/7LmNN1Xs4Ito4rdv6+tEMRMdSBiBE3JMMJbOwqpULWCMiLhJie+ZPOsloASeqde8UFDy8CWhOCgJx1UrwwhmPdtjiG9i5PPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36HO3eOkJNhz/ae45W7hBbrlpypd69fuEMxQxf55LK8=;
 b=ItIjyLSYtEDJxneySU2zNp6OaGa7D6ZLDXguB9FlEbRgctfmCac/sHIVXUW2BlJnbHBqRLs0TH4qRVsYJ8uZOEHlGY3le7dmDmu4gCimfkWbdViRid2KtIopilnFeOyDZo7u1UUTtG22Y2nsLwDdMvt13kOPbSrKTmnMNQQHydWqb0a9nv4SYs8gR2CybE8tgBysskZaLT/Xih99N4mNDDJ/gi15BnJiCbihkiXY4yQRdPm0a3h+UZ5QMzA3PS5SWtEetjnsXAIZiAljrEd11D/DE3LsIaBmM9LrepGg3q+tX/3R2OHe3UVtHkotsOINMoiTcspvSgp2g8zHGZS0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36HO3eOkJNhz/ae45W7hBbrlpypd69fuEMxQxf55LK8=;
 b=I5FkvTmDt5tvNiJAtEBUYytXS+xzkAhhIxVTQRqpAeBhCyXwBLMSw5Z9RXr79wXkchgibnp5iB7Tw4YWhBTtcLn8slA7rCY0YD2b/7i1IJ+nwig7347QkZkdbTE5oTb2y95zS5Ex7dp8HoUmW8fIwFyUiStyYh8UfmT97EWuJEg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6409.eurprd04.prod.outlook.com (2603:10a6:10:103::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 13:48:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 13:48:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Topic: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Index: AQHYswnglvLyEnQT3EOaMpXlfQkMiK21me4AgAB3bYCAACpYAIAAAEuAgAAB6ACAAACdAA==
Date:   Fri, 19 Aug 2022 13:48:00 +0000
Message-ID: <20220819134800.icr3qju7fdfdm5oo@skbuf>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org> <20220819110623.aivnyw7wunfdndav@skbuf>
 <Yv+SNHDXrl3KyaRA@euler> <20220819133859.7qzpo7kn3eviymzo@skbuf>
 <Yv+UDHgfZ0krm9X+@euler>
In-Reply-To: <Yv+UDHgfZ0krm9X+@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f2d5ec6-3c4f-409e-f57c-08da81e96e72
x-ms-traffictypediagnostic: DB8PR04MB6409:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8+lbb/sgIPMuETjGvKSkJnIWHnz0PMm78vWkKFrsAdaqbyvNdVCIUP3K3hQiioek22t5GQ7qviQy3goDooONlcLB5m86IlS39hat/TV1mnaJQTYwuZQ7OKZQGIaAffCjVdm4Dxa+WM+RMTEjJ6GFCri4cZzzBwOaFux+KmrjPsEX/ZgMRnWI9uXwav6bUwj+K31IWckJ2Uyxi3kkV2FFn2fNQawL98jiYiZeWQ75/ycizZiUeh0mSg/KC12nRNiDUTg23wIjHAXycMcKvIJhwQ39CZBZtNJSVs8euSqggZ5Jkvzn1q5HGwFwhJWCP6MjEd6w7jabu9ULwnkzhqgBvCrINaTo1zT97bQzkfTX3oD/QoZFMHoZPJoDIA0hvRlJoXgEMhi9prXvA9o/4zN3zYd1lZeIxbtBjMkk25OyAhIaIUivRfxsdZImwsqJlgg6bpE5/WmQW29YaSrQO9yGZ80n26VRvk37+bz+NH8Kgoq9Rn9n+VrwKuuB2DGYpWfxHHJ8BtnquIuFdS0kySK5GgHq96eOYMBtCYvKxbGMMOC9DjUclJxkEJFnBcy2yuZEVQ7M73p5yLLVa1LvhbwjJmBcnAgC5UGS6BVUns8dQU9+2PXemVU2+G4q/tD74RagIjYyaVupaGc95/EBgiH8YGV0qYnL8gRDt8jou65BKUCYkgaLFG55WE4G/1jqUeKzZ4puTaDFWhg97PCZIkwVZ8QxFil7C0c5pOnctpS/Q7momIzMZ4lzkIuYjB5hwhY/bvv73hgNCXGtfa92/tU8ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(136003)(366004)(346002)(39860400002)(7416002)(66946007)(66556008)(4326008)(44832011)(66476007)(54906003)(316002)(6916009)(5660300002)(8936002)(2906002)(64756008)(478600001)(6486002)(71200400001)(8676002)(66446008)(41300700001)(33716001)(6512007)(6506007)(9686003)(26005)(122000001)(38070700005)(86362001)(83380400001)(1076003)(76116006)(91956017)(38100700002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V1gsyjFX6NQ2IJIf8LVliNl0R7h9ZFt736Iwgck4V7I0BYmRQ8veeE4L8zkS?=
 =?us-ascii?Q?pXJaTBG0SFw4T1ucLlGZdYqKUtz9AD13rKEKl/4IkKJeG0Q9Q1CabgtjMOCo?=
 =?us-ascii?Q?gql5krm3DlWdNfVPygk9nGV2GtTjISuty1mossaNWOt/9p0fowFAi90Vpxzn?=
 =?us-ascii?Q?NgEfZjOfiGhIx9O9kFyt+MPDamU5wqxVn4umxshRyz99yfhyF5/wQf111n+c?=
 =?us-ascii?Q?kdHG8D6RYGdnWQDFKXXDgP384JGPq4KfbCg+GugqvbNlY8EORGzCr5y/sY3+?=
 =?us-ascii?Q?Fa1jnXMM1C6ZYPcHLgvwQSJ50WLn+fyxrJm7cOnMpVvsqY4RhJiukFRiEXKJ?=
 =?us-ascii?Q?wL/CeYZx+UgioPpBqVQUmfl58WMbRHWy2k3s9RtF/n3xAmvR7OVMXPSkQeaK?=
 =?us-ascii?Q?Yi2YDgJ5CZD7gjSmolOq0/09cWaVJABmAbfGFNxPvmSqsZoi8WyfULjzf/ab?=
 =?us-ascii?Q?AjL9RspnRJntAfZ/bZUNGa5KBM6lntU2+B0sljBr8Tsk9CEUxa/DYlkalQ7d?=
 =?us-ascii?Q?EHXmZt9klQQVg25KmHHoswrdaPYDwOIa1srv6/OEEv2oGVFmIfwToCvCUq57?=
 =?us-ascii?Q?cf8fjb0jiIirNAtoy94rIuHGxefO7frfJduwBWR7Crc8ka50WI2hv6N9AMc9?=
 =?us-ascii?Q?MrV9HlCxaR9xY0CTku2F3cDWMV28LWSY7bhjQ+Sf+VUv0rLMvtLR4hG2ITtH?=
 =?us-ascii?Q?zTm4vxBMtPkoSLZ1zhaxxPGVXQj4Wr5h574F9xVKxIajM+FCD0hKeM2HkObS?=
 =?us-ascii?Q?7JcOi3Cn2pubkIJ1jM9L0eTmNqBAnI56vmswqIeHkYBGL0P89/SxMQGR6QAw?=
 =?us-ascii?Q?5M1HxWfOzCLZEl7ahM5e0jixvO3puA30wjbcmgvnzz08vLgNxMhXb9LGC+M7?=
 =?us-ascii?Q?yQwW92WgKF3PAgkvC0SxH5gnSSzxWQX6J6wvcS8R0jeKVNqZ1JLfKYKQ8HIU?=
 =?us-ascii?Q?vzBM4Cc5UuenBUMmw9kzlv4je3UtDO7h5aCY5h7jYTDHsxkVOCu3qJuOmptM?=
 =?us-ascii?Q?fbtzUGg1iOwS2LzdLX3I+iDBl0YZh0m43iSiPTstAFemBZQmwYyyuavcMMSs?=
 =?us-ascii?Q?/rVz80lNxuGyHbxwDQVjse19fHqtm7dIMqxdqQPj0aIejnWvJM0woe3/H1Pz?=
 =?us-ascii?Q?cBSzmnQ4uaEbVB6gkn9L0ndQHufb1X/LfszOzlT7+QnujhVvs3WVa35gqHPg?=
 =?us-ascii?Q?/Fv3Is4GXyR3j+/Io3iCMGDdzAY2o7Z86n2S8Usw5cVqjQOU3q1XAPycYYC7?=
 =?us-ascii?Q?IyUJC7UeX1/s00FyMzzKWVp/ntDyzWpCnL0YOXRchRTefo+j/zRnjlzcPZ/M?=
 =?us-ascii?Q?BZuRNVCOhtejvweY7yxhGcj8KmY+lS5SgudXw8tP7DoI29U53APlf1UPIuzT?=
 =?us-ascii?Q?I5BeSd6NbQ/xyO7t3C4tLrPKSVDOGQOxEqgSSCDGxU8//JuIFutjXuAm8vQW?=
 =?us-ascii?Q?GMNzgbpWgd+Il5AtQsLpCsGLXn238TqYMYrU39uGLn/Vy3Kc+izV1H/x+buA?=
 =?us-ascii?Q?EcFF7udXim64e6/vmDuvHdevX8xhU3mM8a46HjAXujnmywjLp5FWpWojMcI9?=
 =?us-ascii?Q?dcL6MI1J7Wsd+DAGSzKqwoPxVPimoUXTM39a0tvQyJxa8o/t4cGUVlkqcauS?=
 =?us-ascii?Q?WQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C1C9F555A5E1F409E14257E1A39AE2E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2d5ec6-3c4f-409e-f57c-08da81e96e72
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 13:48:00.6268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OkizKPUhpS1Jg/m8n6nUOpVDfnd6LHMKDHQ1xDXIPPiKGmUMJrxmhQF2nUjqGgeuctjaSAxUOQfbZJdbucOknA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6409
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 06:45:48AM -0700, Colin Foster wrote:
> On Fri, Aug 19, 2022 at 01:39:00PM +0000, Vladimir Oltean wrote:
> > On Fri, Aug 19, 2022 at 06:37:56AM -0700, Colin Foster wrote:
> > > On Fri, Aug 19, 2022 at 11:06:23AM +0000, Vladimir Oltean wrote:
> > > > On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> > > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net=
/dsa/ocelot/mscc_felix.ko] undefined!
> > > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net=
/dsa/ocelot/mscc_seville.ko] undefined!
> > > >=20
> > > > Damn, I forgot EXPORT_SYMBOL_GPL()....
> > > > Since I see you've marked the patches as changes requested already,=
 I'll
> > > > go ahead and resubmit.
> > >=20
> > > Any reason not to use the _NS() variants?
> >=20
> > What's _NS() and why would I use it?
>=20
> include/linux/export.h.
>=20
> I don't know when to use one over the other. I just know it was
> requested in my MFD set for drivers/mfd/ocelot*. Partitioning of the
> symtab, from what I best understand.

Odd. No reason given? I would understand symbol namespacing when there
is a risk of name collision, but I fail to see such a thing when talking
about ocelot_port_teardown_dsa_8021q_cpu().=
