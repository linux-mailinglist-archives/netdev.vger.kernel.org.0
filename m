Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750C8434667
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJTIG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:06:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhJTIG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:06:27 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JKfIRt014355;
        Wed, 20 Oct 2021 01:04:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QazTzDNy9hq19ClnT6ZuS4KhNfdj9LVvHKk6kM9n5fs=;
 b=f22zBcCaonifggW1MBEUliCi6mQUaBQcfkz2UHaHfkuZ+S1Lx170RKWp3I+WL32MzVHb
 BjIQmI2uqdJqwHLHpBTXFFAg0AmI0qy6Z+aYjmQ8/JQtLgWrck0lqhSk8lt7uep2vXWm
 0QJQNl5Qfv5ynrCwV90zVnbAZSkL1jQKsq4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt4rdkm7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Oct 2021 01:04:00 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 20 Oct 2021 01:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiTXtdgXEJH0PcbzuLsCCuZ9AqKN1W0xGp+6xlG5Osega6W6lzCzUombbFxJvfk9eRSy0lSc1P6I/v5PVvbJ1fHBbjTsgBOR+Q5QAulalYmSjt/MWihfaV1lKKsYBGuF/aT+q/DZAQLb9cnW+9loaDIJwox7Ad/WNlYWOXe6mIjn3JqC4xPVnQTghLk1vruZGQKnhxElRyVGqHrOlyG5D0DKuhwGUmOxgHm/xIMzE0l6I051rApSzg1i76qTNG3/QRbOn9+JlLVgGhtCHVIs8uhQufiPQq29qjPF2alNb7SizeWWBAHtUexWbZiZqyENgcBQ4S5qwynyi+I3kJPsjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QazTzDNy9hq19ClnT6ZuS4KhNfdj9LVvHKk6kM9n5fs=;
 b=oYwgNYk3PgxUnXLxdfHx0yGGz3emAfYK1JrnqXsG4BgInoRioiUP6uSzjO43wCda1ohksE+TkneSduZRx28Wu2nUCQh/awQlfftMUGxbCOOxfvO8onIKNy3W/YKK6wZuvh4tMy/oDH6A7RXqYszen9Z4u6B1Rp+Y1msdRJaEdY32ysCguZOGCmnNo8YlpumPKl8NLjRRK/SIk57mv/CRojdSCxfXE8Cr8SmNlBvfGmnf8gmvIp1Bqv5FBhn+YjEhpjnxMDaRN9KtZ1vTlYMy8ca0TP679O/lvOwlvDYWWcZ6Z8fKeRtdw/U32ksEeSb+E6OimIXWbF84oDkIBmBFCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB2410.namprd15.prod.outlook.com (2603:10b6:5:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 08:03:58 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::755e:51ae:f6c:3953]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::755e:51ae:f6c:3953%6]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 08:03:58 +0000
Message-ID: <549f7100-ce3f-4754-a048-a2c824139a02@fb.com>
Date:   Wed, 20 Oct 2021 04:03:55 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: add verified_insns to bpf_prog_info
 and fdinfo
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20211011205415.234479-1-davemarchevsky@fb.com>
 <20211011205415.234479-2-davemarchevsky@fb.com>
 <CAEf4BzaMgv5otr9AQGHZW=sUCuBdt_Vkv_GqB9n8BYVcZWHjAQ@mail.gmail.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <CAEf4BzaMgv5otr9AQGHZW=sUCuBdt_Vkv_GqB9n8BYVcZWHjAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0067.prod.exchangelabs.com
 (2603:10b6:208:25::44) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11e1::1047] (2620:10d:c091:480::1:1ade) by BL0PR0102CA0067.prod.exchangelabs.com (2603:10b6:208:25::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 08:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62c339b3-bc16-480a-678b-08d993a02b58
X-MS-TrafficTypeDiagnostic: DM6PR15MB2410:
X-Microsoft-Antispam-PRVS: <DM6PR15MB2410252672DCC5B3615E87CBA0BE9@DM6PR15MB2410.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mtsq+u2gDLeU+aD4g2NlqlOyLeyauYmOP6yda7DFOlaagZJIhqRyXXzKzoi7FXtUxj1BkLAfoTYou2vQxKJcbz21fKpWld3wuSzWGQiL25ONY/Yq3zs1/GFjPIEpH6zkmqPz8mLhsuAC0H75OZ0GirT2rzLb2dZf4z5lUX4fGs2Zme493vWjTC+L/OYvO4qSgOsRpv6Jh+mde6f9SM/PVUJ2XzGb0M40zzwADG0PQ76rK+Lm6kfEBBycTG4UDktpQNP1+2Uqk9QSJBbriKzTyxUAPfPe9ilIC4lJ9CwYhpIhYvEzlHyyfQ4rGZUZ+LfQ8uWGOUcLHgEz64ei5u/NGfZObIP/flfhQu9WdJCXu9hRCtmdOo4bUzTIGHabkyL4BZIpURFIoz0Q6vFsVLpMXhsdPByXaY+5u6TgXNa2pxW4X7wJ+6Z/HAwPylv6qdd3x1udMDGDHxfyYzrBhsaGHAYDFpPpSaw7yK9j8fGYov7eL2MDZ4KRglylVCLYdF+iJErPvPoUX9/yJWehjQLQcex32znWkdTEMHatGBFzwwHjX8toOnbH2aqeE8kEnzFo09iOTxEs3OR7fDNt7BZqnBN2us2GUiwLSaC/4EGLaCHX2hCSfJH7+oO+iPb4Kjr73ObhSZxnBbL8TzxC77glwvtyBJxnwUhgKAj0dWuOnwGaPWx5DQEZjGm/jmd9prQWxTf6noQgMiQmmPl9SxBNVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(36756003)(4326008)(15650500001)(8936002)(2906002)(66556008)(38100700002)(8676002)(5660300002)(316002)(31696002)(2616005)(53546011)(186003)(6916009)(6486002)(86362001)(66946007)(31686004)(83380400001)(508600001)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3FiQmJZUUxnaWpURzh1M3FLRHJDaTNBZG4zb0hwaGcxdmg1NlNuek1FVWxS?=
 =?utf-8?B?MTlEQ1ZURVVadXUwMFZsbi9nOXhBYkNpaEZTM3dRUEkxWEF3RGJKUGloTmVr?=
 =?utf-8?B?RUpNaFdOaTBxYk90YWkySjc1Zi8zWlZVd09yQ0J4R2Y2MmFudVBsRGVWYUFq?=
 =?utf-8?B?MXBDWFJrb1pEaUdVcUprZjk3QUhVblFMUFNtNndpWWZ2aDF6TUYrbDZETHRD?=
 =?utf-8?B?NUtrMS9jYWp3ZGF3MXJ1UStlNEdkUnVHeEFhaEVHVTVaUmNialNNSXM4Q0J4?=
 =?utf-8?B?TUFrc2MxZFgzcHFJNFFPV3pCOHNVSm5MTFJneFlMUXJvNzZHVi9nTjBTWmNk?=
 =?utf-8?B?aWJqRUlWSmNsbkp4cTFqY1ZGOWxaSU41aWRrTERQN3BsTFJJYnhZM2dQeWxn?=
 =?utf-8?B?aHJTaGF0eHpQNitvcEU3S0R5MUYxRVIxMnQ3L254SGVnKytKTUg5WWVQS01O?=
 =?utf-8?B?TnlzdHdHY1I5cU5UVG0xMU1YZ0pqd05vcTJ6MVVjczF1eXNxU3NIY3FickFJ?=
 =?utf-8?B?MFhTa2NublVGVEl2SGtRSWt0K2M3VytXVk5JZ0xDdVNNeFlWZi9vbk44MDlz?=
 =?utf-8?B?clRXOGdSSHNRYXRXL3F1QWtlYjZXNDVDbG5NM3MzUm9Zd1paUFlOZlk1cTE3?=
 =?utf-8?B?d2lwOVJYMzZtOWQrWktEVVg4SWVLTWZPUUM4eFhnNWJGYURvOWJRRW4vMzJl?=
 =?utf-8?B?UjZlY2RmNndlL2pkcjBpNFprdGpBTFRNcXBmOEZJbFUvS1NLaStScDVMYnJE?=
 =?utf-8?B?SVRpdG9GWjl1eFBRWW9qWVlhQ1dNY0k3dktRVG9vVjFhK25UcGpuNWsxMHhC?=
 =?utf-8?B?em9nME5RSWl1TFl3OFltWUZ0dElNNGpxR1VYQXRUVUJwTmVGbFhpdHF5bTNk?=
 =?utf-8?B?M2xUNUZ1UFd4c0toVjB2ek84ekVKMGVxdUdhSVFDV21wVWFtdWhuMis5dWdx?=
 =?utf-8?B?VWIrTjZ1clF5VU4yOHJab2E4UkdJYTFndXduMks3a3p5ME1sSXhBQTZDVXJS?=
 =?utf-8?B?TWRRcmtlMFhiSW1MdHBDTTR6emNTdjFkWHZidStSMVQvLzB4L0JxamNqcU9M?=
 =?utf-8?B?M2N2RGZTR0t4MHBUU3JEYnZDWmVHeVZnajVYR1h6TzlOQTBUVFM2VTVPamRy?=
 =?utf-8?B?ZjcrbVQrQ0JKd01SSk1KVXlVZWE4a25OTEYySnZjZTA2alBOVW9Gc0JzeG5Q?=
 =?utf-8?B?SDhaRDFRQ3RaLzEvZkJ3dkZFVTNudmN0bldlUE9iNHhMbVN1VUx2ek5seHBY?=
 =?utf-8?B?ZEFlWWN0ZEFDWEVXL0hYSmdKVDlRSkRXZGZkcVFSaWxXcXBiSUdEbU13YXEz?=
 =?utf-8?B?TmxPbGZhcHM3ZEhsbElxMkhoSGVyaDh5OEU1cGNyQlZLTkdsMFN1UlFQSFRy?=
 =?utf-8?B?elE3YkNnL0N4b2ltN1Qxb3U2ZkJVT21MMVBTUDZzNWNUZ0gxOVV5LytENW9P?=
 =?utf-8?B?TVBxcGE2Ukp4Z2VUMDArbmlGd0dSUWFlTzFpdDE3MFM4WHhiN2VhVVl3cUVx?=
 =?utf-8?B?V2s2eW5jUE11ME5FYk8vN2lMbzUwQm15ZGZBTWtpMlNWREdTckczbFcxU2J6?=
 =?utf-8?B?eFpTbVpsRW15dU1pZFdPb2xKc0had0ZjaGdJWDIrYjVlbWsvUFRra2syQXFU?=
 =?utf-8?B?T2ZRUlRuampXQ0daOTdmVnk3NkF4OUZmb1h2MWZjVVB6Tk9ReWQ0VEhaN2d5?=
 =?utf-8?B?V3RsWTJXRHhPRC9tNDNVYnRhTWlQc1doVFlHSHdrcUhXQjdZcUpLZ1lXODEx?=
 =?utf-8?B?QVNqSDgzTjlscWN0ZWdXQ2o3ek9jYUladnQyK1ROV2VXcW4rKzZZT0JSTHRu?=
 =?utf-8?B?bDdIckM3QjNidEEzSXNCdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c339b3-bc16-480a-678b-08d993a02b58
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:03:58.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: davemarchevsky@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2410
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lwHDaJbc0NVaUzFwjJhNOMnkTfqgMWL5
X-Proofpoint-ORIG-GUID: lwHDaJbc0NVaUzFwjJhNOMnkTfqgMWL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 5:22 PM, Andrii Nakryiko wrote:   
> On Mon, Oct 11, 2021 at 1:54 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>>
>> This stat is currently printed in the verifier log and not stored
>> anywhere. To ease consumption of this data, add a field to bpf_prog_aux
>> so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.
>>
>> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
>> ---
>>  include/linux/bpf.h            | 1 +
>>  include/uapi/linux/bpf.h       | 2 +-
>>  kernel/bpf/syscall.c           | 8 ++++++--
>>  kernel/bpf/verifier.c          | 1 +
>>  tools/include/uapi/linux/bpf.h | 2 +-
>>  5 files changed, 10 insertions(+), 4 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 6fc59d61937a..d053fc7e7995 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -5591,7 +5591,7 @@ struct bpf_prog_info {
>>         char name[BPF_OBJ_NAME_LEN];
>>         __u32 ifindex;
>>         __u32 gpl_compatible:1;
>> -       __u32 :31; /* alignment pad */
>> +       __u32 verified_insns:31;
> 
> These 31 unused bits seem like a good place to add extra generic
> flags, not new counters. E.g., like a sleepable flag. So I wonder if
> it's better to use a dedicated u32 field for counters like
> verified_insns and keep these reserved fields for boolean flags?
> 
> Daniel, I know you proposed to reuse those 31 bits. How strong do you
> feel about this? For any other kind of counter we seem to be using a
> complete dedicated integer field, so it would be consistent to keep
> doing that?
> 
> Having a sleepable bit still seems like a good idea, btw :) but it's a
> separate change from Dave's.

Re: use padding vs new field, I don't have a strong feeling either way,
but if there are proper flags that could use that space in the near 
future, this combined with consistency with other counters leans me 
towards adding a new field.

Also, when using the bitfield space, clang complains about types in 
selftest assert:

tools/testing/selftests/bpf/prog_tests/verif_stats.c:23:17: error: ‘typeof’ applied to a bit-field
   23 |  if (!ASSERT_GT(info.verified_insns, 0, "verified_insns"))
      |                 ^~~~
./test_progs.h:227:9: note: in definition of macro ‘ASSERT_GT’
  227 |  typeof(actual) ___act = (actual);    \

Which necessitated a __u32 cast in this version of the patchset. Don't think
it would cause issues outside of this specific selftest, but worth noting.

Anyways, sent a v3 of the patchset with 'new field' and other comments
addressed.
