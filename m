Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C5D42885D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhJKIMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 04:12:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:53646 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhJKIMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 04:12:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10133"; a="313023539"
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="313023539"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 01:10:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="716297474"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 11 Oct 2021 01:10:31 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 01:10:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 01:10:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 11 Oct 2021 01:10:31 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 11 Oct 2021 01:10:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHCuBsa1NNBi7OMCIXol0rE72Abba6gin2ptnp4rs7jOuxievamCWGMNaMeD2iIQolznDTuX+fy7Q9ONvdzitb5kflZSiexrKNCWt9/dWHknVQZWLI6podlOv49Z0VRxjWly4FnP/wa1xYju1jg1ejzBud/eCxF7FilNepEkw7P2lOdgS47AijHv1ZziVg6I/T5LBrvikytPy45Dj9MqR4u8Qd8gtNrGhU76Dd838mSJE64iLQ0Ovb5F1SJd24TBGQupd3WXVyJqypW+/hkqzB/zT6awn1quleJnkqbJoWwmw3WDg50rio3JcsGmoz7vUJ5E8CawNHQd4P+uuW1pPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLrLVnGRysKH5R2Ksb4M95u+/b5gJt58QeXzuPQusb8=;
 b=Fm0c1CTeek8XHlYzGdPzVfhXiQktLxxTCjyQM7Xu0jc+SvRySV0YIN2M3l9vSl2w6Xff/m2FynLgfzk+LIvFDwXbLpHSMIHkjokYolAd1yLusglqTX4Bz9hCLhVCV1qy0f/CYH1tXnPCvsL/GDWCD4foNBrxeKzmkCX8T999In/fb/lZ1UlrjA+ArFDGJ2ZejBcqiQdXpjXZMGeDaOtP2iMd+oFjPKCvrYi6LAVxctsJ7nOLfOdbvBFgxQFHXMkNeUzbs8AsZrP93xnwivyRPjmSMw9cNS392lDbtQS4iBEdemX52FDddw81lT7A6URYa1liECq0AW4eHPPqi/RFXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLrLVnGRysKH5R2Ksb4M95u+/b5gJt58QeXzuPQusb8=;
 b=V9m1SnllPIAZcBcV7BniBC7JV7dxWjDojlPYolAsHp6XfTv+m80gkN2h/dbUt++TNiGKOvKDOWpE8SonOtaW3bNVKM4UE8i0RR/qJ/zTF3zoQhu2/cJUa4amfcz2OFy1zx5wGg+rqITuZX+O6bW1Gze1LS5HOSjy/HKtasKFx6A=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4715.namprd11.prod.outlook.com (2603:10b6:303:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 08:10:29 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 08:10:29 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Yongxin Liu <yongxin.liu@windriver.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net] ice: check whether PTP is initialized in
 ice_ptp_release()
Thread-Topic: [PATCH net] ice: check whether PTP is initialized in
 ice_ptp_release()
Thread-Index: AQHXvm715C75JcNIGkyx4vym/rHCe6vNccpQ
Date:   Mon, 11 Oct 2021 08:10:29 +0000
Message-ID: <CO1PR11MB5089DDA3AE43771D735673E0D6B59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211011070216.40657-1-yongxin.liu@windriver.com>
In-Reply-To: <20211011070216.40657-1-yongxin.liu@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55a4ca52-1174-42b7-2ebc-08d98c8e96f9
x-ms-traffictypediagnostic: MW3PR11MB4715:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47158739D1033D36BC85555AD6B59@MW3PR11MB4715.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: both6vFB17Fm0rr5W+iM4AQ7ZaV6cUGP3agJhcHHeFEBdgGj3mccf57PI6HpzeAdkYHV0HRTrkiCjy1m3WDRmvu5fIQAJMZvm4Eba/6Vo7Cx3xwIcf0cWdDhMzib6VDsosIWLn+UCH0wwJTKXxeCHmSA6MXybLdP2S1UxjMTuDO717HwX6SJUPxPOnd+oloQmulpuUYhqtrngX0lC39SBBQDBqGRy0gcnVrKYeJ/Hr/mYRHgfsofgN1bfJeIpejaTvZtxijOO8bhPGvWU88Y6trESLQbW2nJRzOBI4QNiSAO41iexJoYIYIV3u3DG/OOKRpjvm5B1HdcT34spX+l8RgdtYM5a1sfgnL9f2chENHVeMyRSg6k9LP0/+TPblsuYoHys/tRO8F9hhP1nNUwvedP1Q37doI9IkAuLoKyYR8KISVesXm12GxSuZgHtZkgYjs6tsGgE2/8jTlfe7dUk/hzLI0Gp/Je9njJC9UQJ2GFpDkSC6enbpeYKwsQIUVukS3hVKUATw8R9wqcCmaXAH8Vd/H0WfMbHxNGzAqgDQI9IQb0j4lwT036TzZJseC+AgbA6Tn6Y5CDXRDk4MCpu8j2kr/hiXp2xbjj11Ocx6uygHnGwLfUCuIED+xICCM+l2CJMhsThNWmvjYt3vzXWpKb3i4f6mXvG6BSZZ0l3NR9r3y5lXx650VM6OYqhaj57P5J40TDyD/5uy8VXgD3fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(2906002)(6636002)(6506007)(7696005)(186003)(26005)(66556008)(83380400001)(53546011)(38100700002)(54906003)(66446008)(9686003)(64756008)(122000001)(8676002)(38070700005)(86362001)(316002)(66476007)(5660300002)(508600001)(4326008)(55016002)(8936002)(110136005)(33656002)(66946007)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fi08AwOWQktSY6WVPvQqB7AQ0Mx8HKC/jx9W37c8uLl+A7rnAtTJxWWcaPEX?=
 =?us-ascii?Q?qlgZFp0rxV8z/kcGHSPFCXTGhDPFFHqEYlFq2dM0TQvzpWwIpRdkjzOWU5xP?=
 =?us-ascii?Q?pRnCbatesS1FvbXoESHf5hD6XHxSYq5Hu7TSDyefZTTJ8fgBbTEy37B8Nthk?=
 =?us-ascii?Q?O5v6EHwlDgAuzC7JbeVkO8RpNszRz6q9WSecaBbi48eBrKbQ4sn0+cQRWHEb?=
 =?us-ascii?Q?+uHOpCdxREjtynwhQItifzjDqmQfYhLT3uURrqbj5F8P2fx6U1z8kEAIPkGY?=
 =?us-ascii?Q?an3bOIt67w5f1YAcCsYMwRB0UsyTy441fJjqmYoETyX6j9Jl0nz4z9QcB/cp?=
 =?us-ascii?Q?lViaLFFWN8X7U9N5/TmyXutwpFNhIAIE9HWizJ9MomkunTU/S4RIGgcn8qcV?=
 =?us-ascii?Q?WUWZe+/P0JQmYIN3VikgkDCWpXl2N0wlBo1q8pTyfTUdwyNVqRVrFZ8H6l5T?=
 =?us-ascii?Q?xsmq4M9T5NFRNEHKmlAieKj1OdK0Nco9Se3zGpXl47hx++H2yxAFMb54dW5S?=
 =?us-ascii?Q?YOPdcjQu4FdnAZ7tWZU8CP6vlR9+VtndIJrQK+Y45SuneARAfzaEuDqXzh1K?=
 =?us-ascii?Q?evyfXX7mCMvuAci89uPE0K6EQR5I0XHic+pssQh3o+71kvjqdbid4Z27A2ot?=
 =?us-ascii?Q?ciAYKfrVn87FAmhCSv1ix3+XIZN1mtZldlp4ZhsAOQSoIAfhUgLpOHnuIOal?=
 =?us-ascii?Q?1HZDVn9NS9CwRRoLt+tKjfwkyDpCICqJq+/Gm4j03bNVnuie4NgCxl9AsB+C?=
 =?us-ascii?Q?jl9yWeovEMs347JpOZ5Aj2mUMv1o1OdAjUcOOKoqBXgaodZeucA86EdyFD4w?=
 =?us-ascii?Q?jAYTt9Vs7+AgC+f+AVGtWpe7gBbRM1TT+urT9i2Rw13Ny/gKBVmtyXZ+Vvrt?=
 =?us-ascii?Q?Ir3VYQJ7W28reSQVJ/ZDHLWp+XjvTE/7mn6dMo1GuekKq7pbA9NTDt+AVX6B?=
 =?us-ascii?Q?yOIegklAfZs1W0iOrcRK19Mg3QEsUcsgv92B4xtkeBU3oCn4FUn0tgRlFLq1?=
 =?us-ascii?Q?sbKNJ1Z/fx1QkqDGJ4hDJfzxOc5pLuYtSBDW5L5EkSgdi4Ya5Hj5fTsuaHby?=
 =?us-ascii?Q?XdbLxHGcOXzntjPAn+UXDA9TjQFzM2z20ghYY4F6r+JeukCGZH0eykRQOW86?=
 =?us-ascii?Q?A+IV+4L5e5mx/OK3Feovs9eIat42RFL5w8fwfUhgX7obHL3SIKZagsokGLdC?=
 =?us-ascii?Q?mGU84JPry0xDupq7uHobB/zCKWkBG20bmaLN9Wm8VPr9l/dEuZM6uCTRzT2g?=
 =?us-ascii?Q?bW7pcxd4137p7Zc2TjD6EezJMifgIeE8acUINF/s5v1bsxhIdTy/tn631Agi?=
 =?us-ascii?Q?Jpk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a4ca52-1174-42b7-2ebc-08d98c8e96f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 08:10:29.4837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iwOEE0jJ+V0+qTevnOZv5WiRYGHtkKbmYiiOTj3awkXDmBJUMJzE2URxuJN5h8AvGruXD6ZuhUCL8xEhvX0ajhDeNhjn7ZfzUnURLUrVotA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4715
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yongxin Liu <yongxin.liu@windriver.com>
> Sent: Monday, October 11, 2021 12:02 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>; G, GurucharanX
> <gurucharanx.g@intel.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Brandeburg, Jesse <jesse.brandeburg@intel.com>; inte=
l-
> wired-lan@lists.osuosl.org; kuba@kernel.org
> Subject: [PATCH net] ice: check whether PTP is initialized in ice_ptp_rel=
ease()
>=20
> PTP is currently only supported on E810 devices, it is checked
> in ice_ptp_init(). However, there is no check in ice_ptp_release().
> For other E800 series devices, ice_ptp_release() will be wrongly executed=
.
>=20
> Fix the following calltrace.
>=20


Ahhh. Yep.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>   INFO: trying to register non-static key.
>   The code is fine but needs lockdep annotation, or maybe
>   you didn't initialize this object before use?
>   turning off the locking correctness validator.
>   Workqueue: ice ice_service_task [ice]
>   Call Trace:
>    dump_stack_lvl+0x5b/0x82
>    dump_stack+0x10/0x12
>    register_lock_class+0x495/0x4a0
>    ? find_held_lock+0x3c/0xb0
>    __lock_acquire+0x71/0x1830
>    lock_acquire+0x1e6/0x330
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    ? _raw_spin_lock+0x19/0x70
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    _raw_spin_lock+0x38/0x70
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    ice_ptp_release+0x3c/0x1e0 [ice]
>    ice_prepare_for_reset+0xcb/0xe0 [ice]
>    ice_do_reset+0x38/0x110 [ice]
>    ice_service_task+0x138/0xf10 [ice]
>    ? __this_cpu_preempt_check+0x13/0x20
>    process_one_work+0x26a/0x650
>    worker_thread+0x3f/0x3b0
>    ? __kthread_parkme+0x51/0xb0
>    ? process_one_work+0x650/0x650
>    kthread+0x161/0x190
>    ? set_kthread_struct+0x40/0x40
>    ret_from_fork+0x1f/0x30
>=20
> Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c
> b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index 05cc5870e4ef..b1cd26a5ad33 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -1572,6 +1572,9 @@ void ice_ptp_init(struct ice_pf *pf)
>   */
>  void ice_ptp_release(struct ice_pf *pf)
>  {
> +	if (!test_bit(ICE_FLAG_PTP, pf->flags))
> +		return;
> +
>  	/* Disable timestamping for both Tx and Rx */
>  	ice_ptp_cfg_timestamp(pf, false);
>=20
> --
> 2.31.1

