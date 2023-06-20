Return-Path: <netdev+bounces-12111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C86F736336
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D234280F83
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 05:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B274B1FB9;
	Tue, 20 Jun 2023 05:37:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D31FA9
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:37:42 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941A010D5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 22:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687239460; x=1718775460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NZ59iBqPia1HvippVIvArOgxQz46c7JaCIrySnR4mF8=;
  b=LMUVCzFzj85ufc4eVZ1po1HwgBmE5q4E2XfNM0DFaVxQDoKof9e1cfWQ
   av/LkWs86d4uaF46LoWXfiCRonb9r2opP1zQP8FKTufeZawYhf6YEYSLH
   M6LEwoI8tp8rYgH1uYiL4ZP9+/lq8pZKXpVder36dQWE/G0s/wCuDLRyY
   vPvxjNOXzQ9AjTjCNpUaYK0swBg/CCXnTanWrSzNkBkYACeHfoxTfl3Po
   BPDD2nOLZuRalEVwuHSzV+Y3DiqdyNzfsCtTBFF633HQUefHotJGFQqZH
   pFjP3gzv7cYp0oHUdydu00lz0lnAsdDSZqgA14CHl98k8e93LdogeFMNj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="339385368"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="339385368"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 22:37:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="779253195"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="779253195"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jun 2023 22:37:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 22:37:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 22:37:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 22:37:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C08hNRFKQxVj5umAPWk9VkBg/9/o5LP+Oi2dDTxdPyTbg+nLvTfT6femiyu1DFN2FaUAp3w25c7GK+JNV01ZArUHVOdDbCOFsI4/pTMB3ma/t3MkGaNAiwwKTIwSweb1XdDRmcL7plduJsSRKUYscjHnqGJ38oudb6ztHLAmyiXNg7NmidOpYWKQ0SYpKPa9xv8vHNdq39oav369Q+jk8W354DiVhQNfX9ArfqMIltWA92tDXgu/ugJLVSaQhMdib6i5N+t+TYsgp0hXbsKEarMFGJCSs5UixMyvnEWijFepTW1JaGObM2mXSqDFR+zmVYvwhjqCtNzA2Zja7/a19Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4rhc4Xdj47K7wxXaR0pxqtXWrEsLFaZyCnxByO9mVs=;
 b=UI+ej8hVYi9U0JVd4GKPtx4bkfPmy9Ixwjkw6mdSAMS9HihfukCiHme4pJh8grE39tW2GJc8ONCikESbFtrTiJlnNFFkJaR7joGoLPTtU6Cm35QGXj4iSGXqDqvFHUotuvEXmGIae/pOiP2/D28Es/4XrC5gnV+0BSHsVFHxX3pTlbgRrdbJ8+ZLOhr2so1ECjaBnXERahsvxK8PH1gqxXamHU2WcK48daBggc2E8pXd1egRPLui7HGBt3FF/SliAGl0W5IXOpKEW+xqJh0McKWfgTuVRsOX+/tlrqUq2SPR4b03cDo31ZgHWy6BnmcU64py/Ngr1Y0T0L8AGDKNag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7874.namprd11.prod.outlook.com (2603:10b6:930:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Tue, 20 Jun
 2023 05:37:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 05:37:28 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>
Subject: RE: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
 tracking
Thread-Topic: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
 tracking
Thread-Index: AQHZn4k/55og50Iaa0aKa6neF989Za+MBLUAgAEXw4CABhbRQA==
Date: Tue, 20 Jun 2023 05:37:28 +0000
Message-ID: <CO1PR11MB5089611BEE8A5E220A557488D65CA@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
 <20230615123830.155927-5-michal.swiatkowski@linux.intel.com>
 <CO1PR11MB5089B50AB69E2EA953E07FEFD65BA@CO1PR11MB5089.namprd11.prod.outlook.com>
 <ZIwfQ62nQFmr6RFZ@localhost.localdomain>
In-Reply-To: <ZIwfQ62nQFmr6RFZ@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY8PR11MB7874:EE_
x-ms-office365-filtering-correlation-id: d94f1744-7525-40e6-662a-08db71506fb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRk552yNyZOalvK75kkAlERd/ipIgQB1cdUwyUillnFhRaK0knJuCL9okLCmH53DbGVENRdQ5S9gqKncSDxmoZloBKED20cVMsUa+mFddEifUsSOBKcDh2V4yjZio4tmdb1m/Z8opHYxL706WHq2HaEafpJGTKBka00xVExwYBUYPHC6mjVKHrNZkJ4NhtYGlta5nle3LH20vsOPIAC0P+jnAf7v+BSv3meVqPPzk1v5lF6wjTow+UoFk/aUs3/U9W1nvvi1yVg29rI3tGgrUytO4BFB86VxjlIbTkzFFWvnqS7qOsg6fcMIA0Hgbz4Etr/0Mx92dzIa4tFGCsGvIQvibc7zoJDgVqjWachK097hDuuvzu0Qrq0rZoVSqAIrwVZ2yn0Vn9G47gvl2bYHjQ4t94mzO0qTAW+0CI1UkwzURynl/VSMYma570cIoc6sAuy+ySKCFf2bbpA6D8yB9gilZ+fwDfvdOBMDEMMsrd/SCFa0UrsXz14/TmAhsumSLGqReSSBuBueJeonTU5gX4b5MJEj0qOZlkUUNNeqO6Tz6Duj4zP62c6LRXPoL63QaEm3c90nSLUijqtwQXsugWcXeIy3mtjIBmniQykgViG5zb9hke+Cy9DkJU2jcSsM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(52536014)(33656002)(86362001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(66556008)(66476007)(66446008)(64756008)(66946007)(6916009)(316002)(82960400001)(38100700002)(122000001)(83380400001)(186003)(26005)(9686003)(6506007)(53546011)(71200400001)(478600001)(76116006)(4326008)(54906003)(2906002)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Ryp6nYIxi2VjVJH3l+/11+JS6oWmSPXzntrhOjgj6Be1yAxHJN2OtJ5tyco?=
 =?us-ascii?Q?mVCTgSMFaC+XCxgVnjazOrZeUlIaLxJ4Q78Up2p2nfIK6GJ/HmphTTV+YqQo?=
 =?us-ascii?Q?pPNvVyZT7gg4CE25jwt/vKGEvaNTrhdGiywXGPQVog7/OsGN008OVbYvs9Ml?=
 =?us-ascii?Q?2RH27TOCqPUgQql3l6Rag/dBWzM7hh7MOwt3AOglLYdTadVW92/2t8Dj0blW?=
 =?us-ascii?Q?K9DCAzZ5dTKfDRMJv8euzUALJFW59gghT0/9qXZhS6qcqzNCsCFegWIKX6Go?=
 =?us-ascii?Q?G0MqiOTvsZrdwKwyPWCqG3+jaIrGXhsnJbgisdQ4YgUz/9NpVYZq01/MnzCx?=
 =?us-ascii?Q?Kb/+vadCGqs3Ud8traoYuVp8DyjJpcqv3/Y8+qpfh5PTLKqr+36Cnsw3ZDpq?=
 =?us-ascii?Q?cnFV0qSJeCz5cTt384RYEFm7oSoT0iZ9jq7HLuw8cr/53QTI0KWonLzRuoyn?=
 =?us-ascii?Q?0+IMKzzt5p2pVwpDgolPD5rFxkGM6z79T/WSMZoo35oDTCw4jiFYHwsl4Ibh?=
 =?us-ascii?Q?InENu1q4PIiG7tR9WEHV409UHERZedVNsAxbaHcG/SU4B2NDgDTGlTN7FAnB?=
 =?us-ascii?Q?LXOGbXEHHy5VlFQTRm4edGN/R2ehWZQs32iZlPyX8utazFEOsWUjW0a2ySp3?=
 =?us-ascii?Q?KePpFjQNNEavtQverAc+qvu3V0ORaglBC3KyAJb4cGZaBZ/rEQ9v6WRFod91?=
 =?us-ascii?Q?jYW5Z16n6QA4gA2mWCmEeY66Fw5EreJp12/pQqaBYIVNSM4hZuYLKzsJXiMO?=
 =?us-ascii?Q?5tI+sDy4x6QOl7a+/HrRK7BzWG9C19QUeovIa2DAYFSs6z5V3G4nqYfsxcQ1?=
 =?us-ascii?Q?F0PCTQQDrQPK8QiOuhQHEgGhErWPxBP/jTbZe9P2tg6TgGWAkIYNL6cLqs69?=
 =?us-ascii?Q?yx6BB+nT/THwf+SLf1WDlhbot2tSGb1jpJjCicPSabcgAd6RTCfA9mHSDYFE?=
 =?us-ascii?Q?nsUs0Hr7O9kATX8qRz8jTOyrj8jDtsz1hA4RWQ7GNqs8rlCYALbAhb5Zb3kt?=
 =?us-ascii?Q?UpVTuSdDYAO8AqAvfmr9Tv2Kbr2oW1R1ixPjcUR/1h3ajxgZupZRnwUIxWUc?=
 =?us-ascii?Q?pkVtqdYfNmMcL6pk8GMYgxoQh2sICjhpMOY4mPcLuqDF6dRGtcSp5dV94zRC?=
 =?us-ascii?Q?eNnXZCSU04ZJk5h5dDJeOLj45jh8XpRzGiIK/wZUjsi2aXJGdC2dtMnxxwpF?=
 =?us-ascii?Q?WCvHEjns8Q4st+Ji1e5XdWhPk0jEbcVupQ+UnNsuunmbGlTgRcX/FaQBTN/Z?=
 =?us-ascii?Q?vN2NlbhV60JE2rmNdp01Lrj2P6hUhUP7h5rbzFDp5n0oF6E9oq8XjqaoyIVn?=
 =?us-ascii?Q?7Oyjd1mc4l+AOUgpUc04ZqUaF2Gyam3GDJ2W3jiEYXlrT2CQTqfwgSoNbzd8?=
 =?us-ascii?Q?Omku6YWXkAMgkt6BUuIZ3Qomkkg5lXsk7iVE8fpjAowKi4XNTFstv3m6dtHJ?=
 =?us-ascii?Q?x3kFDqjUTD83duqVg4NhZZVuYevS2aPyriao5grvo/fAAkNDogQCWyCJBfZx?=
 =?us-ascii?Q?8rfzlvSNiwsQB8OngX+2+082BPJk7wABW9GHF9B06oU99cAc8eZmGvtn9eT8?=
 =?us-ascii?Q?uiFuJZzItoU9Y1/lZEm5XkhSRBScyiIHptuOzTN/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94f1744-7525-40e6-662a-08db71506fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 05:37:28.8596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XG5KjMT53e8rgCBFeImHZCC7p6i5O3aSLQV/LtBcAaHCi24JPajnzUznikrN8Qm1nek8AUkgj8LBY4LsDQqBXe3UXsC/XWZmNLR/C7tP3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7874
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Sent: Friday, June 16, 2023 1:37 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Kitszel, Pr=
zemyslaw
> <przemyslaw.kitszel@intel.com>
> Subject: Re: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
> tracking
>=20
> On Thu, Jun 15, 2023 at 03:57:37PM +0000, Keller, Jacob E wrote:
> >
> >
> > > -----Original Message-----
> > > From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > > Sent: Thursday, June 15, 2023 5:39 AM
> > > To: intel-wired-lan@lists.osuosl.org
> > > Cc: netdev@vger.kernel.org; Keller, Jacob E <jacob.e.keller@intel.com=
>;
> Kitszel,
> > > Przemyslaw <przemyslaw.kitszel@intel.com>; Michal Swiatkowski
> > > <michal.swiatkowski@linux.intel.com>
> > > Subject: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
> tracking
> > >
> > > Track MSI-X for VFs using bitmap, by setting and clearing bitmap duri=
ng
> > > allocation and freeing.
> > >
> > > Try to linearize irqs usage for VFs, by freeing them and allocating o=
nce
> > > again. Do it only for VFs that aren't currently running.
> > >
> > > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com=
>
> > > Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_sriov.c | 170 ++++++++++++++++++-=
--
> > >  1 file changed, 151 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c
> > > b/drivers/net/ethernet/intel/ice/ice_sriov.c
> > > index e20ef1924fae..78a41163755b 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> > > @@ -246,22 +246,6 @@ static struct ice_vsi *ice_vf_vsi_setup(struct i=
ce_vf
> *vf)
> > >  	return vsi;
> > >  }
> > >
> > > -/**
> > > - * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the=
 PF space
> > > - * @pf: pointer to PF structure
> > > - * @vf: pointer to VF that the first MSIX vector index is being calc=
ulated for
> > > - *
> > > - * This returns the first MSIX vector index in PF space that is used=
 by this VF.
> > > - * This index is used when accessing PF relative registers such as
> > > - * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> > > - * This will always be the OICR index in the AVF driver so any funct=
ionality
> > > - * using vf->first_vector_idx for queue configuration will have to i=
ncrement
> by
> > > - * 1 to avoid meddling with the OICR index.
> > > - */
> > > -static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ic=
e_vf *vf)
> > > -{
> > > -	return pf->sriov_base_vector + vf->vf_id * pf->vfs.num_msix_per;
> > > -}
> > >
> > >  /**
> > >   * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
> > > @@ -528,6 +512,52 @@ static int ice_set_per_vf_res(struct ice_pf *pf,=
 u16
> > > num_vfs)
> > >  	return 0;
> > >  }
> > >
> > > +/**
> > > + * ice_sriov_get_irqs - get irqs for SR-IOV usacase
> > > + * @pf: pointer to PF structure
> > > + * @needed: number of irqs to get
> > > + *
> > > + * This returns the first MSI-X vector index in PF space that is use=
d by this
> > > + * VF. This index is used when accessing PF relative registers such =
as
> > > + * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> > > + * This will always be the OICR index in the AVF driver so any funct=
ionality
> > > + * using vf->first_vector_idx for queue configuration_id: id of VF w=
hich will
> > > + * use this irqs
> > > + *
> > > + * Only SRIOV specific vectors are tracked in sriov_irq_bm. SRIOV ve=
ctors are
> > > + * allocated from the end of global irq index. First bit in sriov_ir=
q_bm means
> > > + * last irq index etc. It simplifies extension of SRIOV vectors.
> > > + * They will be always located from sriov_base_vector to the last ir=
q
> > > + * index. While increasing/decreasing sriov_base_vector can be moved=
.
> > > + */
> > > +static int ice_sriov_get_irqs(struct ice_pf *pf, u16 needed)
> > > +{
> > > +	int res =3D bitmap_find_next_zero_area(pf->sriov_irq_bm,
> > > +					     pf->sriov_irq_size, 0, needed, 0);
> > > +	/* conversion from number in bitmap to global irq index */
> > > +	int index =3D pf->sriov_irq_size - res - needed;
> > > +
> > > +	if (res >=3D pf->sriov_irq_size || index < pf->sriov_base_vector)
> > > +		return -ENOENT;
> > > +
> > > +	bitmap_set(pf->sriov_irq_bm, res, needed);
> > > +	return index;
> >
> > Shouldn't it be possible to use the xarray that was recently done for d=
ynamic
> IRQ allocation for this now? It might take a little more refactor work th=
ough,
> hmm. It feels weird to introduce yet another data structure for a nearly =
identical
> purpose...
> >
>=20
> I used bitmap because it was easy to get linear irq indexes (it is need
> for VF to have linear indexes). Do you know how to assume that with
> xarray? I felt like solution with storing in xarray and searching for
> linear space was more complicated than bitmap, but probably I don't know
> useful xarray mechanism for that purpose. If you know please point me
> and I will rewrite it to use xarray.
>=20
> Thanks
>=20
> [...]

My goal wasn't specifically to use xarray, but rather to use the existing I=
RQ tracking data structure (which happens to be xarray), rather than adding=
 another tracking structure that is separate. I don't know if that is feasi=
ble, so maybe having a separate bitmap is necessary.

