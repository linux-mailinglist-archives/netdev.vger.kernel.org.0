Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EFC407005
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhIJQz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:55:56 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:60001
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229633AbhIJQzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:55:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2vyxRejKzLqCIVPQlH0qD/ttEP4U2w5eZq72G2vT9TTiGCRB33G/JfwSXMOgG/o/SJq1um9wL38LBuggoDe2/+Eju9JggS+BwEnW8qoOm6ouYz9SzpOBm9D4kGnVxie8y8iwq/Y/hNvsoEXfdj1VEg5ADxvao2H9zmYkZZ8EKhkU5eavBtitV1Lcw+oT8YnYg4wmjSTO1UnQPD3QjonT5DR8EIsZhZxy0Er4LS9wpmARyU8JEc0wqTuwE392S2b0D0meGC/u75PuDd5ZYshXrz7JCQJ5UhRbPy0m1iUi4oYC9Z9qOahKuYwXlDfnQsX0TeffmavJQWKnj8NnhHmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=07k0m0mrlJcc3w5+dOaM5Kp4xCx7nVSsqQT2V30EGSc=;
 b=EbopO9pFUsvOVtPtApFbCTBjj78mevnB15ph4d9yQpO+HtpDoBZeSPrq9T14PxrB/ReReTfJlOW9+zxYWncbubInmKSTHTDlfrbUNKE6MzorPl5qF3Ylg/91QxlP6mjjH3hVjwzORG/zj/byS3OEAF/zm7YB7ryjXhbhwLgj8kzBqrNgrgmmW0T5yaHePU2yXlcB8/XIBvCnjVce2M+wIrJjw6zZ+oLZyRmrAmU/K3HgVM36mxWS6uBTveN+X/912pTk4eWaa2EtiG1AZJHF97qneg7Th+7gnBdKA7Xg9ZlF9YPGQi9qhB+LwXHLbX68yem2kV0DeBs7Gb6ez68EXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07k0m0mrlJcc3w5+dOaM5Kp4xCx7nVSsqQT2V30EGSc=;
 b=mmcpd11icSax1F1m7ii7YL+6xr1rFub+q450d3H9PqEe4wGzPigp07KI7robl41Q39aPu50HW2cynaRpNpPH1SUm1aJov2lD57aUvqsqvhO6abIlU6ZmpyZUfdBH9JgAkAqLSuw8pWGmAkpsZjBk1m+QxH6/fVtrkqy7KvPxHuQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4703.namprd11.prod.outlook.com (2603:10b6:806:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 16:54:41 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:54:41 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: do not send CAB while scanning
Date:   Fri, 10 Sep 2021 18:54:36 +0200
Message-ID: <2897625.p8pCB6X8cM@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910163100.n6ltzn543f2mnggy@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <20210910160504.1794332-3-Jerome.Pouiller@silabs.com> <20210910163100.n6ltzn543f2mnggy@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN4PR0401CA0024.namprd04.prod.outlook.com
 (2603:10b6:803:21::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0401CA0024.namprd04.prod.outlook.com (2603:10b6:803:21::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:54:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61433090-76cc-4dcc-227a-08d9747baee0
X-MS-TrafficTypeDiagnostic: SA0PR11MB4703:
X-Microsoft-Antispam-PRVS: <SA0PR11MB47031C357E91FEBD1D0DC52293D69@SA0PR11MB4703.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +f7HXfmUE0dZ43JzCYPUbVKlBhpSmGN/vu9fUTHnwGs46AoW5jkyA4ALWMH/v5gJUYTD1srXmANNzI0xLyQI098WjAfowOdrg6+nzFSe0qB3ilLEwL93+sNw6gyEk4msPbPvGgpVI4t0anGtUzhXBb2PynXuBhGkjY/4CDtmrh3hMU349hb40GZ2sMSgDefxpEAQlKcScx7dbrKbHthk1wUAjoDZhYqQZADbWbwqo3a79LpWNrQUpKod492HD71uWcxDm+ppYjEByoNwjqC5zTUTySX/mimkj4MpSh+zjyIiufVzmqKlU03szbLy3kR2kGZma256KfwfUfUTwPx3STzDUkqpt4sbmw16zQardQ0ylaLbngX+yWCEb6mycUjN2qHwMR6FNdHPlx8nFuvlo4XtJhuQ7KTQUS5AmQ9TX7lk49Zk0t58fpMNNv5ygd3k4hN3Ki9+PmlTeCXmkw8O+wC/Q4aWNIQyqYu4VOMq6DmCmmSfBEqjFs38V6Efwuw3GeQ6nChqIRq6XR4K2HoKy1FQGOYI1b7dJTjPLl75vOXxHFzhcOQAQNivV9oSVts01U93FhEbuPfz2kbRRCl+OiBM7RlG/XrvuqTkX0ePx9jpQFN3PyMd70gz2n4i5S2gd3v9LwzD8XwgefJBwZ2bdwo/Q9CfsVEJSBsF2IbA4g1BWIonTYWCvY536fuiyyVS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(39850400004)(396003)(6916009)(66574015)(8676002)(52116002)(2906002)(8936002)(316002)(186003)(6486002)(54906003)(6506007)(5660300002)(66556008)(66476007)(9686003)(478600001)(38100700002)(36916002)(83380400001)(4326008)(6666004)(33716001)(86362001)(6512007)(66946007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?c+QircM+zrkhdtrPV0ZgXjilISgTHU/PQNDKyM5x78zg/klRpDP7PYp0mt?=
 =?iso-8859-1?Q?JSu+ylYQOH086Bu7KwZcmHkExFUwAUfuMQenC9SvP86hn63tX0r8rrvN1G?=
 =?iso-8859-1?Q?QyVweq8fbjRbm1jslXfkO2WIIKqYvFJRWxU8dj655B0GNBd8M2/fAWyByo?=
 =?iso-8859-1?Q?cyaqTwOQ9Ai1myVp7pEKxF7rTm79VRNYgNBKiBOzK2eDsxICmgCfcA6MAv?=
 =?iso-8859-1?Q?SH+A7Tb1pXNM+CuWnjV7zNI3sotfEtuSo2jME6zm5TyUPPLu+PFL2Uh0ez?=
 =?iso-8859-1?Q?SSg16JiBJrue88NNlf9IZrI+VJZ25ZkIIjhKOXTZvZoD6P4oHo/3NnMx36?=
 =?iso-8859-1?Q?ehfsyxXWJ1/UE5wIYISnJzZx6A51izyQl1RBrW3K/cf3STcTxTc7tIle4y?=
 =?iso-8859-1?Q?IZAT5gvhIrkeL8TY1lAIizTADyPIRG17+hMXAtUa3ZCYoQsE/8+XmlJo6c?=
 =?iso-8859-1?Q?k3YexHbZVSV2ncDIShD4Yd/QYjRcaMjdCh3s3mkgmYuOXkdHyK2Kn2mnZz?=
 =?iso-8859-1?Q?/HWNiKq+ic2Tkad6m9Kcl8YB+zv/mj71jBFILECxj1o4TwAIsyinAT5hfh?=
 =?iso-8859-1?Q?bHI5dZMRXogS2sBxpAVhSyuu2r7wdU8xWkzO5mKUqRinU1TmgZYYamCLLZ?=
 =?iso-8859-1?Q?MwM5f7Zea6vQzbu6Qa+qV1fmSosoMaazurHZXw+PDF/MTLAXf8pFhrQUj1?=
 =?iso-8859-1?Q?CJtnjYkKGutoa9a4CII8sCqp5w+/jcaCj3EzIzsW3joA848k94k7pdzL0j?=
 =?iso-8859-1?Q?xsALgK8x9Fu9om6ml0GjYJnBTQIOVCPjbffeAnWreujMzkFsEIhK0SNc/v?=
 =?iso-8859-1?Q?TYvgoxJVWfUWRXRSZaCSAE/fs3BKDfWg1ZqInUj2m7p8UDWqJrC/gRq+Qq?=
 =?iso-8859-1?Q?m1yMM3zqlCiU189xdppdZtFGh0H+5T2FO6aqJJdPBURazBVVxFTR/4inXD?=
 =?iso-8859-1?Q?m71c9I8MXg6lVOOaZFAItsPYtan1QQsquDz7S9y6DRQAkozX6KueEOyMz8?=
 =?iso-8859-1?Q?/weFQ7P3UdNlnSDEAsq00tTARVmFK0m0uET0QfG6mCgSGOJkTyU9QrbCKw?=
 =?iso-8859-1?Q?Y/XB8rmEQz+IT+RjzOABrW55FVx60YNioaeMbTopkZ3C4VsysT8h4gDZsc?=
 =?iso-8859-1?Q?WSMC+wECKVrim8dbC7e/qhygn65hHxig9U+p6Jh24PRy1v5bPuCSsJb3p3?=
 =?iso-8859-1?Q?fdHn4fEOmK/qO2Os2oTmOnSk2J5oBfRfIUpE96eoTW+vtcaRbCz0KfcezV?=
 =?iso-8859-1?Q?y+7e7uqOYvUNB3ZT18rKvGq1DIhC+l8J6+LMXKHHjF2dHVl0kWq0ZiCrKf?=
 =?iso-8859-1?Q?tXfuhQeEMChW9/6vi2F+udFemeJKhxvXjjpVw6Hn6+7TmIah9FKPh+jXQQ?=
 =?iso-8859-1?Q?K5xSNRaE0vwbMBCyEy1KCt+t1c6Plg2MWIBZFdNooUFGalgPyFJPca/UEW?=
 =?iso-8859-1?Q?o66EamjneiinL77H?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61433090-76cc-4dcc-227a-08d9747baee0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:54:41.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S11Uz6k8sUkkrMjEQHpAfqFjOjxlYd/gbZU7M9wm4oFQmYw1zWgeMu3wFZ+0HMgZksBHQylg7vfo2yWgGeNHhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 18:31:00 CEST Kari Argillander wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> On Fri, Sep 10, 2021 at 06:04:35PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > During the scan requests, the Tx traffic is suspended. This lock is
> > shared by all the network interfaces. So, a scan request on one
> > interface will block the traffic on a second interface. This causes
> > trouble when the queued traffic contains CAB (Content After DTIM Beacon=
)
> > since this traffic cannot be delayed.
> >
> > It could be possible to make the lock local to each interface. But It
> > would only push the problem further. The device won't be able to send
> > the CAB before the end of the scan.
> >
> > So, this patch just ignore the DTIM indication when a scan is in
> > progress. The firmware will send another indication on the next DTIM an=
d
> > this time the system will be able to send the traffic just behind the
> > beacon.
> >
> > The only drawback of this solution is that the stations connected to
> > the AP will wait for traffic after the DTIM for nothing. But since the
> > case is really rare it is not a big deal.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/sta.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > index a236e5bb6914..d901588237a4 100644
> > --- a/drivers/staging/wfx/sta.c
> > +++ b/drivers/staging/wfx/sta.c
> > @@ -629,8 +629,18 @@ int wfx_set_tim(struct ieee80211_hw *hw, struct ie=
ee80211_sta *sta, bool set)
> >
> >  void wfx_suspend_resume_mc(struct wfx_vif *wvif, enum sta_notify_cmd n=
otify_cmd)
> >  {
> > +     struct wfx_vif *wvif_it;
> > +
> >       if (notify_cmd !=3D STA_NOTIFY_AWAKE)
> >               return;
> > +
> > +     // Device won't be able to honor CAB if a scan is in progress on =
any
> > +     // interface. Prefer to skip this DTIM and wait for the next one.
>=20
> In one patch you drop // comments but you introduce some of your self.

Indeed. When I wrote this patch, I didn't yet care to this issue. Is it
a big deal since it is fixed in patch 27?



--=20
J=E9r=F4me Pouiller


