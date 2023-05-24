Return-Path: <netdev+bounces-5110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 689C870FAB6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EA84281385
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31ACB19BCD;
	Wed, 24 May 2023 15:47:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBA19BB3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:47:54 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0FA197;
	Wed, 24 May 2023 08:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684943251; x=1716479251;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L/bOoFoKtGT8JBHUjEWHEV8g5oyvjGsAUUBoSRfqY20=;
  b=OOBlHh7BaLgMUCKHwZh4qfIkmSN+IjxkiiGshagbKlHYmw/c5UASG8vI
   CnMSDqWd0M+tDPH4RzobUnyugkb7JeXEQRHlABlVl5l8gaAE8LJFdfzsz
   EVZudzLrrCPIuzxhrmwd5zA/Jisjp81DQLctuEC36DhEugh1KOq3kaeG4
   pVXhIFaHk+JGD1OQpxE0ozqyRnKgDyOF13BF2SQEHrjkNx1J4Ku7NcYK/
   eaomsmrqVRH5Margo/SX+T7TlXfm3cDIUtecNI2ITQ7wDxWnujrBYlfm3
   Jfeaby2E0kl0uSMtDgSFqvS2caagahB9tsZDago52imdbcTTi/aFgDxGM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417066930"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="417066930"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 08:46:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="735234913"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="735234913"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2023 08:46:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 08:46:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 08:46:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 08:46:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPZ4djoUYDcx0H8PuhbboSuHhQatJ9EWs+oBTwWvzKKW646chZP8sTL2o/G61YZs1RS3lJzu3cZnNrbDGRD1b4CyXeJ+xiGENzufLzZxPRT84qSqAiK09OlHPCa38rzP7H0fB65UK3JHmerlThHBu3U/xGmmxcqlrFvVCaTWNbJj2ap8+6HQwepNI3zZt5Pemy3bUqKXvy7L39Elh+buPyvkdKSEPB1ZkyclM7y4ypSvqS/zEiEim2GGpoLYRTh3YsyphC2icfkQIOPBvR1N7icqwB4AOXCpGPrPdOMQGM36nMeh7Uwi50ZalhfOpPnEIrm1Uxib/sjCwXS2NbIaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfBUquu6djuZnnZt++wWPKx+Y8uNw+IPX/EWzUAcyPM=;
 b=d1SMxj+aRjT5ZK8cBnbufSbK7sbfIt2/UCpKERsT5eLdT5D4o1XU83Uui5ZdgpPJrSWpGa/YtgYoHn9/JzxTin/Vue9qhQAz9LltTx6cbpMfdtO1V7hTox/XWP3+7dy2oDxghKLOy2KgA+vz3ClhDY1+cTnr3jk+yercfdT450SOJ9U1a/FagJp60Jpw9DjnSP4QeKgmB8mlCHXWwzmU2DuLNaJHuwRaxPj6Tds6DmTbbU0kDrKKoa0LWH5Q1Nye16Fq1lhCUQvARoSFH31Axn05TxBt/N2s0p0xapPaoXVSaGjn3AnXJJcrdJnGb2F+vQaJVBvcG3AYJ51/084X0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH7PR11MB8122.namprd11.prod.outlook.com (2603:10b6:510:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 15:46:36 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 15:46:36 +0000
Message-ID: <dc30f485-8a91-74e7-0ad8-0388269cfee6@intel.com>
Date: Wed, 24 May 2023 08:46:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] overflow: Add struct_size_t() helper
To: Alexander Lobakin <aleksander.lobakin@intel.com>, Jakub Kicinski
	<kuba@kernel.org>, Kees Cook <keescook@chromium.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Daniel Latypov
	<dlatypov@google.com>, <storagedev@microchip.com>,
	<linux-nvme@lists.infradead.org>, James Smart <james.smart@broadcom.com>,
	"Guo Xuenan" <guoxuenan@huawei.com>, Eric Dumazet <edumazet@google.com>,
	<linux-hardening@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Sagi
 Grimberg" <sagi@grimberg.me>, <linux-scsi@vger.kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
	Christoph Hellwig <hch@infradead.org>, <intel-wired-lan@lists.osuosl.org>,
	Paolo Abeni <pabeni@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>, Dave Chinner
	<dchinner@redhat.com>, Keith Busch <kbusch@kernel.org>, HighPoint Linux Team
	<linux@highpoint-tech.com>, <megaraidlinux.pdl@broadcom.com>, Jens Axboe
	<axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	<netdev@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>, Sumit Saxena
	<sumit.saxena@broadcom.com>, Tales Aparecida <tales.aparecida@gmail.com>,
	"Don Brace" <don.brace@microchip.com>, "David S. Miller"
	<davem@davemloft.net>
References: <20230522211810.never.421-kees@kernel.org>
 <20230523205354.06b147c6@kernel.org>
 <1d909989-5418-17ca-f161-67b4c05c6fb2@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <1d909989-5418-17ca-f161-67b4c05c6fb2@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH7PR11MB8122:EE_
X-MS-Office365-Filtering-Correlation-Id: 58ecc161-4c40-49be-74b2-08db5c6e0df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ana+CSSfTzo8LDZ2xhGD9lmxxZDgAI7FAevcSEO5bkNrsHJ4bK4h5JVUdUzX/2Jn3fNXpKQe19OTIvwo1k5djwzPvn6NrTUE9BYYsqd0ygqIkFSLENBl/d3gNGspUYqQx1hFkJ5GPwVpLCSOyEdfXoeVEAlyiFASkOueuwAS0qY8OvkTBxXFiqoZ9phG3XW7FG2H5ig1QKFnJNLfzz1xOoemoTyUnpsi8JF21rH+/Gj7V95TZ8TzVT7xNK1hD2fMtW3auvr4PxBFT3t48svlbUGiD/qxiU/HXL356c5lGdfOGIgvU0GdcDEv6soUt0CE+FlfNCwHcXUkfsgujP3njUXSwYm2EAzahn1OIpiCwMj+pjkwFfI9AFhl/QNrOzv8klCN9mpKHdLdsMGqEoS8yOvqzHa3xZ3miNN4428WiOeL2Ozn7GnNfCSoDjJOyyWiRvZEOX4vF3CU/ltZfPuQ8PiufBcFMOzMAsPedoRpCtdJ7YvwLnj5MlXabs9+UYGQtDZy365Ys8dsrSe0Wo/zaU/yxJVf24UROsTyKmg7JV7Nf5gYEeJlXfBcF8VL6kyYvEDadX0ebzLL8pLJHJ144N93k4rUYO2i0+rkei+v6tTMEcBG5xIYoJOPxhejbca6VxeY1G6mJQjkXfQ7oWOqeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(6666004)(41300700001)(6486002)(6506007)(186003)(2906002)(53546011)(6512007)(26005)(86362001)(31696002)(2616005)(82960400001)(38100700002)(5660300002)(7406005)(7416002)(36756003)(8676002)(8936002)(66946007)(66556008)(66476007)(4326008)(31686004)(110136005)(54906003)(478600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHBhdlhUSGhGZE02VjN6L1F4NHI3OUFjS1VVbUZtT0Q2MEU4UFBJU004Q3B6?=
 =?utf-8?B?ak9EeG85bVAzVVVxV2xHbzlYUGNobXdndTVlWnRRaXJtaHNiY1FhbVVqd2Zw?=
 =?utf-8?B?WE5nRVdCUVcrY0FJMXlRS29XTkdvMDgxclFlenRIbzl2a1lBUytncEYzeTJr?=
 =?utf-8?B?RVdzczBwVWVxTnlKdGZ5SkRNbDhMTFFBL2ZMdE9sb1BPSEYwaXZvMjZBVjQ1?=
 =?utf-8?B?NTdodVYxN21YcVh4ZytRWUtycTg3RUFMa1lWdWhLYXBTN0dHTEoxZzJDdDVi?=
 =?utf-8?B?ODdCcGMySkVUaDB0RytLeXliZXZvUndXWW5zL1E1YUorYWRBT2RONXN1cUZ1?=
 =?utf-8?B?cHhFZEpBMUltb21sOTZzdkFtWVFSNHFLN2pRUjNnWWtuQXA0NDR6WlZSRi81?=
 =?utf-8?B?SStLL1BTSVRvT3BXS3ZUenFJTnlPaDhOVkYxbWZlUEN2VXVpVUhhbmdjQnkx?=
 =?utf-8?B?clBtYXR6UFRocE9QSXZxRk9VUHJYaEZEZVVsVDc0TnVCQjFNeHhEN1BFWk0y?=
 =?utf-8?B?Z3piYUhpTWVpTUtoVFhPNnJDYzlDSTB5T3JYZTFWY3FNNkpJaG8zV3BJZWFF?=
 =?utf-8?B?bXBaMFhTYzcybXhEeUY4WnJkaEJDMmNFSitiS2hsV0IrNlFTRnBSeG5jOWhO?=
 =?utf-8?B?S1RiWnRaZ2FGVVJPVVFQenFBeTNMVVB1QUVCSENLUHM0MVp3cXhoNkxQWnNB?=
 =?utf-8?B?SUF5OGxKMC9SeUNHTzdQTmNHL3pkSjljZ1drQ2ppemxFTnZTZlVZZHJscGI1?=
 =?utf-8?B?WDk1MkVLMzJjT0JrTE8xbks0L3FHU1pobTBHNjkzaytscWFETStzRmJUcU15?=
 =?utf-8?B?ZDJQYVd3REhyL29rdnBHYWRKK2hqUGYwMnZSb3VQVm44UDJSYS8zTGNzdThh?=
 =?utf-8?B?ZC9DcU5JY0hnM1lRM0k0Rm84SVdqb3dwcnhEeHphZjJLbmZZVjEvNjZ6YXdz?=
 =?utf-8?B?UURiYnBaeE0xa3lZUzN4VGk5ZFdPeXE0QVVMNDYzM1NEOWN0ZFMwOS8vUDFt?=
 =?utf-8?B?WWM1MWNHbU9rMUhSVllhMzZORnBqVVd0cGwvM0lqZ0h2bjJDRU1IYUl6dEFw?=
 =?utf-8?B?WE5NdXhNa3ovRTNNVWlwVVp2U25Jd0NadjZrMk9BVGtoR3lwK0QvWHFoN0NH?=
 =?utf-8?B?eGw2MUEyRjVWSGxDK1VwQk84SUxKUlYvWnVaU3JINUxBUTc1V3c5dTFEQTRB?=
 =?utf-8?B?S1dqVkFoa0xRZVRIZERoeThSNWNmVzhuTytPdGlVRGpIRTUvUzdkL2lvWkRR?=
 =?utf-8?B?alA0RkE4WC80SzBFdUZ0T2FQRGdxaEdoQ3d4NEdJdDdTbjE2NHNFa3IvMThW?=
 =?utf-8?B?bTc3MjdNanFsdURmdjlHSkpzdVJVVzJZTzNuUk1KZzNQNnlwekt1NnJ0SEpt?=
 =?utf-8?B?RVd2Q1JSQ24rdnY0UjJLTWM5TXpBTXdMakpZUDZhNG84WEtwMnMvdTVXc0Ro?=
 =?utf-8?B?V05pRHI4UGs2bnJkS2J0RHZrdVNjS050V0ttYmRsOTR6blJyV1hDVmIzU2J6?=
 =?utf-8?B?ek05VGlNdU9meU4zRXloNWFHSytKWVd0VzQ4SFhFM2hrYVExbnlBamNDR2l5?=
 =?utf-8?B?cDVTc2ZaaWUvaXVqL3FMdkJ5cEg1WDZDRXhHblprZ0xoamY4YzJjcDBSdk1D?=
 =?utf-8?B?MyszK3FPajFyQjFlSy92bGk2aGkraFNnNFVmQzNuRjNEbmJlQnQ0cXdocW5E?=
 =?utf-8?B?WGdiSmdpdjVyRWJGMkEzT1ZOOEtKZ0oyVWdsZXFjclhRRStYKzg0ZGNGQ0tq?=
 =?utf-8?B?a25BVVJUeFdiL3NTY3g2OEtMcHBCdlp0UXVWMm9NTENHMVlSYm1SbjREQUJT?=
 =?utf-8?B?Y25RZnhXWE9tMHk4S28xMGJwMzhCL0FjR0RhcDYwOUhmamJ2NEdRajZIcEdY?=
 =?utf-8?B?YmkrQithQ2g3TllPNEVCZzJHUy84c0dpRVV1aVVWQWxNc2FSN2FmZEZSNU5Q?=
 =?utf-8?B?YzBvaW5WRSs5dXhPKysvV0xiMTlzS2F1U0NaVklUVnEvRUZvYzhBbElhOSti?=
 =?utf-8?B?dDJxdUNsS095NGlWZEFnT1BadW9SNXdBYkZOOEVuUmppc0JiZ3paSFR5QTUz?=
 =?utf-8?B?WWJZVEd5Wm9KdmtpeFNibjNlT0NQTnJ4dytSclpNWTNteHdLNmRCZDBlN3RJ?=
 =?utf-8?B?cDVVblpSRmMrYzF4TkFRUzNPeC9WaEFnbUJHSkd1OWV2amZoaVA4b3FTOUEr?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ecc161-4c40-49be-74b2-08db5c6e0df4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:46:35.6834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/wMjDSB2ujJ5Smy4ysa73KD8Uw/sc6FEXfRX86dC2O8aIrrNDOq87SP94c/L6t39dbIOp00UbXDdCXGf3QD1m/0N5NaNB97IH6GidZKTCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8122
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/2023 7:17 AM, Alexander Lobakin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Tue, 23 May 2023 20:53:54 -0700
> 
>> On Mon, 22 May 2023 14:18:13 -0700 Kees Cook wrote:
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.h b/drivers/net/ethernet/intel/ice/ice_ddp.h
>>> index 37eadb3d27a8..41acfe26df1c 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_ddp.h
>>> +++ b/drivers/net/ethernet/intel/ice/ice_ddp.h
>>> @@ -185,7 +185,7 @@ struct ice_buf_hdr {
>>>   
>>>   #define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz)                                 \
>>>   	((ICE_PKG_BUF_SIZE -                                                  \
>>> -	  struct_size((struct ice_buf_hdr *)0, section_entry, 1) - (hd_sz)) / \
>>> +	  struct_size_t(struct ice_buf_hdr,  section_entry, 1) - (hd_sz)) / \
>>>   	 (ent_sz))
>>>   
>>>   /* ice package section IDs */
>>> @@ -297,7 +297,7 @@ struct ice_label_section {
>>>   };
>>>   
>>>   #define ICE_MAX_LABELS_IN_BUF                                             \
>>> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_label_section *)0, \
>>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_label_section,  \
>>>   					   label, 1) -                    \
>>>   				       sizeof(struct ice_label),          \
>>>   			       sizeof(struct ice_label))
>>> @@ -352,7 +352,7 @@ struct ice_boost_tcam_section {
>>>   };
>>>   
>>>   #define ICE_MAX_BST_TCAMS_IN_BUF                                               \
>>> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_boost_tcam_section *)0, \
>>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_boost_tcam_section,  \
>>>   					   tcam, 1) -                          \
>>>   				       sizeof(struct ice_boost_tcam_entry),    \
>>>   			       sizeof(struct ice_boost_tcam_entry))
>>> @@ -372,8 +372,7 @@ struct ice_marker_ptype_tcam_section {
>>>   };
>>>   
>>>   #define ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF                                    \
>>> -	ICE_MAX_ENTRIES_IN_BUF(                                              \
>>> -		struct_size((struct ice_marker_ptype_tcam_section *)0, tcam, \
>>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_marker_ptype_tcam_section,  tcam, \
>>>   			    1) -                                             \
>>>   			sizeof(struct ice_marker_ptype_tcam_entry),          \
>>>   		sizeof(struct ice_marker_ptype_tcam_entry))
>>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>
>> but Intel ICE folks please speak up if this has a high chance of
>> conflicts, I think I've seen some ICE DDP patches flying around :(
> 
> I haven't found anything that would conflict with this, esp. since it
> implies no functional changes.

Same here. I'm not seeing any conflicts with the patches I'm aware of.

Thanks,
Tony

