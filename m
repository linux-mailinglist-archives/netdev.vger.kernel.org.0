Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B474C6B30
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiB1LrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiB1LrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:47:18 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00049.outbound.protection.outlook.com [40.107.0.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559BB47542;
        Mon, 28 Feb 2022 03:46:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=my39+lH4SZM2C5E+Ta7dRLQqSCxclwjRS6wLeUyRlFZErkcb/ZmtsCvMrrsrqOMdmUWsgjOg6QZFYLe0H0a5/DdYQkzWljQI3J2nU5whnnawAO1/7UOc+8LBHhA7NZXrNicEsfnzm1GCDM3srT+tlLL8JuZMbwtCn+6v8rxlVMjKIoHet4koZ7mV2smg0jUwsUGnHV8i6r2R1Dy5vedLysc8oETQ+u8lelnUewWaeOzNdaAOGD3zL/phORaNIKSRzYQuK/htpy4cutVq2WpRSx1IKrarIzxM+qNxn6VscT9O4jyyIqIAKhYe/QJcwKyBgSscN68snLSvHJO1EUwVJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlhEWZsVnKZIPmwnFbWTgC2Xx7hIiPHqcBD7XS6/C/Y=;
 b=I+OcsXUqAfIm06kEBwmAagByytaWPXlel5LsTGxAu67R8x/+zFdcjZ5ztFlhfoSxCB4zfbDNwTKQ4VLEsSoLbp5YQbXoSpxVKclZG6T7Nj4t8l3R8gyq+8FsMN2Zy8QEveZCAeHgXcCN+5f3ljjfmZOMCN7vTjdazyD45nqQ3/nwvgwEicjvaupGL6zyp37lZdvA2G27KFc4cZaTjoWg/Mem8XmsKUBbdle5YberTmopUJg8tfcsoZXuoSfy1dPMgOpgSibDRbnSTpHIBV/EwyKv71KAM0aYc0mD/bEM0JcD2F4ipg/N63n+Ur+sAQnj9Gd4DH+qz3OBXTDMX6jdeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlhEWZsVnKZIPmwnFbWTgC2Xx7hIiPHqcBD7XS6/C/Y=;
 b=VxV7rFCqA0+u6N0ngAUmJLKJ4dVT9O3Fc/j2h3b9AZ1IrTODFE4gNJE46GAMCG3PZjb25eD0gCGbV5/WIEnSVs2QByl5Z6D6iVewPualKsRQmarocPDQ7FgHJ4cEeDRNkJKpY7cLK1gkKWth8OFMzCWI0mBI+L1LxnoE0vAqZMw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR04MB3275.eurprd04.prod.outlook.com (2603:10a6:7:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 11:46:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 11:46:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: dsa: felix: remove
 prevalidate_phy_mode interface
Thread-Topic: [PATCH v1 net-next 1/1] net: dsa: felix: remove
 prevalidate_phy_mode interface
Thread-Index: AQHYK2FktZ+AkJz6WkWsPM8tzjJshKyo2ugA
Date:   Mon, 28 Feb 2022 11:46:35 +0000
Message-ID: <20220228114634.izmpym7x6kvjjvq6@skbuf>
References: <20220226223650.4129751-1-colin.foster@in-advantage.com>
In-Reply-To: <20220226223650.4129751-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b663e04-223b-43ce-05e7-08d9faaff8fe
x-ms-traffictypediagnostic: HE1PR04MB3275:EE_
x-microsoft-antispam-prvs: <HE1PR04MB32753140C8E8DE7CE08089C1E0019@HE1PR04MB3275.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95rb5V55sYXn4Z/mmaOU29nb2YH2ZEmA2CuyL/Ni2EhBKmgSlCIh/zew/EviVtXGQZCqa5jFOLuoTI5537ZH/59VvF+ZuVQNPj+rTvzdCKLsVQ+CgJVELPZ5qtLvVpq68jY9FH/Mo/EvIZ1ktLt68mlGIYal6rN2P573QxZjFnOnaS+VPGvJG9LU7uRrgIBY1TsP0Ujr7ikaT4hhHID9zIabIs/NNBb6VJZtFPFrIMMnWzBSTwgYBaoPk92w7QPS/7uMxIMh00wBy78iRuU8mcaNs3o4qomeca3HYFYLTta2oBqltKP9i7OnfELnDecPJgNaXav1rKKjzcvNzK3TJ8P5YQhaIznYQwaXxn3WXB6NJlGK7NnzjS3Pyh2VaZ0TwxSc65Nvx2lbUzq2HcdgtvZMMP+0oF2uhcdpmyBFfZR00ig3wJFIP7IPqRW7yS6nNFiTwuBLX5A7iL16Y3Z2nxPYa+e5QYXkjjMddtMAzjullbcbdN7MHd/8m3RJ5tbSFFqQjlZFdEppcae9wip5PGWfhfqywmycdGE4zucmnlDTHatukD9rJ3oZO7DbW3Z8bIgZ6UDIu8vGMP5SmBY7vDcMZBU+I+ij35fUlGeW9zFJO6YFjcSHfp8QAn2DOTnpv5lssPgdoBjfaRY4JLshVaqeRvb4ivWG4JO4OKdb1SG7abTN9+oUAVhzV7mKHddKrm9npmvpGiXTSQkoqoRmug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(38100700002)(122000001)(1076003)(9686003)(6512007)(186003)(4744005)(5660300002)(2906002)(33716001)(44832011)(8936002)(7416002)(66446008)(91956017)(508600001)(71200400001)(66946007)(76116006)(6486002)(38070700005)(66556008)(86362001)(6506007)(64756008)(83380400001)(4326008)(8676002)(54906003)(6916009)(66476007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1wSM+40P8l2SoLvyWgliZpRtAD7bxJUUUeqHeQJVOAj/DqVWLsZH8p06yDJX?=
 =?us-ascii?Q?1wDY4YLaNRiij9LTM3ABNr+uVQVfhm2mmD5ziiRjnnHutdLmC5ZGpQLnBrrR?=
 =?us-ascii?Q?j61jg81Y7HTq/VU3NwdfcAPmU8nXPeTtR4elZHYAuP2Y9YE9Ly5JoZXxCPxy?=
 =?us-ascii?Q?HrxXqLuqKLRA1Xa3F8UrRERy1GRyQDMSDnMjjKQGeoo8yXpqJh58YV+gX9xE?=
 =?us-ascii?Q?fu5/ytf/JIGUUiYtYmYBdLlZrO003m5aSXHVoLj6kwVjNIaNto46ckelP1kG?=
 =?us-ascii?Q?6RYbn5gZoOWQNiCeb5oipTbhljHNN5kZthJQHyvVTxhFEmUXPIeqisqEQvCv?=
 =?us-ascii?Q?776ZJHjzMgtyRsoA9ARtztUIBvafEECrkY5lbbQGC14AvAIMq+fY7qQCBGdg?=
 =?us-ascii?Q?4t89hrQ0vjG1FBZrzz0aIn6lA0zDHUF7PjNa8StYJxn4+/Dn6iAoG7DERu2A?=
 =?us-ascii?Q?l5U/3ZkBohGLiN5GOJb6BQQiRcz2sRkyr8bgMzpbOU4oO9KffZbegwGjaKCv?=
 =?us-ascii?Q?2BDbhFf2Gez9tL371aLPQgd81sKEDvT6VSm8byIBcq08AgrOndWt1mJ6ZtUt?=
 =?us-ascii?Q?sDRfb/vtLA4KZ40bIL8N3JbiRSc/4lHonqBL9z7zUP3osohka4n42UHLOtDi?=
 =?us-ascii?Q?M9uivy5pvR6stmtyBRecCgY0GolKyY565y3rGkMvQsi+EtAmlCTUMboRTfR8?=
 =?us-ascii?Q?RewKYfkab/DU4gEdk7LPVTxctghnDlvyo7SyPsDKLgT4ju7LTEQP114bozwq?=
 =?us-ascii?Q?B+nMudZIBjII+hQIFnU1a7ZG5f+4f8xHJF5Y7JMREIM6k9VoSamgVA6QjMws?=
 =?us-ascii?Q?utQMIn5NU1E/L2o0x7fbrSl4TNFrwpJqI63FD/bwwDC46Pxtezo0EuJURm6V?=
 =?us-ascii?Q?XzYQZkrBOCELyq8DIo0wZ9QPk/NUJMuBVVVsX/V/LrtNFx5nWRmLST81b8TE?=
 =?us-ascii?Q?p2jMLGnIX+BTSA746nFqfvIOCHMEdrPnsGJhLAL0l7EvSi2ojRDxDDnq2tmA?=
 =?us-ascii?Q?ZFg9i5IzHkXrvU1czNv+0zNv4x0xk0x77zM1rfoOX/RVsVJk4wEBI/H8JnmE?=
 =?us-ascii?Q?iooY652A676Se/f9iYPeWebeg72zKr9NRS2vm39OFvPEkpBq35VTIzMbSy/K?=
 =?us-ascii?Q?+Nhe5PsApH2o1T6TpGcE+L9iXFaR4/tL7iRRosGrcL8WrAImrlnNTQvhae+L?=
 =?us-ascii?Q?w21d5bGnN3XbMZWgvH2NKEWJelyrAunb8WgnGmGSC9VFowczkRfZSKO0dNs5?=
 =?us-ascii?Q?hYUDszxshUbjB6l3qSx9pWDHJ1bU5sPjWaa1qLtublIkkvwSK1wGT0qkmX6A?=
 =?us-ascii?Q?/OAGwiVhQ59Yfri+XRcUDsih6nJ5hRv5eUQoztyEVKrei+0tMdqGctte/4qk?=
 =?us-ascii?Q?LdQO0MXAH5Eu5rDg0pV+1l6LdPtspcN9SPSdO1Q4dtGWZ8YhSa1echnsWbd8?=
 =?us-ascii?Q?Kt+4tuN6i97Mj4Fs2xAFazm/UDbybp2NVHMmphBbyv0cqNua+H0xgCztNhS5?=
 =?us-ascii?Q?Ou5Zn0ZGGxAbPmjp+SYCuA2JXhzpF3+JtzzaMD7IEDqyWOGmSgLaRQn9KrIq?=
 =?us-ascii?Q?2sYcTgY2we8NqXqmZPFc9/bQVVwFRlP7Ij79gho2tAjSC1likAkzQVWDUI79?=
 =?us-ascii?Q?TsP0dz7Vo+aYSdeihst6WIM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9837ECC2D51CF642829AFEF329E0D8FE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b663e04-223b-43ce-05e7-08d9faaff8fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 11:46:35.2472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WAYp13NP2QeH29mU7PG5ECP1qSdUL2etIeYuinLMhDZObxLePNVkBZzAl/8sgKldHrLferVY8I8LLnPORi/YAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 02:36:50PM -0800, Colin Foster wrote:
> All users of the felix driver were creating their own prevalidate_phy_mod=
e
> function. The same logic can be performed in a more general way by using =
a
> simple array of bit fields.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
