Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49428426152
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhJHAbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:31:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhJHAbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:31:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197Jkt7h019683;
        Thu, 7 Oct 2021 17:29:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=krnybCdMt3CBJsOKkFA2s9VSDf/d8UQ69U1ktaHyl5o=;
 b=b7QAERfZ9mIa6lgSIaqtoupqoIyyAgX/3xExuygAIlDdxEnKk5grasIkv4gnWL0YTiLf
 GTJStJYSHMQEC/z0bkD7lJhgznze++lqIxMR3STOdkoVfsoEXUef4BqEoWVzKGaxyeex
 eWa3xpP4oCv4GJYCfeycBxgmgZWP4kchW3A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bj7bm9vjr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Oct 2021 17:29:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 17:29:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnOGok4azwcJQdraVzIEseCh8L4EvW+7EWG1J/Wt54Mde+TLrW4TQxzUinSoFFfGNtTDVDuv1C5ETsPuW1XgZ0BpimP6i1G+n3UUxKSGbZqAgRbZiTHLVC6gtkpT1h13Qs+cDK4fhe2GLSlIm051agWSo9F5jiSEtQFaqR414JFHLNEnTyN6PSlSKlpZtNxSP8meQCciUzn+4sKKtbyhWd24kiG6zOXpoA2/UhhEVv8B/ae0JvgqEXqjBwE2GBTH3xmNlWbQ+DDZRQDnZx729Go4i29ygzg64dMnmoSzItQa+g7oU3v8ilTwPdszKiwIY56E19T3Sn9QyP3HibZDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krnybCdMt3CBJsOKkFA2s9VSDf/d8UQ69U1ktaHyl5o=;
 b=WQIFaIxL+cLn5LoK4pLAFs49VhyPwzOaiVG/7qvY6TFU3NPFf73qcEGD9Vxut6xJi0Vah6ARPz/XlnCqwJqFqy+kunPYGX6TeYp5bosOXZP5PNjnsDZCBjdnIyum2DefLVBf8LECcmdXN7ladZ2y9++SRfrIISB0PVxMgbVYHjlEujvztM/tpzAaM+Zg+3//hYC3BukHS5yS5EOGwWxbJamqWwrs6ez2abInNqOR3XqZibIss6gP1ITM9eEaani5AnwRXMKuw3rtnpkInaHzrV7PnPovu4rD+vlP+GW20k9C31pjoaZYG36AhaLgdN1dLUavxnYBt8VswxFx1u7vAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB3928.namprd15.prod.outlook.com (2603:10b6:5:2bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 00:29:01 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::955c:b423:995c:d239]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::955c:b423:995c:d239%4]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 00:29:01 +0000
Message-ID: <b64e2a70-dd2f-a5f1-a72a-4162cdba4db0@fb.com>
Date:   Thu, 7 Oct 2021 20:28:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [PATCH bpf-next 1/2] bpf: add insn_processed to bpf_prog_info and
 fdinfo
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20211007080952.1255615-1-davemarchevsky@fb.com>
 <20211007080952.1255615-2-davemarchevsky@fb.com>
 <b500e3bf-ade7-5bb5-4bcd-a67c4be8a8bc@iogearbox.net>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <b500e3bf-ade7-5bb5-4bcd-a67c4be8a8bc@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0426.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::11) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11d9::13b3] (2620:10d:c091:480::1:8489) by BL1PR13CA0426.namprd13.prod.outlook.com (2603:10b6:208:2c3::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.5 via Frontend Transport; Fri, 8 Oct 2021 00:29:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a401239-0ef6-4bd5-0678-08d989f2a00f
X-MS-TrafficTypeDiagnostic: DM6PR15MB3928:
X-Microsoft-Antispam-PRVS: <DM6PR15MB392833A5A116B5D9FEDA2F96A0B29@DM6PR15MB3928.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DHq4fx9BOQfbtqyTFLSp5aiOcLK6W2S1cFGDIryuNh8F8rmSqeB8Xz1yLeMP+AhK+tcrsXzWM6ho6YEvImw93IbDgYiyRD+Fdfh10J/TfPtumJZycuIrzwz8lA7+hva66l8ibWrqXy321sr/EF/l7RFZuM8/2KZ+tvXUjhe70VnHcjWl2vIJkG25o461yGrMAbp1p5+36gNBkvXoFC9oJvYYtAGTytpPm6nAWSfBrcvMvIU+QNEeQcDhLidfL4ouzgl2lECJzJgVm7KnjoTlHVxiKjOhSLFrEfzUKqD6yhQIU3H0DJDT7FT7TYCCRDp0y7mOoTihk5X1Hkle6dN7O3hxMASpwRuNa6CgOeubRu90a2fmaR7tPt1ggYXw0eG4TyOKmE4gL7sjbAWuavGx0zksJrYgJ/9WRrT652AwedPAFYrDv+suQPzck0pvvj7Pi1VOYfSgrulAhoyauJ0ZpwWUNJYZX70ri5pXZSt4MEJK/Rc6Q8gqC63qHReQwtfXC5Ef+Q22S6RzvgSFcXXlfuPzVUwynB1JojiyTlsKemyzrabij6bRqKunSKYH8jpsMapDlIFpENitMiINU0aIChp2jcMV5LGn6iylDL4Plvd1Slxx4V4Ve/P1DkSYzX0Fz8LarrDu6k6qKI8ya/6jP1qpLTf8Qw3b3j1VuEUQnbe0m6xLdvtCkXh3qud1LqGR0KY8pqfOuNqHZ8Daxc7uzWR9lFsq4pli/d0Jwn4ihk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(54906003)(6486002)(31686004)(36756003)(66946007)(66476007)(66556008)(53546011)(186003)(8676002)(5660300002)(2616005)(508600001)(38100700002)(31696002)(2906002)(4326008)(86362001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eE92OGpBUDFvd2c1TFk4ZlZMdHNObVlKZXQ1MldoL3BaY3RPMmE1MjdwU242?=
 =?utf-8?B?bjBBT3gxZ2Zmd1Y1S21zd2VnblQwTThGWDFzaGZ0clRMT01rWHliaDhYUlpz?=
 =?utf-8?B?OW1ndTRqRTdkMUIwcXhMSVBhZGp3Z2ducFNMYWlYRHJLM2s3aEwwTUlIdXdJ?=
 =?utf-8?B?VXdxZ3dpMHZ2eWJmZU11V2tmTmd1Qi9hb1MraTlTTHptYkFNTkpBdlJ5SkFw?=
 =?utf-8?B?NDZqeDhHanZTU1BXUjY4R0NXOTN6WmZuL2ZuTmdSSkRqQW1hVWFKVkZNK3VT?=
 =?utf-8?B?T0ZzblNxUDZWQkxaTkU0cWY1Y21rSzBXSHZlNURKYzhqMWlzQWFTT0taY3JI?=
 =?utf-8?B?WmJ4Z1VEZXNtbTlPd25tMkFDcmk1RGY4eGFOZDVWd2c4RGxHbE9ZbjZkaGZZ?=
 =?utf-8?B?dGJNL3VZbUZmMG41WU1ra21xSGxBWXlKTmIrMWo5blNFakY3a1l2aXVGaitL?=
 =?utf-8?B?NW1VVHVUWDRFY0xEakkzellESHBDemxMQkdPbVdkOFV3dGYvL3Z2dnhLOGlp?=
 =?utf-8?B?S2dJNUh0RzJtZURpMW53SUVIa3ZFa3B4TXhPeGFuYUlUVVBBN05lNVpwZ1ZT?=
 =?utf-8?B?R0p2MXhtRGNzK2o1V0xWVkZERStXOWRIZWp6a08rK0tlNUVvdnVjcjM1amRn?=
 =?utf-8?B?SlRtcWwzeEVrRjFKYVFsTUJJYVVITktMUFV6S0NBTTR0TE1JbFlpdGNyNlpQ?=
 =?utf-8?B?Skx1VTBKK0IrcFRVbmlXa3BVQ1VLdVhsMmQyWGhTZGFHSmZOUkx5QTZUWXFz?=
 =?utf-8?B?TTk1ZDBmT1EwQnpiQXY0WFB5SXpNTDlQM1hKM1JPT2o2c000Mm5hOCtkNkJr?=
 =?utf-8?B?RHQ1Q3VmdlQrc1dYL01qNkVpeDVpeHFXbmlVNzlraXN3b0V0M0xwNVZLSTdS?=
 =?utf-8?B?UGZFMEZvdXV2cEkvUERQSVVmZTd5MFBnMkxXRmQ2ZWpLaUc4YkNnWlE5Tmp5?=
 =?utf-8?B?RE5zVy9Ldks3UFhVYU95Uyt5SUxTL3NJVzJkemtDTnZjSjZnV2NEelgvUU8r?=
 =?utf-8?B?YVU4NWFPZmZqUEpjdEYxeDFKaEhqSUdNcWZFTVZQcVVCV0lHZEw5MlZNNExL?=
 =?utf-8?B?ZW84QldPemErbWtUaDY3RndqcmJWdlMyeUdOWjNXeE8rK0llVFpGczlNMWx0?=
 =?utf-8?B?MXhyRGJIMHJ1eXBnRTlzMVNTWE56RFR4WEZ2clpONnRkWjl3S01jT2J1UUR0?=
 =?utf-8?B?WGhMdGIxQVphVERCUU5MWWQ0OFlkS2VlenRUYzdtZHFLTnU1TVdZcTZrZWMw?=
 =?utf-8?B?c1hNbFJRR3Y1TFVLbDRIcE1XaVNpS0ttdGgvQXpBSnhoMUFXd2k1eXljcXRG?=
 =?utf-8?B?NVdIZGxjSkZzVmVMREZ5ZGNGdzlSU1NjZzZ3YnBabkUzWmViaFg4ZUlGbHk0?=
 =?utf-8?B?RzJRaFBqL0FxTEk3Z3MvZUxMMEp5Vng5c3I2eHF0dmhUc2g1ZzcwRzA5SElv?=
 =?utf-8?B?VStwOUJoUUpFKzVhWFlBcXgxWnB0NEhDeGkwUjRCY1czQmxZd1AzUktNWHBL?=
 =?utf-8?B?bFhVMmN3bU8za1FqKzBzUTdJQUdqanhyWWdpV3RPdVpxYlRQMENOL1FDWFdw?=
 =?utf-8?B?eWtQU2EwNmg4Ulpaa3V4ZTRISVNxdXI0OTRnT3FPNmZPMUF4emVVRFhiN0VK?=
 =?utf-8?B?L2lrcEFMcWtCcWVXVkZaVnptR0NCQ0tVc2kvTWt1SE1tSURtY29NY2MvTUUz?=
 =?utf-8?B?eVZ6Y3pIOVAzYkVQSDY3WjhFeU1iUGpYL0tqc1JoZVo3aWxSQTBpVW8yeVR6?=
 =?utf-8?B?VHVTRG5iK1YzenMvbTk3ejUvNFIzY0tBK1MydGRJeW5WZjA5eEVEQW90SWtO?=
 =?utf-8?B?UEo5dk5GQXNzMGNKZ3FNUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a401239-0ef6-4bd5-0678-08d989f2a00f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 00:29:01.2047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUptqf9wwFIGTi3JKAjvKlq/i62rWaRkqL0jlWNCgKKcNzlFLrBrorNjf9WCk7zA49KNKaw+pGMaLutmdJxjxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3928
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Mn1P6fgXUHIUOARyNhlQj2k2Xig4WY4G
X-Proofpoint-GUID: Mn1P6fgXUHIUOARyNhlQj2k2Xig4WY4G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110080000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 5:46 PM, Daniel Borkmann wrote:   
> On 10/7/21 10:09 AM, Dave Marchevsky wrote:
>> This stat is currently printed in the verifier log and not stored
>> anywhere. To ease consumption of this data, add a field to bpf_prog_aux
>> so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.
>>
>> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
>> ---
>>   include/linux/bpf.h            | 1 +
>>   include/uapi/linux/bpf.h       | 1 +
>>   kernel/bpf/syscall.c           | 8 ++++++--
>>   kernel/bpf/verifier.c          | 1 +
>>   tools/include/uapi/linux/bpf.h | 1 +
>>   5 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index d604c8251d88..921ad62b892c 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -887,6 +887,7 @@ struct bpf_prog_aux {
>>       struct bpf_prog *prog;
>>       struct user_struct *user;
>>       u64 load_time; /* ns since boottime */
>> +    u64 verif_insn_processed;
> 
> nit: why u64 and not u32?
This was an attempt to future-proof, with this comment from Alexei
on the RFC patchset in mind: 

"So it feels to me that insn_processed alone will be enough to address the
monitoring goal.
It can be exposed to fd_info and printed by bpftool.
If/when it changes with some future verifier algorithm we should be able
to approximate it."

My thinking was that, if the scenario in the last sentence of the comment
were to happen, a verifier putting an approximation of 'how hard did I have
to work to verify all the insns' in this field might have use for the extra
bytes.

That seems pretty tenuous though, as does the current verifier needing the 
full u64 anytime soon, so happy to change.

>>       struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>>       char name[BPF_OBJ_NAME_LEN];
>>   #ifdef CONFIG_SECURITY
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 6fc59d61937a..89be6ecf9204 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5613,6 +5613,7 @@ struct bpf_prog_info {
>>       __u64 run_time_ns;
>>       __u64 run_cnt;
>>       __u64 recursion_misses;
>> +    __u64 verif_insn_processed;
> 
> There's a '__u32 :31; /* alignment pad */' which could be reused. Given this
> is uapi, I'd probably just name it 'insn_processed' or 'verified_insns' (maybe
> the latter is more appropriate) to avoid abbreviation on verif_ which may not
> be obvious.

Meaning, just use those 31 bits for insn_processed?

re: your naming suggestions, I prefer 'verified_insns'. Main concern for me is
making it obvious that this field is a property of the verification of the
prog, not the prog itself like most other fields in bpf_prog_info. 

>>   } __attribute__((aligned(8)));
>>     struct bpf_map_info {
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 4e50c0bfdb7d..ea452ced2296 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -1848,7 +1848,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
>>              "prog_id:\t%u\n"
>>              "run_time_ns:\t%llu\n"
>>              "run_cnt:\t%llu\n"
>> -           "recursion_misses:\t%llu\n",
>> +           "recursion_misses:\t%llu\n"
>> +           "verif_insn_processed:\t%llu\n",
>>              prog->type,
>>              prog->jited,
>>              prog_tag,
>> @@ -1856,7 +1857,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
>>              prog->aux->id,
>>              stats.nsecs,
>>              stats.cnt,
>> -           stats.misses);
>> +           stats.misses,
>> +           prog->aux->verif_insn_processed);
>>   }
>>   #endif
>>   @@ -3625,6 +3627,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>>       info.run_cnt = stats.cnt;
>>       info.recursion_misses = stats.misses;
>>   +    info.verif_insn_processed = prog->aux->verif_insn_processed;
> 
> Bit off-topic, but stack depth might be useful as well.

Agreed. Since there's a stack_depth per subprog it would require handling 
similar to other dynamic-size bpf_prog_info fields, so I didn't add it 
to the RFC patchset either, thinking it would be better to start with 
simple stats and see if anyone uses. Feedback there was to avoid adding 
too many verifier stats fields to bpf_prog_info, instead relying on a 
post-verification bare tracepoint (Andrii) or other BPF hook (John, Alexei)
for extraction of other verifier stats.

>> +
>>       if (!bpf_capable()) {
>>           info.jited_prog_len = 0;
>>           info.xlated_prog_len = 0;
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 20900a1bac12..9ca301191d78 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -14038,6 +14038,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>>         env->verification_time = ktime_get_ns() - start_time;
>>       print_verification_stats(env);
>> +    env->prog->aux->verif_insn_processed = env->insn_processed;
>>         if (log->level && bpf_verifier_log_full(log))
>>           ret = -ENOSPC;
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 6fc59d61937a..89be6ecf9204 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -5613,6 +5613,7 @@ struct bpf_prog_info {
>>       __u64 run_time_ns;
>>       __u64 run_cnt;
>>       __u64 recursion_misses;
>> +    __u64 verif_insn_processed;
>>   } __attribute__((aligned(8)));
>>     struct bpf_map_info {
>>
> 

