Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD54E9E97
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244192AbiC1SBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiC1SBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:01:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5093DA59;
        Mon, 28 Mar 2022 10:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648490380; x=1680026380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A+MRLxHnzL5u6D7IuuUI2bVOWgeMJ+GIIl1u1wIMXQs=;
  b=P47xE1MKtHyo0P5Hv2sx1ICsdrlPz6+xAEJxkX/sXay6z6IZj4pqmgIU
   a7UTvTejWC8heIPwphKOdQPuSimFsP1qum2tRxixSfIOcpOqmtBCAtD5X
   7I2ZCq6dV/GtSDdlqcM+3eStFzAzmyKvgYiki66oQLFE+vwBv81C1uxg2
   PIdpPB9JemuEwrjrjXmgpbZ8OUAGbMB1Wa7HzBSxb80HDrBEybmoQ5dj3
   qD9RuOQyiWQYuHArRoN+fiOUbbZVPX6p3uUj5TKlfBrVZifkzR8gm+qXR
   /3abbLAUZS2ssP+f22waSbmQ7nIfWJyti8Q+LdMaEBGRHpn3DC0klQ4FR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="259039017"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="259039017"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 10:59:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="652228554"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2022 10:59:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 10:59:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 10:59:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 10:59:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 10:59:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHAhYpwBD4uYlu9rbLH05aAShTcRaCURgAkpyHIEOmE8peVifuraKvlgibMwPw1x4BB3ZEhRpXUXK0mdixElFujFVT46POWD/anal1eBmkBEf3qPO1bXv2VE9Vk1WdlTiZbP6tR40+GztC/q+kuez2enLl1muI9b7HUcLiyRHykcWQYr+pWIEW1s/Hhj5j0f4yPICxsbPLtwCADku1S3ntsCY226ws8LV/ZdxR8XUz2wJ/3PZ8JW/BLqMkV3BiCyISvy1bYyV10jvwyGfOR88r5IWp6XJSVM3NjgWB1Hk1knl5jj5riZ/RenDmUiP12UT52ljov3e1eHRM8EW53Brw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3tAHFhfSrtaXLmuXygotuhd7zQ8PHZ1M5vneSrGi9k=;
 b=JrupJIN7qHVU1Tjz90sC/qzkJrX05ispNtDaemw8/N4nqD2+CcaMTtexqNo+ryjXLLogyEe9JRrmQGt9lJnUbhccwc9yG4pwHEyxpcNtWz3oJifuEyH2DmsBF8HL6wMfZ0nCzTMiTZtmOyfl5S6gpX9r5ZDnFrjHE3DHbwsrE/JUeb2cJkMOW1N6exeueeHBn8Idp5Z/zCvuFN6hVmdI4Eq59XCXRZESUsdBO2029JKPCv9Z/s8/agc1tIgTYLmhH2UpURrTzr4e487+GSlJG7uJmOG1xxWVKY636KjXVUoEsQNmbNxZ4PqNqck6jD5YlJX/m+fAq5yZlq9nueS7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB3916.namprd11.prod.outlook.com (2603:10b6:5:5::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.16; Mon, 28 Mar 2022 17:59:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 17:59:36 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Raj, Victor" <victor.raj@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ice: ice_sched: fix an incorrect NULL check on list
 iterator
Thread-Topic: [PATCH] ice: ice_sched: fix an incorrect NULL check on list
 iterator
Thread-Index: AQHYQaYPxsKO3xAdd0iiv3AHWrwYUazVF6wA
Date:   Mon, 28 Mar 2022 17:59:35 +0000
Message-ID: <CO1PR11MB5089C7298CC46861FF41D3E3D61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220327064344.7573-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327064344.7573-1-xiam0nd.tong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e68153e5-f1e1-45ab-e1db-08da10e4b881
x-ms-traffictypediagnostic: DM6PR11MB3916:EE_
x-microsoft-antispam-prvs: <DM6PR11MB39168F9BDF70D05671196D95D61D9@DM6PR11MB3916.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yiK+KVdcv44WIRXadd++Oo0IJuEu1ivni/kGQeZobEln55v32+IUA5obQmfiCeuNPDZOLlP8vhHeHxLZfghof2+eShfulEFpVwK4YX9JIQyCIh8YJWmQVVnD/1FycmsJZyCPh3B5tYQS0UwY7Ugl886aakgm3iB0nJAARFBf8hO6DQ3AITazvldX3a+iUHIxIfReV62m9n6ZWJC+ElnLUDCZW3Vj6R05+Fai9k9/deXCSfNEkrIkymc0MgtxmGtn7lLUlzP4+ySY166WhwwkRUpoL8RfYdfmynu97r7sQ9vjQ4Ogp+lNH0cNXcjqFU2ktHLVVjDcuLcFGCMbmOB/C8DON5wg2jlPq3/d93r7geFUqwZ99lrY7TZfTvZ7KFK7zG+knugajYXxikTLKI5jT8eL/wHM5cYKdPe+2ftCC30mRyUB52/ij8nMoKJcYv7sHav2uVo4oixCEIXwYq3I/vLCdFGIeq+ncdk57CmTIvFAgT7KZPxwEi1rt7rJvtDujedabEZmc1/xrEMsPNud237uhEnY7HMtpynlMI+vD5b9rE1UB2egXnZ2y0zPg3fzHa9yDHqDRZl+KQPzvF1uYsFeYBobfAoS9nc/Ad4yF3RJb86fhb8Gz99UUpuf+rIcn/Fxp8ORe0fuEdZxr5kYNNtFHpl07YSdSdsSl6MWzscjlojigyzGC8U/QitAZwNWk/eLL7diDpC12lHrntUEXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(66556008)(66446008)(7696005)(53546011)(2906002)(9686003)(38070700005)(76116006)(66946007)(186003)(33656002)(6636002)(8676002)(83380400001)(4326008)(66476007)(122000001)(26005)(316002)(54906003)(64756008)(508600001)(82960400001)(86362001)(8936002)(52536014)(55016003)(38100700002)(71200400001)(5660300002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fv1bXTSk2hQi/GoMr8txe1G2EA04df0Y92XMHoOhIrD0h5WdeDgzoLby3dl4?=
 =?us-ascii?Q?k/mMI8+E1YhwV+KUyGYzBCaPfPFe0epc1+eY2QVnatmkjsbp9IzWbE0dIgv4?=
 =?us-ascii?Q?DiJr2A+j+pvtADAE6Kno1zx0M8VHtfQTuYhvRTFwnldlnhI447YTYP9HUaLP?=
 =?us-ascii?Q?mh8GweWA7Xu6XHbleBdK1qWl5h3LS0s7U0zXiv+8iRyyLamAbKtvjPy8DBLU?=
 =?us-ascii?Q?GBT4frGfBaugzIrEKaYqHphVkW3hFJ/hFWwZ7k2omc4F1Ia0ZmVORx8tUV7Q?=
 =?us-ascii?Q?ff9nQBBAd3keuJhKOcrIjvBr7VncEji4zFEGjEMzqxjsEVMqNS8cBijjMvuK?=
 =?us-ascii?Q?sUBpLWw119O9uuLZ4J+CSY+6w3QnOvr3dECAHFuN0F1yEmQVD5wd2ip40c7b?=
 =?us-ascii?Q?WJwO+nEVcNokNDYNHV8ipYt1TUYzZ0ayf/LfsBLNGQdcODSgD79o2mky8V7z?=
 =?us-ascii?Q?Oa2kvlexn6C8LodVNqexxw/YoyxvHiYzg1zlZOCbaQdNRffS7PMnTRK1kvJV?=
 =?us-ascii?Q?pP0eFUlBdz6H5FRo4TjsH4dXghVw2j6Aivf6/wcv9yp8jXqudP2NwoVw5UOR?=
 =?us-ascii?Q?I/H86Se4SQVCq/xrQT7eJKoKcA/dert7QqbBSgg81RYvBnUC/4W3MS90DdAc?=
 =?us-ascii?Q?BrtzkrDKf/Y0Z1UyK6V6cWDxR1QJbq2XTUXb9W77oZBri3+4iZ1RbKjm/fyt?=
 =?us-ascii?Q?f0G4F8vtWyN2n8F7+4J7wi9hIOuw/+1crz3Do53JnAUiSKMDaAyK5te/tWRh?=
 =?us-ascii?Q?JfuDsDP8uMRnsrFi2WyB1OcPKq9F6G/pbYOnM/pjOU9cozrdN2ixF3a9nU8Y?=
 =?us-ascii?Q?B0r7dP9DazelaRAdFVPqBGvq4D46sZa1edFHaTOHKqbLPgG/rO/o8ySZ/mfd?=
 =?us-ascii?Q?m+rRRIH02IADKFAvZKAbv6KAzVm7u5rLU6p59ZDm2kA6zlYSpBEZsNtkgH1S?=
 =?us-ascii?Q?EgGxm2D5JVh/0qZ+ILwp/1H5cupv5V97Cv6nMzmjjLya8cRI+x0dxXbSli+x?=
 =?us-ascii?Q?aZs6TCZLf+XJG6tTIsiI2vTRE+mFqL2mmWHE+dZPq4H6tXTx18hhSzEcpQpV?=
 =?us-ascii?Q?TLIUpidiRFQ+79/fPRe4Gsprtyqfjfy3ZHyhIh5n14XEK20oGlEgniAOwKJc?=
 =?us-ascii?Q?ZMldcFmTlRfR6TFNWyKHgRI3FJXs+PQfKXvos4vbQZm98rHZvR6yyIG1PnXt?=
 =?us-ascii?Q?ylRd2bpJXFEHL4/WUkQXK71ENe+L5aj02YWKEb/1gZnlMWBilY2a9txdPvZx?=
 =?us-ascii?Q?QlY97+67QoKKy1TRs2KEW0Bb7q1vwEgOe1RnOZkmezBeAKB5SKrvIkYLZoME?=
 =?us-ascii?Q?0S2QWD5NQdvi1xKAJnhib3YlWFZ6u0Rs2vCbKErf/lbVtkP71y9wFuu8Ic7h?=
 =?us-ascii?Q?oveZWZojxvXPcWUrmIQg2N7fVfHurUjizFaMnEfR/A0BvPOFKe8G04l8nRda?=
 =?us-ascii?Q?VQIa55tRwsfRHdWvhQqEeK1O+m2ThSLPTvjo71F5wkHqNGfW7iHuWnROzT26?=
 =?us-ascii?Q?eNwBjhHFMdRwuuE1nIRt5xnBagYANDIV5WCDQGHYCiN0cCrtl7fRxnZn3OtA?=
 =?us-ascii?Q?PFSj9oQMIyK9X2ZuxUEyl8ykJoipuadtdXzvtyOpX91ioKFO/DUSBdsjWqzp?=
 =?us-ascii?Q?ziUbuuSlq+c7+DFue3YN5PM5wSvi4NEyQXSKwxShslu128R8xddqWdtX9hx/?=
 =?us-ascii?Q?IW+MA2iDWP5G+UILvS+p5c4U09vzivFEbuxRafAZHuMWsL1dJyrbhPoclmW4?=
 =?us-ascii?Q?LD5tbZdhlQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68153e5-f1e1-45ab-e1db-08da10e4b881
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 17:59:35.9360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tUZLuTPpq6wu2fQujGXeGVLGTMdyeakJBqsSfXTtyw0CpmLHi7HoavVs/jfx6oT7I8pOmAJaSLf0v/3K/B3QkEW5xGY9hfnWUP3bUMC5qYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Sent: Saturday, March 26, 2022 11:44 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> kuba@kernel.org; pabeni@redhat.com; Raj, Victor <victor.raj@intel.com>; i=
ntel-
> wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Xiaomeng Tong <xiam0nd.tong@gmail.com>;
> stable@vger.kernel.org
> Subject: [PATCH] ice: ice_sched: fix an incorrect NULL check on list iter=
ator
>=20
> The bugs are here:
> 	if (old_agg_vsi_info)
> 	if (old_agg_vsi_info && !old_agg_vsi_info->tc_bitmap[0]) {
>=20
> The list iterator value 'old_agg_vsi_info' will *always* be set
> and non-NULL by list_for_each_entry_safe(), so it is incorrect
> to assume that the iterator value will be NULL if the list is
> empty or no element found (in this case, the check
> 'if (old_agg_vsi_info)' will always be true unexpectly).
>=20
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'old_agg_vsi_info' as a dedicated
> pointer to point to the found element.
>=20

Yep. This looks correct to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

> Cc: stable@vger.kernel.org
> Fixes: 37c592062b16d ("ice: remove the VSI info from previous agg")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sched.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c
> b/drivers/net/ethernet/intel/ice/ice_sched.c
> index 7947223536e3..fba524148a09 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sched.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sched.c
> @@ -2757,6 +2757,7 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi=
,
> u32 agg_id,
>  			   u16 vsi_handle, unsigned long *tc_bitmap)
>  {
>  	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info =3D NULL=
;
> +	struct ice_sched_agg_vsi_info *iter;
>  	struct ice_sched_agg_info *agg_info, *old_agg_info;
>  	struct ice_hw *hw =3D pi->hw;
>  	int status =3D 0;
> @@ -2774,11 +2775,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info
> *pi, u32 agg_id,
>  	if (old_agg_info && old_agg_info !=3D agg_info) {
>  		struct ice_sched_agg_vsi_info *vtmp;
>=20
> -		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
> +		list_for_each_entry_safe(iter, vtmp,
>  					 &old_agg_info->agg_vsi_list,
>  					 list_entry)
> -			if (old_agg_vsi_info->vsi_handle =3D=3D vsi_handle)
> +			if (iter->vsi_handle =3D=3D vsi_handle) {
> +				old_agg_vsi_info =3D iter;
>  				break;
> +			}
>  	}
>=20
>  	/* check if entry already exist */
> --
> 2.17.1

