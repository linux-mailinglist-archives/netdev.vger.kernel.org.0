Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23A316364
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBJKMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:12:33 -0500
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:37152
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230302AbhBJKJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 05:09:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT9i0Kh6BmWfJ7FDSSELLv7+ztzLMkB957qGfIZbqroYznW1sA9Y9BVbNUfCH/V08UkDGiwI6l8/paSEzP0LZ+YqHbZNUdTcLldPYtpHGK47x0QK1hPl2fpQDEQlbF0JKuQ82UBl1P5kCNP7Zl42XNQMmgQRE0n3dFV5146QVpoEZ/m3PYhS36vLgIw+ccNfk8fMW9mm6OD6lkX2osH3vg3eaDRKnZMQ5z3qS9zxtqhYhYyTxOhHidxxZKt35QyzQyxixx7zb4SzfQUr3vP2va24BI3ltfAOTyBeHEvoaL/7Wv3rcwxVFGtlQ4AUCU3RFUFNJHJ1/kjlizYgA3ShhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkSCqEMIbki/ZQV1uwE6Y+aTejTgyR51Z2ansgi2fl0=;
 b=iTNBI0WEMAXs5Q/y8pAWW7O/du2SNs3lb7qfadxfyoU7kn0F15aKR1U/GLwjwih0wtuMxTIFvS3iYWxGnOPBDr1isOIwN1ULAUsMiDuo+RCwKwDSWmgSxETFHJjwZtYCW3ORWWXO93iSswj9FOTN5hZaRWwDm4OO+CZFbA9V3XAlDPz1apXCVMuvmnZIBZrG50CO3NqJMHrGUv/F268iiwzvgiwtkJjJXaXjge20HbnIcg/eI21A35CbPxjqZCzTyQSLqHGk4/Ix+Pce46u0ZJUtWCHdUX9I7KxUDx+5y3NdG5V9TFy+bU0bd+G8Y4gWqfl4DK8Q/NwusqzBMfFlAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkSCqEMIbki/ZQV1uwE6Y+aTejTgyR51Z2ansgi2fl0=;
 b=ntVQEZ0d8Bi7ms99wOlSg3940EJvoKVm34Q7x1mPwNq8W3+YvFcY68xERqUfcIkL8HKCKezRcquTjDKTutdUl6G2FW9Bqgjyu9KOSD0pFynCRYXGvpVett1UtjLKwU0E5bSgGPASZ1tKVS6dDw2Wn1CafskzFz+CQiosqe3VOWs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Wed, 10 Feb
 2021 10:08:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 10:08:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v3 0/5] bridge: mrp: Extend br_mrp_switchdev_*
Thread-Topic: [PATCH net-next v3 0/5] bridge: mrp: Extend br_mrp_switchdev_*
Thread-Index: AQHW/yGN1ipr+GfbIUiWAmue2IqujqpRKxqA
Date:   Wed, 10 Feb 2021 10:08:31 +0000
Message-ID: <20210210100831.acnycww3wkeb6imt@skbuf>
References: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 522297dc-9c55-4209-e178-08d8cdabd20d
x-ms-traffictypediagnostic: VI1PR04MB5134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB51340619C33B7D95C2A9879DE08D9@VI1PR04MB5134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R2Y+QhXpcMxPlJtkbcLijv8pPUH4fZB54PtM1pMTh2JP94ycJkjnQDzZlDbJmf5NcGSYxr22TjNqKFN7jmoqjKrrxADIpBlJNlb0Tqq1f6C2SPbRGa/VQumrsXLFL+vNO5cY1KhzezA7NYCf9diVbXhwgZy0fnGPFlBQTkI9u4narf8ZhMrfh57bbIduMAJJu0xbM1YQHV99Xi+HPJF7uKdaRmDCM5S7687DI43zXVN7pEmO5QjqrO7VloscLYHd2ireunjmaefP2gC/7Hr6tvXmwnb+V4t5FjrzDaXHlz7C7aMslC14Yz2czoKjI+8PfK/5VgDLsHBAf54xCn4A9t1mdJT9vnlp0drYDcBjmk69za5gaXehO/eXXHqTWi/kxrqWRUJdJxHNFOiH/42b4IZpSmy3KbyGH46qiZJvZR2uPlZzHzhP+O4OzyPC+lRN2HrFdjOZXbFIMFHWg4WElYLI8heAqqCfd0Ydk++MA9a4eRb1n/wuVN/GgZq1LS2WsOhijwZH6D3TlPh/zveUZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(136003)(39860400002)(346002)(366004)(396003)(71200400001)(4326008)(2906002)(8676002)(66446008)(64756008)(66556008)(54906003)(66476007)(6506007)(83380400001)(76116006)(44832011)(1076003)(478600001)(5660300002)(26005)(33716001)(86362001)(8936002)(6486002)(66946007)(6512007)(6916009)(9686003)(316002)(186003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m9zF83YdmeW7+NUbFC8JOEve6GIR87QG2/cJkOYZWX9bXT9hQX3evC+am0eA?=
 =?us-ascii?Q?Da4zFzdDc4so7Bj5jX2I31eU93dfMdquyEIMutxp5Q6hgRF8ge/7LF4cwsCD?=
 =?us-ascii?Q?tpJtFWsCgBd0A1+H+/2tq9px1j7I+jSe2/CFqZuqiJsDuSgWMgDa0LRJesZa?=
 =?us-ascii?Q?6Xw83YNmlASAwNWqXD+eCBkiyR964qvKpBZUAj3eVP2L61GBa0yEbSxJTFDz?=
 =?us-ascii?Q?jccQAd25k+O75NF2SyZZgbkBo6rOkErA1DSjWNgn0SH4xulGt+7yAsDqtuJ/?=
 =?us-ascii?Q?izeO12u8Af8EoOwF4BfqGnCTQdj/7F7qmTDDxahrV/GKbrI66dzmHQFZHm2B?=
 =?us-ascii?Q?79+w2+ACjXUM7lZ4PzSKpHlrlSU0tubf02qRqkxewDWteSave/jn+QspueyG?=
 =?us-ascii?Q?8od2RYIAbwAFN+mTG31YleBGnKG0xrzR9kGsSLaAekqZNicg0kl5PRSkOCTk?=
 =?us-ascii?Q?b67O8NEftcIC8GkSWiquoDscbMkQWIEtiBuqx+tSKAUHQvFNMIyKh6bxrFM7?=
 =?us-ascii?Q?HYzuvMLx56d0/ViKM8Fs0LcFwtuza4xIizSnuxg8m3hTur9PbGXMRnDphG7p?=
 =?us-ascii?Q?qtl8xnzFWyjmkLpBVEfRf1kHGItHXt1l4LUklXV/jpWoRPYOIiLDXC3GOcwe?=
 =?us-ascii?Q?1sq7DY5Gnj5CU/zwAUI3tG6VW6DQmlm27a9Wt6+8wOhBQt4/08B02UiwH5D0?=
 =?us-ascii?Q?/J8b1kCDoNH9svmzI/dN6xF9PbYTQ/ClZAe8ngyvpn/50lp8QVFW03Utr7sY?=
 =?us-ascii?Q?XVeX73pfPxrLUv3E5Eorl/z2WrezBNZfx+gy2K32rzTlPl9hICG3mxxt/29J?=
 =?us-ascii?Q?LwWbDtzjPf5gJRxNd+blMDlyzGJ9P3fdw1VmLZQjuBJWrvw3NLvrg7vqeK3T?=
 =?us-ascii?Q?IIJQnEl1vaxtDIGJ6WS0kN1dUb4a3+WjYOAyAUswRQJTnMQKtl+BWyaVLwPZ?=
 =?us-ascii?Q?u7Z+xHcTxA0k4IeDfawcfHkr7hO/2yiBoxp1mrYPPQNeGclZquPj6C+0hrEz?=
 =?us-ascii?Q?0L3u32MG7Mvh6081q023Ct441sIBVLkqP+QPe/1rK7PJz/STr02/cX5TsWpq?=
 =?us-ascii?Q?4y2fvgSXcKHng9NGcq/Kgd8c4NkxKOaTJqfFcFOHOT4tFeD/h9zfVJmumGAT?=
 =?us-ascii?Q?ryOdHKdHG/hrbw5WWoNO++LlGB/BNogdtaDobPSnSOKgWZPbZ/tRb5ATtFXu?=
 =?us-ascii?Q?RSo4zzbPIbcU6WAqhAmaA+vo6OhD/9yCPI4WGAUbh+mf1gJCY5UJhcgQhMr7?=
 =?us-ascii?Q?8Abf5ZgA2Q5VGn1vo8UQPqmSJF0pbwgchNJ/O+tP8Py1KadmMjJtG9JlPoyE?=
 =?us-ascii?Q?YONY3KqN4FJKkZZZr1obRd/K?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90E48C016380FC4182CC031CB1AA155D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522297dc-9c55-4209-e178-08d8cdabd20d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 10:08:31.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CD7omGggi78p01JxJSzu4QIIV/KDQRe/6uOWVhLkmm13LLzcnyhbWAnxbsWykrFLlb/ELpSGf/M5rHC70vNj6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Tue, Feb 09, 2021 at 09:21:07PM +0100, Horatiu Vultur wrote:
> This patch series extends MRP switchdev to allow the SW to have a better
> understanding if the HW can implement the MRP functionality or it needs
> to help the HW to run it. There are 3 cases:
> - when HW can't implement at all the functionality.
> - when HW can implement a part of the functionality but needs the SW
>   implement the rest. For example if it can't detect when it stops
>   receiving MRP Test frames but it can copy the MRP frames to CPU to
>   allow the SW to determine this.  Another example is generating the MRP
>   Test frames. If HW can't do that then the SW is used as backup.
> - when HW can implement completely the functionality.
>=20
> So, initially the SW tries to offload the entire functionality in HW, if
> that fails it tries offload parts of the functionality in HW and use the
> SW as helper and if also this fails then MRP can't run on this HW.
>=20
> Also implement the switchdev calls for Ocelot driver. This is an example
> where the HW can't run completely the functionality but it can help the S=
W
> to run it, by trapping all MRP frames to CPU.
>=20
> v3:
>  - implement the switchdev calls needed by Ocelot driver.
> v2:
>  - fix typos in comments and in commit messages
>  - remove some of the comments
>  - move repeated code in helper function
>  - fix issue when deleting a node when sw_backup was true
>=20
> Horatiu Vultur (5):
>   switchdev: mrp: Extend ring_role_mrp and in_role_mrp
>   bridge: mrp: Add 'enum br_mrp_hw_support'
>   bridge: mrp: Extend br_mrp_switchdev to detect better the errors
>   bridge: mrp: Update br_mrp to use new return values of
>     br_mrp_switchdev
>   net: mscc: ocelot: Add support for MRP
>=20
>  drivers/net/ethernet/mscc/ocelot_net.c     | 154 +++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c |   6 +
>  include/net/switchdev.h                    |   2 +
>  include/soc/mscc/ocelot.h                  |   6 +
>  net/bridge/br_mrp.c                        |  43 ++++--
>  net/bridge/br_mrp_switchdev.c              | 171 +++++++++++++--------
>  net/bridge/br_private_mrp.h                |  38 +++--
>  7 files changed, 327 insertions(+), 93 deletions(-)
>=20
> --=20
> 2.27.0
>=20

Which net-next commit can these patches be applied to? On the current
master I get:

Applying: switchdev: mrp: Extend ring_role_mrp and in_role_mrp
Applying: bridge: mrp: Add 'enum br_mrp_hw_support'
Applying: bridge: mrp: Extend br_mrp_switchdev to detect better the errors
error: patch failed: net/bridge/br_mrp_switchdev.c:177
error: net/bridge/br_mrp_switchdev.c: patch does not apply
Patch failed at 0004 bridge: mrp: Extend br_mrp_switchdev to detect better =
the errors
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".=
