Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ECB2D5609
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgLJJER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:04:17 -0500
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:59297
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbgLJJEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 04:04:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glKzmpyuK83ct+OTbDhXGvYefaD9d0EpoQYwaMFFE15e4ERtkoqvzzyUuMorCk/mSbCiD5s6s5s4bZ3My+EEMVca3dnFCvEPT0oYVBhekKrI6jiqN+LQWGySUBxVW7rPAC/iuedXrq2KjcIq9bYxuiQ8hHYWKTb/KjnLf4Gc7NsrdXHlGYJ4/l7yNoUQkUod2D5mcmNV+2vCZvN6afTDP9spryjSzNHqL1BKS3zjt8Rpy0bggwHEO/F2TrLQtnfE4khbefitSSooZTjwrcismHpcIFCEtO4rETDy5hj09qEeaRTbH7aadYQ15OS6RtQZWek40PPkFtNdOVKa8USHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmKAf15GFX4z56FB6kccWKQiN5r/5cyno2ujs8Xy/Qg=;
 b=JN71XGjkWXSi240ylJ++jfKJ6K7OuTdm+uWN7/az616oZ93rnnbF8VIOgghGIOQd4MRlLWcphmn620/2RyyqMv3hvi8ZOF6I77luVd1aVGmYd0zkfEBnaBcnlBPezvYfiyzhAuqPlIzUeMTkYzezUMXDmIwcz9FEomWRkXv9BLwQBVJhsgHfvVMl6IigDP8+V0jx+5pAtQRdyQsWU9WBSKUMVsjBDeyjHonDjzwXb74Bs4KViq1J5wMdt/T30Y9hW8MWUH4fxGDnvt5nSaJHc1WjLiVYG+gKFTCChz+415fOSjVl8Vnz2GZRyVwwHmvCb2UxKOKQL8JWM4iCDKTlqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmKAf15GFX4z56FB6kccWKQiN5r/5cyno2ujs8Xy/Qg=;
 b=QHE8C43tDmiOpepTQkha/4RNjb78IsUyF5G4GYxH4utAoo0sfX1uvHb7b6V20Di5Njuejl/7OEuN/0SIcCbUYWXSQIzpAiYBzG8C8sMA+mAC+e3SsnP1+WYP44XwXWWOjD7tiwWkOhVBzixDjy2goImg/mLJ7Qt2E7VUkIyXnBw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SA0PR03MB5484.namprd03.prod.outlook.com (2603:10b6:806:c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 09:03:27 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::412b:8366:f594:a39]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::412b:8366:f594:a39%9]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 09:03:27 +0000
Date:   Thu, 10 Dec 2020 17:03:19 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Message-ID: <20201210170319.534c0377@xhacker.debian>
In-Reply-To: <DB8PR04MB67952071DBA50ECF03BF9B98E6CD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
        <20201208182422.156f7ef1@xhacker.debian>
        <DB8PR04MB67952071DBA50ECF03BF9B98E6CD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 09:03:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 391f7780-95d8-41c0-a9b6-08d89cea752c
X-MS-TrafficTypeDiagnostic: SA0PR03MB5484:
X-Microsoft-Antispam-PRVS: <SA0PR03MB5484E2E2C0D90762BC777E34EDCB0@SA0PR03MB5484.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyK4a6uNfnDvQSPMvNgL0EDtbCwLXyDruF4iJ8QmWJgsvZdEQ3STrpnOO4anUd4Kec04FMzA5kXYxaKPWStqlV1nvICgeKjb8dltYPhJWTePK63c0tiAI+ENyQstU+dl2Fro9KMh+DEUKxBRK/uajq7Hys0Gt9V0Aiwtm7mMnRSwmlkhg7rES1IBwqMYgkyQTKqO6LRyjVzLzmpzQJpCBSUnE8DVTkbhU6jXEDFrdJiM2mVVIG23MtsH19z9jdog2HLEN30oNevnIei0l6+6XqDIwwiHcWvQpU+4iIqYO8HPTfhr8rVCJbufXqy9DUBdKrHRPyJ0bNH9hiD9ANx1GrW/5KUH6fefl3m7nuiDQ3suDai4EzhimdbJa7QnON2d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(66556008)(54906003)(26005)(4326008)(15650500001)(9686003)(6666004)(956004)(86362001)(5660300002)(1076003)(55016002)(83380400001)(66476007)(508600001)(8936002)(8676002)(6506007)(53546011)(66946007)(7696005)(186003)(6916009)(16526019)(2906002)(34490700003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MFBaUE9tUk94emZGdkJycDhkYlp3WEd1dWlsQnJNQ2xYNVVhaVhETTJjZlNx?=
 =?utf-8?B?VkFSRy80akszRGZZM2dqZk1MWTFrQis2cExYWlowaXFSZk91NFlSSEJnUzhy?=
 =?utf-8?B?WEpxNG1Hc1ZQQlBGbE10b09PVTFkT0pLc3RvTHNzRzJiaEErQjgyU2xUeHZW?=
 =?utf-8?B?ZDlSRU84aXg0NlhpU1ZGMExiZi9aU0h1bUs4RkdKR3M5bUZFd2NubXRzLzR0?=
 =?utf-8?B?dDRKOEZyYVJrTnU0ZkMyMndCT2dlZFBWQXEwM2Q1YzVDb2tXbDlMQnJmMjVt?=
 =?utf-8?B?WXpJcTM2eFI1WkxtcFhKWnFIUHQ2MDlNT3MyUVFpKytVSDdEM2U2dElRaVBm?=
 =?utf-8?B?MzBKUW43Q3c0b1JlRWxHdWtxOGYwanlvcEtGQTNWQ0RFb1RubndLcmJaR1VF?=
 =?utf-8?B?Wkt5TnYwT0RpZUFabnZLSXN4bFJjam4zRTZOUURHT3ZCUk9pcWZNMVVXMkts?=
 =?utf-8?B?K2htSG84bWNqTWp4RnhicC9LWWxTbVdITURuNUhreXJIRTFEeEFlYi85VFdK?=
 =?utf-8?B?SzVwd3dNSkJwYUJvQzRUdGZqTGZZV0JkZE1Fa3lreWxwUVNtdGpCeGRuMTc5?=
 =?utf-8?B?SjhJU3ZmTDNwbDF0cVdpVmlDK053NEJzNzl0RytIZUM0VXpUMnBIbUZYRC9P?=
 =?utf-8?B?Zmx0RFhBam5kUlFLYUFoK3NvOUZmb2JqWTlJMTVxb3pHSUh0cUhsMkJoVlJV?=
 =?utf-8?B?UHh1VEtWeWNhN1hmRHV2aExUc2RSdWwwaGtlM2ZxQUVuYVBnM0tCQkhTUHlx?=
 =?utf-8?B?TVZwNDFXMWZsR202Nml1d2FiT3NWWUpvSHppcnlqWEwvZ3F2c2ZYdWpkVGlO?=
 =?utf-8?B?dkJtTlp2RXRiR2tucTA0UXZRTVhWd0NpMHYxRHgxM1BoME0xaVB6TVdlbVcv?=
 =?utf-8?B?QXFLVHorcHR1cmppNHpvbW9XTFNVMHR3NUxTc1V4UFlCTVNERmRtVmR4Y21X?=
 =?utf-8?B?a295cTFCUUNGMVlPa2NRYUE3aVRJMWdCNDBxVDQxSUM1M1hTejZjb2N2KzZR?=
 =?utf-8?B?Yk1lNGtGaVlpYVltdmIyWjY0eVhsdUJyNGhJa3UzZGpxOEdIVXc3allUanAx?=
 =?utf-8?B?WjM0TFV0L3ZLS3JXK2k0THh4ejlBQ08veTJHUGVtZWVtOUJReTMyVmZoMjUz?=
 =?utf-8?B?WHJHL1ZJRC9qYXVxZ01ZbzZCM0plTG5tQyt0OTBNQVJ6a2hnVVdEa04wSG96?=
 =?utf-8?B?MllJSWkwSnJQV3RlS3hLalZHNjZkeUVMaEVFaTU3N0ZYM2FkZnl1eEVxOTNn?=
 =?utf-8?B?dG4yME1hUWNnVTlWcHlpNGFyb2x2TnBsUWVVdkxJem5UUzEyVG5QT0xYQkgr?=
 =?utf-8?Q?waOW7t0N2GwLURNqZ73M721JqCeUFjKOhg?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 09:03:27.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-Network-Message-Id: 391f7780-95d8-41c0-a9b6-08d89cea752c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3OYlh4j3KsRZX8KA/nPrFNdCGe9EOmkFkYrjsP9dEwP5GSl45xTsgRh/acnS54zr1UdvUJCruD6ck6IMXAkrsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR03MB5484
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 10:49:03 +0000 Joakim Zhang <qiangqing.zhang@nxp.com> wr=
ote:

>=20
>=20
> > -----Original Message-----
> > From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > Sent: 2020=E5=B9=B412=E6=9C=888=E6=97=A5 18:24
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > netdev@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH RFC] ethernet: stmmac: clean up the code for
> > release/suspend/resume function
> >
> > On Mon,  7 Dec 2020 19:38:49 +0800 Joakim Zhang wrote:
> >
> > =20
> > >
> > > commit 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before
> > > clk_disable_unprepare()"), have not clean up check NULL clock paramet=
er =20
> > completely, this patch did it. =20
> > >
> > > commit e8377e7a29efb ("net: stmmac: only call pmt() during
> > > suspend/resume if HW enables PMT"), after this patch, we use if
> > > (device_may_wakeup(priv->device) && priv->plat->pmt) check MAC wakeup
> > > if (device_may_wakeup(priv->device)) check PHY wakeup Add oneline
> > > comment for readability.
> > >
> > > commit 77b2898394e3b ("net: stmmac: Speed down the PHY if WoL to save
> > > energy"), slow down phy speed when release net device under any condi=
tion.
> > >
> > > Slightly adjust the order of the codes so that suspend/resume look
> > > more symmetrical, generally speaking they should appear symmetrically=
.
> > >
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > ---
> > >  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22
> > > +++++++++----------
> > >  1 file changed, 10 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index c33db79cdd0a..a46e865c4acc 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -2908,8 +2908,7 @@ static int stmmac_release(struct net_device *de=
v)
> > >         struct stmmac_priv *priv =3D netdev_priv(dev);
> > >         u32 chan;
> > >
> > > -       if (device_may_wakeup(priv->device)) =20
> >
> > This check is to prevent link speed down if the stmmac isn't a wakeup d=
evice. =20
>=20
> When we invoke .ndo_stop, we down the net device. Per my understanding, w=
e can speed down the phy, no matter it is a wakeup device or not.

The problem is if the device can't wake up, then phy link will be turned of=
f
No need to speed down the phy before turning off it.

PS: It seems your email client isn't properly setup..
