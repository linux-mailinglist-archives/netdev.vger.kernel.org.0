Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E63322F02
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhBWQqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:46:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61962 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233468AbhBWQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 11:45:58 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NGiMq3018722;
        Tue, 23 Feb 2021 08:44:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JqeeHIjGZ+nzXU62aO+50qyzRH53EjgdCL9KGWr+If0=;
 b=CSP0N0pxOsWbw7SwIyX2A8mlyVmiZVe5HKmh+5/CwUGXdQYgSwtHpaPSWOn2sfdihhLh
 qALmUy0z3G330WO669HZ4s5n685tL4EGwTtoRy6UfDc4+6Niu0a5SQ8DfJZnVTTv6l6/
 8bxIrsigMVCGfL1vJxD9bikWJlQ0ozB/Ou0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36v9gn8bqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 08:44:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 08:44:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqtctfpQvu/UFVlex0EGDYPz5Xycs8afQwHJET1WjOItKaFvXJPWhlMGb4jmjOCm0tMldFSLEU/VQ/Vj14it1V1eqwpREKSUOsRxLBtYMZa2T6Rzm8bR1V8g5SJiAotEmDb65TbpQq5BDm04M0O/PLlmr4suzWsQ+oFZTG4T1nzMARUmLYDPuQ2gp37e59zeCDFGEls6Q8zZQBBOR9aprcF5P8hBJRfj8WPSgoF5EcX+yCGx/ilDZvNcrjLf/T3lOC4vA1CU/+bUJlEpZ2oH+D/y/wHMqzO1c5hqPY2TH2mhWa5l5xNiKNe6mqSZ9ojJ/yZ0IURLCDHkzboUOx+Ydg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqeeHIjGZ+nzXU62aO+50qyzRH53EjgdCL9KGWr+If0=;
 b=SSOXhDhVw1Yy00TFoI5kO/Md/DQJ8pymFUKyPG9dglG5MfpZFDiUv/mzgZgMZukYJzkEhEsiUUzetsl+cn6z2ceoQbXK97HUt6HMaO8dt+i25p9RMBAebWbC1Zd7sxj4U0I7s2HnRqvEbA632zzViSdiAhoD8gDQi74L4POYAJZKYo+10eKXg//ZcTWXxUvGjmlNMGH2V42hYsM6dW3+FqOmpwFxdXsD/PMRuoexiiFX+bjopuvnQOCxCzACxlnb5Kt/iDTizBBlgGasoVLdnECia2Ya/aM7jklH9MNSvvQyH8ECgMhH1LgmtM63yCVcbW/JbCNpBurQvEGVpZ586w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN7PR15MB2292.namprd15.prod.outlook.com (2603:10b6:406:8b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 16:44:55 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::81bf:9924:c4f1:75cd]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::81bf:9924:c4f1:75cd%6]) with mapi id 15.20.3763.019; Tue, 23 Feb 2021
 16:44:54 +0000
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-3-songliubraving@fb.com>
 <CAEf4BzaZ0ATbJsLoQu_SRUYgzkak9zv61N+T=gijOQ+X=57ErA@mail.gmail.com>
 <6A4F1927-AF73-4AC8-AE44-5878ACEDF944@fb.com>
 <CAEf4Bzak3Ye4xoAAva2WLc=-e+xEQFbSyk9gs50ASoSn-Gn5_A@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <a3eaaeb5-f14a-ef55-10c2-884dc9365f57@fb.com>
Date:   Tue, 23 Feb 2021 08:44:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <CAEf4Bzak3Ye4xoAAva2WLc=-e+xEQFbSyk9gs50ASoSn-Gn5_A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:5e03]
X-ClientProxiedBy: CO2PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:104:1::23) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:5e03) by CO2PR05CA0097.namprd05.prod.outlook.com (2603:10b6:104:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.9 via Frontend Transport; Tue, 23 Feb 2021 16:44:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 761d585c-168b-4514-4a06-08d8d81a58bb
X-MS-TrafficTypeDiagnostic: BN7PR15MB2292:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR15MB22923C1D368274FFF20A7860D7809@BN7PR15MB2292.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlB4Na/f9i9vNK4i1MIXrRPh4FWilRg09gusHy9ktGqbnQuItL376Aaez/pmJgvgI2psTt093EE5Q9KnZqSwt+j4xm/FF7PF3bGtxKpaXf7U9j9mwKLiU4vwBtYHSWxIX2JAflnZVl10vt9cT0aa6oaEidWfMT+iQC9PYUQO9VfIO9A5KfA3B047B+WFK5RlVwnCln278CY+K3PHI/VndM6cijZfvb1IeQW+Ysgk2A1L9BlnEALnwFMjOhcwR9fwUaIdp0738l0Uw+VFUTTRYXoQSDSLotSw9DfkOB+kkoGFn7Xg/FH/Ev0yXKnKOljgPa9wBitJSu0YYT3LvrKUlUUil6DlMf9oT6JzoFT/zQ5O+ByamH+jog9Lg11cl4NCafDuQplcWXvacn6MbQYkdhS5TcudnScxvcTY2MHV0mGxaqmwaCBzyb5cJMKm64U8l7bX+9tAy3pxJ5sGaZ8yAn59epOjNeQILGU1LwdFmtWWyF7rrFz4OuHYgpnSaBETJUwp33Ia3vffaeq+NnBl3/h7T3sD9D24UJFEdfhDXBt3+7AcNs2LxBAzvBl9IKCPz6+1Cb9aaI7wA+G6UwEDMACnLZd+EUDGGQhG6T7NewM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39860400002)(366004)(396003)(86362001)(83380400001)(5660300002)(36756003)(2906002)(8676002)(31696002)(6636002)(316002)(8936002)(2616005)(110136005)(66556008)(66476007)(186003)(53546011)(478600001)(6486002)(16526019)(66946007)(4326008)(4744005)(54906003)(6666004)(52116002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aTZKZk9uV1NZSVY2V21IRDdjK2pwOCszZFVOQmZGTVJseVYzbUt6Wk0vZlVT?=
 =?utf-8?B?WmNCbDhjN083d3hFY0ZFa1VQdTRxT3NpbXZDZm5SL2RtNFpTV2c0aDJ0MGdQ?=
 =?utf-8?B?RzJMVDR2bDh6Zll6aUpReGdEdGMrWTI1U1lNb2xnRmJDS3hCZFU3UFVBN2Y0?=
 =?utf-8?B?R0ZEVVBzbENPQjQxcE9SZENzOTZzZGordUs4SFRvdllMM1B1UjRzdmtpQUxB?=
 =?utf-8?B?Ny82bWJYSyszUVlsK0ZHVUxDbmdZc211MVZtejRzdW9uMVl5M2RDcU9sVzM0?=
 =?utf-8?B?VEZkS3dlNjhnd25qcVFjUVdoZ2lrZWZXekg4YVJYS1BibmxsWVREdXUzNnpt?=
 =?utf-8?B?NHZQcEd6TUFhbzdaTEpIS1FTVzgzeVN1UjZLZ3lBT0YwMUhwYlJ1a2VRcFZJ?=
 =?utf-8?B?WDc1NHlsWllGeWlOZWF5LzlYZkdKekpDd3RIcWpjdmRaRFl3WEVaZnRYc1Nw?=
 =?utf-8?B?enVkNzRhYjhBL1FHOGVJRjZrSHdxWndUendib2Z1c3JzSTZtT0krNExMSkp6?=
 =?utf-8?B?R2F2c3QxYU0zbUtJczREYnp2QnErUUZCQTNMejhiZEthWVRZb2FSeGdqMURi?=
 =?utf-8?B?M0RzQ1BoOHpOQmJBcGZqaXZqdWpwNGlxbExxd1ozTEk3UElWR3FMMmsyMGMz?=
 =?utf-8?B?RGxLeWVIZ0pFRVdRbjNIbHY0cVNvVGNpU3RCTmxuWFRwMlhUUm1zMndwSGM3?=
 =?utf-8?B?N0ZQU3FhZ3hPdVhWWExLczNiVDVwMDFPYm1JVTFoR1E0MnU0OS9QVGJOemNS?=
 =?utf-8?B?UHRnRkU2OGsxa052MFByaDFHSnlCSXJuSUlHYkpHYlZwWXVYMlBGMm9RUEJF?=
 =?utf-8?B?RWVLdEVYQ2tqaDFXV3pRb3g1MGVTN2ZYd3J0MER1NDhqdmxsbFJkSmFMbERj?=
 =?utf-8?B?aHZITVcxdk84MlRnTVErMlpjbTBaN3h2TElSdGxiS3ZNbjNyT0tpRlhmZTQw?=
 =?utf-8?B?THdpbVovTk85cldnYkFjVWVHSWZudDM2SDRBdE40d1ExSFRYUk4vWFhwS2JP?=
 =?utf-8?B?dlZBMldlTnNYM2RpdXZHOVBIamgxL0pGYUJ3R29WdzFBYU1yQ2VSUFlIQ3pW?=
 =?utf-8?B?ZnFjOTUreit4NHFuNUYwKzVNWklpVGxIY2U0L0NHR1RsZWwxV0VJZWRoa0Q5?=
 =?utf-8?B?QldORjdvbFBKYUxHTzVpSUNDRkxON3NzN3JFbUEzUmJ1T2FESFRsbzVPWUMr?=
 =?utf-8?B?UTlWWjZndnIxOFJENGFQU0ZqOXl1d1UwVGczcFFudGsycXN5Tk5EOEJuUjdw?=
 =?utf-8?B?aE41NUw2ZHpnbFdsMVE4cDc4RkZZQWZydlpsWFZEMDJhOCtqRE9LNWs1bU4w?=
 =?utf-8?B?c3lqc050cCtIU2ZteW9ZQmhVTnNwL0pEUUE4N3ZkVFVQbDVOZWhNMHZ6M09N?=
 =?utf-8?B?ZHRhcHdJV0VOU3BkQkFRZlVTMjhZTGNKTTdhQTRlYlNQaCtGRnl1UWlVM0x6?=
 =?utf-8?B?UkhJSzBjQ3VlcmlMS3NFV1ljS2dzRytEMFJhWmVIMlVRb3JOUnQ0V2t6Vm1Z?=
 =?utf-8?B?bXZDZ1JiZDJ1SFRoS1VKY29hQ2ozeTUxVXdoYUdJWEtFMkZ4dFpNVnZla1cw?=
 =?utf-8?B?TzVua1A1aENOTUxSQ3FBYTh5RnJBZ2ZSRW5yajB1dGFMckVHb3I1bnpYWUN1?=
 =?utf-8?B?QTFPZ3FFQXc0dUJhTFF4VnlmY2RGVEsyT0FkMFJ5bnpDRHVBZHlIYmlkRlBE?=
 =?utf-8?B?czVwRm9LQVNtY29ETEU0bTNrdCtjVFgwZnVxcnNHR3VNajYwa1hVS0cwbVVp?=
 =?utf-8?B?aUpzL3FVczFiWDhwNTZCQzExbThCLzNoQTdUamFnK1VDZVhZWFcyOEt4MWVL?=
 =?utf-8?B?YWVNMm9adVZPaythR1RZUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 761d585c-168b-4514-4a06-08d8d81a58bb
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 16:44:54.8530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a4sh3W4ddntAWymQxsRNSdPBu8i/9WnhNpWgb3Nk7cOOOVqqD6OoUJRhnHJn+7iK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2292
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/21 11:19 PM, Andrii Nakryiko wrote:
>>>> +       bpf_task_storage_lock();
>>>>         sdata = bpf_local_storage_update(
>>>>                 task, (struct bpf_local_storage_map *)map, value, map_flags);
>>> this should probably be container_of() instead of casting
>> bpf_task_storage.c uses casting in multiple places. How about we fix it in a
>> separate patch?
>>
> Sure, let's fix all uses in a separate patch. My point is that this
> makes an assumption (that struct bpf_map map field is always the very
> first one) which is not enforced and not documented in struct
> bpf_local_storage_map.
> 

I'd rather document it in separate patch.
Just doing container_of here and there will lead to wrong assumption
that it can be in a different place, but it's much more involved.
Consider what happens with all map_alloc callbacks... how that pointer
is hard coded into bpf prog.. then passed back into helpers...
then the logic that can read inner fields of bpf_map from the prog...
