Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451884BBA63
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 15:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiBROFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 09:05:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiBROFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 09:05:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482551802A1;
        Fri, 18 Feb 2022 06:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM2aAH0uOIS1MGzZbM9ff+kNW219EYEVs005HfCqZi5pNWGcv5uxg+5aGugwQlIGGU3OXM7jukqfDA/2/6AqJIxSI1zcBWDpu3UC/rq3Vd5LAkLjZfcwp7BLrbUFH2XXEzp0mk/4QzJBfe9KJDwhs9xl7tGoZqFdOJ7I/fKt+akKH0ltxIfOcyQLEP0HpZjOJWVPi3oJ5na1bWSRNjlv8prHTQwrwLdzEf+UwVhAbvkZzFzMaIP/hI9Z+LFu+vXTb97AZrBiGYceqRe5gDpwxDU6I3aOjecnVkhlWJ12Apw7yeZvk99PeyuyCzQ2Lxl0+ts+8uKuQZkITEJ0zTg//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnew7yp7Y/Pzd+vzAtd0A6WNvd8bwQHt3U5HIBuDuW0=;
 b=HtHMVJz0JcsZw9MYJ8GaZ0p/e7yQ1wuOHv7K49lfKm1UlNmp9AMnXpgeZ8dTzfP9imXRlrrRDGhiAzvDKEEPPjO2KXHce5zd/NoMTY5x1DZdHwiZxCYHoRdRQwtNDl07WSBz4eGubT0km9M8NkhC+Tfgr6mNr1d7g/XeKxJVFHDOzS67B/tAIunpvovIgM6VePbsLJnjsnxNQYTsBtWFApLpN170b6oNGq1zFQSqRoYodk8Ly29aEL2U2+m+YLRfM75gyzL2cX8lPuaYfWkvV6Bn+zf7kPua03rWYYFNi28Ne/4EIgjxkBWT8+BbYgUTzlsLrOgbx/DrwZePz7IQwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnew7yp7Y/Pzd+vzAtd0A6WNvd8bwQHt3U5HIBuDuW0=;
 b=fzAeEhxlrRXBZPBHseQwlR0WqeOVbYvSvxkYEselxa+w4+LPVoZHyQnCTAGF0FDFTChsEYpUW9x53yq76Szv1rhlMfGzkwa5WUfvPAMiuNAbdiFBZvoo031y7PsN0xDRAhQAxMZOR0+HLNfhO7XQZkUgQuz5j1NZB2CPybTGJB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BYAPR11MB3704.namprd11.prod.outlook.com (2603:10b6:a03:f9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 18 Feb
 2022 14:04:56 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 14:04:56 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Riccardo Ferrazzo <rferrazzo@came.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Date:   Fri, 18 Feb 2022 15:04:48 +0100
Message-ID: <3633390.6h3MoT29mx@pc-42>
Organization: Silicon Labs
In-Reply-To: <5feac65fc71f4060abb7421ee4571af4@came.com>
References: <20220218105358.283769-1-Jerome.Pouiller@silabs.com> <3527203.aO2mCyqpp7@pc-42> <5feac65fc71f4060abb7421ee4571af4@came.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR2P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::23)
 To PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3172c93f-98de-465a-0414-08d9f2e7a486
X-MS-TrafficTypeDiagnostic: BYAPR11MB3704:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB3704BB7BE402CA15AB301EA393379@BYAPR11MB3704.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ciUzOWhqr2R600mr1djOi4uIob83khJAbuaWkXy9TlStpp+IW54/DFUhwHFsDoO9e1zZI35IHlDKRC5j6FVwTcw3q2uP7zruzTAijnma3DXKctIfMd+jITuKqfWqHCx/JcruD4dGdq7l49GnqLZ3F8x8uCbzFpKeyOOye4z5FuTeFvMatD/2l6ZSQYGhZiFY3kbKvHjtXAifVyQfnbJ3hnHlIsRRQvNO+yWa+CtjW1SkObRzztFi+i4Y2Qwy2p5ax9TSB5Y2U90M6FK2El/OqiGqxCIds86xbTGqCvpLVpiNdRoeMgU68WGU/0+385/HPBSjGnl/OpyUgi1nHK4veXnuwloPMwJFw3JtARUc4lag9gXuvymWa16ZX2YnWnbWf/TqfE4n4DX+LxvxTZD9fNiHWN3wZI4/wfkoYl7UR/u71jZiiSu9TLnLJzHoQLN8qf0uLxXd1FF7YAL5dYQgH+rquDF5A6KFODXuWdqdqQ8n684z3yeqIbiy0F/XBVDZ0tZH38Myq3SB72wjhPHNZ7vEVDUpZGJEaFdMQVzqzmJD4Mzt2KUmEKijYENRexx7pa6ItcKnXkpGJZTW2HPR6361pObARQTNn1bo8xk7fpITasi/vATjDSh4OfkS95a4u8Xb5WhO1K0MmOjHtUQFUQriX5XyiCgyUu5/rRlGHGZygIMdhlZZbAzMXSkGycgz/pSNZVdW1nmzAWtPgrf2Pk8teLv0eNXGPDkOe9UorfvPkz1CvpJOaK8O5yo8M2PVk88X0T4HyzqF4tW3uf5Uf9kvwUh6SLDVoMIBl69i+yd9+pYs6yAgkgsWxd/CKs++
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(36916002)(66946007)(9686003)(5660300002)(508600001)(316002)(186003)(6486002)(66556008)(66476007)(966005)(54906003)(110136005)(8936002)(8676002)(4326008)(52116002)(33716001)(2906002)(6512007)(6506007)(38350700002)(38100700002)(86362001)(6666004)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ssmNS42NlWRfpJNn/FmEQMToFW1ErITwv6zVPZASSyeIvviK6qSbrVN5IJ?=
 =?iso-8859-1?Q?w1GJAYnlIg9DDbfdZcUiUQb4vEsgoAx/dVUK74oKj38b+kGzhf2xUw3Klu?=
 =?iso-8859-1?Q?9Xa2c7rqkZBlV6xYCJ6LcS8s7+o51Agbj32BPJNWInLtzJiIoKSa319p+c?=
 =?iso-8859-1?Q?w4ZAZSr4mp3oRy/ocVjVsjqhX/EZ6jsrbCBZ0D5unpr1OGwWpIJMHU9Sp/?=
 =?iso-8859-1?Q?VZnuq4n/gNnmJY28D+bh/kWks8NgUqFFSxyRd9KSk4W5a7aXMXYJoxrgb/?=
 =?iso-8859-1?Q?BO4xfiJ6+2OqeamA5zYU6jey89cPCAeSaiWn/2VaWa+7TcKJgF/uG8bwUs?=
 =?iso-8859-1?Q?9yuiNb/4s0spltGPseMLvHALu5gDr6QSsHjwjcA+HFq+YzOe+BqcdZXPtX?=
 =?iso-8859-1?Q?0G6AUOS5irPzrRO5a4n1rQio3oLrk8+5+a2ZOaqkYCOF86tSYV3A4U8NLW?=
 =?iso-8859-1?Q?0We/3mqQ/WKmYl1o8gpTKHHYMK7nen9ecOTKRvs5whulSaxCGPPWvMOPMS?=
 =?iso-8859-1?Q?lQQ7y5Yryev4I+ThTr3grVsDOE9HzYnttYlrjjtdQ2v4T+G9pT9FHGGUxg?=
 =?iso-8859-1?Q?u3o/UoOdlDcEzRGIMK9/h6OzV8ANB9c703210/YtvyWMAkXaSjkpVOOOHg?=
 =?iso-8859-1?Q?F3JmGCNCj0zA01l5BGl+SR0IuCTKS4Jg/pB32fYH8ahKikSVByrHOD45vn?=
 =?iso-8859-1?Q?rjzcfi+YD/WsBsZe49mhg8Tn/Ixts00zARmyP5/Bnz8b1d04cKI3ZOSqyS?=
 =?iso-8859-1?Q?4rDzs361s+IPf0V4WEXEtfTKagBjTLvbETMpyVd3xfw603uGPn18xgYNxh?=
 =?iso-8859-1?Q?O8RXJ8I4dRqibsmlPq1PP0WHmk6YZlfZCr2TmB4narTuKySyfZlLyTlJcT?=
 =?iso-8859-1?Q?UW9DTThreglI84T5dsIOMpRN27XGoHN9fYHYW+/7kExtg8BJ5vCshHe/cv?=
 =?iso-8859-1?Q?fVNNWRSZrvDbRyt/xrYcVOPOUTNiLh2HQCvStqropIm27kPG1BPhZQRO4N?=
 =?iso-8859-1?Q?771bwsLxxjjqwpYaXIkSI2uhaTk3be9KyLDdjjHxheIUY+7OIprjiiPdeS?=
 =?iso-8859-1?Q?UyUo6u/u5PKXDqZc//1qh4tYsjeEFBiAsbphi4g2P1FYNnQ0nZdkD2RFgo?=
 =?iso-8859-1?Q?RFa9d9Zswjms6ezMJxxan56aGkirjCq4cBYaYVejadVvolfh+8WSGU+aMC?=
 =?iso-8859-1?Q?94sVBIpNPb1DJ2E8Hb+PPla+NcoDejvXKH7jh9Zi9YLlloxTDF5Obo0I5H?=
 =?iso-8859-1?Q?SE+ezeoa91TxR5GxDd6M3TbLI5AMZ4EcrW8wBgYc2KZXiPhHlNzdMtDHon?=
 =?iso-8859-1?Q?ys5Y5UYgTB+kmo/nqn1xb7GKkqPfDD6INUD8rkAvdOYJv/1ZgvBCN5DKaa?=
 =?iso-8859-1?Q?98M5K/tfVHDSms/VmwfEo7VpxaW87Lwp8fdInp4Tw02B2QvE/xTXzBadXy?=
 =?iso-8859-1?Q?H2cE7b4AyARzbSL19l6aDosge43T0bpkn5Tci7lURES4CwvEdfhLy5I1ZC?=
 =?iso-8859-1?Q?HM7WObp9IFPJzDqve34SFniGt8BhZlcKUZduHOSL6q6507n1jtxsZG7NdH?=
 =?iso-8859-1?Q?3nBzWOWpSHFBLQHqnSjjp8GNYUby5Ar+ruC0vuf/B2/iGWKRbQWuuNShZQ?=
 =?iso-8859-1?Q?HISUyQAjxdrbBbuFKh03basTgyumHQRzGwdmLTlk2eQloQ23ub11HC7rfq?=
 =?iso-8859-1?Q?rinYxQKCXPX9mrRuZS4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3172c93f-98de-465a-0414-08d9f2e7a486
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 14:04:56.4074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PV4A3xYqbwssTetryvnCHDRs/l/QZOtedxrHEb/gC2qnZ//EYcIXBwMvpd+NtjDbDgdkJyb0DmJl70ur6rh2Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3704
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Riccardo,


On Friday 18 February 2022 14:53:35 CET Riccardo Ferrazzo wrote:
>=20
> Signed-off-by: Riccardo Ferrazzo <rferrazzo@came.com>
>=20
>=20
> Sorry for the footer it is added automatically
>=20

Your mail has probably not been received by everyone since you sent it
in html[1] (try also to avoid top-posting).

Nevertheless, Greg, is it sufficient for you?

[1]: https://useplaintext.email/

> On Friday 18 February 2022 12:00:54 CET Greg Kroah-Hartman wrote:
> > On Fri, Feb 18, 2022 at 11:57:47AM +0100, J=E9r=F4me Pouiller wrote:
> > > On Friday 18 February 2022 11:53:58 CET Jerome Pouiller wrote:
> > > > From: Riccardo Ferrazzo <rferrazzo@came.com>
> > > >
> > > > Some variants of the WF200 disallow active scan on channel 12 and 1=
3.
> > > > For these parts, the channels 12 and 13 are marked IEEE80211_CHAN_N=
O_IR.
> > > >
> > > > However, the beacon hint procedure was removing the flag
> > > > IEEE80211_CHAN_NO_IR from channels where a BSS is discovered. This =
was
> > > > making subsequent scans to fail because the driver was trying activ=
e
> > > > scans on prohibited channels.
> > > >
> > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > >
> > > I forgot to mention I have reviewed on this patch:
> > >
> > > Reviewed-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Reviwed-by is implied with signed-off-by.
> >
> > But what happened to the signed-off-by from the author of this change?
>=20
> The author hasn't used format-patch to transmit this patch.
>=20
> Riccardo, can you reply to this mail with the mention "Signed-off-by:
> Your name <your-mail@dom.com>"? It certifies that you wrote it or
> otherwise have the right to pass it on as an open-source patch[1].
>=20
>=20
> [1]  https://urlsand.esvalabs.com/?u=3Dhttps%3A%2F%2Fwww.kernel.org%2Fdoc=
%2Fhtml%2Fv4.17%2Fprocess%2Fsubmitting-patches.html%23sign-your-work-the-de=
veloper-s-certificate-of-origin&e=3D09733f94&h=3De09f2efa&f=3Dy&p=3Dn<https=
://urldefense.com/v3/__https://urlsand.esvalabs.com/?u=3Dhttps*3A*2F*2Fwww.=
kernel.org*2Fdoc*2Fhtml*2Fv4.17*2Fprocess*2Fsubmitting-patches.html*23sign-=
your-work-the-developer-s-certificate-of-origin&e=3D09733f94&h=3De09f2efa&f=
=3Dy&p=3Dn__;JSUlJSUlJSUl!!N30Cs7Jr!GRgB_JlhZF2XzaDEB1ZDnSbLiMmD8XdrmC_uqyL=
oczR5e05vvMlDCgyKlEu3XyI3PdJK$>
>=20
> Thank you,
>=20
> --
> J=E9r=F4me Pouiller
>=20
>=20
>=20


--=20
J=E9r=F4me Pouiller


