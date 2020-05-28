Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C519C1E6FA0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437337AbgE1WyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:54:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:35381 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437209AbgE1Wx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:53:59 -0400
IronPort-SDR: cEUg/GHiuTfzrRniEBNOGl4fcTeuU7LQG3R6Hh6/Pnlvq4aR9TwbZIPJh9lALDqVo44/ZOfRey
 6xVV6UbfmG2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 15:53:49 -0700
IronPort-SDR: WI8/FImoPuPOu9UqSoy3eTh5DmE4Hx8U38DDPmqneHMd8JZ9Fo6zwOmOoubX5KiWihQaNI+sDQ
 B+j4OnPbZ3kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="285321993"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga002.jf.intel.com with ESMTP; 28 May 2020 15:53:49 -0700
Received: from orsmsx124.amr.corp.intel.com (10.22.240.120) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 May 2020 15:53:48 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX124.amr.corp.intel.com (10.22.240.120) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 May 2020 15:53:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 May 2020 15:53:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDwJ82cXGJUab+wvNVLrMy0NwqRusQlj1dV+xz1TQkIaYBC+Ne+43bq/CLHKcgjyvf3XtsKlgx9AZqCpBOJ2wnnNXTNzQwmQlPSCokJhORXpMCXSzyD5H9GRPgn5eFY7bACVIEBit1pbEgJw/27wN2vfaITgEnwy3EwYS8gY+oJPoMkx0CCujsSzJtbRxxgLX8NeBtr5bno0uhQvKGRqrmAFlR3aGlEpbDcHhFDfvx0enEMEqgty8ljYthVUAwjZY5Zos2rT3IzM3nW7LtvxCP6s1/vxXg9TR953HagCghkG8ikswhtb7lHZ3cQmzZ2NIMMRvmo1t9tMYaVWIhtXWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggyraaRnHQ5vkiVaHMg/5EVY7ubp2iKFju3fF56sDbc=;
 b=bsgBsxaX8B5e1YXc9RWgvGVFVaDXcKYNdXM0PRe+n1QMtKL360pHelzuTkARLmxqzzXvPUHusOkJqoUDlJH4jnEUVGO1XK5uNilDwGj9EsEmq/xUZx/jv1473FKwjWopAWxBgG44k3ZLosRZXQl00HLjuNNIBDaFCAELM1IZzd2RANdFuRlTcPQprzRnlIXAb1fWWrNmguxrq9bnPB3YCbgoYATaPbswikg5yXwqlpgxudj6G88fRT3o3QoBjFHIaortL09FWhi6LgJJdd0EVaL+FRNoMOXzTkilF2RYs+Ks28KLIo22Q6qEpNK1NzY60Wa18qWG/Sj0aftV5aX32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggyraaRnHQ5vkiVaHMg/5EVY7ubp2iKFju3fF56sDbc=;
 b=BKFvyh6nIUj3xD4R620/kuP8zEo5oC6Xu/eGwB/HSILgT3atkEXE913O8pp+e2mbioEUmHNanbv0dTKXi14JMm3nIe++qqnhIJHVFoiU81073bdLtPAxPHcX34WsN0OBAnjcoKFnTM4uFp0mmrLfQESDh51ektk1SyFogD97kZI=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4441.namprd11.prod.outlook.com (2603:10b6:5:200::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23; Thu, 28 May 2020 22:53:47 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 22:53:47 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Hari <harichandrakanthan@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] Fix typo in the comment
Thread-Topic: [PATCH] Fix typo in the comment
Thread-Index: AQHWMCQvol+QjbGZgEqpcODXeVg29Ki+JWVQ
Date:   Thu, 28 May 2020 22:53:46 +0000
Message-ID: <DM6PR11MB2890C40D909D3546457CD2DBBC8E0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200522103024.9697-1-harichandrakanthan@gmail.com>
In-Reply-To: <20200522103024.9697-1-harichandrakanthan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 643b0cec-af69-4b08-8e0c-08d80359fb10
x-ms-traffictypediagnostic: DM6PR11MB4441:
x-microsoft-antispam-prvs: <DM6PR11MB4441E506B89A67BC10024F36BC8E0@DM6PR11MB4441.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EaQ0CKiA5H7UVPsvRjkgoFHDcTTg5R+sK4pKd15ErD5R4dFS+Gu1WqLcFhg0HigbldvhXosBiMvkKADrwvU3Mx43epWu+JHkYpMPynPnl4hAmDVRs0uk+EIbo9bqqNkuWAKZwK+rDBKmrL8dti76WhhnewmV8FJ7dY11wMNQ28NttcxFfDAyVhkHhEVLtDPGeX18dPtyv2Knha/fb6adq+OVx+cx01ZflNCsq9+A+KFCW4Nr//ikmMqWkIroJjVDXEvT7h/keeYFUBQrigy5OBL0nE5Ctns+LTDERL79aFJFjUwB9D4tE9JStlBb2tiW/hVmrMSd3GTIoXDrdP8ZiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(66476007)(7696005)(53546011)(8676002)(4326008)(9686003)(66446008)(83380400001)(6506007)(52536014)(66556008)(86362001)(64756008)(33656002)(110136005)(76116006)(66946007)(4744005)(71200400001)(478600001)(54906003)(26005)(8936002)(5660300002)(316002)(186003)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: V8rn0TUkIGu46BQ2OxQHgBewHnTwnxz3Muv+Y87tTpkjZTAD2CdOAYYC6B4sGwpsRvnncEGQryKdbt7fStweMh2NKKvIuBbTzyU9ZuBtZIfioNK92GzimzZsIcEVMoS57l7XFqMkjSwTlxbwR2GVU4yw9WztgDl2FJmzTvUB0R1CUoiwcdyG3BGD5Lyvy+M7rvJfu/odIBhOPKkTByO18iKZBN9fFZj/LVYuv7YZ0vpD6H1q6XiKReXqMNY+7qzgayCfYRVEZrlKa08lfITcYMilfv1ry3FVoO3LB0N9KjQYLgU4GGXqxD9EN52c5s8WEA64AFsufOayWlq+9r76bpNJrTK2kUgWxSEeQq60+LB09sxpyeGP1z+cx9F/M139aM0in0opiFG6HxCj76PfDCzF0M+xm4SCB0NrO8I1yGuf5AmuTO+YsleHOgB67pKQWtICyqYFNwPOwZe7cv/60bwaeIVT5qucBFi1M3+q1SM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 643b0cec-af69-4b08-8e0c-08d80359fb10
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 22:53:47.0534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6NuQLtByT/qz02OkqYaRBSEiCFtxPBut1q75+pbObqFftbDFlZijDC9LOonUeTygHBjUCm5x6crMxV4JZ36pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4441
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Hari <harichandrakanthan@gmail.com>
> Sent: Friday, May 22, 2020 3:30 AM
> To: davem@davemloft.net; kuba@kernel.org
> Cc: Hari <harichandrakanthan@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [PATCH] Fix typo in the comment
>=20
> Continuous Double "the" in a comment. Changed it to single "the"
>=20
> Signed-off-by: Hari <harichandrakanthan@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
