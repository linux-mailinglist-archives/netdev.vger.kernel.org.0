Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2A854B2C1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiFNOIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243565AbiFNOIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:08:34 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EF813E12
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHW+rrvR+gnHAfrfQuaQckn8j+2gkY/poCtfgiuiLryGV4+KreH1YjDW9obQ54ccbDBF43wLlFVLHJUD1uGABE8n2zgvS09pszzTqgZyKQaQapb21SDjl44Z9UEG/ZOFQ6hrvEN+U8D1t3zd99M4tjG+FDhSKuDhxu2hiccvHtWSu7MrwGN29WInpLE9zOEm8DjKzf4vD1G67viPgmdQp1J5z9ss7lVBV5khV994gUdOE8Kb9NrXLwvXARAxLNE0ABJWCQhpoA3OrJCF3JQR/Fog05sTR+fthmZSleJmJb6mKc+GSbVhs+Dl8glFwewg7tBdbGRnniPqjRWu+91y8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETxuuCMcp1vk4FNcI6ErZvDXohtDEhzzJJxSjva8BT4=;
 b=kmx3dJ7Hu3wm+P5/vmOftEnzFplw9MUblKkvn+FuJag3xhknKnR/ccbHMmOg6+9T2x/YZhtZsqiwDOihYjwtMt5qQmFl7+M3jJogkTr6ucHzL43NVnim05c8W0O28tHW8+tYDpQ6RCtvjTBq502RVeAXwfnm7yO8dzuIC+gt3MzeTC6K+jGDojAst/udYXZvGFo51B/r6wJ//V+ZTjkKbxjek6D4U8SE8imWHh29nJiEuynKPOM0uk0vmucs238LcFHYn6porP9UNvM9mEdKODDpYxpWeGU/MT8N8/FKqITQyojHK0uaq7jqabsgqiYq0aUd7pfeyxs/xVY3JjdvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETxuuCMcp1vk4FNcI6ErZvDXohtDEhzzJJxSjva8BT4=;
 b=EVnTuEIDe1wfJHaFYRgcsyoNWL4IESVJcTcg4t3LAW3xoGi7y0mhTbaSQrYZQrxX89LWW5KhC+PWU6PwZAX3qvz4jCtxJ/11fjrfkKO4XPGmhFt+AmLrsiz1SF/2ooQiqpTmGL+dFk/221iIqS9H3H2Jd5JC1tXSsFcUpYIfmBw=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DB9PR04MB8347.eurprd04.prod.outlook.com (2603:10a6:10:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 14:08:30 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1%5]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 14:08:30 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: RE: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G are
 not advertised
Thread-Topic: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G
 are not advertised
Thread-Index: AQHYfKXSil1P6dug1U26HZopRldC861KTn+AgAAtI7CAAF7XgIABPoUggAAzfICAAn2Q0A==
Date:   Tue, 14 Jun 2022 14:08:30 +0000
Message-ID: <AM9PR04MB839798057AAD153AE644B27E96AA9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
 <YqSt5Rysq110xpA3@lunn.ch>
 <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <YqUjUQLOHUo55egO@lunn.ch>
 <AM9PR04MB8397DE1463E47F5AF8574A5F96A89@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <YqZZs7EAcAFpQpXU@lunn.ch>
In-Reply-To: <YqZZs7EAcAFpQpXU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59e1808d-56d8-4b35-ec45-08da4e0f5c70
x-ms-traffictypediagnostic: DB9PR04MB8347:EE_
x-microsoft-antispam-prvs: <DB9PR04MB83477E5566AC5899987F546B96AA9@DB9PR04MB8347.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TgW/dI8aH31Yf+iVx/w4cJ7dvZ67s+djDsNOUqby8a2GOkenBACZJCVC6Ir738ZIBNhQzrmeFAbE+9vGzDRllYkQXwpUovP4ZcpyXzmX0aaaUu0dO25WX1kOhNUZci67w9e1peEjkkOhPp9HQGEI0JzcE+CTmMHIEYhoOzRXStrwsYsCxcQvG5gFW4wkyf3MVVLLPQsD7CVKYOoKHk6ZGA38T09h5dEK0LunbSl+rZrbBUthZDwiH71qU9rqX90pWS05/9v5jv9XAiqmYgdmXW9nF+8nUMJLVUO8ukurcfT1XfMCEh9+eHSLSOvPYwDUK/pI8jFLO0TMG4/mxDBtJd6U0OJJAWB70//+FVoY89Eqvh/eehVZFW9f+7ihLbi7PB9jbDXiCNxHRLmJUnUoMb0Ux+IZuBXXHC/6okvCXWHB5NxiJMcEXtfwtoX7/HOnPUa0aPvZunvyCjhz6OlxG9Id+N3R2Cj7MFCEtZu5pjBm13rfXUBSsRhbaBkhlZXd58nX75VhDIGncCxTDThvdsILoQfNQ36hc5SgNEVEBKtigIpFBJrpm9e+WrC6FgcBxGOqpNwt95mTDLkV+Dc6SErHIVFwBhtkDgsvTZPncbwwvzPWFryH95Kh5zJU86HmER4o14Reu3UGYuokESK4ATdOc5TZQzDwzgAop0IRu/nAgKWaGJNgcyOh0QGCXIVVOO676F3aKCYpGCBUgO+ahA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(44832011)(83380400001)(33656002)(71200400001)(4326008)(2906002)(86362001)(508600001)(8676002)(26005)(5660300002)(8936002)(53546011)(7696005)(6506007)(55236004)(52536014)(38100700002)(186003)(38070700005)(54906003)(122000001)(76116006)(66946007)(316002)(66556008)(6916009)(55016003)(9686003)(64756008)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8ebOc+Obzje2BTac2mhMT4Rio7QGts5A3MjSKepI5m8rZjlN8n64v/4kFB1l?=
 =?us-ascii?Q?PGuBp0tRj2tBUZPYfjIFr4/lGrNiomBjx9o6rP+Ipg5gpXx+B2cD3vEVcmNh?=
 =?us-ascii?Q?L3xLtyaP2sX0xL12zSEnmummBdb261X3kHby2sGZR3zIsILuueU2Qotp2MNL?=
 =?us-ascii?Q?4NygOqUyAcp07GSGvNmUc3UITRb8TAHrzqo0gRuGPt53hnVA9s33aPMlffFx?=
 =?us-ascii?Q?SgnevZmKNMkHRb1YjKbMw8tmcPhVS9OkC1WaBLFScdKN1rIyZRnv35Sq2yhs?=
 =?us-ascii?Q?byV4tVFDnyYxiopRYiohE1Qq5JfIyXvNNCUhsqeRYnDuZD3LqD1i0E9LqUhs?=
 =?us-ascii?Q?EP1abom2FD7/Pwzt5jssQeEaSfxnfonmHNv85FDYhzsVLUhbujQ2ySmaoGSY?=
 =?us-ascii?Q?eGs8qO+twIR5vgnuKaQIiPo0nkPDrRO4Bn7zNFLW29c24G456KvwIkirad/N?=
 =?us-ascii?Q?Zx+aiiAvjmu43zbmv/pJu6Q+00VTAS9O1C9ywJbpVTWE7eJ8II4kLHZM3W00?=
 =?us-ascii?Q?ClWvoheVYnGlt3oVNeXt+M1ETxY64wzFkFxVOR84Sx9TsFof03UOIA/oStix?=
 =?us-ascii?Q?D1C3Vps865u0FQLKobz82pwCS8pBfSwHsKWMHYU207VLsOXQjf4GSCsMZxle?=
 =?us-ascii?Q?n6h2kUsQWUoe3p7eC+CxTHKGuEkprvfYFQ9F5iV2YcQHU+Ixp4uSB/UrbHtt?=
 =?us-ascii?Q?2lXvUkkJ8q7vPxb+GtmAv/ZX5HApu3Hgx+VUI1HCv2o/bTgUgTlyHSgiIvzK?=
 =?us-ascii?Q?FH3fUtpn6wuKVCeOUP+ElP5wiCYd6PypTI4RShcWL4g1vRdLwA1nWpr2/IA2?=
 =?us-ascii?Q?k1gzK1vbm3j+cDtpYzTEVdwDBTihofmHteFhk9xi4hfAb+wuGMxCVVmqxVM7?=
 =?us-ascii?Q?a0Odtz+T+PqrSri29RjkDEuEBtHVA10aRidWl3zuSsbxFj6czemdPnZpMvGD?=
 =?us-ascii?Q?ib+GEWymbPNcH0pYaL1snDS0Y2lF84/vCwDiADo3O2jnykRc5Wkq5dVy+5dh?=
 =?us-ascii?Q?j3TCJUr9n5TjiYL9HkAN5KGK/+BPeomgROGKc4Lsn/26gkgpfblqQh1Du4Im?=
 =?us-ascii?Q?XX6XgQWRNovNgNFT/1zii/UWWIrvEdWmGJl0mZbP58mjWfTaNjefXsxWLVfk?=
 =?us-ascii?Q?ZF4zO1bc9qNyHnSjo758mUw5ZoHRB1j7dzYbw8VK3nJdseBUoM3ABhS+lThC?=
 =?us-ascii?Q?/okKNE4h5uMQZOPGkB4sDl1hojyxPh3/PQC63XcLTLcbrFN3xgc3V31LuyWK?=
 =?us-ascii?Q?r0pJUeAee4siXCuKVO2rwOVY3EGQJMC0GUUW+bjOtpDT8cpFfjLKMk+ZQe9C?=
 =?us-ascii?Q?suxdfnilrqJQYGHkWjkRNK4vaPcnrrtfAgS/yhfBDJkXTqZ7mpt3xCwATAzN?=
 =?us-ascii?Q?2eNXc/Q76Uz6yrMJGkxxWJEVb8aVr2vpJqU2n55cGKXccl/7C0tFXXKKzNuk?=
 =?us-ascii?Q?eTslmocrti1VIzf70LKEuEngLzv4/k3O4wYt/K1vkE+XqeeoyVi/PV34hmq2?=
 =?us-ascii?Q?hRPx7TnyoBMmJ4MJCekzSwV4qfiP3Z3BhB35MUB6QkPyG9Aa96H5ELOOi5li?=
 =?us-ascii?Q?wdETRUAiNCtUdVGyOJ4Zwj4S0j0bsoVRLSgSPYVqepwo5YFdaHRMNWqWqzUK?=
 =?us-ascii?Q?GVVqX83dG5GPOMwKxz/w2Zyxjy817AB+6c+AEfhcrqO9lTKMHL/Ig3DX45VH?=
 =?us-ascii?Q?iyw4QXC+M4lthk/JTF59EBTv42Kb3AIAM5/wPsik8h+39cZlWs7pq3EZTOM9?=
 =?us-ascii?Q?NPKS16OLmQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e1808d-56d8-4b35-ec45-08da4e0f5c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 14:08:30.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KG0FABAGXU2gmv+jY5p6N+m1X8ZUzCmsaeGmsHiNCGW6owGQwY9M4vAL6IEfLqhgyS066Ndq+xYa191Eh9jSuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8347
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, June 13, 2022 12:25 AM
> To: Claudiu Manoil <claudiu.manoil@nxp.com>
[...]
> Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1=
G
> are not advertised
>=20
> > I understand the situation is not ideal. What I could do is to provide =
some
> > logs showing that writing the correct configuration to 7.20h does not y=
ield
> > the desired result, to have some sort of detailed evidence about the is=
sue.
> > But I cannot do that until Tuesday at the earliest.
> > As for documentation, there's an App Note about configuring advertising
> > via the vendor specific 0xC400 reg but I don't think it's public. Not s=
ure if
> > we can use that.
> > Meanwhile, it would be great if you or someone else could confirm the
> > issue on a different platform.
>=20
> I don't have any boards with these PHYs.
>=20
> If there is a vendor document saying it has to be configured via
> vendor registers, thats enough for me. But should the generic code be
> removed, are those bits documented as reserved?
>=20

Hi Andrew,

The generic code sets/clears the MDIO_AN_10GBT_CTRL_ADV2_5G,
MDIO_AN_10GBT_CTRL_ADV5G, MDIO_AN_10GBT_CTRL_ADV10G bits
in reg 7.20h correctly, as it should, if you're asking me. The App Note als=
o
mentions that both registers, 7.20 and 7.c400, must be configured.
We're trying to reach the vendor for more details. You can hold off the
patch for now. Thanks.
