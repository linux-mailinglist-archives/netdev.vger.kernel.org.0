Return-Path: <netdev+bounces-2221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 658A9700C21
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AC871C2133F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614331428A;
	Fri, 12 May 2023 15:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D782412F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:43:29 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2EB40C7;
	Fri, 12 May 2023 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683906208; x=1715442208;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IzJ0Zh1BYx1ymA0vMbeakqa3bw30omH+WROwIyHpsmI=;
  b=gXbZRIi1ZnQBotfxdXx8Dme8ZsHH0/BZcRvq+fjQhiFCm4PbMcaoz3rY
   3CM5E3gw57qKpUR5Mwzq3nKvhOL5CBURZgbX8u0ScQhwHmehO4At+hlK/
   Mq52/Xcr7+LbGjbiir9pJ9Yq4HjL5MnE08+/ypQavPx9CMMkqwT8YioUn
   Bjw3eyRjLhkUAwbpAXsHIy4zC/bafQb3YMy9b14//vgftEdHSsqXHBU2B
   dJf52JWHLMqIsqa7v7F6RaJFJRVNEbtKcU3cdoT85igpI3nh0Qca8SyNJ
   EmTl8J4CqhaGiU9KHNozcZXRTAT/7OrjZ79nckCzPcrUpn91vQOakdTA9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="437154328"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437154328"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:43:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="946671119"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="946671119"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2023 08:43:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 08:43:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 08:43:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 08:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKDwLEvjLVZeWJ6yfTWoZKoNXPYQIWRNv05TxVUPRUt4+zx7mIfRQGRLdB2rQKjsCTIWOO6lNn97wrclw8yieqWL+VrdmLxvOYl1wd8hSUK3/QF8jqNg/VFM8w+1Py1PFOeZ9ssgHsmYwH0hyDIhc9yjlp7YFkqKaMAWbymEFqJyFjdGx1gEUchuCSh4BveTnmnD+YrfjlvHa78rmPkwpoSOoeuU3rxoL8IoUFLCOYfsOhj1Ms5Mptbsy+Oh+EpoVUjj20uOSFfYtKqi1UToNQpJEZeepMprKiujLFSECF11TkjPJCXssEa82XKdjdhKujROgxpTafIra02UOQFUAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPLk2bYAGL3cBCsUTWX5hnvoB4F2kYjRviygmy8jMUM=;
 b=caFJJtpuXehBgKrsl6kl759vR6d3qBqhgSM2tERu1kgn4w2CQ7GAd/MoJG5xekNLRA2ecyXHoj2Le7M0O8ZC2XhEyxMHpKqg5LsrkjtWDGtngiUVUYhxb58puzyrJpG0SA/Q7z6KTAGzvw8aLLPZ1py4qvANBC6GMNzEbdJDm8l16UVYDPJNOUYXWsK/ZdjLZ9JWSb7YsVqGkiw7ovDfNIXWq8ZT6MTpCpTSIkEwpB9IctpNWrW+OxyJ70o9LSiCdQHVowGfsF1VZJfmvvF/AFRxadhyDB/B8/vI390pHaKyI2mcVfLDRHiOBZuMg7N+xAfE72Ll7McNelypD/O7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 15:43:22 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:43:22 +0000
Date: Fri, 12 May 2023 17:43:15 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: "alexis.lothore@bootlin.com" <alexis.lothore@bootlin.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.petazzoni@bootlin.com"
	<thomas.petazzoni@bootlin.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "miquel.raynal@bootlin.com"
	<miquel.raynal@bootlin.com>, "milan.stevanovic@se.com"
	<milan.stevanovic@se.com>, "jimmy.lalande@se.com" <jimmy.lalande@se.com>,
	"pascal.eberhard@se.com" <pascal.eberhard@se.com>
Subject: Re: [PATCH net v3 3/3] net: dsa: rzn1-a5psw: disable learning for
 standalone ports
Message-ID: <ZF5ek77KsL5O4Qmc@nimitz>
References: <20230512072712.82694-1-alexis.lothore@bootlin.com>
 <20230512072712.82694-4-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512072712.82694-4-alexis.lothore@bootlin.com>
X-ClientProxiedBy: LNXP265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::18) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|LV2PR11MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: 631f1f69-721e-4649-03f4-08db52ff9daa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e46afWJNgBn4tO8+nHL4yeFzYxQyWRL7TXSrWYyceVLcNOxvi9pti9KQVJ5t6aTmpcYYpkR57fqBwG7qbhmejgokE7C5qRXPWaABrwT+tgd++hKguxs2F+d+BqC0PaUw0jmJy9IWaAKGdW4Fj8jCbRwsbOaf4PUKcLb7W2NpAJHVr4IoEbM39KH6byIa51zTe30ql+zwXKPr+cikkYxn9rWNXLwm1Qk1ynMlDU09ycBBYLm+8vUBVXW8STxcz+pZyx34H1E7ieqPC00tA8jPQ648TvFf6+wEp/Gg0O2Awo6dD2iBK8AkN1nNg32wXojyiz2jlCjxkMlHZ1MIoofqov0G0K+EEeYEcyTAzYATp0LY2Ly/5cF2Ebq8wiY+Y4X4VG1GOb5QZY4zwIOvFEMJTUO9bTySXLEywgufpkcETGjsAbRN17fcNQzYhbATvGfNN1+G12yS76D2w3fvyCgGGs4EIMst9sg9x2csYm+Hb7RZK71JJoZIQOtUVXqr+yNn3v6bT/n8DWpeiioOtduKp1UIlNuVMwZNOl661URnWb0oFXxIco1hUn/mGvtk2g9K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199021)(186003)(66574015)(4744005)(2906002)(82960400001)(83380400001)(33716001)(38100700002)(86362001)(6486002)(8936002)(41300700001)(316002)(6666004)(8676002)(7416002)(5660300002)(478600001)(44832011)(54906003)(6916009)(66476007)(4326008)(66946007)(66556008)(26005)(6512007)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8/VIzP3R1A76hR3QLI/Ys2DSFsBjsR2QJLtJDKBOE1G98kXUvRaP43YcK3?=
 =?iso-8859-1?Q?OrAX+aPZ/C1GS5kxmDEzvOzm0Vam2m/90tetNI7i/HLP4Y5Otw/VujObCS?=
 =?iso-8859-1?Q?pawRi6CT3Kh0YF0PeEQXBMEHsAwmn+xWfED3HOiOvCT2wEpkUEI1d7xVHH?=
 =?iso-8859-1?Q?VZ9N+xZjhAv0OMSrztcxr6CQ7yrYIm1nCzO//t2Jaqo+MtSFoOo7AE1z7P?=
 =?iso-8859-1?Q?ejFKSNlSAurOSGTu+uCNJBSFmvyV6TTIXZlPrcyQQnVCSVcFVO2e8Oz1Z2?=
 =?iso-8859-1?Q?BwFBoHRXqAuRQKj9fam6v/K9p/s6DFnfDTOJwkxTGz+dmyl3JRSHATSmXo?=
 =?iso-8859-1?Q?ZRR4gQaMp+vimZfEqJ4xy0qV0OEc6S6KUDDMzX7iI4/eprxUBXculq4+aM?=
 =?iso-8859-1?Q?Xy4vHYgrhs6xE7caSRAdAgFJrFbRUjAt3u19KFc9nkT+Qooo4Yp3hyakrZ?=
 =?iso-8859-1?Q?7Q3AzAtW3Odw6Jc6N3BImLkCv1ZK0iFskEp35v9ujIvLc6j9rsgmz9lYTe?=
 =?iso-8859-1?Q?mlp3dSFLbSIuZqMAZz/Uu6ghbNBKVoh3BL02JhZijI+bTozXwuZElDoeVF?=
 =?iso-8859-1?Q?Mtk9tq4sDxUxbeHgp17rQy2YqCbfXzLW3Q8vr2R2V9WlMAXMDRbWg5iwi4?=
 =?iso-8859-1?Q?uJsxHr3PCNPqG8nkkfLGeffsl4xU/RBv7fSy8zY+WllF4OAFXEZtGyfOqA?=
 =?iso-8859-1?Q?sDBf4fsy6Z7nH6CQL/+hg0SoERvFSwb4j8jLIvPHV4VoDrC8sMKKTdsTKT?=
 =?iso-8859-1?Q?1byOnPNUOU0D5L6QqHIBlOtZKbzvJjxLffQKWENK4CPi2vpe7eel21Z0dz?=
 =?iso-8859-1?Q?uHxq28aCE27cHB7qzFI2hF/72ItMfaATtCGyKMtchqUna1KhCM4cQEXe/o?=
 =?iso-8859-1?Q?EB3dkfSEg7KeSJ4AdLrawYnKL08U6IalPycHbLd4qSEnk8lNpnVB+ORlXo?=
 =?iso-8859-1?Q?IKvjEAkb/MC35N6oVhRm765GvyqHdcwTfHxDUeaTm1IBNxczNP+RiVyhyN?=
 =?iso-8859-1?Q?7XrrDkolyWSvWNgVqgp1c7kSZmRA/TqswFuXDO8DZktEp76etsbLqZ1hfQ?=
 =?iso-8859-1?Q?Pp7sj92deOMg9xcacr7g1xgMXzyEodYUfqhT9FLllPDKHNjIEVsT1JQo+Z?=
 =?iso-8859-1?Q?+Po8NGZ+FclZyDxKofixNMm/dvVgtoPT+61yTqkRNBogKewDA6R/KoGVih?=
 =?iso-8859-1?Q?cSaTbJBQjP6lRkZ6JVvNVyIFFVWwk7pcAjeROb6aa0p5lJWWQEaNXYEVsC?=
 =?iso-8859-1?Q?CQw20peilXGPGCQicyeOyml6WDD09D80J58v8m2Lcx4QTV2Q3tlpC71D1I?=
 =?iso-8859-1?Q?3DQpo+VuS14WRP+oUMCXsRA/OECR3BWJ4wdRX5KHPAAWNXlnsEYeAwhbEJ?=
 =?iso-8859-1?Q?KJgybBAZN+8b3sq53swqbp1ePE4IMJo5OPox7PxUnlpdj04MVfsibfTDZI?=
 =?iso-8859-1?Q?7/8U+DcX6L8fiDMJk7BhqB1jbTjVIh6svkQSyFCPRoYpTWiwgGmnSFaZMN?=
 =?iso-8859-1?Q?V7itX8UEaRPUjILzZHmO1rdtOu02+tenUBcNAUHus7/F8QrM05e8bavmym?=
 =?iso-8859-1?Q?/IOO13CcDa2vwgeUKBw0VuCoSH3pTPQqa9mS9pDIvJCQ4jhfBhUpUDmpHd?=
 =?iso-8859-1?Q?pWjyKWPQ+q8KJn6P5itTS0T98lE7QU5uJMf5sDjiOW6pVNTIeuogNFNQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 631f1f69-721e-4649-03f4-08db52ff9daa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:43:22.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnG20zTURRKgf0PZJJkUHJ2/UaFG1PkZH8GyXl0T8Gg5fn3h1bUbIahzGqWGb2v4p2stBOzTSAJQvk/8FV+xOI03Cs9LPUP/seVrhSgPeFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 09:27:12AM +0200, alexis.lothore@bootlin.com wrote:
> From: Clément Léger <clement.leger@bootlin.com>
> 
> When ports are in standalone mode, they should have learning disabled to
> avoid adding new entries in the MAC lookup table which might be used by
> other bridge ports to forward packets. While adding that, also make sure
> learning is enabled for CPU port.
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

