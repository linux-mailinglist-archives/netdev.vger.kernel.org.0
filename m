Return-Path: <netdev+bounces-11141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A9C731B34
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1D3228139E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D0E171C8;
	Thu, 15 Jun 2023 14:22:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04233168A2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:22:52 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B88E26AA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686838971; x=1718374971;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ff55wUHsFQb/K5W0ssg3IH4KiFYextGEmJZTvJ3vEoo=;
  b=MMi1OsjEmN/UkNXHZgLYJpSbdrnJNPBho5JaW/okBU1/Zi/2ACSzy2Em
   lah2NaQSd2HiIHWyl1bL1ZkM9lGHcvL+HKMQzo0m8XzQ5JyuA10PcYBX8
   aKk5nsG/u5nojkYYmzOJ0sdp/3ri92p91xUg5D3lTovayK2FtNtRLcg0A
   l931v3T6XWtEXBrQImvRWptE0Hi4grxrIQFWmPMaTZE0GmVaW9QPyqQKJ
   KTFZ/wj1Ks5BcGYQLSNnSPhYL938FzLBusDNsGaMhW1x24NQGAf2QqJr3
   6fxPKCyXZ0jM52XUy3CsLze0OQ6DdoFivQ0iFEPIQGehIGoMrl309TOvj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387418564"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="387418564"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 07:22:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715644298"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="715644298"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2023 07:22:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 07:22:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 07:22:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 07:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp9MXo//LEHC+vOMW+eqpL453BhcNDcMbQ5bXN65Hjay9KqRMpgUftr09/nopRTe0WRBG3wMLL/ZJwBp5GkJswrgv4kaQEGo8Fdo7otlmxwxySmKLHiLCWALe9QEkEdZHZXOdyXjwj7DIW1vyAqgtx9X3J47E7PTMstr3HZVLmGWTJlZThEFEdTNuryt/w1DEINtcoffwGpD11GV0YCGC9KfVlMSRRGaQwnpLQ/8H1Lg5a4EEq5HXdJ4A6quSqpJrljme9JABDPPINEMXxHhdp2PCRnfE4+/p/T3KeZI7eLNup4tWtwd8gtwfJ1r4t++QVYFCWrvL98LBAsOw+KYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/ji4P6BHH28XlIP2GO69RBIfZX9oHWRTfyGrpceCRg=;
 b=i0hdFbLnq6Mws3creOmIqKyX8lXXlpToKE5K/nZWo7I4ULTjuCqw6F0WuINaRx59I/3VBbcCwemMxy8KgBj6KIYuOx4NdoHpdd4sahyNyqYnCt0MM3IElJkis9RcK/7PARWQybX6uMDMo68KuxgTfVlPXR7xlIAOTo8EP+dRUcor8E8qHI+UNdUQ+Ubrpjv71q906AZ0BSFja+4Bq+G9uL57h809+Bef0gE+uiAEwapsOQuZRi+GM2aXTBxHks7wdCBZuhjSYOI1+5njBhSXdHos6qvtq6cvDRvrKvUGE9siSSu41qbmNevGiZ1dffkAXOza39eBRC0MmyIHEseEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB4974.namprd11.prod.outlook.com (2603:10b6:a03:2d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 14:22:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 14:22:47 +0000
Date: Thu, 15 Jun 2023 16:22:35 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<przemyslaw.kitszel@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v1 1/4] ice: implement
 num_msix field per VF
Message-ID: <ZIseq7r5alm5DctL@boxer>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
 <20230615123830.155927-2-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230615123830.155927-2-michal.swiatkowski@linux.intel.com>
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB4974:EE_
X-MS-Office365-Filtering-Correlation-Id: b26df60e-cf10-4f89-b377-08db6dabfe24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jf+AyFBKND50QGeoF1KHJBEZoCtnm8uqeppQydLzWVVO2SrknurL8RS/ykSZxTSsiMVvaNoUWk9GVEgfmNxSCuB8LNZY0MXfBoBSEwLk0fIRi/K2/ykcSEV7Yzg27I5+4dWotqDBwtVg5oGpMXgmiRO1/Er/Vymh09YOgMxitTZnrw/VShCs9GGKM1MBpaf9YHU9r/YH0CymD5BOWui6r921A82AquBhzHvG+orGlls3n0yeTBrFmunz+aTUR+H4Fyuf9G8sqAIlhTR/aKkCfeDvtuTrmwba+giupkibi61zXCs7dPq3KYIz2ecS51TvQikWMj8YHMUxsiWc77rheKHTlzmvsANZ2Q9aWL33QUAl9g9a5RK6nz3P1IHHvOvVWOI2kgs+BB7DjHJZ69egZaS4CfIbjDN+a1ajQs44fZ7XQdISwc3JS33LyT2izcCWnKoTQI8JMroNO62tJltU32mdPdt82X6dC8LYmyKMOdFf0SKw0OlcrQRBCMi1Z3j+8rdjN31WkUFAXmaL8wpm0lS1mePtQpsWRHBLq7MH0zw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(5660300002)(83380400001)(186003)(6506007)(33716001)(44832011)(2906002)(966005)(6512007)(41300700001)(8936002)(9686003)(26005)(8676002)(6486002)(316002)(6666004)(478600001)(82960400001)(66556008)(4326008)(86362001)(66946007)(66476007)(38100700002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LIvJZUfmASgXEs6DRJ7cTuRx9USMs3IrzycPo5KK7DAWlSwWrJZhZZ+e7+ul?=
 =?us-ascii?Q?Jr8gZuzlTJgJ4o9DoxmWkOPKAFcjVHRMwtcG9a42sNixRhX7UoXpbu3wm03g?=
 =?us-ascii?Q?18ccrmxn5qpX+u38pu0WEGrQ+xRbj9DjC34aX7PDHUgBAzG48m/CndiIiukQ?=
 =?us-ascii?Q?1jC8EVFVRxd/63jsraR4NybcfkZWnXqj1fZgxodRKitoeWHSaFkcgpVaNRQM?=
 =?us-ascii?Q?UdN4bn7zh6nVYih1WcxlTqggO8OiuN8oPbDhpVcwrltT3cuz2ttrvPb0bGl6?=
 =?us-ascii?Q?RAg8F/gqLBjzyMFC7oXqABC12+C4azKGJyvAauklJ8KphSmP9rzq4zDoj/bn?=
 =?us-ascii?Q?kVKdWkX12xoG9cQZ//7gK2AQCk38kjABl0TuFeJwiNfQV+19ycU7PCDwrfTN?=
 =?us-ascii?Q?nFzLw5l1wLFU6U0bB3IzQBhfD5d96ckkSAMHLYi3ifeu5CWkyZ36UgWJCCNU?=
 =?us-ascii?Q?3ChpfXhWjhkutya22f/Vkx691fUMkbcQAk4edf7+eQps29Py8y+X8aieK3/b?=
 =?us-ascii?Q?lOV6IdF1lXT/4Xjnw+Ar1FGCMt1LEAPn8pntqjAxOzJAj2vD7JiW9MdbCbTE?=
 =?us-ascii?Q?TCqfAdmBW83Pv2TfyoRTQwXFXOg/ml+8lpvElPRWQOVTOQhv23CiDHb86orw?=
 =?us-ascii?Q?rxWAoOY9tZ2XEw5XESMfaHRV0SRmZE2FAgMWL9BBHxko35T8cqmYsuEPwK6s?=
 =?us-ascii?Q?Fb+CqJT1v8uNHj6xa+9aIUsh4jrI6ovJD4LvB9pmJhiVrx87sD3kzM415OCx?=
 =?us-ascii?Q?CHunuoDMoVuwd6EyC+bU6qk1gJTkojqIWuztwecxy0T224K+38uI5++12ORm?=
 =?us-ascii?Q?zaDyF9PgTUZN7yNnF+3vSlyp4qjrQd8O2O1KuY5gPe/91Mw9SN0NDWllK8/m?=
 =?us-ascii?Q?lkCyq+pgmDfGoc7jEpYmnQX437OIBTrpbhyfeEWKXYUKnRLH9C5ERSjBai5l?=
 =?us-ascii?Q?7WsIIiqw/OPLTwt6z6zBuPuEVU1PgYH3Qb+YVPdNcezWMXfm9ZAjDi/doEcr?=
 =?us-ascii?Q?PHJnTaILIbaiWpGXD5kzggn2Zeg3jBoafdYBFOdoAHyoNBQLA+G1KS/hiQWy?=
 =?us-ascii?Q?8n36tduVF5LMjbgWhX4C/J7Piw8ex1wdEC/RAV7mmkSTBid8zzhO9DzVrUJ8?=
 =?us-ascii?Q?nKhvdWsF/iJrDhsNTeFCrJ5eyKFYqdDu8FFutzj0gLm3UFdp+Y2vdfDyQ1nA?=
 =?us-ascii?Q?Myn0hEd8yxR1tiGWkUJk+HeA6djudxmeB6+RfHFga5KI+t4WLluZQj7F3ZAP?=
 =?us-ascii?Q?MBOInRSSBfWhEg2Kj/seXHhON4jNm+TzL6RCpKTMLa3k/SbARf1B0jeGuRtP?=
 =?us-ascii?Q?uBRdq4PR8Dn2fJ7AY2HU13Hm6pypJnlpM2HnUoVZbRSjIHRGeXF7u4zM8L9H?=
 =?us-ascii?Q?t7gD/Q/bb91ORMdLLmZtesiw+eQ01O1qIVR7IyliAoCAKipxdjq8p45PH7v6?=
 =?us-ascii?Q?YHct6SEr2sspJ5S67V4MUMZAucRb7UeydWnRd835DP6qzcxlw70phtptFFwI?=
 =?us-ascii?Q?Y8RnEnPkOa8qr0xjC07k4W2JYVkVg2i4C2xDeEbnzMVtU0QIZ87X+heL1Z1g?=
 =?us-ascii?Q?QP1HP4Vbhxa67L3uGzVuVOmX5k7nEl73D7vktME2vgVG/UCWIn/V0ZIumIa/?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b26df60e-cf10-4f89-b377-08db6dabfe24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:22:47.5091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7U8cOWiJeM3Zw2wX0JrYL9Eq3wAeeUj8SKeXbcBYjD24ZMquabUSHtea9gjuErrtPR1wzwg+z6O5i4tbrUOY0LegSu/lzo9KK6OKqHFI25k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4974
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 02:38:27PM +0200, Michal Swiatkowski wrote:
> Store the amount of MSI-X per VF instead of storing it in pf struct. It
> is used to calculate number of q_vectors (and queues) for VF VSI.
> 
> Calculate vector indexes based on this new field.

Can you explain why? From a standalone POV the reasoning is not clear.

> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
>  drivers/net/ethernet/intel/ice/ice_sriov.c    | 13 +++++++++----
>  drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  4 +++-
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |  2 +-
>  4 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index e8142bea2eb2..24a0bf403445 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -229,7 +229,7 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi)
>  		 * of queues vectors, subtract 1 (ICE_NONQ_VECS_VF) from the
>  		 * original vector count
>  		 */
> -		vsi->num_q_vectors = pf->vfs.num_msix_per - ICE_NONQ_VECS_VF;
> +		vsi->num_q_vectors = vf->num_msix - ICE_NONQ_VECS_VF;
>  		break;
>  	case ICE_VSI_CTRL:
>  		vsi->alloc_txq = 1;
> diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
> index 2ea6d24977a6..3137e772a64b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> @@ -64,7 +64,7 @@ static void ice_free_vf_res(struct ice_vf *vf)
>  		vf->num_mac = 0;
>  	}
>  
> -	last_vector_idx = vf->first_vector_idx + pf->vfs.num_msix_per - 1;
> +	last_vector_idx = vf->first_vector_idx + vf->num_msix - 1;
>  
>  	/* clear VF MDD event information */
>  	memset(&vf->mdd_tx_events, 0, sizeof(vf->mdd_tx_events));
> @@ -102,7 +102,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
>  	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), 0);
>  
>  	first = vf->first_vector_idx;
> -	last = first + pf->vfs.num_msix_per - 1;
> +	last = first + vf->num_msix - 1;
>  	for (v = first; v <= last; v++) {
>  		u32 reg;
>  
> @@ -280,12 +280,12 @@ static void ice_ena_vf_msix_mappings(struct ice_vf *vf)
>  
>  	hw = &pf->hw;
>  	pf_based_first_msix = vf->first_vector_idx;
> -	pf_based_last_msix = (pf_based_first_msix + pf->vfs.num_msix_per) - 1;
> +	pf_based_last_msix = (pf_based_first_msix + vf->num_msix) - 1;
>  
>  	device_based_first_msix = pf_based_first_msix +
>  		pf->hw.func_caps.common_cap.msix_vector_first_id;
>  	device_based_last_msix =
> -		(device_based_first_msix + pf->vfs.num_msix_per) - 1;
> +		(device_based_first_msix + vf->num_msix) - 1;
>  	device_based_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
>  
>  	reg = (((device_based_first_msix << VPINT_ALLOC_FIRST_S) &
> @@ -814,6 +814,11 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
>  
>  		vf->vf_sw_id = pf->first_sw;
>  
> +		/* set default number of MSI-X */
> +		vf->num_msix = pf->vfs.num_msix_per;
> +		vf->num_vf_qs = pf->vfs.num_qps_per;
> +		ice_vc_set_default_allowlist(vf);
> +
>  		hash_add_rcu(vfs->table, &vf->entry, vf_id);
>  	}
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> index 67172fdd9bc2..4dbfb7e26bfa 100644
> --- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> @@ -72,7 +72,7 @@ struct ice_vfs {
>  	struct mutex table_lock;	/* Lock for protecting the hash table */
>  	u16 num_supported;		/* max supported VFs on this PF */
>  	u16 num_qps_per;		/* number of queue pairs per VF */
> -	u16 num_msix_per;		/* number of MSI-X vectors per VF */
> +	u16 num_msix_per;		/* default MSI-X vectors per VF */
>  	unsigned long last_printed_mdd_jiffies;	/* MDD message rate limit */
>  };
>  
> @@ -133,6 +133,8 @@ struct ice_vf {
>  
>  	/* devlink port data */
>  	struct devlink_port devlink_port;
> +
> +	u16 num_msix;			/* num of MSI-X configured on this VF */
>  };
>  
>  /* Flags for controlling behavior of ice_reset_vf */
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index efbc2968a7bf..37b588774ac1 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -498,7 +498,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
>  	vfres->num_vsis = 1;
>  	/* Tx and Rx queue are equal for VF */
>  	vfres->num_queue_pairs = vsi->num_txq;
> -	vfres->max_vectors = vf->pf->vfs.num_msix_per;
> +	vfres->max_vectors = vf->num_msix;
>  	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
>  	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
>  	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
> -- 
> 2.40.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

