Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD67C196122
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC0W2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:28:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4016 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgC0W2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:28:43 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RMOIgj012234;
        Fri, 27 Mar 2020 15:28:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kpljoyjr0jiR55YBRt1t+07EJYWgh6xntbr1KpoOih8=;
 b=lO4r+Ga4Hiych+QrtR8mKoIFFIa3aUbR0EpBkPvvby3SV7wbei8O4gwoBTWpBduJK6Ry
 Wcf7GNGwk/nZyPs+/119+ZbJ7ibWitZTlnhh+odzS9cF2nhlGSCKPIlCjQIAooxC8WGV
 csisg6+wbCPHqm7thz+uIo08p63Wx9NI2Ws= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 300xq1g506-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Mar 2020 15:28:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 27 Mar 2020 15:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7sgC6hccX7fqA4CdltG8NtlgMD7bLH1QgaFCvX023hbPKBa49igx1bE06X/rYWjCxMffotL9q2urEAPBJtRsqrOCYStavj+vho+BFrQD9iKz1MYJSoz3/mbH2UTHaumnM5++5clNoMWP9zcEqfpbFNUglhdxwY15XInDXw6mh1F/KbDaUcB0GFGID5dmEzjSA8rFvH62Cd+xYynUaU5l4DVN4anjbhCbAEhR7gVxS2QUqJkFw9+YlIIse3Ji+oU5VW2aUNk71n4hl8JL9+mCwnW+/JY/V6FuOEIa7IhDLanM1JsEoIP9CYUWR4DMSanvzNDfebIVL2KUHx3bjVpWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpljoyjr0jiR55YBRt1t+07EJYWgh6xntbr1KpoOih8=;
 b=RouOLQSJRjwvLfHeiQyA9P3J6eZojvkRR+0E9vLKSPU2azCdF5giXxB3YIF1EpfytLMsfM32hn3UDCYaYjJz33zfKnzHyulyOXwjEmuvfTFN4e8buQygHEifQB2XA1VqXMi8aBJLhL9N95JZLUteAZc/09KgkkKA8oDX8reBus91WEqkVd1KHrcnTNN+LT29sMwx61d5J6/1/Yc3lczTW6OXNcFcqeQrbJCh/HMuzZLl9khakRP2U9mHdHOWfZyAIXuONjO+DIzV/WbYq/by8rnSGY32whakSOzZze4CxP1ETl0cgikGuhav026HmNfeBluE++kp0TV+sRbi7dsyWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpljoyjr0jiR55YBRt1t+07EJYWgh6xntbr1KpoOih8=;
 b=lGXvPX7t/7/JlBaHMk0Wz9QyUcJ4OgogW1N2oP8DOggrJWT//6aN7LvtmM9LTIwx1qEqdp2feoX7wyoQVwA+dT4hd4wTksQg2qY5dinWW9zQeg7yOg2TGU+iNzrTNwQbaLrAYF7YYf9RA3DJSxT1iQS1oKblB09qijqZ4l5vtgw=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3994.namprd15.prod.outlook.com (2603:10b6:303:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Fri, 27 Mar
 2020 22:28:23 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::7434:9ae2:3b63:331f]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::7434:9ae2:3b63:331f%4]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 22:28:23 +0000
Subject: Re: [PATCH bpf-next v2] libbpf: Add getter for pointer to data area
 for internal maps
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <20200326151741.125427-1-toke@redhat.com>
 <20200327125818.155522-1-toke@redhat.com>
 <CAEf4BzbEyYQeLEsw0tzYYHeKi+q7a+vxavya9O3jykwsH3ki9g@mail.gmail.com>
 <87tv29l9ia.fsf@toke.dk>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <dc1ad5b0-d575-034a-ffa5-710bcf94d8f0@fb.com>
Date:   Fri, 27 Mar 2020 15:28:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <87tv29l9ia.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR07CA0046.namprd07.prod.outlook.com (2603:10b6:100::14)
 To MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::129f] (2620:10d:c090:400::5:4ef7) by CO2PR07CA0046.namprd07.prod.outlook.com (2603:10b6:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 22:28:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:4ef7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0958c873-c105-498f-dfd1-08d7d29e2901
X-MS-TrafficTypeDiagnostic: MW3PR15MB3994:
X-Microsoft-Antispam-PRVS: <MW3PR15MB39949EE57B2A5CAA8912607FD7CC0@MW3PR15MB3994.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(396003)(346002)(136003)(316002)(36756003)(31686004)(52116002)(66946007)(66574012)(110136005)(2906002)(66556008)(54906003)(66476007)(5660300002)(4326008)(478600001)(6486002)(53546011)(81166006)(81156014)(86362001)(31696002)(186003)(2616005)(8676002)(8936002)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3994;H:MW3PR15MB3772.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hni8VtF5q4sV3zddR3vuj2IcfX5IbGFHMpGFP60sxvltAPNgWFl5rv/gjywLbrmbIVDys6SUVxuy4i8kFIoYi1p2StIa9HhsHm1vUPx45TxOmMISwK+guCnkdioABRa/KK3aXBPg7z6swYQv6AM+6ln3z5B8xazovOHNIzD21tDndbB9TBiSC/pWei6EPp5eFer6T+qqXYjXeELQxz2mLQWkNP51CkVU40DEQkcHus2bFLFqJ5uOXmcsfHRp6t+8/mvpKOuckXwtlnowGg6D+oTxp81XmmOwfsL9L1zTguAAFc9lhriwZeD6zov7+AhcfZpQNBs2QbOWsxxCRI612SZgFZ1qddqllEJ8hvJu751lkeDms0WN+ltOoChZfDq0gDYSjeHEwhBtlYbsulqNlzMswWvrndngvUixRYAiH87xFOQ9BhrF0Ya+AsLtBA6y
X-MS-Exchange-AntiSpam-MessageData: HNUnegBe1BRSvoXbNh5s6uDCna6kK02unm+QKqK8+F0rouL15/LRs3rKFyeds3EYhRn0uChKj9gYaHEnT9kbQ8aefCYGFpqhi3S7fzdzy+l+CbTVla/L4Y9TV11aF20lMjpuxcKYElE2NM2hl8MH4ylxUZy2Va+IXZigWhTSHaiYdMusGz6pOxJO4pjg9+kV
X-MS-Exchange-CrossTenant-Network-Message-Id: 0958c873-c105-498f-dfd1-08d7d29e2901
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 22:28:23.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEOE0ZDasBly0lV+3Eezw1Q//JkTUyGs8r1i7DG4qEzgsLlGYQ8RwyBblfLZ/1T+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3994
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_09:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 3:26 PM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
>> On Fri, Mar 27, 2020 at 5:58 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>
>>> For internal maps (most notably the maps backing global variables), libbpf
>>> uses an internal mmaped area to store the data after opening the object.
>>> This data is subsequently copied into the kernel map when the object is
>>> loaded.
>>>
>>> This adds a getter for the pointer to that internal data store. This can be
>>> used to modify the data before it is loaded into the kernel, which is
>>> especially relevant for RODATA, which is frozen on load. This same pointer
>>> is already exposed to the auto-generated skeletons, so access to it is
>>> already API; this just adds a way to get at it without pulling in the full
>>> skeleton infrastructure.
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>> v2:
>>>    - Add per-map getter for data area instead of a global rodata getter for bpf_obj
>>>
>>> tools/lib/bpf/libbpf.c   | 9 +++++++++
>>>   tools/lib/bpf/libbpf.h   | 1 +
>>>   tools/lib/bpf/libbpf.map | 1 +
>>>   3 files changed, 11 insertions(+)
>>>
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>> index 085e41f9b68e..a0055f8908fd 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -6756,6 +6756,15 @@ void *bpf_map__priv(const struct bpf_map *map)
>>>          return map ? map->priv : ERR_PTR(-EINVAL);
>>>   }
>>>
>>> +void *bpf_map__data_area(const struct bpf_map *map, size_t *size)
>>
>> I'm not entirely thrilled about "data_area" name. This is entirely for
>> providing initial value for maps, so maybe something like
>> bpf_map__init_value() or something along those lines?
>>
>> Actually, how about a different API altogether:
>>
>> bpf_map__set_init_value(struct bpf_map *map, void *data, size_t size)?
>>
>> Application will have to prepare data of correct size, which will be
>> copied to libbpf's internal storage. It also doesn't expose any of
>> internal pointer. I don't think extra memcopy is a big deal here.
>> Thoughts?
> 
> Huh, yeah, that's way better. Why didn't I think of that? Think maybe I
> was too focused on doing this the same way the skeleton code is. I'll
> send a v3 :)

Could you please add a selftest as well?
I'm not excited about new features without tests.
