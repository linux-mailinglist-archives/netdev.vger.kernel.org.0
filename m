Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1416DDEE1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDKPGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKPGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:06:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B9AE6E;
        Tue, 11 Apr 2023 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681225596; x=1712761596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HuO4kaig8cmQuR3ItPDcy2CfZzqOlvsXaSISafrqrqY=;
  b=GRPzp/vcSXU3VX3DZgrkQfIK9Y8BsavBWvbFnb2ZfDxfzJUwVkDkV9G1
   x986FvDd7MMMTEI9NDUuljCZt0fPlp21YjZd7fKZFGKIv9ZOKgdUgkVeq
   x1po/sKtU0EaCNokMBoV/xnG5Hu0BgyJbX+dKdnGwM9BXYIUi/fSTcuri
   f4eiG28MppZg4vfTXmIjI/YZPs6wPEOcMsTTwvBVxOkRGI+EaAWK11TRL
   Osd/ZmZK/0UWTFbkBzaP23p/pjKKVjcwk9QlfCTXvAvdrmznm8vrvfrJy
   0cDb0saQZYdPordg82SrqibA2Pzj0WYNf6hOxgeiT5i9krcqxgXHDDHTd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="429932213"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="429932213"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:06:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682112745"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="682112745"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 11 Apr 2023 08:06:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:35 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:06:34 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0bc4yPHwzgHqW1SbGGPCoJZoedqYiS48UYxnjyUvGt2RvB6sO/xiglkipc+qiodm1pb+W7uK+yYaDuvoQ+9IgROsH6fYS56oYqrSDOe0W0TrpKDPWeSJ93A1Pq2kG2PzS5sTVxbUGxvPV5UIsRg/anMBIkdEq39Za6BIZfDE13xN6RGhyENldwDQgHxm7jgDrMQEmY52DEmZh9b1UsZcIyjWFuK+SfNzwjMub9O9zpVlgGJk6tpXDsxvl4w0EGMnedLEwLc1Gb6HwQOX4kjIcBeH867aD7PLQAyWE6exPP/aBXDN+rgIoV2saB7eAfa8yvTxbhjbfQG8qi0mDMD8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWIwSWp+Ru56Soe0UhDXTOobJDFYVzHbG9+fYoNryhU=;
 b=Tu7G4evi4RH+9HJhlI8AXr9AdfKsHLVOjpH7qYsEBnRR/npHcnP2ZvZugPBSMO37IWPDUuLP/EJAe6Ll2VK4jj3UM86Ejhiu/NwhY/1Rt/SVy4NWQSYWZIYbgx2IhGlw03Vb03GPQtTtDlIqPbv370wfCNQ1Pk2tqh6HsW6DcXHODNAcO48i1vQog3ZrUPr05cucJA6cKceWdRAAwulkAKSvhiAMEWjUxLXRujVpa21GzvtrJNubhruX3gjze3Zc36i9wlmA0SD7HrVc58a4oXaSGXGG3TSNv53LAtYv0lPhQB0KENRBmUxnKZOUsnt+6AQ/byl4ykYh9M84rVXdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4601.namprd11.prod.outlook.com (2603:10b6:303:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:06:30 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:06:30 +0000
Message-ID: <2a1be32f-452b-1bbb-00bb-5bc0ed5c3377@intel.com>
Date:   Tue, 11 Apr 2023 08:06:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2,net-next, 3/3] net: mana: Add support for jumbo frame
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW3PR11MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3662e0-cf5d-4dda-9fcc-08db3a9e5494
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrI5ZSoJSqyF/cgpG+tPsMFFIPxU/6FQoWHstuzMeeN8NDpwVeiyPNpT8/p7i4HKKvOutGETXuu0NznIuQCc5xfzDae4hs3bOqK4tEkyVRVAjJyWnI6k1VitxjU8p6s1cbBOecUZbBAhNSZJVAoWry/shlvM/lY2C4Cm9kRIdWV922bYNKCuTFofXMydrdxz6S3HncoX2VhwjU3kLV577tNDbwtStLkKEeopZ2y9MrJ8mWRHVhJAszeEPFtvRrqevdoeeeLKJ3Yn2NgYdSVHl6fb/ilIWh71vSx3S7Kb3bRk+PfE4s4G5r/iorz42Q3+w7KY2rvQPweCaqcwmNQK12moZZYWFVFOd30ZxWwshfs4va6A1tM+/TBl8QNN45qu4P7cBbrDJiixDfUAEKMo4tIPeGdJS3/iHox8Ak575/bu1DD1dD6Vro/7LmQgS7ac3stAsAnmmQWh0moeRNvTWJxXL/n+KFn4EsrOtSi5I2mcJw6DbJx+q39Xv/Ns6TtI8TwAh/GWSWLW6vw7Wq2lVs4tPSKF+RKk3mV2q/2fSTsqQ//j1evo/rUHukoiXNXv/t3WqotBJgly+ZTD/awdwbJNx3UiJ97OshVuKVUMAWeCfW5vYc2Y4/ggvVsVg6W0H3Vl3ZqBXi8/T2aTFGHe5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199021)(31686004)(478600001)(45080400002)(86362001)(83380400001)(31696002)(82960400001)(36756003)(2616005)(38100700002)(6486002)(4744005)(2906002)(53546011)(6512007)(316002)(26005)(6506007)(186003)(44832011)(66476007)(41300700001)(8676002)(6666004)(66556008)(8936002)(7416002)(4326008)(5660300002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFBvZU12UjM0M04wOUlxK3BEUUxpdTUxTFZzbXlWYmhPSkttUUZMTGhhNTRu?=
 =?utf-8?B?ZjRyN2YvRzBSbjA2UUgwQklHZjh2b2RUdFYrS1ZIS2xzQTdKaXArcEdzYnNS?=
 =?utf-8?B?TUZua2hYT3NPaXY1d2tZa1JBMThjcHRqS09aRmhMYnBVRUhnVTZQYmpEeG9t?=
 =?utf-8?B?QVlqZC9Bd1JUa0QxYkxiZlE2K1daeWYycVpRcjhITFFZOHp5RVE5b3F6bUVX?=
 =?utf-8?B?eWhnd21Pa3k1ejdQUjJNUXJyZUMwL2U3dlJ3WGJ0NXlDWjVCUGJhZ3kzM0RO?=
 =?utf-8?B?YVZFNHhVRElpdmduQWZma1J6a0hJMUdzNUpxNlhWMVhQeHROaUYrN01PMnlj?=
 =?utf-8?B?aHYyOVRIUFRxZTRtOW5QTjY5LzdDOE90akRIN1p0M2hSelFlM0gvRWdySzUz?=
 =?utf-8?B?NjZ6eHFIejlrM3kvM2FQZlprUS9QdHZFaEhud0g5cG40Y1l6YzA3ZXJQNmJG?=
 =?utf-8?B?bWxRVG1zRTRQOXN0N1FPTG5MclRVMmQ0OGZ3TVViVmljWEZFYUVNRjJQdmpR?=
 =?utf-8?B?Mnk5R1R0K2RseUZiUmQ1T3JFZWg0YU5oa3dBNGVOa0tPUmNodUZNT1p2aVpJ?=
 =?utf-8?B?bU9WWHJEQUtCOEo4OHdmaCtvalBHb2EyYUlKdk9QVGN1SlFpWnpYdTJsT1Rz?=
 =?utf-8?B?b0o0NG9VR05uNkNNZWE2V09KaEoyK3c1aktmWVprb0VyOGMrZmc1M3hYUGVT?=
 =?utf-8?B?SkdyZCtUeC8yR0ZxandiRkR5SWlzSEVDbG5uRFMvdHNiTG5iTmRodXhCYUpJ?=
 =?utf-8?B?NVlWbU95WnhwK0l2OEkycVhOcDR5S0o2N2toV0RsVUtKM2FETC9rUTFvK1Vv?=
 =?utf-8?B?U0czZWpEaExKbVZHQjdiRWNHWTYwYklRNm4yeW0ya3p4SytzWjhjZDNCVXRP?=
 =?utf-8?B?K1NnbFdMWngvV2FjZlZ5eVZsR0ZzMzhmbFU0SUNnRENDdjE0V0NQU0lxY2ZG?=
 =?utf-8?B?OHRKWG01UkNZbW5KUFdsdmZNZ01xL1FWRzR5NUIrL2pHdHdqck9GUnhiYWJT?=
 =?utf-8?B?cktoanZOaWpuZFVVT3RQNmlRZFZPUmUrZFVTNmE3YjhHRDYyRHZSaUgxTmN0?=
 =?utf-8?B?QlNzZVB6TytBbXZSc2tpN012Q29zZFJGeUNvYTFpZnBnR3ltQmh1SWFsYy90?=
 =?utf-8?B?Tmo2Z1dmbVJnMC9MclhiZkhrVDNxVXJRSm5ISzdaQ0l2UEZRMEJBY1h1aHp4?=
 =?utf-8?B?ZWdMQlMvRmFySmRjQStuTG1MLy9KcmF0R1VySkk0SDI4Mm1Da1FqK2MvcW1U?=
 =?utf-8?B?TDRQNVpNb2xtVHBDMW5jcHI4RFk2V2w1cEpWYzJsQlJBU1Y1Nm1ycGxVd0dI?=
 =?utf-8?B?V2xNczIzcFF2WmVGWFdVZkpmSC9STFRIS2dOYWd4UUcycEFaUW5JUUN2bFRX?=
 =?utf-8?B?YkU2dDg4SWpTbDZ5c0xzMytoZ3E2aWpISTZCUWVHWjVtLzkwMGpyZDR3NE5w?=
 =?utf-8?B?am1mWVdEQUVzc1BaYmU2cDJ1ZUM0YXpyWVdPV0oyVUFueHFhUlVGSVdTRVRU?=
 =?utf-8?B?MTZXQWNBeWRQSElJMWVvT21IUDkwSlFIeDJIMWhSYXlJQ3k4dzdHN3lHNDhO?=
 =?utf-8?B?dFVqbWxLWmVUekxVOVNHUG9sSzM1bEp3RzMyRi9uZkVlZzNqNHRDbG0vVE5t?=
 =?utf-8?B?UVZKcnBXaWNNWUgyanU0aGVBbEZ0R0ZyUjlaSG1lTjFJT0lpck16Rk5TTXZu?=
 =?utf-8?B?WkZ1ZVpmTmZPRnpDUXdvem9jSUd0Vk1NNE82T0hsSzZHZlg0N1RKREdwWmhB?=
 =?utf-8?B?R2ZzSm94WmlCQkVYNHNHTjJuMnc1YVloS0FKSjhUK1F6OHNXOEF3MmJPaEpw?=
 =?utf-8?B?c1phWTZGa2xrWUg3VFluRkV3QVFQbUhFNmljV2dOQlBuTks1NmlnVFBHVEdw?=
 =?utf-8?B?S21hMDJMVG55WGpCUTBKVDhNemo4MXY4dm1pdm1Bc0g5bER5NkxaOEJHNnZw?=
 =?utf-8?B?RWdwT2dYZ09vOGcvYmVOMHVzZ2hyOHMxN3hNaWljL1VqRnU0S1pZN0h6LzJm?=
 =?utf-8?B?Qi9teFRockh3aWpEN1FCaCtQbGR5ZnBwRzlVVFlLUVpPT2EyNVpRaG9iWXlH?=
 =?utf-8?B?RERNMDlKN0c3YWsvN2xaWndRS0ozVU41MWNKWUxiR2N2a3NnT25kSW52UjNP?=
 =?utf-8?B?WlU5ZGRHbmlob3hrTW52UDdjVUV4azZ1V0VSRnBkQWVIWFJLaEh5bGxjVTh3?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3662e0-cf5d-4dda-9fcc-08db3a9e5494
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:06:30.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rZS5Ns7TF9ADuHHPaNk/D76Z98qxo06ePZn/fABQNo65/I/4wOBAgIbO3QR8wFTzabUf+EdaDJIupPYcVK+JZNbGdsVqHjQ42zs//ljqSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/2023 1:59 PM, Haiyang Zhang wrote:
> During probe, get the hardware-allowed max MTU by querying the device
> configuration. Users can select MTU up to the device limit.
> When XDP is in use, limit MTU settings so the buffer size is within
> one page.
> Also, to prevent changing MTU fails, and leaves the NIC in a bad state,
> pre-allocate all buffers before starting the change. So in low memory
> condition, it will return error, without affecting the NIC.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


