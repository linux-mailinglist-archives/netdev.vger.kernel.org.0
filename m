Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8957358DA4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhDHToi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:44:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:4296 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231940AbhDHTof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 15:44:35 -0400
IronPort-SDR: 2vgnjl8H21/ZLVarZ72kiSFVdszqIBfX9rUqhIX+CgKwxf++PPmPljbDRiyb0kdU539nWyW2hj
 Z1fQAQTxfH8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="193733348"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="193733348"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 12:44:12 -0700
IronPort-SDR: FnT+7ce3AwfNU+cdj375B4lJNkoDlPD1rSTT+9Sr6uZ73kkGWZWg0Wud9s4tPy7ra58VTxp7tP
 x0LLAjfaM84Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="381835921"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Apr 2021 12:44:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 12:44:11 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 12:44:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 8 Apr 2021 12:44:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 8 Apr 2021 12:44:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmHl0SW+2RjvXeX/pBL8ja0PQpsFt97PQXFGoGJTwK9eTGRwY7g6FB3oSfAGXLC1vxHWv+vDpnbZV2JYR2JOqDfc1RXPdTMyEgu19B04RqKx8uxxgPo+uyqRUtxVHio3l5NsGszH82oh9OBTCn7mBxm30AwVoBxGqJayWFRYeShM+Iw6NP6rZP+O8GeLcWhDENnQyeOWEtZIZ1f65BZYVdyE7FZxPnFgBCObBtCt+sWYAynHevJrOnCWIC3svdlODCanPSGAN/GrmFm8ogXj45sRTrn1RPiWVBcyIwke2lyiGfWtBkYK5Yv71SdIv3bcE0kNHK9gfGfNUtbNfJx2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oy7+kdTRPUgtk87clR61U+qW1xmE8c4d8yk8fiCl4uc=;
 b=a57nzdWutSjreXNEwh1Pk/MDzmCs3x/38DNddoZ2/hKHbwzzpNXyR9C9FUBFx7m4kc/zHBS1+nlTqLTh7eX8K9Ih13a2PRi0p/8OqDBShoJMpoMaHDv68/apyp5CMJ+YpwQh2SANSm7zvztDd40R8Ns9rUsZm5Gld3Hmt2SD0yY+gTi0+eEO/nVpPp6fPync2zg1C6XzHIu5oEm7Va1xKDRnH2KPDoYRDe3IPJVy5fiO12vyxwH3zY/s5RxM2Rc2coxvq4p9VO9u+cZ9tn2Gdq1ZDVHQlJdmpMwy5iwq2vzri2Do5U27aZqbAsxmpMj2kqlLZVYuqHzsbBT5weMxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oy7+kdTRPUgtk87clR61U+qW1xmE8c4d8yk8fiCl4uc=;
 b=rPUl+hDsaXdjEno+bM260UJhhufSLCoZ0pJygrI50TtXZ8E0jSj/NI7pJGi3CmpXo+sDg05z00ZbA3Fa0jOCbbB6Wa6g7nfL3rgQDCxwgsLeLUG/TKyM6odz5rwhsLrnwg9c5QZ+l9Ne3w8HOl++Zr745JrNeB+GwF7iIADUEhE=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 19:44:08 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366%3]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 19:44:08 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][next] ice: Fix potential infinite loop
 when using u8 loop counter
Thread-Topic: [Intel-wired-lan] [PATCH][next] ice: Fix potential infinite loop
 when using u8 loop counter
Thread-Index: AQHXJjy7luSy7BPj4kuzhiECHnJ6T6qrEnQg
Date:   Thu, 8 Apr 2021 19:44:08 +0000
Message-ID: <CO1PR11MB51053F26FD4F24B78969B0F3FA749@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210331144628.1423252-1-colin.king@canonical.com>
In-Reply-To: <20210331144628.1423252-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ff5107a-80c4-48aa-cb7b-08d8fac6ad27
x-ms-traffictypediagnostic: CO1PR11MB5012:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5012027387E279C8A336ECB7FA749@CO1PR11MB5012.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eq3Bfw1WISW/cVzWMYw3xncX/qHUsvdMw0rDPRWpHDoU6cjy2jafORhCSzda+OJMmq39DVoCjDICoGx8l/+xGlX3eGM3uQGO5kgKABjjalEA3dLZUQWcSXuYrbMIZBAUCAqVhij2vHtW27F4hrF19m5RYUN/28l+RkyWQR0v09Ozw0bB/D/kWzp5N4EJZ6vveQPL99nKyOBzpLLfuJ2CEvqkGPIZ9k999H2c8o7kdo7Ji53Z5kAc/FLa3J8cyIEdzC15yI8s3k5Ph49kDuERiqPGAHJxk3md46HNjLI3uDlA+H9O3DVb3CtnrDak+7TdKLrLpjqXTm+KV3DJN06U5N4CH+Fs4H2MbU6gzEBHypk7FkFxFq01Jl9cuVCvjTsMJs2Vdcx69VefX6fGl3nweh24MMEl0Ows4PxwyZFVCOF3tLOKsT7vHfG8geRuA9E/zsrA+jiaZrvxZzt56c3nZ5V52jAxcgh6/nXNOa7iKl5BhWTWg1M0baNRzChkyNNkWtkLFTx/pidR9g5OTOafIeRdWsGDLjTwiNlKYiVEvc1HYRr8Rlf0VxZ3tcUFA0tBYRWe28v2JoKj/YrhGpa7OSjELqLFHWIvk6x9BKsfd+tKNA11+dYTy/jQSiz1PnHthkJ/PEtPGzUHa5FSpjfJosH70EGUMpAzRuQyJMDF4nw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39850400004)(346002)(396003)(366004)(54906003)(53546011)(52536014)(186003)(71200400001)(86362001)(76116006)(5660300002)(4326008)(66556008)(6506007)(478600001)(8676002)(7696005)(316002)(55016002)(110136005)(9686003)(66446008)(8936002)(66946007)(66476007)(38100700001)(921005)(2906002)(33656002)(26005)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?a4VBFhIkk8ctSP5G1lWff8YNTX7h53nMA5L1Z+MLTrVjnkaSC284FeDpUH84?=
 =?us-ascii?Q?c7TVI+5GeRh+oBf2NP5kP61bvuBonccpaKYh8MfZJbSkyEZugpXRaT9A9HMw?=
 =?us-ascii?Q?K609KHilvAlr0TDKWqK/FttSz9dGEQtws8TA9d4n8wTXnmyGXY/5rlzW25IB?=
 =?us-ascii?Q?es3CKHk+qGcyLbe1DP4zlLJziR9KaDfqRIB2WL3kFPpXhg3vkx2BEiiuAbv0?=
 =?us-ascii?Q?uLTHLteWma2WuXOxkJkQME7jdPcWgJJarmUUsqb7MyV1U1UR5I2kuwTHAXBX?=
 =?us-ascii?Q?kUeNxKtTgwFAllHqZLRBgWG7BUptaYBtZq19l1eP8K2TQed7YUJYNwwEmwXu?=
 =?us-ascii?Q?5JiZXZRsAJypzIllXzBRA5dskd3A+2rmFQelz7riuxgCoWpOrFs3vz2lZ37S?=
 =?us-ascii?Q?tOoKrbsC4nY7IuBRIcKx3aAUQU5mBk4MMxFqlrgefXY5y9pdFtR/Vrsb8CiO?=
 =?us-ascii?Q?2culsJRyWAPujLwcsS9L+1aqlMlraQYMF//VTGfEIzOYqLrIoVpOh0uWHTyi?=
 =?us-ascii?Q?YKBXFoLAQx8EKfUra+RWeVLT/J/KUJx5a9WoIkYRwmfHalXM4niMwFIv/lLh?=
 =?us-ascii?Q?0o7yaH1mVTPp0Qi7jGlDyAMSo01qaUFCB8qCsc4CaJ8xiuNqs2QY/2npQWSd?=
 =?us-ascii?Q?CVK/xl1zATPK+CV6wNLqANY+nYsIZ57+zG/Ebr5IlNcx+YAgriGDIRa+6aNP?=
 =?us-ascii?Q?pLMvjK/DGmBZzsUkxbTswJioVGkMmLhZc0Axh4eWyaCbTR8mG7qGhYSiFSZ6?=
 =?us-ascii?Q?zFfx4GabCWMXvMNmRmFL1DCwf7NC8LMAK5vuHnex8E4+4XX86fj/09f/7voN?=
 =?us-ascii?Q?HJl+hbevaaAdckBYzcnl/4J75XOWm7AyTfPfY3iKGfsQV/+JwPDidSUebwGt?=
 =?us-ascii?Q?gA8Awwo9kqyPUtBkNTJos5hBXrLM8MdY3gaCsv4QtTDQnRDD6pOwFz7JYZ7n?=
 =?us-ascii?Q?qg+tQanqdO1G1dXosOveNzRgZLYAtbT2mi8lhW2yPB/bIMJOPuxHL9ahM1MV?=
 =?us-ascii?Q?NRGwml0eB8mcWC8OajbE7RUTlu6062VD5mftDYF4WGPVsWVQ+rj6NX5I3WCY?=
 =?us-ascii?Q?azeWeZByPHb7/IEBUDtAVQBuiYQ63ypZl2YAzi500txiPxlTddv2Qz0QVrut?=
 =?us-ascii?Q?y8e6aGTQ9AL0QWBVHgkzfO2Qmtvm9f48FXYY9O6f6AUlpR96KN73DR2hFkvO?=
 =?us-ascii?Q?fsbykqP9sIXF4J0Lw4wcYvsine/7A9RB4lwRUgxhBreR7/sfQl/ZguXVneuz?=
 =?us-ascii?Q?FjpuOOKLVBNyHfefLselZA1ldPvdf73q9nqnj0cmy0ffbTa98Ner+q7BP+eS?=
 =?us-ascii?Q?hjmzG0IF4sbrxrjLzrkJC64K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff5107a-80c4-48aa-cb7b-08d8fac6ad27
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 19:44:08.7106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gp/iOtBSaZEli3OdK9srSlFnfJqrZb4EoFIbS7KSfSAOqf68JY/DiFV8tObdqkqmX5rpUCkqySX/GExEkBXSO8TPQBzo3YS/sUKuHUPyCuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Colin King
> Sent: Wednesday, March 31, 2021 7:46 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S . Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Cao, Chinh T <chinh.t.cao@intel.com>;
> intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][next] ice: Fix potential infinite loop=
 when
> using u8 loop counter
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> A for-loop is using a u8 loop counter that is being compared to a u32
> cmp_dcbcfg->numapp to check for the end of the loop. If cmp_dcbcfg-
> >numapp is larger than 255 then the counter j will wrap around to zero an=
d
> hence an infinite loop occurs. Fix this by making counter j the same type=
 as
> cmp_dcbcfg->numapp.
>=20
> Addresses-Coverity: ("Infinite loop")
> Fixes: aeac8ce864d9 ("ice: Recognize 860 as iSCSI port in CEE mode")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_dcb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> A Contingent Worker a=
t Intel


