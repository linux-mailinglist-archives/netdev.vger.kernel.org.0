Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D391E6D53BD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjDCVj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjDCVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:39:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B3F5244
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680557916; x=1712093916;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m9S3r5y2EpAEX6JWmXbObWmCR6WzHeRzFRgYDogUtlQ=;
  b=mZnFY1qSMFWxrXlCKIJJWFB14zWO6vrqxtlNsR6J25U9u+xbGtujoGkH
   8CJmAKiaP/crczu9eexpEdVbyFl1+q56bF9Zf1vgLTd9Ttm+NcZ/h3oy4
   MHPzQx1w3eQXc/anIfTY3jDL5HbaeI+fqxV6QSZkV0JyZ6867v+4V2yFA
   u1GQ20nxy2W7pHKSqmVYO7l9RjFWqqsi5FDKPerTJvrL6HeK6w/2MGyZZ
   M8/aa66p7kohLfQN8e6gqEotDzDhKO2MHmT/KQyt6Ldz+XnRQUyBrl5GD
   sNKnmgxst7/Px9Fgm0OF1aeg0Gh/NmOmNX20rN8jWEGbZ4aP9tQOdAb5D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="339511301"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="339511301"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 14:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="750632766"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="750632766"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 03 Apr 2023 14:37:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 14:37:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 14:37:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 14:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5oM+ec8eiUetai8TIOaNpLGiUHlXHR1i6Tq1vmkUP9Ui9MHJC30DbiGQKyesrr5jrqQisbb/NoD83e+KFXV6vqKZTqjIG2kjlfQq7Dnf6Htp05tC+Jh5pozDoppQ64ikUHxIt6FGy21SywlQ4JC0L3Fhij42dfjfENoUjf/r7E3tn0zFflH89VHwtDRjUhn8r94mt9aSRwhFT/FA8IbXpW23nNcKgyqKgpN8s3X/M6HzEZ7iuFYEg5Xu0uNEx6QsTE6dY+O28fkLKc/wKSHKAo03beE+IIq+RnjIm2IQqOyvL7e+ffZJFgKPwV/hBxethEDgl75xE7mgyFTpxnP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxBVxZ1cAPB/XP4iN8HxfHjKMMXGXDiv6aEpW0W/YWs=;
 b=P/cSe05BToS+WC3LFL5d52S+OGeeULhSZCf6Q3N0B6lUzL0DPFM8APwxO/j0btTj7UJFt0OJBYSPAMxxaqlvGFkEoxMfv9WKaPlePdEOwrgorO0PlYG1lC34FGWElIL69FyLctNwloPVz0h2prmNyA8fAVF/kO/UoGgCGgHakz/blMMPexZf6L+LJCmgpGJrj4YwTtYZYJ6xGgeDf0uiAsr3kEuF594MwwW/OIfC7mqZJiUsd8BbNzTWGzjP3BmndfwAiAzjbhug6HFOeDY2UctPFijfnW9qlzbsGs9S/N67TLcZe0vPDauG3DsW24Lajslj7Tcs99Lr+Vns4wIdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Mon, 3 Apr
 2023 21:37:02 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%6]) with mapi id 15.20.6254.029; Mon, 3 Apr 2023
 21:37:02 +0000
Message-ID: <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
Date:   Mon, 3 Apr 2023 16:36:56 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <emil.s.tantilov@intel.com>,
        <willemb@google.com>, <decot@google.com>, <joshua.a.hay@intel.com>,
        Christoph Hellwig <hch@lst.de>, <michael.orr@intel.com>,
        <anjali.singhai@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <ZCV6fZfuX5O8sRtA@nvidia.com> <20230330102505.6d3b88da@kernel.org>
 <ZCXVE9CuaMbY+Cdl@nvidia.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <ZCXVE9CuaMbY+Cdl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::18) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SA2PR11MB5209:EE_
X-MS-Office365-Filtering-Correlation-Id: c76b907a-b1ed-4832-2041-08db348b8fc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TWaDQrv5re1xjaOlKJoudZHvmonBT/8XQKJodANO7dFWO9b20Vb5PmuP4lW+zZNYOdwTLLGKamkZElqUx17UKUTRgr6qkcRi9HRLoSfLqVtPpCUOqrNxhIhid3A0CVL4MOFK97hln21yql+eDy4paAEaE1p6+aIzbwJrVd0Cgwoqqpa8JeMS57FX4kODUA82ZvVM9cqSFD6ZnV/7JRLGZVyKtA9XYODp5fOdagz8GQJedG9kbh8Omi5KMb6q2LTtv2M/uVSN+RlxuHWjaIxcaly9LTX+xNyon7S/yHU9kVHmZTHWZwWbSW0q9vN/fua8Nu4YUiPGBZA+K0wO+PWjv+IOHwIIaYTTzMNt9Z0IIpZj4XsyCJAY1Q1dORlgQmrVdfTFU5yUvJaXE/45eEMBg5ZjCUIlsLgbZP+DhjBY+Lg+6h1OKNGQCh6c71mnSen6jdXqK9+5fRVF8jO6jyrkvjVXoiN6DtmcvNhbqf4YvJP8UyfvPZCcbCSyJfZuPETOWRAmbMmjmcOvMlaCC+UF6vJbecsOTQMe5pM37ukeb6ZobtCpRohtU/IG0wBRUOQAYQCox7k4VPRnEPnnVj8br9vqB79wd3ptICUfisv4jZNVE+y7FsrfNZcTPtZuDtMZwi4QCBw/hE9Cw2qUr83045ySoHPhf+fnbSJ9oSuvpqo0X9oVvXcRRg1uXk907ccs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(83380400001)(31686004)(16799955002)(36756003)(2616005)(186003)(6512007)(6506007)(53546011)(107886003)(6666004)(6486002)(966005)(54906003)(478600001)(316002)(110136005)(66946007)(66476007)(66556008)(82960400001)(38100700002)(8936002)(4326008)(41300700001)(8676002)(5660300002)(2906002)(31696002)(26005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzcyL2Z1M3JLUW92OXUyN21rSDIvT0xqZU9WZUdIdWNwVzJGYlpVeFU1cjhq?=
 =?utf-8?B?Tm9VU284Y3ZjOXh4YW85alJ4V2c4dVNBMUM2YU85cjR3THNiNTJtL01UckNO?=
 =?utf-8?B?cUtRSko4U2VqZm4ycWNZU3M4cHBRcGlTRk41L1JQalhmR1pHR0c1RE4yemY4?=
 =?utf-8?B?QWtuUnlpRXlGNURhN2pEUzJ6NmVlbmtKZFRlcW5icE8ya0NOVDczcG1XQTg2?=
 =?utf-8?B?MEpQdlNZTzdPYXNCNElEZkEyc0NkeXNlZnZvWnhYcmNUWDNhbk5QcVJiTEVh?=
 =?utf-8?B?aHBIL0M4akhnWm1TcFJEVlQrZGRwRU9FNUlMcWNpYk5USEVxa3l2ZnFZZDh3?=
 =?utf-8?B?Y2hzVlFTcUZSYzRsUW4xNkZLSkYrS01yK0RKYmhWN1dhRnViTy8xd0Vmay9i?=
 =?utf-8?B?b1ZCQXhYSS9iN0F1eENGRjJZMGVkSjcxV3Btcjd1cGZ0MFZpYWF3T09mb3c5?=
 =?utf-8?B?a0gwQ3Mwc3RtWFNjRGF2UGJXeVRPU1lQT21tRzNFWmd4L25aVTBFYkI1RDZT?=
 =?utf-8?B?TnRVWVZZdWVqaCs2aUxlYnQ3ZDFjZWREWnRQTEpzS0V1UmM3RkxFYmYxOER1?=
 =?utf-8?B?RTBNZnMvLzVkT3IrTWtIVzRhWGordTZPWXlYTHcwMjNaN2ZNZE94QXZ2QzBB?=
 =?utf-8?B?MVJoTSttcFJWdlMvT1gxdVVSNmRZM0Nhd3E3TjV0V2plbXVWck9qU1R0QWp0?=
 =?utf-8?B?MHhlUWN5WlFST1R2ZGpqVmY2MFZkNWxDN2NKWGMrV0pKKy9kczBWb3QwN0U3?=
 =?utf-8?B?WlhQVHFUVHNYVWg3aVZoNkt0WEpUamdrRzFrcDhRYTZlY2xEWjZ1ZGZ0bUhX?=
 =?utf-8?B?cTNaTHJnb0RycjJtbEJFaG85a3dvclVhamdKOWNaeDc0QlcybnZYSVp1WjVY?=
 =?utf-8?B?S2RMbzR1SG43K01ReGlZaTJucUtkR2MxQlVoUkppVkFNaG5ZYjdCWlhDTmRI?=
 =?utf-8?B?OFo5MDRJS2VNR0E4bG9Va09RbE1RMEN2UWZQbUFVSzJLZkZncHY4YmwwdHZz?=
 =?utf-8?B?cnVjRk5yTTFIQmFBZUczMU1BdmVTUzZ6VzV3Q2FLYXluTXllWWtUb0pHTzho?=
 =?utf-8?B?T0pMdGNacXJxeHNJUDBURVgwK1JvdnlNU0gwaUpUemkxSFFodjNTME5FbUVs?=
 =?utf-8?B?UVhKa3hPRWw5ZmFMU29qNDIvRVVIQU00Z1R2UGs1aW9pU3NkbDJpMHFBd1hs?=
 =?utf-8?B?K3BHMTg0a2VYRk9ydDd4VDNtdzh3M0laWThWSDJuQW95RUp5NmV6R3VFTDMr?=
 =?utf-8?B?bzJNamU0WVovSWR1cGprZS83T3lzUmJPd2J5RkdhQmk0cW9ZZ2J5UkVrUmwz?=
 =?utf-8?B?Y1VBenl2dnlNQ3dpckhXTjlwd1V4alVnR2RQOXdtZ3hjK1hFUHBLcnNldXpX?=
 =?utf-8?B?dUczWks3ZDRGV0RwUU5CT2s3SkNKZ0g0NzExQXEvcUFLblhTaFRSTmhaWnVy?=
 =?utf-8?B?RWRWWXBLY0ZvWFpVWUpISXNteVV5OGRhNkNDVzBBZGlZR3orWUt5QkVjYmU0?=
 =?utf-8?B?SnEwcVYwOVRKUS9FRW4wbGFpdGtxamFZTHdOd01KbGZTeFlFSXRnL05ldktH?=
 =?utf-8?B?UURIMUx4Tjl2R1BHbjdRVHhRYmZBcFNEUFYvd0VPek1Zc2lJWkRsWnpnS3hy?=
 =?utf-8?B?eGxGT25zQ0o0NWg4VDFxWmZMQmo3OEZ2Rno0eFprRFZVU21paGY2RmN5eVBI?=
 =?utf-8?B?aElDWlJwYVUxc2gxUGR5RzJkQ2xFWHFsTWdPMzhWZ1ArTXBkY21pa0QzODF2?=
 =?utf-8?B?aTJJWDFtNEM1eXJYVjEvcm1XWU9uMjFxcFUydW1IdTZHUFVLOGY2ZG1tSHhz?=
 =?utf-8?B?Z2NCSnNzdW1zd0hCdUFwRmFPY3pWM1VsUHRyYmdReDlHRkF3MG4xZ2tsNk1S?=
 =?utf-8?B?MEJzbERLNGQvMTh3ZVpNR1Y1cUpVdFhWakFvbFQ2OTQvVXU3eVYxd3M1a1Fh?=
 =?utf-8?B?ZWN6aitjWDA0SGtSaDFYcHFTQWQ4RXk1NzhhODR4M0JoclpTL0NGYXBJdDEr?=
 =?utf-8?B?cTl2ak9uYWpFOXE5WCthV3JONCtmY1RYeTkySGpjR0plMHN3UVNiOG1LbzJI?=
 =?utf-8?B?RlZHdjVXSWVOYUV2Umo1a3hqbldTRE5UK2pXeFdpRm9SUFJFRWxzQ3cwZDlE?=
 =?utf-8?B?aW1pY290d3pYSFJXMHJlMjlNK040Q3NhL2kxczR2UUVJbGFQZTFrSngrajVX?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c76b907a-b1ed-4832-2041-08db348b8fc5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 21:37:02.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoAHzbQnQJBIvOa0L9NDzReO20dPwiMz3GgWWgM0bfJ3jR8sFsyQmcf9lZlZLb6d9YqbmC3ZbGqVRb838945FcfBw+/xiOQkibtoQvkE8dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Posting on behalf of Michael Orr, Intel.
====

I am Michael Orr, from Intel
I am the Convener of IDPF TC at Oasis, and the Author of IDPF charter,
so Probably the right Person to answer this.

Due to tech issues in getting subscribed, I am asking my Colleague to
post this into the thread.

Bottom line: There is no issue in publishing this driver, and no
conflict with OASIS IDPF TC.

See point-by-point below

On 3/30/2023 1:29 PM, Jason Gunthorpe wrote:
> On Thu, Mar 30, 2023 at 10:25:05AM -0700, Jakub Kicinski wrote:
>> On Thu, 30 Mar 2023 09:03:09 -0300 Jason Gunthorpe wrote:
>>> On Wed, Mar 29, 2023 at 07:03:49AM -0700, Pavan Kumar Linga wrote:
>>>> This patch series introduces the Infrastructure Data Path Function (IDPF)
>>>> driver. It is used for both physical and virtual functions. Except for
>>>> some of the device operations the rest of the functionality is the same
>>>> for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
>>>> defined in the virtchnl2 header file which helps the driver to learn
>>>> the capabilities and register offsets from the device Control Plane (CP)
>>>> instead of assuming the default values.
>>>
>>> Isn't IDPF currently being "standardized" at OASIS?

IDPF is indeed being Standardized at OASIS. Everyone is free (AND
INVITED!) to join the work.

>>>
>>> Has a standard been ratified? Isn't it rather premature to merge a
>>> driver for a standard that doesn't exist?

The Standard has not been ratified. Work has just started recently. When
IDPF TC members finish the work and vote to approve the result THAT
version will be the OASIS Standard IDPF specification, and will have a
reference driver to accompany it, likely labeled V1.0

>>>
>>> Publicly posting pre-ratification work is often against the IP
>>> policies of standards orgs, are you even legally OK to post this?

Publishing this driver does not go against any IP policy of OASIS or the
IDPF TC. There is no legal issue.

>>>
>>> Confused,
>>
>> And you called me politically motivated in the discussion about RDMA :|
>> Vendor posts a driver, nothing special as far as netdev is concerned.
> 
> The patches directly link to the OASIS working group, they need to
> explain WTF is going on here.

As explained in the Charter, Intel & Google are donating the current
Vendor driver & its spec to the IDPF TC to serve as a starting point for
an eventual vendor-agnostic Spec & Driver that will be the OASIS IDPF
standard set.

> 
> The published doucments they link to expressly say:
> 
>   This is version 0.9 of IDPF Specification, to serve as basis for IDPF
>   TC work. This is a work-in-progress document, and should not be used
>   for implementation as is.

Since I wrote this: This is intended to state that version 0.9
is NOT *the* OASIS IDPF TC driver, just a base to start working from.
We know the current version is not vendor independent and that it is
likely changes will be added by the IDPF TC.

> 
> Further OASIS has a legal IPR policy that basically means Intel needs
> to publicly justify that their Signed-off-by is consisent with the
> kernel rules of the DCO. ie that they have a legal right to submit
> this IP to the kernel.

OASIS does NOT have such a legal IPR policy. The only IPR policy that
applies to the IDPF TC members is the “Non-assert” IPR policy as stated
in the Charter.
Any IDPF TC member company is free to publish any vendor driver they
choose to. What they Publish is simply then their driver, and not an
implementation of the OASIS IDPF Standard.

IDPF Charter (And draft spec, and all other documents and mailings) are
here:
https://www.oasis-open.org/committees/documents.php?wg_abbrev=idpf&show_descriptions=yes

OASIS IPR Policies for TC’s are here: 
https://www.oasis-open.org/policies-guidelines/ipr/

> 
> It is frequent that people make IPR mistakes, it is something
> maintainers should be double-checking when they are aware of it.
> 
> Frankly, this stopped being a "vendor driver" as soon as they linked
> to OASIS documents.
> 
> More broadly we have seen good success in Linux with the
> standards-first model. NVMe for example will not merge "vendor
> extensions" and the like that are not in the published ratified
> standard. It gives more power to the standards bodies and encourages
> vendor collaboration.
> 
> It is up to netdev community, but it looks pretty wild to see patches
> link to a supposed multi-vendor OASIS standard, put the implementation
> under net/ethernet/intel/idpf/ and come before standard
> ratification.
> 
> It is a legitimate question if that is how netdev community wants to
> manage its standard backed drivers.
> 
> Jason
