Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859744AD8AB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbiBHNPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349531AbiBHNHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:07:43 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C69C03FECA;
        Tue,  8 Feb 2022 05:07:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYyedpbq+ssMOUyUgmP30acXp4c7pErSwvEgKHVt3ogFjiyUzrRn74EALwisG8pb1ywUBmzkO/1pBhkNPRL0/Dfi3/b1DJIYq+ZM/q5FO2Ef1RvYoUQhZqTniSxYHqAFQRs8hXOc9vVwLP/Ji2u9PSKnkm1T/yjpbtBHFFLZ1utItfDUyKnIk73purHAWazE5W0itU2ChBZucUVL5R//VmTLGAt26pPSOeXHTiMmWIP85Oy9COUxrq+bzdigb1e3DvuIv23FUMwSbSrJZp1TeT7twcM0pZoZ+uvH/RMi9q0jdMLGICfRnnpuZylSXG0YVe5Erk+BzWWAiHZfZEOdgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh/eQR4tXJA/nPtfeBbltj9eXaHZtbOdZN7StRfzVWw=;
 b=KqrL2jvHpNXb+bGLpj+SPCpGaeisUUNMraJ81qjwUYtnmwNhy//5F7aldK7X9nVyW3nvxy5yqyZqyjFH0FkRLJkvP9+tZ3k38yhd6vwMyMsNDmIjGTpkbHj8rtCUn9wll29eFJPIyZB63LgXoap80ZfiNBtSeK9qPfdaILrwcFMcjxPtXmJ46F6vgbtwvUWuD9gSLxLE028S8+gFG78d3HIkA18SzkP4s17e3lNY7kjriDTBk0hgt7iW3MSq8tAMPj+K0C//JIieLB1QiKDzr05JITgilnVDp+AZ4afMww5bs5D7qK07ntTck4suLAAWtdbHQ5yHzclIgK52q6UuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rh/eQR4tXJA/nPtfeBbltj9eXaHZtbOdZN7StRfzVWw=;
 b=GRJfN3m9cJ4c4GfCxxQ3Qyh1BwYvwPcpvkeyT+CwaXcyxPhPp1LJMbyMlp8c5FkO3GofvtU49sOUQjMGENgn7hlY62Nv6wy4aeshfd0Zu1f2E0AK//M4GzTbjwnlUFIwbEUO6D2ykIP0AW/chSQhUPIJnnHn4ti6eFxfm8PJpjM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8681.eurprd04.prod.outlook.com (2603:10a6:20b:43c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 13:07:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 13:07:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 2/3] net: mscc: ocelot: add ability to perform
 bulk reads
Thread-Topic: [PATCH v5 net-next 2/3] net: mscc: ocelot: add ability to
 perform bulk reads
Thread-Index: AQHYHKbqM7NATlK8REy/sHIjApGBE6yJoGMA
Date:   Tue, 8 Feb 2022 13:07:39 +0000
Message-ID: <20220208130738.6ejbzr23c2vnot6c@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-3-colin.foster@in-advantage.com>
In-Reply-To: <20220208044644.359951-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 879882c7-13f5-49c4-129d-08d9eb03fbbf
x-ms-traffictypediagnostic: AM9PR04MB8681:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8681378A2F30A7BCC0DBD9EBE02D9@AM9PR04MB8681.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aQF3e4Q/HKxQizfQli4oG9DiYC/DNn8rMITXDBavAcILtmwRD3WmvQY1DIRS/CZH7eJpixhptrmkNZ+avwW/eCDeH8sKrzBOZ4ZUf/xSZsJEvW+eJCh0BfgQE+UsoRSJ61bxAuSN7R+ARUg/2pmUKIvJo4L+7b+GJni082jj2zZDevV2XiCXfqfY5PGPieneaaNDy98+aH6w3yQLR/mx2MKBuxpyodIPlI/2E+hBtATWMwixIhaKoF6ARqsPnXUxtPy/ja9Y2aLJeg6FWTcC7L9WUqnEPiAjKwegwTGxVpQ0WwLKXeqNmgd3f8a1pSrqE+pBFYc4Pe3Nij7fdo32X6NmaRqnK7haU8zsS9jve/BB3svJxJrg8Tg80nb/nePAlhsAX+0gCBBwESLPV2JzsKzjHyCCUNsp+UtUMEMoCk7iuKUZgRCtdHXNnWD9Y7muwSjeBid2XPY96qnTMB/ZR54Yl1cKo6m750Vz9WFXedHtlwHEncIHPzErNB466ajzmGLUkzxfW2gQcgOfzAeBWnTmxlOw5fD2aQRcU1K1SIqyUQgG2vMgD/uhI07c2uptigIw/7LMBYZZ8ik9eMZHB0asq1btTERKSXVN/Snfj3WlNErcGxHxr6UrHKAdes4YNM5zD4w1Iid6LynxFNg0a0Z0YdqJpvSb2hLYcWa8ERuosduVUf1Kqloi+TLb0qtzhHsI4k4y69ZwcUyKjulwzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(122000001)(86362001)(38070700005)(2906002)(8936002)(66446008)(66946007)(76116006)(6486002)(66556008)(8676002)(508600001)(38100700002)(64756008)(4326008)(66476007)(71200400001)(33716001)(54906003)(6916009)(44832011)(9686003)(6512007)(5660300002)(26005)(186003)(1076003)(4744005)(316002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E6jKQgYE1u6Ig4MM3PQ/zn8yryShBMaSr1LjAFOs6L7OD3YpYBPbRhXStQOQ?=
 =?us-ascii?Q?pDTUsBWdlxVVlQepdb2qBk8XmjsfV7aQb4fsXuYhKEV4I63J5bZbfV4OujuG?=
 =?us-ascii?Q?502cqIcTX/WmV4y6Oe9IwiGpqtibl2sIwMsxtkbbNpc6senodvPahZ2PuAE9?=
 =?us-ascii?Q?N8Gs/VTKeYJdG2Ngh4qf9lOlrtePWLMaEFOKwxoa4WTl+dyXOcCcozyX4fXS?=
 =?us-ascii?Q?sx1UnR3qmkknIqjhZvVi7Ftbx4PCblZGnMNI60huaMdgoZLEto6n6WxfAagm?=
 =?us-ascii?Q?oaK7CUMWb5tCiboVKFjFxVwpPT8GZSJ0/vcg5VvWkfWc0mFxs3DN8TuR9Uj5?=
 =?us-ascii?Q?pqQjKEv4hIL6Vk93PP5lJ5FvlHSgAhqxg/IN+UiV8LYqb6BqqUvqgq39AOML?=
 =?us-ascii?Q?V3LPJJ2hx4efLoWbOPvlOBU2oG0wVzGp8F/TvW6qAPKkQXKTPMhSyi8oFUj0?=
 =?us-ascii?Q?O3i5DthdrmQd8RhiQXCs3WvgmHVwyxpGCkwknTR3S9Zj438eXeZKq+4cMqCC?=
 =?us-ascii?Q?aWLJpbAPkOVgVNX/Y9WuovAgxT8vSQyeaEKszk/gP1+x9Xb9Z7gAl4jHaipO?=
 =?us-ascii?Q?NEbYtBeKNwONL3dxOFV5xpNdUavVGMyFhaWnSeV8UKMzNzAM0j2+J5aPQ6ZS?=
 =?us-ascii?Q?3tyKqgtN7A/SH2A0nTeBBospXMBV557ViDEaMlLUJnFUF1KMvDAGZfb4YADm?=
 =?us-ascii?Q?uO94bEJ4X1f3fcQ9bPRSGAQm0ezudQhgkzGKBqYTXICdD91rz0fg3XDRbSU+?=
 =?us-ascii?Q?cZD8F1EENtlR98o8GBoZbzYxlUhaJbxcRb8gE16e3+lqSoIXPrhbqeRuNF9d?=
 =?us-ascii?Q?fsG5eP08OFDmvGWvk9VjQXdOt3+YG4XK9u4Z9N2lq07GjvNGh9xid6417/F3?=
 =?us-ascii?Q?yitH9ARXxXVBRMONBwiWSZ51Mvcy2RWqv7s2aaLeFbBLz1B3LajU65zgJFqG?=
 =?us-ascii?Q?aHv3P2uABN2U2ml2LuEMVVjzhbMwyxUDNkqGDNpUckPxRT4mxgyuv6nqpCyc?=
 =?us-ascii?Q?4sXAG3p45qSSqNGSxzqm3xv62Mbz54Knzj7g0FL+RJKY+MoPOm1YjiXFajKT?=
 =?us-ascii?Q?K7KJAQv8kP6CGOU720Nw/Jht/7HeWxkx4QQgRIlJwDdRP9PTchIVWnxV9/5r?=
 =?us-ascii?Q?hX2AOxbnsDG1kGellRWssqANBmKMWnweX8DKxPqR7LAuF6ge33PR+ISzWEGN?=
 =?us-ascii?Q?VbitrvRRZnmFRIhoS21IWctw0T/Img7x9ufOr/0MRfxQuDXUGOkHceu4TD1f?=
 =?us-ascii?Q?x8//7E8bQ95ES5jjA5Bo9OjiXiyglpgnpMJ51Qrk8hAqTWMmqGgEkILrTlxZ?=
 =?us-ascii?Q?IKXPrDLT8woOqbWiAUUW3TJS8aVNQaLXmGJDp5VHkAaksLHEqE3jusczOOXL?=
 =?us-ascii?Q?ZLBzKhOsPGvU6sUKkyd5LQXytCkQvYhUccG38UqhpnZKoH/HGrasVqueHwVV?=
 =?us-ascii?Q?ZGSjvMVmyvWnnW5lcq/bSb5e2w2Zk6oxqSGB/VyOAIyaFCnrjlLZtO6Z0ACY?=
 =?us-ascii?Q?QWAleMAAaOPpZ5OwNBSbD0iuJZHAWess+B0mYOGUYDPtelI0yM1ZEu2Z8Z6n?=
 =?us-ascii?Q?m152WlgLjnAU4/Vq2ZjXA5Zx+DHY0wVKg7eQoyseYBNwVS1BU9+Z6CTgn2Kw?=
 =?us-ascii?Q?viQHufzszAZ9cyPdtKR6WHJ1Q9WbJHma20/YjM7YA6fu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16AC71BA05C4E34BBD2EF4C18F3A90A4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879882c7-13f5-49c4-129d-08d9eb03fbbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 13:07:39.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RUGx3UKakaX/TLbMZB7JL9cs1x1/9bUNtxMRJ7rdOlIV7D30VkXcJmTvNCo7d4TxCJyElp3bOdWb8F9u3dEW4g==
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

On Mon, Feb 07, 2022 at 08:46:43PM -0800, Colin Foster wrote:
> Regmap supports bulk register reads. Ocelot does not. This patch adds
> support for Ocelot to invoke bulk regmap reads. That will allow any drive=
r
> that performs consecutive reads over memory regions to optimize that
> access.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
