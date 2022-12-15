Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF264E3C0
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 23:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiLOWWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 17:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOWWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 17:22:42 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5831958BC1;
        Thu, 15 Dec 2022 14:22:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQOc0LMSouekPW3WWS6TOEl6QI16N4EOS3nqETT0xIwgpS/8Hi72PLFlWHbjqFZ0DEGGbhmUR5dg0WDtEH83kVaHpMkNahWi4IYGFMOSQOqQUY5Um9X6I1UsXbYbhO+FVU7johJl8XKXndA+4mu2wyxmiQefI6znzxIGHqQeL4aeKS2A6h0bH8hzBfBiCNOY+E7KW5rhDU2LHOM9DXyTcMUUtdfNQYA51wjIo//CYf82MTdEKuem1bVilHlvv6CC7/U/0K2WEtK+e/GiJI2duoTJEyx2mhr+PbL0+Et4zxXQ8E56DBEvF9/TYVC1y31RBlSe4gTzjtvwMRgH4FpuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYIqzuOZNsC5kl1HH17PC0c7Ca6YNTUcJKu18nA4nnI=;
 b=K8CAzXfCm83DwDjzSygaCuXKSUs8orsdXybCD7K99iJC/HhqlHMxqZ8lI+mWvzRKJn7VMImAj7Zo1XUNHCBKVmTL0V3PhlRXuqm0FiQ6lnEtl4PYCh+Se/QlLosPM1aDivCnWF3cxQH3XEPgQQhLQsQTvHpG3rHRiNaxAg5VujynRodtH+qHYoZmBXn2lWH4y7QG4Ss252OFq98Wtih/A+oui54u1TH3xoJI9tjOsFZjPeyBLDtN3a0mpVgWkZXQXLXMenYUQ4rvB1U2vM2coBCxuKG0SJ4iViWG2fuPO7lqDrkQdChKt/m4Svn2Cfi5PFgJUkoLT1utLTkHA7h5qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYIqzuOZNsC5kl1HH17PC0c7Ca6YNTUcJKu18nA4nnI=;
 b=cHhryBpEJ7AJ3/h2YVIInQ7wCl0/8fHxaC7jFtwzDHPe4qMUUQKHaaEQL/7LTxOvk0Fnmjo/LwY7PGlAkvs4FbyZe+3Bkizjtl9UTD97uVUcNY8blWtQCwur1QbhVooxtKDu8bbD7SZKSqkicUV8/rs+GdHoiYzM/z9T5ha8Bwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by IA1PR12MB8078.namprd12.prod.outlook.com (2603:10b6:208:3f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 22:22:37 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 22:22:37 +0000
Message-ID: <4438c3bc-0bb2-becb-48ad-4e85f79f240f@amd.com>
Date:   Thu, 15 Dec 2022 14:22:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH v2 vfio 0/7] pds vfio driver
To:     Christoph Hellwig <hch@infradead.org>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20221214232136.64220-1-brett.creeley@amd.com>
 <Y5rE26OcSnoZbqzn@infradead.org>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <Y5rE26OcSnoZbqzn@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:303:2a::24) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|IA1PR12MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ebb910-cdac-4543-fdf3-08dadeeadf27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GKKbpjSQRrDbTGhyypOqeT1jHkQw2CKy/QgxMz2UT+WIg72NZ5B/YQUk8DTuvcRjofVw5WoFTtHt+sMp09MgJfgbeLAs5rjW36+AziKliCf8Ir+ofNasNRG4DuCY91qWQYhc5PEyvDXk9QPDC+DmO3KEZbUrGQL2N3bUDKSnoLF371E29yQ52PTh5g40Wha0U1SBseXurS3hScFPF08b9bnhKiPEtM5lUzntWSgxqb7kKmbSfNbQhR/lDAYUDi1LxDD2+y03U9PjnE9YMSV3su4RRAzTvSgJ1F9KKShGkaDTsui9Ih13JpbIycKZPi2MujiNvIVqkpzTjDebjJwy38sefHV1pE6d0cVgmqhlSLRSF/osAgVEyMP1Ahen5AD02QaFCxuowdV2Tl2HqQ1iAeCVvYJCndXPd21xkZwWY2T7Flcy1CAKxFvBdbE9ZtkQhwVjWszBP92uQc6eaPiNJribe8xpX7crsge2owzNeJnbmdBAECQoyvg3cQiC4Q2yzVL/iRzKIJBQtfCTlrC2EE6bZkH4T4o7ElnKg6QCQ7gw5im1alMCwFDqKva6WwUPVIHhSIkk3osRLapkUP4t0MMrPTkJpYymsUyRJZvfr7l3IZDKoqNmYEJHAn4+ngHc5Yr9bKcLAF2Lv4PTiV5sTH6FLmuDs1M4T9c0E0Rrc23kCG2lvoqMM5BmW/RK1bmSEAJrVbIjHUski304QqepJ9WGvMrXyq0SMuacMDqK/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(2616005)(6512007)(53546011)(38100700002)(6506007)(36756003)(186003)(6486002)(478600001)(31686004)(26005)(8936002)(41300700001)(316002)(110136005)(6636002)(2906002)(66946007)(66556008)(8676002)(66476007)(7416002)(4326008)(31696002)(5660300002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2ZMZDZiM053NHpWVit0VENEQkZpK2ZURDRxeU9zTXBYQW52anlQQzdQVEMw?=
 =?utf-8?B?VHhkdUtOZDZZdC9OTnYrUGcvdjEyKzBndEQ0aGNWZ2lQampYQXcvK2RPQTlw?=
 =?utf-8?B?cGpmLzZ5eGVNSFZiMEtycVl2UndsRWRLd2tGeityV201ZUs0L3o3SkgvVkIr?=
 =?utf-8?B?WDJNaEN6S1EwcGxWZlFJWmdDaFJmRkdnZ2pwZWN3Q0xlT2VzRVR3S2FUL3ZI?=
 =?utf-8?B?enVFdGYwN3FjM0tXVCs4VlFpZG9NRGcwSTQ2SzNQVUxOOEk5V3NXU1NIUFZ6?=
 =?utf-8?B?UVkrVXAyWllYdjVueDlKQXNwZGhraGpVMGZ6bUZQZGxueEwydVlSR3lOKzdJ?=
 =?utf-8?B?M1RPdkhieDFEVEVjOTRoUTl0cWg3S1pOVjFpZnhhOWIrTFlINTFhZ000cjlZ?=
 =?utf-8?B?SEhoVlZDNDVxc2Z2VU1mSGoweUV1VkhvMUxRZ2p3RUdqZHNrZ0JTTXE3d0hB?=
 =?utf-8?B?VmpkMHJWUXViMUhOeHdmVE9JaSs1dXczUUc5L05OVTRLVmc1dmM2NTZvdDIv?=
 =?utf-8?B?Q0hKTkNLMlZTcmZpbnZKQnZQeGdTMGdKaGtZUXhrU04wbENBMzdaMm5BWGI2?=
 =?utf-8?B?WkZzNVltcCtYYzRHSEY1L1Bpa3JMdnRiNjVZT1JKQ1JPcHRjLzdyZEVWUC96?=
 =?utf-8?B?bHltalhqMjk3ZU9iNkpPTFJlWlRvNGU2aEQxTXRDYXFSdVZRZWowQmk0MUww?=
 =?utf-8?B?OTI3SEpRekMrZVRyQkZ2SEZIMDlmcW14MmRDR25YZ3BpSVAxMVlsUzNYTEhS?=
 =?utf-8?B?dm5Zb0pkdHVxSnU1eDh5TENhbUVrLzJQakxOQTg0Ly9yeTc4QThvYjdjaVd2?=
 =?utf-8?B?NkIzR1NiT09xR3Arbml6RFM3QXJPeWRGb3NSbFNqall0YzFRUUFud3JNUGVD?=
 =?utf-8?B?bkxIY2lqdVgzN2lPb0FKSndjSklEREpiQXNUUVN1YWF2dkI3a29ONXkyRW5C?=
 =?utf-8?B?Q1RHVHVpSENNdjd3aDZlN3F3cXJ2UmZnbGdHT1FqZmVhSm9VREJHeEZqaXlq?=
 =?utf-8?B?dDRhcUx5YzVXOUxKQzFEamlOZ3ZOWkxBY0tvTEJ4aGQrRlhmd1p0bU9ka05T?=
 =?utf-8?B?T1BaOUVhUjVFMEZVVDJHc3EyL0hPYUNYeVJqNUtqeEJRYitCUy9GWGhDaGN1?=
 =?utf-8?B?cGpNZXdKWlc0V2E1UUlaVVNpV1dnUnZiTzE0T3FnMWhRRmtmTU1HVm9HTHow?=
 =?utf-8?B?UHVyMUd3U3JpamttSm9iZ0U2ZmEyOFZKR3JtR1p2VHdDVEk0OEpkL29ldVJK?=
 =?utf-8?B?bmNEZ3NyelhaSFVrV3plcmZ0YzFXODlGQ3ExQ2Zhck5rT3hFY1VWWWpESkNh?=
 =?utf-8?B?ekNNTnlyUlgrTllqTCttRVRWN0lYd1FMUFR6QWlSZlp6WmJXc1FBUkRHSmNV?=
 =?utf-8?B?alZsWXZ2RnJNOHpQVS9DMkFCbys3S0RPN0kyZ2c1OVN1QjdpYkRkT3I3VGk4?=
 =?utf-8?B?Tnk0R0dJcHJ0dENlM3J4bWxSQVN4RkQ5andrNlVndXlPNlNacmsraWkxS3Qx?=
 =?utf-8?B?YWVQa1dBRy9WZWxXUitPR2RVOTA3Y2YxQ0tqRnZia1l5UDFwUnphb0FFSllM?=
 =?utf-8?B?Q2ZJT3RiUlN4VWtnWFU3L2J0OEhlRGFkTU4wK052Y1ROOHRMQXk4NFlod2xr?=
 =?utf-8?B?R2tyems3QlZwY0lYbVZKRWQ3WENJeGhDOUdDR1ZhVmRRRy80d0xvRldLMjRh?=
 =?utf-8?B?dGZqT0xpc0xuRVNTbXNkUnJTd0c5K0Rud29lSlJhWTh0OGNaazVXK3cyMThU?=
 =?utf-8?B?c2d3eHpkY1kvMUV5cUVaeFJzdXdsQ3FJamdZRDErRGx3a2xjWTRLRTkwRC9X?=
 =?utf-8?B?cEdEWkVGR0xEL2wyczZTYllWYVl5Y2V1WUN0eFlTcU1yc0ZuZlZ0eVdPN0Zi?=
 =?utf-8?B?RnBndkUvc3FhVDhxZ09aZGg5ZmJKZ2ZkOTlRUU1ZRWV0TklmL1M0VzdMSDBX?=
 =?utf-8?B?TE01RHdOR3FBcEVaeitKMEdkRkdOZFNnOU55S0tONXpWVGs3ODFnUmdoZ2VT?=
 =?utf-8?B?QWdmTHQrVnhkRzRRVE9HOTZJUGVxT2JEa2ZUWEN0amVZNjlUZ1doVUlDRkFH?=
 =?utf-8?B?WngyaHQ4bDZBQTVSazN1YTRza2JGMVF4SG52eWxTK0k1Tk92WEduZzEycVFK?=
 =?utf-8?Q?+Hqpp0nGhprS3ZatvrA1eNFS4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ebb910-cdac-4543-fdf3-08dadeeadf27
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 22:22:37.5406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4qYmecQCnLaBppt4CwYxIL5vMCu0z5bqza1D1+EodySFp9+tcb1xgvbREw680gkR3RttRVn3pNHwdLcTQS+bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8078
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2022 10:55 PM, Christoph Hellwig wrote:
> just as said last time and completely ignored by you:  any nvme live
> migration needs to be standardized in the NVMe technical working group
> before it can be merged in Linux.

Hey Christoph,

I'm not trying to ignore you and that's why this series is still marked 
RFC. I appreciate the feedback, regardless of the end result.

I am paying attention to the other thread on the KVM mailing list and do 
understand your stance on the topic.

Thanks,

Brett
