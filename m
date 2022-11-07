Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A161FD2B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiKGSRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbiKGSR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:17:28 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799092717A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844960; x=1699380960;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2tVyZdY+lJdd62t79ZZd2bb7s7GnAyyCb9jfoUgFick=;
  b=B1ldRXQh0YAgQekgS87SMPIi/lvedjdicRV9C0APIkj77sCXv05sosgC
   1bf8EdSn+95HfJjOWmhP5DqIeADL8N8sWEyI1FJW0nyyx0WJBOQOVi9ZV
   Oy3KOu6bbx2Vvbss7+GplmJDaELDeeO9FuRKFJ9MB0w8w2PYHfttCXQL5
   XzQ/yp16R2vBiO6RGuIWxUbXVLCj6maUhHXkDINzyZSwz9xjqnHrEvt2Q
   yj20dcQaSoPmYcqqlfcITa6hptldLgKIZ9F6xJH9Wpdrrkop/m5mnq+gc
   uzMTGEONIJdlZ+PofiEdl0M9mohkD+vwu2HE/lld5BeKIV1CA4/ofTH8o
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290874646"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290874646"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:16:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965263845"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="965263845"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 10:15:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 10:15:59 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3ge8OXbpod8lvxrCwFOViGhOlvT4xKEFiZJClTZoWKT995ubVTXu22r0hPNRafAC01Hyozai08uBmfKDfblzajimMX2JWcf7fzT/HtcavrF0cf/V0ElQmcMdC1N4GmxfO8+OvZTwqDmAUEIKKcm9veW1Aq2Gnnwb6odzLXhljs8dhbMzTtqnbFXp+zjJhe6SQcEOSjOS2OI5MtrZ6t9NV9FwCJCYOp6ReE0dJtQhE8NU/pHi6reHQpNpP0aMFca0Bloiyi8YXpMWZrKBX3czfMIqQ5eNUmrE6bGj52vIoBC7Lt6rGQ+9CE1AQfyKONcYHFC1E3hD4nd9fqmqLglrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfBKKWu8EbeHrsGwFm01DXWMA+Ydr6ozz0Xu0evN08Y=;
 b=i7wGQoHTvwCUy+DWz2gUz63g0Fw/7df6fxKguB7zTj9jQy3rCnyP5qPdDYkoZNkzC/d9WbidQCGPO5zcVFhz2aUdKvJdioaWhEXJw6SVfRAqfB/1mTt7SP1+dT6FNR4FOZRZUXxCe/1I6mdS/ORfZnAGoaIfXOKUTOAp8vPuO2DRimp/pCcc6GVKWqGL2XsxeKx9XcO+QiHRmqGdHGpIjaqj7g6qhh9TYJ1J8pKTNcnC2Vmv8Ky4o3a45H/LHdPoVJ5hZMdNTqYa9FAd4W4jOq1MKiYFxHGtuHr5bbdOcsZ2u+Xo1giRazOhk9Xo2740i25UGaHlNaAfE8yBg8bNrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH0PR11MB5045.namprd11.prod.outlook.com (2603:10b6:510:3f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 18:15:55 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Mon, 7 Nov 2022
 18:15:55 +0000
Message-ID: <abcfad1e-b5e7-ea85-ccb3-27bcb4f8c58b@intel.com>
Date:   Mon, 7 Nov 2022 19:15:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-2-michal.wilczynski@intel.com>
 <20221104191021.588acef2@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221104191021.588acef2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0091.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::32) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH0PR11MB5045:EE_
X-MS-Office365-Filtering-Correlation-Id: 557a63c0-9264-481c-ba56-08dac0ec1ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tYZ+OcIcghuCXdJ6dfJwsAsByUiF73bOjzddSZzmfaGiRA8CT1m2A6eQFaEpigJEulxIFcDbpOkjvgqtisMWedRat/feGrqtUc7DvrDz2H9vg1fxObcqGAm7cae4PZ/EAEPdhzA+d+wFkB+G6mREPdspcTdeRoYUgjTm0nvChQYyEyoCbQ9BI6KTyN/YlqqDSFL5fkviNBbUUzBvLD1BcXxNLGdApkp75MY+Ihg2FnjVghQmGN/RUiUVgIa1LF5zl4G15RwpJChKuPw5zu6QKDmanSPHdWjQjhBI5XoTrAHKYXulhELYySZ8OOH7YCzf1M9SwT9v/70RkuOR0Jpl5pBSOhZBdCYsBnruiBd+Sg3UDS7PYq5EkkE58u24Z7upHV1uE3OMjhK66+FwLQd+VrSGdAfi1zgZ6k+4K2vtp/ppF8cxy3RRSgtw74mToJirOJcRf2MOobHuykiNZYTk9wx8L5YtwqQ7CcT+HabtTupVkaqHDNKAfpMSxadK9sUO5gkbbzDBJsf/WMLyAxavW7EwA5ThBDCfM7I2M5IecAAulrLTPu7zBevr39dFDXHNPFYr+sxJvQEWAl6uv4H/xtU/FMSpClpZRcndCnum2Ogrz7RN8jI1BVJ5POzd+gkzt9H/5q/qGB2OcQKminf0U3qbFTw78dzkpaDI5xMX+Prsn7slpheqYjtxIZtMtxnUq4UpZUeeCmmL4EevWPX76feTtfw5EQnntNBQtQOfuFqfSdLCbybAmC4x34F2tWBoh5uW6/wgs6C6te4CIG60UP/DT5h4Uh6lWt9Zpu+Tzs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(53546011)(6512007)(26005)(2616005)(6666004)(186003)(6506007)(66946007)(4744005)(2906002)(316002)(4326008)(6916009)(6486002)(8676002)(38100700002)(41300700001)(5660300002)(8936002)(66556008)(66476007)(478600001)(36756003)(86362001)(82960400001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGRoMXVyb2ErNjVHYkdRdXBwT0hkQTFiS0NabUQ2NmRtcXRkSm9pek4zTHlD?=
 =?utf-8?B?TFBMVHc2a3ZXSDF5R3NnMk0yUmsxUmtxeE1NRUlDZ2RvWElmb2tTQkhuSG1I?=
 =?utf-8?B?ZWwzKzBzY2hucTVLMU94Q3hQcjNtZm85ZDFid01mMmdDa3BjTnpLOW9vdmc3?=
 =?utf-8?B?R1ZZK2lIeGUxUnZvRURoNGtKY1AxUWZGbUIvdGhncGpFdStBMUIraWZ4ei91?=
 =?utf-8?B?eVhTSE4xVW5SbVIrTVJEdXUxVUNPZ2RvQnZaOC9tYXlOQlVaZDJ0SUVKdEFM?=
 =?utf-8?B?TnFyUllNTVh3dlJmN2R6V3ZmSnNLdEhsNjdmWHg5Y2NGeDlhTkZYYm0zS1ls?=
 =?utf-8?B?Um1zblkvdWVMQ1V0eGRzRmhXbmw5cGhDVGUveDFibVFsdFliTVBwV3BrVUcv?=
 =?utf-8?B?c2x1enBWVTdBZGFsSGFTWGp1WWt3SXVBakxyRlpSa2hmQ3U5VW5NR2oxaHo0?=
 =?utf-8?B?S0tFY1pjYkdpMVptTUs4bkpGdFY1ek81TVNVSFRMczJ0Z0hsNW1EeTVyeVgx?=
 =?utf-8?B?RHBKNDQwUThkWkNVVjM5aFVwL3RLRzZ1TlBIWkdVcndJTUp2NkVJd1pMRnBz?=
 =?utf-8?B?eXdYVi8vS3lVUFNqbTdwQXNZZE1WeWUwdExuUE5ibUJSaTRCaURjRmtBL1hs?=
 =?utf-8?B?anhiTXlkVnNNaUp5NHBLNWN3QzFub2ZsZzhmUVRHckhOZFloZGxrRzJ1bkNm?=
 =?utf-8?B?aTE3b0ZWbjVJT2VJSVpWb0lKdHZFWXFkZmpLZGRHWWY0SEJhNGtmUm9hMXZv?=
 =?utf-8?B?RkNhR0t6a2d5aGFRUWRWOFBVZ2pwS2lzZ2dScXl6SVI5QW5HZUIxL1JacFp6?=
 =?utf-8?B?bC9qc09LNUQzQ2dxZ0QzcVcvMEhnTU5FYSs5T2s3ZFpQenhxOG42ODdjWGY3?=
 =?utf-8?B?QjZjUEZPQzNGR3l3VU1JRk0xZEtNN3JMN2pRbHhSUzcyNmNycmZWNTg4SUNI?=
 =?utf-8?B?UG8zWTFFYUd0RUpndHdMWHJQeDhlSlNCNm15T2Z6Tzh4ZldKbTJySzVGSmVO?=
 =?utf-8?B?NDBTcENqK2d2WEFuOVRlWkRxc0ltSXhRUFVXZzh2NlkvaWhROHRKOUhWeXJz?=
 =?utf-8?B?S3NFMVlMMHlBTmxqakNKbE9haEYxY3U2TWtRYTBLaG1vSFFHZ3FvSG5FZ1p2?=
 =?utf-8?B?K2Y4aE13aldvM3F5U1dHWEp0bE5MTjMvbE9ZVGZVV1N3a1hsQUpPOW1hTUpM?=
 =?utf-8?B?SHB3eTdHY3B1d0xXczAxN3lJcFlnd2hUcjBCYjN1aGVxSUdNVUc1cWFrbzVa?=
 =?utf-8?B?cFNRWlpjQXl3dTlab1RqQlQxSjhhc1R0SXlCdzhZZEovVzhIQ1VENGZPcHBj?=
 =?utf-8?B?RUF4Q3pVZjE0UmJaSE1VOWNTb1EzMCsrUWw2VVJjbUlmMEZiMUxmZEpqeVE4?=
 =?utf-8?B?cmVMMzRQWDlDYmhrM2RxU0kwQ2R4aHV4MVhqdFFoNlh2Y1hqWlEwM1JtM1Ir?=
 =?utf-8?B?N2dwMnFDUmliZ1JsejcreWZQWEg3bDIyKzlBTmhWa2dwS3JlTm44Y1ZOM25K?=
 =?utf-8?B?THJweUk0MWFLaThDd3pmMVIyZ1FvaVhnalBTR3gxV1R3VzlHSHkySytsam1o?=
 =?utf-8?B?RXpSMnB2aGJmUnlVSTBReHJLY01mUTUvY1RlTnQybS9mNVBDU29WUyt6bEkz?=
 =?utf-8?B?alBYd0VoVWhPSFBWczlPdGVPMUZQMnNkQ1NMQmo1cXhZeFF3R3FFbkk5M3Fy?=
 =?utf-8?B?Snk1OXVtVEhJbEtCcENQc1JvN3hWQ2pGbXRTV0xZbmpOeXFibStrUFdPYnlv?=
 =?utf-8?B?YVBPM0N6Um9PNVVMRGNLOWJQNk1LU3E2YjhTckN0N2lGSXZadmE2b0ZHOFVk?=
 =?utf-8?B?NzVsbDRRMFIyR1ZGMmlNMjl6cnN0bUJOTWxyWmgyb3lKbXVmZDM0UjdJM2JU?=
 =?utf-8?B?MklsemZQaHNKckdPTzlrSjQxaGFOMnBxVkpLWEpaTHJ3UXVKemxGMUVVdG16?=
 =?utf-8?B?RyttM2ZjTGRiaFRJWFR4Q3NtQ3dIMHMrNzcrS2dOVHk4NDBRZGorY3loQjlV?=
 =?utf-8?B?eHlTdkJYK0xrN24zS3hldG5scVVCYk5LQktlQTYwRG0xU29venNCb3B3czd0?=
 =?utf-8?B?eFN1RVluTDRMZzdIenFrMFczZGR1R3c4UzRHdkQ5OUlDYlNrdGF4NDF5U085?=
 =?utf-8?B?dHVQTUUrQ1NzWi9xSmNQNEN6R3pSczljME9vNUFzSTdUMS9neERHMDcveXFL?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 557a63c0-9264-481c-ba56-08dac0ec1ccd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 18:15:55.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDc4NdvVyOdQMC56jQttJBHKXiYQ1uXVOssknLRRDZRdHlP2Hu5uXxFQrsAF1rBeR1vwIysQ7MNq4bGW8Gnh9Bor8Z766I1FD4Jxx1IoguI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5045
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/2022 3:10 AM, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 15:30:54 +0100 Michal Wilczynski wrote:
>> +		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
>> +			NL_SET_ERR_MSG_MOD(info->extack,
>> +					   "TX priority set isn't supported for the leafs");
> Please point to the attribute - NL_SET_ERR_MSG_ATTR().
>
> I'm not entirely sure why we keep slapping the _MOD() on the extacks,
> but if you care to keep that you may need to add the _MOD flavor of
> the above.

Changed to this macro in v10, thanks


