Return-Path: <netdev+bounces-6607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9630871712B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4955D281392
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7300534CE3;
	Tue, 30 May 2023 23:02:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D00A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:02:58 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18446E8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487777; x=1717023777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n7wkmd7AXWdtHsKrvyGiWof7rMc2DuoYk1UA4uRCkE8=;
  b=hkkeds4u7e+nCTFHkfxzm48ir3ktbp1oNItkoWF/MUXrxi0yZE4atpX6
   fbnP2QfbfxbxSTAygtq2cIJBVx1PvstXvHq9ruwkQZKIqvCJ8LxtTqqw3
   rL1fgIXxEWVd1HoyLFHKzJ7ZjQF3OBk/gmH6q2muOCrMzi9Lk1vho87OD
   RV5EfKE11SQkvZZGTyzSe7F79ljECOJtaoRpSCIXUDGmGoztedsnQymFf
   TwMv0y0aRJFI2F5tWt7ZI8bcW41HDx7EVuZve2pFMExPxCaLJ9rI/vrU1
   dz/LackrLOZpWmakv4E2I3czMuvszsu9f8gPrSjYnJVh23jDjSuQyjijw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418557103"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418557103"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:02:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="706625446"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="706625446"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2023 16:02:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:02:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:02:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:02:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5UraIgrIA9paOyq+C+16vn9u7qV22zvNZXH7RCxko97qa11fHdCc7MNQIKm6gTaUm5czibyii0FVKgTyCPNOnHu+FMkBIjXmiwQ1zut9zXNvO1IIt7Oe4GSOIcmo/IMDJX5EwMk9JOloiaKx15lQdC2s7RNxtC9WpWqeAVF6nlheu7HjeJXFONAXbqx3T046NutI9sXlrJgDvQlq/b0PnrlJKEh08DkR4c6OvQvU7vIOgW+BgazrBnA8CoD9JUwqjx0cZHEw6RwYocUdSUntPVhLAh9mRr6wqX3mEbYtlip5FQAgOal1zgoaP9utIWE6KLVWgzN3qPuKe9Dv5ra6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pumfiq9x95Jk/VRGersGyItXYr37iqTfNqgrhswy6I=;
 b=bbWLz/B4kRxbASLtYoc/dA0YG+Afb1NhectiuUAjoW6cI2KKBarRFjBEIm3769K/U0MrOuXIIBQUWV4GYVcBnLdu7GjZdNNofF8OpkcVyDZKWOTbDoCkw4jxTglOFEfdYBnksc5jRh/9y3cS10XcMKzgPGWnUC8wcu/qXZgHJEqeIMgmHy/drdNfxvfdOGWLF7T/2bIlBQLanSyLTEi7iJyZ/BVYHByGe8/7hIoHuoir1984opExSg4B1zq2O8CSi18bxMdqhe0BGrOa/ShQPn0uTgAgpgSpx0JyWLyTtItcDaMCwXmG45WF+Djkv66yztFtOg7mvhEb8UEbsWNX0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by PH0PR11MB7660.namprd11.prod.outlook.com (2603:10b6:510:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 23:02:53 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:02:53 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"edumazet@google.com" <edumazet@google.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 12/15] idpf: add RX splitq
 napi poll support
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 12/15] idpf: add RX splitq
 napi poll support
Thread-Index: AQHZjQ1vg3ciX8OOekqLgcxskjdHi69ze1Yw
Date: Tue, 30 May 2023 23:02:53 +0000
Message-ID: <MW4PR11MB5911AE69A00E0497F7DBF12ABA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-13-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-13-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|PH0PR11MB7660:EE_
x-ms-office365-filtering-correlation-id: ec69afcb-7ae3-4301-54f7-08db6161ffd7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCchETs00Gib8at2aNd+UJAnU9FNDCVDfFQKMTPmuI4RcFP6PnS+RxGEOtycHJziwR0T2jna6bYZpnaUph8UHMqXuoQSaB+/tfug7PaEgjHTPkWSDdPQz++YyYRGhkNe3fzFLFe+V8qPSyumIdxEFI858V+8pvXsSFFmp70NgSuq2cuj0fSOFj4ByHkT6+75MGoRRoMueIaE5Mrr+tHhqRB/CFGignglYGxtLrYv96cV/+VhXtHentwHut7WLm0bu6sWuGLr8UkbuX9XvY5VZev3FgpnxBJ0W8zQOYThP3iZ1xKamnwNAliw3zJznromQjr6r/P+A77k6a/2nRMj+iAz6EkQyhcFAyH43T0dwBD968sTctM2aNpG6oypY7XetP0P6z7jwRVHDkmxbsyVrOt+dU/DCr5b4Xng/GOjkGogxeoAKB1g8OrZGXDWBILDnKgK9YaPdK4S+XzaVerBkS5GdNznDFo7cPHgyF3uWHGryINF/DS1w+IoI5yay22aHtJgJHAFyEYgY72FOtP+oIbvbmNXFOvSLK63wIdi4f3CUEMVzxLEzAOdzHWHsp/+gXn4mBv/RZTuh3uIK5DpFKTrPR3bIhIygH2l8KKxq8BMIrFNVukJW3Uqvmfrrr0L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(86362001)(41300700001)(38070700005)(7696005)(55016003)(4326008)(71200400001)(316002)(33656002)(66946007)(66476007)(64756008)(66446008)(66556008)(7416002)(76116006)(52536014)(5660300002)(2906002)(186003)(478600001)(53546011)(6506007)(9686003)(26005)(83380400001)(8676002)(122000001)(54906003)(8936002)(82960400001)(38100700002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aCpBdHFqhayw9iQJGgIVVDQVWxg7mTSw58CcXgCOKXu0RXngpUyrKJV2ZhGg?=
 =?us-ascii?Q?rwUGVyOg2EfHqEb8pxmWy3mc4Ym21Hu/zF/MjmF+BMfCzbIfLzme4vjyfI47?=
 =?us-ascii?Q?K+SUUEvooh7axXjwX2E3ZUZwlG/eWV5A8vgKL81ZEP/AwaJ2GFTtJ6PaQ2Qx?=
 =?us-ascii?Q?CL7YLC+bVIXwNjd7fzPKN+IJ9XXL9KlUFI4OCpzIOEgsXX8FDPLrMyXSIq/c?=
 =?us-ascii?Q?LwRHPEFUPtngwIbuskhQQmO1Z0bqniuNpFO2heQ/vAHJho8Yd/T5ItLH3knc?=
 =?us-ascii?Q?Cwc/Gw/JB7Pilo+8MO94gcTv5WqSMpTGw2YOBDNTg9IkPEGT5UMX3bSnovc8?=
 =?us-ascii?Q?P+ler4jDibDx9CYXU2C5qT4m/689vSYvKyiJKJtYdhOgYQU1HUwPuf545Yb4?=
 =?us-ascii?Q?3mGzEfTJEHXfyo95yqwjaABDtB7IwlTwPG8AyLia26LJtdMuwrzNs8JUln2U?=
 =?us-ascii?Q?+qDcQJtaLjEiVUbrYy0W96HMMYFEbtddLHsBAiFOCT7WTaFikdpB2N69rfCM?=
 =?us-ascii?Q?+/4k25MjV72/sHRNfHnJPNfVYyPgxWu6kPW/g0ejutfdoCxSI5ERc2ovCax5?=
 =?us-ascii?Q?Aw+zbloJC48a7wYG42g1bxL1AOGtSFV0fUdJR4O3/V3vWrGRsKdbjKqbwJFd?=
 =?us-ascii?Q?I79YfFlc8+tKca2R213MsJwqoD9Ky66jfS0cJtaPVN5uYlMczwEVW6eHJQaK?=
 =?us-ascii?Q?Wm6wdv+R8R0VNWxfXmBm276x7ulj8FpCWwg6cFcK0laGAsFg5qwUJSG5kimz?=
 =?us-ascii?Q?nGD5hJJy0L5LvojOsqC84eEbhtxst3oMJsoPgq3tlTqyebuCYhIdpfKgcQlG?=
 =?us-ascii?Q?wxXIBCAVS6W3ZS7oQLLxkKex14qIUDY5UZwTkUGU7ejgLEs499+HPX4Mluvs?=
 =?us-ascii?Q?gtCNgXF9WLCIO9kts4H8rBbiVvrHSfJ5m/6QhqZNaEdSokrmXFCyHAzFpAX5?=
 =?us-ascii?Q?hXdFuv8CfVTWqcQjwZqEdcowCYRyPSsGbTUJatTWHjAPRBzTcBpgUBN5irNE?=
 =?us-ascii?Q?JR07w/0rhgEYScSNcOr4PNuQ1DOBRvwmLgb8Yvcz43UceKHoK/ryPynGPLn8?=
 =?us-ascii?Q?PNM77konRdPMTaIaoAOycxTnfxHtedkbAcZmgz2oPCzhUPivICLKvy1oNDkD?=
 =?us-ascii?Q?URqYZUkS5evWKk864HGN7e9rjGM1v1/Stms8RllMAVQSaiZ+AvE3UdUm6FyI?=
 =?us-ascii?Q?ido2KiJy7/grEQqimXGMLHTbQX58OQH569mEkMO8tRU0UMDQfC+sNya/HAJr?=
 =?us-ascii?Q?UixhU9txVKgebmHiGrIDIImBlW/XDKKWIOcGLmBlHjFvcye4MGbNjNkoEkS0?=
 =?us-ascii?Q?4vOplhdkwv4VsRwcX3wxveU5W5g0RVN+csyl+1JIjA0NVUtxrwAau2no11zF?=
 =?us-ascii?Q?Kom+9e0An2RGb0nlXWUVjN8UOipt066b3lfktf7MaJFow5jJh2Ps577oqCin?=
 =?us-ascii?Q?flppzEQlYGxLwkyfzGGApMTL1QzDq5ZDYw43+04lrQFPA4oMTeXJsM6nyY+0?=
 =?us-ascii?Q?dnOPH8fFLazJLBU4pSemXns20ItVO7UHPUF/4YVi0v0dWh4TQFF9Dx4iINBK?=
 =?us-ascii?Q?IDWx6d1/gddjHHc5OtaYYwY1mQUJ13ywGsmdDoHpEWWWPQrlzjPXQHZjn90h?=
 =?us-ascii?Q?5A=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ec69afcb-7ae3-4301-54f7-08db6161ffd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:02:53.4577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2F2v4nNkj6Zyw073+OdiVUY9UPH8OS/3Yr+BL3PYHSVVJkGTVH2MV1oXUbJKT0tKqP0kvuGdoVKq9FVl3zhEi63bYLG7xVJ4CnO/Ne3idZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7660
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
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 12/15] idpf: add RX splitq =
napi
> poll support
>=20
> From: Alan Brady <alan.brady@intel.com>
>=20
> Add support to handle interrupts for the RX completion queue and
> RX buffer queue. When the interrupt fires on RX completion queue,
> process the RX descriptors that are received. Allocate and prepare
> the SKB with the RX packet info, for both data and header buffer.
>=20
> IDPF uses software maintained refill queues to manage buffers between
> RX queue producer and the buffer queue consumer. They are required in
> order to maintain a lockless buffer management system and are strictly
> software only constructs. Instead of updating the RX buffer queue tail
> with available buffers right after the clean routine, it posts the
> buffer ids to the refill queues, only to post them to the HW later.
>=20
> If the generic receive offload (GRO) is enabled in the capabilities
> and turned on by default or via ethtool, then HW performs the
> packet coalescing if certain criteria are met by the incoming
> packets and updates the RX descriptor. Similar to GRO, if generic
> checksum is enabled, HW computes the checksum and updates the
> respective fields in the descriptor. Add support to update the
> SKB fields with the GRO and the generic checksum received.
>=20
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/idpf.h        |   2 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 992 +++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  56 +-
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   |   4 +-
>  4 files changed, 1045 insertions(+), 9 deletions(-)
>=20
Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

