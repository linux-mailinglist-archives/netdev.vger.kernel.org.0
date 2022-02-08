Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B984AD8BC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245704AbiBHNPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376438AbiBHNG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:06:26 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124DEC03FEC0;
        Tue,  8 Feb 2022 05:06:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/mQN4CjSEvU5kQLZt5VvuuRzsQrUztTFONik/shDepSCiy2UL/O6Tf9n5D9Z/MhiQsOj9rSYjo6KjR5w0E4ZTq+oJrOa4BLrVNTNpllQ/NO77TAC+025orgL7x0YGg8p/IJerRbgLykUUH4Uv8KNaJOZicB8HrD2uMExe3v3L3ECP7TeyyOYjEVY5xrtneQa3DjLvMM0J11sWUryZwszLxx6C4xp835DoGQtPEjDPNZr61XbMIRb3FUJgg0fBpgCVc5rSU00ccQ5cUcwYmFD0W+lKs0ftmG+AWRQLVYIKFQ9Nx9IcufZCqkrMEKqV0oYXKSZ7df8N+rX6lj8UesxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7W+w+K/O3n1G9a9EYcRyzz2Rhyuae32adoBYpwYSvk=;
 b=AHRgtP6cgVEMXjeYqijRIJMHEZRViL+8+QxMOZCI8BZmfQGEtwERdSatE7JFxGpQJTk7aoXxE6qgcVY8l34c44r3CdqEc+ckO9ok4sTvpG1Q1rVcXSD2iDkDlOCi6LkHN/EIfOH3daWCliMQxbRJ3FR0eYc/rdnFzf6dzyOpTqdsFyBr9SBPTgoeDzh4XQWvRu3eK6xKlk0PZjO/QfMFGz+LBwLzSiS0se6s9nVbQSSIPbwdukq343OIBxTBS6qKp25NQ/Z/c9GLHa4kwAiAzvwwm4Pi0+I0uf0QbuX3wsMM1IsuPF/dFKmvqn9BCQyMbIr9ockJhR4nEgy6yi89yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7W+w+K/O3n1G9a9EYcRyzz2Rhyuae32adoBYpwYSvk=;
 b=fTEjtK0qGx3doziiZjb+yflkAfqvpByCPiHzeenmm56G1plcNnRkevxJkMZMHb3q8r6f+tc/vKIM0AA5zW7Yfuq6xYH/Q/LezfI3FMvTvsHnHgYISd9vRG9NFORXvi29EOkI3VKZo70sj6YnyePRwQVHCuG47YcXl1eDvkl50m0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8681.eurprd04.prod.outlook.com (2603:10a6:20b:43c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 13:06:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 13:06:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 1/3] net: ocelot: align macros for consistency
Thread-Topic: [PATCH v5 net-next 1/3] net: ocelot: align macros for
 consistency
Thread-Index: AQHYHKbqWioTn+VzbkmgZzPtRbMifKyJoAeA
Date:   Tue, 8 Feb 2022 13:06:22 +0000
Message-ID: <20220208130621.cmlm5ytbgcexe7na@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-2-colin.foster@in-advantage.com>
In-Reply-To: <20220208044644.359951-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93ba283e-0174-4bac-62e7-08d9eb03ce3c
x-ms-traffictypediagnostic: AM9PR04MB8681:EE_
x-microsoft-antispam-prvs: <AM9PR04MB868108329219D08DAACEA331E02D9@AM9PR04MB8681.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OVDfMkemhNV8eWnmt4j7gcoA6EB4BkQIlyMzxBf7WQbXgDWmnoZ6+9RVJV6GPL/q/6FU8NCzcAERBCshrbIOPWzoNcZoKGd1BJXww0UMGuqGv1vG4oBMrcaySevax2tULUDyeahahDeQCGKt+1X0hwGMuasB3ZEcTyzfoszMyQnAkO9WFGs9GV88dmGCb796LrMVJWLPotPTelXUWt9PwdERBLPb3FepiwfzDYIrxpZGefFXjAHP9zuYj8+BzEGKBsJKJo4GGJc5Rv/BL9ZBRcPyajdGTcV0NGv31RMFNO4C0F+uVAqhSKzjziSZqST05+O3QejgYW9LdHqVECCwszMWZNmm8La21uiABn7Z/4ih8qMT+5YNfNepfYfvZOYfoOAHVBsW1isQ1vfrv35P3k5hlSro5JpRHBSOtkUC7B3M59hPKeFVvY5uDyzR5mQOJ1H4HC4IShc4ly9b6MoBeeUjWYA2YxCP7QAb616SAjKd8egs+XYcOrMJgcMhQiKtO6V3gINv1ISeou2CsnAdF8quB/hs6aTjdn68NTVTU92g3fnzvZC58GpATNS3yZsZEgaz+6L4AVpQvPWZDFwf9xkm+poEilnFZiqWnyjwGmjtugQWc6qvdtSBpRqWBJfKvJ2Z6mPLgoXv/YIj0jvoZfWVzghexcBaUSELBQ3OkTQXt8mu5beNOB6FJgi/cc149SN/i9nTy0Iz2GFwOg27CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(6916009)(44832011)(54906003)(4744005)(186003)(1076003)(316002)(83380400001)(9686003)(6512007)(26005)(5660300002)(8936002)(38070700005)(2906002)(76116006)(6486002)(8676002)(66556008)(66446008)(66946007)(122000001)(6506007)(86362001)(71200400001)(4326008)(66476007)(64756008)(508600001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rmsteRQ6nTv8s8gSc7Tuuh3DubXp0VBpTYbO/JVCtWWQ+sc1883fk42t8sEa?=
 =?us-ascii?Q?oAS7+/9eNiZLjOFx/hTMDtuxpnJMX+2GguXAvZGAOxaq1kbDxAvH+JU/sVYG?=
 =?us-ascii?Q?fuzDpX2541+JK/2avpHYIoEmjjC+wjrlziG+YQoojNRyCKTdNp6l3RGGHBo2?=
 =?us-ascii?Q?Z54cCd81bEM6fgedSUDvpEkl5Bg71mymRsSMp4e9ZmF6U+FwrSngjVU5Rs0f?=
 =?us-ascii?Q?qsJLHjIlw2V0dYDin6fIWCXoTvj0mg8foT5AclZslu6+nCouhPlHPcR31Cns?=
 =?us-ascii?Q?QY1UP9EaHG66ov6j3kfYlGWMZDTXn1UtC5bptpRsgQ9KsuMDI3+P/RetA5jN?=
 =?us-ascii?Q?3dUplKU1oVOKhy8FAjJ82MmbZ8MjagrgmMdp/Tjk4OY+vZ+UleKiecea5yPE?=
 =?us-ascii?Q?Nnd3B+i3qgeQu/VTQ9211OHe3JYn3LtnAQm0Xi+oZbDMB/uCxYqQ2wlEULrU?=
 =?us-ascii?Q?+qtszVdG+iViRaxbTj2hgatApHNDdlvRqf63O3ch9k0IM0eKXST3kl6UeA0o?=
 =?us-ascii?Q?ZhaLCJKQbCTV6wnr24eTn8dpMbQ4og18/I6YbiZXThtHM2f3O9FLdJXmWPmO?=
 =?us-ascii?Q?JG8S3YjFyEBNX7NOHJwxIHFfkjuXwdMnEJNB5yzTX5qPxM4cPU9lV3f7yNCv?=
 =?us-ascii?Q?zfaD5v3uTOdtd2LXRaz0ML8vRzVnVerL71Ylpvi8WsKsmRxV+KivURjYcdkN?=
 =?us-ascii?Q?ILO6IV97VbgWdvNuGmgJmpLEkwSkBFNPAkSdL5LUq5C8LOlm1PMncxJTYDAY?=
 =?us-ascii?Q?CYtxv0Rkt6+h9lZMsXcX2qI2mD4kVAZLTlYPKwUsnh3JME8p3lK1QiCtXPaq?=
 =?us-ascii?Q?Y8cH1XP69btl+ni/h2UqF1nC7epbrIqIk1QqL7j+JIIloCQ617R9BOyMIHov?=
 =?us-ascii?Q?toWRIWDtVgBjFMGwh2Q8xpLjSL9o+HQaa9yAE6+fb/W+at2HalzIBh28HP7T?=
 =?us-ascii?Q?x7S/Ud869YTvlBDc60HJPTt3OrMj44X3JAHhtxNJtXoEkeIfXjbLykS6T41z?=
 =?us-ascii?Q?l/mlJkjy0972tYiMQM6tSyOgvLLlGw7VfDfbM7HMQPYSOY/5zRIQ3ISNB8K0?=
 =?us-ascii?Q?Dc4tLX1rrlX47cP/BzFVYgjfHpo2oCTnwqx4vpavWYR6j5xebv13ysvwwCNK?=
 =?us-ascii?Q?G94FapH6ZPYsExZ0jS8ccR06wYz0TOCDxGiOYub8BK0XZLDhzznvfuqoaWVL?=
 =?us-ascii?Q?L2Z4OTIhQjz7S3wVgJNuBAbCvFbod87NuVyKtAwCZN2gC/hgTlbNWFRXmJmA?=
 =?us-ascii?Q?HtYdGWUJsVUnWF1flb6H0EbJQnm8dabFgTpVrpFoiuLoZKi8XZdv3cg62TaT?=
 =?us-ascii?Q?XWRbw6TnI9GfSP4aGOKhlZJvFkWOM5aE+u6SSu8nCgVT94iYXaO5OrxRmZWl?=
 =?us-ascii?Q?KBrUbScnJwIWsiMhwYqm+QXfYd1n17RuOnMrt1Byj7K5iU/yVIEz26YIeSWI?=
 =?us-ascii?Q?dfs9s6i8yEbpuZA9t6j03TznOx+Btwzd69e9Ha6+bV9Cyoenyw58REjAtL5J?=
 =?us-ascii?Q?/buhrjQsF2YDf5VgUvUpDoYnpMx9eENIWDIXBGNnBS/S0h4kPVkr4mneot6v?=
 =?us-ascii?Q?EiOrt0WKyP4mTUAv8zkPhfiAGLk5XIkKEm71K9EHBlO6ij/9A+/klAcZZne2?=
 =?us-ascii?Q?qXWFhdqPa84FK65vSwtQhjs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BDF30BE851A4CC489EED6189D989F676@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ba283e-0174-4bac-62e7-08d9eb03ce3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 13:06:22.6347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3we+g3di/yBtsZlitzzzm6ak1GNxdR7BA5nXU9XGxxuY4ir4iFXU07xaUviOOnWqFwFozqV4wpyxF1s4sajuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 08:46:42PM -0800, Colin Foster wrote:
> In the ocelot.h file, several read / write macros were split across
> multiple lines, while others weren't. Split all macros that exceed the 80
> character column width and match the style of the rest of the file.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
