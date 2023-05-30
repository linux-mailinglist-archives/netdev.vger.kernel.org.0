Return-Path: <netdev+bounces-6605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC414717122
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6716A28131F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B732C34CD8;
	Tue, 30 May 2023 23:00:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21E2A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:00:16 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322F3E5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487615; x=1717023615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NefJNW4dwkioiVlivYLeJIHrD/RBxHggET7z97A0qmA=;
  b=U+mb07jWyMdXIGljY+ZDUDCmCUbJn++0yrgVmcAl8IFNmtDe9ZD6mT5E
   mddulPRJO+vn3JQdmJYyBT1GPGZVYNFtKZqMwj/Ug9F42M2lRFhhgYR+k
   o60Fpv31Je0hHadmHq6EbQVzhS7RAVTLGnRz/NgG6Yqwv7/EciapEswlg
   ZDRJ0KyfnD1uwsTpStoEF/mwlJOFX322Nl2YYjvLqiEGU1pcsqKypJyJ2
   0mLabX94BHGI4M3oV6bTPt1srEp9sXiEgTVpyFGjustKhlewKEkTTCLPC
   atv5mIcseRh+be5kEjbQ8Vc2oHBp70V9j5jgo0ighUS4MVQScu4Jw7xjS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="344573366"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="344573366"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:00:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776528811"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="776528811"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 16:00:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:00:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:00:03 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:00:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/qFA023fOXP9ETFO4OxAydgUKefljKUYKZHzWxjignFwiBat9tavezC9N9zmehJIG+njR1IB1om4guVNSd6v1l8QomCRJ21WjwVF6VbjD03OhSjVTKQFl6CRKKlrPK8AS+mVE5nztXIliwvToSJtUNj5m1WyyzGEG7DZQEPss5iy7z1vxs+ZKDrefvwFsk5TCVweVozWYDPYcRyJDCq2UIR32VNYcIHO7DmrtCBlK2AdKfBTry20BuwNKaZ9zOrTYOV8+RC4n7cv7zf8weAQ8sh7F1KPFLhDvbZcfhlJMmccI/woWqQUoIAE3NucRH9dxTaCcW2ojuY5ox+5tSuxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G49HQ1wphG2Y5gELFiDGWDv9cNXlmcyRKrDW+u35/GE=;
 b=IbSg6z2QVlqxYREQ1hMvunHNB4PQsXntBX15M0SBfzDv/9zgncVBTgsNXka9b/VDRpfeo6zSzxqXW4oeyMqmtUcVMgblTddsyzMtdLgx++ik0zKCYxV5IRBBLhy13ZVYeyzPBPTjYT6cWb5L5KFjHZQZQlsUyxxsvwWNGkZKb0/BmX7NuuTg+hFAKjJ1C9m0QwHAlStH0St9rsywB6wsEG6zBewyV61sUa4iNayYhwrPlYa9tCPDD/BJFueihtTlL7ZNJ0wTNksEnCCNjogVU3XNgz5X8iZN+zHXOcdEZmjx6CLZtyAHEIRLBNCeU2WsJwqP8HVv+V5uR70ECM9Lnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 23:00:01 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:00:01 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 10/15] idpf: add splitq
 start_xmit
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 10/15] idpf: add splitq
 start_xmit
Thread-Index: AQHZjQ100lot/aOjvkm697faYp6LHK9zeptQ
Date: Tue, 30 May 2023 23:00:00 +0000
Message-ID: <MW4PR11MB5911E4114A4346991695A4CDBA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-11-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-11-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|PH7PR11MB6649:EE_
x-ms-office365-filtering-correlation-id: 748e79f9-301f-4516-4fa5-08db616198e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwxhSexa0C8u+AFKn10nqm8K+AePC74UzWJAeiYJIfTMJo/bxUtywHEnq7jwJWi0zSSPWfVNuytqOuqN2jFSXk+BM5sOMw84QpxWTWAEr7XjrKSkNgpi/X0leLtb3f5A5wqwx0jLuzBuZb1rlj29uHBBDIiVmyV0jH7lhHXdv67rrKz4lAJ7cGPBRER9dT79Rxz7ozPzbPrtzBfBJ6UniG7ntBiq0M7mmKlxug9gwje7aTRvwQvwxzya41CrgWHlWICGhYqQBv+WsVFn57ORgmHZ8LOV/vbaQ2YQwSsh+X3iAso1tNW7cHvKhuFqhR9JOI2RXE4uMgLVSomU0Y88J+K7V+mWVRFudfhd4o1G7X11UMOnbiNyGHpoyrCTZmMBPUr5bGzuSsE0q2rpY8APucZOED/kHzAxDzHePEnJZQP9ZCf9V/S0SYpOM2977/EmUXgQl/5lAKmDGgsl2u/TO5ae/xrJ/F8Kwx0U+LvJYd9YdSki/P1IjRHmjxYQpLbmzfZtfDLUyAPwF3Qzy8zW42Fhoqk/um4gFx428nJj+ccXHLDg/w/7NvAauCZ1P8xnTGypZPoKnyHTA8VAOgTOIEICzxcIDQbWAiq7FYbL+RjdW4iqnzPHhVoW0pF0eVG0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(7696005)(86362001)(41300700001)(38070700005)(4326008)(55016003)(71200400001)(316002)(33656002)(76116006)(66476007)(66556008)(66446008)(64756008)(7416002)(66946007)(5660300002)(52536014)(186003)(2906002)(53546011)(9686003)(6506007)(26005)(83380400001)(38100700002)(54906003)(478600001)(8676002)(8936002)(110136005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ya4tXo05togyiv5O6kv/ktFCv9U1MuILCkztrXPmiVSaTdOGBCU0Kgkp6WVT?=
 =?us-ascii?Q?KkY/MHJ5oz3tXLnEpur8oUjazJifRKlLoZTl6/xCuGT9K9s7AZiEW39Yjaj5?=
 =?us-ascii?Q?biQNLkN+xP1u8nB2qlevmUpIcjQHcQd/ZiJdxeiVL/cbRtJ5yUUZKC5WOqDx?=
 =?us-ascii?Q?RxMFPp5Pz7sKhpcz3vyrpPgp21ZUyTodLBcLSwxi1q5jSFXZi7iDBIK4G+/e?=
 =?us-ascii?Q?cWl9sGHBEv+nTv+C0pStl1skNrD1TI/G/So7qGTANSnmpjTJTOCkxJkVQqR1?=
 =?us-ascii?Q?NFdZxkQ25ZqZailxM+sdJT36oL3ZUhT/JF72JLi4wZx9ihTVqQ25F2p8g0fY?=
 =?us-ascii?Q?3aTyYa0cEHsB/MS+BSTidwjwlhpxpZQxYRgQgjJdMWcvO1J0ufPB7lzCAlka?=
 =?us-ascii?Q?g/A8HBZowRZ8tvKegxKzEujBFkpMjut8NZy4pMp9xUztxWaJGFoRs0yQAypD?=
 =?us-ascii?Q?P8S/nJOh7ydXjhXbVKRBCdK/PHhJkZUOa3wgcXeynobuvgTV9uL1QctpCckp?=
 =?us-ascii?Q?7DUzxjE3GtAe03lsa22hQrGAMF3yaTGHQ/Lmi7kuGdMp6cD07y9nkyKKClcO?=
 =?us-ascii?Q?zYtbcZXs4cKD4CA7vH/gG3n9CbkxcpcKtPQnYQRCBa2NxB4kVJQ38q1F8k09?=
 =?us-ascii?Q?I4DBiwUi11d0A2sEx8ADlKbaO4Y+HEzMk+GG9upswD6K3/EhaQR4lpTNziZb?=
 =?us-ascii?Q?azUrkGws4sM7hp/LHurbTlhbiEkvKXjyLbSDHiTy4DWkTPKw11hjiMW20wPW?=
 =?us-ascii?Q?XLK+tf+ns3i4csr459SkWKjH02yBOmJv7rNFgKi3LRHRmwLanHzGPcE4SoUC?=
 =?us-ascii?Q?+pmV+Vr+g6kbYnMxCDAHwdEatNC+iLtiuTXBBFgDKdCRUuwY0c8EWp7oMRP1?=
 =?us-ascii?Q?whuotEcXNlQsUdtSuRVwtnerHDr1Y7SS1ZqWcztJjMpWyz+CPlt/XjuNxyWQ?=
 =?us-ascii?Q?WEovrMBeuzVaBgZmphlUYDNwysukCR+9AVjttB7NHmVSuKM193jf5yhZsG35?=
 =?us-ascii?Q?hNUunIy/xQO1Tvas3+CuOfoMWWyOg9GwrLE4DIgKT3cwy0o/3ejHwJITEGT/?=
 =?us-ascii?Q?xgT5eXWT+mP04w5SfruIglphlL8tfTQIcLG9XquhTu409E9z5/d4cESEAMvQ?=
 =?us-ascii?Q?aKrbz44EldIDIdRYbgJQiwwEkCIzNPe7zSCHFPjZJ0c+s9pL25KLiAetGvjd?=
 =?us-ascii?Q?/BZ/enZPydT5XkmzIBz4RQLtcd1s9y7OVYUejCFk0IF9JSGyzTeamrqM86Ux?=
 =?us-ascii?Q?iA7rDqALL5id+tL1qcu6awEvRemRS6+kiZ39EyrLO4dZzN9N/YnwGZvv4hha?=
 =?us-ascii?Q?X4eycatJ28+nkWNcF9odpj/j2fUta2Xa1hyV4ONkeGbNNZxpLW1KVLuOXr4w?=
 =?us-ascii?Q?cDUwEidzOEur2t0z7fU3jusskM7fuBkZOpMl3HUulLnDCaQW6NUcv6KpcUud?=
 =?us-ascii?Q?meW//BQrEFKhSc7kjG1cdLo99IoA8huPLSCWw8bz85VdbRDaSqbI03LzXOy1?=
 =?us-ascii?Q?/L4d2ywcHecei9sOsQHH3qc8jAnOLwTmUe/4chdkWfuOtfYZwrfb6cvyK1zv?=
 =?us-ascii?Q?cZFujMlK3lS8XQc0n3jO+fT9hwyV6ETzjpdBW5oMjwtPg6DAd1Tz1SL3C626?=
 =?us-ascii?Q?PQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 748e79f9-301f-4516-4fa5-08db616198e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:00:00.7698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bX8XVwR7BGB23EcIE8BJfl2EM/v9lF1yI6wFr5nVVH0uzmHCzkack59L8ivH9kKJTvQVK6tHYPeu9Fhjv9KEVcEydG1klNiMGX9GygpFO7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 10/15] idpf: add splitq
> start_xmit
>=20
> From: Joshua Hay <joshua.a.hay@intel.com>
>=20
> Add start_xmit support for split queue model. To start with, add the
> necessary checks to linearize the skb if it uses more number of
> buffers than the hardware supported limit. Stop the transmit queue
> if there are no enough descriptors available for the skb to use or
> if there we're going to potentially overrun the completion queue.
> Finally prepare the descriptor with all the required
> information and update the tail.
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
>  drivers/net/ethernet/intel/idpf/idpf.h        |   3 +-
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   | 143 ++++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    |   1 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 802 ++++++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 167 +++-
>  5 files changed, 1108 insertions(+), 8 deletions(-)
>=20

Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

