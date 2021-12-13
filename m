Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A960472D3C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbhLMN2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:28:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:58090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhLMN2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 08:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639402096; x=1670938096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G+d9OKNSrOTHC2XRXaBiBs9bVlUmDW2Oegw9FWEmtAI=;
  b=Bb+VWNl+ej9SPzeda9Mt76TJU/aec0ybYVXaGEhD/5G8SxAslcvnpCBj
   LmRdSMB8oUNFqp+kc9cSLVES//dAMKu+0VhK/5unnI9z5QYY8gNgwsLRu
   J2citwcM17jy8iC76bmkIy/fGz9Og5ZZAd9/Lar2K/yXmuW6ko3z9LjQt
   hGW2NbGBy1WVyGHBFPIUbxz7tmjz6WQoUeUSaUNqYa+bCdHYmnWXa7+ig
   TMVBqWKpq9aaBT2/097tBBVymVY8OvZrGP08fm/qV5bQhlvRVYdLe4jht
   bADHHT0Z/LOQlflDoyv3hXve80NajE51S/iQSn7phViWS8gKo31URr9Co
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237465291"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237465291"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 05:28:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="609018453"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 13 Dec 2021 05:28:15 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 05:28:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 05:28:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 05:27:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFQd+Zi/+FRFhOo2CAH2CfNH9voyr8Z5cAWsPMMWzUNa2lKrUS9EvBnGQ5hBexIeg6fDaT2CmtrAuXXXiWr4UplQ8M4bJOR4QJHD76goft0hle5uyeAkpHrFjs7juA5OxHoTXPxHX06G2FSrTJTP/Wl11ackvGGZdqwRB9lJy3dgzZe53NjWGvBKz3ug4LJOrFn93neAkCjZteLR6ywG3G0scboNfNGmahZfgKfcJBv9MYp18C6n6k48hHrsxULz1M4L8q1RR72/qjP8pIoLU4K1qR2jaat4NLYXg9ZK/fRGr76ppZPYCC1DdK47cjPAaltyq9k3N/Orout9d5iqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9Xub3cZMtru3B2Qk1tEwsP3y5YNi1LoseLGitoOJnU=;
 b=XhUHhL2Njq+aAdHZ0Wxp3HchVSlM3BvK/1FKh1NGlcfvYJkX6GiO/D8CU3YdcLQFNB625rq/IX4Qx7HxDJSLfCQ4WHg2OqrH6G8wCqxnpX5na9oazwMc378HOqO8t9eJ57x73HD6rxHlDZD19s8kjGLF+c8wU0QAqq3+PiancP8pVe25XbQUV4NFMc1DViF09ESUP5MVW6QAzMkCxo5ZNixKxu9dPHg3xRU/q5t0j9ZLvzUpuYrK6trEoynrIkJxrMqu/j+7Hw4Eq4rDkbwacdoC3s97HTO7aT2FDTtxhAXiNjbhmwkg7p1MzImlw0eg1SasY+edLTGbD0ng9Ld0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9Xub3cZMtru3B2Qk1tEwsP3y5YNi1LoseLGitoOJnU=;
 b=eAIkJKD673YIi4NN2CayVHmusneg7nB0Av32wQ+1yp8O6f7SuH/ewuD7L/djTAk+e4haP7X3oBUkvUnzqrZ2FZVCEbUB74ulepS0ZHfcaiHij+Bp+AwoIbNezlCNCR9oVfgSDfP24SA+TASVzO4z2o6pZQQMdj7ufmXMsuY6eME=
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM8PR11MB5574.namprd11.prod.outlook.com (2603:10b6:8:39::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.11; Mon, 13 Dec 2021 13:27:55 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a%4]) with mapi id 15.20.4778.012; Mon, 13 Dec 2021
 13:27:55 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: do not override the adapter
 state in the watchdog task (again)
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: do not override the adapter
 state in the watchdog task (again)
Thread-Index: AQHX5oyHvGq6d4pET0qzsXrq0pK9W6wwfUPg
Date:   Mon, 13 Dec 2021 13:27:54 +0000
Message-ID: <DM8PR11MB562126C8EE3AC17F4CDF0763AB749@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20211201081434.3977672-1-sassmann@kpanic.de>
In-Reply-To: <20211201081434.3977672-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f81ef33e-7aef-49ff-238b-08d9be3c5f01
x-ms-traffictypediagnostic: DM8PR11MB5574:EE_
x-microsoft-antispam-prvs: <DM8PR11MB55744337965E14FFEB7AEE7BAB749@DM8PR11MB5574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0jzAbv2r1U5pfZD0H82Bmb0gyUtAwTAe//pBCxy5X6BLBzuWsLzf3j2tmo/Yj6Cur30E+VsZmEE58gEss26NGNlRMS0v9iUmAozThWxuEKppiEtkmLNgY7S3mOAJV7uYvtyt/mGXaOg0fA43FPpFA2DySmX+EJAL4V5BgxF9uYpM3OUS7lGvMxTAB+YBrGR3zxySBqwnNMvRSOa2X3cQ3M3okldC6cN01ju0zCO+WVRlW65323ZUUn3ExGEFLP7FXFQ/Qakd+ToDDH3zjU+RIePb8EK3VE+RzjABJRFA1lk3UP7eD78l6bLNA5I0AWIDfUq+PMA74uucEJoO37CJ0wm55ZWMwWqDWvCVkoTNYCZkCgC59W9+KTPfkqG6o3mWAr7f5ZdMr6tqCI1jvN1O9Q+0Qc1bEm1/zL3FPu4N9rAvLZ66aCNSXqqyrqmKp5qOutbDcgCq+8RfLW1kCOaVwA4inf9rOeIb6FsyXoLhJ85wuEYSpIMxHYyWDeqktP43fEPswI2OMwGqR2knaFs6VrG5NDBHAU6/nf7teu4fInMnbqu/yQ4l0X9PYhW//N5vOPG8ALtcmvrM8WvuvjfvjCag2GY0lKuI7BtOdZZJrtnPROTqYbR6JFAFZWD2ZTisj7nkkyGMysdm5DbEjFz1iXysEVhOIKuMzjapPTYedYU0kYYr+ntNVhk/cM9U9mhNjgGtcNOWdJ0G8XPHputBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66446008)(76116006)(55016003)(52536014)(9686003)(110136005)(33656002)(83380400001)(38100700002)(54906003)(86362001)(8676002)(316002)(53546011)(7696005)(8936002)(186003)(66946007)(82960400001)(122000001)(64756008)(508600001)(38070700005)(71200400001)(6506007)(26005)(4326008)(107886003)(66476007)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?HSKLQvBiDQ5uFNHHniyzGs/wQIH7mbocTWFthVJAIl4cccgYv32sAutsx+?=
 =?iso-8859-2?Q?eyBOFU0rd/6c6ce5+2OxGiYB72lxteswjXyprZewnv1QTxQa8XCzH+p//a?=
 =?iso-8859-2?Q?aG7OqnSdWazwoUA/YrraRP7f8YQZ0JXfjSUpPMHq1t+O6rf5RBP5Vho6nD?=
 =?iso-8859-2?Q?S9w1V6hqhoLCN189XVQbLS1N+LaA952IsnIYykmKgOsz718TDuOyRSfWu+?=
 =?iso-8859-2?Q?FF9oz2hZxaE04qWafOleF+sH8QMOvIavqfJ/CRqTTARUymGvkJRt54MglU?=
 =?iso-8859-2?Q?FR2mc4FABzW/IVPZMtTHLMDGsq5Fs8nfZXx3mdEn6vLdz/6OQkxR6eNnR8?=
 =?iso-8859-2?Q?T0gmGO6TYbCBXLS7J3RZSsENYJEu+yAqwIggIenNVOkgxpQXfF3ImyB3zZ?=
 =?iso-8859-2?Q?0ku4yyebe0YBOzJ5TlT1X5uwwm2/UK4lyq2lneOI1yZOIGbp4Tjo91StAy?=
 =?iso-8859-2?Q?7m/kEO1rcCOov6CqHj8cOQnp7bqJO31YYm0uPYDRL6TCpBMp4omUFSUMRW?=
 =?iso-8859-2?Q?YU2xk5sUKBw433U0paW5+qZrvamNT5Pt4qXrNYLDj4YfisrWv/8azi4AXc?=
 =?iso-8859-2?Q?5F9pJoveIn/Ifw9wZwfWEHGNyUz6o8ThL6cy0h3nPfXVPHm26pSv2qUyJ7?=
 =?iso-8859-2?Q?bAd5t8ZI+/vSczYQK/r1JZSF3Alzile8qkNhqXTLODOfu5jph2d3CIt5o6?=
 =?iso-8859-2?Q?sDzz8UuqH4xi4HYpeTNHIDJvrrjSZJUt55JG1ybkgpjxPbU9H0/x2LeUY/?=
 =?iso-8859-2?Q?kOq0qJXgGEKXximjviFdtMVcqp4cBMnlFZkA8SeHRqaVUgYzgITvjxvABC?=
 =?iso-8859-2?Q?B5ZuE0np3v3p+1dorblmchWMqPqo8FhW+5PBZRoZX0FgWRRRi3hgKb/BJX?=
 =?iso-8859-2?Q?hqnW7/j85OC1U9wjqcpcdU2vBc936LcosdFp+fRlbA9v4cpFuDVsxpvfwc?=
 =?iso-8859-2?Q?i0SHBxLyKJ9HjqGe3T9ljiW/MX7/xFVfY83P/v/kaq0euRBO63nCi5KFEd?=
 =?iso-8859-2?Q?Q6sj3QKFS6NFP22ZquyjbQuiTOA/f481SbrMnT2yjLiY9hxFTVcfKdNzX+?=
 =?iso-8859-2?Q?O8gKA5Bqbu+Q4vjjSLWcIwRkQgYaRdMOrbV1whaeaoDgnrt4lq3/VZhHGv?=
 =?iso-8859-2?Q?5NOlnjXQHYNmCaX/GSU0fXi6qhK2C2nit6ytpYO6wP02fjoiq7EYr+oUvF?=
 =?iso-8859-2?Q?rE8AfOJ3ZiLdLNmn0JD4cH6b7NehZq+jfqctz34PsCBxKZsdvck4rCT4Ir?=
 =?iso-8859-2?Q?KNJ7XePS2kTTJ4SJwy+m2UUrt0ZMNSvV/1QtQKBSCqhZTR4zfEdX3zv3Sj?=
 =?iso-8859-2?Q?l3baVmbYFrXbzyfz1U8QXfdWMX5QUW2h7U5dAf+4O3atdTfcwCkPnxUMMt?=
 =?iso-8859-2?Q?SCHCduLxPheUVa4hFg+xEs2iS0XMFLutwK6Co5BE1ymFMN9jRUDHAv2RkQ?=
 =?iso-8859-2?Q?7zN+GcWUIJHRpyjzpUsi47hTuIqkBMXrJ3+k297djThOJYL4Wt7TT2LaKW?=
 =?iso-8859-2?Q?w7h/8ND/oxnwexd5KnNv+QkDT2qBaEGwSCm2RJKEETlPuPM993pHocCr/b?=
 =?iso-8859-2?Q?ut56IoqytECZfZjrBH14ljFC5GMFS+dD6Zyf33xUpbzvf+xlKL+7/MQlZF?=
 =?iso-8859-2?Q?RFxtIepG6HGn+G0Vka3HF7H9d2uiXzDLdrCTEUuFLtsDDba91b5SnUsMbO?=
 =?iso-8859-2?Q?m51nqpp7fKibbne66jIt7uJPhpcvVJ2BKnoPiDZAgeOmw3TXFVULb5M0vn?=
 =?iso-8859-2?Q?qGtQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81ef33e-7aef-49ff-238b-08d9be3c5f01
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 13:27:54.9756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEoSkq5PiCyA+Dm8XmbrnpTNauBDn9HiuzrAo7VxxTdj8RgaLPdMQ1pXHwwoTchvQvWk+QkpaOEJlQke9mD8Eb2zsqnHITvO7IPqjJ4WBqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5574
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Stefan Assmann
> Sent: =B6roda, 1 grudnia 2021 09:15
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; sassmann@kpanic.de; Palczewski, Mateusz
> <mateusz.palczewski@intel.com>
> Subject: [Intel-wired-lan] [PATCH net] iavf: do not override the adapter =
state
> in the watchdog task (again)
>=20
> The watchdog task incorrectly changes the state to __IAVF_RESETTING,
> instead of letting the reset task take care of that. This was already res=
olved
> by
> 22c8fd71d3a5 iavf: do not override the adapter state in the watchdog task
> but the problem was reintroduced by the recent code refactoring in
> 45eebd62999d.
>=20
> Fixes: 45eebd62999d ("iavf: Refactor iavf state machine tracking")
>=20
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 14934a7a13ef..360dfb7594cb 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -2085,7 +2085,6 @@ static void iavf_watchdog_task(struct work_struct

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
