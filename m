Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C703AAEE0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhFQIhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 04:37:06 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:43972 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhFQIhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 04:37:05 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15H8XtZn015730;
        Thu, 17 Jun 2021 01:33:55 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 397sbmgbtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 01:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hfo0t/sdSSmSM5WUqTnd7jjaNUioQNJ5wQjqyDRvSAWXL+S2JuoOlphTUBRYZM08YTqPc+aGmCiCk7LPGL87h6pmJVIYETVnq0Hs2BzwkyxrDMP7euoyLuh2eHexS4qI9AUokBnVTCc+d4G+eD+lLdaqkOAObgACWFhicKAg2yPQfNDo4EnoL3o3h2uFRK6DDZBm9SsqJCO5kMzaRYRi1JtvaKrlQQJRQlUTErW35Crnf7T6OlWiIMgA6avApFH7p3IAPw9einYOIDWFU7tWjsF24N/EgM3Fnf07DxymxgclX56y5zKdJrVYT8f0Mm+lg7QhQKJXYjTkC01x8rCk/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQIH4RnxcDEWAifN50ekH8nw9gtzI43t9tCF7NHgR20=;
 b=LaU6rVVfx9V1fCjwPrpj185edBiGuHeoJT2PjADOtntpAt8VWUjYkGiMGE1SSvTlOmjDTtyY7YJITr1bqLhNvkp3G7APgXLFufm6Zjt6gSnUbCVORfaEmKd0h0tgGSLqQ64iFs7hfarZTZF/VuXDGrQJ98E+ECEO7EAtFagIRc0tZpzbLg0I7a69LW6fsC+mJsg+PoEUWRNSmO/ub/UQvixszwbTTTAr1cwET2AoGHz+baXw8hWrKR5caYsYGHPclb646eMrMCiJtCxphGiNTROoVtyAMyZo9oqfVI6SN2anf919pjSDJ2ozNnam3siPmwssNEPDs/LK9qYKSnbHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQIH4RnxcDEWAifN50ekH8nw9gtzI43t9tCF7NHgR20=;
 b=btm53/y7VvX8ddQqAMJCLatb+lxAG2F0WxrIRUG+LV8SrFbetRfKSUSBuEutbK5V1x/AK8t+KIQNPUgN+oE59gsAlT7+GZsPz1JgAxWIu3wRf7xzWGKq5JkJeOOxZAsPr5jcEcKcb07t95swLV15v2+13EB3oEEeHMnhQldMzxo=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=windriver.com;
Received: from MWHPR1101MB2351.namprd11.prod.outlook.com
 (2603:10b6:300:74::18) by MWHPR11MB1743.namprd11.prod.outlook.com
 (2603:10b6:300:114::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Thu, 17 Jun
 2021 08:33:50 +0000
Received: from MWHPR1101MB2351.namprd11.prod.outlook.com
 ([fe80::c5c:9f78:ea96:40e2]) by MWHPR1101MB2351.namprd11.prod.outlook.com
 ([fe80::c5c:9f78:ea96:40e2%10]) with mapi id 15.20.4219.026; Thu, 17 Jun 2021
 08:33:50 +0000
Subject: Re: [PATCH v8 03/10] eventfd: Increase the recursion depth of
 eventfd_signal()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        He Zhe <Zhe.He@windriver.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-4-xieyongji@bytedance.com>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <8aeac914-7602-7323-31bd-71015a26f74c@windriver.com>
Date:   Thu, 17 Jun 2021 16:33:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210615141331.407-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: BYAPR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:40::14) To MWHPR1101MB2351.namprd11.prod.outlook.com
 (2603:10b6:300:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.175] (60.247.85.82) by BYAPR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Thu, 17 Jun 2021 08:33:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b7a1221-56f0-40fc-3276-08d9316aa1cd
X-MS-TrafficTypeDiagnostic: MWHPR11MB1743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17430D16EAE2B19BAC7F4DC18F0E9@MWHPR11MB1743.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzrjIpuQNP3Y7IcJSect/ohk2Mnc3+1E2aqQDYI36pZ3FiUvylaysGx5xAhYhRe4tpZoM9pyhC5V3R/4f+aAgjgii5VF6mo4l0BBS74sCNYu3TNqn4BQ4LQAqEqbKa6GAW/VSACL1NI5K3QrdRITKyE1RxJ6YJCDWfmmSA+NySm8afePpkqddI36bQ7uE2krj/1UXdxAgIfjajCk+0fFCP+ourBcpuTMJhN6VFPlNI+O7MZ8U3bzqqIthmrNexpexpERECJcYS/w2eUavKlh25AdU6bWNAHvjcjuhWddIBLzgeJ5DMjYdcFQud7wkm7ZeTXMdhSV3PXiQFdIZw+rAD8pHt+Drsp9XTMkN33T5+HGVnRwYmRxtwRRRPPFD6V9rvqzZUlaCosRkTTxEkUn0UybdHt+j4s9/d5Wtcbk+y9ftsmk1g2SgFYp+UqU8gDv3xYKubZ1QvO8BkGuBwWw6uHQg3pH8XdBx2G/TqmqO7cUDFKN/YdPYK+CCexQf50ElOvNaDsL3hSdRVvECnTVX7KDcG5qE94aTI4mdtlSyYp/5X2xeEbYtgNxho5gBcJ0goF56ViM+xI/sIrslfjjoju1EJn1nftshyIcNLHPgVDkXE0MlrLHbFKrnlHUUOsATzsuqIUqwrkaRduamSuknw/mkg/uem46g33gMLZA6DawCdbu+XyJ5g6WgpkNTXKQd359h8mnwSrBUk7UyAXRzedOaJxuu7y/rck5RKf8flzbkK0oeYkelfJarCMDEjFcHjRmtzYXZKJ26kpxT63o3xHCpFZWu3jpUNCpoKn/XApVB39Agss8gAdDkQOOm+XHPrHuOr/qB6YFzwY1mIuQ8ffjC5i7Hy3/RhKpSyPWF/EHOgy9T2ew9uXjZyQCdBxR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2351.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(346002)(376002)(83380400001)(6486002)(38350700002)(38100700002)(53546011)(66556008)(8676002)(31696002)(7416002)(52116002)(478600001)(2906002)(8936002)(966005)(316002)(16526019)(5660300002)(66946007)(66476007)(16576012)(107886003)(4326008)(921005)(956004)(86362001)(6706004)(2616005)(31686004)(6666004)(26005)(186003)(36756003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkYzOFV2OTZXeHJzNkVBVmFTRkQwRG41K1F1S2V6dGlYSGwvcm52eEJhVU0w?=
 =?utf-8?B?N1BJd0RnKysyQ1pOQWxsWXZUVThTenZ2b1pWUWprL3U0Rm9vcU8zM1FiUHoz?=
 =?utf-8?B?VGZPemUyc2JlZGNWYWZPdDU5YTR4WFFWSEVKQU02SmcrWkhhU3VwOURDbklI?=
 =?utf-8?B?QWxTYzZEbFE5VTQ3aHc5TDhYNFRKY3ZBQmRuazNyV2lHbGxFb2ZEb3BlUERw?=
 =?utf-8?B?ekRyaFZoR3BGNEIzR0JDUThoSFI4T1lhUHJ3dGlzY05UZytIczVKcWQ3V2Jt?=
 =?utf-8?B?eDJKTnpKQWdyRzVwNU1EK05DbHY4aG1KeGFZbjNzSElzRFB0NGxyeGRNZmhl?=
 =?utf-8?B?RjRyUjlzWFRZZitGOFdWdVV3Vk1hMDhRMGdOdXlmSHYxM1huUytVWG1FZkNZ?=
 =?utf-8?B?Q3FYRk1VQjJTKzllenBVTUQ5VnJsS0ZtVGkxVi9LbWtIOHpZUUR3L3FrTGUr?=
 =?utf-8?B?S2wwZ0xlbm53ZXpiU3IrWHR0Wm9PbEdRVkM3a3dmb1hQRFRkUml4UTVMSSts?=
 =?utf-8?B?bk1UVTBTU2I3V0IzeDIvck83NGd3cHNZTmtDSHNwNW9JMHl6cTdoT2pBdWlQ?=
 =?utf-8?B?V2dSbU16d2VNSThrN1c2YzVxQzJ4d3dSRmFScTZzTSs5Y29WTWs0SVF4eEdB?=
 =?utf-8?B?amxWaW4xMVJRcHR1T0VyZ1dtT1MzZDdkeWViclkxeUNGRVZ1RGYwMS9pWWZo?=
 =?utf-8?B?clVISmxmRlNlM0gzcjhLd3d2Vm9YVm5mUGdRRWUvWDBCNzNDd05tdFZBdlJr?=
 =?utf-8?B?M2ozN1M5Rit5TVlOZ3ZsTFk5Q3I4L1NROEN3dzU0ZEdHMjNkTDd0empzRzdG?=
 =?utf-8?B?Y2lXWXpSenI4R2tPaEdRZWVVSW5XZ3N2Z3JXL01GWEg2azNKTTZTbXoyc3Ny?=
 =?utf-8?B?RldhNmRUYUFuQUs1OFlMc3FPV0VabGdueTIvSU5uSjNYVnc2LzN1TDFVMktn?=
 =?utf-8?B?RnNqa0xCZTlEYzM1T00vR3hUTnYzaTFmMzdSOG0vaVk0bFVDNldKOUo4cHRE?=
 =?utf-8?B?YmtHblk1cEpyWjR5Zm1CTWtmNHl5MVpGWklmcmd4TC9wMnRLU01sVUx2ZzlG?=
 =?utf-8?B?aktvVVVnQ2FROHNuVUhNTXRaaURwTjY3c3MvT3pMd1F3bHRETFBTUFFPdG00?=
 =?utf-8?B?M0ZwMkUyb0FmWU0zdlZtUzVwMlNqYy80ejQ1MUJmY2dCV0xHNUFYaDNZZjUy?=
 =?utf-8?B?L0dLc0dTZW1oc0dpYSs4YjEyZERZV0RyNGExR3FLaWZtdzNwUUtTdWx3bzhL?=
 =?utf-8?B?c0NJY3BKaGh1aEFTamJ1TE1RcmRZYkVrbUxwekxJbHF5ZFJKRHVUVmhIU1B1?=
 =?utf-8?B?dE05SlMvMy9KZ2l6S0x5VHpaWk1oZWtnZGppQ1NUbmxlaG4vVGFkY3BweXZO?=
 =?utf-8?B?UjVFeHE1K2lBOXcyQnQ4Wi9vdzJlOEgzWVlmK2dPVEthOGxUKzJiMFExaXFV?=
 =?utf-8?B?YVB5MGRiRFA5SHBVSW5YZEFRcnFzTGhtcHpVQ2J6SUI3RUUzaFZyS3ZPR1R6?=
 =?utf-8?B?YUc5K2liOWZpczA3ZUk2VG41dU1lYkJ6QzhSeVJiOXYzR3FRTjN4SW9taTJ0?=
 =?utf-8?B?b1JCcGR6a2Yzb0puTWg2NHpYNDlPSUVXSDAvQURCdHdNV2x0elhaYUFNL0FV?=
 =?utf-8?B?elN4VG9wSUhTeTVzc3ZIckFLdWNDWHhkcWl0TlNQMkNvSkFjdmpQRFNxUXo0?=
 =?utf-8?B?cm1wdUVmUGpWb2M5UUIxd3lmM0llSFVYelFyN3diYWNkM2JqcEJwS1l4bFJv?=
 =?utf-8?Q?ppCBtUK8YSeKR1T9ze3qEd8Rdd2Qw1kJK7B0Mzk?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7a1221-56f0-40fc-3276-08d9316aa1cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2351.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 08:33:50.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkE1xQyYga1nOu/B54fDA+LtCc41/ZXOKujN2Co7y+3ro7RA92FU2jt8GqKQTt64caZaUa6CcDvGBjyfj/nNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1743
X-Proofpoint-GUID: VrqGYeW4YzfhASZIlwQwfty2ef2XwwgG
X-Proofpoint-ORIG-GUID: VrqGYeW4YzfhASZIlwQwfty2ef2XwwgG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_05:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106170059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/21 10:13 PM, Xie Yongji wrote:
> Increase the recursion depth of eventfd_signal() to 1. This
> is the maximum recursion depth we have found so far, which
> can be triggered with the following call chain:
>
>     kvm_io_bus_write                        [kvm]
>       --> ioeventfd_write                   [kvm]
>         --> eventfd_signal                  [eventfd]
>           --> vhost_poll_wakeup             [vhost]
>             --> vduse_vdpa_kick_vq          [vduse]
>               --> eventfd_signal            [eventfd]
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

The fix had been posted one year ago.

https://lore.kernel.org/lkml/20200410114720.24838-1-zhe.he@windriver.com/


> ---
>  fs/eventfd.c            | 2 +-
>  include/linux/eventfd.h | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index e265b6dd4f34..cc7cd1dbedd3 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>  	 * it returns true, the eventfd_signal() call should be deferred to a
>  	 * safe context.
>  	 */
> -	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
> +	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
>  		return 0;
>  
>  	spin_lock_irqsave(&ctx->wqh.lock, flags);
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index fa0a524baed0..886d99cd38ef 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -29,6 +29,9 @@
>  #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>  #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>  
> +/* Maximum recursion depth */
> +#define EFD_WAKE_DEPTH 1
> +
>  struct eventfd_ctx;
>  struct file;
>  
> @@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
>  
>  static inline bool eventfd_signal_count(void)
>  {
> -	return this_cpu_read(eventfd_wake_count);
> +	return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;

count is just count. How deep is acceptable should be put
where eventfd_signal_count is called.


Zhe

>  }
>  
>  #else /* CONFIG_EVENTFD */

