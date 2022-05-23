Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F5531F3D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiEWXdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiEWXdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:33:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640F677F23
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcA6PcuglGIZ+MzYPUGBT8lzOLPsXAXk7WAkoG2qpA+hOiLeXvdgp7fA7ZmR5iI67Lyu7mr+dPdQe46Pasd9A8qowIZ3yILle/ol6DE0qODrPLlWyC5IhPKuwIkAN9D47Troe/XjTIkcjetpkFyb8MNIcm0HcF6IRNXGDiCELeLThn5j9KdUjn2PRglsktbjN1p6t/1Zckyf1jC7UvpmTeEaT92D5oblK5Lhu1bc0g8Guh/5A7juA+3AwZL2zRScdDACWrbk6wP9FoKEWj4+Idn4tT1W6U2QydXgSOjuADuQS/QYQaYnOdy6O1JmpSvoHplB/4nFXBKhysM4SivZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZEbY4oa9mlHvaaq/DFVLMwb/QD3Nda/CZbYMRgd3ZM=;
 b=TbYZHJmnf0GO4bb1LhuC/5q4VByoKxyzL0wS6xP1Tk0QR+CJzPjemV/q44v9SQQ8+iEezntq/f8vL06ZsWOdXJMNia60sscO8dd3B3MskcjBG83G0Ofc15/T+k8VAXg+g0mQojNAgeO3UFG15tnRryntxMlNUWQWPfCKoOk+30BLDXhjnO5hEi74RmhMHCUtmImp3N9fRX8HE+/TwpdF/sutU7RReAbiJElO6NUi4JIyVZPVVfjlJi9qUJl3UES93MfmF6C8Cgj0Pj2ysSq793dwJmV2SF1HhWiK8QtIRIIydlMiX0R/p/nvD9/hVdPQgFlW5KSI86G0YGjDzbQnaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZEbY4oa9mlHvaaq/DFVLMwb/QD3Nda/CZbYMRgd3ZM=;
 b=UOGnKSf+F1AFhV1OkgtARczzmmIKPLsl5mIezFUnGQ9Qt6qXCenfyjU1+t7Iq5cEtNGGSeBn6H0Q4ydda2KudNaHdtvwRGcErV79tLmyFGCFxQLNxDE8PJfRsEDt2TO4AJjr8D4qoALPFyuYC/vM/aNA4+uPKdnMbEi0yYWYAVo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9647.eurprd04.prod.outlook.com (2603:10a6:10:30b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 23:33:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 23:33:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Topic: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Index: AQHYa+cqehaWXK64WUeB49V4C8aceq0oW6eAgAEUSACAA3WRAIAAPb8A
Date:   Mon, 23 May 2022 23:33:39 +0000
Message-ID: <20220523233338.tmwykgwutoigurnu@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520153413.16c6830b@kernel.org> <20220521150304.3lhpraxpssjxfhai@skbuf>
 <20220523125238.6f73b9f5@kernel.org>
In-Reply-To: <20220523125238.6f73b9f5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23e42ccb-9c81-43a3-d7e1-08da3d14aa33
x-ms-traffictypediagnostic: DB9PR04MB9647:EE_
x-microsoft-antispam-prvs: <DB9PR04MB9647AF8BF205CBEC890341D9E0D49@DB9PR04MB9647.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8YNY9Dxkm/i6FHSS6QsY9In8YbAP4KhSGRDtjTgGBH3yoQTp211TIdmraXCxT1Ms/1avzK4Stl8uOdN58TPgeHNrxqgnxyu2At7v9LCGKobbHD7aQr1XNmQBq2MNPvCAsmrs5BET1PwzAm3jSgmvDvjr4/K2UTd5PBEk++PKt+aqhWWhsReqgJC+/Sgmu9hs9pKFZafe2TRUFMfHRHTI7Wz6PtKW9e25WT7Mxl+Lak30mti7/wrKaA5IGOHQtFn6HXUqf2w9ePJCtIe0LNrrxjd8ExKaAVAntvFDGQAQ0WBh6BF/sTtC/PcvJmEvJ5Qp1nLhcABgtHTj9AmOd38+bPsnGVYcDh13RxUJycp2B3kQg/afcdFyGYRLJOoYh3X2eycpt81soHadJHYH7mqVL7LxDq/WryMKSCRdCytJzLi8RflsCN869QPIH+37B2Fs7i5wBs7X42tURuxvo38zqCfR7IKCxyDyBACyxfRzm+VKcIyQ/7GbwRgxTDz2rmp2u+B/4A2ljyUE1xFclbHVmw5407J6XLem0FS10sdy0l9mCM+A8h5m4auvq3UD74bn3I+cfeF9OYez+raRbfN1kYzuoVR7EoXttJv275IgmIlonpcQEFxFPPDD792EV0oOKcm2PRHCjStjNYIFMpVAuZ2zA6UvqlmDqtJC8HGqnABevELBx8GyjCFdB1pO5ffti0MDbiOtGjfGMf3uJI8jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(71200400001)(38070700005)(508600001)(66476007)(66556008)(64756008)(66446008)(54906003)(2906002)(9686003)(26005)(6512007)(316002)(4744005)(44832011)(33716001)(3716004)(8676002)(66946007)(76116006)(186003)(1076003)(6486002)(122000001)(5660300002)(6506007)(8936002)(6916009)(86362001)(38100700002)(4326008)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0mtJUOuglK9S91EYcJrgMoEOa86dcdeQjtvQ0K896eL0rJbVk2ANdGmHQnzC?=
 =?us-ascii?Q?q+Km4gMNN3XQRHU6DC6yQRLmQbMki6eC6BQl/2otUPWyK7EoLNYdsZiHBxlV?=
 =?us-ascii?Q?9bQ0hFDhtG6Ebfbng88VbC1WV1pv4vyB/by1AuGMZIBgKQ4GykMNY5KDSzHG?=
 =?us-ascii?Q?CF5JX2TA3DvWfMrUzS8ueNkcX13zGtjNkG8yH6LzxeYTcC3vDefizLp6at81?=
 =?us-ascii?Q?U5AZ3T4JKeqClDKTsg7nQWr3RiyRyT86GROqDbHP4fDx6Jm4qZL3zCt/gS1b?=
 =?us-ascii?Q?j0d3daF1UOncWKi6gJffh+FcYpK9yqlo3pqGbSBOH/BmTDuS3B/yjjVvHQHo?=
 =?us-ascii?Q?mC3Ili/dIsmbB7QNj4C8Knd4MSUsoWAdsxEwB0ud01Ag8TRytav3ieB+ep8v?=
 =?us-ascii?Q?f+5rEPL8oQEtxj+jWbp7BvD7l9LMZNI1w1RNx+89QJJnrc7Av/tdoI0TEAeN?=
 =?us-ascii?Q?jbbOMEMX2kF3gLcup1CSYrA4H8y0b7QIW0YWiUn0kasItcqdIlz/RUVTrydr?=
 =?us-ascii?Q?R9H7G4YRMN9WoIwQ4jRJDDAoO6ECtG9BCIvmGmZkulElAFFWWB/+sg16tg9J?=
 =?us-ascii?Q?icmEHS53eT0SJTAbPRVeO8Rza2FkPyBOQCIRvccY5cJtqH3U1SewiVtheGqz?=
 =?us-ascii?Q?P+xbrFBi3LamAYqbwS6Utf2PudWk5ZsrOp5UYORrzrFxSjKID/08/ejTT51N?=
 =?us-ascii?Q?ftjGLOtfcPKBfh0FXkVgy0/3IllZrPxCbFvx+Mfk/fjm3rDAbPg5Cv/oQLt1?=
 =?us-ascii?Q?G925VQ3PiFNVr6x226BmFZjLRt96nTydxt89l+/EsjP9XnZRDiHbcSP9DdW/?=
 =?us-ascii?Q?uwMH0sDYNXA4pcMZOEjxQWIMgV/BrAnSEw4sWKePkXgQM8t4olrxC+KO4PYq?=
 =?us-ascii?Q?F7vxUq0nT6ZIXFA5OdRZP0FJkfwwDpOOedyQeDqZA2IOVqmCEWfptDF4T968?=
 =?us-ascii?Q?prO0XA+5WHaYL/0AOzzaXb5GgkWgTXDW/1/MJjth9P5UbUMF8qxqra3UyoEB?=
 =?us-ascii?Q?lgIdZO5yODHNeqOvcN4JhmaitKYjXx+SUzqTunIDRaKqXFMCux1RZBAtszcZ?=
 =?us-ascii?Q?KVqaZFNvlgRCT7SeQ0NEnWjj87ijyOgqPbGqhGP4ErM1qto5iyMaZmzFKIHB?=
 =?us-ascii?Q?wORZn062k3WNhws9TzpD343T71NhaPxei2xAEcwpGMKYzCNLpOAAEJmfCOHH?=
 =?us-ascii?Q?L6CgEntZbiqnEdgmCVwlkDGMSCn5DOunvaisG60pAGtw7WuggQpQ5uRdocYa?=
 =?us-ascii?Q?ZOpeyEzI6jP+R/O9yW9cdPyI5PrYejrzSAqt6OvoGPlPMgbsA4klKvKuTaSl?=
 =?us-ascii?Q?1yzXdkG4UsDo0lsxJeaAfwGlfkfeAY38W3cwuLvX+EcT3QtkGkkPLFVteOY4?=
 =?us-ascii?Q?5QFeOnac1759hvnLZa5QPscjmKSjklWs226zicDzoX8Y7or7hC/cIyfFIgq9?=
 =?us-ascii?Q?O2DCTYlKTYdoo0VZ5FO2jXpmxbdBfCOXbPmJGhB5hHhYraL8Uusm0v+6skW6?=
 =?us-ascii?Q?FIpZ9QrRwPnXd1H4g2XXYABFumi6dxblRMotEeVIIpGNt/JpG567EnomwwT5?=
 =?us-ascii?Q?8yCjGZbNL/oQguysicmKMnzl2FSRUyjni6fcBGd5F6D1GVubqZmVNd74oMPR?=
 =?us-ascii?Q?XN4ZkjygmoGYoLx47c4Y1G6f+UxQU1EqKVJA7p1JcByzAlJk6y+id7+RSQoe?=
 =?us-ascii?Q?NAkzLRNUR56vjrcYkDPZd/iARr5LWCQT22jLOavuZZjOXy1CsCZ5TwNO7hZp?=
 =?us-ascii?Q?BLacOc0xDm2rEmb0bkAIpgEHpXzPDmM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A41A6F5753E81A4C9FC38CA60F7DAA5D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e42ccb-9c81-43a3-d7e1-08da3d14aa33
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 23:33:39.0354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5jB2HfuOnFshwsHuoLz63E2TKHkHrQW9HUtltjFgMxh7R6ezRS6BB+hUTgvuSFpOJRTIdOxHfQaTG+xsDwIFUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9647
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:52:38PM -0700, Jakub Kicinski wrote:
> My understanding is that DCBNL is not in ethtool is that it was built
> primarily for converged Ethernet. ethtool being a netdev thing it's
> largely confined to coarse interface configuration in such
> environments, they certainly don't use TC to control RDMA queues.
>=20
> To put it differently DCBNL separates RoCE and storage queues from
> netdev queues (latter being lossy). It's Conway's law at work.

I had to look up Conway's law, now I get it. Beautiful euphemism, thank you=
.=
