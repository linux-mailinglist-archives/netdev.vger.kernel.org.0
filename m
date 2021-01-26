Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD3B303865
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390525AbhAZIxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:53:25 -0500
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:27310
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390499AbhAZIwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:52:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LH8YGHyq/oRAIBU5PkbHoaO2I/lNeZwf7176yTRJAGGB+ap8XomgDYfSSJK3xfrZd2L/otZE+xtbilT+ulp3nRpmjQ8+1zvtX2rhHeUktmzkDDMKwP06sIST3cfarZDVRfloruH3HE1KZzG/n2jn3KKzJw+u8Q+SbFIs4DAGT4Hz8bX85NGoBDvbPnuKmJqO3NSG+RzwUAQs3tSYb+1gxWIkJA3dkXg0SGB873VuO9gPog/SU2RYbh1qPEYNbiEIygd547NOMW1wUGoeiICZI/2K1GNoDCUJhnv0OBbBEjDSpNMYm4bIhFa4ulRlcaCLCXEEn8hUuvZ20cVK4y6NMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu2YldFnltaISAy6Bw8TLYvc+ts/ek1qhKlS7Tipu0Y=;
 b=RSnCz48jAeWzXgCOnDjzrklXpkgsjw4eVuzHi8XsbJpxi750Sym0gCR788ptujyCzsbFECiPv4Z13whuDESzf40QZz5tSph8oPMdXV6W3MNedhaPEN5jZkdQwktsd4/TjaKhrMOm+GS2RWEHdHLbA6AbYSKDjzm2inDWjTHB8/YmPYne34CH4tXz5jVti6z1HMbaEJtIQrOF0hhzH6z6nsTNbQvuSKHnl/WInj31CL3pZf/Tf470SVPBEiuaFufWjjgOzOrJlMeOep5WTjCE937p/J5lk3E7m0xMlL+/aW0JOkk7Vv28ILPCT72G/1dhXhbztW4o/kJN0zbOPMn4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu2YldFnltaISAy6Bw8TLYvc+ts/ek1qhKlS7Tipu0Y=;
 b=JWln3OZUbEpdPmDoEOO2EM8KwsoXTS/CyuTTBtfYLbUnqEhENHF8XzB7vi3Jw4Ta7X1qqrGGyZ4hNNmd/NDm8O8bRqq+h6B9PTmZfB7cOJ5bbsWwi6aHwmSJtbo1msokH+ZpQ9icZ57AM6E9T2kngrzAlxu1SHWUVvMvY0KgstE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 08:51:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 08:51:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2 1/2 net-next] net: mscc: ocelot: fix error handling
 bugs in mscc_ocelot_init_ports()
Thread-Topic: [PATCH v2 1/2 net-next] net: mscc: ocelot: fix error handling
 bugs in mscc_ocelot_init_ports()
Thread-Index: AQHW8vYEy9kRVDNRbU2EPw8q4M1MGKo4hWcAgAD+MYCAABdrAA==
Date:   Tue, 26 Jan 2021 08:51:43 +0000
Message-ID: <20210126085142.rrr6jbm6hj6ijjzq@skbuf>
References: <20210125081940.GK20820@kadam> <YA6EW9SPE4q6x7d3@mwanda>
 <20210125161806.q5rmiqj6r3yvp3ke@skbuf> <20210126072753.GU2696@kadam>
In-Reply-To: <20210126072753.GU2696@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95e71142-e852-4963-fee8-08d8c1d79afd
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB25118B38765C69C6BC08FF81E0BC0@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Il3p0Ouls/Or/N6qpYVDgk9032C1RRJGxrhojl67ezCCnhnvNJWuCEKL/vOBeCsJvEAY2LSG8qM+fjWFOOvExOGyxxvuKnlbfj2i/g5zjBSU3Zp3DOB/NZpN1Uw0oVFDTCKpamUD21jaV0DOY8NpR1A6BmcoJSEbpgw0Jvzdte7ZyQcD3CX/60A3O18W93m1b9BHAq4cqDelfk7mspjAag5ivTmdlvF0kOsY2IDT07fQznMHfCCiw+9VWQILiFpRLeGmmQr+dboa1sPZ2NTJpFJGimYGN0egV0BTnEGiEC69qCGgq/bC7z3bIePffnQ9tfHQJUZZEJNNnw8jvyJFXaXb4JTxzKskRhVbNfoqDkghPSmh2vEjMn/Tb0vUSgO4C6sK8T4byiapd+iBKqyx161SpuhvOyC6/K2A/2jFS/OHcNi0PfOL79TrxnB8xOCAdvguQOG7/aCyPAVWrMvaEYUBieRbn08v+jJDut3brF3iEJbRmZoobG47Z+JirrhSfiAnvO2NQumHo/+P36MrBHLfWiMxiF8sxLLOVgCtrVvkOHYC+puyK1//WsGT3fvDUaZ7LH2VBXLJpJiQ2eRQKfIapIaSpDvIu5Sn03IQQA8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(64756008)(1076003)(5660300002)(6512007)(966005)(66556008)(66446008)(8936002)(86362001)(66476007)(44832011)(54906003)(26005)(8676002)(66946007)(316002)(2906002)(9686003)(4744005)(4326008)(186003)(6916009)(6486002)(33716001)(478600001)(6506007)(76116006)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?T3SiscXcQP7/rYqUnBCCOZGBIXGjiGjqxe+Zm2hjZMOZphT5nTCebmtm+Ubr?=
 =?us-ascii?Q?L+bvyYLoPezH6inj/yYJRr/cKgWV9bfVbW9IFVMjyIqfn+gfhGt+22p3eNo1?=
 =?us-ascii?Q?uRQ96ZTU2rmvNvdP4AqN5zaMe8aNoLbi697ebZFYd0W8AxBGa/QkftC0Gvrd?=
 =?us-ascii?Q?vCN7BqTECVC6U4cuxv4UOATGmxdjTTpFeuj6sgCPV3udERg2lSrvGhGtfe2Z?=
 =?us-ascii?Q?vEKY3ZXeH4iVnVGfy153BVi6v7N359ZnHZ9AkgxrOioRRMxKZ0IpjXzyj2qT?=
 =?us-ascii?Q?dLWuhqGhcEC2fNAmjO59Q5RxGl3LURTI+jhq5cl1M17j0qwst1xuEu97VrSe?=
 =?us-ascii?Q?XuBwCVv1uBy3WvDywIsqHFNQYWk2zYSbUIv/tKn8iAdcAF/jvu1gVHcEzamW?=
 =?us-ascii?Q?OIQmIz8VQcXxG/U0wQHZWsOX3LiuftyaGImIrvKKX7hAOiq9Q6ULZefZAEuE?=
 =?us-ascii?Q?NVR5c86SRwIXAM5HjQl4hq2TQv0cxuRmrHQ3CMIqu5gWSb7C3TFLIPhRibJj?=
 =?us-ascii?Q?PVQh25+xu9NSNhGSkhhttgE/PoIg8lL2utRD68eJsQciaIE1+idMm06Q4qYA?=
 =?us-ascii?Q?jeL2l78gqbAEDOEsycoewMamuQL+yiBSE8hnldp6L5/9YApHdjDUJpbK8iCL?=
 =?us-ascii?Q?MIibYPHaHQfdoW5WTDIlObdIO6YdBQOyntWMmdQUubg2/I3JXDOlEUulQn99?=
 =?us-ascii?Q?8kbbkh4NqCRGVhQNpFQ62TmqHrVoRcxAdj1/eAho98+lYRlPSwNfEzmhiRsx?=
 =?us-ascii?Q?AWwk+vceGE+79JsI9dp20f0G46LToUaJjYT3ES3sSyu/WwXMtsI26U+oBiSk?=
 =?us-ascii?Q?EKVGAlxih6/NORZgIkhXToCW544Sm4tswU1xASrtvucNeq+iZf3+lI+2RaJ/?=
 =?us-ascii?Q?gSI7mrLr4jUsYs78LYGYhVLAbpZddRdOHjtz1kJMCZohQDQ2Ult8czSSaGer?=
 =?us-ascii?Q?xIf2mq9cF818j7tWxR6BQWuopl7r4IhnwB1pFtzwU7QxXl8GxQhKnTxrmfCL?=
 =?us-ascii?Q?ES9A/1t7GOlH2/5BcfzxmZKssPW3sIXJ/IXKjutcNkueL2kO+SVtmtrMfQQ5?=
 =?us-ascii?Q?HUk3RJTW?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16931E61DE79F04CB10041CBEAD631BB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e71142-e852-4963-fee8-08d8c1d79afd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 08:51:43.4812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4N6ioaziD5cYSzRbLfYlxxJmeT+dkAKtSN6C7Wx1bMj0fb/Dj/bGv+d24lbcxbCuJGCQ+0CHVDsGyCEwfs9/gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:27:53AM +0300, Dan Carpenter wrote:
> > If you resend, can you please squash this diff on top of your patch?
>
> Yep.  I will resend.  Thanks for basically writing v2 for me.  Your
> review comments were very clear but code is always 100% clear so that's
> really great.

Until the code is wrong :)

> I've never seen anyone do that before.  I should copy
> that for my own reviews and hopefully it's a new trend.

I took that from Florian, it was helpful to me when I wasn't minding my
own business and touching code I couldn't test:
https://patchwork.kernel.org/project/netdevbpf/patch/20201218223852.2717102=
-4-vladimir.oltean@nxp.com/#23858835

> > Also, it's strange but I don't see the v2 patches in patchwork. Did you
> > send them in-reply-to v1 or something?
>
> I did send them as a reply to v1.  Patchwork doesn't like that?

Nope.=
