Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16B4BB32E
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiBRHYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:24:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiBRHYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:24:08 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2058.outbound.protection.outlook.com [40.107.21.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA325595;
        Thu, 17 Feb 2022 23:23:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCDMp1mKPJch+dzo2Gqg/Epn9m473F5WZfqD8l2Fd5/OnoorIeWcndsRebMd322pPjekiBeX24L2edFX3oqXL0z5RttimCueGjueofp+OYGXDyQmPwu2mc+ycf5YLG2giTr6LMSa64YsaVkoENLBTVKAn0SU1CUVWlBNisVoGl2KCZQPXn8sIzFD6xJxKM08nTsKs92IfYDXBmyy8C9xWa5IY1KKsQo8agiyNf068zfiYESCZT2MoyyTsldvZ669yCypsG1P9JqpYdYn6uegh36YQP4hvoBpByNoHNcFP9aSroFBTAPaEUU9Vs1Q3swhEPV4ItqLoP23zkITh2+a7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhdlqM9akl7IIL8tEcjDjrYWbJOajYGaqd8sDmeH0sM=;
 b=npb//GL5YkDoxswfWhr8J7LKLVOUhpxAVKHtkhIFB812BQnuk3rgewlaB/J1xhiJ1do7qw20nc6yAYINOsk/POJa4HF3Ze9IrDqdvOxp8LUCMHLHtgf94BPMgUMhT+hH/7OfVpB1oLWApPNJCdAT0Wj8fnfC+K2EYVLrmoMN5tlWbl9Lv0nwgHJ0aicQB3WEmrPcjnNdEclt275D7bkOms3iMMbCOLArLNz3U00cHlFhdreIfrsuNzRQBo7LiNARtSR4QXsZ3NWyAPUEXjLZq3l/swVlzYnapo7Fv7QX4rTF5DvzvJH06ePOjyYOT96geHed+g8RJolJumiqz256Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhdlqM9akl7IIL8tEcjDjrYWbJOajYGaqd8sDmeH0sM=;
 b=IYA9uaBxPDWENtUisToRyCgSKP+1ScAZMad2wid955zyhS/SugqOU0nwuGKrtVdpQBn+mg5CObJtj0vFClLj1PlHESZV7A0VcKVhSe8AZkbffAQjL1d6rBC8H22FJZKlt9oeFnSuW23Wt1LHg/ojUHDo3m0hX5Oo79facUaWOEk=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by DB8PR04MB6540.eurprd04.prod.outlook.com (2603:10a6:10:10d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Fri, 18 Feb
 2022 07:23:49 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::10c0:244:ae5:893d]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::10c0:244:ae5:893d%4]) with mapi id 15.20.4951.019; Fri, 18 Feb 2022
 07:23:49 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Fred Lefranc <hardware.evs@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Thread-Topic: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Thread-Index: AQHYJBi7im4VlVtoXEK5XJ+cBjruzqyY6EQw
Date:   Fri, 18 Feb 2022 07:23:49 +0000
Message-ID: <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
In-Reply-To: <20220217160528.2662513-1-hardware.evs@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49696d05-3024-4b57-4dd2-08d9f2af9bb6
x-ms-traffictypediagnostic: DB8PR04MB6540:EE_
x-microsoft-antispam-prvs: <DB8PR04MB6540BEB2727A7118E9435926EC379@DB8PR04MB6540.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VmPQ7SRyaigrdqX1n9wv+c4fX3+w+iqUrhvDeRk83SrFpP5ITSacOXq1AwJB7Jd+XZ3jj+gptBLeHxtt+Rc9jGuz7toNF9VlwlNpntEol5tPAJu1ff2iVIboEfaWlFUO26UMUuHDy0jAOe4OOzublsViON5f7n5e2q+XTlJzb0JiHMz0jTmY1D9pw19C9qJXUVMwAu2WzjQDawyYptYQJEKI9rtTQDJSeqOgMcLJ5jyFgOKL1pUeMxFF/9umOVR1KcmlhSUV0NEdBmai6GoXd7DLj5tV4cI86jPpo3iR0Ls4OTRby3nOGFK2gxvTfS6Vmn9OOMJohiNgiE74e3tTa7a1ayN2/XOzymiy0AMahr+cNWXIdMNltCmbxddN+r2aPl7BXhSnGgwB5CAUd9xKYWh0R39ZwKfNuC3xdR+mmpt+1Z11WfVOImThKW1OG9Y6xbg5Hk7iQdyrCo6v28GndWY3+B7PjMbKVqvt9H4NzBYVHnk2wNyWwGOrtGq504L+i3j1AmkwKC4rrhpIjQ6xVHZliHCeX/TQvAIHx3TfqmGGLuQdg2gFHdQo3CocgkLtBu9uBrYIXFgK5jC0+Ana0SSe0tMDIuru69vDuzRC7YHwtPpszGUTH+4/Di3Ff7JvBI4g1wO04dp8PIR5pX2s/qehbb2ukpSfjHniesvMK7wkafXzcGm+LlX+wd/FVo5rrAB9pP3/yC2mHweBfxh7qQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66946007)(83380400001)(122000001)(76116006)(186003)(64756008)(66446008)(66476007)(26005)(8676002)(38100700002)(86362001)(55016003)(66556008)(9686003)(33656002)(71200400001)(508600001)(5660300002)(7696005)(6506007)(54906003)(2906002)(52536014)(110136005)(4326008)(44832011)(38070700005)(4744005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rUgXTPnnetb5JYKJhadyBPr4YsRgArUfNlNhtvupyBZpT35D0VBlPqArykoA?=
 =?us-ascii?Q?3XNPemt/p3DMiLYMGcNXxTTpTKk/6qfAcROKbqKSkbkJi26C4ZL1c0RygArS?=
 =?us-ascii?Q?q3TnaUwOSqHgPnyOVFaZnmstjovMhW+mkhqH3mInHv9pVng4y5Q1Ros/B3Oo?=
 =?us-ascii?Q?DDoubK6i/5X6CjmgNx25B+zy0Py9+nhah6o9gXcc5iQ++64JBGKFjm9pgmHX?=
 =?us-ascii?Q?kJg6FGHgPd4mdsL0nTj+/F1n25yGCYGfdhs5Ab1YoF+EwPQuQPCTB1LCTDJs?=
 =?us-ascii?Q?1Cpjo8Bo6ecKYuXb2QLiKQOCzL7WCegcIzMuU6huCY7stCQu4J3ru7JSmKbn?=
 =?us-ascii?Q?ODNI/iJ5qe4RE/e7mCdxHiZecbpxR2ZR+Hb+PlKYdAaKyklESls88aro36oY?=
 =?us-ascii?Q?rMSGGAoGB/CKf8hHTOsBHKks+pgLtgZvPfs+BIHwM7Bk2GjmYAPRoW0Lp/+H?=
 =?us-ascii?Q?AH3jefiXw8/+0pMqEmimce+lUu9ummAk7o7xxbAwNi08QJviYejaDUv7Mp2B?=
 =?us-ascii?Q?6lgPvNXu799HytnXgeQe3LDn1QHBxVlsmehGLD3ipr2nJ/lAvnr1ptt6wEdu?=
 =?us-ascii?Q?ocduZMhyCLIvRSrXOUoxfBJpyuPs1qrCulKnb9hJqR4nEAoAN7WgXQuHvRj/?=
 =?us-ascii?Q?wkUSUX6J09MdMbGSJ38sRCy8Lk6DZMQ/+AH6wJje4X5V/lCnE0dSqQf1/6ck?=
 =?us-ascii?Q?SeFcLx59v3i8aBFG11o/1z8X0SYUc7u+Wvg40mIKe7ih3r+eMS4J6Eb1XKBg?=
 =?us-ascii?Q?ctWpg4M4dgFsxGLxMUnvCAqWvgxDDnbQOIq7ZYNBn25JsoOoAYrdx3gQCUU6?=
 =?us-ascii?Q?RYwlIb9cr/nfu1IgVFrSwjXCAjLutDQSdbLJ3t8/JInmzyXg7pNgBtXgjwE/?=
 =?us-ascii?Q?FGXWwU5YawmQER1/Ty8nWns7CcbaXxLjYvP8wMdImhvNrjGyywxOOJAhg5yp?=
 =?us-ascii?Q?b/WqeiYLL2WKjdF+QAo/nWrxHC1zcsPezKlfFm3TWJ7cbMdd/tWgdYQqI0Ie?=
 =?us-ascii?Q?zEw04jC5f+a+rg7xl7K6xmoVtUZ3CJ0aidOd8wdGiOrTt3YUTr/5gmmsLZnl?=
 =?us-ascii?Q?9HfOKMA6RLu5peEPQ8uz1CYGwcZAALhd8LJiAvRXqSJabDezc0vQkqraapgn?=
 =?us-ascii?Q?YFqL7X+ufp+yz6/tyfH+BHHHzBckB06zyma7CW8LmRjumrBlJnLRiufGDdFi?=
 =?us-ascii?Q?Kp0rECM8nE2hQ8w28otvGNsRPocVAzi1glXD+kDNWr5oxDn3xyMv/NqCKnIT?=
 =?us-ascii?Q?2Tefd6HSnU/lYNdkNjPXBtcFFOfDvGoEvTOombRvlO6jmiZJn0/TXUGnpEty?=
 =?us-ascii?Q?352s1e4fLs+WfPV4ewGiWMLqaY5Yv7gYKndLMzf4hO2FUhCezCQIo+AeJmc6?=
 =?us-ascii?Q?w3uTWUNifejKfUAbV10RdeOK3C3msJ2i7n6RRsWx75B9tH6rtymNAxmKHliL?=
 =?us-ascii?Q?QAFGp6hB47RXzEejr/MhmfxLJ+pJfcwUiwVmx0w6pdk836bAvRwbvU2DZaav?=
 =?us-ascii?Q?b9h33E17cVNS9U29oPaznaGWTpuYV1vmNe2CW4J3Z14S7RHxIhl2lIhNM2Gq?=
 =?us-ascii?Q?nhfv6oE3UM7r2C3NmzyQbitRi5uWv0mgaYs8zJAWv7tSVf+iYjjLLL+hkt9o?=
 =?us-ascii?Q?Qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49696d05-3024-4b57-4dd2-08d9f2af9bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 07:23:49.4156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F9uxzMsYaciVB3OqttP4QB+bkQe/FPwA14qHQW4tE4Xe8E4Z/kW4e9s8glBVP8jzd6CTq1lNegTyZCk/dsVlFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6540
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Fred Lefranc <hardware.evs@gmail.com>
> Subject: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> rx_extra_headroom config from devicetree.
>=20
> Allow modification of two additional Frame Manager parameters :
> - FM Max Frame Size : Can be changed to a value other than 1522
>   (ie support Jumbo Frames)
> - RX Extra Headroom
>=20
> Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>

Hi, Fred,

there are module params already for both, look into

drivers/net/ethernet/freescale/fman/fman.c

for fsl_fm_rx_extra_headroom and fsl_fm_max_frm.

Regards,
Madalin
