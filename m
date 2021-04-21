Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6E3665C4
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhDUG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:58:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229536AbhDUG65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:58:57 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13L6qqvx021860;
        Tue, 20 Apr 2021 23:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6bsHqEkrq01yc++zvSxROgOCclTwvZIo7q34uov9pms=;
 b=bp7DKU5xnxdnOHPAMgAwzFLYD2gn1BLx54hY0AJ4w1i3y9dROUHLX5WdcrPWy9yTWqGX
 TroUWOJ6GqfsKkbvexYFc6msmQWfe9UUG2YzUK22DGcQaeQuio7u92s+aow6O+LBcsMn
 /C0A3DoBqAmfVPKuQkqgrR08dxEOCMaFM0A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 38270dt2h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 23:58:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 23:58:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyOPJd6+LELqhTgE06Wl8PegER8mreu793rdze/vgWTtsSPNO/CWLkxIJZt9eKQnWuAx0UmuRe31jp0zAbHpts7CKgPoAgQwadfrduRyjboRZBf3z/KAgyGrAq9oiQza+h5HPe2sreaDVEdKSwBgzV1Jc6vQa2JTEz+wpfhMihN6mTSKQvfGpNdhS8+PjrGVqXLG0io+kS93z7n0MLUf1qyMp7tOB56A25wILreXao7Qr6BjWuis7PktPkZg/e97TSPQvpBGTFtIUGHiXI5CKNu0AoMqXj+E90vX0twSYC9kyheZqgmSjDFx2xgZfHW/xu9WTYa4DjWfGSzh/Ku8Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bsHqEkrq01yc++zvSxROgOCclTwvZIo7q34uov9pms=;
 b=cp5FdLykkUeWHwGxqa9rLJp5y9x789waYNeT6V46KXSLqgg/2hV+260SZL2LOZ23RutuByQm4F/VOhMV5PAZtPmH5rbsrYBT+4b5nEQN4Xkl4ckdS6exWbXLuv1wzkQ3oVeU5S1wP2ItwmTTN6H7cW7hAGkAoYAU6xHeJq0JKUyeMstEccQcM2LRvIPMsi6nvGtJpeiHoEWoQpJX2Huu7emFxTrIcpzroed7a7lBDSEHkobSqCtOeCF7njunwaCqJ43XB0n6L4ey9Ob6fO+bmmJy6kw79+oB+elaK71mipwmy4g1uswlxQJJClMX6WtOMnwvskX+jk5K+YBjzPviWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4904.namprd15.prod.outlook.com (2603:10b6:806:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 06:58:05 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 06:58:05 +0000
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <27b90b27-ce90-7b2c-23be-24cbc0781fbe@fb.com>
Date:   Tue, 20 Apr 2021 23:58:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210420193740.124285-3-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:d87c]
X-ClientProxiedBy: CO2PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:104:2::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::137a] (2620:10d:c090:400::5:d87c) by CO2PR18CA0049.namprd18.prod.outlook.com (2603:10b6:104:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 21 Apr 2021 06:58:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60924d05-0f73-4b19-d15e-08d90492d02d
X-MS-TrafficTypeDiagnostic: SA1PR15MB4904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49047A12DECCE023057E7ADCD3479@SA1PR15MB4904.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvfYyciF8T3jXzgkgM0cjmN2KpCh9R/NFwkEg2UPwgcylxbQr68TTKHFnxfkJ2ZF5VlVDA3DhJUovUEFCzW/yR7dyNp7HTJl2mJ3OTZhCVWGQsDvyuLB2howLFvK9xuRLfK8NIdHPI2p+XU0/EXU4EIq/AzjY3+/xhWIYXiPIjYZHfaYKDZ5WMRDz03/jmU81iOLckyeZD1Ikmi0+1LRxNUYHCXJfwqRBU38QsysQDymSBt3PPmZKX36e3RpsxSBtPJjEkf9QO66iRFwpskWZ3+98eU/VbpfQBXs4FOIVMDOWjl+MhR1e/AycjmDj4/c4guzgZlixaoZjgbxQ0SqdQzMXDDL1oVdpiwldw7uoQV4RG/fRFMHN511BZ/4nKy55NJ4iGAksWPtE6a2mTYfeq7wqafgodpJKZ0VttjW5MgXS338HufVYRuF0lbiwoh1LTOjwFy4d9+VSd2AvUDXz8EcB0rKOTgXaWSeIK5JTLOJ16sMZYL5xeZgyyO/Vdn/f1to+1lH4VokKM5GMOtUg0UbFo9LfFXcyeP6OaPLyP31vrSF/GP8f+zSyG0mGmUZkWeE2QMImx1vbm9tmkvQDZbMxMI1SEbGFr+WPhxKpg/hotKItS4jwqkhn06/21SmUzprnuz8/fAFqk+yo2Hc7KAUNxVgE2jo41M5h1x8G5hR/dP04S2mO4UnkoEzt/Rd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(5660300002)(38100700002)(86362001)(31696002)(2906002)(16526019)(6666004)(8676002)(186003)(83380400001)(4326008)(66556008)(66476007)(31686004)(54906003)(6486002)(7416002)(66946007)(53546011)(498600001)(8936002)(52116002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c2ljQ1FVQzhoeTQ4eDczdXZiRWpLOGttbzdQZldZL1FKMkdpUW1HV1orZ0hZ?=
 =?utf-8?B?Sk9iRzRhM1FkKzRtMldVZnF1bmsvdzF3aDVjdDNlVlI0OHVWNldMZnZNdVUy?=
 =?utf-8?B?ZDduMmR6MW5ERC9TM0ZMdmtxRWZUVFJ2SnhNbnV2YWJPMDRoSDk0Um1TVzdy?=
 =?utf-8?B?UFhkTzZWak9MWHBtbHZHYWdMRGRDRWhkRDA0UGhZcTJ3dEpzcGc2bWlCaSsy?=
 =?utf-8?B?cjNNbUp6Njdid0JiU1Z6QkU1dEczT0c5OVQ0ZUh1T3JPdnlxMHI4dXhWTkF0?=
 =?utf-8?B?Y0hWTHZQbHZsTmVjMjlZV3FxeTRXRzN5Vm5OMEQ0K1R4cXpoRExHdmxhRXdt?=
 =?utf-8?B?M2IzZURXazhkeVVpbE81dkx1TFRFOFZqZ3NPemhkcGNlRUFHdDF4cGpKeXNI?=
 =?utf-8?B?dGdJWVd6TEZFQU0yN2xsYkdreDFUaHJUUC9GQm5PV25YN2Q5d2ZvcDJYQ2g3?=
 =?utf-8?B?cWtsZkhkdDUzS2lJZXNqVmRYbGFXbElSK0NkN0E3eVl4amE1b2w1bTIvbzgx?=
 =?utf-8?B?YXNTWVBUYStWS1liL3pJOU4wZnU3Y0UvYXExWkg2MGY3MFNhWWZ6WS9IZjFn?=
 =?utf-8?B?cTJNTlZQZkFMNXEvL2xUeEZBVStWR0lsMTZidzRXY1VlajZmdCtGMFg1ekF2?=
 =?utf-8?B?VjU1UExmcUJQNTlRSGtaTkVFZnJkTVFpSWhyT3ZEeU9JMXlrdUxXWXFaY1NH?=
 =?utf-8?B?ZzRZRkFFVFRWYmlZSXJ5WmRTK0lXM0Z2ZUlUZ3l0ZE5FbElQdlpMQUpncDJN?=
 =?utf-8?B?c0tZdkdxbjlYZjlTYnVueXN2Wjk4OWxRcXZtT0RmNFE3S2ZlZ0VmWFR6QXNp?=
 =?utf-8?B?eVA4dXVINUorbVZZVTdVZ1E3TEE1ZmtzS2grdGpqOHl6elFkUHd1ckZhNkNW?=
 =?utf-8?B?T1Q2cHo0ZHRSOXJuNlJlZUFnTnY0dGNsUCtqVUpCVkd3eWRDUzBiVDM0VFZo?=
 =?utf-8?B?eG1wRjNPOEVLeHRUL0RLTFFCUkxlT2Q0TUxLeW1PanFvNGtSTVBaeWdUZjd0?=
 =?utf-8?B?WC9kUk90dXFPYjhPMFBTMVlmeUZoQ21rVkE3VTBnOWxscXl2UVlZcnlTbFlG?=
 =?utf-8?B?WUxTZHA1WHJMeDJoeXgyeWpraUR6RU1Ray80MjYySkhUaUJMRnFLMU4rNmMw?=
 =?utf-8?B?aitFRGFIbXFFUVBjeEloamRIempFUVdselZ5V2daNmNjYUJnWWloWUFPY0l5?=
 =?utf-8?B?RGdERWJxdjh6eUsvbWVZTVhyVkE2bEFmaVVYbzR2MzRWdVAyV1I0SCthTTA3?=
 =?utf-8?B?QzZJeVMya3pPNmhySkZJU05yTGV2RndPYSsreUhodEpRNkZGRjJieFJ0VzFP?=
 =?utf-8?B?UXRnTXR2L0Zod2FzV2dRSWkwQW9ZNGxRRXNBVTFwRVl1c29qcGpyczNnSHN5?=
 =?utf-8?B?SmN6WmUzTFVTaWdOK2w2SG5LdHU1QitqKzRIZHN6Tjg2N0Q1TWRUN3I1aG41?=
 =?utf-8?B?ZzhJcmVpS1J2c1ZYMW8waXRTQzRtNVJxRDVldDhoWStrdXlrUHl0VHo5cHNK?=
 =?utf-8?B?Skp3bGh4SFo4Q1JPTzc0T20rL0wycTRxQ1dBSlhHa2ZNMFZUM2MwNlR2VWhS?=
 =?utf-8?B?QmdtNWZaYU15Q1pwV0gvczBGQkdmbitPZktjQlNPT3JsMnR0cFhZSCtCcGl5?=
 =?utf-8?B?SE1zRzlSM3lDZDhDcU9vYVdKRHdYR295QXJWK3lMd0hyb2VPSE1oNDZ3SEh4?=
 =?utf-8?B?elEzcWhYY2JUTjNPWlNxYVRIZFJkSm9pSGdHZjhFQTF1REdHWVJFYlRSUTA2?=
 =?utf-8?B?anA0V3FIaVBQWjhQOXRLS2ZURGp6K0UzdUQ1ZStXSHFGSitaWG4zeTJIUHlq?=
 =?utf-8?Q?JCLX319iJtRaH49vAHPeueIiyq7DnqJH+2zbE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60924d05-0f73-4b19-d15e-08d90492d02d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 06:58:05.5115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiY6wW+T9yFKolS4Hcs1p3UJis9VV5gUvXkFrmmXh1cmx/SCkf9pNWun35NBR2kZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4904
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jjn3CW6gsoug_rpJdHuCbxS9egClBMBl
X-Proofpoint-GUID: jjn3CW6gsoug_rpJdHuCbxS9egClBMBl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-20,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210054
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 12:37 PM, Kumar Kartikeya Dwivedi wrote:
> This adds functions that wrap the netlink API used for adding,
> manipulating, and removing traffic control filters. These functions
> operate directly on the loaded prog's fd, and return a handle to the
> filter using an out parameter named id.
> 
> The basic featureset is covered to allow for attaching and removal of
> filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
> the API have been omitted. These can added on top later by extending the

"later" => "layer"?

> bpf_tc_opts struct.
> 
> Support for binding actions directly to a classifier by passing them in
> during filter creation has also been omitted for now. These actions have
> an auto clean up property because their lifetime is bound to the filter
> they are attached to. This can be added later, but was omitted for now
> as direct action mode is a better alternative to it, which is enabled by
> default.
> 
> An API summary:
> 
> bpf_tc_attach may be used to attach, and replace SCHED_CLS bpf
> classifier. The protocol is always set as ETH_P_ALL. The replace option
> in bpf_tc_opts is used to control replacement behavior.  Attachment
> fails if filter with existing attributes already exists.
> 
> bpf_tc_detach may be used to detach existing SCHED_CLS filter. The
> bpf_tc_attach_id object filled in during attach must be passed in to the
> detach functions for them to remove the filter and its attached
> classififer correctly.
> 
> bpf_tc_get_info is a helper that can be used to obtain attributes
> for the filter and classififer.
> 
> Examples:
> 
> 	struct bpf_tc_attach_id id = {};
> 	struct bpf_object *obj;
> 	struct bpf_program *p;
> 	int fd, r;
> 
> 	obj = bpf_object_open("foo.o");
> 	if (IS_ERR_OR_NULL(obj))
> 		return PTR_ERR(obj);
> 
> 	p = bpf_object__find_program_by_title(obj, "classifier");

Please use bpf_object__find_program_by_name() API.
bpf_object__find_program_by_title() is not recommended as now
libbpf supports multiple programs within the same section.

> 	if (IS_ERR_OR_NULL(p))
> 		return PTR_ERR(p);
> 
> 	if (bpf_object__load(obj) < 0)
> 		return -1;
> 
> 	fd = bpf_program__fd(p);
> 
> 	r = bpf_tc_attach(fd, if_nametoindex("lo"),
> 			  BPF_TC_CLSACT_INGRESS,
> 			  NULL, &id);
> 	if (r < 0)
> 		return r;
> 
> ... which is roughly equivalent to:
>    # tc qdisc add dev lo clsact
>    # tc filter add dev lo ingress bpf obj foo.o sec classifier da
> 
> ... as direct action mode is always enabled.
> 
> To replace an existing filter:
> 
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = id.handle,
> 			    .priority = id.priority, .replace = true);
> 	r = bpf_tc_attach(fd, if_nametoindex("lo"),
> 			  BPF_TC_CLSACT_INGRESS,
> 			  &opts, &id);
> 	if (r < 0)
> 		return r;
> 
> To obtain info of a particular filter, the example above can be extended
> as follows:
> 
> 	struct bpf_tc_info info = {};
> 
> 	r = bpf_tc_get_info(if_nametoindex("lo"),
> 			    BPF_TC_CLSACT_INGRESS,
> 			    &id, &info);
> 	if (r < 0)
> 		return r;
> 
> ... where id corresponds to the bpf_tc_attach_id filled in during an
> attach operation.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/lib/bpf/libbpf.h   |  44 ++++++
>   tools/lib/bpf/libbpf.map |   3 +
>   tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 360 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bec4e6a6e31d..b4ed6a41ea70 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -16,6 +16,8 @@
>   #include <stdbool.h>
>   #include <sys/types.h>  // for size_t
>   #include <linux/bpf.h>
> +#include <linux/pkt_sched.h>
> +#include <linux/tc_act/tc_bpf.h>
>   
>   #include "libbpf_common.h"
>   
> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>   
> +/* Convenience macros for the clsact attach hooks */
> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
> +
> +struct bpf_tc_opts {
> +	size_t sz;
> +	__u32 handle;
> +	__u32 class_id;
> +	__u16 priority;
> +	bool replace;
> +	size_t :0;

Did you see any error without "size_t :0"?

> +};
> +
> +#define bpf_tc_opts__last_field replace
> +
> +/* Acts as a handle for an attached filter */
> +struct bpf_tc_attach_id {
> +	__u32 handle;
> +	__u16 priority;
> +};
> +
[...]
