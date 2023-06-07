Return-Path: <netdev+bounces-8861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C0D7261D3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57961C20BF1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEE135B47;
	Wed,  7 Jun 2023 13:58:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8A139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:58:01 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C131BF7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686146279; x=1717682279;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dcMzULzBYGs7wh49dBqHE0/FWSqDnLx0SPIzYjl4NWk=;
  b=mbXdMV/hkz6ZD5nf3wHXwVbkGAm/WRxj9zIuCyAFQjapVpUEgxWZc2Hk
   AImh15ziWlGXSSNOCQny4e0YWkkiSP/li/PFOwi2zh5wBBLqFHCNxUGn3
   oMMPky6mujaqDWSnhbLxso1Txw6hDPlReMm4t89dpSVkDOD56P/DLMoAA
   mGIXkwsjek5REj8ZROAmkNPrXU6DKccwc/BqRNDwuCxzZOfQU5jRcKrzL
   IeaiWir3Lx9WcHj+ZD9R8z5a4CrogBZbO7ogt2vVR4C/O8eFpkkpif9zU
   pg285ecDuYh2uToP9PIcURMFNP74/tumoiZwRXf09TvVIP46UU5IXxuxs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337350819"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="337350819"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 06:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="659954173"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="659954173"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 07 Jun 2023 06:57:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 06:57:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 06:57:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 06:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Li9/+titLBa8yat+EypGxfnppfRsMB2kGcK+X2CVeG28Y2RkG8uo/TkrVHVyRc2SndV/uPJOlYihW8MvhsYU+ArbLNb9ZZlPsWkwHctQKlUcky87HKMwgB+PseGbYHajhGyEvPtkfUR/ANTplox+z3P7+MxTKKgo7ADuZT2ZhyGBy+7+/My2Pg9Fxwf6QsaIDkMFD4ENrKVRcJqDHTOYUzTeDud0SqJxX1mn0auGuROqX5Z8Y8b1Pmcb3TLyH1LSWfd+rldC9XpDr19zGRJ/M0ImcR4VGadMfu9AB8WsAnMAK4UHZP5+ulw1V1GXWyRPUBHmENZS6mA1kTZayI7XfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UfaWo6cA29zt6/T0lsEBxs9o6t/N8Utle+ZKaOlvcQ=;
 b=JPzwJz4rKgvEG9tF9c2Xykw37rKFvzqL+1dWvY7Tthx3iDJ3pGSAB+ilgAxhFhMPG6UvsiKo+zAzCFcRfNaoRj301IKiAcQsKqMblUm2pXcyqglk/hHfPyEMGPelxswgrhQ5yQaSCmnAF25O4yerXLxFR5gasXS1EgPOv4xn7ftgLD1eZMAetwzAOGkKzc/mgicLOvn15guqB4XcB2m4fJ4L+9csRNMLWt+giG/QABbiJGXkBjjP2mFNG9T90Ud2ZWkwcOa6AHjYUnSZW2O9wWlPRr0UUK0RYbbqrEfwFMZoGjlRYLDkAgP41vc4PIw26OpAFdmQ1jaOWYLNwB5n0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by MW4PR11MB7032.namprd11.prod.outlook.com (2603:10b6:303:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 13:57:55 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:57:55 +0000
Message-ID: <e5f6407e-e19b-636a-a90b-3d1d6f7beca0@intel.com>
Date: Wed, 7 Jun 2023 15:57:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Content-Language: en-US
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>, Piotr Gardocki
	<piotrx.gardocki@intel.com>
CC: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>, <netdev@vger.kernel.org>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
In-Reply-To: <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::22) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|MW4PR11MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fef0491-ea07-41de-1063-08db675f3198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MatE8wGfoQ27iA86BrmW9SGjw9AJpk4XyJezk+eFtvYgKOws5HSFfYL1vvAovoPVKDetKJTXYr2qfrg0i4jTWMfiviNM+/ZSYEPzggTBaNrQIRNS2NDfuxgPqHNwhjOA2bAupvmPCjWiBX/uNpnhwJHrY0OyWBJCn/sLWHsmyehJ7U5fbkcehBj6mxpUCBXmNVzGswMMVMHRLSXu2a4WdDEA2LA9hZsAbJvXdH5LaTKXrLh1KP7ni0/a8b9GFR8TPGpxV9qVPYb5TbZQWYkEfcQYtgL1bYX0CO2b8GSFDa9zLMn3Fpc5p7RLx+h9BEPppJO855KwQ80D4TUrsVjw8+k/5c3FA4vZ0D4eOU/Cgiz+n2bQl/0L4Hms1MYsg0pcckctMCQLWozm56RnXeRmtCgjOWWEKZnH9I5vLGyFc+y0D7vRDp+txraQTKHTbhRPUi4WORdrDqWJ6jxQgDNznzpq8F+LeKUyBu2SOBD94d/oZ9wx4IbTk2rvoO7Suv35qmJ+RNtdAOgLkDWEqJ53bMcIN0PEFTo9m4osoNzStEy9GHnVrlF1bHgh+tcA3V3Sp2ToSppPkETBrjJrNu0Zh36sFu7hbsu2YChK9ktwRNVgAvc0umkQFvk/Gj+M6CSsq6C8WpNRHjjE+KN00z9QGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(53546011)(6512007)(6506007)(38100700002)(2616005)(41300700001)(26005)(6486002)(6666004)(31686004)(186003)(478600001)(110136005)(54906003)(2906002)(66556008)(66476007)(82960400001)(66946007)(316002)(5660300002)(8936002)(4326008)(4744005)(31696002)(8676002)(6636002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnhhQ0s3bGc1Y0o3RCtpMlFXVlRUWWU3NUJKOFdiNExZQ3pTTVpGcG53MUlF?=
 =?utf-8?B?YVNwM1dBVjNWSXQ0TjIxKzBsbEpHNnVQSitoSG1od2x2dkpyRTQ1T3owV1Ba?=
 =?utf-8?B?dk9iWlZDMW1OUVhIUVUvT1h5dnR3ZDk3SnVUUURHQlhwNk85VVRBQ0dTQzZk?=
 =?utf-8?B?UjVsTE1zZVFFVTQ3TlBaUXRSSlYzd1hXT2RHdEFrZjdwNlFLcmszc01xcHNL?=
 =?utf-8?B?cW11QjRRNXRlaTdBbjhuQithTGF2a1JJOHBaaUdYWiszL1o3WGVoR29GbXNX?=
 =?utf-8?B?STU1K2tlK2N1Mm1FRm1oRG5pRzYxcUlXTVNXNW4vWlJQZ2lzNk5GMjJSVEF2?=
 =?utf-8?B?TVY4WEowZVdiM0pZUmR4b09ZMUloTE5USERpQmVDaU01TnFRMzBSZjA1OXQ3?=
 =?utf-8?B?dlZZNFArRmtrTkdVdWc1OGhyQVZRRTZ6NUMyMzVVZXdjZXJRT2ZVd29vNVhy?=
 =?utf-8?B?NGhGVTVYTldnV0V6WlM5dElVSTVuNytkNzFPTE1IOUFocmh5RHpNaC9PVmtk?=
 =?utf-8?B?RDlSZW9aQUkydjhsdUV4b2NHRFFIT0QwS0x6by9oZldqcUpNUGpnWWd1WUtY?=
 =?utf-8?B?T3lXZkUzQlA0YVdjNUs1NFhtLy8wVDRLci9CK0lNdEw4UEZQeW5NMDRBbldI?=
 =?utf-8?B?d21sN1IzWFFMcmFHMGRTU0l2SGNmODZlZEovTGdkcmdQS2d5NWhvTzF6YkN5?=
 =?utf-8?B?OFh4cUl4VkhQLzBNZjVIb2tVRU9uMkJpVFZYWlhxMmVaSTg3OVorVTUrRkRH?=
 =?utf-8?B?UVloenFYcnZmTjRCSG9lOG1BVEczSXdCTEM1OWJVQ1owTnRYYlgxWkcxTGlF?=
 =?utf-8?B?L3NKU2xURlA0bUd1RTlmS2Y4ZHJDODhiNXpTMTJ6TzU3MC96MTJuejZBZTVX?=
 =?utf-8?B?MjF3ajZrRFFhQnpBbC9qYUgvaFc4TGhPUFBlTkg3NUZiTmk0Z3U3UUZxRFVw?=
 =?utf-8?B?eU1OYU1lU1c3MFkvYWx2Sm52TjNhd0ZER0xTcWlid2ZCOGpNcVlUdCtsbU1R?=
 =?utf-8?B?bDl3L29kU3JocWF5TXFGd3hmMFRtbXJZT25VeTZraGJtYXZZT0NWeXZiMkxx?=
 =?utf-8?B?KzlvUmFJZ1l0dHdFVEk4NkVCVXkrbk9NZEx0TEpDWG5iOFFudFI3Zk5iT2Zn?=
 =?utf-8?B?cmF2RU4zZmNIakcyWnJxZThBdDVXc09jdUYxWk9VbzRuVis0YWdnVnVPOEtD?=
 =?utf-8?B?TGxadFJHN0RUV2ZrN0FzV1FkbFMrbDE4ZmRVbVZYY1BHMUlJeGFCYVRPcmJ6?=
 =?utf-8?B?b3NDZ01xZ09kTGpQT2wrR3V5WFMxdU1IdWRMODdCUTdZbktOSkNjeGZ0cklL?=
 =?utf-8?B?NHozKytGd1hKemI2b0l1SU1oVlFvQjgzMlBpWnRqbmVGT3Y1RkNTQTkwM2hJ?=
 =?utf-8?B?ajFjTzZ4MVpXQnJoa1pUaVBaSWFnZXBiUjg1bVp0OEhnT0h6N2ZSa0VvdlNW?=
 =?utf-8?B?WU0wY0I2Mmdzc2Q2cE5JWVJLMnJmM0hVN2tac3ZDQXF3UDk1WjNKYy9ob0ps?=
 =?utf-8?B?UTVYNGkraEJLeHF3T0dUL1ZBeWNyUmRvbFcyL2RqaENBWWR5dGV4c1Zqa2pH?=
 =?utf-8?B?K2NncnRTWWZuTXdvcExLT2dwZDJxdzVidzVuckxxSUlrSk5NZVRid3A5cnNr?=
 =?utf-8?B?dml2YU9LRWErL3VFQmNDcmFCNDJwYkRwdmM2amVzYzQ1VlRXK0o2ck8xY2pI?=
 =?utf-8?B?VURZSXRKTlZyZWRxbXJyRmVka3g2U1d3Qm5qWkh5d3dlbHlxY2VwL1p3MUxn?=
 =?utf-8?B?eTIxUEIrVkJjNHBuTVJhZjNrNkVkNVJyMzZ3WjFYenZlTEFOcUx1ME1XbU1T?=
 =?utf-8?B?NEJQelIwRlJHRk83bjdHSktpd1pGV1hpWCsrSUVsd0o0UGZrUG05dFZ5TUlW?=
 =?utf-8?B?eVJ2QUFJem9rOEdyV2lHRVpEajFiN21uR1VaZElTREVuRzRQZWVaaDgvRXJw?=
 =?utf-8?B?NXRWelgzVE1yU3JBVk03dzRZYWNZZkZHU3BvVVFpaXJqTXJuRXluU3hNOGc5?=
 =?utf-8?B?aWp4enlUTy9VMWh4Nm9USjZRVjRlWm9xY3A1RVdpK3RPQjlNUEl5ak9GcUt6?=
 =?utf-8?B?NGxCSSt0SzB4N1lBSVNGSjdlQUtSQzFEYzhiU1Y2d2hsSUs1bzFKazZ3NGRK?=
 =?utf-8?B?a3FKbWQwSzI4NkMyWEhlemczL3VTNmhrQVlueGFGditncGJLRXFCRlpsVjdw?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fef0491-ea07-41de-1063-08db675f3198
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 13:57:55.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4gH3msM7+U9Ol5QOAyEFmR6fqlnExWkRp1uNnXByZZDrDMLdhLp5nPiMWbW/BDx7zuyQ3Z+0BfNhepZpHKKyo3bByTJFC40P1o9WKns2fI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7032
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/23 12:14, Przemek Kitszel wrote:
> On 6/5/23 21:17, Maciej Fijalkowski wrote:
>> On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
>>> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>>
>>> Defer removal of current primary MAC until a replacement is 
>>> successfully added.
>>> Previous implementation would left filter list with no primary MAC.
>>

[...]

Tony, without Piotr's patch for short-cutting new Mac == old Mac case, 
supposedly my patch would not work (we have to either re-test via our 
VAL or just wait for Piotr's next version).

Przemek

