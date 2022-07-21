Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7457CBA9
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiGUNR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiGUNRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:17:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2070.outbound.protection.outlook.com [40.107.20.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2687B789;
        Thu, 21 Jul 2022 06:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwFGUYUsa32h8IGHYt4HKi5dcT7G+UH5+CR35fF/HiXKSRwwjJvgxNuiLmJDhRb4UrKfzZT4BPsHOyyIYCm8UyqciFUJTSm3+csoVeKlmFBy/nk/PaU/Ryn/6Fu5btxDOocBEEmpHm1AE7R4F5Gz0OIV8ggtTI9rwi65wnIbRG7/VPBKrOxsKLKZd8+GqQExFH0v+HQt53mp8mo2esAikhEfPMtYYrfDBbtapPU1H8sUVI+8/V2qjp+yYFWrtABp84iFazdoqDIlDRPmo9jSPbwkYI3TiiCufyVoaps8yw6LOxEqEgFYkmW8raA4GzXGqAXs+n7hFFepuUXmmtnPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhQLhs1z0s1XidQAUNJHH4bzc1s/8lYH0Oyjuu1Nok4=;
 b=IqEneIuN2ApCbI8KEbZOEq3WQec1b/u/1nfiYPcgoIzdXuaqEjWzS0XYdOHX37mdW7OvT6hrwZePDEHpr/eIWgmULqUPD7j3RmmBIay0tmMbvI4/IyZirq2JyzkCi2lXRpcuSL8K8WvOF9uupM1kQ9kQ3Lp27th8xqMg1vNhHbvZ32nuPPnLu3KMBeqgRRiFvaPYdXFJtn/7ov8sjSbdLXQ+0/jCSrEgRP+OlX8W80V+O32SxECdLtYjrrIRJRyGB/pfFZr1uBvTXleysGbIw1I8B9CRRnQ3nAql3sfcqNWcKjgNypeyS+/dRnwr8UGVFm7JZCrRHXZrZwQgrkLXeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQLhs1z0s1XidQAUNJHH4bzc1s/8lYH0Oyjuu1Nok4=;
 b=mXNkO9WzJPhyw4qlCrlMQU+Z1xi45iRFDsGoMGJTg/nY3T39ZK/7i9Pyi7avx9ksj1Xhkww5m0d/VjJ4Sp1okp5PnTM0BzaiO3soQXTIbmIMaYcOAfwWZO0Nn8VVvRdzcBcVbje2DijbkoaBimLjtKcYSLgNylpETHYdav5RgTc=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6191.eurprd04.prod.outlook.com (2603:10a6:803:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:16:48 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:16:48 +0000
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
Subject: RE: [PATCH net-next v3 36/47] soc: fsl: qbman: Add helper for sanity
 checking cgr ops
Thread-Topic: [PATCH net-next v3 36/47] soc: fsl: qbman: Add helper for sanity
 checking cgr ops
Thread-Index: AQHYmJaOEx1tphkrB0GI3O9tJcJWba2I1wUw
Date:   Thu, 21 Jul 2022 13:16:48 +0000
Message-ID: <VI1PR04MB58074AF835F113AE6EF6541FF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-37-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-37-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 049596ed-6301-485a-6554-08da6b1b44a7
x-ms-traffictypediagnostic: VI1PR04MB6191:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vx9yws7Q+tirwlHKYjQNBeCsyNtXRzsZUf5jUVrC/Trdoe3AVrc/zMQM1Zf4DM+X3c4i1AFS52DteeTnQ8TKfWiB79hQYKcp9RC1JbW7tLaJyNc5Eq9roe13NP+FA6zWvMmjxmkJ64sSmk+yslG1m+3s1H05Zuj6yfP6vARLeATUhvxFO++sNQDgSX2l+ZlXIN8XBMV05mnCkvCykdRf1PCDRu4i8TxLKUOnOcBL8d7MkQTd8tEY4Gnnrf5XE4hIxO5kB1DYi4zDhq6QZgj/JIDl+CXYOkzcDoBYR17H3O81Ee1IUVZqGYvKe5QNbNSYsYuY93OgNQJZg/SnbyYg2qzZVvacxyxcJs1EGtAqkhxL5T5vBJ/sMJW8MxmmvfkXxYK1R7l/rzeWhgbmKUH3blkLHQnyYcN85Xx0XWLB7KPWMF6TvCMOUX5HPZ7+wTph8DzkU4lKb7H4NmLuXGeRg9Gh/5DptWhhDU+JBACzXAi+ZP9Pekc/xH3yagCjLTJmsKuw+Z5FloG7FKJd0UO759T0fpSAxganvT7aqS3QIPwGKH4wgBaHLvtEQuxnx4mQ93OEpzqTZ+uUzvAmhvDbcHjcFBXCIFb/6/qQ+qHVBFdhCB4Woqfa/Y1u5VWxiHkPaK6jA0XDYjeLaGsm6dZZ5vjprHMIZNRrX6/UU/isDEZ4kG0T06D0HXUQY5qCoRYlLXIM2ZvTBgJp8IaM++bKELPWMFQH3o8UIaK4wDG1DKJIYS9wUk4kzAfCGeHHV+FYHGz/kul8f5XAQMQcgCXZ99CBCDmm9G7RYnvTAT1JYni41u1cJQzj6bHFZgCQEfas
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(186003)(76116006)(38100700002)(55016003)(66476007)(86362001)(316002)(8676002)(54906003)(122000001)(71200400001)(66446008)(110136005)(66556008)(38070700005)(64756008)(66946007)(4326008)(52536014)(7416002)(33656002)(53546011)(55236004)(4744005)(7696005)(6506007)(8936002)(26005)(83380400001)(41300700001)(2906002)(9686003)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LR/r10Aq3IMulQBqTbavLQCZ5wu94IUhoi6xFP4j2MoQAQ8kbBsvN/ubaDsf?=
 =?us-ascii?Q?ABBqRgdrKAn4e6iMYP3VkGtUoyYbmMeSA9JQpW7t662tnnvTz/bcZ099gUAN?=
 =?us-ascii?Q?p1i7WksspKxMAF5XKiIUlHoYgVKg39OKutYt5PY1Vb2nSfT5VBkHXRIR6ATu?=
 =?us-ascii?Q?eznhqlwpAfZnwMo2j3HzkoBeNKboRWObpqPyRUjPshzUX/uSO8hL37C6fb/r?=
 =?us-ascii?Q?WTcDekftL80mAjisr1vR4DHJqgxJICVmGcYXYduS/tQX319wxKGK0RpMxW55?=
 =?us-ascii?Q?DhcaMlBgZrf3iilpa0CspfLWsbrXryg14WAPDHDuBXKu2hEIHphTiHnSczZ5?=
 =?us-ascii?Q?hlPmF/ZsLs33bt3aKEOl7jqyHPH36dScPLWGO6EoZdiROVvWCTOcUVpCRaHj?=
 =?us-ascii?Q?pxf76X+5bwAqrHLGqfw7VHXDgn/MXuHxLFaLL++LE+d0cnRfyizR+34qLaZ5?=
 =?us-ascii?Q?sY93xaHOiL/Oir9PePrVunbVZlrpVzK9tiLnDzQ3pAmb1VPC73LY7x0lmppu?=
 =?us-ascii?Q?9jhC4LhnnukjwId/UTa3DDe1iXry1B7zV5ZxXO3gMWtFqM2gNWCvcCXzslDD?=
 =?us-ascii?Q?OPwUNSjFeDdhog+XoG49ugt1bQkEhraamaJI5WhF7q7U9iC35mbz0RlXm3GZ?=
 =?us-ascii?Q?ElpbNgxgHXOcRVJBL0Pwd244Q/z9DWw0Zhx6aM0lzVMuZFQcRL/x9gT1yUGb?=
 =?us-ascii?Q?2kqIOkpseCjmfFHN4N83iZk5bCdGweEi9H8DOgjyzcfuOaUK8YCk0ooM7Zhx?=
 =?us-ascii?Q?Sc6mDPt86DrypgGR0ZRXbBVDrgfWGNJJFw6E/B6a4M86zRE1GNcCWmyYb9wY?=
 =?us-ascii?Q?fP4sKkJjha/NbGoXq1OWnfVmZz1h7TR6SNJE3TjBhvnMwWjxQnZn2sDFkyap?=
 =?us-ascii?Q?cPFWTcEackMhr3e3OzJ2Z1WGhgzw4epHHeMsbEC09jRH88X5aWdAloS3thfw?=
 =?us-ascii?Q?HH79iI3jKuEh+HXG1H80TOGFpON6F4VszyEs6PZHQ5QdTuliRyhAPIEtJWrE?=
 =?us-ascii?Q?mkS/lR3bgc6qffbnrzovRcxjKutHuEBwm0TTSgZGQPiKo0upC0QAyhgOiTHh?=
 =?us-ascii?Q?PnCJ7DERIMELBIX3r5I3CyCFO8YPNE9w19KwXtMIJLZJmsuYhOsDmNMaHRJe?=
 =?us-ascii?Q?UzU+kqNauIZwpkFjHrIG3tn94BNy9JAr8AzuMZR3+dGb/rZfmm1kOsdEKjaQ?=
 =?us-ascii?Q?HyqxEgOFa1Pg1jRFB2H4lmbz8TL3etx2jsPbIto71BrYReN2h8FXKdJ3UT8x?=
 =?us-ascii?Q?jS5PJK32Ee1Xf+jkL/Oho4oLE9RKXPOgDSKj8f1yJ9xxsN8AfGbH7lyHX1Xp?=
 =?us-ascii?Q?EZl/UBld7l8ezZVFtXwl1UNGFO8zuAPw8yxf+yt1JCsjOm7gsxyx/XWfX+2w?=
 =?us-ascii?Q?0m3KX2lGsy/OHT41e0Ys3yWGOz6Jw6j/mMuqxal0oVMtFR6UE3DHDI1NZGnM?=
 =?us-ascii?Q?3ZqSEo4Bjmq77ArmTL3lKX71eP3E7wzsXeAA3NQwhYKobtGkBqlljM0k9QG9?=
 =?us-ascii?Q?ly2p0YO+I43DEyT7vNWDdH2XekbwprLLXxIqcD8bKuTgxE2Y5MDZFcY4S5RZ?=
 =?us-ascii?Q?rJDbO/8l6JVmvgQFLVSsZlDHdrAlQNFuVVTpgYIB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049596ed-6301-485a-6554-08da6b1b44a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:16:48.6300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZLVNsNJ6I36riaAG1gmdennLrggmbwme5CNeN6s7z4WKwbeSmS5oJTHErOKC6YI+zXpgczuChUphZrnNIYBroA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6191
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
> Subject: [PATCH net-next v3 36/47] soc: fsl: qbman: Add helper for sanity
> checking cgr ops
>=20
> This breaks out/combines get_affine_portal and the cgr sanity check in
> preparation for the next commit. No functional change intended.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
