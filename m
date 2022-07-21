Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BDE57CAEE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiGUMw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiGUMw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:52:56 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150075.outbound.protection.outlook.com [40.107.15.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE6F1B78B;
        Thu, 21 Jul 2022 05:52:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+EKMpL2YFA8CJpjG9cOE0nLWYiMWNouDMiN2QOqRzb5Gp/qnZWUcxkuTmrmV6EA/al5j5CPWxM6GitQGXUsduw1byIqtGkBnpdDRhlqnFw9/D077sMiPLe3EU+LnPTSecV8FxeFT6oXLTTOQelauIInshwjACQ3mUgE58Mal1e2BK42ND2siq+63GF0bMxylds/nSKFGPpMEEyJsKngqu+X5rEoV25hCX/35wGVvcupmYVv0FFiedoAXGn/3yaCtv9TA1HUvdqyiQZUd14gK3GkaYS4oKSjiIaB25HYZsuZAs0I51sfXknkH8nch1T8rjBVxyHGd0xM8pYbl1aKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp+gsvuZne4r2p9U2YLR9zkkO4+GeGGg6whkIFMGhUo=;
 b=JSCw7YHGl1duj7BGVi67p2vPe2ZGYvOeMFPR1TwkBkKlLyl+plw0H1v3EaMdCsttB+RJEgLT5OvcUYH3UA+nbvKHApL7T6ZSpxFn+VFlPJNf7ZtbDufJEKv/ObmVrPZljBfO2U0hpAJueO1sWKykQLzr/7/98DlVHJaC/x76FRWBJwLP8Y05ZnmG1xvFMgbAzDVn436AmYd246sMdaSzhsFk1WJcEoTSeJyd8xT7bQnVeGxvvvWuoI7d9kiUB5j9Vmi3c6zaylrSVUAtC6BFBOJ9r+/C7JpyBOyRRGUX0ZbIKz+3uUvlCOfS8hiqeELiTgnjBl3QyQnxZ9NWeh/tFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp+gsvuZne4r2p9U2YLR9zkkO4+GeGGg6whkIFMGhUo=;
 b=ZTrYRXhmB43Ktx2GWhd23gV77OeB4dNa5ZFifgIK+BQqSaLIKA1/VuUiXMtfNP2BMM1HHqxeV6fLYTbbLMuDkg2GiiiEzRMCKJePbZEZ1KfSS/RiGn4xCR9+ZUovd/RWn+KnDmMTFZhNIdFD/0wWelYEjqfMV6WG8zYKtVX70ks=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4623.eurprd04.prod.outlook.com (2603:10a6:803:70::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 12:52:52 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:52:52 +0000
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
Subject: RE: [PATCH net-next v3 21/47] net: fman: Move struct dev to
 mac_device
Thread-Topic: [PATCH net-next v3 21/47] net: fman: Move struct dev to
 mac_device
Thread-Index: AQHYmJcPnoXmZkShfk67Hj6gO1dKr62I0BeA
Date:   Thu, 21 Jul 2022 12:52:52 +0000
Message-ID: <VI1PR04MB58078CB166A9749B881E02B2F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-22-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-22-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cab7115-6396-435d-84ca-08da6b17ec9c
x-ms-traffictypediagnostic: VI1PR04MB4623:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nB4IcH7jM4SNNONgXO42/thHb1Yqaxy8B9/pm2wsmADoswvxiw+ApbZnpXDlCLIutXMpAcCBprK5qA9oTJZ/O+V97sIIkiRkeszeyKSFBa+vXrG8vHhL+VIvPTo2vsUXfJq2Fp4jieqWC2e847AJ0aU/1hMZHZLg1CGDIE2Kp5QnX1uzAmFrMmDluEGkH4ygk/M7LDT/yVRH/q7ieCQc3qxI8USg85JURPq2I2RpDeH3VkVcTlfXUSd2cSnjSmxPKJg/tqE7V0ZolREpoUJRuwX4QWyWyng8CaWycF28iz9B77IP/lIAA2km6K+iYqf5r24bnrozFNjh71wr+/8rihd/DqRRZNr3BZll9AVoSSbJ80iAFCwgeGISMqqkCFDKp02jTcmelyHI/PMi4J9abj/bChxPUlhmWJob9sigAh8T/RHnwZhYf+arq6qElvAChe6GNrePFH8onOsCJT0TdLS8gBHxUVuf/pBTRiZi8K/k0Hj7w5bu3K4AYmqGKqJdDNTvqUyl+/2PwqQK2WZXsj7EnFpoK2kw2CVLrNh7inuqFV3pdzh2udKqFfZdxixqPpkb+r5oXw6iSvwjkR1PvoFG0WKs3FkurosQc+qkq5JNwUpzvz8nScGuAq+PMap7HlhhQ9EWMS9Rb1LxFzhk92ja3hwK7bQdm0Zros0utnRudqiR0kOWdiM4EXDs8nZkABfBkjzknW0VfUAhlkMO3aTFkvklMBe03ykdivi5VjKKyI/FykoAxWwDi73uwldyGRpgWpObpYPpfmgW60u1t/kb0Zsx6UjsOpJadzwOjhKryNYY8yYbr4Yx67hwxxGl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(55236004)(2906002)(110136005)(53546011)(26005)(478600001)(7696005)(41300700001)(6506007)(9686003)(33656002)(86362001)(71200400001)(55016003)(38070700005)(186003)(316002)(38100700002)(122000001)(8676002)(83380400001)(5660300002)(54906003)(8936002)(4744005)(66556008)(66446008)(4326008)(66476007)(66946007)(52536014)(76116006)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ULLFLS1KzUCZFqJCzDoH03jgHZtmOoeQ8HMYw2AQqMcjELzLcj01MHi5evIb?=
 =?us-ascii?Q?njPHPXzJBPAYpMWwGB1LxdDVhxkBDIgw2/ZEj4cIfnRQI3r8xsasExhOQ9O5?=
 =?us-ascii?Q?CE8v4b0SImyMTqth6mNAwJ8IbDqUbEukGoVrE3QYi4VzIn2T1NEaCXkaL6qb?=
 =?us-ascii?Q?Cda/6dB8pIr3925fiAy5pSNYQsA5kmvCwLM7bTZAGTh0QsFl/1KZYBSj9HnL?=
 =?us-ascii?Q?/bA1KND6wUlt6WAhBNG3BfVVEs/NroIPwMLYfCpMpmN5D9o2K2bGdsFdxuP9?=
 =?us-ascii?Q?i3WSH2p8gOXKXVLNUdekoxGkJEHDSla2+pj+r5RkwLrLPAAMTZOOGMFApTB0?=
 =?us-ascii?Q?eCaBWJL4rkIWUP3wonu5G6lsSqlnMk8b7PqTCNEJQBe2wuIP45FVTZXSwe0T?=
 =?us-ascii?Q?VpkGQui04bS41SuH8cJuAAyADFn0xfCAfvINrbucmpxAV303kCytWAhkpcKA?=
 =?us-ascii?Q?Wd1pMkPA5NhRUQj665vmQLR7x78riDgRk2NUIZhzYZ0i66h97g/grz8dvoYE?=
 =?us-ascii?Q?AIxLmw7T1L/auUyzQp13D+84dtAKXzWWlqTaZ6/TMUtWLCXrl6r8t2/x0tcG?=
 =?us-ascii?Q?9mP4+JsCFXJTC3vGPYzXekN29OCgo0qZDyFCzuHNygvYJqMb6uhpV07hGqG4?=
 =?us-ascii?Q?oH0Tdvg9iQphhCkA41IQWFDx5o8OrDLMVR6LX2y4NfZljbCnFuKaeCW6NHvj?=
 =?us-ascii?Q?zuR73MFVvc28KozUiU9+7odHgM4jJyMCxNroVLb9JYjoDPE/+gvW9QuTGDT9?=
 =?us-ascii?Q?9JxVMg/L9uTnOfERTT8hK3aQOYz1OGAXgxun4dIYkp7NySdNLGWKWzbz6h3O?=
 =?us-ascii?Q?1+kvZJeqvx+rhvWDXAEzpGpyCg8cKMBa4054ALKRA6QuTRNAM/2yeHVbpJ8g?=
 =?us-ascii?Q?JJtpF90R93Fe2GrJLBoiaPd6cdi/Iugq+fl9vTmqnALUfnV5/5id9WyNE2Zt?=
 =?us-ascii?Q?cGVOSGDnBCA3PNgKXokTUwsJUxNH/uVSNsIyfi6NBxZw6oO/s0SrhvE+iO5e?=
 =?us-ascii?Q?kSYzJ9KuePc/k5FHVNT5NSDnN58ofDiHFJ/z9KPnMF+c1ySjmRc3euJIQE47?=
 =?us-ascii?Q?OtckeQzNT8xLLjwsFoqMVv3q+HaIjLCkCBtxp8dD2nUMDil4OcY+oE1XWCKO?=
 =?us-ascii?Q?le8AObRbHjkble3uRShRZlko6D8AUO6VWrdauS8wPvFPhN7BNjzcisZYO3lF?=
 =?us-ascii?Q?C8AhyowalIV+QpCfeo7FzJIK7mWlYXJVLrpXJGD4yhXrALZuvSKJLiZhbtS5?=
 =?us-ascii?Q?gdjHxDdiO32z8GRsNFq3emksUx/u0CIASWVWYOGUNdDgxhZcGFae5le53fGy?=
 =?us-ascii?Q?V12766cZkHBYDt+r+NxAFOvzql8dRRq+c3llvH4BFMfYOz9834p9pTW7VVgf?=
 =?us-ascii?Q?K+hiLEO1CAEf7Oz7clIu1HxFYflARKnvKdWbvoPvxNx2zTMIiM/Slgo3kmRY?=
 =?us-ascii?Q?h3h4zZvvguEFxkhwSrVwLxNMlvbN/S28qDiEuoWWnDOXA6yjPGk7sF1PgVvU?=
 =?us-ascii?Q?rHaFLNj8bccvgHcfB+ExGg/oJc9euG+cwJJMpwp5SHb8hA0T9SqRRP037r9Y?=
 =?us-ascii?Q?Q7Tcv3keoO/l03WKP/XmL7tnokjiZsTBgwBWHsz9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cab7115-6396-435d-84ca-08da6b17ec9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:52:52.4290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KUBDU8wd+JmJTWGTM/CNm9/lfi8vinC+NYv0Kdi5i1JQYk9KNrZzVEmUpZ2+qZM1z5C2TLX13i+OrWs9j7izTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4623
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
> Subject: [PATCH net-next v3 21/47] net: fman: Move struct dev to
> mac_device
>=20
> Move the reference to our device to mac_device. This way, macs can use
> it in their log messages.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

