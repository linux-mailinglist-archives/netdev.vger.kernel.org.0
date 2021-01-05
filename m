Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A082EA745
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbhAEJ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:26:17 -0500
Received: from mga17.intel.com ([192.55.52.151]:51063 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbhAEJ0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 04:26:14 -0500
IronPort-SDR: SkHVsz57ov7p7pD4agS65koVxAnN0ZNRMi/k6FINPCF/0nE5v7u30voLgntK1dXkyehU4espuB
 U3fq17NoAHPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="156863244"
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="156863244"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 01:25:10 -0800
IronPort-SDR: Pl8oQ3hM5bRdh7q1cTzekIo0rtCiGfdaQGg95udW8JwXyeBTJiXeyvFITPQn8g32/HbxJyJ3uO
 Y5F6AoASrpoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="386992109"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 05 Jan 2021 01:25:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 5 Jan 2021 01:25:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 5 Jan 2021 01:25:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 5 Jan 2021 01:25:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLgp2LZYWSM6N+k1n5JLVMngBic3AMpVFxp7nOqGchaXuX98wi6zBrv6tT6kQgijnZKvT2Pq1BwAN4hapekZIB7RFFZX5fBqrPLCcKoAQpGpX/OBvvoWq4u1Y9dMqDVXcgeQTHkSNlhnuTOKZViEW5eRd2/tVEnTr3HycXn9DPIKJIj3eusDm8RQ+TFWhAv/y+4dGIkzG/HHovY6qAe8lQDpiveGLkjd8Dw/f4XfxpFNEw++WXvDpKzjqKaB5R/izMpY36G7B9va1OV+APWwiOwmB1ftLz/WdE74/L75bA9B3ImDKNlR3pdqdhvetoESIf3zaxlmQU2lUMS8oZGUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feewExTWn9q5wHxQM/JP7hQuUo55ZMZdr4TIeROMeJs=;
 b=J83w2OqFxUDAO++BMHny739v+eJsHoTY+HeB1W40s/yKLKl4a8DyScU4l4wdfnCTk6gQyIzVr/+QJ9qC0XSVle1E1JrvmBn6TpbV91Luytzo2J7efq+356mIaMry9gGe7qCQiuxqQzYn4DXbIuWga6n+PLVu2Dec0V4CvUMoe77HJ+nxgxZsTKw1CRGbTOh6R1jEc7M/+hPus4bOwGFAqeeNj1bNcNeqVEkT32u6oYnh4j1xn9KEK4tHnTYDG6h72B/P+MOyQyMx/+fclT7XzdDVN3LI6EtWGljoW95RgGydY1il9laUAXVAZ2iWYkyraj6eKpw8HU7VSEKGRUwPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feewExTWn9q5wHxQM/JP7hQuUo55ZMZdr4TIeROMeJs=;
 b=cu3AHrlfVuip6X0MFLK012B7nZAblLgU6bi8O+OYPb8fW16ORggrrIoV+cPGlphRTjDrdSX3vNOJTT2j5nZoy1WX2Gj3H67a0JXShAN1sR9kJd4BovctkIcQ7At17ljH0urJCs8YQ57TIp8AXHfM2TOsnQ1UZQmL8Q8i6k/68cg=
Received: from BN7PR11MB2610.namprd11.prod.outlook.com (2603:10b6:406:ab::31)
 by BN8PR11MB3810.namprd11.prod.outlook.com (2603:10b6:408:8f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Tue, 5 Jan
 2021 09:24:59 +0000
Received: from BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c]) by BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c%6]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 09:24:58 +0000
From:   "Peer, Ilan" <ilan.peer@intel.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Rojewski, Cezary" <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        "Mark Brown" <broonie@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] cfg80211: Fix "suspicious RCU usage in
 wiphy_apply_custom_regulatory" warning/backtrace
Thread-Topic: [PATCH] cfg80211: Fix "suspicious RCU usage in
 wiphy_apply_custom_regulatory" warning/backtrace
Thread-Index: AQHW4rwYhFgUlszMR0OBRT1c2rvcL6oYwsJQ
Date:   Tue, 5 Jan 2021 09:24:58 +0000
Message-ID: <BN7PR11MB2610DDFBC90739A9D1FAED52E9D10@BN7PR11MB2610.namprd11.prod.outlook.com>
References: <20210104170713.66956-1-hdegoede@redhat.com>
In-Reply-To: <20210104170713.66956-1-hdegoede@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [147.236.145.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 372527cb-7190-4a2c-e7e5-08d8b15bc5ac
x-ms-traffictypediagnostic: BN8PR11MB3810:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB381010576971021058E491CFE9D10@BN8PR11MB3810.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62Bh8kmsLjkuDhwQxd2feIq2dXtGEb2pkL2A3Nr6fx6k6AD2xpQ8+wxnwsWg6j6zylRQiQQ9PxusKeQQxWEdpllhOiNslrqwJRQuHiwOGeZKgP3/86khayH66NDD2+cYCgyrF/6v+fvSrE3GcJbVwbHOMNyOKULeAEa0sBtCuXALy7t1NwwUkhCUX9R3cx8nSxZipilSHyK69rkkzB5rf4L3FZNgGtVM5CF/eUKE8t8RxK9BxCi8lpTucOL6MCsKw/mDxsBqdsF9RUtZgAnu2QTf3l8x8Ikc014Vr0omQ2m+FnGYV3p6avpBFxfdCM3myiCScgoWidxLF2Hi3yiVoBv9h0xb1IpoRQnKHSF3h83bQRQBg+4bKZM6JvhXwHJs1uBBh+ejOSemocH/r4tH3G0dYTdPKl/Y8kG5qiZlCJDygJVqKJI7j5CTmzVANiLu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2610.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(186003)(66556008)(33656002)(66476007)(55016002)(76116006)(64756008)(26005)(8936002)(52536014)(110136005)(4326008)(66946007)(7416002)(478600001)(5660300002)(54906003)(2906002)(66446008)(7696005)(71200400001)(316002)(6506007)(921005)(53546011)(8676002)(83380400001)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?L2HZVUg+gdEZvNbhdPqoHSXZsj8cDq+b6p/6Gemj6TpH9So5src0pszMHZfv?=
 =?us-ascii?Q?Gkf72rQVrYxd3yKtrh9cSRslB/ad7VrQtGyeHP9V0wdG2+w9MwemnUA2K2on?=
 =?us-ascii?Q?ZOmO8Z9HELcEavxhX808k2Qn9XWfqeUB4SUWnNSBpF3/gtmrOeu0UxuIeJEL?=
 =?us-ascii?Q?e10yAU5Ztv9qlexQBJ3SVF1gqej4Wek+/rwUEoDKMfk++ESbmbZFlhCovey3?=
 =?us-ascii?Q?u9MUyNdsZdMGh7AwCNgiKuHwSgCuONIdgdJoajU3pF3d1nw/DBtPe5JyKglD?=
 =?us-ascii?Q?9UWMZgjpDFt0ko+TIip1VBPyJeZlQYxuSwNF1fEjyRPo2repbrfAYz2x2KIk?=
 =?us-ascii?Q?tn5A3FkaU5Ie2+gLKqL+ZGYFoKUEWXW1uVzy52k6hGHY9qXI7QKVBaUNgaHL?=
 =?us-ascii?Q?jJ9l6p/1SZM1wpVSp6aSe17wJLLZbAd4+HMB3EpSahEgYYbHNGHk/DIQLUHa?=
 =?us-ascii?Q?D/JxGsVpnsBr7LaV05PHXWXs8pPu1yi1v1FVeoDZmi0Djb5gHsyb+P/njvti?=
 =?us-ascii?Q?bUA2S7xv5vZebOs1MmWc7z9FLzlVWvfLSvPi6ry4sBTKcHwc8cRlieU+k3P6?=
 =?us-ascii?Q?bVQ6kOTobcExzu+fQVlZLcNIh+NT4sZQy/WkqUIdC6I9V2483hmjIZsPqdbh?=
 =?us-ascii?Q?kf7TjfRTCbhCjLi27ddwSTYhrUewVbJfK37/2Qxgm05LzMzSOIGjAAX79aVi?=
 =?us-ascii?Q?hETtFs5s1eGKdlX81hk6ngFImJ9rnHYcYlafIDCy5iUY12WtvUFe51nawzMF?=
 =?us-ascii?Q?GepRJqfJVTQEUCNCuV6yPd/sfARiwtsCKt4jnnvtFnkPahMG87PXvAoNJswH?=
 =?us-ascii?Q?JwNyZBD6cG3lFwBtHKvjnC1NiXGLaDAki5nRPMTEq8tXJ6DJUfUTJhq3fUwG?=
 =?us-ascii?Q?yUZIzlZFwyhziepyPu6Spwn0Dc+sgW7xmtkurYy4RwKdX28nwHtD0IJQ+H4Z?=
 =?us-ascii?Q?KPN6xhJmFT7Npj7/d3FcKZUwTQ0jMqAHX9+MF53jhcQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2610.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372527cb-7190-4a2c-e7e5-08d8b15bc5ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 09:24:58.8149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e8+AWDWfefuTXKA+N+GiJj3nZL4iOmdBLxNZgtMBpg7flDUOyu6PSi0RLl11Wt2Pn6E/HV/bW+fmMNXMz5sKUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3810
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Hans de Goede <hdegoede@redhat.com>
> Sent: Monday, January 04, 2021 19:07
> To: Johannes Berg <johannes@sipsolutions.net>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Rojewski,
> Cezary <cezary.rojewski@intel.com>; Pierre-Louis Bossart <pierre-
> louis.bossart@linux.intel.com>; Liam Girdwood
> <liam.r.girdwood@linux.intel.com>; Jie Yang <yang.jie@linux.intel.com>;
> Mark Brown <broonie@kernel.org>
> Cc: Hans de Goede <hdegoede@redhat.com>; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; alsa-devel@alsa-project.org; Peer, Ilan
> <ilan.peer@intel.com>
> Subject: [PATCH] cfg80211: Fix "suspicious RCU usage in
> wiphy_apply_custom_regulatory" warning/backtrace
>=20
> Commit beee24695157 ("cfg80211: Save the regulatory domain when setting
> custom regulatory") adds a get_wiphy_regdom call to
> wiphy_apply_custom_regulatory. But as the comment above
> wiphy_apply_custom_regulatory says:
> "/* Used by drivers prior to wiphy registration */"
> this function is used by driver's probe function before the wiphy is regi=
stered
> and at this point wiphy->regd will typically by NULL and calling
> rcu_dereference_rtnl on a NULL pointer causes the following
> warning/backtrace:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> 5.11.0-rc1+ #19 Tainted: G        W
> -----------------------------
> net/wireless/reg.c:144 suspicious rcu_dereference_check() usage!
>=20
> other info that might help us debug this:
>=20
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/2:0/22:
>  #0: ffff9a4bc104df38 ((wq_completion)events){+.+.}-{0:0}, at:
> process_one_work+0x1ee/0x570
>  #1: ffffb6e94010be78 ((work_completion)(&fw_work->work)){+.+.}-{0:0},
> at: process_one_work+0x1ee/0x570
>=20
> stack backtrace:
> CPU: 2 PID: 22 Comm: kworker/2:0 Tainted: G        W         5.11.0-rc1+ =
#19
> Hardware name: LENOVO 60073/INVALID, BIOS 01WT17WW 08/01/2014
> Workqueue: events request_firmware_work_func Call Trace:
>  dump_stack+0x8b/0xb0
>  get_wiphy_regdom+0x57/0x60 [cfg80211]
>  wiphy_apply_custom_regulatory+0xa0/0xf0 [cfg80211]
>  brcmf_cfg80211_attach+0xb02/0x1360 [brcmfmac]
>  brcmf_attach+0x189/0x460 [brcmfmac]
>  brcmf_sdio_firmware_callback+0x78a/0x8f0 [brcmfmac]
>  brcmf_fw_request_done+0x67/0xf0 [brcmfmac]
>  request_firmware_work_func+0x3d/0x70
>  process_one_work+0x26e/0x570
>  worker_thread+0x55/0x3c0
>  ? process_one_work+0x570/0x570
>  kthread+0x137/0x150
>  ? __kthread_bind_mask+0x60/0x60
>  ret_from_fork+0x22/0x30
>=20
> Add a check for wiphy->regd being NULL before calling get_wiphy_regdom
> (as is already done in other places) to fix this.
>=20
> wiphy->regd will likely always be NULL when
> wiphy->wiphy_apply_custom_regulatory
> gets called, so arguably the tmp =3D get_wiphy_regdom() and
> rcu_free_regdom(tmp) calls should simply be dropped, this patch keeps the
> 2 calls, to allow drivers to call wiphy_apply_custom_regulatory more then
> once if necessary.
>=20
> Cc: Ilan Peer <ilan.peer@intel.com>
> Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting
> custom regulator")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  net/wireless/reg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c index
> bb72447ad960..9254b9cbaa21 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2547,7 +2547,7 @@ static void handle_band_custom(struct wiphy
> *wiphy,  void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
>  				   const struct ieee80211_regdomain *regd)  {
> -	const struct ieee80211_regdomain *new_regd, *tmp;
> +	const struct ieee80211_regdomain *new_regd, *tmp =3D NULL;
>  	enum nl80211_band band;
>  	unsigned int bands_set =3D 0;
>=20
> @@ -2571,7 +2571,8 @@ void wiphy_apply_custom_regulatory(struct wiphy
> *wiphy,
>  	if (IS_ERR(new_regd))
>  		return;
>=20
> -	tmp =3D get_wiphy_regdom(wiphy);
> +	if (wiphy->regd)
> +		tmp =3D get_wiphy_regdom(wiphy);
>  	rcu_assign_pointer(wiphy->regd, new_regd);
>  	rcu_free_regdom(tmp);

This only fixes the first case where the pointer in NULL and does not handl=
e the wrong RCU usage in other cases.

I'll prepare a fix for this.

Thanks for addressing the bug,

Ilan.
