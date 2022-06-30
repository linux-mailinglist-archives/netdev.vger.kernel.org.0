Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A128456122B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiF3GAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiF3GAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:00:32 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60044.outbound.protection.outlook.com [40.107.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992237661
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 23:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6Bl6yqSk1crfYc+8fkV0xVO6lB8M9kMeZXpU8VA+FL8Tt9oElTOjLu9HHuO38e5PMoqJ6OssPk3cV0VVOgVoXBHh0iwKPSWaWFytitOjNQJIfkQyQIbSlWU/7n5pBSa/YRSLTaccaa87GkYIFApqE4a99EYDv4VfxHUS/4kTNZ0dpGFGHeFwzVgTD3RaqQKQjZoBoSYlaYbdas6xBw4CnSILo/wMrV0Wd7eDzlsBDgTAUIfoTKFkeq6tHTeGH6gcBrHOgaJ7S9hbPJEHH7uLZ7QT9u1xUnKqkGLhqXA9nB5UeDDIvaBXpXonov5zUqbVwd6yZ8icms0IxmVYOpQ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lO7VLImBD8fhoG2cFzuQyw9pSvfMstcajzOT2kEs5zc=;
 b=NJ+lC7upFfZomL6Vy1H4eBdbsw/MdZ28PhDl4sOGv3l4x/hgqizK5vJ1mWYoxRkBejC4Cnt1oTNd0rpo2M+wVYYxMGxG9SXMgoMZMcm4BmYIXKOW5ablaN9WSNOiiIR+yVCpJdGhksJoZY6Pdn9K8SCSaYey9x8OzbX5u/XVslE/Okad+YKYprhhwWF6raxsYiiBbd4joUP82dt5V8jJBifn73cw7ORIyYKVxP9+7RdpclRifGrqKKuOngSeC7emTKj8lC7EPT7IHMUpOCjFFzoDl55Dh5u5qWoDLyEfVI9n/TXYoZKb/FSqTm0tJy+SSF6yhs0DRbSK1nRzZK7avQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO7VLImBD8fhoG2cFzuQyw9pSvfMstcajzOT2kEs5zc=;
 b=j5o/lQ1PKlhpv+ZjyH6coG7L5R1z97XXZQMxVrzq9FUfD/h/ko8JSIqosUwl8IQhyOnU/5hlb3/cJPSZAfMLgblE7qrTx04EIB/0gU4yzLkJT+NTE1fZz/pZq7esbN2o0+ftDLPJaF1hl/xaZM4MFFSv3ZILPb3Q2ng4e2w+pqA=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB5812.eurprd04.prod.outlook.com (2603:10a6:208:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 06:00:29 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e105:82:9927:989f]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e105:82:9927:989f%6]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 06:00:29 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] net: gianfar: add support for software TX
 timestamping
Thread-Topic: [PATCH net-next] net: gianfar: add support for software TX
 timestamping
Thread-Index: AQHYi+P9aZ8YW4rLWE2OTvlaL3T4ka1ndQ1w
Date:   Thu, 30 Jun 2022 06:00:28 +0000
Message-ID: <AM9PR04MB83975BE2F8FEE594D31F77F896BA9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a5d9c7f-8dfc-4cd7-f8c9-08da5a5dd5bc
x-ms-traffictypediagnostic: AM0PR04MB5812:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QIkzBvwgD/vA6YSc1dmzJfTYbteE4+zKbd11u/rcos+5KYWb/mRk6squ0xsRe92EZJa0DQyO6Cki1Zh/ENmg2kBZ3DedLLAUtn3TxOpw8hHc6ZNGyvFqzhI4gLkZFWkjYCTkOOEU8sWXhqnB3R84oiiNKNkSALUrEsKtt956pV+klTbb2s4OEFynu17HfN5EqjHLqoC7s6Q/FzhP1DToDo6yHVsH3TlMqtFF/TVo0yj0ZlbasTHnz51eGKJnDaXGISevKsEDbf2uN340kpaNiTevV/TFqK6jmFU+1Tjtt7Mwy7A9OgAYsyiO0ummlbrMFoupdxYSfILwBfnZApT0JtsR5Up7zWLLjICvFCTRL0cqZk/CwzXu7/gvlmO4+PFxnsB9CatXrYHTuzndVlmEyDawRCSk5jvU1xINrtIWXsVlim/XM4ITM+phxsgZZA6nknnlCKltHuWrLzNAKNa9MVU6Ty3VbJNY9eFdk0p4lEh81TuS9RFy9x8EnHZgC7S/SRbHWb0hjPdm4bkwrBFCmhxyXhZd/OefvtJYf9GmAZ87oOvg3N/oS6lVcU4cYNNclMIt8IzFlJ/C3Wm+nKc3hkrnNIvWzo+ODuUBrks8pLWXFF71TGDi2rSDHtSDhZ7N4Sme9SiTp2sxgyAiH3K10e47IMHJ+UT6OSxmUBbtZC/rAuT+lmqMgLIeRwuuZaNKO6dN5E3YrnRNfE5//HVre4dsOfYGgDeu39n7GhdY0+hnI3SdvQDXc4DT4DSixVlxPwEDDGojrklKw4nfYADFi4tTDgMYiQqQQVhZ6giP2IPqJke8GQtHRmwhmvzILG78
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(55236004)(53546011)(6506007)(7696005)(2906002)(38100700002)(33656002)(41300700001)(83380400001)(26005)(55016003)(9686003)(71200400001)(76116006)(4326008)(8676002)(66446008)(66556008)(66946007)(64756008)(66476007)(478600001)(86362001)(54906003)(316002)(110136005)(186003)(38070700005)(122000001)(5660300002)(44832011)(4744005)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qovTIp/fqEkmkychIGXAPOB82z2XOEEmJz1anBrBBmLffKypKOeVtK/fZGyb?=
 =?us-ascii?Q?JvxtAUum+eeN3meSRVkrKPYRdo5wd4M2n/VR0a3kOAXYmKZRaBfywkGkReek?=
 =?us-ascii?Q?KWOqBDKuMUU668EEYP6qEr2L3UxxCiYoE1h3JhdeDripCT68brgmRbVerRzV?=
 =?us-ascii?Q?z+zaLWITW99tj/EMAlLJQd2ImqOZ0BQOTuJS4XyaIQKSRGl7tuLE5Kn2utPo?=
 =?us-ascii?Q?RQRndM2OAHkeaMf1gdGycGhusIWWh4+zCZTEu02e5s4VdR2xTq+4BuzoD+h+?=
 =?us-ascii?Q?g/cyGYigaRDrLSW/pOFHvXUUMZvBc+hgYlKKnrDUL74Y8AOu3dR0xrzx4qca?=
 =?us-ascii?Q?gJaM6zAbupmvesI7FU1iYz4qu4F/WPsylbXqZ/dDRF+UXN9qFJu4e1rVMCYR?=
 =?us-ascii?Q?yjxB7DnAsKyYoypI9TDgYfpnw+CVnCMDIjG6aQSmJCXkRZuX3xqNt/D6Cu9F?=
 =?us-ascii?Q?/rCbQrosC586/NgLA2uggXXlVTyYIwebx0QUjVYs4QlECdd12XFdJWZliwKe?=
 =?us-ascii?Q?lEXLEubgBKqp/kEN9MDPkKr5zHFdo3LDgiYxgk3YKnTN8T9nQKCG5j8qJ3Og?=
 =?us-ascii?Q?Zq2Xg5flFp57BZckSh87wFf1PVmS6afvrlfshrGwKcik5XQ6/0k3UGcN+fOB?=
 =?us-ascii?Q?xz8pu8oA4AatvPw8og+5GTYYRBHyedZ1mBhdhkZPT83Ny9Mima5hFS+7uE6a?=
 =?us-ascii?Q?LvM7PFaUktr5kOluI0ua2O28YZUb7LWUdqZnlsTd9DuMI7aphf+o6pRCCD03?=
 =?us-ascii?Q?f/s2nSEpm0O4T7f4EfwQ8FNd/LKHBKTaqW/HWj/x2NXK5dETpxjRQ3vcOpz4?=
 =?us-ascii?Q?xS8+prV6m9DaispjlXmgmtynkjC2OatuSm17h6JTTaVGEHcdsr/czL+OAIoO?=
 =?us-ascii?Q?hCmbJLK+n/vDXFGaNUm/Bg9b2GXoRvCrbmFIgLnX2lE/q/btpB13QUqn/tlo?=
 =?us-ascii?Q?WnuosG6iqSgJp3C6KUQVcTo8LVdoh9+kuTTTZRWdNlejGbZOf0kOVTcm6O2J?=
 =?us-ascii?Q?V7o+ZsM6XL8+JlwU0qTv33kRC9YA0XCqvjpeKDRScZhucSP/lFOXVNDTOC6x?=
 =?us-ascii?Q?07xy/eayfvovoqPzsK8fgY4KOeedqoFru8ty0U/Y60EyKunpS2rnS1Mqm6n/?=
 =?us-ascii?Q?6xhZWcREMEnY4cl74MNCHlzIYmgIDQe+HKu/G0NnH+9z34kqZNnc8nDUBrhv?=
 =?us-ascii?Q?+KkLNUT0MtMEsCETscJqaSpSgttKaqyQpjDMbiDScO+jS+WFnWdjKraYGqtd?=
 =?us-ascii?Q?fZNmPazHSBurgV7bR42DZB/1TOjQiaWXqjiLW8Gh7IHYSZ3MLGOAIaVnJnIE?=
 =?us-ascii?Q?BE04+pF+QQoynU5zDOZtNGUHXBCE8WQ2UybN01PS+OG7drrGXLZdpeD2g2zj?=
 =?us-ascii?Q?0C7J4F5UAWm7CKS8e9DH1n9LGZa5D0UzLuLcY8USbOe9P2wRxsgmIrm9MDK9?=
 =?us-ascii?Q?3dazhY/pa0x9ljlogxEZa95wr0GZo2FCxWsEaLd0zsMWIPXPygft2XDU1eeK?=
 =?us-ascii?Q?74r1sEMe9f9a4QYjzWSB20ikVMoPvAFTjhP6m1nKnp5BLhpx5UvXORNjJrMV?=
 =?us-ascii?Q?21o3id+2BkYEFLCVG6wEk1wA20GGe+Xg/2RfPrsa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5d9c7f-8dfc-4cd7-f8c9-08da5a5dd5bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 06:00:29.0267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HtyvW+X7vI43MsWltnUkXbJxZT3OWstDslB5YA2DP6NcRPiLGK5yrxajO6nfj7LVwhxa62qzqjQ+2S18tmbR0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5812
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
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, June 29, 2022 9:14 PM
[...]
> Subject: [PATCH net-next] net: gianfar: add support for software TX
> timestamping
>=20
> These are required by certain network profiling applications in order to
> measure delays.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
