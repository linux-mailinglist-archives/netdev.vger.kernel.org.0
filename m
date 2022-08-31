Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44E05A8751
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiHaULn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiHaULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:11:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7FAEEF21;
        Wed, 31 Aug 2022 13:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661976696; x=1693512696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bg/AKLm28HPZmTkIYbsertLl11MXP2S4J/1mblZgzIU=;
  b=H5niFbHXHBWFWgvglBWk1ceJivNcLf/SUrpMNFbBevTbEdfrGzZIKlk3
   LPWUsuy4kKjTkV8pjvnplNqiVkDxhwTcupATxcdV7smqc16v0Fqu1NOFP
   xGaqpIXrmm0890Pi20ybEIMzFWaHN0BTgaKDW7QQOhUm4IKr4HhvB1mLw
   uMQgLRlaes8Tu8vVFzAj1VesdN6VT/2YnhMNtHAVM/Qm+MATSLdRmL5sz
   yuzw3JcGeVeGMuDsKWHkdWwoD9rEf67gJPFTldxoqDZwiSH44T06FTTHP
   scaCGcrkzI7Y6XelIudUwlxO2KCJNGSqQDJsbZSCvOblR9WjXRpj8O5g6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296815918"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="296815918"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 13:11:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="857577073"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2022 13:11:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:11:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 13:11:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 13:11:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzI8k/1unVRFVK6XLtm9E9tNHir4YzQstvkAeZBNT8u1yRDRP0gP019H5cFiqDKbExSGvJoU7JNqUal9E85sOChm9upQZK9e++nkDa1QrT7Rr262bF09GiyMvXiNbJ/yekO1fzpAZCFdLUHSjhToWBcK3sTg5vN7XDiBFEul1I/fKzV0ytQfTRX5rfr/CDIj5btbzuc/uk1qL6CPm9BNakZUtqWNuNKF2RL6TpRuJt24w+AEk8EmceyWI01wNpNXDvleZa4Hs83SpsgPxfiZBtsD9r7tSmHfzk4JIE8GjjLanrrcOAyiXot+WSffOZgIxoIFhamW72FvILzt9WZSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPOPJp++ENYCuVppw3b+Ck3TK4CZkVWtZp362DjXz5I=;
 b=imLDbUQZ1j/hkuPVu7zvytgGuuYrDLvu5dOonVV5LYXTsMEwXityQ7X5hLmJIEtYFpu6KCYE4kGq8hOxIzt9K56OeXbuSTOHJ+ZSWRaLfwE+t0P2zWaaoWAX8ppEMDTxx+jBPSfXJxEs87IW0gPFvTohxfTdJhqV6AytBP2JlIac7poVSFW9ScWJ3T9SQCNmIPmGxBpILvgriNKES9ygoKNvRuXzHWl904i+QGgIQVDcXy8y9mP0We4o6LTyHeDuSFV1Nz0V0B9foBSMAobUbiOH4v2cwh4LURYg9+pZ2i1PlNJDChfM0iA9cuFN0EZKAPZw/pFwVOWBKPzU2ugNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Wed, 31 Aug
 2022 20:11:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:11:32 +0000
Message-ID: <148662c5-9be0-3872-fc66-e600163ca49f@intel.com>
Date:   Wed, 31 Aug 2022 13:11:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 intel-net 0/2] ice: xsk: ZC changes
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <magnus.karlsson@intel.com>, <alasdair.mcwilliam@outlook.com>
References: <20220830125122.9665-1-maciej.fijalkowski@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220830125122.9665-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaaee0ee-0b97-464b-f6c5-08da8b8cff4a
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iW82RKH9cCjS7Z4YxGkGN3Z20e9TW2jI7K395B0HU1UCwbvrCw1X3SRGyQQTK1ybGwUHQy5XEIk7/vm+NkrYcSw7PCl+02bS6LtoRW43+LExT5H4zplPWZ3htYkgU+bBFrGUgWEw9JfVsFVCEDoEfQYMwL2SMIdI2HSseBFvnlVJfybPgFOlSQi1gB3XiSXDpsa1BRyywFIhTbVhMHhrD5JLJUBfbed2w8qndSseUnXEMif3smzY0i2+jfiLe4vLtPgHouRA5Qy7PM68sj0nOHOWg2CWomCZFgB12a5bGPM65mSJWQQwPsnJ8AIK9fU6CvYAbWFpxk76jkwyeXu0NSama6UlfgGcSRCcvbf5JGAnJU3C2vCj9jMvUClrQWN8MCo5aBL1RM15hk4nYm9Git5bAImWIaVQNuwdI3edR5zDZ6yAZclIgj/PPscve1Sl6CuaOVGHGXIMRgMERf+3oDsnOg0tziet0XrINh/ISGEJm6M9BvGugXHzgv8k95I6G151lL1ES/6KSacTh0m2bGyxPpw4X2zyl3nGe0yqTL3Hbx3l2tqIxkZH+zfzBr1+BwMNkN6B5+Zk96SpsVnuTT3KH+nsDtY6wVOPYfw3IvnZX8LUr75vSqhlU+zfxl9rRZ7GIX7b4vMC83gcC4QdI6KNcywlMqyif9/O6+qsnR62fDdkpiEqR3Dr7pAYyHTSi0aNz+oE3c1FRiHVGTrZttqdVzIhs3IWI5wM3B03up+TA4xNnZ0wsFo98HmF27/NuwEtRMxW18VJ3hMB0VSGo1qFNDH8ofG8vx9V94sH2UQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(136003)(376002)(36756003)(2616005)(31696002)(86362001)(186003)(82960400001)(38100700002)(5660300002)(4744005)(4326008)(66556008)(66946007)(66476007)(8676002)(31686004)(2906002)(41300700001)(6506007)(478600001)(6486002)(53546011)(26005)(8936002)(6512007)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGxGUTB6OFBybVBBaHZaQXZZREdWT2VBVnFMWk02VEtnOGFDYk5seS9SSk16?=
 =?utf-8?B?ZWtRZGxJa1Z3akR1THRtV2c2NFQrVTF3b1dPcU5aYVNsSUJ6USthSjJCWDRu?=
 =?utf-8?B?elVjQi84QnFRUG1qS0pWNktlWlQ2MTU0ZFRFb3g3R0hDc1dPaXE0NitjeEdH?=
 =?utf-8?B?bUhXRnNSVkdqc0QwMmgvUUtNbk95ZWt1c3hzMjV6ZFY2SE05c0wyRjNQWVRr?=
 =?utf-8?B?cU96bnVFL1FIZTNYSm5ZNDlWOFU4Rm5vOVU2Q3pYOTdHZHBYRGI4M3ZicDFI?=
 =?utf-8?B?L2RLWVRmRng4R2I1dk50NVArS3VQZ0ZKaERuNTIvUjNJaUppMFAxNjEwMWZP?=
 =?utf-8?B?NitHcklvYjhSbU5EQmxMODhaY0NqVXQwdExNd3B5SUFuZzBZaEd2SU1BM2o0?=
 =?utf-8?B?cTZrckl5S0lLM2VWUXZORGJUeVhPWEZjRStoSXkvYVpUT0lFcitzL1N4d0hr?=
 =?utf-8?B?aFA5ZjRWSmhkdWVENHFTbFpCSS9oeVkyNXUxTk1PcHM5S3dQZGxyNWxIc3lV?=
 =?utf-8?B?L1lmS3BrTmlMMUJUK0t3U3hLbXBZemNOcjVFV3ByaU9XUTNKRTJkdTBLSFh4?=
 =?utf-8?B?ZlNUZXlqMU1qcWo0NzQ2VUlKcWc4cWJpNTA1R05aaUl5VjFXekkrYmowU1Vl?=
 =?utf-8?B?eDUzNkJRR3JtOFAvdHRuczQ4L1FFOUprYXBDc2xsZFRtUVlKcm9EWHlUZWFk?=
 =?utf-8?B?WG02WXhXa01GcXRWaUcxUlBnUCtUUVhCcGw0NjR2bkVtZWtDYVVmOThSb1Jv?=
 =?utf-8?B?bDQxQUlLdDR1aUNrQmVWSDdVSERiQlNWTXBrb1djMnJUUitaTmVQemxqbjJl?=
 =?utf-8?B?SXNESTFrQzlha3prbFdDYXZpNEZzSHlybnUyakVjUWRneGhUTGp5MDNkaUEx?=
 =?utf-8?B?Sm9VYzJIRVpyU2pBYXFpVXh2YW85Tk5PNm1YR0YyM21UdlZWOTNNT1lqZUNu?=
 =?utf-8?B?QWR1NE9jK0Y1V3lzdXJsdTJwRi90c0d4MUhZQWhKTjJLTStmaHJoZDF4K0hH?=
 =?utf-8?B?Mml4ODBhSGE5cDY4V3kyTnVTZ0pDYlpqellXRWMxMXhPSTJpeUZxcGUyaWw2?=
 =?utf-8?B?dk4rTGJaMFpPNXpIZTlENHR1THk2Q1NCczZhNy8zTktZWUIzcWgwbko5WmYv?=
 =?utf-8?B?amQ1cUEyL2paRXZNNm9DZ3dXVXJ6cjBXM0JhaFZ4dURxc2FCQ3FGdEVjTi8z?=
 =?utf-8?B?aUg0NmQyK3l1SXZYNzNtRWFYRll4QkFpd2NBYXE2WlpUVmdlSUphdEJkc2pI?=
 =?utf-8?B?ZklNTlFLZ2ZvMmNJN1dVaDlPczdzMGIvVFVIVG9ldlpaQ3NtYTVVQ2EzMzh3?=
 =?utf-8?B?TXlmb2FJenZjWGIrS0hNbFJxdlBxbGpkcEJXZ2phS2JhZGF6SHJackFocnd6?=
 =?utf-8?B?Rlc3cTVmSytvU3QxYUNJYjZTYS92VENFQlg3S2o1UUc1Nm9scDlRVU9WTS82?=
 =?utf-8?B?aWYzMC8xaVV1RHlhSHVWOFJlVVlBZWtxeUtHUFl4TE9DMk0wQ3EwUE9ENXVr?=
 =?utf-8?B?ZlJ1MWxJc1dWc29vOWp4WGlianJ3b3RoZnVBSjU5TzRLMXEwblliYmFHWTZS?=
 =?utf-8?B?ODBNUWNlbVgrejZUWnJEWVVMY0xwUER1eklWZm03ZUI0NUh2cXR4bGpxUnQ0?=
 =?utf-8?B?WVFQbVVsUTJyUnNDQ24vZzdiTVBDQ0FTaEI1dWkwSyt4bFlESzBrNjRkdFB5?=
 =?utf-8?B?L2d1ZWJNNk1ibXJIK3ZROEZaazZIMzhCc0dQSWJlUTI4YWRSN2JHRjF1Vit1?=
 =?utf-8?B?T25EcTY2bVRZVitscm9CL2ZpQjJMSGlsdEI1WTBJOHBUVmN1d2RBcHdCc1J4?=
 =?utf-8?B?RW9hRlhoUVdHd1JzWWgrUGlxUE1pS0ZzSVdHV0lLMWdkOXVJcUREV0g1VkI1?=
 =?utf-8?B?U090WFNnMEVVK1pPOWhBOTRROWZHYno2RDdBdjdOaVRDM09ZNkQ5YnFrUEd6?=
 =?utf-8?B?S1RrNW9lQUNjNHFOSytlNjQwWHNFMnFrcDRnN0dGd2pGSUYzYUNxMVg5djh3?=
 =?utf-8?B?bXNTR055Y2N5MkZIM1hkZm1nZzRuTWdPcDNyRElFR09pS1lFeHVDVkF5U1NP?=
 =?utf-8?B?bWh1MHJ2b1A1dzVSZ0xSQVdWa0lRL0J0SFF0RE4xZ2dtRndFczY2dG9ZSDdx?=
 =?utf-8?B?ZWI3Mm5MWm92VEIzcGE1MmVuTERFL0czOVNORmxNUWZjZFdUN1JhTmtPN2ds?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aaaee0ee-0b97-464b-f6c5-08da8b8cff4a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:11:32.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tyuWshipVf22oNw4+hNvr89vDmB15OpXf4SMrtPxZlwEIWCzJaS8HNifxobB/YBb20zEb7oeryGkznEuVYnh3tH7qSXbDVG3nUfMkzKQWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/2022 5:51 AM, Maciej Fijalkowski wrote:
> Hi,
> 
> this set consists of two fixes to issues that were either pointed out on
> indirectly (John was reviewing AF_XDP selftests that were testing ice's
> ZC support) mailing list or were directly reported by customers.
> 
> First patch allows user space to see done descriptor in CQ even after a
> single frame being transmitted and second patch removes the need for
> having HW rings sized to power of 2 number of descriptors when used
> against AF_XDP.
> 
> I also forgot to mention that due to the current Tx cleaning algorithm,
> 4k HW ring was broken and these two patches bring it back to life, so we
> kill two birds with one stone.

Hi Maciej,

This isn't applying to net-queue.

Thanks,
Tony
