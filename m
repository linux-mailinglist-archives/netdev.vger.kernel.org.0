Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDEE32DD8B
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhCDXBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 18:01:13 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:56579
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231694AbhCDXBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 18:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9zHUIv8W5l4y+HFwyLtA1FwyaSg+gl25Hr3dHsov3yQ92pl2U3zgcgu0oxqBVTbov08p49wQXjmShICbfVzxeGyF4r1gu156a021rBWPMuur7RGzNAJTu30ptnAEH/SQmYIEw77uXW1/3v0DPK6NrZrEnZfQvEsoXosmLce/6o8gvp0BcPIVyxMfqKiXBZl9x/ye3oD6vwKPqLnXsIQlHI90JDE/vVKNwWh3pVT+/jOBpWlVEVuoJrk2oJG8tF/ozdBzAapEP0WSlABWsio19/Pbox0Qy6dK610y33YMVE0hWWF/WxPIDCgWi9RTv6qGGyLei3pNWSHHOrwwlaqHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KisYPTOfh/VUEYGnJeDGPBazilIf2eJxY0s8+zbhrB0=;
 b=UnDRkcCjfKzInJkMTqUt2a2yPsG8URKQ1NQVLihEgwmu0emH18GBLD7hIr21SkgT9bN3BNSV6BL7Y1Y1fvyh0lKNy3QxD95c64urBHHV2lNDqbjcTVnziO+nqZMzKzC7+GNTeGaks5dPLhR3lHNao8xRHwEyaIkXblXJFjL+ZUnaMEWyLsEZbhepY5ejWKHYd/wEuFGLB/UPIYc9QVvJT2G7+8TzOkmPpWLzyXhFXinH0gAfBEF9xGcia9Rsy9tjrz/WaZEroZ6FJArOKQ77FqQXHVpKmjUZ04VS8UF6Y/NTQGYmkkWnU4M6D8mcbHrvLSbH+25V9Tk0cijOkFTTCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KisYPTOfh/VUEYGnJeDGPBazilIf2eJxY0s8+zbhrB0=;
 b=PW5WY+3TkfvxVovpR3DjALcSBGEzY2Ig9QyR2bHifD6wEcaJtzm8cGkqC/3NvYIzwDWKcAvBZzgf6kGoQ578YQFZvKDoFbWI9X1C5VXXlaQGAyW5aH1FD8phRddna+Vycv4cyLIPKG04d5hTIRKjqyRVjg/j2XO2DfUogSVhnK8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 4 Mar
 2021 23:01:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3912.022; Thu, 4 Mar 2021
 23:01:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH 045/141] net: mscc: ocelot: Fix fall-through warnings for
 Clang
Thread-Topic: [PATCH 045/141] net: mscc: ocelot: Fix fall-through warnings for
 Clang
Thread-Index: AQHWv2tS7JUUzLFrPEeYvwOMGmf196p1E38AgAACMAA=
Date:   Thu, 4 Mar 2021 23:01:09 +0000
Message-ID: <20210304230108.3govsjrwwmfcw72e@skbuf>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <a36175068f59c804403ec36a303cf1b72473a5a5.1605896059.git.gustavoars@kernel.org>
 <20210304225318.GC105908@embeddedor>
In-Reply-To: <20210304225318.GC105908@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44797c86-190a-4c6f-0e4d-08d8df616640
x-ms-traffictypediagnostic: VI1PR04MB4686:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4686DF8F00162466929FB47AE0979@VI1PR04MB4686.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIya7n6e5fGZCywuWnWwmIc8C0SWuC3gQV2gyuMyin9may/AEbi1tVhsu/vCmzL7JdZT/syRoHd+jWqhdNl4ygO/WdedT96uQNH3MVMZclMnXhcRaJIQfgyaenID6ZIWCIZnrRxp/bg/rtUAHc+S4Tex+S31IrRBzDVaLtN9/lNP3Gv/QTBo1oATYcIPUywEAzG+aa94N6Iprhp4FccWXi3xiuiMwMJ6Sa94bVX2J4uYneL42Pg7rfTfkUMRVjYoQ94lxn7YKpeqXdnXeXntvP9DIv88KO1UoUoHZoj6X9MIusPYSzGvwDW3qjsr9E69+k98wlxM7hEP2OOhE1jdlH+MFZ9+ITxR4b3sbJ3JHiey0twZDuDBVy1ErmFNda6LTYGMh3mrpMJgawU2bQa0kRmGhBt4GVKTIu0B3BTSiRQ7XXn/4+XXRLjcr2xaVvJq7joY5EpGRrAPLg+EvBAQNCcPzZscnSAv+XjZSwf+IyMdayEQp9c8g3H4YRpeHYibCoQB1SFtgQfH/ZqHdrurFV7a5ubrIxG3EFp7KU3/tAINBVvINKde27QSUYOX+N+bYnBTQppwTVv7umL9S+GtAynyOlNn+yzb9C4bxcuxXT0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(376002)(39860400002)(366004)(136003)(346002)(966005)(186003)(2906002)(1076003)(8936002)(33716001)(8676002)(478600001)(44832011)(54906003)(6486002)(66476007)(4326008)(6512007)(66946007)(9686003)(26005)(66446008)(66556008)(83380400001)(91956017)(76116006)(64756008)(6506007)(316002)(5660300002)(86362001)(71200400001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QNmPl76eFeSRq5d1x1WM2UxQGouA2yhqyxfvgLYaF9NNr8fk1RWrkosi0DtW?=
 =?us-ascii?Q?fJyJ8S+9I0k4hKbYGNhbg/3cfwmRpgp+DqItXK73rCHvxYIEKPrZKbjNgcX5?=
 =?us-ascii?Q?jvg2Y3ecPpgatyq0fXhvmAEzUCzAubK3tc+zZKXWZXfZxFw2WZuZRwq/freY?=
 =?us-ascii?Q?vYKbOeWAHYM2vStyhIx1dJB+w5/D39lbR+/Z39B1EKLUUY5lPsDNqkcwgczz?=
 =?us-ascii?Q?iP0JvYLLIgSLa5Hq5UigxiZDYzJHOaaYENVihwO3KCAN2TV5dADsoUVIw3Zg?=
 =?us-ascii?Q?TSLam+0yILbVvxIeOtGnZrGXUP9eTPq8HmUBS+vMmxCyPv7D1MzBbZwuENnF?=
 =?us-ascii?Q?Oc/5LYd2GPnsh7ODp/r7nQxc2WDlxsIfQAlWt/fZg2/eLXMCS0gtoogW9SFg?=
 =?us-ascii?Q?/PywYxSsmhnIy+DmfaPSQn7E2uAZZAi4PlNYLE8HY/koh0gJBzwTqquiGWHU?=
 =?us-ascii?Q?Pi3dtuQIaSpIDqRFbaDpwDzQDkwoVuCYn55/G9Rwjxuqw18o2awCJL3khgAD?=
 =?us-ascii?Q?Og5jMhCkdbT6QAndjvwHnMrH9G8RiJyHkVoqpt3LhDqIEUSV8g+zuUH71Xie?=
 =?us-ascii?Q?ZEfdbnsJPvNJtV0tbRxBnDJCoUDV+JUx++ke23MBww4LrF+cFDOdiSbwyUKD?=
 =?us-ascii?Q?vrytxHg4brFYywQ8BesS1gG2v8nkSsXOl7gKxh2QanZnT+Wzwe6CLvLDZjDV?=
 =?us-ascii?Q?yLTmiVjsCYRQ289B6+F3zHw0t/US9wpCwN4f92+0CeFKxxHOhTL42MEXbzss?=
 =?us-ascii?Q?o9CskzvcBKocy7opuM3PDu8CC8VDAuWxtwOsjKuqeC8a+FSCWZmJlu6Yh5+c?=
 =?us-ascii?Q?0uuynglXII8UYdqCaQ8mO5w2NyU/1JW+q0NWl1JOvazHq7ZFxtU0eWF2V+ZF?=
 =?us-ascii?Q?rVqdqVB8GXfBZ9qyJs5sx3GLibayyjHMDwooG9w732HM7ShHqaHu3A11WpjH?=
 =?us-ascii?Q?gvRkpRzHBgcutAWSDCV7yoS/AFbYE+UG7kCclczsJ1iY5ZZ3rcJPZgD23pMg?=
 =?us-ascii?Q?ojrTfFQsgCIPEuwVYaHpXGGSEVQac0q9weUOSi+pliK1HNlk5O0hSHyPW65g?=
 =?us-ascii?Q?WSZhRmDPHEhHYGU5notVDvfBtJDVKlam+v9hmHbWs1HG/q04uCKA1214wI8E?=
 =?us-ascii?Q?d4m8OeHuojvBsE/SrGfpGdwMPUH/Lueoa/cNAvWzfb4wIAZei1NI0Mq8KF2A?=
 =?us-ascii?Q?5Zpqio4mxFGBgwjrWiZtduH48QxeAtQtchuvwUqcqF0RQsMTpiiPQkvRDkiY?=
 =?us-ascii?Q?GVeZLGOEIGzE25nUokt0bgrBYGam/G/g8AqFLl8KVfIcGexgiDvmvDlTaFSA?=
 =?us-ascii?Q?HyyxJ94RQZATLIZY1x0sq70fHTOJYByOEEbs3KvgWT7F8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32593CBC6DC40C4B9B214FA840FACDE1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44797c86-190a-4c6f-0e4d-08d8df616640
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 23:01:09.2721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y63YdKpwwyVf+1WwXLv6TLQbVm2dpqaYC7PELeCrlnq1Qycx1l7xXbbC9bhPnPw0Sgt6MmmHXUoTdDsKFwrRYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

On Thu, Mar 04, 2021 at 04:53:18PM -0600, Gustavo A. R. Silva wrote:
> Hi all,
>
> It's been more than 3 months; who can take this, please? :)
>
> Thanks
> --
> Gustavo
>
> On Fri, Nov 20, 2020 at 12:31:13PM -0600, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warnin=
g
> > by explicitly adding a break statement instead of just letting the code
> > fall through to the next case.
> >
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---

You'd obviously need to resend. But when you do please add my:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

And by the way, I think the netdev maintainers might want to take the
patches on network drivers to avoid conflicts, but on the other hand
they might not be too keen on cherry-picking bits and pieces of your 141
patch series. Would you mind creating a bundle of patches only for
netdev? I see there's definitely more than just one patch, they would
certainly get in a lot quicker that way.=
