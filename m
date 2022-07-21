Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DE57CBB1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiGUNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiGUNSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:18:54 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00066.outbound.protection.outlook.com [40.107.0.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5A97AC2C;
        Thu, 21 Jul 2022 06:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLMwyDJtiqVsIXS5FOrtsFAfdIw+Ng4WiEKKmLJDRsd+LxCy4pOVuKMhgmGIpeDnrC6zuAH54aB+deVNqMNj6QG/rOPM8baaECwAwuctv5aKWb4dZkK2oQ0jpJGxRMvKncrx5m8yeJX2bLXQ9CNe1Jw2s+cnXDbueU+/FVS7w1oHz83Fjud0OTQHntyKg4IH5rXEEf8/3rWwC+dEp5DMMIzQspvw0V67eOcVYbWaT3SPUaOTCuSr8ZrfeCbxhZ+RqMBe3Nfwo+rZuNuniv0SRaI/47tDvHf9keAW/nC2ZfrlTgV2eEzHTfxlPLjM5DD8dBxhDKElHSLhYMQKhVsnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9vXvvf/JqiVdkzj9isv8RbcucdP5DUzu8dpXGBmdyw=;
 b=kit0WC9q1RHBJ7/q+oC+QWMfI5vbm+xL5tGAjnl8vjoraf3fyi3cYjkp9Ti8+TnypXr02Pb0ooSW0DcD7d/tghpqqfigMufVHADWT8U6g2sHgSFGl8AaX/dq+kR7DN/65UNycrZafLW2G63o/38WlKZTdQEHMUvQ+m0F+tR+i3J3oRL/g8fXAKRrgPLO1qrVOG57b96qni+BLGMopub7xM8qiIx/D5Dii0mCTx/a230mYAPzWplxCLsuOFkly6ZvPoo7NdTgiZtGRiqKjy7yjpWFrCqOZahPJoYL9dIHW4K/xyc+TB3KSQ7K2XLF8DvjyI0twyFKpF40jsiHCusfeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9vXvvf/JqiVdkzj9isv8RbcucdP5DUzu8dpXGBmdyw=;
 b=n6ks++hvvO/bKth/eHXXStlTKqXv+GWf73HBzwrolIh0+aV9IYf2Wpqz0a2Hjzpp1mDsdwzSvIL3G+t7ckxnMLmJbiiOqbjarEW4Negr1xNtDSfSUy49n4XH4Jy+dFhOm/45NYl0XjiTYpcDg5MypLgbtZZJiaBPhMnl6/kH+TM=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by DB6PR0402MB2856.eurprd04.prod.outlook.com (2603:10a6:4:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:18:49 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:18:49 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Leo Li <leoyang.li@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next v3 38/47] net: dpaa: Adjust queue depth on rate
 change
Thread-Topic: [PATCH net-next v3 38/47] net: dpaa: Adjust queue depth on rate
 change
Thread-Index: AQHYmJbEBzDFq0faUUu0+f0xTCzeF62I148g
Date:   Thu, 21 Jul 2022 13:18:49 +0000
Message-ID: <VI1PR04MB5807AE37477A9E7669D8A10BF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-39-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-39-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52c19ca2-d31f-4c84-4bd3-08da6b1b8cc5
x-ms-traffictypediagnostic: DB6PR0402MB2856:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FzfoTObf+5Ob2LbzdotYARjIzy8jSjs9s9MdV0rLsu8dQyLmunv5qgwCkcTSFTcnZmTu01A5ipbzi68uVAMhfleXadawh05TTCXDlqkIp834SQYZLLszBoSmlMUIpiFJyhidmcgPn1xFFsNQay1pXXKz9amfg04pbIReBU1iTp5RZi1PRXgS5Qo4X8wNJBSq1UhdItF4WNFBnL2WZmY8rUedE0UQdY1qRYrkvfQK2V8ECb/E4rq22xDa+/sX9JXcAqDxQJdTuruWY4jVlFbm3Z7zxPk9Ahp+NVWeOM8QaADG04SgghrFNrw+OkaUKwJM1+cWL1GiD1QjqeYxGQ6z9MMzufG8WiAHUgDfJWwIPTtuRZqMa3TttVNGOSccwBD6NubYYxwEQygotrodS52hqWBdpLdKSBRwqXGZJ89T54/xbHPu95q1WV/FGiu4L6OLYkIqekHDG0fxlXi+NSolyDtH/Ni5pHZFup+UAg7JPLHGWxMrOhdhuh6dYfAD+5KdDblVTj9vtqdRwGa93pld/Tv8P43WSacoHOVoy90tKntsavtNeaKkF9uEvp3y0S26AKb+50xOqNBF3/+uMLyHVhqd0pYwiDMIG/LjzuuTxGrh/UBpYUfOsxuR7Sfbb2lPe1y7xcfePhAfVon4nu8XuutpF/mu5kRLGFMbsIjHYiTJw2lG3s0P5XvaNZkS5TlaaIy0VM0DqC4fvPYO9TtsPgHsom3ZpUe0FYn9djJWdHrulNiBjASxTfxnEJACI4w7HdgKsgrF5h/Cqs8c/aqqAHNOhGowTOoiOE/999k3yFYMfEvTJwNCzSl6FepIkWMO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(186003)(76116006)(38100700002)(55016003)(66476007)(86362001)(316002)(8676002)(54906003)(122000001)(71200400001)(66446008)(110136005)(66556008)(38070700005)(64756008)(66946007)(4326008)(52536014)(7416002)(33656002)(53546011)(55236004)(7696005)(6506007)(8936002)(26005)(83380400001)(41300700001)(2906002)(9686003)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rnAGFPbgMmkrllTwxKjYAz9tyOos+YJWWrL67zakA3Vsr6TVFT7PFJridRJc?=
 =?us-ascii?Q?ch0bmBBVLA6kkUqQmGjdlFlAajFI2ZiQq+xh8WbZVVeyE0XyTLBTHaiGV1Si?=
 =?us-ascii?Q?BnxSPTd/s2wYfBYSuhG52K0O+3NEwsjq/2x4LdYOzPQRd0SVLS2MHxWEhwn6?=
 =?us-ascii?Q?AA4BUkCFWKsP+GFHiZBQFQamKRMoJaRDPBEM0KjaRmdLixmAm1PgimBqOPuf?=
 =?us-ascii?Q?dtZbIqM7M1KL6FOmOI0BR80p3gyvehFwXtpDPsJYoiHLB/eoc01riwVX3rrR?=
 =?us-ascii?Q?WmNvCpcyr1XPUVMiKK4pbRsRKbsofbW0T6Grf/R5NNZekMdcXI9aMUi32o2O?=
 =?us-ascii?Q?s7kwDKwsT+FexY5qEjZxGIblt+ProR5tBgh+wmJ6snlYstnO5ZaTInQ84WD9?=
 =?us-ascii?Q?tm4oAP2hTHsmGyVaSb+oJWcZOH+uH1M+7Ho9nQ7dE8IRQr3Tb4+USLZGF+Lj?=
 =?us-ascii?Q?kP3n5UolfYqDRl0ScIL20nd7IBR9Y4nZigBXG3c3fzD9kFqZecJVu6sfg+bA?=
 =?us-ascii?Q?S5NMnfDbZ+W+P4NmZTHU+uWim0WjFDZTCdGZOewZb2URTQ2emKaOBS/nzalo?=
 =?us-ascii?Q?NJvb19oVM5AaDo4IrEzQpwpZXXJcsX8E9sQ6qdo719Tf6t/2QzJwb2UQtdOk?=
 =?us-ascii?Q?R13Ys1OpH3ODY5cnyRXorYRNZguIQHobnSkKwutoLl5lQH8YRxxkwTR9btvp?=
 =?us-ascii?Q?kDme5CDEfBGlV8KZewkmu6WuKcjakNNTQy7efWLPOrkbNixuEIwA+0ParTKc?=
 =?us-ascii?Q?cucGt6lXAn9rFvC3OrpC5+HKbSRcWUy/T3tZ7+K0v/M2C00afxPwYiSe3nEI?=
 =?us-ascii?Q?wYTFjhWW4HGAYAbFuqkjvZeWyWaEakrX9AI29FQ/idsguEWvw/H+Arl4CC0q?=
 =?us-ascii?Q?0NoaoyDyiSYUucLwo2/7xJsPstL9rmzuuKZcTHLXS/mb9VGpXylAWDn/rOHY?=
 =?us-ascii?Q?yTrl0swbf6V7WVxrpxqFnUEQzQfYIyrvbdDZ1H2FFJmH+TXmsjbGWtI2mARi?=
 =?us-ascii?Q?L8bj1Z2jWbVqpSwvps7HW8qvy/tZ/u1hHDqsN0PhNHqho5S+K19ED9G12KPe?=
 =?us-ascii?Q?Vs4zAhLef5haanCyVrepGEhbkR3or4CTAclcd7WPtdFqsmT+nN1N8RSve1gO?=
 =?us-ascii?Q?nvVR+ZPujaK+WkKV0vmpH78Mu67CWjCwmW7dz2Jk/eAOpF3s74sBcXKnrC9J?=
 =?us-ascii?Q?gHYLYqVZB4I6oQcrLs/BAjdrmnQzM/FGf+HgsL1O3h0BG9IGy6ahSAerGsba?=
 =?us-ascii?Q?QdzqlSCeYMHa1fuxvBqWwMVzswPxS3SrX+Gr/tSWi4KJg6OSqSdyBqQmjfCT?=
 =?us-ascii?Q?2sbypOqvbRPIy7njU2iSZ947klMyAkMa9687LuANDcjsA/j8SVUlnFnQM/un?=
 =?us-ascii?Q?CzQVTdcZLsxDudAkf9WwteSeVBEe/Cqd7n8JZg7v2fvERWirB4OEpn8vGCOt?=
 =?us-ascii?Q?+/nMEHdw9LAE1BwW2IM7M9LCxjH42KhW9fTkuPf0Onh2SzDEwkFXpvq00H//?=
 =?us-ascii?Q?AherZsqOs3GduC1JgeXiEkIzuGuXRiEwJZwyvESQ3XSq3e3cmviVe6VjDqg0?=
 =?us-ascii?Q?Dxoukeg3hAZ1YrIye3WtBp0ti36pXIhF09U3yByo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c19ca2-d31f-4c84-4bd3-08da6b1b8cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:18:49.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nl4hmfyjImK/SnOMjjlzq0cevq/pQs9w44q3AD4KCraBH+zB/lQ+6j8oJF4KwP9CDujfJk8/74fTjnXuyZA4ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2856
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Linuxppc-dev <linuxppc-dev-
> bounces+camelia.groza=3Dnxp.com@lists.ozlabs.org> On Behalf Of Sean
> Anderson
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Leo Li <leoyang.li@nxp.com>; Sean Anderson
> <sean.anderson@seco.com>; Russell King <linux@armlinux.org.uk>; linux-
> kernel@vger.kernel.org; Eric Dumazet <edumazet@google.com>; Paolo
> Abeni <pabeni@redhat.com>; linuxppc-dev@lists.ozlabs.org; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH net-next v3 38/47] net: dpaa: Adjust queue depth on rate
> change
>=20
> Instead of setting the queue depth once during probe, adjust it on the
> fly whenever we configure the link. This is a bit unusal, since usually
> the DPAA driver calls into the FMAN driver, but here we do the opposite.
> We need to add a netdev to struct mac_device for this, but it will soon
> live in the phylink config.
>=20
> I haven't tested this extensively, but it doesn't seem to break
> anything. We could possibly optimize this a bit by keeping track of the
> last rate, but for now we just update every time. 10GEC probably doesn't
> need to call into this at all, but I've added it for consistency.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
