Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CC95BB46D
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIPWid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIPWi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:38:29 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448EFB99EA;
        Fri, 16 Sep 2022 15:38:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipmTiVsrTxejb+mFZHGw59r2xjdx68H3+5PVl6aBdob163XgOuvGHDW+XdZxOIWQ3QqSKpk27dL/ZbYarLm5XhKcVoVzY43+1Dv8Z4j85P0m1yP3q1yznLI7jHTaH0ojzEPVDn41Q2T2jiFqM0mglP0t4YJFzU7pU1VohhLP+rDGMBuhBpX9vqLkXg2uo20XX6qMeEssuye/bmSolxeAn092nuiS6sU9FIiHv+Roz4QFpEK7Yb2iKgO7JiGL4N1Pobsz1FyUcY4IHZu1PHyAvU98dh3phS9IORk/deRLwQt0bW9IER/O4uQB61QkxbFuw7kdExZpCad/Efozf/v6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wk1E4g/gxxxemncVr/6Xry0UWkUz6H8l6UGCnb0rxt0=;
 b=fgxkQYHUPcU8j+xPFw0jae5AzcFYZZ52jsshpqHAEhQdct5Mg2U3QNTMTPSaVgXOfBdady3CYBnWKZrY1RR1X8LwVfsPIlvpGde5G6suoJGCKmLWJr2M51e7VO58BKU5vqqAiGavhaTZ2k3zc8ze1SNpKKu01WxpseT6LQa3oqFKIAcq1grc8LTo3FK7oPTSkCcgSczrmexYzI02TpngUmiwteU9uru9AxTnwh9eAGoTTjolX/Q0oxzWNbxKHzC/24RMylkrelM7mfmsKp+OOgdpaHnbrzEVwLkDyL6V8L0QoEIxhchJA3olJhhEDS1/siw5ThU5bAWX9ttYyQGY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk1E4g/gxxxemncVr/6Xry0UWkUz6H8l6UGCnb0rxt0=;
 b=gIwAU20VsUjtgNkuUsAVgyTrMtEkj1/H9g/zxpvceo1VR5Md6LL2nnz87iCB0ju2uVuqdsih50BM9sH9yNIqqas8vL5ZSZqlJsoRWSFrDp/SvhSfaLn0iFsFKxjtTDF/pXTC3GF3ODyX6swBXcuRigqJle7mpHty4e99RMvY9ak=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9340.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 22:38:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 22:38:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: utilize
 readx_poll_timeout() for chip reset
Thread-Topic: [PATCH v1 net-next 1/2] net: mscc: ocelot: utilize
 readx_poll_timeout() for chip reset
Thread-Index: AQHYygB9y32ONsH1G0+BLXD9AIyd7w==
Date:   Fri, 16 Sep 2022 22:38:25 +0000
Message-ID: <20220916223825.gblajpsyq5zku66a@skbuf>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-2-colin.foster@in-advantage.com>
 <20220916191349.1659269-2-colin.foster@in-advantage.com>
In-Reply-To: <20220916191349.1659269-2-colin.foster@in-advantage.com>
 <20220916191349.1659269-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9340:EE_
x-ms-office365-filtering-correlation-id: f1b8a28b-37b9-484b-7d67-08da98342b68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v4B9KBsahMExkBcLJ5tS/MQ2bwBscRQUHhek7ne9S9jlbvvXi8ByndqvyBOFzJXhw+9IMSPUYJrg4B3vwONlkRzeAX7bH9d+YYDsqii4sUsYZyKaBs9zCDsal2nQt4QdwOHyOD6V1G9ZDWqITUNV8srs1ayt0X+NOPMmMHAZGsQTZQ7hE3R6OjfdUR4X5aUnmy8/aHRrhdJW72ffgRA9dpZQeTZx7sq1dnVjXf84dmfQa7WoXLuJU1VszH+9QjBJZ0CaFDa9egzly/XPwSm01Bkokoh11nvW80AwpByaOuTNht52j74mNKTbM2MD7i3s8h5a6tceJ6FK/0ZFHUM/CbBtMctnSo/3gGXGgy6i/VCha5TGmTY2AMNPc1QMVw4ExszOjIZBUZBIWzDTaUXGm6rn5mUMIeEGlJdQFsYb8kJDU2HOqPFBSx6yLEeK5Y/hGZr96JbB1mhGFlyNnYHy7hs+YlnrEe2GCt3KfXhxW+WCxObXuxjntCxgwh3VVbpZNH2jKfMuXYJPFoVkHRXwtls0qkoitHdaTUPNxKoxgVCDyq6T2VheV7pGZHqbLBWjACHkuj5nLBM+Qijuo9c7V9QMAriMxw3vi0GBmx5ACKF1XnNQ1KWQxGSGJdUmFk2Xi6XU+tEV1JBOous7v4iIu+Tzb5JXzVN1gx7aZrgPmjizuJFLFioNrUH8F9WB8zoKRC+/UbhzNNyCfjAdUze2tsrhrZou9V+CgEFKHfRomEAJfG+HARnD9dbuy/z77d2lHLZvIrwpyfUd4kCQjTvV6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(4326008)(44832011)(66446008)(8676002)(64756008)(2906002)(76116006)(66946007)(66556008)(6506007)(5660300002)(6512007)(33716001)(66476007)(86362001)(8936002)(9686003)(26005)(38100700002)(122000001)(186003)(1076003)(41300700001)(558084003)(91956017)(38070700005)(6916009)(478600001)(54906003)(71200400001)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i74iZCYt6hUASEs7mxjNWpABmD2RSDj+L0MtcDaRBWBa2zG/9ZZaOBXAM9zj?=
 =?us-ascii?Q?PMMTQs486yHpigeKLQ+/XLdsvcbBjQJAsPrQD0S/1nRLQcl/vps7zzAi6hWB?=
 =?us-ascii?Q?HK/6NEs1eFimPrWYvH9WVTNrTr6hqV4q2k7/XCMScOoTCUcqtrXh9cfFKAuY?=
 =?us-ascii?Q?3aF2sGijeJPd+yZop4LjKSByy6t2JTbD1xLMEROvThYXS4FODaASDzXSI5RW?=
 =?us-ascii?Q?F7U7jFVQMRsN00WpX6liKG2pI4EJi2NLwTKjo4VeQXIL3VLzbXMKJvGwqvOk?=
 =?us-ascii?Q?dUHzvX1pQMN+z0FnCM9tnc6lmxT8sYOGBlhKLYqMp9H47aGXpgPEaAB0gsUY?=
 =?us-ascii?Q?barNtDRA6ZE9t3M9+dyk6gdQ/AGc/yP95Kr/6SOttrLXxNMk7xZYdFb9ZzD3?=
 =?us-ascii?Q?YSv4vbjjQXJLw6F3Ph53fpbmRJhvMB7glCE5hTTAsm6UJwlw1ol7O+Y6pjka?=
 =?us-ascii?Q?vq4PRr8EYuBnYXKAN4cTl9E+dksJiz0m+HPgdl5My+yVQZgKvZ5m5ZWmPGAC?=
 =?us-ascii?Q?v5vBrN+s3mPSO+7GzM3+xFlOPXt3ruz/quun2t9vM006EJzBTWhiDoUUvXrP?=
 =?us-ascii?Q?rfF6slU0JBwcjr+nagTR7mlvIoXMkhcfY7jAykh3A01bK/trvI7PBbY613Qj?=
 =?us-ascii?Q?TOVwbj6bqWSQ/VewFfQ/Q5ZUMB5mnHnRR+ucaU8LMDVFuBYVbfoFNjW6Tiah?=
 =?us-ascii?Q?qUPZGLwiu75h4/vcC/m1DaxIs3u2/UzdC3aNucRfLuOxoZ7fIHm1ucEgzynP?=
 =?us-ascii?Q?WYvtt56xnxY0dIR+FpWT2o5iKRtWPZfNwfgmt2M50vi27LaVM3nCfH4AqRsm?=
 =?us-ascii?Q?XZ1/pqGJOzt8cXaJj05/AuvyqykkrlQvKuRVnbUXrEDMFoZ7BmOhVfQsTNkO?=
 =?us-ascii?Q?ixGjm2OkR7sA7ScBaPipaev2T6nMrgAN0I0idJ4opvCN+l4DqeIhzCh1/jFK?=
 =?us-ascii?Q?h5tIKZklwVvvyYYALXSexxEomA2KFy6jP3os4SM50vVcg1jLeKIIchEZxMu1?=
 =?us-ascii?Q?KxVpahazg1017Vk8yKel7b5gPinOPo7II6yq2kxY4DoCAHsuRmPMMiRB74OT?=
 =?us-ascii?Q?KtaIVivg2Eod8ps/UDRNCiJuxs4LqJpmJGesNDsWTKFKBSJCU+q/KtR9BvYu?=
 =?us-ascii?Q?PD11hRCvsnjgporOAzDWG3FqFgHlm7S16uYAG5NtAtFk0F5r+6ZyBNDzJObC?=
 =?us-ascii?Q?p78ZsmegRw8cyi4ZempES0KWByw/1xLmYzwIj74T30MTPbitF1y5Kt5FJ8kn?=
 =?us-ascii?Q?vDKGJxoL0cJ6aNDCMqrX1yNcCwh9wV/gpJwhlovjSjpS4LLemEHnOzvXbrz0?=
 =?us-ascii?Q?KRRalh4bKF5TjjucrrhEsei8bh/icoDtKYdGE5Zc391Ukr3UDvx7jV1ybDw4?=
 =?us-ascii?Q?Gm3/uvahnTVmT2LEfUMSX6EdX0kwgYDVFVCyr9gnNYZVEk8MxApwsFtX5Nn2?=
 =?us-ascii?Q?m95Loz4HxNqDjd12zyA2fqCcste0gCfJaE9vY+XHk+FVEYW7GeD7trrxkUaJ?=
 =?us-ascii?Q?5iYMg+ogSt4RX4ejfGiAqinv1KZSOnSllOCAUM3yOzQW4tSfhT/DcT91Zw1s?=
 =?us-ascii?Q?hi1Y4cxCW5U3TgHFMysIK8ZAGiqzLKxfgyq8qHOjQ9LJLYviV+4u141pr8ml?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11CED4B241FEBC48BB09A19D28908220@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b8a28b-37b9-484b-7d67-08da98342b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 22:38:25.9711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxYHemh0i6bZV/l7AnzY8rl4XxEifswZRM8GAj3NdACtfEpHAdljQ/+Iq2P3UY8n/2RNBehFxi8bBp93grv+jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:13:48PM -0700, Colin Foster wrote:
> Clean up the reset code by utilizing readx_poll_timeout instead of a cust=
om
> loop.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
