Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF142FC577
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394873AbhASNsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:55 -0500
Received: from mail-eopbgr00101.outbound.protection.outlook.com ([40.107.0.101]:46112
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389678AbhASKOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 05:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ey1KJ4U3dAD7wabejXc0vrAgVpiTc8+V4yPjSWuOVv8=;
 b=MVsDOSVV6E1zwr6sf4qzj8ql0yvLbX3Jjkj2+1yz+TbumfAgc+FrbcO8wAq6zXiVoCYp0cvpIatpibZGIjqMBW/FCkDiAeYl6FWQaEVWcApHFxYQdS2rVn0mhUTAqA7zv4hp6a7Nvx0mqQSlClAocslCNTo8bVQ8IdF4mCOzoYw=
Received: from AS8PR04CA0213.eurprd04.prod.outlook.com (2603:10a6:20b:2f2::8)
 by HE1PR1001MB1241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:3:e9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 10:12:37 +0000
Received: from VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2f2:cafe::c1) by AS8PR04CA0213.outlook.office365.com
 (2603:10a6:20b:2f2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend
 Transport; Tue, 19 Jan 2021 10:12:37 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 52.169.0.179)
 smtp.mailfrom=aerq.com; nxp.com; dkim=pass (signature was verified)
 header.d=l2task.onmicrosoft.com;nxp.com; dmarc=none action=none
 header.from=aerq.com;
Received-SPF: Fail (protection.outlook.com: domain of aerq.com does not
 designate 52.169.0.179 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.169.0.179; helo=eu2.smtp.exclaimer.net;
Received: from eu2.smtp.exclaimer.net (52.169.0.179) by
 VE1EUR03FT011.mail.protection.outlook.com (10.152.18.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3763.12 via Frontend Transport; Tue, 19 Jan 2021 10:12:36 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (104.47.17.111)
         by eu2.smtp.exclaimer.net (52.169.0.179) with Exclaimer Signature Manager
         ESMTP Proxy eu2.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Tue, 19 Jan 2021 10:12:37 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 14724495
X-ExclaimerImprintLatency: 546825
X-ExclaimerImprintAction: 89b52e80d41c4f368ee205800723a752
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glYUw/6s6h6qpcCyg3La9FrNRuVkhs/PfBJCcGFsPe5I41Nj6QwpwO5fm9xChfTfm3cmAAMgAu/sOLWodzKUvpx9T1dlW6iLtQ5BFCYQVo+lYUm9sSnyriiZPeVOkPhG4BgMqTTfnTTkrxY27KOOUuz5G5NAL/wEdIujjzjeObTTYqgFsUnw4CsA3kNSceoNpWSQsPjVOc3P89x+4QiWiJRiWMyrRdSCmdBW5buD7vtgv3KbCUouZxivJfvG3DKkGuIx2UHw5CG7kTG0pVFsqJoaOkLFVgmankY68pkMvFI1M8a7qGHY+aCa3TGTYOytolP0KmpJyxV8YlOQcmlIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ey1KJ4U3dAD7wabejXc0vrAgVpiTc8+V4yPjSWuOVv8=;
 b=hC4RoxvtErmxNei9zCHsMoRbLbEKGBN07/o0R1hF/4dPjXJkg8xSKcjUAWZQtF/u8o7y12XXBmKmKSpv5eijA7Lmh1DgDvEeb0z3YW5dU2EGu7sRi/BGkyRsNvNUNjSzf5PTObtP06t2TFv1MMZnWycam0f0gdmaCMm4ZMw3k/a2Je0wt9MjFWYbf1a7FKmM5MHTx5/YzTtyXC4mbaX910KVzB60UCwE6SoCcuzSk2paTD+JB1TjlHZ4TvfnIRScf3zs7njIt7WlMBPnMkD26OkyKruIU8+ywejTXcZDHO8OynoMoaYc3Qf1robV+c2efF8th5HvJYrSuSBCPp6Yag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aerq.com; dmarc=pass action=none header.from=aerq.com;
 dkim=pass header.d=aerq.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ey1KJ4U3dAD7wabejXc0vrAgVpiTc8+V4yPjSWuOVv8=;
 b=MVsDOSVV6E1zwr6sf4qzj8ql0yvLbX3Jjkj2+1yz+TbumfAgc+FrbcO8wAq6zXiVoCYp0cvpIatpibZGIjqMBW/FCkDiAeYl6FWQaEVWcApHFxYQdS2rVn0mhUTAqA7zv4hp6a7Nvx0mqQSlClAocslCNTo8bVQ8IdF4mCOzoYw=
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:161::27)
 by AM0PR10MB3170.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:180::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 10:12:35 +0000
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48]) by AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:12:34 +0000
From:   "Bedel, Alban" <alban.bedel@aerq.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Topic: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Thread-Index: AQHW7bN4HHCMCRTydke5G8Z5O01ybKotu3KAgAEAWgA=
Date:   Tue, 19 Jan 2021 10:12:34 +0000
Message-ID: <2cb97bec861c751530a04a9764b8855c8e8e2e41.camel@aerq.com>
References: <20210118160317.554018-1-alban.bedel@aerq.com>
         <20210118185501.6wejo4xwb2lidicm@skbuf>
In-Reply-To: <20210118185501.6wejo4xwb2lidicm@skbuf>
Accept-Language: en-DE, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Authentication-Results-Original: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=aerq.com;
x-originating-ip: [87.123.195.14]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: fab8b403-8521-42b7-f1a3-08d8bc62bf35
x-ms-traffictypediagnostic: AM0PR10MB3170:|HE1PR1001MB1241:
X-Microsoft-Antispam-PRVS: <HE1PR1001MB124179FED780FBB2890E63E596A30@HE1PR1001MB1241.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: fTyad3i5UCX4AIZ0FHiPV8tmmmhqJJhNaRaphpZsHEboozX2sLK5fitjsbNtbg6Xyh9SAardyPTeGdjcHtwJ0e3qwsJ/j4hAV7S/Cy6GiN6m4eaFQpK22VMRhIlYGXNQ2IhW2nHtkQUGFUUPDSQbditVezF4c8g0v+WF/FPNCQTNc1KimEHAqXXr+m4YVGKi/U1M6L0/kNWD4FBRtIbR/el2QzG0ZcZEX6LXktHxN61noYQGI5uxdG0BiO8dulaVu7FDBVLqNTTaB9TqpRIZmRB7SCdrLsSTf+ZqUBhCw4un/1LXeUa0taT/oQ7MQqzGHkAvvXcteS+//YLGRqVkGsP+qDXU3wnrstrvFWLncvD/xljlHz8/h3ax1TpcGGpD281WEObl3mOfqTP5Nyds2Hyp/i5ZMPYgCpD7A4E6hXk/f5Uf/HSQfBp4xVRfD42p+y1/DrphvTkDdcfe0OHnsg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(39840400004)(136003)(376002)(366004)(83380400001)(66476007)(8936002)(2616005)(8676002)(99936003)(316002)(2906002)(66446008)(64756008)(66946007)(54906003)(86362001)(5660300002)(478600001)(6512007)(6916009)(66616009)(36756003)(26005)(71200400001)(4326008)(66556008)(6506007)(76116006)(186003)(6486002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UE96ZUFEdU1FK3hvK3VTU3ZUVkJGc0lKMnlKajlqK1pPMk5vSHBYdjlPcW84?=
 =?utf-8?B?M0orK0RYRUdSUHJzZWVOWExSUXp1dXVzM3UyNlZ3cjN1N1FhS0RFNktOWllO?=
 =?utf-8?B?NkJINlBJS3Z5Q3hPM1FpcmJOOXByTEtmdTRkYUN3UUNIcVcwTGNNYnAvSHhw?=
 =?utf-8?B?dm5DUnVQcndDUUZDYldadGZaM05iajNKOTZtUm5rSHNHQjBJWng0NVg0NFdp?=
 =?utf-8?B?L1VZcEVPTUMwN1pCNHh0L2U3djRkbjV5SzJrbnl3d0tpQjlhaWUvNmYzWVEx?=
 =?utf-8?B?ZXkxZUxwMzBZVFUwRFFTMytqQXVjMEhhM09yUDBmYjFNODZYRE91d2txRnBn?=
 =?utf-8?B?Y3ZmNkwvSWxvTzRCNVhKVllDRkdRZ1QySEl1VXZCUTQvdjEvcVl6eXJuV0pV?=
 =?utf-8?B?UUxXV2YramZ2Q0pzOWswaXJPaG51TGdCdGtndmlKUFhYNSsvVjdrcHpmWnF6?=
 =?utf-8?B?RXEzdWJBQjRPendUd3N0QjBXWDlEY3FlaytoWmQxRkJTWmFIMUF6cTJXUFFj?=
 =?utf-8?B?UjhGV0x6YytxUWgrbGVrUVNoaWFsYnFpM3d1ZjdHMFl2elZaTFAzcmJOdDdH?=
 =?utf-8?B?U3FENnNya2ViVGZrUmdZZDdXclViUk8zMmhJRUZELy9mUmgzNWlBTEJWdXo3?=
 =?utf-8?B?dEtNaUdoM0ZmYmRlNHl0anloVzZKQUdiQUE2ZXB6eC9QWEZnVWZMTG5JTitN?=
 =?utf-8?B?UURveWxzUG5RdlR2cUEzQndQYituZERONU9USHh6bEJHNzNqcHFtNG1vRVFw?=
 =?utf-8?B?T1BmVDBLTlpTR0N3bGdnRHRUdExNWVNaRy9aL0lmQ0RtVjNSWWpCRUlxQktr?=
 =?utf-8?B?ZFhJdm0zQlU3NUxkMXZHSEpKOWxJV093Z3IwYTYwdzVCUVFYWENpb3FIdzRl?=
 =?utf-8?B?WHRvS0cyVXgvcVFoK1IyekVZQlVMWlBueHFGdWhyTXRPUDBPd2NlcTRXMnJu?=
 =?utf-8?B?NU1DOGFvNlBXV1F5ZERVU2VRTDFHemczQmhHckpzSlhpdzNURGo5a0VzZlph?=
 =?utf-8?B?Z0gvdDZieENsT1AwbGtKRHFUaEEreWQ1bzRLVkRWdTBZMnFIcm5xbXVKWjlS?=
 =?utf-8?B?eE9QR0EwbElFMC8vMXVYRkhMT0w0bDhQRzIwSjZrOWNsMzhvYkxxWGZFWE1F?=
 =?utf-8?B?MkhJbGxiV2tWSSt6ZEZqSjdxZlNVVFpocWVwc1hZRHNRTXhBVjRXMVZzNUg3?=
 =?utf-8?B?OTMxMmZsVEZPOGlwNVIzbFlSWnIvSCtYYTQ1R3RXaXVaY3M1Nng3M1VidVFE?=
 =?utf-8?B?S1I1YUY1eXFxSHN0ZTFMM0htbUYvcWFLekRKQlVqSDRVMkxOZ2UwZHBkU2F0?=
 =?utf-8?Q?P3Fsszch9vrQ1pXFZS0wCGE96sFPRdYRdS?=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-sqtLZymOXC82qOtWpQ/3"
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3170
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3557165c-7be7-4529-6b1b-08d8bc62bd82
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tfhapSXGgZlIk1Y/M8IJslmDYN9tMKrFU4ryp6PreEIsIYWb3mpW4E8qmm5iJzdYC2R5/AfSl2YrAbRv6pKUDW2EXCsjQ0SJ4U8AXIYhuifHVGFgS5sOuihY+V/Bkq6DxIYJa+HgzthRusjivL12I9bhi1RQFjFfDv3ec7H7mJXZwiEnMPg3R3M/akw1PA81JykqWHZ8DLKDwib64xplw34NxmhiuU2ms0vO+wMG57xHptXlBkyXOuhZF3scm2YKMNJCo+iLNwiKR8LkIzI4B+U2SdgJZUQc7mioH2nPlU6Wra0PqyYsrB5LfW5KOGvqj7J9fxLcfTVObi4ZSIR2uQ1vQd6sWIeyl85nOwjXP+NVSvwsNDg3R3zscmrLj2tGEHcSo8Su9mmVmSvOdN3UbBqGnRJkHnhOSq5In6jizlYnVL6Ti854b77GBk52TaHAwLgv3S9EhEX+pCbe6nwzAL8KK8Uk2wiwPihF9DnTGN9Ux4CGkta9/p9M+P9yBEX21Ehj60PlsApqEt/dG/YaBWYhy8z8TLWN5/MjTEzF5NSu3lF5giP1KfmsycGtmmwzrK+7ovxLx48fC5+Vq4lNvsRdr3xGNuGdOlakRsCfWCLfcDgBgVfRZ9Aj+m2wxXHTQSIV0wKrnsAUQ8c4gUdzJ5z/+kDDIuUe3VC5tdBaYc=
X-Forefront-Antispam-Report: CIP:52.169.0.179;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu2.smtp.exclaimer.net;PTR:eu2.smtp.exclaimer.net;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(376002)(46966006)(336012)(6506007)(4326008)(6916009)(83380400001)(2906002)(70586007)(47076005)(186003)(6512007)(26005)(70206006)(36756003)(6486002)(966005)(33964004)(8676002)(54906003)(82310400003)(2616005)(7596003)(356005)(316002)(8936002)(99936003)(478600001)(21480400003)(5660300002)(86362001)(7636003);DIR:OUT;SFP:1102;
X-OriginatorOrg: aerq.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:12:36.6718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fab8b403-8521-42b7-f1a3-08d8bc62bf35
X-MS-Exchange-CrossTenant-Id: bf24ff3e-ad0a-4c79-a44a-df7092489e22
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bf24ff3e-ad0a-4c79-a44a-df7092489e22;Ip=[52.169.0.179];Helo=[eu2.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR1001MB1241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-sqtLZymOXC82qOtWpQ/3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-18 at 18:55 +0000, Vladimir Oltean wrote:
> Hi Alban,
>=20
> On Mon, Jan 18, 2021 at 05:03:17PM +0100, Alban Bedel wrote:
> > Multicast entries in the MAC table use the high bits of the MAC
> > address to encode the ports that should get the packets. But this
> > port
> > mask does not work for the CPU port, to receive these packets on
> > the
> > CPU port the MAC_CPU_COPY flag must be set.
> >=20
> > Because of this IPv6 was effectively not working because neighbor
> > solicitations were never received. This was not apparent before
> > commit
> > 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet
> > mdb
> > entries) as the IPv6 entries were broken so all incoming IPv6
> > multicast was then treated as unknown and flooded on all ports.
> >=20
> > To fix this problem add a new `flags` parameter to
> > ocelot_mact_learn()
> > and set MAC_CPU_COPY when the CPU port is in the port set. We still
> > leave the CPU port in the bitfield as it doesn't seems to hurt.
> >=20
> > Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
> > Fixes: 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain
> > Ethernet mdb entries)
> > ---
>=20
> Good catch, it seems that I really did not test that patch with
> multicast traffic received on the CPU (and not only that patch, but
> ever
> since, in fact), shame on me.
>=20
> What I don't like your patch is how it spills over the entire ocelot
> driver, yet still fails to compile. You missed a bunch of
> ocelot_mact_learn calls from ocelot_net.c (8 of them, in fact).
> I don't know which kernel tree you applied this patch to, but clearly
> not "net"/master:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

My board use felix and I build without CONFIG_MSCC_OCELOT_SWITCH so I
missed these, my bad.

> I would prefer to see a more self-contained bug fix, such as
> potentially
> this one:
>=20
> -----------------------------[cut here]-----------------------------
> diff --git a/drivers/net/ethernet/mscc/ocelot.c
> b/drivers/net/ethernet/mscc/ocelot.c
> index a560d6be2a44..4d7443b123bd 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -56,18 +56,46 @@ static void ocelot_mact_select(struct ocelot
> *ocelot,
> =20
>  }
> =20
> +static unsigned long
> +ocelot_decode_ports_from_mdb(const unsigned char *addr,
> +			     enum macaccess_entry_type entry_type)
> +{
> +	unsigned long ports =3D 0;
> +
> +	if (entry_type =3D=3D ENTRYTYPE_MACv4) {
> +		ports =3D addr[2];
> +		ports |=3D addr[1] << 8;
> +	} else if (entry_type =3D=3D ENTRYTYPE_MACv6) {
> +		ports =3D addr[1];
> +		ports |=3D addr[0] << 8;
> +	}
> +
> +	return ports;
> +}
> +
>  int ocelot_mact_learn(struct ocelot *ocelot, int port,
>  		      const unsigned char mac[ETH_ALEN],
>  		      unsigned int vid, enum macaccess_entry_type type)
>  {
> +	u32 flags =3D ANA_TABLES_MACACCESS_VALID |
> +		    ANA_TABLES_MACACCESS_DEST_IDX(port) |
> +		    ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
> +		    ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LE
> ARN);
> +
>  	ocelot_mact_select(ocelot, mac, vid);
> =20
> +	/* Little API trickery to make this function "just work" when
> the CPU
> +	 * port module is included in the port mask for multicast IP
> entries.
> +	 */
> +	if (type =3D=3D ENTRYTYPE_MACv4 || type =3D=3D ENTRYTYPE_MACv6) {
> +		unsigned long ports =3D ocelot_decode_ports_from_mdb(mac,
> type);
> +
> +		if (ports & BIT(ocelot->num_phys_ports))
> +			flags |=3D ANA_TABLES_MACACCESS_MAC_CPU_COPY;
> +	}
> +
>  	/* Issue a write command */
> -	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
> -			     ANA_TABLES_MACACCESS_DEST_IDX(port) |
> -			     ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
> -			     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCE
> SS_CMD_LEARN),
> -			     ANA_TABLES_MACACCESS);
> +	ocelot_write(ocelot, flags, ANA_TABLES_MACACCESS);
> =20
>  	return ocelot_mact_wait_for_completion(ocelot);
>  }
> -----------------------------[cut here]-----------------------------
>=20
> It has the advantage of actually compiling, plus it should be easier
> to backport because the changes are all in one place.
>=20
>=20
> Please make sure to read:
> Documentation/process/submitting-patches.rst
> (this will tell you what is wrong with your Fixes: tag)
> Documentation/networking/netdev-FAQ.rst
> (this will tell you what is wrong with this patch's --subject-prefix,
> and why the patch does not build on the trees it is supposed to be
> applied to):
> https://patchwork.kernel.org/project/netdevbpf/patch/20210118160317.55401=
8-1-alban.bedel@aerq.com/

I must say that this condescending tone is a real turn off.

Alban

--=-sqtLZymOXC82qOtWpQ/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE0W61GceYqNjiMSkodJSaS524LbwFAmAGsJAACgkQdJSaS524
LbyVrw//VaM+31it5YRZU5qzyHhKVKT8EVbfvgTMbNnGArorsstaKCrU9z9jedwL
oGNzg1k31FU8dl46qt+jnrnY+pEnxCkO/Xw8tC26lottJQDq+UztDz5h0VAG9hyj
XSdyR1PAU1NjySQvPySKGjP0areF1wJZ7oYq8qC2fvqbi1EwYJPcymtGrFqHT1no
dWP//vcLzhLOQdlZDSuyQFTICYFUBjiClK7kMpwX1MYhwFBu/aW7omqUgkdwKYzG
CfVfWiXGbT6iRF0QvFHi7pycGELidtTmoxZ1wR3UY+z9hwwU2JCJdjmAx3esjJwn
Rio2f9hEoS96CH7xG0Xcr9tcZ73Fu3ICyB+n3VG50u5o2G93uBe+wAPGqZ7vMbob
aEslPVFL6E5sGWGlph4PzHo0B0MEKoKXKQcTAQiM+wcaEiKhZgbscqWVXANAnJZF
32EgSorXgRDZwvFpKV7s3fl3fOKfbcZAOP3HF3d6ksr474NNbo56c8L256sVAj+1
O0edhWJpuQ3N98+TGh8RUfxvz3F/bs7mFMs6U5tSF/rp2bpiTuhPqBeMXRcXCbRT
5I48gHN+2fDzvxbW/h/L4JYijOZu9ZDYp1GYQx1RPLcx0mYH91TUdrdGNMcu3mmY
7L/OYYdiYrSQDz/rNCd/WHwqdqHORANyh0V7esZ2oZeLagxIiqs=
=cDbK
-----END PGP SIGNATURE-----

--=-sqtLZymOXC82qOtWpQ/3--
