Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9581B614FB5
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKAQul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAQuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:50:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859991A05F
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 09:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667321439; x=1698857439;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GZw/1v+H7w2z0ZtaBhGkavWeYqmRdWMIINeFp+b3MYU=;
  b=XX49lJ2GIY4f8Qnk+dAeOSauOqWpRoIRwmRkXvIKY5YK4RHjw54slWrZ
   V9v9mfgLdsd/PaEX4P25fYuEwUh+pIEN+W4V4stz5UBuxulkBwOQWiV+C
   hLOy1SL9Pg9AIBs5uRVxjPTCZqVY9he1Udgf2cgq76DSo3/b+MuQp06am
   gZcID5mtYin50GN8M34eTqMBra0okHA26bP1YvGJOm4dPr8dmxsmbE/15
   //aRSrxJCAXoIwFQyroifCnAhxccp941RSxDZ6rxjgWeN9fzK3/BCdpUn
   9DLA2krARCfVRwu321kJPP4Zg1fN55CJXnEgJY82pDdAg3GuI3Ty7Lq1f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="371266306"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="371266306"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 09:50:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="633935086"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="633935086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 01 Nov 2022 09:50:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 09:50:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 09:50:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 1 Nov 2022 09:50:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 1 Nov 2022 09:50:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWxcH9A7UwqV4d3zy6B7NUGYLnG3ZORaMnIJsJzgh9lPKKQsSg0YSZqI6bvZGV3K5NKa7RLTh9V4rx20124A4tTIvb0WH64cdXViF8pssmhWMWOWARvJ/rw3C9VE+S2O0zTYMj+w0I2Yhj9Tims3VWwXn7UdZSPoZfWjY5FsBJWZ66cnkkUBBBir6dX+DvY6LGqoRoOydDJoLPJxEyum25XbQvv2BZYyH7fKNJdWjBmhXrkrTXUKwxDAWYCTeaHjJUwdk8KDX3p1eyEwyNGLuUhsFUDFnHeC2huDu4UZJGn2j1ufQ4brQ+s887UwoFRJH9PaIODwSTy+5VKT2nvHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZncZhW7kILvOW4OQL4fLjTykSAR7SQYjcVQZAoCQpcA=;
 b=EwZKGR4GwjLHc1jlCk6Wqgf9Fxl3fQTw4yRN7VlFN63w66bFULXb07hX06x1SGNAGIPEuWkca0oS/IyVpsePe04+EWnqtrribzegyLPff5m+m2fCPpb9ZvrIFzlznfPqbQVQhxnQGi9TRavx/DB4f2BIk4yYsDRFtVPmrPAIP+YgA4eLqqbx7fwkgJ98znaDPeoWqpMT645DQ7gcDHLcV64xWyMEWpbAdj9OTH7BcF+TsGMhP2kXC0WmiSheKY+iZe+N28lLXlE2Vr2bIDst4SweAnnkldXoQD+7h3eChMgH7iOjkpdm2pz0cGaDed2eFGheAcusHxrYHrnRVdT6mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB4742.namprd11.prod.outlook.com (2603:10b6:208:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 16:50:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 16:50:33 +0000
Message-ID: <d6068a1d-bf73-950d-749e-70fbbbda489b@intel.com>
Date:   Tue, 1 Nov 2022 09:50:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next] ethtool: Fail number of channels change when it
 conflicts with rxnfc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>
References: <20221031100016.6028-1-gal@nvidia.com>
 <20221031182348.3e8ddb4e@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221031182348.3e8ddb4e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::42) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN2PR11MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: fda2a4cc-b0a5-45cd-ffad-08dabc293199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEkLmpaOraBEwaTG4+hylVR/BiU9gVVpAt1aSxPVwJr0fWkyidMMLhBvrSEfM6PA+ynTwKDU1i0aW+r7OZxh3GfPovBV3/Un1fZ4U+P4tbGflR66YSKy/JrKx/xlinXkieeQ3d+GGmX8MXFX9I4FWpw9008sTskCI5jlX2YKfGh+he5It112KaQQ+Mk5+lHiQqYdYGYQmSp+Th9NvODGFa3ww1AqNirqjZVTPvqvVSWhgU1OpTRv70HwBAm0wqwFXVb2TGWSlMpKDzLsRfYTI3ksRWcYlzKJeSdSzWF0rmzCrY61yq0zoERBL0zu68PYyXjPPlqcFcPM1xr/QfcBT8ilZLMZLucqkYuDJjEKCElhCHL3LgttaBFWrwDsQyTa9fpxW5wiKNjl8BHFkNEibxAwLqAmodXUplkCvlvDBW11c8bZgL33TPzo1JoasFv11yfO/+TbnoFP3YkUiY1mdlFG0VbG9ZusS/dcN2Lt6nNt6Im2oR5XjdbMNsV2XCWAxagMa5ZPOeRryjbKz/jOTT1CN1CatT23REK8Que0soVBm2nub/Vpg4aj0eB3yBZimTLVo5oMiSi5sRR/WojbTwu7gKjkiaiMe3OtZhXtdYc/PSHqaWmRhvqj5vnAkheG7+sBrgJlk+2GpNkFOBNtJKgBIYEFXj7zEbhz1b12qExxTQlVqrPuVA7SfBSiKUm5bSrZpgzbSYTkJXxssVbg/Gx2A4+2RMXND4WlJHhW3uDGRGWLPNYD9jQpKYNBXAB2DLRQdTZzGitly1M/LfF3lPZa+E2hYAj+8b2oxaejbmnJLhtgax0q3pNt+tNAkItEkFT5xrq0ppsNlyI3CYuvoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199015)(41300700001)(66476007)(36756003)(66946007)(4326008)(66556008)(8676002)(83380400001)(2906002)(86362001)(31696002)(8936002)(316002)(5660300002)(82960400001)(38100700002)(478600001)(6486002)(31686004)(26005)(6506007)(53546011)(186003)(2616005)(110136005)(54906003)(6512007)(17423001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWM5emVLdEZ2a0QwcVhLZUU4aEt2VDlOTjA3QnFHMVhWR05kaEM0VXlOWDdu?=
 =?utf-8?B?MmZzSlN3bkhNYmQzR1oxWG9SbytMcUMvbzl3elM5Nkl5UnQ3YTZjUk10WC9l?=
 =?utf-8?B?TytJZXR4bHJvQkxzZG1Vc2lyamRLU0ZtaUg3SXFOSlZ1VDVMS3ppVElzMWZw?=
 =?utf-8?B?YisxTDUrckszMkZ6djd5U3dXS1NoMy9CV0FmT3B5QmdRZFVRSEo5OHZhUkdl?=
 =?utf-8?B?VzgxeTY1NzlTZCt1K2tPNmxXREpNV0VVUnZDcTM4c2NFQmw2elBDeTlIU21L?=
 =?utf-8?B?UDJ5amNmVzVjcEpZNEpKY2xIVkFqOG9zT3BCUnVUT1gyZ2VEcFE1OEhMWnpz?=
 =?utf-8?B?V1c0N09Yak5rcjlDbVhpSlpIVlowOGo1MjRBQVFZdnVmbkZyRmNDZnJmM2xK?=
 =?utf-8?B?Y0RUUEZsMXdYbmhFOWxudWZDdFp3VWxReUpMRk9hTmJtN3lQa05mZUliQU4z?=
 =?utf-8?B?NG42SFhEa0ZacDlFUnIxVGN4Z1YrYU9PY2VSZ2d5UzVickJGd1h3VlNJQUdC?=
 =?utf-8?B?Umxka0NKMTZtNGJoVmV6QkNUT1VPOXdFT1JWYkJIdGR4QVM2WEJxTHZqUWNT?=
 =?utf-8?B?bjB4WjBBQVVIMC9Fc0FlNStoS2tXWmVzeUJGL0RIMVpIQklnZ1dCZ25KMHFL?=
 =?utf-8?B?VzNuOS9IV1BwM1haM1ZMeVRsUEtaUEliN1ZqS0FmTXl5MVhrajZaWHJ3NXFa?=
 =?utf-8?B?MUNrajhOR2pKKzhva3BxckxiODZlZ0NPTlMzOW02WDNLR3ZTRnhzclFLVTY3?=
 =?utf-8?B?ZjdHeHhsTVpjYmlzdHFZQ1NXQklvLzd0eFF6bzNSRlpSbWdzZVpZTDdWeVRn?=
 =?utf-8?B?VlUvZzlJbnV4eEVMcEhidWxJODhsSWluakk0aTRkekFGRXNJL3VPdWhaZ3U1?=
 =?utf-8?B?T2lmUFVxRTRKZmF6aGNzQm1HYzlDdHRyK04zTWVCYVhpMWVXQnNDMjJXaDVG?=
 =?utf-8?B?dVBqZXhZQ0lTOVRyRVFMUzByNlZDWU5KOXM5V1R6eUJnQS9oSjVnN1p3eWV3?=
 =?utf-8?B?c01YSHdaTTlmVmlqMWExMFBINjlpbVd1NWlUZHdGNGlSWG5TbW9iY28xRUpO?=
 =?utf-8?B?SXVVREN2bnpYNlk1SGF3ZHNNZVkvWGkyNnV2THJpaFl5empoTDZFOGVMVmFK?=
 =?utf-8?B?ajdWMHFYeVFUbnhyd21vN2h3N1VPK3NIaHh3aVp6VzJpUjJpQVowRGRBbWtN?=
 =?utf-8?B?Y3h5S2NpQ2dPbGY2QU5FZ0EzZW16dkNNYWtvRkZmaVZsaTFKRjlsR2gxbHlD?=
 =?utf-8?B?U01mb2lMaHU5S2dZRG5nYlJMWk9BV0JTSFYwdDJXK2xtOG9FQ25tVGVGWmU3?=
 =?utf-8?B?SlRrZkFHaFpPaXFzRnZXb0dpaEIxUDdGandSR0pxQllYWGI5dnRJV3NGajVq?=
 =?utf-8?B?ZXdDK2I3MWYrTlV1Yzd6VVU4eUZpNElpU09ORXVJTENZUElMZDBJSzNiU2xQ?=
 =?utf-8?B?NjFoZWFZMXYvdjBtbWdKQzMzdVdLNmZnQUVBdU11ZXJGYXZoMHNtKzNpQVJw?=
 =?utf-8?B?N21IZ2NrWXY4cFRlSVJKL1hWUFNzZWtVMXg1WGU2VDBuZitlQmdIT0dpTFN6?=
 =?utf-8?B?ZVhlUk05NWxrZ29kOUdha3pvMGJ4UlpVZFUvdE55UG1ZY2h5ejNVYjFZOTd5?=
 =?utf-8?B?dWp1clRYaVl0MnczTlBOK1hLMHd3WHlHbWI5dkhRRG9CbitHbVlyV1ptNnVo?=
 =?utf-8?B?MkV3MlQvSncwYXZvdTBMWUlYVWVLVjBZbURRQTJoV3VLUnAyU20yR0FtdWVz?=
 =?utf-8?B?REkzeW4xVnV0K20wTEE2WUsrNFNZMytzTGJhMDlzNmVvY05BQmhDTEZtNE1C?=
 =?utf-8?B?N0FGYkhyOWxtRzJvL0ZIU0M4OTJYdUF2UnIrR05XNzhQVGhSYzNBeGVybFMz?=
 =?utf-8?B?d1Zid2RjbVlzMzB0ejVLck4zZ2NDeU5iNGpxS1dic0xPWkUxQ2kzZmZOcTV4?=
 =?utf-8?B?b0k5VE1wcVk2N2NFTmNHVEpZa2c0QkhNV0FsbFZLcGY1YWl0anZ1QkdtcmJy?=
 =?utf-8?B?V1ZSNTZXMjJMS0txSWUweXZLWVM3bmdpTnYwY2lYWjFsdVBNTFUzWEJ0VUNS?=
 =?utf-8?B?aWhOVEJWdDBGU2tMNmNnYWJ2M2RDTnpQa0Q5ZkdxQytuRnhXeVYyWGFFREVo?=
 =?utf-8?B?NmU1TklpWjNJaGRFdGtWK1M5ak52YVg0UytFZ0VqK21IaHVYUWxMTVc5Rm51?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fda2a4cc-b0a5-45cd-ffad-08dabc293199
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 16:50:33.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qD7vyHtc16kewsLaHlUcKhMM2WIwEPN3YKtTReJ87d661nlH5sHIMxFLtsuJ2+keyGWKuiVWz1pxJ9gIjm2gK1VdKNVfBabVbs7uMsHwiGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4742
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/2022 6:23 PM, Jakub Kicinski wrote:
> On Mon, 31 Oct 2022 12:00:16 +0200 Gal Pressman wrote:
>> Similar to what we do with the hash indirection table [1], when network
>> flow classification rules are forwarding traffic to channels greater
>> than the requested number of channels, fail the operation.
>> Without this, traffic could be directed to channels which no longer
>> exist (dropped) after changing number of channels.
>>
>> [1] commit d4ab4286276f ("ethtool: correctly ensure {GS}CHANNELS doesn't conflict with GS{RXFH}")
> 
> Have you made sure there are no magic encodings of queue numbers this
> would break? I seem to recall some vendors used magic queue values to
> redirect to VFs before TC and switchdev. If that's the case we'd need
> to locate the drivers that do that and flag them so we can enforce this
> only going forward?

I believe these all use the same encoding defined by 
ethtool_get_flow_spec_ring and ethtool_get_flow_spec_vf, at least that's 
what ixgbe uses.

This sets the lower 32 bits as the queue index and the next 8 bits as 
the VF identifier as defined by ETHTOOL_RX_FLOW_SPEC_RING and 
ETHTOOL_RX_FLOW_SPEC_RING_VF.

It looks like this change should just exempt ring_cookie with 
ethtool_get_flow_spec_vf as non-zero?

We maybe ought to mark this whole thing as deprecated now given the 
advances in TC.

Thanks,
Jake
