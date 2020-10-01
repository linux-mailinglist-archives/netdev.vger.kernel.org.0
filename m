Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926E527F97E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJAGcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:32:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:3828 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgJAGcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 02:32:36 -0400
IronPort-SDR: telpp1EYDDU4mv+1GhGBixEpc86/ogUVk6w6wZfxGhP79TQJXU9CRV6vXLHXbdjUs8aDxczKfG
 XQyaSZkJlFDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="180800821"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="180800821"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 23:32:35 -0700
IronPort-SDR: ybVgT2kCZ4C0EVVApbMGWOKNPcJbjxF5wtA6uu2p9rwzawGNjtcmCHNo2QFpFk7lsaZjy6qTsl
 m2WZpMSnPidw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="514566608"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 30 Sep 2020 23:32:34 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 30 Sep 2020 23:32:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 30 Sep 2020 23:32:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 30 Sep 2020 23:32:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FktHdc9GcdeM/AO2i7SJRBp1SKPVuKKZtvCcqN6RHLO7tm3fO38RiW3MgVK9TdNrS1iPafcnC4fJmgutW7LJaTBz4Wu55f+xbHM2GE6DDKlSFbu/XjcExZym0fsU+6jO9Ch+UNrUyGiT18l3Q8/UziQxyI2U1gaPqY7H63n6Nky2tMW40+cChzWGWwsMrvGv68pUGOJXfQExFiju6i1lcALefI2sUJ0ZJkYGc44dECP1MB9uufPdH8+e9Qq98PZ5zpuHZJa8ZTCec5+FWwWa+Sg/lEOjG82JoU01h6PXo/6fqiFAPo2Da0yAQOeG6Z330u93cAyVYluB47frO7QMrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNewq5SxgWIR7NBTNSnW+uKF/BEeJsoig/q9aG/RiaM=;
 b=JYeFmDvhykPPBqhUmeFxSvEpB1upc7GQUh8ox4bminSoImEw3Jy7pIt8VGaXemw1VrfcPEP3/MYM50/5PB9N/K7frHYamCkgKf5Q48QOlDz868E/I+NTHfl6Hz01VkEOTBc7a0hNPtUWJggRCFSUqLeFpaBafjhNN33DQm4Ni05eGbkZOXVHoqWnoRa44ho8BHn1nS9DbEbc/vsad+diQWZAzm1r1n3GrSuJcC8huIHSId3eAFXVqg5EThElv+Yod+BWvArw99NV3xzrlKYQ6KIDPUEZrW1TIca1qlJWzXZ+sfNFb6bLbTIvKQiTLrLop7jBSuNkeI5yx2SRrlFpnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNewq5SxgWIR7NBTNSnW+uKF/BEeJsoig/q9aG/RiaM=;
 b=mxEoZzYDXFIf/gjgIttnkh9hSKd39rmw15RrUgWorXwy8FQ95sZRFNb7aGHfZzoAOdR3bK94nWoDCwV2atZpsDKPZKTfmBZQxFBFhr9pdRvnnB3qvS4EBJeL3dxSEU62AI0ghH9bdqbjeoOyF+673GQGiPY8junnPS/zeeV4Cdg=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4564.namprd11.prod.outlook.com (2603:10b6:5:2a0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.36; Thu, 1 Oct 2020 06:32:32 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::8c79:e56f:7f8b:ebe4]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::8c79:e56f:7f8b:ebe4%7]) with mapi id 15.20.3412.028; Thu, 1 Oct 2020
 06:32:32 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Tong Zhang <ztong0001@gmail.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed
 rx_desc
Thread-Topic: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed
 rx_desc
Thread-Index: AQHWhfynZPHLUfowgUSbCO3qc22yBamCbJwg
Date:   Thu, 1 Oct 2020 06:32:32 +0000
Message-ID: <DM6PR11MB2890535C0E060AEE49A34D2BBC300@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200908162231.4592-1-ztong0001@gmail.com>
In-Reply-To: <20200908162231.4592-1-ztong0001@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.130.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4231e0fa-393a-4369-de4e-08d865d3c74c
x-ms-traffictypediagnostic: DM6PR11MB4564:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB456469108928D700D4100E67BC300@DM6PR11MB4564.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kOVvaWMmO+Twy5CAnm/Hx0XFalSckc2XxzXXOYRymVEQfa1d1/raV7SEEAp9Un+ALeszzR/eSkipAqtPpeybLbCCG67ivS3dM78qGYBScUpt1Qio93xe/fkPWilCf5ppNHG5XfLhITEoRa8hg8MkaKkaSYOxA1hZnNTUB38y4l7H1JXDuwzAUevl3hYa7az3cbryWSh74bwZVMEyUwAotNq59/sD6MgWcL7Q4tBqmYf4ZCym5a8wRAEb8Lw1i9BcsXQnVitR3/iGIydDaTAFmf5tzDEQ1vzP78hQaMZVhtl3gE878djOD0/ddNX25sZz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(86362001)(26005)(2906002)(186003)(33656002)(52536014)(76116006)(6506007)(66946007)(53546011)(7696005)(66556008)(66446008)(64756008)(66476007)(8676002)(316002)(71200400001)(8936002)(83380400001)(110136005)(478600001)(5660300002)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7PmH+je3I+/4Epng1b8IcQxU9ESHoH3S6ryyDpdXH4EGsMmk5NA5Jgy5ZD1PsWn4LAK71sA5+S9Lk3JNzqJALecyfs4XtKhqMUUsOrnB7R+cIyFsv4esdUSEoN+y/S86xdNjxLqDcerkcJmi5h0IrPVFfeMDygBx4up+qqfGjkr4xNnll4WpQVA98gZMsCsdSPp0ShTriq9MXmEQHjUZEIx1ZdzMzOOCmY/oMsFtpm9exdOdj/Rt8+NYnU9kNuFIXTMEsbhoDOjO1aEYsYZfUJAQV83owNhlizklYls3coWfmSHcs6pbxtXpqr2uZHAq7uzrNwIMbTUqYpRoSLMpfZef4gyEofXJ/9dyK07nKYxpe2DXQGix5eZNso4r2F/aikOc20hYUosJmfqiA02mAf0Ecrxt5kjLnUPdlwnBO8LhCeJYRFVI85gviPoZTqeGbvAuV1nYdZDmZSn6FJXV5vl3a2Wjyxhb90Jw01aIkwoG1RKYhywgiCH1Ayb0UBoRsRoTkU+xjzcJgbJRE2pX+fLxMJMm4C824vmsJPrr7auHBuEoBoLImDMNIp4m5BikU+5t7dufJD5zE3tnLkcloyURjfAgiDLqMA0FYkXrwktOcw6uHoTHCpq9P3Wazx/uxYNs0vgBBaO2WHztUbmcOQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4231e0fa-393a-4369-de4e-08d865d3c74c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 06:32:32.8054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nilOcO1gSj8EWVrZazk4XSAaInVcxuCFb1UIeaK39a0alCU3KNemc9iXWKRpKwqaPTDfXskPKxk4FHttEaOenQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4564
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of T=
ong
> Zhang
> Sent: Tuesday, September 8, 2020 9:23 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; intel-wired-
> lan@lists.osuosl.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.or=
g
> Cc: ztong0001@gmail.com
> Subject: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed rx_de=
sc
>=20
> length may be corrupted in rx_desc and lead to panic, so check the
> sanity before passing it to skb_put
>=20
> [  167.667701] skbuff: skb_over_panic: text:ffffffffb1e32cc1 len:60224
> put:60224 head:ffff888055ac5000 data:ffff888055ac5040 tail:0xeb80 end:0x6=
c0
> dev:e
> th0
> [  167.668429] ------------[ cut here ]------------
> [  167.668661] kernel BUG at net/core/skbuff.c:109!
> [  167.668910] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [  167.669220] CPU: 1 PID: 170 Comm: sd-resolve Tainted: G        W      =
   5.8.0+
> #1
> [  167.670161] RIP: 0010:skb_panic+0xc4/0xc6
> [  167.670363] Code: 89 f0 48 c7 c7 60 f2 de b2 55 48 8b 74 24 18 4d 89 f=
9 56 48
> 8b 54 24 18 4c 89 e6 52 48 8b 44 24 18 4c 89 ea 50 e8 31 c5 2a ff <0f>
> 0b 4c 8b 64 24 18 e8 f1 b4 48 ff 48 c7 c1 00 fc de b2 44 89 ee
> [  167.671272] RSP: 0018:ffff88806d109c68 EFLAGS: 00010286
> [  167.671527] RAX: 000000000000008c RBX: ffff888065e9af40 RCX:
> 0000000000000000
> [  167.671878] RDX: 1ffff1100da24c91 RSI: 0000000000000008 RDI:
> ffffed100da21380
> [  167.672227] RBP: ffff88806bde4000 R08: 000000000000008c R09:
> ffffed100da25cfb
> [  167.672583] R10: ffff88806d12e7d7 R11: ffffed100da25cfa R12:
> ffffffffb2defc40
> [  167.672931] R13: ffffffffb1e32cc1 R14: 000000000000eb40 R15:
> ffff888055ac5000
> [  167.673286] FS:  00007fc5f5375700(0000) GS:ffff88806d100000(0000)
> knlGS:0000000000000000
> [  167.673681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  167.673973] CR2: 0000000000cb3008 CR3: 0000000063d36000 CR4:
> 00000000000006e0
> [  167.674330] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  167.674677] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  167.675035] Call Trace:
> [  167.675168]  <IRQ>
> [  167.675315]  ? e1000_clean_rx_irq+0x311/0x630
> [  167.687459]  skb_put.cold+0x1f/0x1f
> [  167.687637]  e1000_clean_rx_irq+0x311/0x630
> [  167.687852]  e1000e_poll+0x19a/0x4d0
> [  167.688038]  ? e1000_watchdog_task+0x9d0/0x9d0
> [  167.688262]  ? credit_entropy_bits.constprop.0+0x6f/0x1c0
> [  167.688527]  net_rx_action+0x26e/0x650
>=20
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

I was not able to trigger the panic prior to the patch, so just a regressio=
n check on several e1000 adapters.

