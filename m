Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC6F3595A1
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhDIGiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 02:38:09 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:37806
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233333AbhDIGiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 02:38:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeeIC+/kI8XI/a3R6OyXNKqKfHASr1C/53wUlVTXXmCBQCE6XE7P7u4H7LFWDND7FKTvK9/77cRcJ6Pbt+qtjgWlsAzTri3LuteX5wETDRj2NfSyi7RX1Xpwy1GkTp6gff5QLpPJM9PvelR/SzrXSVcXXX+tF16WJRuUnxyfzst1x5W/fhZ29mt75m4grWxKHsF7YyYY3iI68R3XciNa6pcODSxhkB8SGQuykIob2pCMZR5KlNPakG3Q24G0p/B1vY5RXFp6Safqtlf3gQ5ttY5wlnqX3RixtX0eziXxtlgK4fcB78mRdhJsK3CuJbd7E2NNEmy56xCh7HDo9EaFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b75onZXREj2w/uGCSUb1xqQiR7M8cyJpxfhqVZw3/Dc=;
 b=LbEBaDLINDWfwnGax5fBzzDmb0ALyiKsALj1An8BbbepN0dFKyziPIaj41c6hOpA5G17TUBFBX42fmvIBZOVl4fLL1tbHaAuqUj4LnkNmBzqS+O1bSKi1wWZ9tXcFcu5oHSY8CdRrKPxKrrwA/SPdAcVdTAhYxUBT2xYURDeP3myWlHYKDVC+UlxBkVfEQuv3csexpI8lm6KfHZz3R9z3eswLehFTy2GIWyEKNa2qh0tpC9VpNuzKJmiXX/7hkbPXQYtueiUlsxAG2mDf3hpz5k8FGQpA3fKkQn0uJdoQ5M59kzuGfHftZ1wOSeSsdjVfk+XHce93HRCx4iKGqpzRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b75onZXREj2w/uGCSUb1xqQiR7M8cyJpxfhqVZw3/Dc=;
 b=OyZfX65RxSW+e2umqMWZbq2wDoHDxnljo3RAPMSQZeaAp/WRyxhjuUBWTqUxd9E/U0hoRM/EVkZD4XUIx4bJlvl/cmvpIOdjqLN3VBt8tiqmwXNVkly6Owon8wYaeKY0ehSxabhIOYjLNGrH/zY2v0Di3rVYPBN8vY75WlFpSbI=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3331.eurprd04.prod.outlook.com (2603:10a6:208:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Fri, 9 Apr
 2021 06:37:53 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73%6]) with mapi id 15.20.4020.016; Fri, 9 Apr 2021
 06:37:53 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Topic: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHXLGdYb33b3Y88SUmJ9DmiEwNHPqqqyHEAgAABMwCAAPHyMA==
Date:   Fri, 9 Apr 2021 06:37:53 +0000
Message-ID: <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
        <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73486d72-63cd-4d21-bc75-08d8fb2200e7
x-ms-traffictypediagnostic: AM0PR0402MB3331:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB333185A7D7347835646D9EEB96739@AM0PR0402MB3331.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mw3TzIncMip1fv1ane62kRJ7F8eMSzTsvlSIZINvpaS2IThTXJtSyjB6kXD6nn1X272B/npsp0LGrhNANJOouzbFn1UJxMaHQ3IWgOwyVSV4LHzBPBfDSdnU46CNemxhzupxEeYOcJlqq5VzVH6RUcf54uTucIepUsqZx5E8IRMQsSutq9wZk//CAmnP/QghtUYPqV21qyGPxN07YxpGYNS6CZsPw0Sq08g6zeVtsf+aEYFlsldkvJNXhOvmf9nCUKayuZrGgQaBCJw0UCfZl04BNWcyg9TA4BwUg/o67uspoA63aRo2+TVGdlpkit5WBeHcHrCcjO4LM8v333DE2xr/aSVBaSFsDfCV5OVuKmdzgWx96AM20g12SfSuqdlIsvBs2jJT7FiLlZ0vNd8FsUHUjdHV5NIJPN/0Gaq/hcfvpo0WrQmPCT7fwU9WeBBwhtmQqw0HMr1xSNmAiAtRPT8U8ccqDE6os6xWbxms6IuJ5PlsHdkuySFxxxcod9cV8obIveGz5OD8/DH73UlPiK4xoZXXrsGCWHHO6ealry2sR1gqYTq9m6aCXK8F99Ej79au59konABvUXAAPJy1erZ4EI+IGPq8t7MiSxUNy16KJ4A04ckE1I1H9EPOXpJoFgYsh8dJ3qD8RhS/EniHCptJvthHnqxQE1yqO0HS2O8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(66476007)(66556008)(4326008)(66446008)(26005)(64756008)(44832011)(4744005)(66946007)(54906003)(8936002)(186003)(76116006)(110136005)(6506007)(5660300002)(316002)(8676002)(55016002)(478600001)(38100700001)(71200400001)(9686003)(86362001)(2906002)(6636002)(33656002)(83380400001)(52536014)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TtfAE2/LyUyiEMduYrD9y4FpeqzBb2nunOSFyo6VVPsPXrtIxv9wvtkg9f0m?=
 =?us-ascii?Q?dfbEAYKClTYTbbcG77XnxM0fzvqCSSFTIcPk3K5bcVp9DeBZssafqpYvJeuY?=
 =?us-ascii?Q?lEdgzz3XnoEYX5MgluxoXmYcj7rgsDrf5Lf363XQ9atowE5xdWgbu75b+4P9?=
 =?us-ascii?Q?Q1V3tjuw15oCZxbxGNaDaUGLR/AfGtvAHK0lLjrLdK978nsg4cDVhjPGn7vz?=
 =?us-ascii?Q?6rJ5X82WWkHmfmkx7RQymn48I3Af+v5bEGWHrGhBR1JiC52LGHULhAVxpgJN?=
 =?us-ascii?Q?CKrJXZ5IYiQ4zvB4irIck3yFpvz2LUFw2LFhYXdGQgzz+nJMEcsgZtQFwLZc?=
 =?us-ascii?Q?TLJZjpfZm/AnISgE5bmnk5nCMy29a2BtGmkVooYEWE99Lnkr2etB2VL8gF8S?=
 =?us-ascii?Q?ZN5ShyU0y+bStfWdCSDHyx35L1qjamZSBoJu75IkTPNwbaTeWa5Y6bacVh1D?=
 =?us-ascii?Q?DxlUJe3tpFE/Qrfi8VJNSXZBYcbNhhdd9CPMsfHRx3K2UX9005QMUJIeosLY?=
 =?us-ascii?Q?7p8LzyjbTAJc2L+HKA1SBhDur030N3h3f4ybBbUm575uB9FhI5nRDZYvNwMH?=
 =?us-ascii?Q?5fEELe19tlqKkMBQKSSg8rXwG0FF7umq60ExQlzdgl16/7MJN3I0wqqCQmCa?=
 =?us-ascii?Q?Ly9FO/6YuIuo8N+f4BMUVVFX8u8cX+yk1FPfUikQFkTtAvazOHfeR+YXuHWl?=
 =?us-ascii?Q?KtTqftzIlgoF5F6qGNYx04munROH0l/lXNDWpKltE5eKwOr4o+u1f0gTpX0b?=
 =?us-ascii?Q?AhS0VF6gPPtPFjfSh1wzV6XtnhtAYbgQ0UuB/A5PsrPoR9eNRX2w0koWQRW9?=
 =?us-ascii?Q?LFoIn+aKjT1B5ZjD8JiIoBR8hzUn9TB1dqvfs0hWiC2nNWebCE6/IlMFD5Xj?=
 =?us-ascii?Q?b7daH9G3nCsLI1fVhv8JfKZmn1IiJZpbNgs3tpp+Yr8Rjk83TZJQhMP9C6V3?=
 =?us-ascii?Q?7tKlM/7n6+AfArDdQhpzOyIV9F/mtcWb1aRRUUdkMrv9TPqe47dUDtHNxbLL?=
 =?us-ascii?Q?ti9sXGh9LrNCisXPafvmQhsrYsktpxhoNGU4XFQkxVLzsyOfYMbF2cSsuTID?=
 =?us-ascii?Q?SGDoWf8iUiymdeKjeX8h5XsrV6PV0m/sWj/4ikyvtcLsrQQt3M1GDojbw4om?=
 =?us-ascii?Q?1P5Lirg0gxm0iiGUK2j1Mq5BSC5DEkqLe0q+li2VZqzM3UI4ILSyoevIEhy9?=
 =?us-ascii?Q?8D7aNAqSEUOUblYvMN44+z7I1/3/bdBM6l3hMeZJnnkeVf24vPbdmHQJFZvg?=
 =?us-ascii?Q?1jf5d8m74n35jUFuRRZ5BXsRtU290ZV8uSfgsZyAhQPQLMX13sjih/HFY3xV?=
 =?us-ascii?Q?iMKMqTI1g+jMMyz3Bd+It/cj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73486d72-63cd-4d21-bc75-08d8fb2200e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 06:37:53.3913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IdHCKw0IOLEZUTpfTwIA4gx91Koa775A84rNyUrL6EtWHwd34/GHqa/1+avFMy3nY5UXQ9E+4b7I8BazqHIp8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, April 8, 2021 7:07 PM
>To: Y.b. Lu <yangbo.lu@nxp.com>
>Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
>Richard Cochran <richardcochran@gmail.com>; Claudiu Manoil
><claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>Russell King <linux@armlinux.org.uk>
>Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
>timestamping
>
>On Thu, 8 Apr 2021 09:02:50 -0700 Jakub Kicinski wrote:
>> 		if (priv->flags & ONESTEP_BUSY) {
>> 			skb_queue_tail(&priv->tx_skbs, skb);
>> 			return ...;
>> 		}
>> 		priv->flags |=3D ONESTEP_BUSY;
>
>Ah, if you have multiple queues this needs to be under a separate
>spinlock, 'cause netif_tx_lock() won't be enough.

Hi Yangbo,

Please try test_and_set_bit_lock()/ clear_bit_unlock() based on Jakub's
suggestion, and see if it works for you / whether it can replace the mutex.

Thanks,
Claudiu

