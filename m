Return-Path: <netdev+bounces-2681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9575C703191
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71A8F1C20BEC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46460DF4A;
	Mon, 15 May 2023 15:30:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38179C13E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:30:39 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E5F19BC;
	Mon, 15 May 2023 08:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684164636; x=1715700636;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dvYZbD30pCDNVctoyF2ARLiHsSvGhBRURFSksWDGWoo=;
  b=BHo4nXwkGi1vmngASZIOB8oIEDYV44R4Hb33PH2ZoXcJs9cJGPvyGa6+
   lRwrmFmGeAJzIpZc+ASEDHgTzXJP/jKMt4MnK1XmAaIEZbcKLqQhM56Ra
   r5i0KG7UXR9GDDtcHhOFgYza+h3im0954ryoA2SCyvBRG+H5cbHp1NKaL
   nlPofL6cL73nlZAaSntROOS/rtzFk5blMKwI6bbOFKnKZZ89GI7FttPXN
   Lljis9OXD3E9qzoJafsMwUE3Uq7eKFo7pPPM6xINjzCpk5+9qC/8CZNZX
   rFtqWxHi0UaowYhTT58bGUU/bXYPe6kcxP5YmnAb9XtbG1FSW+yB86UD+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="335773442"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="335773442"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 08:30:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="825223429"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="825223429"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 15 May 2023 08:30:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 08:30:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 08:30:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 08:30:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 08:30:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOrBWJxqRd+d5OhvkRAX16byF39cnOX1akXMBwm2pN6SvYnpLM3stwKjsao1yhtiPx4Ao0/ddKea7Tef38lhtBm3h0LvD4pCA7tNPM+7FgDhEfU/5buzLYC0ZLJ8qKfSjbbXSwjCOidQi6PGZdG6dZOnh9yHBmqDNWfREamTIRGryWVwy655UN5YPeNvuEZx4+LLo8nCdGMtfl0Le273nZmTr3dGSm9CRWo8cXMkMjJ2yvWlpYD7KNzmC7DcdIHHBGeZPyr8fvvn0VEE1HPLVst8arGk3meyLsCn6WipNtNXlX0lfAcjxBojZ+Bxww0oiY/gVgXH+rcV1mvstHbMYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRxHlnzNuTr1Krm6uEV5cYmaCievE5baQ5JIGeQBlYk=;
 b=LjoeW0UiDWU7C8XaCF5AYlii+vzKU9V/lk4uBxAWru3jYILDKRjfiWw2rsOgv3tSUOwIyPEZYX64T//4KMyukGRFflWi/9GQ58fYK7ZF5Z5olhowL4IkQghSylayXzdkYeJidNFDZYZOS8UfveRtvSGBWwSV8uVW+kkBMoxip44Cbry+GxMYfYHomsNWHI+Qoa69QvXZ0TJxgynCep6z2sENxZFJk/yUX3Uc1LkXBTd5WX6Z/Dk4+a2dkGp62Ofa7i/IohUhT8fCqEg9zk7Lo7nAEr8hBUBVGH5bKv8/HEWcnb67ye0HK89OEeFqvktIef8XC6uZmTkA4pNIHOef+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CH3PR11MB7252.namprd11.prod.outlook.com (2603:10b6:610:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 15:30:33 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 15:30:33 +0000
Date: Mon, 15 May 2023 17:30:27 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 5/7] net: lan966x: Add support for offloading
 default prio
Message-ID: <ZGJQEy+zFFfCdDRm@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
 <20230514201029.1867738-6-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230514201029.1867738-6-horatiu.vultur@microchip.com>
X-ClientProxiedBy: LNXP123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::33) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CH3PR11MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f071e2-023c-4d84-a8ba-08db55595284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+jGRmSBEbUnuN36hd/TorKtbV99z20PziqU5gcnUmq8FrxoOLyTSoCcoLqAL9IksC5uOfkrQ8WVZvp3nNwcUsUk+u/Q0SlHTiLjY8oBCxS9zzOq1dzG/I5uMZ3OIpdJAY2M7IY88sjqTihYoulbdRNeFBXuzLODg3/OSC7/8u4Yny3+i6WkHcz8ekj5NnphTYCQsrbq2VBu3Gp9Ev6FNsYHagsKXZpKZ990pyse2VPdVO2Y4ZpsJQHhbBvK/Sgjg6aa+cxmYEZEiQOheB5ICEDJfcjo3U27TSgXS8eS4pwXdBzTIGzD2PZz+xwAci7brU/POXuzLxqhrQVDg2o/AeZclfZRma3oj3p64c+mA1Z/UwWnHkoeVyO8tAvO66ZXO4ahGOg8L6B6YWJu4WQ3kffs2wEMzT8zYPpIlcBjfHzmZc7WORVQounMnc6voenAyFeYzGLO/SQ8CnM0Q2Nfa9VM0LsYeBea9Z29Mcb/m7VRCRLf/v7DseH40oSVJNYAaQ+ZMQkaD39ZkCLd5gkAISmlLGC1qbMFKiVHDNi9wOwgUgUS5nItks50bxsyfn5IQeHws3+aeGpoVzf3BJ2VQq/h/zrOMd2wdmNpt5YpgFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199021)(478600001)(8676002)(44832011)(8936002)(5660300002)(4744005)(2906002)(33716001)(86362001)(6916009)(4326008)(82960400001)(66476007)(66556008)(66946007)(316002)(26005)(41300700001)(38100700002)(186003)(6506007)(9686003)(83380400001)(6512007)(6486002)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cu69hKfq/uFgAccCdXHIlB+ujk9k/ILFTqCuJP04j2EHERGpOb46PIBzLMWl?=
 =?us-ascii?Q?82xI20ay3Iqi56rOOqlQP/Co7AsXiq+lE0x8Co24+Hay/z11hfPY4oYq6nXM?=
 =?us-ascii?Q?oq5NXgZ46TAzuD3YJ54cdtGok/hhEYhq4c4A3sNgV3JNOtfTh0O5ONLogqIo?=
 =?us-ascii?Q?iT9/A5ku5iH8rMygAusc4LH7et0qVy+qCXnFBUxKuicFxc5zxIBOs2658yB6?=
 =?us-ascii?Q?FcLNfT32qYIQg7xov8fu6HoG+ol8qzrVHge5hXnaAv6Oz0u78P/U5FzRwT1A?=
 =?us-ascii?Q?B6aN5z3TxnS9HZNz5t64Z+23O4/vH4loZs56X8lUNJQSNwtN+/3p4s3aGh8L?=
 =?us-ascii?Q?roSFbFW8CdqDrnt8mZlMMK8jt7gpDdgXc/eJ7O0WOOXwoqUZMJ9b50Y2Nziy?=
 =?us-ascii?Q?FPpVbNM2Y3/dO3L06+fpzJh3NoQ0AFMweBKykeYHlo7whQ7snBwpetJfgwaL?=
 =?us-ascii?Q?QT+9KYOha/uw2ZFo3jGb53Gtfhzhe1MndUpAJgQlb+z2gp7CXi1EFoDAGoG+?=
 =?us-ascii?Q?c+X5GEZmVWT6M4id56xfJ6t0L2wyqteyX/bs8OB3O72p8zGK0tAv71c3ez0l?=
 =?us-ascii?Q?n/73jLkzEgBFpSjmWs4UTLyI0Ua0NZ2BUOGjWdJfxBkTQenDYe7YqUzhytD0?=
 =?us-ascii?Q?2FsZPIqE2qxVL+Sjy+TGCKYiLURcX5O+ooOf8JSUM+1VyjHJ9+fJawdRva4n?=
 =?us-ascii?Q?HbyEfuJcdscBNYOd55fjMDyiWHv0O1vlbAd8gz87J2QdeSSTaWnwDo/3kJQX?=
 =?us-ascii?Q?Mf577oDcjhfP8bsXLGeIZdmLE9eRJbaSDzU2M/ibOgo3ueHA3kKwSNHj9Cr9?=
 =?us-ascii?Q?iwfTBrLDdc3Spe89hyOzMIQmbaIcOys/7Oj0GWEcFZaAjCma87VipO2C+L/H?=
 =?us-ascii?Q?HaVwjOGEvbw+nqN0kjNiKyWCWZatvghKQQt92kDQcCQBsN+yFv9rHbhPJkKE?=
 =?us-ascii?Q?GDz3+YCKAjHQ15XFamAkjCk6UMjmo5je5giMst0U5bGKvn1KTWqGypB+xLEM?=
 =?us-ascii?Q?+xUNF05JHd2T7J4GpJDU4nPfre0imr42geKTNXBdyGwvFMOBnCGlSDqZXPlQ?=
 =?us-ascii?Q?YhmC94ktO7imHmVyJE9s4kZVuDEKN/FqcG7W0xACLlSmRL5ZP/9KoJIs1ZzP?=
 =?us-ascii?Q?zmyr7iqMk6B1ozuhJ7inKUlhoY/xrkABxWsZXmFdDH+COW5HaE0bg99EUO70?=
 =?us-ascii?Q?jvAtwDHHqGLR1gCFnz/lhouz6N4V9juzvyu7B95vK0bYqw3pYPt2XhfxeBPx?=
 =?us-ascii?Q?drSXtrQNx5Dga+g6tszGXYfyk8i8hniEXBOcDRnxOfcDeCL5SQbeTXbtvd1O?=
 =?us-ascii?Q?XLg3yI9xb/G9k6oPFq5O9XDGx8GA4NTKq549J3b3IUAQi/0fkghBe0aYKCa5?=
 =?us-ascii?Q?yd3m53NthVb+SHFMkCo9wNuPLW/K6y9AGgTNlGSzl2PQWpgzWQQDqIEpaN1S?=
 =?us-ascii?Q?7ymIgD/um4cPxqO+RbR3Xv2Ei4Tx2YIPTsk7QsUc8w7VK6ymc/Vx13tiO539?=
 =?us-ascii?Q?7ocOQmRDGvpv2dHAbUeA23yAGHTnAFFzUJ8VNLg0yAV3skHF+BFGMvTTUmnb?=
 =?us-ascii?Q?r0bE5ObGG4YFLtiJkiTEOVImXhur8AURBc63WmkJfaURpj187e0krI9hbqEN?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f071e2-023c-4d84-a8ba-08db55595284
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 15:30:32.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ixGUhlf8SX/V49ooQl0SUfvDQdssPDGWxasXY0+Ms+Fu5R7UBE+br6VwoAat5zIlVK8ku2q3zAOkY9Pc2z0ubmPc2kpFIbhUpH79iKeNww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7252
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:10:27PM +0200, Horatiu Vultur wrote:
> Add support for offloading default prio.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

...

> @@ -106,6 +111,13 @@ static int lan966x_dcb_app_validate(struct net_device *dev,
>  	int err = 0;
>  
>  	switch (app->selector) {
> +	/* Default priority checks */
> +	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +		if (app->protocol != 0)
nit, you can just do: if (app->protocol)

> +			err = -EINVAL;
> +		else if (app->priority >= NUM_PRIO_QUEUES)
> +			err = -ERANGE;
> +		break;

...

