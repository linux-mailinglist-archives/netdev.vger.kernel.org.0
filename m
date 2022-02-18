Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452544BB753
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiBRKzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:55:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiBRKzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:55:21 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CA0237C7;
        Fri, 18 Feb 2022 02:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645181704; x=1676717704;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AroNkBQOD7kGLDnHaQJqWoHuFWTI8Kzr+8TBp78OR3w=;
  b=EP3ZD59AWkJTdekhWjoSne9p7y0/FVVW5qv8XstDm3RTESELsKyy1Z2f
   L5EanFO7uKN7HcZ1/QkIFnW0qrm/1l1DfxX+UaO2jngj7NCK/6LcrSFaM
   MDOogabo7eYUO9HfYkrjQV/h1ldqFa0PxvyAit3a9LPw5o01q8coLlgdJ
   WqzJ/E8UXDxWzAEhFCVKDNpxf+XYCcbNptDofRTX8BUEYYddSO0vRMVeG
   iP3LLTER8uQ8YwAqdXJ0x+M6LDpvJXzq3I3cPW+oVae2WHO/9yxQgIAhI
   aVBjv9bheOT6855OM8nu54pYE77DpAMuAivS+THx12RQdk7G3nIRX85yH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="275701017"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="275701017"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 02:55:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="546233623"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 18 Feb 2022 02:55:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 02:55:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 18 Feb 2022 02:55:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 18 Feb 2022 02:55:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVG949yowd4MeHLT+k7ywpCjEJtdmUnBbIUZJqFqMwCihJRcbbbOl1oTKQLE4OzXvBAnz/WainkoTijQdLbtqerZ71LVo94GhDHRbdb9j6gezSoc6R5r6MPvsqLyE0R2iQ1XXvuf3q7h+somThGVU+863M6E3OuBlhm/UE2z98wnnLR9BQqnqSMUB6U53YO1oTwFZyXIzD7RQx9tLQ+ZlCWqKC7Ug6HgmGLXfPDDkprYo2sBfSpCtEqpjZgD6TdxJBG6KmNd+7S98RxV1RewAtmVsS8BElN0H2w/idgSdKSyiUvqmnfTqxPecSuxXy5qm6uVOER3rQESCanX1v01cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTjetmL+Nz1ArtMAPTigEQQgPKYd2EwIxBOv8tMB5Zk=;
 b=bpux2l5omtX9tMBDoyaE4iuaDvybNejWZwZuWfIxqJ5Yz6IsJhxWTlsy73jrk2SeDwjTohqsAOtaOIF7v+71Yj0LBcwgv5K7xPe76BBI/U7AJRcH4m02izJWlj6wAf/PhB4rErrnlR3RvglhixlKD3KHsfPYz3xSeWAZ2lcAGDZS6i5zvzj1z8eP0+eS7ELaRuc5o2nKndEhKD6GlgDgPMuKlpiCwI7vw1bW0DGqCFHYbWExURYb8kKjhJ76eJPwNxkgkTZPKCzkWb1kLZi5PKAfMn2HmR+awpfH9OWmVuMQIrCsB4y3WIvVC9BHt0suerJopdAEdQh0+rq6mYcwag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.14; Fri, 18 Feb 2022 10:55:01 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 10:55:01 +0000
Message-ID: <199aebfb-f364-cd9b-5d2b-dbe42b779a41@intel.com>
Date:   Fri, 18 Feb 2022 11:54:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH 2/9] lib/ref_tracker: compact stacktraces before printing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Lucas De Marchi" <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-3-andrzej.hajda@intel.com>
 <CANn89iKgzztLA3y6V+vw3RiyoScC3K=1Z1_gajj8H56wGWDw6A@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CANn89iKgzztLA3y6V+vw3RiyoScC3K=1Z1_gajj8H56wGWDw6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR0502CA0061.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::38) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c17da7c-10e2-4e00-9f3a-08d9f2cd1c4e
X-MS-TrafficTypeDiagnostic: BL0PR11MB3521:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL0PR11MB3521924B00003BC447A1AD18EB379@BL0PR11MB3521.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbDJJxuicHWLr1APmFf+V1AqaIBK+cbuf5ktLJ4kBRu9UptyzKQ1L4rtl/hrlutHLkH1zJkP9OiVwFDvLyAnbHBNoN2u+va/n7GOY2j0nHhZh6VdlNhoWs06QWug/GHOG6V4uGcPvr5v9rJEuleTTiNEW5dqrniftKJFe29p3reLLtLOXSNTAjfBBttQgBtNvP1HQ+Xr14okvIUrkekI3a+3ybsCvUTwoxtjiJmKSyZ//4bkBg7uFqzUGVEnmEKIE/YiRDNLzTH44tsOkhCXjpXTo8AVxbiQx7S/ihmaPMY3u0BaOqw18HDRMEyfz6JIGJUMlJ9ikE/tcmWOyRT2M6qwNhlk4MRGwHdxxPwDxw/dn16of0S+TrsD+VRHpRO2xAx6OIB1lCFvviOILrZLk3YBzYJZi3CyDnAi/3kcDVHh8qYjV3El22YCLFOLSb8w/OcZeigqAkCWUZx/zBm1PLzRkrsi2gNrey0BqygahR2qrKcR/W4YdHX/OzWMxSaf3EMEaLWniNwHYjbPas7K+7QuKg4hFcEJv/hKHJ9EDTV3pFBTFgJZBSaIDAhcKDLSZNSUVlGzC3fA3yuKEqFNZp08q3eRiviu2qV+FsC1nsBV1hpJBsm6FprMno45003kd8WkEBJcQhMrPFPO5I4POv2u+zY9g7sdj7U/KVt9YphBfwOsm1Z7xk9Oa8bTuWhREo81SFYihljiqL8bfFWAlSmQJ5VGF/06HhMPpX5QnfT8OkWvYO3An6qaAWfZVf6p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(36916002)(5660300002)(8936002)(26005)(53546011)(186003)(6512007)(36756003)(6506007)(2616005)(44832011)(31686004)(508600001)(38100700002)(316002)(66556008)(66476007)(31696002)(6916009)(6486002)(86362001)(54906003)(4326008)(8676002)(2906002)(82960400001)(66946007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEFUY1FzWTlBdzUvbEVMaWJoRWUzSE1vaUkrNUEyaDZ5eCtHZnNHM00yd2hQ?=
 =?utf-8?B?QjB1TW84RFpjVzc4TFBOMW51dS9teGpXRmJzTzdFL3I1QklPeTdiaFAyaitW?=
 =?utf-8?B?RGJsanVXaC9QSWgrTThuL29UV3J4aGxsYVR5cUJucTh0MWdZcVdjYTNib0p3?=
 =?utf-8?B?ZjFNYXRMTkhUOVlvZENJYWJsditpS1RzN0oxM04vVXhkeGs3OFlsa2FvMU5S?=
 =?utf-8?B?NEsrV0dCK3BFNW01U3FuOC9vb0F5ekdQcUowak9PL3RGZVhJVmZiTTRNTzBN?=
 =?utf-8?B?UHFERnJEQWM4NTFHdFFYWnhNRGt3V3NYbDhzVTN2alArR3NJcmpuMTNjZkVr?=
 =?utf-8?B?dEFaU2FKcTdsY0w5eFFLVkFlU0FwckdSRjI4UkRCK2xpTENBcENoT0JZWU9i?=
 =?utf-8?B?aXc1TzBuUHkvNnpYbXVmVzhNWXU4aTAvdDh5d0dsMWtva2NwZGc4cXhUekpm?=
 =?utf-8?B?VUUrcHpULytZdGNjTjJZSUkxTDF2RlBUSjZhZGFJZkRnY1pUanl2RlVUNmE4?=
 =?utf-8?B?Mno3ZFdxWlBjd0xzVy9CWmdndEg0SUVTS2NqZjVwcy9LK3dxMGZ2Um1UYU11?=
 =?utf-8?B?UFdESWk0MTVOeTVVNHBuRjFKdlVRNVI4a3ZkdjczMTRlWmN4akViMDBxbE5D?=
 =?utf-8?B?WFhGeGVTS0dueEZBb21VanBJK2hoc2FjOXJKS1JEclpxc1FXMEtydVl6Njhx?=
 =?utf-8?B?NW8vd2UvSjZwUDNlU2llSGo0V0diMHAyTno0OUp1aUVtOXVDYVpwUUk0eCtW?=
 =?utf-8?B?MWRad3VFTTk1ZGhDRzFOVFpZMnlKcy9RYnhwd3d4TzVFRGczQlUwVmdJakYr?=
 =?utf-8?B?aDhqVW4wM1BEV044STRiU2tGaUZuakhaUm0zU0xQMkpwZjJUajIxQXZnZHg1?=
 =?utf-8?B?U0dWUjVtNFhNclFhWVhvcUQ3YXhQUnRJMzJsdkh3dlNQK3R3VTJoNVV2TkFs?=
 =?utf-8?B?SEUyQThrN2ZzZnVUSjNHaXQ5VU9sd2dsZDRUU1FCbkdjQTY3RG1pc2lSeVIy?=
 =?utf-8?B?K0RzOENmWjJSVlBsUVYvNHYxQnAraTRJTXk1NFplbWJGc1I3YlR1V1JLQlZ2?=
 =?utf-8?B?aXpKVVRTekNrdjZwMEIzanc5aG50Mk5QcWtCM2xyWTYwMUNrVkZLMXk3OFdu?=
 =?utf-8?B?UkVPVDVrZHFpTDYwVEtQa2RhK2tuWVFzQnJWK1ZyNU5MTDdOdDhabnNYU2JP?=
 =?utf-8?B?QlNQRVBsSUhyRUhJMXdFVU5VVGIzN3ZFSE5uTU80UUIwTHZVWXI2bTYzMjNG?=
 =?utf-8?B?RmZ4NStUditEOXlVN3BLY1QxTS93UzRTaVRidTI3WHQ4WjBlVmVia0lOcjcv?=
 =?utf-8?B?KzhMVFFobGF0Y3BUS01tdk5xWFRFdGYvdTZ5c3Y4a3Bib0k3ZC96dHJqSW12?=
 =?utf-8?B?Um1HaCtnOUxxTE0ra2VjMExiZ1hEdWNrNDBhYlV3Vy9sT0gxNkRaN2RMbWFh?=
 =?utf-8?B?WFJrZ00xc0xOZVloUEttQW1hMSsvbWxIcm1YYUdyUkwzcXpWQ2s3Z3BvRkFm?=
 =?utf-8?B?ejhRNHdZZmlXMVdMT0JsSmlxU1h6LzhXcUJYYTF1WWRTYk9lRCtHd2dGRDQ4?=
 =?utf-8?B?WVBVaGdNNGxTOG8reFJyZHdVeXY1RGRQYWMzcEUrWTlCVndmbVExR1dVRC9z?=
 =?utf-8?B?OXFWSWxwNUpFOVBWdGhaQnBXNFcvT2hldzRqOHFNOW1JdVVXUkRnanViZXpM?=
 =?utf-8?B?VFdnVzRzeFpwalNXdWllMmppOGRzSmFvVnVpY3hQYjRGY1Y2VDc4a0p0SEM2?=
 =?utf-8?B?MGI5NVI1TmwvRHJ6N2pCbVljQ09KcElYSk95bnF0NlkwT2wrVVpZZ0hBcEdK?=
 =?utf-8?B?TEpXRDU4U1lRbTVNTFpJcTMrMjZZZXRNK2pSSE5tUEJBYTR5UnB3TklkSTA4?=
 =?utf-8?B?YkZ0aWlWR2ZqMENkL1MrV1pjNW5BVDdMOVE3bk5CclFZVFNWd3BKczRwbHQv?=
 =?utf-8?B?NkU2TWZmS3B3S05EbitmZWYwV2ZYL0VLRWRlWmtoeVYzUDU0dkI1eGtyNWtM?=
 =?utf-8?B?OXdqQWZieEQ0Y0tXMDdVUUFwUjBtUDlKZ21wVXR4VS85TVYwV0JLbGN2aDlp?=
 =?utf-8?B?RVVxc1JOT0tEUGV4bkoxY2cvUVlvbCtsc0FWY0M1bW5WZm9SVUhKcjJkSElN?=
 =?utf-8?B?RlBRcGhCaFJBTnZWZVVub2FMSWUyTXdrVjlIZXpKS3dhZUxoYXp5VURXSmw2?=
 =?utf-8?Q?aEl5z8cP4peaa1IAN5wD8TI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c17da7c-10e2-4e00-9f3a-08d9f2cd1c4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:55:00.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyQyktlloNc653YS1yi9jOBh7KOnnQJNj6SMDzI8HkBqekWegnJDS9O+OWO5myKhMkjfAmDGiZHGnfWbSsypDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.02.2022 16:23, Eric Dumazet wrote:
> On Thu, Feb 17, 2022 at 6:05 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> In cases references are taken alternately on multiple exec paths leak
>> report can grow substantially, sorting and grouping leaks by stack_handle
>> allows to compact it.
>>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
>> ---
>>   lib/ref_tracker.c | 35 +++++++++++++++++++++++++++--------
>>   1 file changed, 27 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
>> index 1b0c6d645d64a..0e9c7d2828ccb 100644
>> --- a/lib/ref_tracker.c
>> +++ b/lib/ref_tracker.c
>> @@ -1,5 +1,6 @@
>>   // SPDX-License-Identifier: GPL-2.0-or-later
>>   #include <linux/export.h>
>> +#include <linux/list_sort.h>
>>   #include <linux/ref_tracker.h>
>>   #include <linux/slab.h>
>>   #include <linux/stacktrace.h>
>> @@ -14,23 +15,41 @@ struct ref_tracker {
>>          depot_stack_handle_t    free_stack_handle;
>>   };
>>
>> +static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct list_head *b)
>> +{
>> +       const struct ref_tracker *ta = list_entry(a, const struct ref_tracker, head);
>> +       const struct ref_tracker *tb = list_entry(b, const struct ref_tracker, head);
>> +
>> +       return ta->alloc_stack_handle - tb->alloc_stack_handle;
>> +}
>> +
>>   void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>>                             unsigned int display_limit)
>>   {
>> +       unsigned int i = 0, count = 0;
>>          struct ref_tracker *tracker;
>> -       unsigned int i = 0;
>> +       depot_stack_handle_t stack;
>>
>>          lockdep_assert_held(&dir->lock);
>>
>> +       if (list_empty(&dir->list))
>> +               return;
>> +
>> +       list_sort(NULL, &dir->list, ref_tracker_cmp);
> What is going to be the cost of sorting a list with 1,000,000 items in it ?

Do we really have such cases?


>
> I just want to make sure we do not trade printing at most ~10 references
> (from netdev_wait_allrefs()) to a soft lockup :/ with no useful info
> if something went terribly wrong.
>
> I suggest that you do not sort a potential big list, and instead
> attempt to allocate an array of @display_limits 'struct stack_counts'
>
> I suspect @display_limits will always be kept to a reasonable value
> (less than 100 ?)

I though rather about 16 :)
In theory everything is possible, but do we have real case examples 
which could lead to 100 stack traces?
Maybe some frameworks used by multiple consumers (drivers) ???

>
> struct stack_counts {
>      depot_stack_handle_t stack_handle;
>      unsigned int count;
> }
>
> Then, iterating the list and update the array (that you can keep
> sorted by ->stack_handle)
>
> Then after iterating, print the (at_most) @display_limits handles
> found in the temp array.

OK, could be faster and less invasive.
Other solution would be keeping the array in dir and update in every 
tracker alloc/free, this way we avoid iteration over potentially big 
list, but it would cost memory and since printing is rather rare I am 
not sure if it is worth.

I will try your proposition.

Regards
Andrzej

>
>> +
>>          list_for_each_entry(tracker, &dir->list, head) {
>> -               if (i < display_limit) {
>> -                       pr_err("leaked reference.\n");
>> -                       if (tracker->alloc_stack_handle)
>> -                               stack_depot_print(tracker->alloc_stack_handle);
>> -                       i++;
>> -               } else {
>> +               if (i++ >= display_limit)
>>                          break;
>> -               }
>> +               if (!count++)
>> +                       stack = tracker->alloc_stack_handle;
>> +               if (stack == tracker->alloc_stack_handle &&
>> +                   !list_is_last(&tracker->head, &dir->list))
>> +                       continue;
>> +
>> +               pr_err("leaked %d references.\n", count);
>> +               if (stack)
>> +                       stack_depot_print(stack);
>> +               count = 0;
>>          }
>>   }
>>   EXPORT_SYMBOL(__ref_tracker_dir_print);
>> --
>> 2.25.1
>>

