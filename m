Return-Path: <netdev+bounces-6611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6CC717150
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8947281027
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DCD34CED;
	Tue, 30 May 2023 23:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D43DA927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:07:59 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A66132;
	Tue, 30 May 2023 16:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685488044; x=1717024044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fjezQE4ylHrFH7JfpmQoDm3frpQrdiFVvfWXRu4CSG0=;
  b=GZp4kE+Qxt5ScCUs4+Uv7C9h+HmglYDzIJbG06XWghw9zUWaIaif3MHz
   H56t57lpE9Ob+2OkuYMOahHc6o3xUAig8mhlp86Uqy6UVMC+vBkRUK+jl
   B3mvs3ofzLuPLBtAS5X1M5oYQlurggsEYlp4z25mnSK1PUJyExHrYCf0q
   gYNdmjoKvwbbA40oONX92n7J3iB6XHL36VUT+Vh5rdT26XgjB+ajjYSff
   0IhO4FqJSP3qAGMpeCBQJ34Qz16RXWpylwZ8BEi4c1l8fgY9sUidNeK0i
   sGYtKIjhnYPqcwjAhBwHnn168DWwtjqQ0JDIVSA6yKf8FhxTdVkPWMHYN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358329026"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="358329026"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:06:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="709809769"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="709809769"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2023 16:06:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:06:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:06:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:06:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdKQlfCZFMMia+3ys4W/LMmLT7/8iBGRQ78jrjRncXZx/O0b91LZfV6XfEyPLn7UE7104VAeQMn7sHMy5uh5zfEk7MusydfFwDCq1c3B/HGrqzwdSgbWlNsw1Nlmm0ZwRZ3hXJ2zCtN6ugC/AvtbUo4JVDWzj6ZpCiY5sAmPw0Mp20uJx+qUTXMExIVBTMKg6LbS1+WIAL0D1NgytlzB0ywuCFpqEFRlYAUdyzBcHHmxlPNLaA7MdpdSiK7XSnDIaamj1P5myDxFbTuOHSjGju8g/KR12afavJoC1tIlpELQ/hOwz2opUsX3RtpeOjhPtz+oQDAxqKBtr278PZuw7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ipguo0S8OwcsFLIKFrmwFFoRcT/G55n6gBrJlczJ7F4=;
 b=NBob63Zw55AmcZESzykL0jy1zSAQw6NfbdUAUQ6L91zz47riTeVOvhL5wD/c6G1qkQ2lyYdBReOlDIzYiXjt4crniI5NIYA1u1mi9kPq5sypmkmcWveXzTs56ZGT9u5mPo7YUu3CUc8tPGyAOJR0eC/lrUsOgbeGngI6g7dMed5ezjqo2PDp1XIi0xmBgcwI8d37MROuvNjqkRsxo+Y2G7ENLFZvvYjnHSVRLIpA1PWYXqrqVICkvgKWsDx6OYlFTadnNJLy/DN2juQQ6j7gNHTHMhTLJZ7gqDxOMTl795uWzy/D2Br+US1quZdb6zvZa6QDwEDksN0Kr+ZwtLPuWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by SN7PR11MB6897.namprd11.prod.outlook.com (2603:10b6:806:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 23:06:40 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:06:40 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "mst@redhat.com" <mst@redhat.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "edumazet@google.com" <edumazet@google.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>, "decot@google.com"
	<decot@google.com>, "leon@kernel.org" <leon@kernel.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"rrameshbabu@nvidia.com" <rrameshbabu@nvidia.com>, "willemb@google.com"
	<willemb@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>, "Burra, Phani R"
	<phani.r.burra@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 15/15] idpf: configure SRIOV
 and add other ndo_ops
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 15/15] idpf: configure
 SRIOV and add other ndo_ops
Thread-Index: AQHZjQ1zqpOSlmSGBkC/2bb+YYJ07a9zfIUw
Date: Tue, 30 May 2023 23:06:39 +0000
Message-ID: <MW4PR11MB5911BB14B4BC41FEE8E55E83BA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-16-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-16-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|SN7PR11MB6897:EE_
x-ms-office365-filtering-correlation-id: aa33d6ae-31c4-4a87-d05f-08db616286c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X8MBNRYQRuSqBJTjVWw4l0q0IYcYkNeXlnVLWS5lsp0nGDprW8x0KzPcFOVoZhDRk+logyRFMzdvUMEFf5we4bTkqenhutHa3wsmeW+gyjxB6hFb86F47NMuaCzutok2GOrnXp1QZysHza04hUIm50WOgy12241T0LCUF8EGGQ8g9fJtKeYWGaaDw041zV9zgp16bcTcxPxKVhfZPRb8TakHYrW/BjPBUmhr8yu/tjhOfjj72LTsh0+g57SSwgIB1NjLlxS8aCkrSXgf0whS2K6HdKAo0FL3F3ryZR2h7NnImb7BQHFg9MwK1kaQigkm4r90TGCHQRIMkoXRK2a7dF7jqy3ouzcbDteO3iKstMfVV3cJHfpOT7YyDJg79uiOjbC8C2uzIt6nhrkg3DVIAlp3uqjz6OZRdgnoWsTl0gzlPMIk4zXvLjKZ4u2OnalZENqX4HA+qSLSaJavG3/9z0kWUXiGHUE+fX+ceHwJvWwFyzrPkq+bXffvQcBsQKDlxhzzbAfAGEPiPBXqiItskQiDjugjP0BZQQpfpveB9hGfL+4qIOLSSM0AlOXj9rKQWt9x5ClACJD98A5Oop7QX5fbVaFiGfQUd1aAdFoXhRt+KwnZaUvxaY39j9OEr6oL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(66946007)(4326008)(7416002)(76116006)(66556008)(66476007)(66446008)(83380400001)(64756008)(52536014)(55016003)(5660300002)(38100700002)(86362001)(41300700001)(186003)(8936002)(7696005)(8676002)(122000001)(2906002)(38070700005)(82960400001)(71200400001)(6506007)(316002)(110136005)(26005)(53546011)(33656002)(478600001)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/Do4M6yoaNG9S3vpQG5bEQmZ9W1ZZ0Shq0px5TPvqdTgEIEHZFVtRxwLkgA4?=
 =?us-ascii?Q?BqEuBJfomGdheu3sD8SVIVnA5Q96iRg/pnkHwjUelvMWTxuagkixIVttF9Qp?=
 =?us-ascii?Q?4ublQ0wAAnjNLAP2xBL+dWEPnGV41CiLfEq3/BrZzpL7sYhxRR55+9gieYUg?=
 =?us-ascii?Q?pkcnxGUKFoCWVMbbdxemOIb7/kILPwtACOiuvaOxviHtwimuxK3BsGEsx1Ul?=
 =?us-ascii?Q?YTTZVrUaMzEPvEY07C2dx+IcVRWC7HxY0cAeRWZ0m5teIpTIwHDOay1VmLbP?=
 =?us-ascii?Q?LQhn9pEAwuw/wu2L4Q9hysjWJaFeAhp709d62TPmjpxQNGgF5/MdcHi6R+Dl?=
 =?us-ascii?Q?Ss/4/pFSGCkrmqytTUJQZL9KoARmc2/sn4+IfDS0TT+YlrniwLuCRseoZaFs?=
 =?us-ascii?Q?oBfFbxc5DXcuNMUX3YdnJ9ib4mh7y5ZeLC3/b9hRqPb3ecPn+9bEmOmJbOGD?=
 =?us-ascii?Q?fRKW96o4CzRU5dO+pFXYw+GUfZr4mUD4cTyzvWE/0RbLtF0g6aOLl2KKVFVp?=
 =?us-ascii?Q?StexjlPDEchh1SZT9ePXpFYtMZekats4gU9EsttIyYG6tQ3LDx6L+95FgPkM?=
 =?us-ascii?Q?yXz9SlC6VeTZHPvESpoMk64z185QHxDVRtL4CLh6tGAoSPMzoZytarBd1Itq?=
 =?us-ascii?Q?Qj+YBvU3z7ogRBO25WOD/nP1RI75dQj+DWOcGySEbaWm3wcEkRk1PbvMJXaA?=
 =?us-ascii?Q?uKJeBr+mQASOKaYMWAGP+htjBx9nPl0Ie/OX5k083iUj8niNeaDxTXTBSppD?=
 =?us-ascii?Q?zcFDMoqopuBTazo4FIvgK9YrFmuyNU2MeqkL0v9eAmWFvCzbsAB6LXHI2/JG?=
 =?us-ascii?Q?FAhxs9QVuXFbRkSd6nms8skkrRDyII2Nx0jYB8WG6FOglpX3y4fGHNVr2Vz5?=
 =?us-ascii?Q?UiN5hoeZOy3T7iPtRiRo2WWd1NRqGOAgI0wy72LcrUCVcrbKiA2sKvD43jDP?=
 =?us-ascii?Q?wxYqeBioNEpkaIgOIbKL9oP4V+yOJlBf1R48eWPutL9tAag1FOhJEUfz4sH0?=
 =?us-ascii?Q?jmP4YBPs6faRR3XhY3BjjEIXT74wfKZFcqxr2GEeJK1GcyvsqGUi8Om+k4MA?=
 =?us-ascii?Q?PBs+dRxggO/gdXsQatzhq+MgZFRYyilnLYyMbD3Vr2yf9elEXi+p+1EDvCt1?=
 =?us-ascii?Q?BRwrMoCLwgDiUyNEICNWh/dJi97YMAcKxxeWh0JjX0A2PMpIQoTyOhOn1eXf?=
 =?us-ascii?Q?lVe72y27oC1FBbozuCzC+EHLMD2ht3nLbCpLtRskJ9SCV7pxVJsDv6IrMHRA?=
 =?us-ascii?Q?n4M2jU5p+S25W11nVA09dM/+CnYH8Se5gYwILrlFCFvJ8++FqHO3yQcm97Ko?=
 =?us-ascii?Q?yoBm/a0HrWGZWBbOxE4R0pdZEGpMNqk0P79dpLlkDNNZIPGxsrh8M5d4fYfg?=
 =?us-ascii?Q?X4erhW3MTVYb3rnfQFRgqVfbmk8Z6+XR1sQOYLd9VYyh/iiUQihtB7OeabS2?=
 =?us-ascii?Q?7tf/2xiLUYDWHxt7MMABSX2ydkzXVO7J5YY9nvpgZQ/IRHhAFPBT8NFHyu3h?=
 =?us-ascii?Q?kV1l4x7dwtBcxD9tZZw3GbskodigFPTexxKkZ7MUQ1YihgWlhPF3LlU4Csax?=
 =?us-ascii?Q?6BiQHYuuM5v7XQOBsV2lsy8qvRWt19lijrDkhg8ZXyhBtJgXppWH2ubGK85q?=
 =?us-ascii?Q?QA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa33d6ae-31c4-4a87-d05f-08db616286c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:06:39.8295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+zCzekPhNHzGqE42Vr4QyFlQfRtHpyd4E3LSTtdKr89PZKNIcoWg81SjK3swrnrWVE3wu/VaGbUOVRKYjdjutuRO6OVzG9FB7b4egSzKhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6897
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: mst@redhat.com; simon.horman@corigine.com;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; decot@google.com; leon@kernel.org;
> corbet@lwn.net; linux-doc@vger.kernel.org; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; kuba@kernel.org; pabeni@redhat.com;
> rrameshbabu@nvidia.com; willemb@google.com; netdev@vger.kernel.org;
> stephen@networkplumber.org; Burra, Phani R <phani.r.burra@intel.com>;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 15/15] idpf: configure SRIO=
V
> and add other ndo_ops
>=20
> From: Joshua Hay <joshua.a.hay@intel.com>
>=20
> Add PCI callback to configure SRIOV and add the necessary support
> to initialize the requested number of VFs by sending the virtchnl
> message to the device Control Plane.
>=20
> Add other ndo ops supported by the driver such as features_check,
> set_rx_mode, validate_addr, set_mac_address, change_mtu, get_stats64,
> set_features, and tx_timeout. Initialize the statistics task which
> requests the queue related statistics to the CP. Add loopback
> and promiscuous mode support and the respective virtchnl messages.
>=20
> Finally, add documentation and build support for the driver.
>=20
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  .../device_drivers/ethernet/index.rst         |   1 +
>  .../device_drivers/ethernet/intel/idpf.rst    | 160 +++++
>  drivers/net/ethernet/intel/Kconfig            |  10 +
>  drivers/net/ethernet/intel/Makefile           |   1 +
>  drivers/net/ethernet/intel/idpf/idpf.h        |  40 ++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 642 +++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_main.c   |  17 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   |  26 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   2 +
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 193 ++++++
>  10 files changed, 1089 insertions(+), 3 deletions(-)
>  create mode 100644
> Documentation/networking/device_drivers/ethernet/intel/idpf.rst
>=20
Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

