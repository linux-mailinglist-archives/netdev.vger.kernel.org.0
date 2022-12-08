Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE11646659
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiLHBN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLHBM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:12:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F129075A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461947; x=1701997947;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nAWMpabl+6jlcmzWRYSaXDRCt9+8XNVtu22wrrSHtUg=;
  b=mxNCmkp1mOFE2r2A4k2UEa96YRMb9jH9bDdAgIBDSCjOL4OghseVpYpS
   QcKVrvvWzsWPfmxwTH3N7wSlta5aMhwv3ZEsemDdfaOmW6spfH5X2q4C2
   yAPTROxA7FWzzE0Lx80+8kM6uV0AkCDMxHqg5hf1FZn37lCWVoB78pH2K
   hB2FJimjOzCpZQ1UYLGVl3XWCoTIYbUZhU/UZ0KiXX7eqm+ot6oZ2yT3S
   xuiu1gZH1APWKXVNZ9d6prCUpq3M/qXWu/aUKNHrNYB3juXjdmjKAogC8
   86jf73w4T0qFr5Sw2ApOMh8iGZYMAMNMycHG22zUYbd495AtMm+YANS+a
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="314690648"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="314690648"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:12:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677568877"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="677568877"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 17:12:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 17:12:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 17:12:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 17:12:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk63n/AFqinQqJ8D8Pmoki3mE/dprCd/s6EhFcCAHCEYVgw1XvNCuyORQk81HW40EwyfScIfxLQBaxzn4kVHqrYAK6Sq9llupjI9V9cpKGCfNeIxVAjyr76XN0kkqKwh5wvdf724m6mtfgUpr3ke41SvczokzNtI0OuhVzNak2BZes83GKE44xrPDvkHryC2zh+WcImNO4KZ/kai/CORjWSvTFYwZk5fxqDisCj3YZPzcAYdW8BK7U9tWQvVi7opJaBRNMPY6dPNFBHDC1snFXchY7TuIWoKGW4lnwIerSYdN9KX45LMGpjYzULYQbQJPl2aNETwFeG7+Y244e6zcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGnER/zSUkZOgVOFKqt1bl4I0BponK2z78B0/HihwsI=;
 b=TeFyGotNXJZp+JW2vtU2wDKK2UIxV5pna/uY7SU33CFBvK5oQ4rPCTW5lz1a0ij6ATMuXEdRRIN0s1W9rBHoVoF6CEvsdXSoAwk68R7IqpdGizwhT9yYIAz8YBSlc3jyhRGVhMgkIrgzZ/QMRwqDYuO130b4Xpf88P9n26BKoafm5TFI/kvWarCWoUtg/vNHG+lf99lcY4/K/5QWskr5JtXaK+pbvPTV+vkwqzUNWcqpPirT+zexa1yYzWos3yrWrLRZ7RY3BxxHwmc5eNgzKGG8+ZOU1ygOBtiuLZ4BdjJIm9VWZeliMiX23P3z1MPzmp6XyW9pcTiO2/S46Q+EPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 01:12:22 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 01:12:22 +0000
Message-ID: <2ae326bd-a8a0-ce88-606d-32da3dc96597@intel.com>
Date:   Wed, 7 Dec 2022 17:12:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 12/15] ice: handle flushing stale Tx
 timestamps in ice_ptp_tx_tstamp
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <leon@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-13-anthony.l.nguyen@intel.com>
 <Y5EoRXaFs3mjrTLE@x130>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5EoRXaFs3mjrTLE@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P222CA0015.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ1PR11MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: 849f63a3-31f2-42c1-56ca-08dad8b94130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cnpVuFT7PVfRJc9S1Cp4PT9fm70Gkd4Jq3RJQnY0z+neTSg2nv0sFiqgP4CCPoAJXAyd8djBvtkfrs67odmHrc8+mx1TTBYSnPnqiIcVOEy+zyf74HjmQIKiigCXQUQVN7tUv+UZ77ylVo0SrDnHG9Im37Jpy+wjgzWnP4kEAHqkdGYAIYHjSGlQf/rsIpqVySLlqmrNMIdMEhDARajSJKMXRsyD7COBKsvuI+KaEY/9arWr5L9ijNZlS9sNbtcBdH1oBxa/0ZgaN5uwGbt2ORowYH0BfhMKxRbkgufnWobR85YfuVfT2n8nVmcmd2ZKLjU8F90dz/POqokN91oRGnzeVM8EXe+NHxV1MGymiviyat8MU069QkDQhBfdHCZuo/S4WAI2BA4lPwuCVugAYWsgMcbmyltNFDiIWOWMgXGsYMa06P12+j9FXrXB9ins23XRPSqov6FM4WTMPy3p5oAdXQz1l4HMTPDONorIFxioCa8g1R3jeMCw7Wt+/575mZo6JcV7jacorOh3B0foUx7DVUnufs7vpMXBZpmP2sk3K1RzzWUyLBS01pApcO+MJX7SE+3N2Q8EvwJOciqldiqFJw1O2DbL7xzOYkxObs3T0axGa4YFG03DiTbK+OxmM1AkknxKC9zNbJPg4q1gpuN8TiBLYrOY0G92b5fnfcKg91O0zFwfM/JCcqNRTDpAPlx+LFK5jG2DM+P2lPzbfYjl83iVIYeoQ9KyW1QGfTY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199015)(6916009)(2616005)(2906002)(41300700001)(38100700002)(36756003)(5660300002)(86362001)(53546011)(26005)(6512007)(6666004)(316002)(6506007)(107886003)(186003)(82960400001)(4744005)(478600001)(31696002)(8936002)(66946007)(83380400001)(4326008)(66556008)(8676002)(66476007)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ektvckNNbUs1Tzd1SGlYOC83cUdzbUNWTWEzWmlWRzUreFhoNjdJVk9INUxL?=
 =?utf-8?B?ZHdLWmpQRWs4dUExc1F0UXJrdGJMdFpXb2FxKzd5dHhabndiZTJza3g4bW1q?=
 =?utf-8?B?WWZUeWgyck9HVG5QWGgzV3N4aFl4YStpWHJCOTVENW1qVnVTbFF3WUsyc2Z2?=
 =?utf-8?B?eWs1ZlB2dURmOTlobDF3M1pRZjhTbE5jOUY5c25tbG1CeTdlY3c0VzVVVnVG?=
 =?utf-8?B?MFhxL3hBSjB4cWR3WkxOK3Jwd0JaSTJydElYcnVRV1loRmxrR25yV0hxTTFJ?=
 =?utf-8?B?a3Q1VWZMcHh2M0dkMCszM2hYQjZiNGxtWTZSei9iMUJ3WUZqRlFoV0hRcGJN?=
 =?utf-8?B?RnJ2emJzQWswR3hWRUFrWkRMbG4xM0JHRUFSdENQL2xkbTNWMk1ycEFqQVhY?=
 =?utf-8?B?SzZVaHJUSlhjK0kzZG1uVTZiYjB6YW5Nc3FaU3VkbWo1N3NCdWo0WjBvUWRr?=
 =?utf-8?B?WDJLOEp5a2V5SlkxbHdDTkMxclE3Rmh4amV3cm1YVWxNZno1V2pqS0hRMU0w?=
 =?utf-8?B?Z0E2RmNzSXRKYjhyc2gwV2gzOXFWUThZNXZpQWdRQUphYVV6c2V6bGtuQUxo?=
 =?utf-8?B?ZFdhNWh2ZmNaY25EUk4xeW96amRFTU8zY0s2ekt2bEJGQ2F3VFZIbjA1TUVH?=
 =?utf-8?B?NzNoWGpOV2dxaUloNFROSW9Xc09IWWtKM1Z5MmVEQ0d6cE1EaUEyUlp1cnpB?=
 =?utf-8?B?RmkrL3pSQnVyRytjV084M3RkQzNhN25VWHVDV3FGNysvOU5MYUpxY2t5VVQr?=
 =?utf-8?B?c2VhR1RQNFE0NnY0QXZJdHBnL3FoaGRFWUN2NHFuZ1BaWGVoc2lxaFJ6amhL?=
 =?utf-8?B?cE1sbjN6RXhJSUNwbkZXOGg1QjN5UnJjcGJwWDBuUXRKV01tR0RIMkc4RzNH?=
 =?utf-8?B?bms2ZlcybzRlUWp2R0FkR0JRYkVIcEhhRVFNTFdPQlhWbk44VTNWeUZTeHZ6?=
 =?utf-8?B?QmRObW9xank4aGV5T0J5R1hpVDhCWm5jb3pidUJ5Tll2VVlkYmQ0YWFxd1dK?=
 =?utf-8?B?MVRjTjc3MzA1dEF2NVpRamcrOW5SRnk1VDQ4cFd2QTM4NWxZQTVESVJUUFIy?=
 =?utf-8?B?Mk1PLzR1dG56UXgwL3ExdFp5NExnNElaY3oyMWIyNXYrV2tPTmgvNVRJcnlT?=
 =?utf-8?B?ZStoWDdVdTc3R3EycjFsRkFQUWJxZEJsUnVodWNuR1NQeGYrNWs0b3djQ0x0?=
 =?utf-8?B?ZzA3OGVVK2M4eWJmZzNyMWt0MFFjcmZUVVNlNTdxdjV5M3JHYW40SUQwWS9Q?=
 =?utf-8?B?WDBrQ00zTTh5V0RZYnFHaGhBQW9EZEZBSkJVTk9Sb3N5REhXWjZUQkk0U0pW?=
 =?utf-8?B?bitDNWNTVDkwbHJ5Q0dLSm9xb1dUZ0hObXgyZEM3bVdHZDFoVmQrZkpRd2pY?=
 =?utf-8?B?MW02NVpCOUNMK1BoRW1odXBHRlYxdklMeFlVNFhUWTYzKzVRY2c4ak4vZHJZ?=
 =?utf-8?B?LzNuODNlVkRBRDNQVzMzT0VnaEM4UktKaE1iN2dBV2UvbEJkSkVtWVR4SUly?=
 =?utf-8?B?dDZtQkNaQURoVHFGanlVRS9zWEhzK2dEMEVONndrZ0Y0d3Bhb1NJTTlUeStG?=
 =?utf-8?B?b0IyOUEwVkVHd0dYRTd3QmYxV3pGQm9IK0lvMmllV2w5VXIzSG9udlBJcHpj?=
 =?utf-8?B?a05hRXJaWTdCZG4wUkxjdjBnUkh6eFhvbEU2MThBejdUUmZtWWVmdUsrVGda?=
 =?utf-8?B?NEorV3JYNGpBL2N6QnlDYUpXcnF2NUFFQjYvYkZkK3c4a1hxZ3dJaldIandP?=
 =?utf-8?B?NHFoV3dSV0R5aFVscHBpdUlhWkNOVVUyUXJzL2dHYk96RUZRMWxUUGtpL2Fx?=
 =?utf-8?B?bkNsTm0xUlVBdC9ISUlUZHNudjkzMHNSRXJibWUvNXdjQytCcUJHN1N5dkM3?=
 =?utf-8?B?V29ZckJ0blBvUXBzUG4xd0d2eXJkRVRIdXlHN0VvUlU4eU9jNWhaYll2blRG?=
 =?utf-8?B?dEhOMGY5WWhTbWl2ZC95dTBNdlpidFdSWmtLOTlsZ21vZER2ZnVLN2tNS2E4?=
 =?utf-8?B?Y29mOWM4WW1xWHZRanRiaUlRVnQwMmxCT3hKZkhSenFzZkRMU0tlbXVJOFJR?=
 =?utf-8?B?ei9GTDhmbEZUdUVSalhUcEpwdXF5NnRyMmF3WE1ld2hnOXQ4dElJY3AvWWMw?=
 =?utf-8?B?NUo3eHlUNVBHSVY3anB1dXowN0hLY1lJWFdvbWUwelU5bXdCSUxPdWs0QWU1?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 849f63a3-31f2-42c1-56ca-08dad8b94130
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 01:12:22.5927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pb+f+93IlCPg0YHhfh3pOBWIkIWFDKqoXfsY30ea5vcV/RviDnhExoCLOHx4eekEvZjb3KBtGILscnqK2kHIFf69/j7ufAMpdvjOFqN6A4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6105
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 3:56 PM, Saeed Mahameed wrote:
> On 07 Dec 13:09, Tony Nguyen wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> In the event of a PTP clock time change due to .adjtime or .settime, the
>> ice driver needs to update the cached copy of the PHC time and also 
>> discard
>> any outstanding Tx timestamps.
>>
> 
> [...]
> 
>> +static void
>> +ice_ptp_mark_tx_tracker_stale(struct ice_ptp_tx *tx)
>> +{
>> +    u8 idx;
>> +
>> +    spin_lock(&tx->lock);
>> +    for_each_set_bit(idx, tx->in_use, tx->len)
>> +        set_bit(idx, tx->stale);
> 
> nit: bitmap_or()?
> 

Ah good point, yea we could just use bitmap_or instead of 
for_each_set_bit here.
