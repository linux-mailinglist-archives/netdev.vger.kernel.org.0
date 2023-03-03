Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411DA6A95FD
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCCLXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCLXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:23:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F55118B19;
        Fri,  3 Mar 2023 03:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677842601; x=1709378601;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jZIaOkrm38UTRkTWcltyDLSnWWjT8rgg/diUp9Eqo+Y=;
  b=DQe8VXBlD20lmxNmP+Q8RZOFPBLZYG0ajTrVD0Xf6TGJ1QE/VCG3KgaU
   lUbzOAG75T5TWJbJNANHteyzIf6joKbpoV62PWAfFy8r81Lb1J6U4EdQb
   +GlQiJL2LIa0PjqzV48xRwQMI+OkUYVd4V1AFIb7wfkFtXcDuKx5nnLc0
   tDctZlCtAI7sf6l8d3U+uremvj96I59wZ3xt5houdBW08+pSHjtLPoVi3
   Jeoc09oHr7lopuDsqJsj3+8A+LcUKegoSsxMsc1QT4w+qiyQ3Fw2w1kGm
   DIItJYzNCs/rJqbAAxVgCWTU+WypMTuq/1ZKLpVJowjQo4lYF4yrRkuy/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="332502350"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="332502350"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 03:23:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="705613823"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="705613823"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2023 03:23:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 03:23:20 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 03:23:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 03:23:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 03:23:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i020JRNZTUjw4tphcbEk1Lf8op76g5dBgEJZspQ7axQs8BcGuCAF1Q8gFryETbcI2CuGhaqoTkd8OxndSXqEWUP42t1Mbcn6KKHq0ezmsW/wbyci2QHrZ2717IRTJco08Sd5cCEd/hata1MaCsB/TTx1huS0heiGLxj1xlxrYXQ8CRd6yrqUFO9oeR7waLg2iRsm3IrZ9s5ix9TYWgCRdl0fnIkiw9aodO0ZXSR4zyesrltdK4DZrDTT0ng2vdJF59l0wgEJ24P0DSyoKSzo1+k6RZOumqd5XfXpbKaYsr0z/iCyDLXRWtJXzRuhD/zZ0ze/uHgjDG8PAnW/obBzVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ugux30qmXeOQIgK1DeLzLGSLNQw121vzHlPo1EcedFc=;
 b=JviCao37yjyakQzQltgQ+ibWS/CyMqwSDGrMaPbxkc8PyxX+DB7T7naZ6y0+QDG8nYbbBUdq225gdAgxUB/7Vb0oVfbNUyBdVGNzRUmru4BSoVa4N1reiVpV4HlPD61+ouAQEi+4mSVn4lLLw/hu+6kXwA2BW2HkMSpVH8gr5TNRPa1ZU+4WrthCa73Q8esbq2Ivqr6CJwCle6j69gFxOUnsvMOKhx508pnSaZcrFXLLyj2k93Nx0xoEsbRi5lqB2d5PfMwYd05C7b8GrP8RXNgTL56KUB5ZkfnFP5k1rmFQu+LyWaQZCAUtI7B24dYicoVkMIuqfd9waYt08hkm9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW3PR11MB4762.namprd11.prod.outlook.com (2603:10b6:303:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 11:23:17 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 11:23:17 +0000
Message-ID: <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
Date:   Fri, 3 Mar 2023 12:22:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:610:76::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW3PR11MB4762:EE_
X-MS-Office365-Filtering-Correlation-Id: afd89996-ea5c-480e-f22b-08db1bd9afa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zcKsF8LCB2Q+d4+m5vGVkWjgPLW9zIRlzF7afQKvXnRHL1EQLHYzx4Q+VnWdzSDXjGom5BLP/BvI0Aviupsn3Cy5NCEMAvE5C6b8h+Mlc0Lp+qeDu3DHsGxNHKyiP3eNuaYzQ/DPJvMYjwwbO3BuTkEoabLIRAhvjZxJhIgkdurdwyQ52ySC+pBHrKAKBLy0Soy8sESdrC0hbN0bsHrD59wZQyq+whNiFJT9sUjOvyFPW8i0uRNDd9cOhp17MA5KNHWx9G+R4FW9/flJAaESAWtKIO0p0mZCtxintf7bGxQCPL0ny0PQ8WgI2AT1+aKycaKTSn9mzCmP77HudgX+ZfvT9Wt0vQWL1/MvJEaFtJEm5Pn6U881/GZP9iVrxx5L71E1Na//n6FNCldXNfEe3IKTPznhuCnG5Kh8sEl3zwLWOanV9XYk6rIOI1RsBVz3DfBFAVCyE89JexYS7RCXfVBp3RavCtbln+hcj2nJV7I8ipLnzMwG723r7ZTVgXbuREG96QDQST4fUxOSN118K50bJT0s2MWyNmQiUdniD27QbikXRsIy0dURRDmFUQ+JHQ9/xu9MfLs1wHKOsxFGNMlmRMYfmxwhqIpUK6p8sZS1ycLCCmkDuD7998bRyiAv9C7hFb6bfcI5I3KuQiQXYRrsjPCB2lFTX3LuKNqmeyu9OnHJySSq94k0WLBOJsmPNBSvIB5TcUNu3+//jHqxUa6dKTW/3qu6c+bagZZWupF9NsGSVh44fuuftfJZyG1+U2nlLGWxTlzldchRhfL+0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(31696002)(86362001)(66556008)(36756003)(2616005)(41300700001)(53546011)(186003)(6916009)(66476007)(66946007)(54906003)(6512007)(8936002)(8676002)(478600001)(6486002)(45080400002)(316002)(6666004)(6506007)(5660300002)(26005)(82960400001)(38100700002)(83380400001)(7416002)(2906002)(4326008)(966005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVVXM250VVlsY2UxRzRLVTNDQk4xUW1pcEpFMWZkN3BUdkpDdDdVMHBrSGdL?=
 =?utf-8?B?RlFzY1hSWUwwY2FKN3VQTThUWTJJT0h0SnlkaFE0SzY3RHNZUjNiNy83MHpz?=
 =?utf-8?B?MVVieFdQNisyenRqUTdEbXlIWllUNlRVRkUxWHBXUkNrVmZhUkh3aExrekN1?=
 =?utf-8?B?VzhqQ0t6NGVja0VkWFNzVVo3SFJjaEFkYkV5UWNkUmpwWVRpWW0rajNwUmxP?=
 =?utf-8?B?YkdidDROZnRUYlRQTTRYbHB3ZUNoUTdSRHVuWUtocXFobW9IQVozY2FqL0ZN?=
 =?utf-8?B?Mk14cFJRS3ZUWFZZQ2tGNi9DVU00L1gzSjdQNUc3Wlg4eFpJUXVaV3M1RUM5?=
 =?utf-8?B?Q204eDgyVGNnZm9MR3NWL3ArNHltWFVKZFRNaE5VZnhMUDdNYnlGaWtnbmxG?=
 =?utf-8?B?WHc2K3VsTFJnbHBmazZOTmprSUJTTDVsbXJ0Yys1R2tsMEJiZDVteXRtWFUz?=
 =?utf-8?B?Y0hNSklaNm8rUmZDcEJUUmFRSEtPeTJCZzRqUjl6Tk5oOEU1NXZCQlJmWmI4?=
 =?utf-8?B?V2Z3bVIxMGc1NmRuQXZqWWhTNUQ4YU1RWVZGaTcxTnB0REpBVVZLSy9VeXNX?=
 =?utf-8?B?eDcybG9KTGlrSWxwSmNXSjZwcEJpblNkTjUxZWdlUjZwTS85Z1dHdWE5T1JN?=
 =?utf-8?B?ZU5MNS9hWjVLTlErTERTK01lZUxjY2pVQTVWV3RtL0NBT3ZmU1Y5dTRrOUtv?=
 =?utf-8?B?UDl1YWJBU2V5aDZsWms4cVlvTXl0Y1pNNzc2bklQTHdaWlo5Y3BwMTMyZGRl?=
 =?utf-8?B?bkVCLy9sSytHc3dvaHpxSFVlVGZoQWdMR3k1ckRWYW5IQ0hrdkxFQzc2SVJV?=
 =?utf-8?B?akdEZ2dnK0Nsb0wyeEtsNitKcjdoK1ZlZWROa2NwTENXSVBiWUl3eFA3WEth?=
 =?utf-8?B?YjRPamtubTlmVVM0MlF5NHFHL2pBcFc0ZTRYOHlRUTJMZnRqeWFncDVzd28x?=
 =?utf-8?B?VGw5bUs2QTBmZWpKVFVQVk95K1dtTmYzUDVHbnpzY0l4Wk43RWlFVTVPS3RX?=
 =?utf-8?B?YXI5djkwMU1Jak1TMkIzOHlsd3NSNUF4QjIzaFJ3RW9ZQzNCRnBvNnVVcHRJ?=
 =?utf-8?B?cmNhaXJCL1c5OG5ZMDlEejBMUVRWMlpybks2ZC9WeHNzbGpsWU5CVGw1Z3pn?=
 =?utf-8?B?VVE1U2pkZTlXdDJKWFpDUnBnekVCTHdGbmR4R1ltaXdOMUdpc0J5NlVaV2hP?=
 =?utf-8?B?eUdzaDU3bmZkaGdqNlVTTEQ2S2NrTVBrdGl2U1E1aU1LWXNxa0ZuNDNOdGNk?=
 =?utf-8?B?RDJmN1Nzc2N3YjhRbS90NUF1M1dBeGJZaXZ5bnp2SzNzVU9pMVM5a3FsRDdy?=
 =?utf-8?B?M0ZwSHRBMFc3QUxXajBUUTVsWTFBNDRVaWltWWZ3eEFaYzdHZmFPd3B6K3hT?=
 =?utf-8?B?L2s5UDN1QlZJS2dQZmlqTWFNY0pRTFVoT09Yc1lRWnBPYjVDbTRPc3l6V1FG?=
 =?utf-8?B?eG01bUxqVHlKWE5saVNzRndYNHFJUTIzZzZHbEZ6Y1B6UDh3cExUQ05xelBM?=
 =?utf-8?B?bTZLL3ZZaUpmSHdHNUFIY1B5YWEycEtRK0dHVEMrSkZMYnhzK01CdnNnTWVa?=
 =?utf-8?B?T1JZdlNlWTJqVGtLSEpXcnFJbTd6UTVTYnd0ZWJuTVlvQlhJRitPT3ZVQmtL?=
 =?utf-8?B?MElVWEJpRXZoZmZLamwxTDMycnJnSkZxZmFBcE42RTJlRkxRYUxmZW45dHJr?=
 =?utf-8?B?eFJsVGoyd1plSnhrTjAwYXVGWis0VEZuY2o4TUxCVW1FdzN5dE52eHdvNHpB?=
 =?utf-8?B?bEg3a2FtZ29DbVc5VDBlRXNLUTlvL3ZFeUR5ajliNkJQWW1hSCtrNFRVeVc4?=
 =?utf-8?B?aUdSREhmWlAvV1JNaS9iUkhXTE40TWt2N0dYbFhsWVVib0hud1JNMGZ3VWo1?=
 =?utf-8?B?OFQ4N3BOcWpXNFcyWldyR1lneUtxbG9YQ1Jzc1VNRjlCbVVGY2ZXV2YzdW5p?=
 =?utf-8?B?Tlc2NFNHMnJkQk1ndTNuVE5CZ0RwalgzY29oZGtISW9WNEg1OWxxQisvaStt?=
 =?utf-8?B?Q2xCeTc0VkdsODZNOWNvVzdnWXVVVGx1T3c0WlFOUDRhNVMrdlBBWEVFRFhy?=
 =?utf-8?B?VVI2d1YyU1Z2RnBaWUlSSlpHeTJHR09XRjVyVmhRaGlYQ0padGl1am42cUxT?=
 =?utf-8?B?czd0T0hQdlkvZStmblUyeVl3UXlaM290KzlGbWcydG51a05XQ0U4cUtIbkpa?=
 =?utf-8?Q?JqXK22CcUUesH9R09fpaVh0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afd89996-ea5c-480e-f22b-08db1bd9afa5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:23:17.3829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBFeS/dLQBYgwlfTk3eJEWPI3F14K1vby7V4E3gycnXI5RLqQx8r45q6ZJyk+oXSzfN4XJ/x2gDXen+Y1sLJEP6CWX9S1LsPhVdp2FkK7cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Thu, 2 Mar 2023 10:30:13 +0800

> On 2023/3/2 0:03, Alexander Lobakin wrote:
>> __xdp_build_skb_from_frame() state(d):
>>
>> /* Until page_pool get SKB return path, release DMA here */
>>
>> Page Pool got skb pages recycling in April 2021, but missed this
>> function.

[...]

> We both rely on both skb->pp_recycle and page->pp_magic to decide
> the page is really from page pool. So there was a few corner case
> problem when we are sharing a page for different skb in the driver
> level or calling skb_clone() or skb_try_coalesce().
> see:
> https://github.com/torvalds/linux/commit/2cc3aeb5ecccec0d266813172fcd82b4b5fa5803
> https://lore.kernel.org/netdev/MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com/t/
> https://lore.kernel.org/netdev/167475990764.1934330.11960904198087757911.stgit@localhost.localdomain/

And they are fixed :D
No drivers currently which use Page Pool mix PP pages with non-PP. And
it's impossible to trigger try_coalesce() or so at least on cpumap path
since we're only creating skbs at that moment, they don't come from
anywhere else.

> 
> As the 'struct xdp_frame' also use 'struct skb_shared_info' which is
> sharable, see xdp_get_shared_info_from_frame().
> 
> For now xdpf_clone() does not seems to handling frag page yet,
> so it should be fine for now.

xdpf_clone() clones a frame to a new full page and doesn't copy its
skb_shared_info.

> 
> IMHO we should find a way to use per-page marker, instead of both
> per-skb and per-page markers, in order to avoid the above problem
> for xdp if xdp has a similar processing as skb, as suggested by Eric.
> 
> https://lore.kernel.org/netdev/CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com/

As Jesper already pointed out, not having a quick way to check whether
we have to check ::pp_magic at all can decrease performance. So it's
rather a shortcut.

> 
>>  
>>  	/* Allow SKB to reuse area used by xdp_frame */
>>  	xdp_scrub_frame(xdpf);
>>

Thanks,
Olek
