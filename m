Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607C7333F58
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 14:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhCJNeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 08:34:11 -0500
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:8770
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233627AbhCJNdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 08:33:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3SfK2mbfeV/iKzyav+R5dqfwi+3wAGEbXOJTadb1VYSJctWbNP83MlE6oZQ5slZ4vJY9fVYzV6WPIn1SSHnzzRt6SD0cUUpsLFK4MZuFcuGWVJp16bjAjxMWcxtG/nqOrbYogU1eiZJCSlTOIsARqLQNR7B7SbxV9DewMBYWfUQw8AlBAes3rekGuXImqZJh7zL882SBZGydU1oX+taDjlvuD2MGlJQDNEusFE+3Q+76GfVc+30RJibFz8Zfbd607pyI1O6H33aP/ERxVIEqK6onRph1Ryxgrl6FhYjpADFeKvKgW7/l6OCz+010FNt3hbPuhsyFhYHCkj8IaBnEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyduzsJvMRmWwTLKCFOsQC8ewJc+tH3C9bTpy2sxxBs=;
 b=JEznqF4tYKavGTe6NvIwIZBWEx8DTSiaX8TsBWnXqoz9dN9Q0WNGGDBwrUkVMYJU6a+36JzNjW2druIOlNaciKjdcEwnhkg9f9tgD/BuVhHe6i+DtI6Y8TCXiusAIgBeHxlq/Qp7fdN6D9l6EV6Q7HQKsKmWXAYJ9yzstotSRQ1cEtQUAiPJzwXc0EE7eMA3wmtuhWeuW6smXUXJySBf+orJFcgyqVx00/9cbDP1QqzT736wDLA0Jr5HxT8PzIr0zjQZ+EkUZTK1NJ8qQXF5ePvXVb3OoS7JaMx/x73rOUs0PonEguBT+OTgGTIVYq+I0hhG8oS4k76giDF0LRl41w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyduzsJvMRmWwTLKCFOsQC8ewJc+tH3C9bTpy2sxxBs=;
 b=IId7ChbWJvPuSKGf1t5QkpRF7KlvvHt18/XQzB9Yzm4dWOI/l2VFDl3EVvaDQ3ZLAfnN/VyXSdrsE3nTFXJpU6YzzbF9E5YBF98yRIP93MtcRkKb0JOj2iUL592bayMbVezjYPLXKULUY4WxHHSz6ydvFRKbaO5rmzbIC7HFW1M=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7409.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 13:33:40 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3912.028; Wed, 10 Mar 2021
 13:33:40 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: RE: [PATCH net-next 00/12] Refactoring/cleanup for NXP ENETC
Thread-Topic: [PATCH net-next 00/12] Refactoring/cleanup for NXP ENETC
Thread-Index: AQHXFaWOfsggKZHLpUaScgUAYjJShqp9ODyw
Date:   Wed, 10 Mar 2021 13:33:40 +0000
Message-ID: <AM0PR04MB67549853007E796B598F3EE296919@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.50.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a7950ed-27e8-4e62-436a-08d8e3c91def
x-ms-traffictypediagnostic: AM8PR04MB7409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM8PR04MB7409F50AD37D48F113C6863196919@AM8PR04MB7409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c8ZVxW6SF0hHJtMZFiCWXvscNN+WkKkO0pNSwD6LQqLSGIKtcW1cObXp/lOcZzuCo8HzRNuycvE+fy9lShCA8pajgGjxgQvF2f0NDdoV8wedip4jo3pPawBYN0dwdTAyTjkx1qeA8bzncLsZgCUJJLe0nOb81fTmMVDXD766/BUHjVD68HKxYqaVt8Jc9bR4NlN2rUhn0k4x9/qH+ZG9F2kCAptPpEB1DYfHk0eHsjHrE22x516tGCpo+ajhWUp+At1cUdT69Z00M7xKw/7v7O0BW+77kKbF6JEkgQ8iUDfLTtKJkoLeICkkr4jxnMvqy80ClmC0XvgCcQwJLBa9bFtv/3m6nnOApElqkV+kbn11CIxdupxhc34g0p7ogoVO6HHegdK7hIDFsz4qjRqfArOO9CcMUjGMxWZuHul91rK6P01yzqUDz4MSIJpN2w8v7dQal5OpY8mM7LC75Zyau/2zyzYh6IEcix3619Vftz8LTYpk2bWYs6Zz09MqXrrmpWaJ8jdPUg2GojKlDBqD2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(66446008)(71200400001)(86362001)(33656002)(66476007)(66556008)(64756008)(6506007)(44832011)(66946007)(4744005)(9686003)(8936002)(76116006)(7696005)(26005)(8676002)(52536014)(186003)(55016002)(4326008)(316002)(2906002)(5660300002)(110136005)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?URLaBB7FpvUOi6ktFARuGjXz9/WkQUFM48KhTkrY/4h5QsAUDv/FGlahKCCI?=
 =?us-ascii?Q?US5xPm5CCezfInitwtFL42zVTyg865ts3tIwEoVvs82jKUkNSQ8lcOWwM1H3?=
 =?us-ascii?Q?qp7JNs0SA5GbXNDJbn9dUzYB7XPh7X5PUXNBB5YvQaNr5MVxh4XYoBwVpwcT?=
 =?us-ascii?Q?j8xKwxIsE8bNnSa/Qr87Wdc6/x859cUHy39CkApDj8sfI3kTfV5z0+PR1Bn0?=
 =?us-ascii?Q?Xz0ykxClRLVPD/DbKnghY3HLr15/s1JYY3NphFaB6JIP2Qnrb2GFaGF/RY4D?=
 =?us-ascii?Q?kCnDHoEKjJAT8rqThH1Qf3ViTBFm2hJDELi//IwTLfZ93OvSYNa/1GVvnxO8?=
 =?us-ascii?Q?oApRq+mAnLNrekCoe0Dqq68Dkpb3QV5n4g6EK6PgiXUY9t5LMmCkqDJo/xUC?=
 =?us-ascii?Q?WbIW5DGsy5L0BZG9xJGm4MzesnXRlUSARKfn1MBK9ra/Aq3xJi2MwU+ZkUfr?=
 =?us-ascii?Q?FXKnrgnpeQbUv3Madn6A3SchEvcFcGQY8JTtiXH6m49IQIpsBFWhiCcx8IAf?=
 =?us-ascii?Q?UU2qGrfnE5skw8HqBIZOYc0gzFOn59xNF2HIyAVD6mSXfVwnTnQDmBaIfYrt?=
 =?us-ascii?Q?l1piHL4AYHxfON2FR02gl+ljn4zZQHSqpA5gYXfy4iT0VHxXNfD07Lp5nLa5?=
 =?us-ascii?Q?ztmeZK50NXBog4PMmhTbyhRHXRy4qxTguu57wDlZdPwH3uQYtlUpF1Wv2vJT?=
 =?us-ascii?Q?DT9g7aDn73jSSa0d/ruid8kvKh1x265vWXKclhRxHa8XsIZxFzJAWN0hGGDE?=
 =?us-ascii?Q?89vkD9Dz49AjPNfLnCXJ1IJdVWqfc+UTfgnzlTtMWdW7mmWhn7i3peB0Pz89?=
 =?us-ascii?Q?Lf0erOMkuc934cZekse/Z7ypnkzCQJIWTHST/R15XKZwytVuNG8AW847iv8S?=
 =?us-ascii?Q?PfNB2WEHaqpPozuaBeA2edUHqB7irawYtaVOnkJLlr4UWJKCe1GcS0VbtoSG?=
 =?us-ascii?Q?8WVGD5UCX5qL1VDQ8E7T0dmJqQLHdFaPjWYjGC0dBWz0Ythn+pXYE9xi7sIi?=
 =?us-ascii?Q?QZUuIOhjGkl1pxUdCmHGXoEXhDmTaYcIpLxjg8MJ56e2DV2JfWMJhRlJxqOv?=
 =?us-ascii?Q?XY0SmAE8vYNvLAkd9vFJRm2IwAKwVsGiEH2nmJL1xFaBhqyrVZjsvX74bWvq?=
 =?us-ascii?Q?FnuChnolyc31qbtJ20RD78+lJTRAyxMtkWGbTJVPmKy/IZ4sFr5PzPSomhYe?=
 =?us-ascii?Q?mMvUpLYg2kta78JbvZNWRdGCGi3M3cciBXCUaiR9+PmFe+KeOEDSJa106RaF?=
 =?us-ascii?Q?ValPTgPE7naCLujUKLeWNJbIU+U2r7nzkK6xhZ3yJ+MABv57AYTYdh1bTYpC?=
 =?us-ascii?Q?qP4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7950ed-27e8-4e62-436a-08d8e3c91def
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 13:33:40.1537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: apFb7Dbqv2VeQoj/ApQJh33GfHXFB1Sr4K7LWm25Ma75GcZv0y8RY6e2BTSzEt0IrzMq8I0IzVaB4Hgh+1fVAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Wednesday, March 10, 2021 2:04 PM
>To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
><kuba@kernel.org>; netdev@vger.kernel.org
>Cc: Alexandru Marginean <alexandru.marginean@nxp.com>; Claudiu Manoil
><claudiu.manoil@nxp.com>
>Subject: [PATCH net-next 00/12] Refactoring/cleanup for NXP ENETC
>
>This series performs the following:
>- makes the API for Control Buffer Descriptor Rings in enetc_cbdr.c a
>  bit more tightly knit.
>- moves more logic into enetc_rxbd_next to make the callers simpler
>- moves more logic into enetc_refill_rx_ring to make the callers simpler
>- removes forward declarations
>- simplifies the probe path to unify probing for used and unused PFs.
>
>Nothing radical.
>

For the series -
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
