Return-Path: <netdev+bounces-6610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9917E717139
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B8351C20DB5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A00C34CEB;
	Tue, 30 May 2023 23:05:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878ADA927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:05:57 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C9125
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487951; x=1717023951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JntMY9OAkhkjWl+0+iH78N5i02dyrrzrTV6ITwpyCv0=;
  b=dk1BQ5Ty3HSvFunx0ZcJ399eosOugWUIIuiS6BqCWlRhmUO/3DJEfA0X
   aArMFEbDKEQQGSjKGGuXHNI79yy0A5sHShA1DTTv9CLgU38quaHev/bga
   SCElqVwUrtDrL+e3UYOO+Ccx90fgCQeykxMg8Y3npYpi8Vb1+CyrSCpI3
   shZviGHZpzSYZNCxlmYCg1EBFjUP1aa+6F8nRCWafPE6MqUG+owehvdia
   mqKGSWp0FweP7Rbbw2YVZSGK8dx/lr9MfXb6xY9dEyvzdJUUT74ewW8XQ
   o6UQErSksRTtDnY5MIMwYb0Xs+C4STCfx2ZIactINmMMrL0G9q5noLBK2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358328789"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="358328789"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:05:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="709809487"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="709809487"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2023 16:05:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:05:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:05:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:05:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ee19JshxSvHCUrSoaujbrnSAhZ6pOIbMdzQHzKI2bKo+MLxEO6N0syRrh/mAN0JgCkTJodOe3eGJQ06asNNE2ydKsyK36fUw6eKCTCjzfnyCOFNfcT5BkO89rpGLdDcLfy2CsFgtNeIfaX6lsV6tfGlU8EThH6Ik5KSZ40LdaytL3H94KL7AW5mxgnIPJEGfUvTln2iNrx+b7b4TSEB+Gn4zACsGU2++6BAg9tUKshMBmZjCbwhvjdcg/OvgLcw46ysPvoO29PQanMmUwpAA7iF7Y9lH8fW6mZVQ7BrPFcUbnZXcukyZb7+6IXDcTdZqxM9T3i6D7oAZ+f3jXdynmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09GACKQW0jXma0FNK3nlLpDN7AJQMhe7dcz3P99fRz8=;
 b=Q58/xHPeTZ7aJmJpzVW9ZxNplb8a7BFgXZUf56piiyeZOs2Iak08zYazUIPeUGYb+7aHaOJAPQliHD20FVbbiBeTMQm4k7cWe4QRgWydX6vi5aDhkgBFxp8jegANmqlcPAjdhnm9P/bhM7rS7jDQHrlAuUXZSKYJYM/wft4BzUAmJQDAtTFwU1aVYOyIvrWAiEzzpjALMRat/X03YOjuhE3TDJOVaGqCiCGvZy65gMh2uzDuZUrQarMplLijMJJFRQ6zzNUSbbQYDWyFt+QeeWpr2/EzjHZxKurmBuW5QQBRjk2/4c8hl6dfgylZ0r1c3HirE4h7L+64zpPOENZVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by SN7PR11MB6897.namprd11.prod.outlook.com (2603:10b6:806:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 23:05:48 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:05:48 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 14/15] idpf: add ethtool
 callbacks
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 14/15] idpf: add ethtool
 callbacks
Thread-Index: AQHZjQ15vDf9dOn6vU6z5fA3zGgJCa9zfFEw
Date: Tue, 30 May 2023 23:05:48 +0000
Message-ID: <MW4PR11MB59110F063588D4DF829A305FBA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-15-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-15-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|SN7PR11MB6897:EE_
x-ms-office365-filtering-correlation-id: 62879c0f-2050-40ce-2d97-08db6162680c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EvYHV+n5OulE1burs//aPwug7+4BDv1BmzL2kdo05lKzpatiO/u2ZId/0+rr0VdICQLGyRQFrw94PLYQqvI/H8H2scNb4JdR8jWz3KopGOdgRI2deIPsJEj8wDMaVDjbraMTeN5/dCDDYOzXGSi33avXYU3wIBrFYFJxVJMLzYKB3f9wJVwzMfATIa3UZMQqqFHnh70d8dZeaeJPII/RYObsxDeP3KecywAJYp67dOhjQhXKiO/lzveHM0s2B+ldJSLRVOqC/O08+thNDLhmgCumI1DsXoNN+rSUfG8kVch8jJaJRKyLCaHnT2ENxnDxtMcYDqe0SsFnZc/9B7/kSEznvfIkPzz8m4BHgLRUzqA8dPI/ptIk2IolLCs87boPL6Fo9OrmemOM5fZxIqRDcSOMN2a+ngGORqRQX7Byrd4koS/s11ywx6CKunfM85LkMSW/xrvmfzkTPKiidYFv+hmBlkqXM6fEDWDBc5Zq50ehWAz72MlFGR2i9G8aVlwQNc3wfFY3zcKeCEMEGqGJa2TQrctKrCENDappAsIJCeV6WGewFZENnHMY0QmVwfR9aSLht2OgIuQ2o/HHy6s9bAETtL9rNCvedZ3m4WCSnCrYjnZVwDJXk1kA/XKQVnmj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(66946007)(4326008)(7416002)(76116006)(66556008)(66476007)(66446008)(83380400001)(64756008)(52536014)(55016003)(5660300002)(38100700002)(86362001)(41300700001)(186003)(8936002)(7696005)(8676002)(122000001)(2906002)(38070700005)(82960400001)(71200400001)(6506007)(316002)(110136005)(26005)(53546011)(33656002)(478600001)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dBI3ruLsHG47VIw9Ry4gOWDmM67d++4vtW61OFFDN1N7+AAZLoCGv0vC8ExK?=
 =?us-ascii?Q?oJAY1XihgzS4pQHAy6uBgCRpVU2cG4bvL4qQ7CbLSQLVBx0wh4AI7gFtcthg?=
 =?us-ascii?Q?FVRFe5/0tscyOKPyRNi6g85fYF2D8t/DF32BjfYQT7MTyaFH8OR0xCkYjSfK?=
 =?us-ascii?Q?WCXvTjvsryjcFIaSU6BprrAaqNPNGopc73GnoySYNCmVlxgT4Uduemr7nLdF?=
 =?us-ascii?Q?7i/Ql+R2gF9Wfo6y+N+50C6/QBVj3zp+gfmg/V3FoF4QtuNhhnLEtwDFz28T?=
 =?us-ascii?Q?y79EnffIrXSXeIk/FLrIgxdTWQXXfUJLzM6GFv5i/BO25yjjlD+3Z2Aif+dy?=
 =?us-ascii?Q?vep9xl79mXhOPlGZX6X0kPA0eTcy04x04uZVve59acoB6y8E2rmCoC58xPlx?=
 =?us-ascii?Q?zgQOsqsOENzkSk1FzTCttDiOGEDDQ+MMyx93ZIIsnIfoQ36oOX/EpYbMEi97?=
 =?us-ascii?Q?Ao6GZsLRWjh0YLTFxCiSrjX2mfhyVh4kWYlX2Yj/3T0D1RVfn5ZXpvbVcDN+?=
 =?us-ascii?Q?VLBpEt5PuoC37iPsNSvqAUtMhK5AlVS7uz+jsn+hP6AzClFx2izYMUxeyv3y?=
 =?us-ascii?Q?0VTW5ub+1mtyrOkBvf0dSklX2fDMQGcndyTCGQtf9Jkyo/b3QB+5Mr31Fpcd?=
 =?us-ascii?Q?IJf/R8qb/MQosV2wyfxtKradi3bEctYY5sD93K/u6IxpUjTLFTHjZmub4ulI?=
 =?us-ascii?Q?lBVVBzfJgWJoaqQeN6vHWzAhoUgJ0fQvlpL5VYTpisTz4Yth6PDFCQOpkPpg?=
 =?us-ascii?Q?NCbnoLgumLJWUcMmmaXgo26HokUuEBdgVNSNZ1xTEmILNH9rFcNM2j7YNEiS?=
 =?us-ascii?Q?T7JHYL3KyaBLzRiaKQhM9YDCs4C5m5u0DLRJVai58aQsL/NTL9MxJ0a4GfX5?=
 =?us-ascii?Q?fUzZUUfoR0Kgkce78oucurUPQc17zqEfukQaBhGoLsOMsDbUm85kCOLl3wh4?=
 =?us-ascii?Q?Nw0bel4dGu+jA/AGJQOP+tUGr/SSB0dY89qdL2wqOtdS54EZJv7Jeq5tpqGG?=
 =?us-ascii?Q?7FvB2aSDGJkMs2AcC1Mi92RzxUMOt34DpTPpNWm6Pa3paHxU7sSp3c7uO1TM?=
 =?us-ascii?Q?mbTDYJDu9IbwXGXFhJqcjMOU26SDAWDnA6hGAI8VQF9zA7oB0knc1H+fX9ja?=
 =?us-ascii?Q?rbu0gzedHCftqJg9vPBbwbZ5ccT9Vy8RbaAm417rbPxyJbYtsGjBMpCGm2H5?=
 =?us-ascii?Q?FB3wnzvhVQBE38pvmWFXbaz/yisTPBKgIo5m+BhCagi/hJxVYc+T/Xgguk9X?=
 =?us-ascii?Q?B8wPpPRdkgd/hj3DzeRPHj1jxKaBBFkm20AO5pjnyjLsaU9kCbtxVlfmk9AN?=
 =?us-ascii?Q?LbRzV2AxlF0EAIppKcAjzMzrLaYUrrmLgxnFseVAsknxUVkwyly4Byhg7rki?=
 =?us-ascii?Q?GV9ddMd1FPjfN8LerQ7MJtba9sos7fqN+N/UmBSlsO8jVl7SdcAx0NwR/ed3?=
 =?us-ascii?Q?3sLsBgmf+X7ZIZ3GGsV/uY65JTbICuLEsfMIdtLnWkWz52uz/MzbyApYf9kv?=
 =?us-ascii?Q?zKbOWUR8sdJFI9L5Xk5LaFqxY8ltRYbuWHnizmQrP5DdroOQkt1ROusGUsdh?=
 =?us-ascii?Q?/da4iA3q5Djp/CE1S0iN+GNj7dntu03hf+QEELb9DIMKL5xY84ue8k3ohyEh?=
 =?us-ascii?Q?7Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 62879c0f-2050-40ce-2d97-08db6162680c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:05:48.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vP9tt/gRHOrMBmgN6hhKG8FTO25zz0yTJGyUKs8IegHHhLJyTFy5dqTwje0pJoYZn3Xo9fu+oyJwuENhrRQHHkExCSQGEZemHU/+cl9H+/E=
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
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 14/15] idpf: add ethtool
> callbacks
>=20
> From: Alan Brady <alan.brady@intel.com>
>=20
> Initialize all the ethtool ops that are supported by the driver and
> add the necessary support for the ethtool callbacks. Also add
> asynchronous link notification virtchnl support where the device
> Control Plane sends the link status and link speed as an
> asynchronous event message. Driver report the link speed on
> ethtool .idpf_get_link_ksettings query.
>=20
> Introduce soft reset function which is used by some of the ethtool
> callbacks such as .set_channels, .set_ringparam etc. to change the
> existing queue configuration. It deletes the existing queues by sending
> delete queues virtchnl message to the CP and calls the 'vport_stop' flow
> which disables the queues, vport etc. New set of queues are requested to
> the CP and reconfigure the queue context by calling the 'vport_open'
> flow. Soft reset flow also adjusts the number of vectors associated to a
> vport if .set_channels is called.
>=20
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/Makefile      |    1 +
>  drivers/net/ethernet/intel/idpf/idpf.h        |   42 +-
>  .../net/ethernet/intel/idpf/idpf_ethtool.c    | 1331 +++++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    |  158 ++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   |    3 +-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   14 +
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   |  248 ++-
>  7 files changed, 1792 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_ethtool.c
>=20
Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

