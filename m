Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816792B8612
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgKRU5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:57:34 -0500
Received: from mail-bn8nam12on2119.outbound.protection.outlook.com ([40.107.237.119]:8801
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbgKRU5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:57:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBHAL3o/8J7nrmpa9DLHwB/hHVb0G8t+IhUSSSNRB/8OAZWgXDQjdSystYkq9NQF5t7o9iearea/6Z+jRKerHJb4oADWu1sEaKfeYbcF+GmGHWrvT6vqREGckFfMZ7lQh8uZZIwBk24STxqE4CaxI7y5Nj11Eff3oFprDF7MBA8Vj1v5tyIG2hB2FD8bH/xi6zagdnLfAvICYM9Yx+8QQhgtypYi/523lXdWq2213aNj2rhSbqC/BPQtUFu9zJtlqOZrDbIUaBscheSMQUzsyCphtzygpxZ9UBsxkPlRow9ee3Kh+1anQ3Hs2d1uPm5J9ilhceowUFNiUGnl0swZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZroQDJI4lWK53RjHuDomagYdE4cPHwrR4XECxhcUao=;
 b=UOzPzVKGbMsdjo/WAtBfHX320dhu7NqJ8WUNKrSqDKLFQve+ebabtFgSV1T+xdy6GD19z/V+syMd5sK+KdqhcYANXpVXYgQVxvMg+UbsBBYVAbaPrGblSt2QDK5VEybnGtO+M11J8zWrOgUBLLxFYPQJCX3fJAAnmfbebCNwM3EV1of7mCL5HKVaLoXddxuznqjLLrt3eGkroIbPugxtmvYeGMQG6bhfLd+irMn1mr/YBsZtJLaQPiBKo7MGRBNDbS5Ldx9iExpFHdVmJjz03cQFEY53KCyTeS8B7nm2TBQ3hq7k8e4Voe/ynOmEWNFKdCDHMJfNA0uiQHyittnEow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZroQDJI4lWK53RjHuDomagYdE4cPHwrR4XECxhcUao=;
 b=h5vFl2QSSlRQ4e/OJ+NBOQF+WO+D7H4kPkToP6F23rGnbGr3BQRaalpEzc2QYuQSNH1YFpnvuH4dKmcUkZp1YYM5IolDdEpGQ+8MwveVbAGY87HonlRQ8NQsbe9tp2L60MZtmjmN9ppnJYOow2D5nuwBUnaB0RJeSdskcG33VnQ=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1345.namprd21.prod.outlook.com
 (2603:10b6:208:92::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Wed, 18 Nov
 2020 20:57:31 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::519c:fbb2:7779:ed64]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::519c:fbb2:7779:ed64%9]) with mapi id 15.20.3564.033; Wed, 18 Nov 2020
 20:57:31 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Thread-Topic: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Thread-Index: AQHWvcArNWxyHRKSGUWS2b8oyfgey6nOXz+g
Date:   Wed, 18 Nov 2020 20:57:31 +0000
Message-ID: <BL0PR2101MB0930F4C569F8918BA1A144EBCAE10@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20201118153310.112404-1-parri.andrea@gmail.com>
In-Reply-To: <20201118153310.112404-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2e4df1c7-03ed-4b60-bf3b-169652408bd5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-11-18T20:57:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3291ff15-c98c-44d3-55fd-08d88c04910b
x-ms-traffictypediagnostic: BL0PR2101MB1345:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB1345EC93DF4B519CC25D3103CAE10@BL0PR2101MB1345.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vcH+s9RVQ2Qd+xs9kVfO/eKD5FH/WUe0m8sqR01iE3GDMjYxzH8/vu9GLLJIodZ8YzY6bj4skkdGcMk1QCL/gZM3TQ+fM1sGD9fr2dyEmu+XRwFNORfoQTDQ40mQeAoXfVCh6j4nGLdpUkEl9j/GQKVWOIkfxubdPiqU6R69dyIM/8SCbB706C4mXpjvJuZ9OzhFTJErbcXLRN0ifpD0ESwO7Sx3++JswJJNr5iVT+B1/IyVykbIGHDcKqiQuRFH8lNHyMq+T/JC+GTNwLik1jrdJLxPnbamzz2Mo7aFyQ3PtJfQDwuM9UBWbT5dj+4+s2Pxr1uABjkbjP1HbWdX3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(15650500001)(10290500003)(8676002)(9686003)(478600001)(4326008)(82960400001)(26005)(82950400001)(6506007)(53546011)(83380400001)(55016002)(8990500004)(7696005)(33656002)(54906003)(66946007)(8936002)(66476007)(71200400001)(186003)(52536014)(66556008)(316002)(76116006)(64756008)(5660300002)(2906002)(86362001)(110136005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?V15iWsL42jMkH6aE0pi0D/z6eP3sAcMPeaTIeyCATIsvksr90dGFGUYNKwLV?=
 =?us-ascii?Q?zR+LUYgRFXnF7ocYIFko8RNhZ5kyxoeVPnUxyYRYtBTxjxUy56PZtWYdDGwu?=
 =?us-ascii?Q?AUQCOzl4tAeHlebFmUrowcTe4JOJTZMyE7mqwKVdSkykIxKNbdcLoz+xEX2o?=
 =?us-ascii?Q?Tp8GAoBDB62AFc9iol1wtA3uvfKVSGRQuXvDhEW1OqZp2qFFpajJQaK2y+sS?=
 =?us-ascii?Q?KweWXyxxko2og1xdk73hbRdZnC7/CwYQzEgRPLODBrKYWv2UiDPl6ClGn8qo?=
 =?us-ascii?Q?I/ApPRlYPsOMKtJd4DlqiMSxYJSi5zUFCcAqWV28T8XYEQccjQIncoWSyFF9?=
 =?us-ascii?Q?yi9uZZdWgLbqqNFudyu7sNxFkfd9f7LM5as1xgBquUZaeigi7QQ3UUc7b5C0?=
 =?us-ascii?Q?M0dgbFVg2Wa2SnvWOJqf6Ixd0dsp0HfQ7Gd7ehphZvsfp/YBpUYMDm7csk4/?=
 =?us-ascii?Q?RYh0B7B+n909URs+PnvcAIjnJpUMO4w81eMqKY3dUT4/QI3n6ObraTtlKXio?=
 =?us-ascii?Q?BVvaj0ED0pS8eLRrQ3FBs8ZnAuANKKfd4D8tRPmU4+vY1NSdLB0h58C9xNcC?=
 =?us-ascii?Q?/rcS+BapK6f+9fJnC1J4EPcNkGz0izMZcNYrPXjjR4iP7szSlh9HJE8I/eCn?=
 =?us-ascii?Q?+EFDeOvJqY/8a9Wg873U1N7rO4JeqEWcXOr2XsyWP2SQDNd8iHuQnn7bg54J?=
 =?us-ascii?Q?a8DJeY0B+iOGE3kG2TkfhwT1GqNL45okc/oEoV0cButh10ho6c50/Sz79P2O?=
 =?us-ascii?Q?QUgyB6vFuzg6lIN81bQe+s2vBIbb87RvxQ+sfI8G8s1zI3wggpPooKZ4yegm?=
 =?us-ascii?Q?vaGeAZnXuKCJXUH+UNBsKTHXXYwQy/oDxm1Hikm5mz4F/eRrYJpfcDl4Ee/h?=
 =?us-ascii?Q?T2tD0hKCsGaCGKVgl5ih54Gqv8ucK/kDQmmfHeR3J64tvpHNpa31jqg35CA4?=
 =?us-ascii?Q?JEzww5Rb4Tve0s7B42mweCws5nb+H5VK99scIW7jmZQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3291ff15-c98c-44d3-55fd-08d88c04910b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 20:57:31.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whmz89PFaMU6imC2QrB829bRZ8/JDANtfU61JTic0d4zbe+qvww1Spj5uZQcChqAxZ0ekPfJHG5Tz6W/G8w9LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Sent: Wednesday, November 18, 2020 10:33 AM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; linux-
> hyperv@vger.kernel.org; Michael Kelley <mikelley@microsoft.com>; Juan
> Vazquez <juvazq@microsoft.com>; Saruhan Karademir
> <skarade@microsoft.com>; Andrea Parri (Microsoft)
> <parri.andrea@gmail.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH] hv_netvsc: Validate number of allocated sub-channels
>=20
> Lack of validation could lead to out-of-bound reads and information leaks=
 (cf.
> usage of nvdev->chan_table[]).  Check that the number of allocated sub-
> channels fits into the expected range.
>=20
> Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
> Based on hyperv-next.
>=20
>  drivers/net/hyperv/rndis_filter.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c
> b/drivers/net/hyperv/rndis_filter.c
> index 3835d9bea1005..c5a709f67870f 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1226,6 +1226,11 @@ int rndis_set_subchannel(struct net_device *ndev,
>  		return -EIO;
>  	}
>=20
> +	/* Check that number of allocated sub channel is within the expected
> range */
> +	if (init_packet->msg.v5_msg.subchn_comp.num_subchannels >
> nvdev->num_chn - 1) {
> +		netdev_err(ndev, "invalid number of allocated sub
> channel\n");
> +		return -EINVAL;
> +	}
>  	nvdev->num_chn =3D 1 +
>  		init_packet->msg.v5_msg.subchn_comp.num_subchannels;

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Thank you.
