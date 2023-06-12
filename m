Return-Path: <netdev+bounces-9962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A95A72B73A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 977C91C20A00
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 05:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672DA1FB8;
	Mon, 12 Jun 2023 05:18:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3A1C06
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:18:15 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED1B113;
	Sun, 11 Jun 2023 22:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686547092; x=1718083092;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/qoqI/Eql+fA1VzXUOsBJd3QAvQzqsxXkv6InvVOZbk=;
  b=UuafaG8jGv8MnFVRvnQK29uoJOu1EKOvUVzKrZ+/zOuncOvl9M8BeMu3
   DQzliq/90CTj4VjEbejV6ZSbkxou+6aoqCDfcR1wJckx1uIfXic/J9cEl
   O6kt22h7rTgpb3BbVAt7D3dl8TIfbrXH+mmzMAKBl1IWR/XHDRRluDoVn
   eO+rGJLjOjt1L0lGN06c2bElQMAb0xk7uVUVFeV34IiNEOhPJMNFxdM0E
   BlxjHzVVXb2wVib+ufr/h6DgOyLqHp6W3mx+vOA3c2n3FjB/adV7gTXNz
   THpX5CReEUnpPCHoCdzIcP9npv2oAqYzI3Qz/+BLvN41AknWtX0PxwjTJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="337582864"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="337582864"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 22:18:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="744186337"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="744186337"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 11 Jun 2023 22:18:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 22:18:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 22:18:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 22:18:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCLwfvTQ1b2dwCw60L2jNQs1y0prER1w5jKbnLBMbq0Q+pVup3lX3L3d/qZUeSdHsLQb5QL8+6TtX2Rd0FJTQu1dKTFAki3OCk+6PbkQSkLixMKz9GfQwAP8hRWyMO1PUcmOqGxRCudM4SU9dApnRf2+trkc6A9lVu8GahHY8Mp+STwUBhOpumN6ogdsYoApFFxR+4ZBx7bHO1spElz0G6x/wVPtUTxuhnKDx2A2LBd9LjZspDrQDBVDO/uArQQvkgSsPtoILnWhQOUNNZqKmOukJelLPyrIAroc2ZtyA7ehuU9VFaBT59IW+3GLtt+d4+ukCaFEHE6U8lj5bIFsRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMvUbptURgRBuojoDraODEqlrYoafrVRcRW4qW243rc=;
 b=CyFKfLkr/wUWijnmXilTc7Y6EvzanSOzihqtrVgdgiq/ptNrXRcFjs1hWcGTlCiZQmzvu7CjXA3xzj3ZUoqe99w+Ub/au8g+gGaCVJ8/QdG/9Gtq+Cr0rTY0Hj9fzos85shyhNY9M93Sy50Xu5uhBM4vospvLK7rYpOZ5tG7bNhVJ28g5pTzpm6a5HRfiGalvRwiaJp6jM4cremjlmzKzRlAWyx6w6FkiaOPQeor9Zx77Pxkqu6QWorZJkYqN+P4EnKhw120PHpJ/+9cvimy8yrKrQ+YTcTlZUxLMeJn9zWaGdSaNw0LkL5BZkpxAc5VZJmTXkcmXJbv/SS9hLH5eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5597.namprd11.prod.outlook.com (2603:10b6:a03:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 05:18:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 05:18:01 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ice: Remove managed memory
 usage in ice_get_fw_log_cfg()
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ice: Remove managed memory
 usage in ice_get_fw_log_cfg()
Thread-Index: AQHZnKWNlFlxLTGfqEadQfmxPjZs6a+GoRjQ
Date: Mon, 12 Jun 2023 05:18:01 +0000
Message-ID: <CO1PR11MB5089E9E4E21793B60112011BD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <e86a1ab7b450462a1e92264dccb5a5855546e384.1686516193.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e86a1ab7b450462a1e92264dccb5a5855546e384.1686516193.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5597:EE_
x-ms-office365-filtering-correlation-id: 8a04fbf1-2c68-4e9e-50c3-08db6b046493
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m2tRF70z41z7ezP0beO6wSxef229VIqoQVEJ/AU+LHkN1W34fTvUlm3xWELHhsESSyD6lc6i0CkoMFNOdFNMm80+PAnyIS0ZKZPjYFzJGa41o8opMby8/1/CBL/a0Yl+wefxVBd2BH+5ToOW2dR2vVavJuItBpNrd8PyAb8Z4FwuLCZ0RJ71WRccaBWbH3bfulCSA95RURJKPxbXb8+bkuitk4jrrHewQaeFkZpB9aNE5YcAapMUM4y9Z7m6EDH0zWJrQmWXj/+sOGXMSkTy3+crqstDwNI8SUdFReKXl3kn4MQ+w0dSxriMsd07dTs1ZCYGiY+AfL7booEpVOyhIHpdIVkjZm/lc1cvxFhEUPSOaYDKzoP98nc2+OA05O4TzYPJrI6If/Bva8LATpGmcf74iWLSmjqYmVq+r+mR2I6xdGpJN+OpF5BcBARhK4ptFPyfoJ5VGIqJ/M4NQpCemgg9Lr/wLuxlxYNHUHZkIUs9Uw13CGxyydmoBDvABNG7r+Q/9CoSUSIw5B0A5SZJhgzdwJjotoynGJTMrp1Y7kj3E0ZSoHP9cIIuH9LmvCtcj5U23sxL4xvAXIo28OkdVueParuIyu2n1bwC9yVMeYM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199021)(76116006)(66446008)(66556008)(66476007)(66946007)(64756008)(8676002)(8936002)(5660300002)(52536014)(478600001)(4326008)(110136005)(54906003)(71200400001)(7696005)(316002)(41300700001)(966005)(38100700002)(82960400001)(122000001)(55016003)(6506007)(53546011)(9686003)(186003)(38070700005)(26005)(83380400001)(86362001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tOqCX54TPfrTXlKdIU2iIFS+/4HtQ4pnhVCy8N5lxwlXBE4eCPAgTzdyoyES?=
 =?us-ascii?Q?QaWHRlgU9svvGUJ0I7QFBHXtN2wI6W5ZTRyv6SkbyjyL4xpa2Y8vaW/oN5In?=
 =?us-ascii?Q?Oy0Z0Ly4u4HSJHhHcPZjoUE2liiLpdm/mbUgTDAT11TsYiagWpuD1hTBSGxO?=
 =?us-ascii?Q?IlWA1Xz7Znxe75IIn8Ig4/2a2pMslSFOjsOooGjyl2smNnufc30D8MAspS2J?=
 =?us-ascii?Q?80baqw+NtEKGdp8TK2IWPRoQjr0i78IolVT7NluXSmA2GK64GvH/MzYbWoeK?=
 =?us-ascii?Q?6VPaok0RNv9GeCtnwvB6nYiRWjBd8dWOC7XFiM/CDldhIx+y2vMvXSI89Vhq?=
 =?us-ascii?Q?OeY3if+LoX0lMGiyA/nacdfWBJZEVK4C9i1NuUTfdEwpc+AsLs/JsehSvIca?=
 =?us-ascii?Q?AZ6GBulu8mY2bveYjsiK3NuCypw8RtKrecv2iVj76sny29g51I+AKrP2AHZt?=
 =?us-ascii?Q?C3sN1+RJMVDXErW/6mFGgfDW2QNJQ3DSzuX9+VA+7CR59D6WeSb5gBzoTQI3?=
 =?us-ascii?Q?71dp0eYFzMpIbRWdA+lGO1F4MELTEE6uziRZ0ZaAdaExJAHEEuQf1QOMXig5?=
 =?us-ascii?Q?U4WUaSu/8BcOIF7mjJ7zBkQAwuU9L61EA11BMYFJFuYtliIPskP9kZ5QJjqY?=
 =?us-ascii?Q?phpTH2Yy2Dv357r2xxX0ZtYO6p+e/ElFuC7WMte4HpIiXW4rnZVTuIloCX6q?=
 =?us-ascii?Q?RGfFELwMYr3uy1EoXPJmGjQNE1cNOhuF4weolyfSJcM2vaAeE6J//4VfK8iO?=
 =?us-ascii?Q?2NGGd2wQMoz4CNaF0xFuUkc6Yg0+OpjFPCpFU56I2U2t2ZTxp/oi0AcVx0s3?=
 =?us-ascii?Q?AsQC8+k0byfUoeER1cdrnZyPEk1amqaOvkfBSQ1Jh28afc6H//hyNyREx+OE?=
 =?us-ascii?Q?3B9rqLJrCa76cbRT0xwohh4nAgov2PVKGlqsrCOaZ+LudV/vd+UE6qmvdkXG?=
 =?us-ascii?Q?i65mf+cTTrZT/DHhNoqIm7pl1M23jx9UREQFagBMPl2e520Jnkh1XqxPI+C1?=
 =?us-ascii?Q?NXJMR4lnvmlivIVdBnrpCyXGgr4fnARyRv9fmOPfAOgvb9iRn8nzSPxne4Qt?=
 =?us-ascii?Q?rchMPgGjIlZ42RgjB9XeYInz9y13sHwb2uBH7tXp2fnIW7ruETNqBFhjF+U6?=
 =?us-ascii?Q?lm0PtLvkUpRC3SA8WxoSGMYdXnSQjKODux7eTJzd9YmSG0UChGor9YC6q8n6?=
 =?us-ascii?Q?REqvECKb9pFL44yWocSGLQ3jCyxgIbBSYLOviyxS6Qi/YQ7XdEJh2e4Zc/qw?=
 =?us-ascii?Q?v1ILWuE2+G4/OVQT+vDC/k3ABNmkJnMJW/MHlONP5Dl+njFW3oOvLdE+Y9x5?=
 =?us-ascii?Q?OV/Z1pqPRHYFMdUp3t3SKbHINyOZStpEsWWZUHHXUX0V32YXbNQZzxH2zAlV?=
 =?us-ascii?Q?qMjhSZWxYa/aZg4fikD4k0kVPUx/g4xmT0TL3zgYOnjUWLhqAXm7yEQwft09?=
 =?us-ascii?Q?SoMe5ta/unypsJ5oiVYlIZczUy4PPvp1afRRpVqBsJNE+a9iRd1NhThatu0z?=
 =?us-ascii?Q?LXNeuFYLAXItItn9KMg2FbyDEGyp9DrxBxHRk5MjgTqu4pPYU2Zz2Y1ELb5C?=
 =?us-ascii?Q?fct1NZQ8ZYh+FIK9vATfTLs2Sh+/puw35QF0eBsz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a04fbf1-2c68-4e9e-50c3-08db6b046493
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 05:18:01.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L4izGWAjUdpHOwNr3Zg5Eldg5iQlWctPKSw6eXvSKMmLySY/qDdgQ0z8Eo720h4qyyaoxR1mhw2S0DbmkuqY+44bv6C6hdrHURzUEk28uAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5597
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, June 11, 2023 1:44 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-
> lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next] ice: Remove managed memory us=
age
> in ice_get_fw_log_cfg()
>=20
> There is no need to use managed memory allocation here. The memory is
> released at the end of the function.
>=20
> You kzalloc()/kfree() to simplify the code.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---

Agreed.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c
> b/drivers/net/ethernet/intel/ice/ice_common.c
> index eb2dc0983776..4b799a5d378a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -834,7 +834,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
>  	u16 size;
>=20
>  	size =3D sizeof(*config) * ICE_AQC_FW_LOG_ID_MAX;
> -	config =3D devm_kzalloc(ice_hw_to_dev(hw), size, GFP_KERNEL);
> +	config =3D kzalloc(size, GFP_KERNEL);
>  	if (!config)
>  		return -ENOMEM;
>=20
> @@ -857,7 +857,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
>  		}
>  	}
>=20
> -	devm_kfree(ice_hw_to_dev(hw), config);
> +	kfree(config);
>=20
>  	return status;
>  }
> --
> 2.34.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

