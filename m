Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1162CD19B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgLCIpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:45:47 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:59013
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbgLCIpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 03:45:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmbPh9DO+gaap3omdeL3WOspPcfgwtKbJcRenEj9yzUDwiR2MYd06PAaH1M55O9KKo1JXPFWLaymoZvIbbCRsVeaLgM8oe2dSe7sXUqsGVr4bb7BhI2yn761sEErG4FQoRxLDP/tFlN3UFawZQNo54DllqTE62y06lI85VbmA0ZwB3L1kVBDuvLu6nNnea5MuVx6+oRu0bwuQnH0q65GuZIa5PrwG9R1giFPlcGTUW1N4Z+e6GwyFDLLgfY/mdUkzV28lp5fZ1CbfS86ETlCPjB1pUmvGWavzIi1EyMPk01Q8ElsSkTbwUd+sdN8B3akohoGl+CQXTS/xVmeKtedmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqa+l5cJ2TpB6HiAwiUPsk0VwdrDvWoSt0Q1hC9acPg=;
 b=hATh6oPUdY7vIdaYISNoW4f7yVYoFkKQ5LlSqbtEeXDmi3BDCcx8lQAuD666Pff6e7hkBbQjoeoViX5Ll3e6fJSlV81nPrcPve3v4ywCgAoYR0Hmn2BHowF9MGK3cecdfmmzcXl8CN4LthYSk7FikaM+iDcu4P59AOEwbfXVNO8nXOaoSshdFAzpKx86fsD5H0jgZRfKKPbmWs3OdCA2NOTxJABEnLw7ryiaeRmTZRgeFdQCJEwgHUtYmbDG880PCWGJPNPLTlB2wnWsAFhc5Fl4nh0aRFUoYbAxSoFSEosnWAQfNq4ICL+6FvTevKNc10DwZ8qJ1QKMMbLsYKWr6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqa+l5cJ2TpB6HiAwiUPsk0VwdrDvWoSt0Q1hC9acPg=;
 b=gWSmTnWdUaqZUdTvsireEImCsAsAYIhxQBctdocr5K72EoXkYWZH6R1CfcbOdSbY7TCYDgpKIANcMFnVdQtpTJjWyNOB6ooKtO6hB9i1+xI3UJm/WLzYAvYeZROi5z4KOvcCSH6H7g0ekFCAcQTVsEPByG6YbLMe3QrUOLHxoWM=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6869.eurprd04.prod.outlook.com (2603:10a6:20b:dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 3 Dec
 2020 08:44:57 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21%4]) with mapi id 15.20.3611.032; Thu, 3 Dec 2020
 08:44:57 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Patrick Havelange <patrick.havelange@essensium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] net: freescale/fman-port: remove direct use of
 __devm_request_region
Thread-Topic: [PATCH 2/4] net: freescale/fman-port: remove direct use of
 __devm_request_region
Thread-Index: AQHWyMZ42iwz0XCqx0e7//BYen7yN6nlDuWg
Date:   Thu, 3 Dec 2020 08:44:56 +0000
Message-ID: <AM6PR04MB3976E5A576C3E1AA157DA711ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201202161600.23738-1-patrick.havelange@essensium.com>
 <20201202161600.23738-2-patrick.havelange@essensium.com>
In-Reply-To: <20201202161600.23738-2-patrick.havelange@essensium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: essensium.com; dkim=none (message not signed)
 header.d=none;essensium.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00be9344-810f-4c00-2a46-08d89767b66c
x-ms-traffictypediagnostic: AM7PR04MB6869:
x-microsoft-antispam-prvs: <AM7PR04MB68699888D2174363BD59924FECF20@AM7PR04MB6869.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6p6DvesCK0nDDGiZDwzSXRrIYYioxkScjfKQNqc396/tytmxyEJ/RCN/oSX46isXH21qg/w6e+dHGDADJZewj4XzVG1KjqJ7NBeNBIYna2TnmsANw7Dvi7iL6xIoHS890dhTRjpzcd1LHrpZjUWS8o0S9pj3hI0BIzBUqAYPHOW9WO1J3cdMKyjXZNBpf9hTIdE3ndKuUUCtCzl4m7t4/8mg9ku77htSEU9TQoGpKWdhy/av1AkUIct8cfMqlXUEW0YfXNIeCd+/QjxanPlCakXkjQWY+pCYRG7s5Z3WWjbBPk+gBBqZduJmssPmqSpttBtkbeKMMoeRVvOA16ovAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(26005)(71200400001)(86362001)(8936002)(316002)(2906002)(9686003)(53546011)(6506007)(7696005)(55016002)(66476007)(66946007)(110136005)(76116006)(83380400001)(66446008)(64756008)(66556008)(52536014)(33656002)(5660300002)(44832011)(186003)(8676002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DRxIUchKo003a/+tbKRyyD0pLBsyJGOjWE4VFrbFXRnqQd83x5DtextHiZt5?=
 =?us-ascii?Q?sWb+DV09ZRRqNe9VVlJGbwch/XLPSAnkENQHqnAWPXH9L3OTcXY+KFjp7ar0?=
 =?us-ascii?Q?vtJbzwzIXhM8c3rMhZJI/0IZBmeGlkB0sV6Q9LPf/l8L7F1FkBl2nTSxCQ6k?=
 =?us-ascii?Q?IKsv7QwO+c+sXdLeFiBYfqBrmj7AgAaBpJQ3/nlfwhCQYjTii3Uy6/d4l3hA?=
 =?us-ascii?Q?LKz9AQv4vNCqfuOS1q/9wzd3t9gzPW7WCNKGuqQ6EPTNoNKPzu+nkuyVhoca?=
 =?us-ascii?Q?vE7yCxbBbRBoLOtLq02mAkGdXIN0XwPe1aaMbuyiOrr3At3z0xw5fC2oibEO?=
 =?us-ascii?Q?+I4YtHJwhjMtKwlqnUPk2dJxi1EQ8z5qNtcjkzC3lrNRwGeKaVpgFiCxTlba?=
 =?us-ascii?Q?uFfX3l1UwWrRsRwpPRz0CuZNvhTIWikfPMu1Kj6PavR6efQUQMq5BA15YlM/?=
 =?us-ascii?Q?iH2l5PbzqU2EBmgXo+L8/c31kPHP5rI1QTpwoMQAXw1eGcNJZfiUfqKzEtTG?=
 =?us-ascii?Q?35kLRH+D876vatE2CFIeZaGipYhrZBeGMtA/xBkTvh4gQor6sYE3y9TZ8Qiv?=
 =?us-ascii?Q?MJlzwETcD5YLyyUpmJnBjgYCkx1NpyzfdS5MBu9EPVKT2qEPRSzSuVwRfMlh?=
 =?us-ascii?Q?tv269ddkMNcEiyuRIoBlEZe9OrbD0hw3vLBIxNt+qB5Ft+d83oQ/QoC6I78Q?=
 =?us-ascii?Q?TPA1mpzEXqvOY/giJT3/BNsGWyMcBgtAd/Ugz9gF8s2Epp4hChdYJeXHpfXr?=
 =?us-ascii?Q?LckX0Rzm4oCTPMLDJbrGuu9HKqnrphuUkZvoVD+FvkSV+34jgMTpOSDlxVv2?=
 =?us-ascii?Q?PKlou/ZTnxI2UP/Whrxwjpa1bdrM+GTo8ZrQquA9uAwvFb6CD86mUL5yw1jk?=
 =?us-ascii?Q?qkuWjV5cg54y85qfo/GpdSzEVJodbcTGx3YbxOVf7pSBZUSvGcFGVsG8E8ES?=
 =?us-ascii?Q?kaXSH7aH0qyklE/EOwinD4dYdbn7rlKmEYl5P0f6SIU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00be9344-810f-4c00-2a46-08d89767b66c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 08:44:56.9413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+YLyKGcU9XP41UNvmRqBcItOe10s0YNNwxZciobkfHSYH3BqNilUf2srmDMWjPjaNaDmoHLBrNwkjnwv+/hKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6869
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Patrick Havelange <patrick.havelange@essensium.com>
> Sent: 02 December 2020 18:16
> To: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Patrick Havelange <patrick.havelange@essensium.com>
> Subject: [PATCH 2/4] net: freescale/fman-port: remove direct use of
> __devm_request_region
>=20
> This driver was directly calling __devm_request_region with a specific
> resource on the stack as parameter. This is invalid as
> __devm_request_region expects the given resource passed as parameter
> to live longer than the call itself, as the pointer to the resource
> will be stored inside the internal struct used by the devres
> management.
>=20
> In addition to this issue, a related bug has been found by kmemleak
> with this trace :
> unreferenced object 0xc0000001efc01880 (size 64):
>   comm "swapper/0", pid 1, jiffies 4294669078 (age 3620.536s)
>   hex dump (first 32 bytes):
>     00 00 00 0f fe 4a c0 00 00 00 00 0f fe 4a cf ff  .....J.......J..
>     c0 00 00 00 00 ee 9d 98 00 00 00 00 80 00 02 00  ................
>   backtrace:
>     [<c000000000078874>] .alloc_resource+0xb8/0xe0
>     [<c000000000079b50>] .__request_region+0x70/0x1c4
>     [<c00000000007a010>] .__devm_request_region+0x8c/0x138
>     [<c0000000006e0dc8>] .fman_port_probe+0x170/0x420
>     [<c0000000005cecb8>] .platform_drv_probe+0x84/0x108
>     [<c0000000005cc620>] .driver_probe_device+0x2c4/0x394
>     [<c0000000005cc814>] .__driver_attach+0x124/0x128
>     [<c0000000005c9ad4>] .bus_for_each_dev+0xb4/0x110
>     [<c0000000005cca1c>] .driver_attach+0x34/0x4c
>     [<c0000000005ca9b0>] .bus_add_driver+0x264/0x2a4
>     [<c0000000005cd9e0>] .driver_register+0x94/0x160
>     [<c0000000005cfea4>] .__platform_driver_register+0x60/0x7c
>     [<c000000000f86a00>] .fman_port_load+0x28/0x64
>     [<c000000000f4106c>] .do_one_initcall+0xd4/0x1a8
>     [<c000000000f412fc>] .kernel_init_freeable+0x1bc/0x2a4
>     [<c00000000000180c>] .kernel_init+0x24/0x138
>=20
> Indeed, the new resource (created in __request_region) will be linked
> to the given resource living on the stack, which will end its lifetime
> after the function calling __devm_request_region has finished.
> Meaning the new resource allocated is no longer reachable.
>=20
> Now that the main fman driver is no longer reserving the region
> used by fman-port, this previous hack is no longer needed
> and we can use the regular call to devm_request_mem_region instead,
> solving those bugs at the same time.
>=20
> Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_port.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c
> b/drivers/net/ethernet/freescale/fman/fman_port.c
> index d9baac0dbc7d..354974939d9d 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
> @@ -1878,10 +1878,10 @@ static int fman_port_probe(struct platform_device
> *of_dev)
>=20
>  	of_node_put(port_node);
>=20
> -	dev_res =3D __devm_request_region(port->dev, &res, res.start,
> -					resource_size(&res), "fman-port");
> +	dev_res =3D devm_request_mem_region(port->dev, res.start,
> +					  resource_size(&res), "fman-port");
>  	if (!dev_res) {
> -		dev_err(port->dev, "%s: __devm_request_region() failed\n",
> +		dev_err(port->dev, "%s: devm_request_mem_region() failed\n",
>  			__func__);
>  		err =3D -EINVAL;
>  		goto free_port;
> --
> 2.17.1

Hi Patrick,

please send a fix for the issue, targeting the net tree, separate from the
other change you are trying to introduce. We need a better explanation for
the latter and it should go through the net-next tree, if accepted.

Madalin
