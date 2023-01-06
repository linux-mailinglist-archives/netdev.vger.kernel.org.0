Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE31C660552
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjAFRIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjAFRIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:08:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE534D6D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673024888; x=1704560888;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GYTZ8zC9dpm7USeBx3ufugA+rmqyeLvOKtkfg0mU878=;
  b=MQlDxaW/D5hLtfJPqvFRfn98nAVDt88AlYeni4FI1gtot1iR+VeEpxDj
   cA6GrLhMIkGyEzcgfajnaVezCO/MWIeC8pfCbDVY/z+DAiyfBIUa/PnpA
   XAhHyiL/xSphg1VD3eBYd+mge3FmdxktsWiseKVx8RPNSyaASxFqLjEY2
   SfZq+PlH6AheV83AdeiI0a2blFYLiewtDYtPPL/RCjk/HrpCPLXCc+jO8
   Gyp9HDv7Zzn51+fygD9yLJASjKoOWNw7ecJ7IEdFEuZZoUh7ZsRIDGIiD
   TCqxZtqUISdw6UXYHDRzViRdY24UM5c+i/+L5EA5vP0ozX2IihwDP8kec
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322588291"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="322588291"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:06:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763575512"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="763575512"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 09:06:06 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 09:06:05 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 09:06:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 09:06:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 09:06:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0IJSbb4KNS39PtellSd3tYMbhOhSoGrkW5yFtTN6kqb4UxiG1eRHThSTu+orYsomkVHD6TRa97+3Rw9KGiUHULmfDIrH5skwFS9dU9pfZUEl22oeTdxjYsi7Ye/0/YY8OOtI0spl5SG0crYj6pt9NKwFlereyC7QvOP94KT7ADSXNSup59XBlP5eoZigVy6q+stxfnG8tfxsn29XFfB4/LPD5kq0DWy7IyuMsg6/+K+4lawAT1PbfCmDp0LfAaXHG5Dd2r97KtxgIhGRQ4uNUjhHFn97AQHD/5e9gmO2gGd4TDXhwA6DfgfbWiAJoKSv7v/mwn/1cnm6B9jGkIwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mb24h2oF0tNpVfikP3y7Qmh+vZQwlJkGMnn3nWQpiLE=;
 b=HjnjdgUSSaQx2/6NOp8nZukUo9vyWu4JKNipu/NgRTzymn0CPW1hzT8PeLQZRjiTd3XCPGK+VQaWfanjDR7NqDCOI0Q1TmrtaekF+jCxesYnvoQ3WDv2JCYJSNsQx8objrUtLlrjrzZ+Gv98Oc3UBhxyNSYVuAkWe7mBeq47L1TMrSbmqYv+pZwVLOlBIE7rECg7IZznDb01gkpIIZ/mHg8JbLPccd5kMxT7RxlJ3p/7rL41BKZkOoZ3a1nnbOR2CFxJLSAkfi+0O8TB+fnqZAN7HjtVDYZnq0grTJAk6QXUWf5vWBQa8fLNpIVBZMjLbZ0QMFPCYp2EprCAiiU1hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4593.namprd11.prod.outlook.com (2603:10b6:5:2a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 17:06:03 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 17:06:03 +0000
Message-ID: <26b7bfd9-c438-2170-5300-7eb8dacd749e@intel.com>
Date:   Fri, 6 Jan 2023 09:06:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/9] devlink: remove the wait-for-references on
 unregister
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>
References: <20230106063402.485336-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM6PR11MB4593:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5d86de-3464-4475-f210-08daf0084aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4i0/eZHJL6V/+PLL58mQxlkYNUFcFqnXjHZ1IhXDwNawHmCPTNSEn8dbsfjkvLnLpp7im7Birvu9BmC8qRYpbswNyQ48vqWPkcqX1MY0y9AkFsFpFgi49humg7spBfRQXCY1CE4XcdwSwBoy29ejOGRSFPK7UJml7+fRraEiPg0fqpmwB9C6y1hwHeVUwY65mXfhu//jy6HgienDpkwc8IaEz+bv1fH9q1c7852iiG+nuNwF8l9ZnCyT+WUbVCQCaWOXHN/IGdlkcHsXET+8oWup/4jpEctS2vax6jpx7SwSISteFDYDzUDIWPGFNnAf7S7sm78DAXEpZ4q8jUtwLeIRtC4cfTKB5YY+zpnBuPmKrUurDkjFMACPigeBNMrJlW8eAlzJvd64t+d+yikmsl6TVVGJkXMSet9JAn2w10z7RhisSPVda1JB8Lo2T+G+kqbCFpt5xkhbdGlU5dvqt1D6Wux6h56JN23d1x8WEaYZ4MUGpkBWidB0S/6SCthf9gKBLlke411Pm1/5ETHiF/GKAeBEspTPWKa3g4i/UbgsSGHn+njOYrdTbROyj6Yx4HDLiCcW0DvcxPVZ7qudkmM+sRhcc3BrS6B77mKT1n+caGWyEz7C23I3qyUm3Xvt0sIxaQUjvzdGMYTAIXnhT2YocLPYGe4UujWvBkdsSWtcCKAsh65toVmES6TdJ3qJF67xoG2cSk36hBuKMgelFyeUUCWPdqgDP45n09BVmk0dEC74DokNXFb3cVy5qqKg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199015)(53546011)(6512007)(186003)(38100700002)(82960400001)(26005)(2616005)(83380400001)(86362001)(31686004)(36756003)(31696002)(8936002)(4326008)(316002)(41300700001)(66946007)(5660300002)(8676002)(6506007)(66476007)(66556008)(966005)(6486002)(478600001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0FjZ2QwZVpZOVJjNk5LUEt3V0xQVHYvemROUVRkSHdubE95MlFmOHBKOFAv?=
 =?utf-8?B?WkNuVG11T2NwTzJiMC9RWjFLU0JvdjkyRmwrRXBJYnRPRnhKVXBWVzFKU3g1?=
 =?utf-8?B?bzNXWU5rclNKYnNFSTJybW9LYnY0OHFrdTBXU050Tk8rWEsvOG5KVGVjNkcr?=
 =?utf-8?B?ZXFXaWQ2eGpLTnlNOUhkOUdGaGhTQnVBdzZzelF5OFdLYmdOS0NDK1VLamFP?=
 =?utf-8?B?N1RnajBtbDQ5eWRVRkM3SjFFZDdJTlVMcXJrM002YlR3dk1JdVBLQ2ZMMlB4?=
 =?utf-8?B?OTV1cDlPSkZmMjg1eTQ2Y0RHcE1qKzM4WTVLcVVJNUZWdUNITnpzRkRpNnlu?=
 =?utf-8?B?NWViUnNQNExUOFpkYW5pMWR3dmZqUkdHSXBoUEkxQm1MRjdnUUVQWGw5UWRJ?=
 =?utf-8?B?WlZNZjJKR0NLaHh2eHZPMytwNktTQW1wNkI0NUIvVElDZjhvbENkWjI2NjNi?=
 =?utf-8?B?UUU0bGUrVGUwbnNNMGRXZXFrVVdvdEpseElDcFRHdlNZZkJtbkRydmJ2bUlj?=
 =?utf-8?B?MDdSZmFZcS90dVB5akV2b0tFUHloVjlONGoxbTFWQ3VLL1luOWlxV1VOZUNE?=
 =?utf-8?B?MXdNNXgwR3FEa0I3b1NBTmZza0VSa09Ja2NoT3RtUGJORTBBZWtkdU1zRG1R?=
 =?utf-8?B?by91a0tZb2VXcXFZMnVYVCtIV3RrSkJaOW9SUnJsZVdSODhQZ3NWQXdpMjF4?=
 =?utf-8?B?V0NhTFlKUFZLK0Q1QWtLQzE2V0g1aW5SZUJYSFdrdHd2ZTNIZHFmemFZbHQr?=
 =?utf-8?B?VDNYU21tSW84Wjk1b3BnaVN3R3lQZk84VzhRUlUzcXdnazJ2d3hveWxyUzAv?=
 =?utf-8?B?bzllenZwZklWemxUNXVHVS9ZdTlmR1NCSnEyZUtRZW44cWU3MHpWczdpRm1J?=
 =?utf-8?B?c1ZIdEU4bGtLczJUclpOeWVjMDZidmJ3Y0laK2ZSWWUvRWFWR0U4NWRzZGx5?=
 =?utf-8?B?M1crWW40eWNwaUJEN3pOS0I2cklzQnMvVVc2RGtoZEtwQTl3VU00dDNNNGtV?=
 =?utf-8?B?b3E3RG1LTXZvNmlhdEFxdFM0QWFHdm5UOGNIL3JqTmdOb00yWHdEUlE5S2Rq?=
 =?utf-8?B?RDgvbURtSE94akcrcUxpQm53YWpuUlNjeGdxK2g3THpONW1naVZnM0VHa2NH?=
 =?utf-8?B?dEFUOThua1BGTldHMkRGdXMzSnlRUHRsUUt1WCs4ODVIYVRsWGxqKzYxWXcr?=
 =?utf-8?B?Slh3M3JzMWRwS1NrbkRUM2ZtUXFjN09VOHFSS0R5RDFwVmhiK0ZVVEF3UTB2?=
 =?utf-8?B?Mmw4a09idGVuNDV4WjAwU1lLS2VPNUowNFBNVFhJRWdOelFWR280NEt2eXV5?=
 =?utf-8?B?L3ZBbWREK0w2YnIvZHNZYXV4ck9qOEpUdHdYcDBxazJqWTBOT2hvT1JiQ3R3?=
 =?utf-8?B?cUhld0Q2NUFHRUl5d1pjZ3ZIbjZNMHM0c25XRGc3cUdIUElHVHVjRXRLbGlJ?=
 =?utf-8?B?YXNraEdFNHNzc0VEZG9Ma3dtOTNmMEtocVRqT01yZzNuRWJtNlZhcmhMS0RI?=
 =?utf-8?B?T1hqeXU1WVBINk93TXkzeFZNcStWT3hSWEwwTVljbjFzUVFMcEZEalo2TDQy?=
 =?utf-8?B?MmVoSFN5UVQxdzAybzZxbEpIcHFXTGU1YzlvdVB2N0s1anJtWDV6SU8yK0F0?=
 =?utf-8?B?S2JLNG90TnhwMFVYQWtodk9NMWtPSkxlRnJmTkd5SkJDam8xYktzZnhCNGZ6?=
 =?utf-8?B?UTlGY3p2NkRoaFpTYTl3dHZlRGN4d0t5MUJFUFQwbHU2SmtLcDVkUUJKWXdj?=
 =?utf-8?B?NFhoV1ZlNmNpeU1ZRzVzaGlaWU56aDlteW4ySTZiTVVqa3ZGT3owZ0FTRTdD?=
 =?utf-8?B?Uzk3YmJra3FKUGRZYlRVTC9WejVQVkZhcnJGdStBelYrL0JzNnhkV3BYQkxk?=
 =?utf-8?B?UklpTzBGY0xJbmFrQjh0ZmN0UXlWTmtLb0ZndHRZM200NmxRbjhTT1FPWFFO?=
 =?utf-8?B?MUE2Zlp4N3FTK2FqRWYvZEorR0xuVnBZcWtRMVExY2FmSDJnRjNFaEwrYUE2?=
 =?utf-8?B?ZWcremVVaC8rbGpGdE4rODFYQ2xrZWVaMEdXZnVQa3A1QjRrRndNQTlHaWh6?=
 =?utf-8?B?ZnoweGFsdFBQUnVLaDUxSjQvdkd3dElTRVpLNGxPZ1Y3ZjZ3T3F0bHhPUStD?=
 =?utf-8?B?MkdJaE9SR1kxa0Q5QTh5eTRYQitiUUppR2VoeGZYZTh2R0NJRURabmNkc3lG?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5d86de-3464-4475-f210-08daf0084aea
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 17:06:03.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lHUwHkAmE4Vxh9PUMi1cpff5FPftygj94+Rqg8qWLo3ajVGQ86m3Emo9PDtt7CPxVJytwBuFH8z+b+ZgJzoshvU2ojz8KaZnTtyXuLRhus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2023 10:33 PM, Jakub Kicinski wrote:
> Move the registration and unregistration of the devlink instances
> under their instance locks. Don't perform the netdev-style wait
> for all references when unregistering the instance.
> 
> Instead the devlink instance refcount will only ensure that
> the memory of the instance is not freed. All places which acquire
> access to devlink instances via a reference must check that the
> instance is still registered under the instance lock.
> 
> This fixes the problem of the netdev code accessing devlink
> instances before they are registered.
> 
> RFC: https://lore.kernel.org/all/20221217011953.152487-1-kuba@kernel.org/
>  - rewrite the cover letter
>  - rewrite the commit message for patch 1
>  - un-export and rename devl_is_alive
>  - squash the netdevsim patches
> 
> Jakub Kicinski (9):
>   devlink: bump the instance index directly when iterating
>   devlink: update the code in netns move to latest helpers
>   devlink: protect devlink->dev by the instance lock
>   devlink: always check if the devlink instance is registered
>   devlink: remove the registration guarantee of references
>   devlink: don't require setting features before registration
>   devlink: allow registering parameters after the instance
>   netdevsim: rename a label
>   netdevsim: move devlink registration under the instance lock
> 
>  drivers/net/netdevsim/dev.c |  15 +++--
>  include/net/devlink.h       |   2 +
>  net/devlink/core.c          | 121 ++++++++++++++++--------------------
>  net/devlink/devl_internal.h |  28 ++++-----
>  net/devlink/leftover.c      |  64 ++++++++++++-------
>  net/devlink/netlink.c       |  19 ++++--
>  6 files changed, 137 insertions(+), 112 deletions(-)
> 

The whole series looks good to me. It looks like Jiri also has some
planned followups that will clean some of this up even more, which is great.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
