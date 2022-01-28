Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F2049FD25
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349704AbiA1Pxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:53:31 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:59274 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243235AbiA1Pxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:53:30 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0EF5F40069;
        Fri, 28 Jan 2022 15:53:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elhTkEX+H7arJYqBQyOd0A5SGCim5YAa9KesYUMaG7C+lkJtNE/Z/Q1VN/oH2r+CJBcc/umZ/6CAZ/U0k7JXfgehnsofu/AvDLwKlWgNOpElIbRKZjSF2CY3iy+AKfPJr63X5Lm/qWjzMdaMthKhyuJTi4qwUJbw/5GKoO++Lo/pg7jzbKB1jiUONIDruaViuN0koyVoxci7GtKtKVj92EC7qTbhXFZBmOPgMOaBwnhKp5IOEdvzHRUbnhRraZaMlvrzhTUgLolyRgHVOPQT/2AA3oj39MeJq1NfrDcW8ykipCKT9oEV46hnUjfukRT0Dhzk0jBwM5JcugLtHc/x1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLVmYLNvulQOPvhK91zkDccvyMquPJaO8uTPF9MaUNk=;
 b=mXYG8idr3rKMpSdbMutoQH2tkk/qDRYBjEAkPAr/bvR/bNwKxjSbxJsmj6RSSBhPBBw40uZD3Qkjv7+4pC1PoiztLxXPl0H7+z9aX3I3eIjZ17yKYL72BpmdfAsWWX3gclCLh41ccW/sUSrAe8cLqblRCfwtQWdRQYub+041bVVp0fLAOW1cNtlckp7sPaEihIlndzzrXv0+acTadCrAz0ru0ViRmcTapt81eLcS2wB9HQX45udMGNMfSTd5IY9wsRq/uD0TSNfOZqkSDSsR/IC3I1o/wRUaFpdpGhki985JRhOOWGmtCeSjAbsY9n8tuUqRjORnJkr9sm2FWN/qMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ellipsbv.onmicrosoft.com; s=selector2-ellipsbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLVmYLNvulQOPvhK91zkDccvyMquPJaO8uTPF9MaUNk=;
 b=a0m9URBrgPziCkayRGmQVSslqt3Je1HusBw8MZ7a5CclWdijPB+y/sZ8u1r4Q3s5Cnzo0/Z+7xVv4wXnMmkMtPHUUL0vTAs4WgHh/Ykk89xNp/Tmxv6YFNa0e7NRp8dyLLtg+us0BxFavmXJBLp6VGE1hi2t3r1A5yOXnXEaElc=
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com (2603:10a6:803:85::27)
 by VI1PR0202MB2543.eurprd02.prod.outlook.com (2603:10a6:801:8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Fri, 28 Jan
 2022 15:53:25 +0000
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::90a6:6948:1fd3:99bb]) by VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::90a6:6948:1fd3:99bb%4]) with mapi id 15.20.4930.017; Fri, 28 Jan 2022
 15:53:25 +0000
From:   "Maurice Baijens (Ellips B.V.)" <maurice.baijens@ellips.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE:  [External] ixgbe driver link down causes 100% load in
 ksoftirqd/x
Thread-Topic: [External] ixgbe driver link down causes 100% load in
 ksoftirqd/x
Thread-Index: AdgN3k7I7vjd3hpWRMu+eZtY4Feu8gGfcZCAAAB+5EA=
Date:   Fri, 28 Jan 2022 15:53:25 +0000
Message-ID: <VI1PR02MB41424341E3E7BA3166E043BD88229@VI1PR02MB4142.eurprd02.prod.outlook.com>
References: <VI1PR02MB4142A638EC38107B262DB32F885A9@VI1PR02MB4142.eurprd02.prod.outlook.com>
 <YfQMQWsFqCIPBBqO@boxer>
In-Reply-To: <YfQMQWsFqCIPBBqO@boxer>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ellips.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0931ccb6-560d-40fd-4ef9-08d9e27651bb
x-ms-traffictypediagnostic: VI1PR0202MB2543:EE_
x-microsoft-antispam-prvs: <VI1PR0202MB2543BE89D6324CF43F16DC7288229@VI1PR0202MB2543.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:576;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XHxkcEGp+fpSv+0KRi0K0elVbbsZYEJB1kuLcFEBQYiC9whfAw4PPxNrzjxqqD2IJNnlEGFNkN3BSbtT6QIbAAsyhVhDALwcDrlIqssx58YaeTM9yXn5dgyJDeq5M5FStXZj8QIqH/q7pobOLNpaXzg73tspS0p2gE716DajIAuFYRaMvU5RXwQOWFvFQeESV8chvCb//RUjs4txEkCJQskN4p8ZnKHdZO+F78EDrAOeT0NYePoi22z5JTU5RnIRQz4QtrrdYJpV6W9SJFS4ga8i8NNHHf9dGsHzxU6Q4SZnwq38AiYBTlbaLFE3YSrHkdgS5I9nB6CZKBjtMP4nITRQZMC1A5raAwPoU+C83GZbxbhsSxYoJ9SYNHZH6JQWsFF3VwdOJ0Ox9k+VlEoW9nicBvj6f+UG+fcvhoQ2rj7GntdtkZAjoLttWJTomr/2MY6Dn5sgiXALTQHqt1bc8uNsAO+cYqiwX0DlBqbHI5lMmI6FRB44pQeer8C+D5o9JwYuDOMuMizo7rtcSNDdBewQcWBkw8AyIXGApzhmZHodxKNu9QQDWzlLV4z8G1oQn/N8/Mod0oStHlm/5cs6lndMMwNU4af4iHCTqAiRk2+3Xquriw5ALhC0R5CZ9cMdeOx6acOXuksvBauq12JChWEjw65/qbCBdWyAg6jiV33TmPOw0kqO7a0oaHYMIvTlamFgziN5IYnSUWL3imbXpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4142.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(366004)(39830400003)(396003)(2906002)(55016003)(66946007)(8676002)(64756008)(33656002)(66556008)(52536014)(66476007)(66446008)(4326008)(8936002)(76116006)(6916009)(316002)(54906003)(9686003)(53546011)(71200400001)(86362001)(6506007)(7696005)(508600001)(83380400001)(186003)(26005)(38070700005)(38100700002)(122000001)(5660300002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7km07tmSmAXLVRte0yJtJVALfviJe4937Sle4RyAvF4HOIZlzB+YR0jtG5nf?=
 =?us-ascii?Q?4B5Qn3+lgTY+7oQkPXai6mgZvfRNP8bXrLyY359JtrqOWhZ8QniG4QqcZW/d?=
 =?us-ascii?Q?GuV+XQdrAcLrKTzPMaKP6WyN2aKYWpvTRD21fcPOaNHRxQa34fHTKhh3DuUZ?=
 =?us-ascii?Q?bmeHOq4F8QTGc53eU2xveBlA5nkto4JI1+orGtAfFl3FYYMOmiOqHFadPb5M?=
 =?us-ascii?Q?rm9jMjIrYVcj2C33m8TIIocq2YDRtLkd1K9buEAe8z3mjGD0b437d2Yc0j5/?=
 =?us-ascii?Q?OLHuWRHViFIRwFsF5nCk/zUxXxkvFMgNWaaN4zQFqFgF2mu16zff+CJ0kESH?=
 =?us-ascii?Q?0ZLQYiSGg7PXQWZT+avz2ifEejdWSo115+h6KsgKZsxhfZYxz+zq55LIN4K2?=
 =?us-ascii?Q?cRMTiysq8TJxMwozwY+EsLc9583xYQZO1sP5eX/pi2eiMY/BG/u2rAuezfYv?=
 =?us-ascii?Q?BKjvtAZEBXeRshEnIh3JyGJJh5eZWLeNDJYinLSvMkBFhfsJcxebPAPd2hca?=
 =?us-ascii?Q?krnlTDT+qEV/DIp2z42mlvCHXPGYS1Lu3DYWc8NRAUq1G7URCWiOIJmBZ4ti?=
 =?us-ascii?Q?wSYg4hOXIH8pqwpK+0KDgIps0rIpmlAo1ycEYVx7Nzfl9Sz+6MNRtytEUUDX?=
 =?us-ascii?Q?ir5FB4s2I6XHLb/AtoByXnU2vpzwZlDgOzSmsoYnm16kJpXT4cC9JfRSHMVR?=
 =?us-ascii?Q?9q+Y0bOFJkNsxLjvpm1QVLKVc6ULALMcdeqDA1DmyffQsDl4TGJi0e2udwnz?=
 =?us-ascii?Q?JmDgy7sMMWQWSMKpaEc339G1Qt5Y7kViFZJyoFZUAiaMX4aoeHtb35f8tmOr?=
 =?us-ascii?Q?dXeEMLMKfprthVTQGhObppc2xAci4jWjj3joZao6A2d7rxVdaCvaRINJ8Ojz?=
 =?us-ascii?Q?6NsXADnPLV/m3XH3CXbx/T8D/yX2h0c3OMdZeGChmakqwLRa1BFgHoXLLfnz?=
 =?us-ascii?Q?OI5hN5A6l6t8LkkqKXd2AFuWPNEgKgjlgTiiz/8kCmzSYhOLiMjbeEF/JP4m?=
 =?us-ascii?Q?JT7yTeBGTR6kZB6HRQI5HjOhst96DI+eZ6In3B1dJX8N1vqob0mWm+hxb0+d?=
 =?us-ascii?Q?GrD82M66J7IzC17iZvmy4cltFeBsa6yt8YNBg/H2CZMoafcLHmHYdbU4l3qS?=
 =?us-ascii?Q?P7YzZg8tZvUfpyyqqAIB4eQmRAJTNvFWuqjRvqk5NT5gUMgzdne6ar3lTday?=
 =?us-ascii?Q?U4Eyyn3oUSDcyQrhLn80gdE3KTblHzTddvRwu/9BBgLSKRSZws9JzMmzFHDi?=
 =?us-ascii?Q?Y2a5/idklyaJFv8yu5vUw5XZ9d5bWtJAo6W6JKZ3czaYlPunsH9US/92eLnW?=
 =?us-ascii?Q?wwQxnR2VunIZmh0VwZ2G1qtJCajuc/bcv2xb7zFpXuO/dxFbvsHfgrrIzo4x?=
 =?us-ascii?Q?YDBOXd2JOrA8OBrEGsOWJ512FLDTE7ffQfihSCmUe24XZDDIeJrG48+wdcKP?=
 =?us-ascii?Q?mkY2iTKIVxHOvJ/tXbK7miRfRDiklTdH6zPiuzHpGvsa/eSCMtHnKyb8+90e?=
 =?us-ascii?Q?yZQN5hm84tqxBGBSPTKgKZEUtMWtFlnvb2meTLeFgbxR3ZdpePtWsj/RyifT?=
 =?us-ascii?Q?on2eDHaOwvhGB9UTGhu6nJNszXpv33g5+mLG0NXrY7f8itnLXbD3fsYi88fN?=
 =?us-ascii?Q?8cOPLqHio1POsWke9rYp0ho=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ellips.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4142.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0931ccb6-560d-40fd-4ef9-08d9e27651bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 15:53:25.3009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53a902d4-22e7-42c6-a1ea-5776f15ccd54
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XH6DiuwcbWPIano4MICP88Y51tghUyTqjEU0wid2GiZ1h8oT2KFnUUQfi/EojH7qeuX01w6Pm1JZ3UKhrS+Jdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0202MB2543
X-MDID: 1643385208-x-WLg88VH5wZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>=20
> Sent: Friday, January 28, 2022 4:31 PM
> To: Maurice Baijens (Ellips B.V.) <maurice.baijens@ellips.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: Re: [External] ixgbe driver link down causes 100% load in ksofti=
rqd/x
>
> On Thu, Jan 20, 2022 at 09:23:06AM +0000, Maurice Baijens (Ellips B.V.) w=
rote:
> > Hello,
> >=20
> >=20
> > I have an issue with the ixgbe driver and X550Tx network adapter.
> > When I disconnect the network cable I end up with 100% load in ksoftirq=
d/x. I am running the adapter in
> > xdp mode (XDP_FLAGS_DRV_MODE). Problem seen in linux kernel 5.15.x and =
also 5.16.0+ (head).
>
> Hello,
>
> a stupid question - why do you disconnect the cable when running traffic?=
 :)

The answer is even more stupid. Due to supply problems we sometimes have to=
 use
dual adapters instead of single once, and if one by accident enables the wr=
ong port,
the bug is triggered.

> If you plug this back in then what happens?

Then everything works normal again.

>
> >=20
> > I traced the problem down to function ixgbe_xmit_zc in ixgbe_xsk.c:
> >=20
> > if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
> >     !netif_carrier_ok(xdp_ring->netdev)) {
> >             work_done =3D false;
> >             break;
> > }
>
> This was done in commit c685c69fba71 ("ixgbe: don't do any AF_XDP
> zero-copy transmit if netif is not OK") - it was addressing the transient
> state when configuring the xsk pool on particular queue pair.
>
> >=20
> > This function is called from ixgbe_poll() function via ixgbe_clean_xdp_=
tx_irq(). It sets
> > work_done to false if netif_carrier_ok() returns false (so if link is d=
own). Because work_done
> > is always false, ixgbe_poll keeps on polling forever.
> >=20
> > I made a fix by checking link in ixgbe_poll() function and if no link e=
xiting polling mode:
> >=20
> > /* If all work not completed, return budget and keep polling */
> > if ((!clean_complete) && netif_carrier_ok(adapter->netdev))
> >             return budget;
>
> Not sure about the correctness of this. Question is how should we act for
> link down - should we say that we are done with processing or should we
> wait until the link gets back?
>
> Instead of setting the work_done to false immediately for
>!netif_carrier_ok(), I'd rather break out the checks that are currently
> combined into the single statement, something like this:
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index b3fd8e5cd85b..6a5e9cf6b5da 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ri=
ng, unsigned int budget)
>  	u32 cmd_type;
> =20
>  	while (budget-- > 0) {
> -		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
> -		    !netif_carrier_ok(xdp_ring->netdev)) {
> +		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
>  			work_done =3D false;
>  			break;
>  		}
> =20
> +		if (!netif_carrier_ok(xdp_ring->netdev))
> +			break;
> +
>  		if (!xsk_tx_peek_desc(pool, &desc))
>  			break;
>
>
> >=20
> > This is probably fine for our application as we only run in xdpdrv mode=
, however I am not sure this
>
> By xdpdrv I would understand that you're running XDP in standard native
> mode, however you refer to the AF_XDP Zero Copy implementation in the
> driver. But I don't think it changes anything in this thread.
>
> In the end I see some outstanding issues with ixgbe_xmit_zc(), so this
> probably might need some attention.
>
> Thanks!
> Maciej

Your suggestion for a fix sounds ok. (I have not tested it). Is someone goi=
ng to fix it in the next version of the kernel,
so we don't have to apply a patch here forever? Or how should we proceed to=
 get it fixed in the kernel?

Thank you,
Maurice


>
> > is the correct way to fix this issue and the behaviour of the normal sk=
b mode operation is=20
> > also affected by my fix.
> >=20
> > So hopefully my observations are correct and someone here can fix the i=
ssue and push it upstream.
> >=20
> >=20
> > Best regards,
> > 	Maurice Baijens



