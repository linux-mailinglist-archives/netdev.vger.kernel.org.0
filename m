Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BF28E00B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgJNLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:52:24 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:16385
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbgJNLwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 07:52:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDoo0l1yPEKMdqBZBarHotoXnAW+46J/ef95Ed6990p3yjk4muXrADDfano/69Dvz+MooMUF03g4iDlue9CzKkj4VzaptkdT4QKJYmwwYDvirmdkc5awgy+ee60ZydTBxc4GBW3b5K5vwh1sxMAKTFMIlxCfB6g3orr3fW6golrWASslxBzdhRzv6b5RWK7j6DM1pcUq7O0UlRH3J2nRV48dO1V962TM3HfU9Xh8Ru9feM81hSGQUEnPgYWiLIvx/iwB3ze1UTfO8yiy+oiVJeEyCQZy+uwwqgQOf08pDcFRxQwO9v4OZLPy4JBrB0jBBx3CFv2GxVOM7i2xteg6uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+IPhP2Kmrei5f/LsFM+HorqoRrOj/FzsF13ggy24FU=;
 b=Ene/I6oVQa2VOAGGs+aaeu3CBNJFJVZNHE6IKWtO2D0LayPwgeLGAsv/WPUh5RtqBjgHTEIwYx4mGwmnb1l5BmxGI6B1/nv8YwGYc4LybOkRCu558UpzZDyElU6WHJczVu0/AEJijMNd8QTLyaoaK32WCt4RJZb2fYE9x/SSl6pzl0YaXa1vniZFIJjR1SlUzlc8DhbMvPLEvCL0zedPn3DBbRLIO+3E7fhk6SxLKB3bBgx1iCMBoF59r2zlS/ehMHd87AOjZbqvS9mCSnIE0hOQWDIHS05iZ4kEOL7Dcn30DO5Hd/f3eVlgqLXch1HEh4K6hsJSHRoL6th3+VsR1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+IPhP2Kmrei5f/LsFM+HorqoRrOj/FzsF13ggy24FU=;
 b=gXFhIwg/2fMES5BojVs/UXMH197a1ZK02Coi3SMSuhS2OfxsqWURhKEcJ/850QCT9AApTNnhw1XqFM3Us90ORIPxRkAqzkhLh42xgUdqmox2NG7sLqSbNFXmYKuUf33qHpsSeyWh6vqclzCet+Qqgwfc8xpMJFSgB+4TIeNLfU8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2893.namprd11.prod.outlook.com (2603:10b6:805:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 14 Oct
 2020 11:52:21 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.031; Wed, 14 Oct 2020
 11:52:21 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
Date:   Wed, 14 Oct 2020 13:52:15 +0200
Message-ID: <2628294.9EgBEFZmRI@pc-42>
Organization: Silicon Labs
In-Reply-To: <20201013201156.g27gynu5bhvaubul@pali>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com> <20201012104648.985256-8-Jerome.Pouiller@silabs.com> <20201013201156.g27gynu5bhvaubul@pali>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM5PR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:4:ae::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM5PR07CA0100.namprd07.prod.outlook.com (2603:10b6:4:ae::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Wed, 14 Oct 2020 11:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 836a45e2-d48e-4431-2e80-08d870379b52
X-MS-TrafficTypeDiagnostic: SN6PR11MB2893:
X-Microsoft-Antispam-PRVS: <SN6PR11MB2893755A4059BC7942E7305D93050@SN6PR11MB2893.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FiIC40Fy6cQHK1pF8DlSw0Lot9isxPUyhqp3ltJipnRP40YjH155KPGZ8fQn/y2Gzm687xL1HDX3RdbjrgAJUcSHvj/JoXvOh7JeA4ob8L7Y219hPYO6A+LGJ8dFEy+Sq12AzM9VDWSJl+pKBE2UqugR4v+8ylfxK/6SFP5ghuy1mx6fOeDt/D2Mx9kk5OCeFz4Ml/P4CJBQe7o9XMbNWTUlA24Dutvknqv2pPNtrpwcsF6JE7oe0il12OllqGSu16yH11QjAibsu3AJCsMronJQ2XgIQcWnyAbWaqQSmFRsc+GufboVNv80YiKxEemIWAbV3kOJfaaWqGskL7iQjx04xzgtDauo9PDipKelMol749wgRv56AMGTQjPcQSty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(136003)(376002)(346002)(396003)(66556008)(66476007)(54906003)(8676002)(316002)(6506007)(6486002)(9686003)(66574015)(6512007)(6916009)(5660300002)(7416002)(8936002)(4326008)(86362001)(478600001)(52116002)(2906002)(66946007)(26005)(186003)(956004)(33716001)(36916002)(83380400001)(16526019)(6666004)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2445WES+e9wE0ygrPmUVFANfPe56hqfhoNSeiwmMq3P2dK32Cs34P9LBB1T5VtudGsxb4Zfb+3GWPogBxvUpBfd7980ULqOBNdHOA6ytEWCovdPbL9h/MO4bxi1LU3xQFnU5VcCoLAu8HWrdLyZkgAACYxHW9Nit2AjZDrPgpQcc25wTl7AESmQugWrejGWJVPSXmlDxy5fY1xPQ1LrAclIv83DZJ9zWIhdtQyEwenTl0ySjnU4Cjyw0e39xk3KRBsTs7U+witG0bvPkHhxYfwxqqQJxns2t+IAPs+soqwE1p1xfWsmQLt2iAUwexjPa9kVeQn+0fDO0bR9yb7ePAsDV8eSRsmDkGm/xbDmcgAhRrIqhOfHdHcRnuZ2o7W8nXteRuBfV9NrHXwd4FOuwwuKoBfHAybVXLtUJOYIFsAyOsZum7Sh5ahhdRtcF/lfjZ/Ek0Ze8IUvQzyx4eyx9GrTZsG81tgCpb3UbUqqH5c2A0GXnGDJvkKp/sXF3MBt2ZK1VmMyVZWkvopTDwm4SDOewoE38OHpddN7hHLXUVaw2TAi0Pki1N3MyL6mZrvaz/EU6wmEVX32Ifdthd+aRlC0B8CnrLA3P3m1DsgwfNd5ahsuEx58l98jWvFnsgjWh+j1DR9dAjoLhDSWl9Mc7yA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836a45e2-d48e-4431-2e80-08d870379b52
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 11:52:20.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1bpE0MFkrQ6bQMUGQXiTpoQCrIrD2UITrZf1Q24nhcIZkupPan2i8C0R1FMkeQo/vr4e4cN9VV5wKjqUoxaKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2893
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pali,

On Tuesday 13 October 2020 22:11:56 CEST Pali Roh=E1r wrote:
> Hello!
>=20
> On Monday 12 October 2020 12:46:32 Jerome Pouiller wrote:
> > +#define SDIO_VENDOR_ID_SILABS        0x0000
> > +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
> > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200)=
 },
>=20
> Please move ids into common include file include/linux/mmc/sdio_ids.h
> where are all SDIO ids. Now all drivers have ids defined in that file.
>=20
> > +     // FIXME: ignore VID/PID and only rely on device tree
> > +     // { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },
>=20
> What is the reason for ignoring vendor and device ids?

The device has a particularity, its VID/PID is 0000:1000 (as you can see
above). This value is weird. The risk of collision with another device is
high.

So, maybe the device should be probed only if it appears in the DT. Since
WF200 targets embedded platforms, I don't think it is a problem to rely on
DT. You will find another FIXME further in the code about that:

+               dev_warn(&func->dev,
+                        "device is not declared in DT, features will be li=
mited\n");
+               // FIXME: ignore VID/PID and only rely on device tree
+               // return -ENODEV;

However, it wouldn't be usual way to manage SDIO devices (and it is the
reason why the code is commented out).

Anyway, if we choose to rely on the DT, should we also check the VID/PID?

Personally, I am in favor to probe the device only if VID/PID match and if
a DT node is found, even if it is not the usual way.

--=20
J=E9r=F4me Pouiller


