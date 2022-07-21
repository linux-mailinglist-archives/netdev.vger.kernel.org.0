Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCFE57CAFA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiGUM52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGUM52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:57:28 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAEC3AE6E;
        Thu, 21 Jul 2022 05:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmNrN+7BCIYCZ+YpV7Yj0aMUvI2ELELHa41HzfmElh/2H99MIQJl5/zvG+4H0RbQ46i5JxfChxFPCbVGIFAJiXOJeXc1uPpIZznY91rjqqH3xgKuPvOSh+XMKc3SCHVQkF4x8lvZOSVxbwUv6OSFMvvaxvGyjrKBiWN2D5tednaquxA+UP2YZrlHkYtS4MDCMmgE8IkVpDhLY32aQMfho5rX/SRueRrvrSC3QZ3t0Hy53lqzN8AXj6wl4yr2gndDQyaH6P0bByjE2NSz5mc8L7eDY7Vkh0/KFEGcBOGLK/tjmun9wNBpL5BuvYbZ8kGMQEF4rnYuoLPrtFha8MKpLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHyGNETmzb+tFUYAzRufX7yTX6pI6itd8i5JOH84WZc=;
 b=nbdUGMpVPz5Lz/jRANzi3NqVYJL3fJPdYwvFRAlgw7X7pCM1Fuopgvoaxmna5++phkywt7/gMVUVJ9vfqIT8IO7/uXoCTWQGD/4nCsKJbCdeiTaaLl3dWuOLj4EiHPlpjk/vEFhjMpS7mux8a8T1Vrml3UaMK3woJ5hVi8jzpW+DaYpigtyiPPUa2SaNZv/HpIg5M8iI73PCR+3bI3u4JUKT+mMPUIhV6XRSwG9tx0uLYy2Wpdb7MRIJs9t92BLnffrZzkCgj+K+BhY7+qR6wMrvjNwg13yvNYsiBuP7O25MLtl0+qeWobXMCKC+8pf32r5v6XAE8n0X1RlEHQl4OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHyGNETmzb+tFUYAzRufX7yTX6pI6itd8i5JOH84WZc=;
 b=sUhcswvbBtDYbBF1Sazi5LibxwjyjpTHiRLQkIRiyLD7RO2wYULNXoronwf2pkX8qabNosQHV1sTtUSFkJpng9v+oq9/re6aQntJiNilyM9DxkkaFTpRETlhgIhGdMSrBOeV3D4eSEiTBrHh5KTBUEd0F4G2HcHKRcrwPj/Evgk=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:57:22 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:57:22 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 22/47] net: fman: Configure fixed link in
 memac_initialization
Thread-Topic: [PATCH net-next v3 22/47] net: fman: Configure fixed link in
 memac_initialization
Thread-Index: AQHYmJcWjZzHja3380WwiHyfuAAl9K2I0ZCg
Date:   Thu, 21 Jul 2022 12:57:22 +0000
Message-ID: <VI1PR04MB5807087AE0ADAACE76E1ADA9F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-23-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-23-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c042c028-02ec-496d-b70b-08da6b188dc1
x-ms-traffictypediagnostic: VE1PR04MB6671:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NAmXsebFWP35kmQEe+5S9mW2P4LAjSbvxvg78KTqJQOv49fwEAVSLYa980UCt9Vp9F8AFtsHYYhjF3DvBmECmZYYRmoHEPy2hGqzioatit+xDOm8405TNOnQZwQEW6iUV8S9eVT5JqGEKtuTzSd9gV1RFZJVnlVmDquo4yOyA/c0oW3dKaYl9WxqVO/m89ECryx4F1+N7AJxMf9tYrAQruvINCxF1mcGBmwKyOwh1S2xumLOVLXCjFQ6HRu6GCdJmD1G0bh1bkkw4W6t1E9iBlvO1Jwc92kO/5sePvS64LGR517Qz31a8NGj8GSHU+6cLJajGnZXfpsVlKc++ZP/iKkyRXRURKir8+SGMajFvbclQP77sIOQK6Nj2oGDnosq8HH0fIJe3JVDGakEtD/NVeG/qNHiv1R346dSJvPRweAaZz7pEp5Vf/zhft2Bwlg8bfeE5OtNBtLR7b0Tb+hrbCvFJHpIy//3KadXBvR0LEZrIMdV9ahEhj80+fpp0WEc8/zNphrm8GULPGQ1NwpD0kxh6QgRP39Ss+02AO5F1Bl/9McjM2anIBQfBSEYvx8ba59fGo5Du8Va4G4Ccnl7Fymi/a48e+KiKhlwdER60ffosJ74GsLMTnTECj54/jjvBQF5AQRS0Tspo+2QbqkM1LtGPHRwHSOyp8iXH/XAcEre9nPdo1yps3HQ6ju5J1dcp8BuzuJLmOJ1UdFIn96Rm6mMGFC7jQcK/b2YQI5QCYOUz11LB7394PC2kliJp5LsQNJTDn/zO1AS0uYz35wCea1yGtJ8YH5SNRvHMsTQqvaKnlVQB8URCPyE8iVMnFeO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(38070700005)(86362001)(83380400001)(38100700002)(33656002)(66476007)(64756008)(8676002)(122000001)(66556008)(66946007)(316002)(4326008)(55016003)(66446008)(54906003)(76116006)(8936002)(52536014)(4744005)(6506007)(26005)(9686003)(7696005)(53546011)(5660300002)(2906002)(55236004)(110136005)(186003)(41300700001)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PYuTpDZoTG0T/MUpAff32GCDtNPbX2VXeQ1P3lTIxIwGgnmwi/WTsKK5j9Sh?=
 =?us-ascii?Q?tfZSvxb2EdHzsWRWjZs/2mn3EBmS1sdcPV/9Y7f3qBTr/VzZOJwUvocf57n+?=
 =?us-ascii?Q?AauE4LNqmgYaEwdZUAM+Agdzk256fdV/GCwdSVmvoNQ/jSgo2vUq/7RFpuIb?=
 =?us-ascii?Q?GOELJ6ELezdC8/Cs3wyNV33K9c3XFHg7jd52PA/I/WcOr8grLmzCbbeGjkNz?=
 =?us-ascii?Q?Xq22jN3uoTdUMMmcywgDMcFdNNCqTHYyUqA+a3Xzpl5eXBK8SVXWKy5Qop3s?=
 =?us-ascii?Q?rNluiId18MUu7i9b5BBu/OVANorlpdLcS58VmXodgTAHr+qkFKOSjj7JGwj8?=
 =?us-ascii?Q?5UnK1COZ4aa6S2VmIpx3hqhGUwxHf/C8vzf1T3i3HvKTXj8xk6Jhp9FI6nL+?=
 =?us-ascii?Q?Xq9lybASD+ZxyvaNybSzLSJzXiJGWYlLTbw1Z84Op0YBZoX7UPKBn4xL5qGl?=
 =?us-ascii?Q?55aN5koyesH6XcnlRvqk5TL5o1W0YBhtHCqVDEnoJwTM0FYTnf4ItSbzooMg?=
 =?us-ascii?Q?nH12j8UGvv52NXgjOxqIp8aIfUi7Vx9mB/gankoq0CesXlaOP3rkRD1Q74LW?=
 =?us-ascii?Q?q187rnrGrNjlrc/i2IZ7YXvT6ZHpPX5AfKL4vFiac9dHCdcqCXMdCRhePNcE?=
 =?us-ascii?Q?UapiVRh/Q8ggOcrl3WFEgLdXBtXK7Tr6/buDGFaXiuXsCeC4Byn87i/1hdwB?=
 =?us-ascii?Q?AJQVGQqpdD/LXyfWA00P356ushda5zuDEAP/F31Cgox5p6XyLT75XbF1cyWL?=
 =?us-ascii?Q?UPQPdVqRN/byzLjXY1MAvWJfONJ6NoUuThFqlgv2aE+nxnWwKakYaOACZNa2?=
 =?us-ascii?Q?McoiyEalAGSEa3y5ahDssYAe4UgRocF153K+r+B3xj8/2z7w+V9P9UtPiJGg?=
 =?us-ascii?Q?V8Wgr6pCucF/+9mHHrWxUeZFtRFlyW1P7ymfiS0HW5aNvzvO4FAASFsVuzyB?=
 =?us-ascii?Q?aWISoz++MiZIxi0cOunCwLcS6F4ErKhLQy9ehA9r6rGxLA08ZIuCIHrktB4B?=
 =?us-ascii?Q?FEXFYUVJSVLpZwgbJAuuYWSJwTgxJjJa3BKPBOJBHwjFtk2UhhnrNmgiyR/3?=
 =?us-ascii?Q?ljZ/6EWT+ZL1NVsqm0XS6P+55tX5OUm6LjZB5/Z2PY7rlXrvWn+tOH8RfVf6?=
 =?us-ascii?Q?vwcbt1bEotncp/J414arBSgePRyIyukv7utq4FUAGrSxLkJBVMhcH6DGXnbP?=
 =?us-ascii?Q?ETZblc1Tji/yIVVkP0/U3CJWJJSZuhFGKjyFUK3kWJNyU81hxSjPAoBzZ2BR?=
 =?us-ascii?Q?SVrccrAH5u9bpW3YgdWmxC+stduD3kpadDSmJSvkD6wYBPuHTaoIx0wFHSDj?=
 =?us-ascii?Q?Zp9o8rwJkw1qmWfK44/URu6gbdC9sDqpvy/PJbGI0hF/+asDQf4YvtQ/RDT1?=
 =?us-ascii?Q?dfLLrEYWWuXGRrt3iMv/uHdogUNW30W+sgzkn4q7TufafZN/16HlShf2RZCG?=
 =?us-ascii?Q?73l0XPlbYmjMoMhvoX393vZA34KBO1Nqs/UWvbCS84Ry7fLqr/udncSW1WQo?=
 =?us-ascii?Q?ejy1Pp7gl8wl3rJ88egPSOiltnlhW8O8E4s8rmo6G40Bo4ZUt1Zv/5m/OF/o?=
 =?us-ascii?Q?9OF1i/DLCV1HJia9X7HAAp+0X0ckArtg2ASrjw3/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c042c028-02ec-496d-b70b-08da6b188dc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:57:22.7391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdNXVgGwUwbXRW3Z1IpMmkOjY3nHtYQtH0NR39edNA0DS2kS5YAcemrB1MoTsdLYg9na9r+RVshiV99thuYAFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
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
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 0:59
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 22/47] net: fman: Configure fixed link in
> memac_initialization
>=20
> memac is the only mac which parses fixed links. Move the
> parsing/configuring to its initialization function.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

