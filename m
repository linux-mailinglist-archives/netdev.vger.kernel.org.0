Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309CD3EDF48
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhHPV2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:28:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:43823 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhHPV23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:28:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="215944821"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="215944821"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 14:27:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="640655685"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2021 14:27:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 14:27:56 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 14:27:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 14:27:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 14:27:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKHinJuOyc71AWrCnVISi2yZyY5MgwIWjtejT7FtfH6GsqdB6KdkCe4WILNqmlCAK5Djo/ocO4gDzCAwrtaiDq02QdfpcU68jN38dNxmwbYhmOOKfM8+Wc8yRIVGnr0nxs4typXcF0jCLCzZKMLPzZY9sqIqda2o30eomANuAM5n2G+gIbeuUeRbLqRs9dg61gZdc6Rf/5wXvRiNf41t1rlZqqK9QgeBXnoFiBVcxyAhFZcxKMGhyQc+ETFNSigvHYynlEsgII6+TQ2fOh+bSO0trX5pH3s9B2neOGbKeBjcbhEFnOHVJVlO9dekhdsZ1sTJiqD2/63jk5/dY9ReOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQa4qFTws//pUyGJVuKG6zGQYJPrTpp3Yu6EDOCibn8=;
 b=E9RrZCo+g5+PEp1XAdk2681CVk1u6gKd7y0sdht/+gE3Y2kmaLQYdUroHhy7QcDwPwL0XZH5CA4Spi7Vp5/PYXE7II0xqIDMZXAPv4XPKgju1ZxW3YEeDVkXGXxtLFI4ALFu0AK4m+CnMOLeunPRgl9lMhFg08T0JADrM6Jufp1lkMQqYolDDS/lJTb50ICCf3PIZOwgSdiwzzdmK/aKWKMcQh0BZYh+D2B4xGn/lDiKQqF2ZEpQquaI5B6Rhf7SJMgWFscHgcqNEdeWz2mwF8P7mETrTfiLCwlkIj/QvqdMWOtM6EyYbraTCflcLmjOqC346Yekf5sH2uWXONgqow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQa4qFTws//pUyGJVuKG6zGQYJPrTpp3Yu6EDOCibn8=;
 b=AJ6pQmEjQ+Dz/BcP4T/wGupjz5gwAamilSGyHY+tBSMrBhEA2syicYS714Hb0TUNdhUH6bdbQK9wDq3c8tt+o293zFUBHTuDEnAZzGj64TBN8c7s33BY/uXHpFX1xwh3ZwqSKJf+rq3SwaU9Voo+PMmxsSSSVL2VTKCYaBReCks=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1278.namprd11.prod.outlook.com (2603:10b6:300:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.20; Mon, 16 Aug
 2021 21:27:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 21:27:54 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: RE: [PATCH net-next 4/6] devlink: Use xarray to store devlink
 instances
Thread-Topic: [PATCH net-next 4/6] devlink: Use xarray to store devlink
 instances
Thread-Index: AQHXkPLbdRN88+IU5E+IidkVhhnEw6t2qDWA
Date:   Mon, 16 Aug 2021 21:27:54 +0000
Message-ID: <CO1PR11MB50893EF541863B31DD3139A9D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <cover.1628933864.git.leonro@nvidia.com>
 <38c969b6f490c2b2c0959c017b4461f69ab96117.1628933864.git.leonro@nvidia.com>
In-Reply-To: <38c969b6f490c2b2c0959c017b4461f69ab96117.1628933864.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9fe7710-4045-44ac-c6f2-08d960fcb5a2
x-ms-traffictypediagnostic: MWHPR11MB1278:
x-microsoft-antispam-prvs: <MWHPR11MB12786B6B9FF4CF30C189353FD6FD9@MWHPR11MB1278.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fvMImWZgCzG+VXFtgbnBp3jvN/UW06/vD3UE3yDJFh0F4gHsaKroBnLQHn9u9whEH2oYTFdBwq5kpUKSkJoelbOr81nv2L7tWNWbSIMRtqcCffoIAIEelE/YXbA9qzqwPvfEF0P6Z8ql848e35FGQaiL4lz6ZztvkkLaaEyTH5FLktIbdU4C/R9RBvT9qQiH+UwiMjN1FsF5xwGMhT3fQWOLbL7IG09of8SOLxc+O79SRV6UEklKzzSCWvIkxiyxjn5BuyJNjAYJ6PfQCLFePZo7X9bSRt+QDHQF5WqkMpYVH1EXcDOpVKkgv7m3Ck7o3+t5SAcL8kB35jCRNYo0ds3P83pOKfD5UUS9sCk+CgPq+RCohQhecj7CaWSrmNnJ8CvaeljbeFPwayfMLvJ5JzGR9xTn5VRSzNZjlyCg6zVEdjLOwKd7HulsIuWISPf1TT+RiUPOSE3alC1OXd9sy+c7/hrIyARJUEy6VIMuFfYuBa5cYHN+k06xqUC17ByRDhNTfDKRzIerJ+yHCVsGiI93payKVvd540D8V6WOeb/C6/H7O+6kE+Kx3etJOXY+PTDwMHmg0JDN1LFRzNJNzMb0jEw6OhP7xQt42iaNHkNYAliSxd5vI5ikpAzhcYoCjGntVohuivAxB2sKZqGqaxiVwOfBEkrs7qU3yCshgjtvLelXy8+RmTKzSoqI6aSIDhVSHmUabvG1F08smXgx8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(110136005)(6506007)(54906003)(316002)(8936002)(38100700002)(186003)(26005)(122000001)(7416002)(52536014)(2906002)(53546011)(5660300002)(8676002)(4326008)(55016002)(7696005)(71200400001)(33656002)(30864003)(83380400001)(38070700005)(86362001)(76116006)(9686003)(66946007)(478600001)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ebar/sxe50dcg9OszQpA5FFQT//U30qtRodRi7gHge9hBLHCU6rbJwKOYg2o?=
 =?us-ascii?Q?81G+/6fKowjPst99FIBobMyUjNmipLB7N02zoLewCtdWBr8bVJBbMG1xx2rC?=
 =?us-ascii?Q?TAnXRD+vvUl7SD6spQITlqwjIqKWkQ+o1MMUhkuzfz1sm6E2pYWho5I+mXyE?=
 =?us-ascii?Q?QNKILBlCeHkREvbejGDAfJCfAQbWX0ns71y2ZdKgCqYmsbqTY4wffCJ3Nh+N?=
 =?us-ascii?Q?QZM74fwLTefSyu3oTWh8fuYuygdNQqMdoJkbBw3eho+Gg7dFqeTf6ByUMcdY?=
 =?us-ascii?Q?1vk0ZdSFF/rapu3Qenp2bm9/19ULKRrZUn0QW88fOSog/smbFPdqdQMO2vJz?=
 =?us-ascii?Q?/pQfc5fHhYXymNPi3Rq5Wdy6wCO9VUT7UBrODBe2bdffx6NpToFZaChBOvBc?=
 =?us-ascii?Q?ACc6E4+K/s+4lIHbyEgouyEI6+stJtY8m511BKFZg3BY0do1FupTUxhRkBsb?=
 =?us-ascii?Q?C0NsQeAzJHbSecpjEwQoX6mjC/uE1s0z8Y9zyE+kbMLjidwUlUOXFckHwPIe?=
 =?us-ascii?Q?2/rcftD6ytqBY661RsnfodWFGL3zq7eh3gLUdzVz0f7tNkbe/+jR/NAz3+tT?=
 =?us-ascii?Q?eHVmrgryHTQByt9ayaQiOlgbiEoeNroDqDkNZsKGXoLm+eHIZvIyaOaYUjRR?=
 =?us-ascii?Q?Ktoo0GiAtCE30i6jqglhlrb8vPKKgg/FeLX+ieXo6vdkldJkW53G5ddJLxND?=
 =?us-ascii?Q?wYpWbVb1tKGbPGh1N07tHW3aOJbzJaDd7lgD9vN4qEw19GmwPomc8RPeSrml?=
 =?us-ascii?Q?G7bvteTiNk3i8xQBjAc9dNCbYmz+kwGU75HaAz1mzjVyj+4gPcwO3B62BaDf?=
 =?us-ascii?Q?hlVZ/AcBJ/AVFPzJeHNtK9hrB7uZapwKrFSIcsStgZ91k6ncFn/jWXwfEz17?=
 =?us-ascii?Q?fybw0sR3j9bGWDuSG+GHf8M0Xe0LwtVI5X4hj5ShGp5iCvfGZMi3PQWjwYYy?=
 =?us-ascii?Q?00i8Hinb+ljnJfpQFbkL3sDhu2Z8dHLjuEUrN0LPXrFdO66u03n3pvmlQyJu?=
 =?us-ascii?Q?8r8zxLw7dsJHUqZpo05dBzZVToeNgi3fhlJpns5p0nWjl7U38rX+tKvENjt1?=
 =?us-ascii?Q?6BSAqCAnU+yS49oAGICELErWPGIFwYd0YjHA0oQSvFXrVATLfy5boF5P+bNC?=
 =?us-ascii?Q?JNsE9r7IdOvI0t5syST8kQ0OgrA8pc3zahTRPIL8Wh2QweUiKSyK12TXDggJ?=
 =?us-ascii?Q?CVQnH5UU1cYqJD2Rwd8JdAooI/TP3qnAfnJ0x+oNm1NJko0foMPFaorL2YeF?=
 =?us-ascii?Q?zu+27gg8RZsAnWeD3Yly1wvutOJ5SIyimrUhaJ+D3Du8lqKapGd7XPs9FugW?=
 =?us-ascii?Q?mF4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fe7710-4045-44ac-c6f2-08d960fcb5a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 21:27:54.3411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3X//QsXRJ12Z5XRQVVz1Zll8IrSG0n/6e94ONCKT1p5x9AQ7ApbrcPKsz+MPTFUfNhMdhCoWWBaUkttaC+cNpAPPxy34FK0mhFf0t73HChI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1278
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Saturday, August 14, 2021 2:57 AM
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.o=
rg>
> Cc: Leon Romanovsky <leonro@nvidia.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.com>; =
Jiri
> Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org; netdev@vger.kernel=
.org;
> Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> Mo <moyufeng@huawei.com>
> Subject: [PATCH net-next 4/6] devlink: Use xarray to store devlink instan=
ces
>=20
> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> We can use xarray instead of linearly organized linked lists for the
> devlink instances. This will let us revise the locking scheme in favour
> of internal xarray locking that protects database.
>=20

Nice. Seems like an xarray makes quite a bit of sense here vs a linked list=
, and it's resizable. Plus we can use marks to loop over the registered dev=
links. Ok.

The conversions to xa interfaces look correct to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/net/devlink.h |  2 +-
>  net/core/devlink.c    | 70 ++++++++++++++++++++++++++++++-------------
>  2 files changed, 50 insertions(+), 22 deletions(-)
>=20
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 4c60d61d92da..154cf0dbca37 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -32,7 +32,7 @@ struct devlink_dev_stats {
>  struct devlink_ops;
>=20
>  struct devlink {
> -	struct list_head list;
> +	u32 index;
>  	struct list_head port_list;
>  	struct list_head rate_list;
>  	struct list_head sb_list;
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 76f459da6e05..d218f57ad8cf 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -92,7 +92,8 @@ static const struct nla_policy
> devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
>  				 DEVLINK_PORT_FN_STATE_ACTIVE),
>  };
>=20
> -static LIST_HEAD(devlink_list);
> +static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
> +#define DEVLINK_REGISTERED XA_MARK_1
>=20
>  /* devlink_mutex
>   *
> @@ -123,6 +124,7 @@ static struct devlink *devlink_get_from_attrs(struct =
net
> *net,
>  					      struct nlattr **attrs)
>  {
>  	struct devlink *devlink;
> +	unsigned long index;
>  	bool found =3D false;
>  	char *busname;
>  	char *devname;
> @@ -135,7 +137,7 @@ static struct devlink *devlink_get_from_attrs(struct =
net
> *net,
>=20
>  	lockdep_assert_held(&devlink_mutex);
>=20
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (strcmp(devlink->dev->bus->name, busname) =3D=3D 0 &&
>  		    strcmp(dev_name(devlink->dev), devname) =3D=3D 0 &&
>  		    net_eq(devlink_net(devlink), net)) {
> @@ -1087,11 +1089,12 @@ static int devlink_nl_cmd_rate_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink_rate *devlink_rate;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -1189,11 +1192,12 @@ static int devlink_nl_cmd_get_dumpit(struct sk_bu=
ff
> *msg,
>  {
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -1251,11 +1255,12 @@ static int devlink_nl_cmd_port_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink *devlink;
>  	struct devlink_port *devlink_port;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -1916,11 +1921,12 @@ static int devlink_nl_cmd_sb_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink *devlink;
>  	struct devlink_sb *devlink_sb;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -2067,11 +2073,12 @@ static int
> devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
>  	struct devlink *devlink;
>  	struct devlink_sb *devlink_sb;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -2287,11 +2294,12 @@ static int
> devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
>  	struct devlink *devlink;
>  	struct devlink_sb *devlink_sb;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -2535,11 +2543,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink *devlink;
>  	struct devlink_sb *devlink_sb;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -4611,11 +4620,12 @@ static int devlink_nl_cmd_param_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink_param_item *param_item;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -4886,11 +4896,12 @@ static int
> devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
>  	struct devlink_port *devlink_port;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -5462,11 +5473,12 @@ static int devlink_nl_cmd_region_get_dumpit(struc=
t
> sk_buff *msg,
>  {
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -5995,11 +6007,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct
> sk_buff *msg,
>  {
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err =3D 0;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -7176,11 +7189,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink_port *port;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -7210,7 +7224,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct
> sk_buff *msg,
>  		devlink_put(devlink);
>  	}
>=20
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -7771,11 +7785,12 @@ static int devlink_nl_cmd_trap_get_dumpit(struct
> sk_buff *msg,
>  	struct devlink_trap_item *trap_item;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -7997,11 +8012,12 @@ static int
> devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
>  	u32 portid =3D NETLINK_CB(cb->skb).portid;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -8310,11 +8326,12 @@ static int
> devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
>  	u32 portid =3D NETLINK_CB(cb->skb).portid;
>  	struct devlink *devlink;
>  	int start =3D cb->args[0];
> +	unsigned long index;
>  	int idx =3D 0;
>  	int err;
>=20
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> @@ -8899,6 +8916,8 @@ struct devlink *devlink_alloc_ns(const struct
> devlink_ops *ops,
>  				 struct device *dev)
>  {
>  	struct devlink *devlink;
> +	static u32 last_id;
> +	int ret;
>=20
>  	WARN_ON(!ops || !dev);
>  	if (!devlink_reload_actions_valid(ops))
> @@ -8908,6 +8927,13 @@ struct devlink *devlink_alloc_ns(const struct
> devlink_ops *ops,
>  	if (!devlink)
>  		return NULL;
>=20
> +	ret =3D xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_3=
1b,
> +			      &last_id, GFP_KERNEL);
> +	if (ret < 0) {
> +		kfree(devlink);
> +		return NULL;
> +	}
> +
>  	devlink->dev =3D dev;
>  	devlink->ops =3D ops;
>  	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
> @@ -8940,7 +8966,7 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
>  int devlink_register(struct devlink *devlink)
>  {
>  	mutex_lock(&devlink_mutex);
> -	list_add_tail(&devlink->list, &devlink_list);
> +	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>  	devlink_notify(devlink, DEVLINK_CMD_NEW);
>  	mutex_unlock(&devlink_mutex);
>  	return 0;
> @@ -8961,7 +8987,7 @@ void devlink_unregister(struct devlink *devlink)
>  	WARN_ON(devlink_reload_supported(devlink->ops) &&
>  		devlink->reload_enabled);
>  	devlink_notify(devlink, DEVLINK_CMD_DEL);
> -	list_del(&devlink->list);
> +	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>  	mutex_unlock(&devlink_mutex);
>  }
>  EXPORT_SYMBOL_GPL(devlink_unregister);
> @@ -9023,6 +9049,7 @@ void devlink_free(struct devlink *devlink)
>  	WARN_ON(!list_empty(&devlink->port_list));
>=20
>  	xa_destroy(&devlink->snapshot_ids);
> +	xa_erase(&devlinks, devlink->index);
>=20
>  	kfree(devlink);
>  }
> @@ -11497,13 +11524,14 @@ static void __net_exit
> devlink_pernet_pre_exit(struct net *net)
>  {
>  	struct devlink *devlink;
>  	u32 actions_performed;
> +	unsigned long index;
>  	int err;
>=20
>  	/* In case network namespace is getting destroyed, reload
>  	 * all devlink instances from this namespace into init_net.
>  	 */
>  	mutex_lock(&devlink_mutex);
> -	list_for_each_entry(devlink, &devlink_list, list) {
> +	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
>=20
> --
> 2.31.1

