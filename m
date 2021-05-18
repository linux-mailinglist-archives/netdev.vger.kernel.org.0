Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D93871A0
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbhERGKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 02:10:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2734 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230376AbhERGKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 02:10:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14I65OE1032595;
        Mon, 17 May 2021 23:09:16 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-0016f401.pphosted.com with ESMTP id 38m199s6ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 23:09:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0S8TChDflqokF2hGGXEBk5eI+zBjMWAZfEgauSsILzECupVUzs9P5cv/okSzTqoF8ypwguJ4Kue3TDjC8lRau4fzo6Bt8q8M+iswIzchRyQsMrT/pZXX0sir+QDdlz0xT1hzeEhJF7kbYmM3ThKIyGMsT5N9OdLx92IL6UGOBjnJfbc/1axNt45ZEwCJPdsBqrejmJEZyI8c1LZEGy7mB/RdvrEmcZjmbn2P0bZB6yVb/SGWX8Rjb7/C/0c/3srBJ69S1mTl6f3U1f3T8PDLIB9czmVU78ooOXgKGWtT05LlyvIWgG6bM+NZ4CJBrl5ley2M19+FT10Z74J2O6ISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IR02B9yOoSwgP7dD7YBHf8hvKr0MWcEfQJUEmQhmAQ=;
 b=Nm8wSIxgV4ox7bvJ9bMosaCbi35zGS0xnLGT0MQcovxOS9WcdYT/X+hPdRy3RaAlCIqXHdfkMpgc1zBeUMTcm57/NpXU6ahh+OoOqwqBHyn6+IQnm5mjQu27QkbcNK+k1IzbaMW0FBBui0ybtn+ZXJCq5r8hvYyxkgEaGD/lxYnWMQSS8ZT6kaKMFmFzOo2Fs2mWLfR0LvEOhzM4xLMlaLpDAue+hsD/MJ5Y1mLlt+QmCyIoY6kVNJuQ3LOMv7W6kz/wNfVO1+hv3thojL1o3yzCApaGOKZu4vE7VGJ7jl2EeFV7YGmX+oPePZqtdT7qISp/4+QbQ97x7T5hA+Q1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IR02B9yOoSwgP7dD7YBHf8hvKr0MWcEfQJUEmQhmAQ=;
 b=KhnJ7WBXQIp5LMtpykIm0/eGl1pmJ6zO9VVLWUwmvLrk3Tu3s0xjIqBPiScGAx99Lhq5a0g968nf5ijAhU8uWDUug88OlYPVW/omzD8nl89pqmNh5FPK3zKb62kIx4mvJnE4iP/SE9MLX+dJx4qXJ2RuVRFRgP2wEMpvQ/gstiw=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3828.namprd18.prod.outlook.com (2603:10b6:5:346::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 18 May
 2021 06:09:12 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 06:09:12 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] mvpp2: incorrect max mtu?
Thread-Topic: [EXT] mvpp2: incorrect max mtu?
Thread-Index: AQHXSMEeOB8utqlMw0S+5lVqOciSAKrow/5Q
Date:   Tue, 18 May 2021 06:09:12 +0000
Message-ID: <CO6PR18MB3873503C45634C7EBAE49AA4B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
In-Reply-To: <20210514130018.GC12395@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [87.68.36.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abfd00e4-d2fb-4076-d6c6-08d919c3754e
x-ms-traffictypediagnostic: CO6PR18MB3828:
x-microsoft-antispam-prvs: <CO6PR18MB3828B0EC51655DDCC2FAC451B02C9@CO6PR18MB3828.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HtW6pMd9vHMJI1Ls8EKkNo1zUWjQGLS1PohJiFMnyGt6eRAA8neLe2d/nagU3kNzPgjAIinCFhATvdVlrRphOJbMkvgOhLJ81eNXcG1jIIjf5ayqGpPev99JIh4u83cggEcYylCr4qi064smUo/owBNL5PDPUOda3DoeEcM9EvfFtzwF3yvgos7lb1mlRGrC9evVOk7ts2otF4lu1s3h5D/WeP4WxQKO3b4GfvK6+HPkv4oFgHa+fsDuQCLhvvJpsPmBf9GlHTz5Yfott83haTxooiaX+rH8r1VKxaXWhZ4UyLiPYeYH8BIYUK8J7fO65B6cIt4zVsKCwWdBG4k7tgFq4UOaJffx+c+zI1oj5jxkPmMmhKpeeYQ/f3AcUiwXirkv93LLua4Z8d+JZpvmhMJG7+hCUIf18kFM9+wzcVj538cDAMNjpdeotOXWx08/kn/s+39R41TCVfwl01offf93vqYvS69k0o1ohHTQkJGGNOSKVx5nwUXXxKg4EVnESKSht99HGls+PjBd/XKdMK4TqXzf/Qhbh/WqPm0AQdkZhwVOxLl1lAhF3GUFOCD3CepMCYVcBhaVHhPD67FgMYsmmBzrugH9G1bKCYAp7o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(26005)(52536014)(66476007)(478600001)(83380400001)(66946007)(66556008)(66446008)(64756008)(76116006)(2906002)(33656002)(71200400001)(5660300002)(4326008)(316002)(186003)(53546011)(7696005)(122000001)(9686003)(55016002)(8676002)(8936002)(54906003)(6916009)(86362001)(38100700002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Xfgk1Sz+o39ZqsYIbj8dFaY32pQivXShutl4o26k6cj+O4l0sF7tpdyvtQ2w?=
 =?us-ascii?Q?KIXu5wr9okjDtEOS3RaVnlJPB9QvFFcqlgJqVA4p0FX9hyYKmMLMT8dr68NF?=
 =?us-ascii?Q?ng75IIQ6oI4gtqHXQQ8V17LgZidR95UUygFOnzzq7TAiZEQSmLRaIiKO9QRJ?=
 =?us-ascii?Q?weIwnURt0OEajVI7+DEOhf+/cZVGqxewufKYGehI0X8GbZ3DvXA1nn7smQHx?=
 =?us-ascii?Q?IJXyQO7A58VxaPY6FXFsslYOLy4ZW2WMeYOEZR4TooePDKctVo9ik3XEGmRN?=
 =?us-ascii?Q?hHr5c+fdAN5QvAbsuwuqKpnogGIXcLYRoNi5qO16iDNV22/BLN7J9fRGuvHN?=
 =?us-ascii?Q?3QlLSLNEooAUF6nflFwhdwIMlW9Xk/JmDNF9MCq3pj52UK1OZt6aCQtH4Tj7?=
 =?us-ascii?Q?BJIEspyZotz/h1jRR+ynv/dU4yDM2XxArvmox+NuVmDded3qzSNkPiU/Dg9t?=
 =?us-ascii?Q?2z3LcKPrwpZGfz6t3nMbs0fjiYv5+meodXY7OMLfr9HXC88mVlZD937GAkq1?=
 =?us-ascii?Q?vvYfpk33QbqwPQd4m4FQN0hs82hV08OkWEgnHyVTc/T9cgJR8AGuuzooNkns?=
 =?us-ascii?Q?9cUkK6ADdFiogPfzPoCbKSYdcPFlaGaWMtlSTqvy3+K2IrJTWehkyE5VniPQ?=
 =?us-ascii?Q?czMhEvM/gIw9xQmVd4nT1MgC8HnyIGimyVQgC5/wEFNjSHMieQ5AfF3LxrWV?=
 =?us-ascii?Q?VRe8fFWDAQ0gm7ZVp5PkIU0xPyKr9wauC73A1YjFl/sXapPit5OgHEyZwvyO?=
 =?us-ascii?Q?HlVeQPytl8TlT7iNFB3quICPcelYidf/Fm3B/HoxsJHqKrjxhjzU2NLUJpbW?=
 =?us-ascii?Q?SM9fEPp0J5MBeJ5re5KKCKgqKacgyU3dJzJEV1v1SR4NHr3N7gZUKm5VsheR?=
 =?us-ascii?Q?rpxPRl3FFzE8VSo1qmwaGeww8ORbQGhOT7T2FbnldRRNgAzymi4doHlxHRcB?=
 =?us-ascii?Q?IqNU4HvUGndvZoM4Gq9qxM74kH93EeVw2GIlJPiQ8V7WCXR5AyeV4CD47Zsa?=
 =?us-ascii?Q?uKTljExDHHYrCCea5F2HfOhuD5TVIHG9Fgcxzf1BOUneeFFR28/rWKSKC+9s?=
 =?us-ascii?Q?yH8JPAtNCDrIRwaGJfwi4tK3DflpSouNmH8qilWYBoiJPwHf9bhXlvQYeaL0?=
 =?us-ascii?Q?MBHtJw+G3GYUr/Ym3nsrW6ffaIRt33lYYvzB6f8LyUdAUbd+6xJrCNytcdep?=
 =?us-ascii?Q?ewma3nlBWnvyE8JcNhXtEsf/iaKkdnk3l9k+Pk6izNLzTFt4hj2CJWoIr9CA?=
 =?us-ascii?Q?RBUynvdyH23NiIWuFJnZezWTNIUT2iufUrrdHvnqSYLdeBnWH+I2sHVtTEsQ?=
 =?us-ascii?Q?v24=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfd00e4-d2fb-4076-d6c6-08d919c3754e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 06:09:12.5451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lA/XKx5SDxgKSlvS4AROP8XufMJSGdeGT5idAFiV7JnexJ1EwDNKGSIMCb3GJFPxV8krp11SzClFXBJX52dAxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3828
X-Proofpoint-GUID: X8B9q2o8QMAP7ZcXzrAUgzukqyuuoof0
X-Proofpoint-ORIG-GUID: X8B9q2o8QMAP7ZcXzrAUgzukqyuuoof0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_03:2021-05-17,2021-05-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Friday, May 14, 2021 4:00 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: Marcin Wojtas <mw@semihalf.com>; netdev@vger.kernel.org
> Subject: [EXT] mvpp2: incorrect max mtu?
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi all,
>=20
> While testing out the 10G speeds on my Macchiatobin platforms, the first
> thing I notice is that they only manage about 1Gbps at a MTU of 1500.
> As expected, this increases when the MTU is increased - a MTU of 9000
> works, and gives a useful performance boost.
>=20
> Then comes the obvious question - what is the maximum MTU.
>=20
> #define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */
>=20
> So, one may assume that 9856 is the maximum. However:
>=20
> # ip li set dev eth0 mtu 9888
> # ip li set dev eth0 mtu 9889
> Error: mtu greater than device maximum.
>=20
> So, the maximum that userspace can set appears to be 9888. If this is set=
,
> then, while running iperf3, we get:
>=20
> mvpp2 f2000000.ethernet eth0: bad rx status 9202e510 (resource error),
> size=3D9888
>=20
> So clearly this is too large, and we should not be allowing userspace to =
set
> this large a MTU.
>=20
> At this point, it seems to be impossible to regain the previous speed of =
the
> interface by lowering the MTU. Here is a MTU of 9000:
>=20
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  1.37 MBytes  11.5 Mbits/sec   40   17.5 KBytes
> [  5]   1.00-2.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes
> [  5]   2.00-3.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   3.00-4.00   sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes
> [  5]   4.00-5.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   5.00-6.00   sec  1.28 MBytes  10.7 Mbits/sec   39   8.74 KBytes
> [  5]   6.00-7.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   7.00-8.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes
> [  5]   8.00-9.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   9.00-10.00  sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  11.9 MBytes  9.99 Mbits/sec  379             sen=
der
> [  5]   0.00-10.00  sec  11.7 MBytes  9.80 Mbits/sec                  rec=
eiver
>=20
> Whereas before the test, it was:
>=20
> [ ID] Interval           Transfer     Bitrate
> [  5]   0.00-1.00   sec   729 MBytes  6.11 Gbits/sec
> [  5]   1.00-2.00   sec   719 MBytes  6.03 Gbits/sec
> [  5]   2.00-3.00   sec   773 MBytes  6.49 Gbits/sec
> [  5]   3.00-4.00   sec   769 MBytes  6.45 Gbits/sec
> [  5]   4.00-5.00   sec   779 MBytes  6.54 Gbits/sec
> [  5]   5.00-6.00   sec   784 MBytes  6.58 Gbits/sec
> [  5]   6.00-7.00   sec   777 MBytes  6.52 Gbits/sec
> [  5]   7.00-8.00   sec   774 MBytes  6.50 Gbits/sec
> [  5]   8.00-9.00   sec   769 MBytes  6.45 Gbits/sec
> [  5]   9.00-10.00  sec   774 MBytes  6.49 Gbits/sec
> [  5]  10.00-10.00  sec  3.07 MBytes  5.37 Gbits/sec
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate
> [  5]   0.00-10.00  sec  7.47 GBytes  6.41 Gbits/sec                  rec=
eiver
>=20
> (this is on the server end of iperf3, the others are the client end, but =
the
> results were pretty very similar to that.)
>=20
> So, clearly something bad has happened to the buffer management as a
> result of raising the MTU so high.
>=20
> As the end which has suffered this issue is the mcbin VM host, I'm not
> currently in a position I can reboot it without cause major disruption to=
 my
> network. However, thoughts on this (and... can others reproduce
> it) would be useful.
>=20
> Thanks.

Look like PPv2 tried scatter frame since it was larger than Jumbo buffer si=
ze and it drained buffer pool(Buffers never released).
Received packet should be less than value set in MVPP2_POOL_BUF_SIZE_REG fo=
r long pool.

Stefan.
=20


