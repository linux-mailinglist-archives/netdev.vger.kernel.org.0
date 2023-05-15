Return-Path: <netdev+bounces-2602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F8B702A69
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AB461C209DB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63602C2E5;
	Mon, 15 May 2023 10:24:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABA5AD59
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:24:35 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B77C184;
	Mon, 15 May 2023 03:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684146274; x=1715682274;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ckotdR+PZsIDw3LTtEfBYDjeir0AfiHCMMY7pRoNps4=;
  b=jZKO/fovk/hUNSD9g6yzjKQRtf6vjmlreqcp7mDzfhIy9JyUO95l3UUp
   IoAxYOf5/OpreEonnbfsGc2K5RvN1Ea8ClL7jBbjCWU2wM3rA7M7gqFHr
   qExjP4K5dhPk/BUNHDGA7pJ20p2swgEGaKdO9zrORLVBDlHoch3KhTmJR
   eyxPxv7v66OZ7TFdTj8mTSeq/6Eujcbwzgt+rGqtxY8CtuHqBrTA8rW54
   WVmNrMMAuXuJ5A7zNp0yNJ35wqh0QRWQZJtJXe+YQf58Ku9Agl4acY3JH
   ACSfA1HJaxtdu2SwRFhktB6k1BLX4u4r6SxRNvO+w5feOJuz0f8Wn4TLk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="354322385"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="354322385"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 03:24:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="731582606"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="731582606"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 15 May 2023 03:24:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 03:24:33 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 03:24:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 03:24:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 03:24:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHBiOlVJIHJClDzKKJnfbDxflBf3XzuQR09vlAbJc2jRb3Bnh3vPHkxYWTN0kvyBXW8h7NIhrHO0z/iB4Osc2IKpWu8HHJaGo7frYqbSxdKWzlx18bPIbn5xv900rbgitp4RYx/f5isVbUOZiVkpFIeFJYH6U5uVyJ4HiVi+nZBuVNirytoAYiq29Mb2lH1d2DqTpaRQJh936MNFtP02jvxi1Ij3LekBt9+OFywN6ld8WtvdNqBV/sw6doPecmlNBGXf3QT6JpSlYimV3Dx9rwvsr8YXscBFoFkJBS0yM0qftDvLYYfamHopvf5P2p3DZ86Ffs1PiCjzkSlkmpgjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7mzcCOPY0FayJmYvwziyTNgllW+iiVQvouguuWplGM=;
 b=Jv3IU+6emrUUEOLXzKWbElY0u60AGiV5BGAT8/hQUHq+l1wKE2xKI6wpBcq+AnjnD9kouPhaR3HpaotTpwT1rJYqFj8biNjb4WKipuRS5s7BJylfWlhSaO7cZNN2SGTBJ/dDokyEcUtmEh5PA+dH1ZY7YR5i05gnW927ATSv7cnuMMQ0FQbeghetlCGpDv+rLjbaLBGzRAI3MK5oHZha7iQUM8/I6/XYJB4rIkWBDpR1rvm59245hW3lsdVV+zSh/wjjsSE/aHosm33H9ayXTue/wFBTJHBYyYVhjhyyjUpV2lMFuNPy8IXIVvqCD8avhchNueip9ggpbrEryV5Dxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by DS0PR11MB8181.namprd11.prod.outlook.com (2603:10b6:8:159::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 10:24:31 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 10:24:31 +0000
Date: Mon, 15 May 2023 12:24:25 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 2/7] net: lan966x: Add support for offloading
 pcp table
Message-ID: <ZGIIWU9MoxSKMWup@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
 <20230514201029.1867738-3-horatiu.vultur@microchip.com>
 <ZGIGkZDW84tHr04f@nimitz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGIGkZDW84tHr04f@nimitz>
X-ClientProxiedBy: LO4P123CA0403.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::12) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|DS0PR11MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: f83d6b4b-9b63-4c15-7b08-08db552e921e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLJBO+PnliArcjtVK/DPMl7HI3wfA6mhFoHni0C4vz5mfWxYL8KU7i65N0/Y4jmDVYC4lTGvQU1prHHB19JRs9LtMzzmL7N6HGl+q9NFEetWbH7563FMGbGwOjfs7jbAELSXWZp8RpF2Oa9f7Q9CEwy/2eguoAJLP0BP7y5SPAjZ+KH0nwn0yrJ5biOGanwqFqPxCieHHKRHPEUVoMiyLUyn19PGFjznfBwG7WCJeVYQ4IJG+d55lHEErYIZG29vRFhThmeQlGYIrRyr5D+blRtjjHXrYbucJex8LEQzTZEEU9KjQ4U9sw0hsy2MusDl9447qdyh53TGR5EBXxrvhV+ZqnVl6xktdgkf3KSKOb1NUxjwrUeiZYjIryq3oDzbYPXnonzrrvNMlzyODSg0b/uiPehOSvO3fTsmyWhrLJrRRlRAHaqixarUVqQyqN3WpuyAKUJtB2ZhSNuujyjbeScWprm2RhvhFHdJBqx6E3s0DcgkXFxrCCtF+29SljhlTqY0GP835bfoK95nhYnQROesiTm5Dy9DpnnjX932BrvXdPm2n3DvcddTQQ09mB/M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(66946007)(66476007)(66556008)(6666004)(8936002)(83380400001)(6512007)(26005)(6506007)(6486002)(82960400001)(6916009)(4326008)(8676002)(2906002)(5660300002)(4744005)(316002)(38100700002)(41300700001)(44832011)(86362001)(478600001)(33716001)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPrdAQ1RTSNsswXz6RMGX4LL2n23CErcNYBOY6jc0pDmg5Vmbb6nwqNoXvSV?=
 =?us-ascii?Q?T8x7+3GwJ48wMAOy6R8cbAPEIHuu6Bh/EU9daE7vXFZC+hRCmo0L9kVOZ5io?=
 =?us-ascii?Q?tO+kT6L6R4YP+nUKsCkosur2eq2DrQSH5if1mNaKN4PnXYy6BpZAb/NTTmVI?=
 =?us-ascii?Q?WGAOITOZnn0tu52/0Xq9oPSIZy+wG/EM3ZqUz4IPQktCxZPN0f9Lze3pas+L?=
 =?us-ascii?Q?HS/GtgofQeRLthDEoWevWGqyQRkI6KvzgNrSJq6Wj5t/PpUGoRY+yAyifnNO?=
 =?us-ascii?Q?9uxjO50RyLpAQ6HMo6fyc7LK1bcmYfmbkgxVEswDF9zwtXAutKsakXNKHaxX?=
 =?us-ascii?Q?k5nhfOmAv4eaa2PKdOpO3u6pCyYs2wSK3MF10XlA2GaGsf0/8cXtv8+NWctY?=
 =?us-ascii?Q?zX6AfDzzt7lsUF78dJSvHEohhUX5KAWLAW2RQgn2yTH/LlwstK/Jz8e4PHOA?=
 =?us-ascii?Q?tYp0uT6/6FoT855zDhwubKP/wOfaLwUOu/Re5VWfeD3RrohJgiOmonWab2MV?=
 =?us-ascii?Q?LZfWDmwbWOc0zW0+HTGuCCI4cy5y9okQ59nbTKtaWxmxcekl9IHEEBtVoupH?=
 =?us-ascii?Q?8edUEO7OPBgUN4sAHCdGD2Atq3WyRGF6hMOPxFxJ1NfgYNwZU0tsqehIvaxP?=
 =?us-ascii?Q?vks67A6UjQXebtSMZd2tui311bTsSbvHu9YEDLDPC7cdHlYSME6izw8pN+bk?=
 =?us-ascii?Q?9kCY04D1tbLXikxnuXNSLtSFta+AkFO7Qzl3jOdJ+pvCq/9Xy/3R16Rk1Nl0?=
 =?us-ascii?Q?3/FQexamAC6EiHAV7jq7cyH8T0cJe8QgEkWEl/yNNapT2Z508tVAVxusT5FQ?=
 =?us-ascii?Q?5itfm/+CN/B+7zFB+EN000HS8DOUmf1GvSYO9hzRZYcnTj+A2lQflffPO20m?=
 =?us-ascii?Q?TeiueQXQNF62jeEQSL+PjbHqNUu/1hCErGNr3CaEp1eimmluHHYf0m3qcbLJ?=
 =?us-ascii?Q?S05SAuXAelPhdAbmnjDuvEBV4Ryf7088a4wfBbOQnaxO7bWAZ8tpXqBAuolZ?=
 =?us-ascii?Q?sxk7tp9Q7s0ty4qD5mqaYpNisrKIrew1bnQgfi53HD0gevQKLrlkPY5bxVUg?=
 =?us-ascii?Q?6hhP9NRg8zZmXZWKbjr9rP/Do9uYpeS9PLQEebtWwjkJdQBhc2iz1ruMXLOd?=
 =?us-ascii?Q?WukTVzznaJpe/Fn2/GE5WF7UfqSwSqhahJFLj5NGokDlu6g6luGYCkWso4Gr?=
 =?us-ascii?Q?Y7oH5z+2tSIryRPXxhtYcHQ+ssGCzaDREzjMyh7mwT6PEjv+Gj5NjX+KK/Pb?=
 =?us-ascii?Q?vFR/I5/BanTX5M6zjvLpE7WiGwhnGm/uRSxHb6XOIiHKo68kGqfXxzs3QpUP?=
 =?us-ascii?Q?bVkC5iYoy6yd6286NNV++Y7fKTb/gH5ptDrxGP8ZYGY4bc70VnausN9KKaiX?=
 =?us-ascii?Q?jr5ot7yvI1Le/TOR3yDVfMmmnUVXVRXZB0lBkO3vKXQVD0wKYbWj0SDNyFgU?=
 =?us-ascii?Q?zNJGszh9qt14oOMtFj4xHg2d9qDQZc6h3bKJANe9wO/KUu883MUQeDQgzRBZ?=
 =?us-ascii?Q?frJHdn9k1WeomDbK3kcNPOOzJbOb91aj7xSa2S3L2/wldj36HMJYpT9SfN0z?=
 =?us-ascii?Q?njk/GqpHK6rr1v6zKWp81QcFGbCCZKWvUaJ6yFPSC3g5XO4QTW5G64y8/U9S?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f83d6b4b-9b63-4c15-7b08-08db552e921e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 10:24:31.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RA+OhztTwJdMXEpAj7xsTOGE6DO3qGjD+06hsVLbHFhk4V3fl3b3AFecYmOvwhXS34m3DiD9nwTQJT8Q/UNmhw7rihOW04pGfCV/YiAGSzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 12:16:49PM +0200, Piotr Raczynski wrote:

[...]

> > +static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
> > +{
> > +	struct dcb_app app_itr;
> > +	int err;
> > +	u8 prio;
> > +
> > +	err = lan966x_dcb_app_validate(dev, app);
> > +	if (err)
> > +		goto out;
> > +
> > +	/* Delete current mapping, if it exists */
> > +	prio = dcb_getapp(dev, app);
> > +	if (prio) {
> > +		app_itr = *app;
> > +		app_itr .priority = prio;
> Compiles OK, still looks little weird :).
> 

Other than that, looks OK.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

[...]

