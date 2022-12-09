Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A26C6487D8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLIRhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIRhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:37:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E7E233B5
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670607466; x=1702143466;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jj42xZNcd+hf0i2ygwWKf0TGSK71ncZ8FXeKK30jWBw=;
  b=NuE8+eiUSbdnmJdjblFyH2SCp4uchwhfRCLqoFMBDyDeL9+wp83ILN2r
   HbibUgWsKHU6eWNlgKV89iOu72uFlsI0mONbzT1ccTrnTFv31A1UySPJp
   W8DrVQ/eW5/wDFyjHL0jzsRzY2L/2TtbLm4xaBb+kXTx7i6fuQYGMdW8/
   yNGZ5np9NrwqxR8jt6xnmhB+2zYQ9b61tmwSkHVxDLgEFdlvCnodX8Y9P
   n8ChpxMYfxVRLVPQ0+BJIkPfD7ybYqFkBxsmDyGz7wHaYWzY4Egg37Gr4
   pOGJ4ShBcfiQI+n9v2B/tJJ5/kvumLSqFzUcib8tSDUqGe3d6lDrovqcl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="317536695"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="317536695"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:37:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="976349450"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="976349450"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 09 Dec 2022 09:37:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:37:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:37:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:37:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHzcKAcNYW7ECaQFsD/SDMj4q7vqLVgRIY2Iq+F1BNaDNiCJhbomJjIQ1n8oki5Kb6OR/sFzzimGYPjw3CkSxlh4p3QxuD6kci5Rw9xDH5HNeDwg4LmFkIrwcoIe0TeXlBqACw2Xw12hf3lZRUGmG57xVOPPuqbKBU+2fggH2LqWfIedLde1HhQ2y96aC/D5vJLriOH+piN/xChF2MGoLU/DAnOTgWjTs8eMdJ0i+lQ+YEq8e+661DUioIZeVaGblE+ifzgobvMjQBC5teIdGumoTcm7FX0XtHxRF+I+4ZcJmYzVD3qcfUrG9YTyFt4a3Gn77M/GmfvcIGKrq9Nz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGSxDGBzI53dbi6Aa9WbvDdzhH1WaGb7bFWmc6AMzRI=;
 b=cdkAyEoIfVviysXrTpoBWjsfkpJJ8fOSZr0+rq3J1G1IgKza0FcpaQUl9xj0Y3LZ8vtcKTmxCJLYdlS3GFzbGijK6AP4xuuaWS9AeDPerjJNClaneAzEW264eBiSEYCaoxg+4AlW7AFn+ODvU1H+AEsJ5iMNGT53UKTAiuiJrWX7Drp6LuBx/4IphKNbW3n/taEuIylXRnSfZ1pcV1bh/+XxbJmPb7ZfK52zW9l29i0f92V1h4vKibudzY7B5YBhQkV5R8hqASWtJM+C6NM4DbwumFNWGnQzSYoLTns3M9M/jAoiRrDoTC7tYzDGUKx5PsyYokrCI3GnqeXb0KEkHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY5PR11MB6389.namprd11.prod.outlook.com (2603:10b6:930:3a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 17:36:55 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 17:36:55 +0000
Message-ID: <c62825b9-e2b2-9293-e36e-c34d83c0d7e6@intel.com>
Date:   Fri, 9 Dec 2022 09:36:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH ethtool v2 07/13] ethtool: avoid null pointer dereference
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-8-jesse.brandeburg@intel.com>
 <20221208062312.2emtsvurflldumsr@lion.mk-sys.cz>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221208062312.2emtsvurflldumsr@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CY5PR11MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: fc71ad07-9ccf-403d-7902-08dada0bf76d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCHk493XblAvOJUyqHaglJLZXeEpkHyr1Y3dAThEaK/XbyrJ3Tz/3OdhAQ6b/BYxL//E3BmK3iAlvYxe9/6FjOurdadMnad0JqlF3UObQp/hBrYrSVYsdFmQUf6p9Zc34auVLgJ5JRrPbhRtvP6UxBXKdQEwVHXj3d2pOzxeR2iFEVMD4rj+PkluCTUwmpn/YYwXdUO8v7bmMV/s3fS0do5ReRo9nFsmyM+bM5O0gp+BDLq3LRID/iI3oBPcz/aEALG+YB81j+E8Ma+atBmkK0/YsBCY3ChbV26MpJB/o1b4qJWcZeUhrO6vo4X4N+vXR+Cs3h3qAYQBpp0XV5NmlcNeD3dKmNFUsSplowUvo+CsnWyy0n39M/ZOANhCwkAV3wScB+ZKX7aKasMKH25E35xaVDmtU6d+685rFyliTZbm9xKX6DcPOMSVdocTUQafnRrzIZAlQ9ug3gFmpUwG/LJ0K4xv/eRrCOTBFLJloTSRUxSIKLjrMZdPAV0c7bFAw8FY1ujBrALX4o0OXmm1PO2ZPYI8wyqYWgfod+F7yHGCHrlnpfd90whLKoK+5b+IOQFXnc69MeCPBrV0JtkIQj/f0OhUqgUFCeBzvcPlvVsqRasdY8I2XHnOOKi8xYh3OqmdBJM1QeMlJAHtpIU8SA8asL129dQYHpVDpokjrb/DdLJyTtmvI3QKtitbSse2TtPxaEZfpCfKh523a+dkZXq+UrwCIWTcEVtHvHdieHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(31686004)(2906002)(44832011)(38100700002)(82960400001)(26005)(53546011)(6506007)(86362001)(31696002)(6512007)(6916009)(8936002)(8676002)(5660300002)(316002)(83380400001)(36756003)(41300700001)(66556008)(66476007)(66946007)(4326008)(478600001)(6486002)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTRGdkE4Wkw4U0JuTWpkVXVkMEdrR3E1azZVSUNRTk10bzlmTDUzNWRLN0xT?=
 =?utf-8?B?Y2k1dGRQaGIxdjIyYjBOcmVUY1N0eXp6bTFOeEJENlFESllndFhselBQN2JH?=
 =?utf-8?B?ZGRXSldHcG51cVFXS0V3QldZcS8yOVdTcjVTeGlyYnJ3Q3U1ZEhSL2hNdmpK?=
 =?utf-8?B?cmt1dEVHTU9BQWFnc1prcWQwNFpQTE9aRTYxNksrNVppY1NIc1JnajFUcTNq?=
 =?utf-8?B?ZWsrbXZzeUxQMkhZUUFIYzBzUGNuYS9QZEg3ajFEaWI4MnlLY0ZLbWJTTk0x?=
 =?utf-8?B?ODI5SzZnNDd0RnNjRU1OVFEvYnhoMnVlRTJiWk1HbklZSlZIdUpueXRrbEY4?=
 =?utf-8?B?WDNwZStlOU1KbDY2c3dsaDdkSzFsdG51NUdwM1Nna3NTbkg4b0d3RFR3MDVY?=
 =?utf-8?B?dW1GRlNWZnlmMjU0Vi85YWJrdGE0allFK054V0JUeEM5ZGx4VmRTdmF2VjlW?=
 =?utf-8?B?MXNHMnk5ejNlZDNrMjRjallvMnVMa3pqeUhSR3BHSVk4WktsZlZ2NmVneXJw?=
 =?utf-8?B?U0RiYWNnWUtwcXpGNDBqV09Mb3VqTlU4Y0tBY081NWJ1UDV3b1FpamdhcFNm?=
 =?utf-8?B?LzB4SklMSVhKWmZER2oybnBsYTBqZm1zRkMwM0NpNDU0WEZ1Nm9Td0pJRmJs?=
 =?utf-8?B?L1VzLytnTnB4MFZTMGk5ODkzWG5WdDN4VTJydDlUY1p1K0lUMVVFUTZLa01U?=
 =?utf-8?B?QmFPVzVSWEtBY3ZhbTRPQ0doYTRTYi9rdDRYa08zVlJkRENPY0libHdaZGFq?=
 =?utf-8?B?M01DNExkL09xdEZIZzZ3WHljUTYyK1o2UkViT3ozMDVZUktZUDF6R2VkY3F6?=
 =?utf-8?B?UFFCa3NKRG51cHQ0cFFaWndHMTJCOU5QR0FDR2tHME9zV2RjdFhReENaQmtl?=
 =?utf-8?B?WW1nNHQrR1l1VGI1Y0xuSE5IYnVRc21ZbHVHamlCTnJudFlNdEY4YlNvMG9M?=
 =?utf-8?B?L0hkRDIvVmtRY1Frd0RhQmFSZVVGK3lzWkpHMUJtVmw4VVpBa1NOY0FKUVpm?=
 =?utf-8?B?N25BLzExNG8xNUZmYWtmWWx5REExWktDczlFVjc4MnpvTzRHUFlEUFBub0JD?=
 =?utf-8?B?SjhsM0Z0RXpLT3UzcjBRbDJBZXc1dWhxK3JMVzhyRXJON2Uwc0pUeWVmdEZ0?=
 =?utf-8?B?RkNyc2xxU3dRODFmdW4ySzVaUXlublpuUHRUcS91OGVPLzhqQ0pDL1c5L2FB?=
 =?utf-8?B?UmFsKzJtUG1hbXpTOUc0dHJMVXZFdWZIREpaSW5iTlZuZ3NCbTg3Q0Rwd1Rj?=
 =?utf-8?B?Skw2eTZTSEl4YVBQYWh5NjBPZ3dDRVBvUTI3Vm9tUVM0Ly9ScC8wdDgvUUND?=
 =?utf-8?B?S2ZIUHVwTjlQZEVIRFovYzJOTkthclowMGl0by92Q3l2WWR4RFlncnZJdzli?=
 =?utf-8?B?c3FVZjJXWVBiemsxNjdNVUpTY0djbGZSRURCcmFmZFVqTWNHUjZYZ1c1dnhv?=
 =?utf-8?B?TjVhUnpTWjlEajJ3UzEzVUdUUldGUnM3ck0xeU1JUThuY2hjZ1I2L1NDZS9w?=
 =?utf-8?B?YVVuaTEwTVVxVlJ6dld5UzRzdVRxQTNTOEV3VUxVdG0rajRDR2xmTEFDYkVq?=
 =?utf-8?B?ZzVrekhXeUlZcklwM2tOVEpka0ZtWmROR29jNW1KajBmQ0tJZy9mcnhPYWMw?=
 =?utf-8?B?SFV6dnhoTG5pYUJzSHc3YUJ6SFZ1RTd5aGExOEFMMm5ORlBsVmtuRXFEeWU3?=
 =?utf-8?B?SGMrWmYyR2V5T3NFR2Y0RVBEeTkramE1dHNlRDhzMUJRaTh2THJYRkFrUzAx?=
 =?utf-8?B?dU5EcU5JNk1TbEpoVFhONS84ZHpLZzA3RURCbzZFb09qYVIzZUNFY1kwRlZM?=
 =?utf-8?B?QmlVb3NqR0NXTmU5U095QXRORXpObDluKzRIUFlsM01GN1A0cEM3TVhBdE9N?=
 =?utf-8?B?aVpZZllDV2xhZXpybFlQT1VwVGd1dnBPOGhJNU1nTGlxZTNLbFVWV1ROcUhD?=
 =?utf-8?B?UlhtRm5qOVYyVFNnMlkzUW5HK1ZFY0ZoQUc2Uk9UbnpqVHF1cHNuOGoyb2Fz?=
 =?utf-8?B?TkVOV2ZiQmMxdHRPMHJNOVRacEU2Z0RnQ01mNndpbEowY25qTityQmRFVXRK?=
 =?utf-8?B?QmNGbHhxYWdKSHV5My9BZXR2aGNLSWJVL0YwTGk2dXJRMzFrWVlLM2VRRWtP?=
 =?utf-8?B?cEZDZFc3M2Y3L1RXcDg4SHZkQ0ErOXZwQWRuZyt0eUJ1WXJqNnJyL2F6TERm?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc71ad07-9ccf-403d-7902-08dada0bf76d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:36:55.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kODc+DbQ8NWysfaYTqAFUm6QzS8msft9cQcz8i0/5OZAbZqz9EaYfVjwTerqVfLDYiPi09mVcgNG+T4iGTm+Lpu9v5A1ZZ01tscDZcZmozI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6389
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

On 12/7/2022 10:23 PM, Michal Kubecek wrote:
> On Wed, Dec 07, 2022 at 05:11:16PM -0800, Jesse Brandeburg wrote:
>> '$ scan-build make' reports:
>>
>> Description: Array access (from variable 'arg') results in a null
>> pointer dereference
>> File: /git/ethtool/netlink/parser.c
>> Line: 782
>>
>> Description: Dereference of null pointer (loaded from variable 'p')
>> File: /git/ethtool/netlink/parser.c
>> Line: 794
>>
>> Both of these bugs are prevented by checking the input in
>> nl_parse_char_bitset(), which is called from nl_sset() via the kernel
>> callback, specifically for the parsing of the wake-on-lan options (-s
>> wol). None of the other functions in this file seem to have the issue of
>> deferencing data without checking for validity first. This could
>> "technically" allow nlctxt->argp to be NULL, and scan-build is limited
>> in it's ability to parse for bugs only at file scope in this case.
>> This particular bug should be unlikely to happen because the kernel
>> builds/parses the netlink structure before handing it to the
> 
> Again: this has nothing to do with netlink, this is command line parser,
> nlctx->argp is a member of argv[] array. And as execve() (which is the
> only syscall in the exec* family, the rest are wrappers) does not pass
> argc, only argv[], argc is actually determined by kernel so for it to be
> actually null, you would need a serious bug in kernel first.

Thank you for explaining! I can drop this patch, but it's disappointing 
that one fairly cheap conditional will prevent us from being able to 
cleanly run scan-build. If you have any other suggestions please let me 
know (and see below)

I spent some time today trying to get the command line to pass a NULL 
value but I couldn't do it, and elsewhere in the code the checks for 
argc prevent the NULL value or no value from getting into the ethtool 
code parsing the commands, so in this case it's not really a false 
positive, but taken care of by other code that isn't observable to the 
scan-build virtual machine. The good news is I don't see a real issue here.

> Even if we want to be safe against buggy kernel passing garbage as
> command line arguments, I still believe we should do that earlier, in
> the general code, not deep in a specific helper function. Also, you only
> check for null but that does not catch an invalid pointer in argv[]
> which, unlike a null pointer, could do an actual harm. And I don't see
> how that could be checked, I'm afraid we have to trust kernel.

OK, let's trust the kernel, but can we still fix this issue in order to 
be able to add scan-build to a list of tools to run cleanly in automation?

some TL;DR details in case there is someone else that has a suggestion!

Here is the callchain, for reference:
This is from the command
# ethtool -s eth0 wol pumbag

#0  nl_parse_char_bitset
#1  in nl_parser at netlink/parser.c:1099
#2  in nl_sset at netlink/settings.c:1247
#3  in netlink_run_handler at netlink/netlink.c:493
#4  in main at ethtool.c:6425

and in the #0 frame above, *nlctx->argp = "pumbag"
in the callchain above, scan-build doesn't like us de-referencing argp 
because it doesn't have proof it's not null.

Further I tried putting the check in every element of the stack frame 
above and they all fail the scan-build check still, probably because the 
pointer is advanced to the "pumbag" argument later in the code.

Anyway, I'm still working on the v3 of the series.

