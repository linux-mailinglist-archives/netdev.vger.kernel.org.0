Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6447E677
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 17:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349246AbhLWQh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:37:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240125AbhLWQh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:37:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BN6uDLn000802;
        Thu, 23 Dec 2021 08:37:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=t8fgXdvkTl2NFseD4X8R/fQddfPAFA6cn7SyHfZ0zhA=;
 b=iezUSIgAQUtkfJuwCKHYwuYSKJ9FL5KndkfMv+gph3ptiBIRpOjaEID9lf2+LofIBv9W
 T/CaXsUq2mtcQAQ1qY3fR5yz46K4C58KkYr3Yz9K5KtCk7OJPI8IDjdE33crvZVX389J
 u+riwzU4IzGJ8Jux/xuB4LN3pAcS1zwZlj4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4m96ubdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 08:37:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 08:37:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGs2AaORFP/ZzPmnIA3brAzrzJ6OZ2hHcYR20XhkYXOVnfzfnxeqXfq5epVFZwuHzNQigAAlo0pG6sMBGmokypqLW1faio9cXdNrN1Oauy+A+DQ76JRhC0+Ktxc+KEgZwmwMRKczllgOgjoiGoBOnELVhOxkajGeVkD9OwGlL9X1JXGwAszkOCU1dWFgQcZ0olMsXW3N5xeJ6inuYUWhwUiCcbUfxKWx+FbVSif1PY8dNtt8hHTJ1sgc2Dify0AMsBr6m9xCzB2LWYCUoZNy1jtCRzAg8o09xG++vt7nSBAmtoSdjLJCpjSkHBFe5C2pFFOSnOPZRFGwYmVwnUXxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8fgXdvkTl2NFseD4X8R/fQddfPAFA6cn7SyHfZ0zhA=;
 b=YxX/v3PJS2QnnUPBcqmNO7j1N1f5X2yRrlSJrqqoRrc3mVj3fFnzq4EzadZp35bq9dLQqHzHfpgZupUVslK8l29UhizLwAheL2lgu+LT65q/5XAWVrKFO0xAAhjgqXGSNh8E+bcf7KbLfNj0zy/Nzyn0erkqzDdJISnieA8F3FeqHRBU3Trf94sppV6f5ooOpk39hvlFxY3LOfbylRbnRBdACY7Au3FC5JFD8Y5WQX+FBUpUqJuPKzH/xEACVWwEX+K3Kmgpb9KGLQBWQxesCfPG1UGknwu1zRw7vo9QTeU6SpcCAfJfATdw8FyxUNvLM87n+L4orAAVmKPoJ1YASA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4904.namprd15.prod.outlook.com (2603:10b6:806:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 16:37:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 16:37:01 +0000
Message-ID: <5d33841a-de0c-1db1-1205-30b68258d5bd@fb.com>
Date:   Thu, 23 Dec 2021 08:36:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFC PATCH bpf-next 0/3] support string key for hash-table
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yunbo.xufeng@linux.alibaba.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
 <20211220030013.4jsnm367ckl5ksi5@ast-mbp.dhcp.thefacebook.com>
 <2b86cdf9-0a7a-8919-b25f-29743f956c1f@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <2b86cdf9-0a7a-8919-b25f-29743f956c1f@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:303:b8::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 089c8863-a515-45e9-4d3c-08d9c632724a
X-MS-TrafficTypeDiagnostic: SA1PR15MB4904:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB49043D943D1AB368AD8DDC58D37E9@SA1PR15MB4904.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xG30hZP1zf1n2/J2wLpIFFzYC6uXT1LwhXUEUHczWLhPl55+x3lLUtlsCijdMvm2U77ezUtix2w1rfHP/tkcUBTx+zxK8oC0ngmsfMzyG9h9kkh+/XEpv2mzwrgfdhlSp6oopQuA8vKvQLvkfJ2Ayr91JXEXJPdCSm0DwNvypyVyDHAkdjw/MGuVmLTlGW8341DLcEVKe5E6bai+2CkQzXhx1+mp9pwYAabRz42B0q+/eIexQsN59HZT+LWEcflkNU5bVSHRJsBD6HiYRNFMBoeTlQySu1w4k9gXdwUBtpgaJ3sU/rrCS1nlr08JU0IHiy36iGItrEYy6ha2l7XCsGRKKYBrj1vhaD4uC6G8ZXGRQIzq6FHMH1MVdkj5foRRsObpbBxeiF8g/H7KxIIqIl68EW2V9bIiAcY0dxJAfIMkhifgCsqi2eirSgNsxY4ofc7ut+ogCSm4+joXvmI5JwAAXLvX0/cuRwkH6oQDOoRzK23cLBaB1ZqNOhgXyNK2gH5mF7pEpe3lbZI1z2FKyZxCCxSneDt6vF1zZDaLIwhYooKPmkKTN9jdk9Yqa6umypTDKFCvKl3lhAE34nuFGcS5Hxy8DEce3SJHlebaGeySiaZDTWNM3z6jcY2lMxF25gWbZqlqXm1Dk8sOl6MjaKvZi2cRifVKWs/tuCvtU6zHdKHGMnPLKRSLCJPIjQwytxxcdEYX4VvnHhYoFAjDcMZKTQzUfPrLSTc7uarqO/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(66556008)(6512007)(6486002)(83380400001)(31686004)(4326008)(5660300002)(36756003)(86362001)(38100700002)(6666004)(110136005)(508600001)(52116002)(316002)(8936002)(54906003)(8676002)(2906002)(31696002)(186003)(2616005)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bk5haXcrd0Y4dXBhRHZKeXBnNU5obFZMUFRjdkRvR1JRay9USEhtVVV1ZEx1?=
 =?utf-8?B?VU5VWWNDeWlGUEljWmgyekxjNmtoUlluczZJejhYN2tpbEgzRjh3ZmxDcElC?=
 =?utf-8?B?UEsrMjVlbVdtOC8rMktTeGVNdFFOTkNmNnJRcWorUTh6N09SRmFKZTBFV0Zz?=
 =?utf-8?B?NjBrdGNCakpXS1YzRGwxM0xpZHIzT3M1NHdWeEllaGJaaXBzMlRRT1lsNy80?=
 =?utf-8?B?SE9HaE1FbU9PaHJUWWcrT2RYVzVPRzFDR3FUWHI0UlY0UFd3RTZzbFNpay9U?=
 =?utf-8?B?WVIyUHJoTFY3aWpnVWJKRGNHWXVkVDlGYVdPME1xRlZuTW1DVUZrSU54OUZu?=
 =?utf-8?B?bWZlUFVzTU92UWpsL2NqR3VsN1FxcjZXemNwODNlbm83OUdPeVI0THcxVUE1?=
 =?utf-8?B?STVHTGdVdTd1MEtIdFZ0aSs3NGl3SVRGZ2ptTy9rQjFqVVlUbVIzMGZqQUtl?=
 =?utf-8?B?Mnk1RHB3dng3eStoRzkwejlXV2JtM1Fqc3duditxODV1VUhYU2wySjVYYjgz?=
 =?utf-8?B?Zjd2TEk1U1dRYnhwMHRWdmFLSmdyRlpQUDFsTlpwaXpQZXlySUM1RDVuMnps?=
 =?utf-8?B?U2lobmRDanNzU2V3cXY1NS94ak4yVWhBbTFqb0FaeHd1RWdabTBXZEs5bnBE?=
 =?utf-8?B?MnhGRm12Nzcrd2JMTm9UQU1QS0xsVlZmOTFOVjJJWmk4QTlPL0x5OTg3YU94?=
 =?utf-8?B?VUZ0Y2Z1RTVra1hFRHh2WjlIOUFPN0cxWUhWeUxKQlBRczdTSDlhdDk3alFG?=
 =?utf-8?B?cFl4RE53czVRZHhtMEVtbjNzbDJIRk95c2RBTEV0QmF2ODdOS1h3cFdVZGpr?=
 =?utf-8?B?QmFYa1JaSjJ1aEdHLytKUG5MdUVMc1c5eEthWnVSQlBlQzQ5QndtN1pCS3k1?=
 =?utf-8?B?T3JqYXRsQklBMUs3N1phRUI5ODdGR2tEdEM3SkptUWQ2UUo3Wk1nTE1kVWtw?=
 =?utf-8?B?V3UveDVMWHJTRjMzbGlDYy9jaE14ejdFUjJXdDJYTjVMZjNDZ1JDQkNRSEdM?=
 =?utf-8?B?Y2V0dnNJeWJRZDBkZ3JuRHNhSUJKczIvV1k0L1plejVySmtVbFB6UVZJbE0r?=
 =?utf-8?B?Z3RuejBud2hxWk85UUtGN0VlajZneUphcTFqZHJyWStOR0JzZnFkM3ZQaEZY?=
 =?utf-8?B?bTBFTU5TWkxZcWJTYkY1enZiLzE4U2ZOaFlEM2ZVSld1WFJvYVhRYXZJOWQ1?=
 =?utf-8?B?ajhHRU5yZlFHWHdFOFczMVpzWmhGNnV0MmVWLzA4alUzSzdiWFJUSzlBaW56?=
 =?utf-8?B?QzQ1QU9IQm5WREMvT0RFRnJ4VVpaWjg0bFVnZjMzWVFhczlmVU5xSE9qSUtq?=
 =?utf-8?B?SzNRbm9RZnhZazFJeklqZW12UDViTFNkaVh3TTFzd1Z4eDJYZnRLUGUxSjNq?=
 =?utf-8?B?YjloRENYK25oVU1zclYzRjdmZ3pkbWV0Y1Bqc3VyWElSN1Mzc0dCQndtZi9W?=
 =?utf-8?B?L2loWXZCMlhKTDNWQkZoSDVwdmg5L3pNWVpacTY3TG11cmpQZXlXMHozOXNO?=
 =?utf-8?B?M2RrUnNZMFBqWFBRM1hkRERDK0E2WTltcW9wNXZmeG5vRUFFdG92TTJDMHRh?=
 =?utf-8?B?eW93UnN2aFV3Q2pGOHQxMWMxMnZGdDlNdVdoWGtOUVhJNGpneUdvVUdRUkRs?=
 =?utf-8?B?WW12WDRpd3RKb2kzMWNyNUJzOXR4TWt5Tithb0lHZmxKTHpLSmlqWjhHM3VH?=
 =?utf-8?B?Y3N5S0hLemdNWDFNb3hENUxXNkFJYllDOHFxL1grSVludmZuVVNFUjc1SVJL?=
 =?utf-8?B?TnpSTEpDTDZoNlhjVnNrNTI3cDlwQ1lscVcvYjg5VDQ5clB4MkhJY2xPcFhN?=
 =?utf-8?B?Q1NMVi9XWVRPTkp3dXJKZFJlbmw4SUVOcXRSVFFRVCtrMnFITUdqRzdwTk1V?=
 =?utf-8?B?cGZObVZ3aFBkRVR3aFludi9FcWl1RmpKTEp1dFJjREN1LzdwK3dMRnRUL2lG?=
 =?utf-8?B?aTk0WFFYQThqWlppZnBZdTY2NmtzUWdwS3RWWlNiVWJ1eG5rUGx4dU9XNnJ1?=
 =?utf-8?B?dDk1VkR4Unlqd0tRSWRSWWpzOTEvVC95MTFVcjA3SmVHTzZkNnl3NTlVMkFn?=
 =?utf-8?B?MndudFRwUGlZMFdXbjN4aVhFU2VpSDdSRHY3eng2RjZLeWRJdkZDRFNQekIz?=
 =?utf-8?Q?LpBGjI9kNsgxMG2y1zKPIxbSB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 089c8863-a515-45e9-4d3c-08d9c632724a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 16:37:01.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYYctuHn8MZBQS3h8MZl4WsCR2tFjdpWLuSU3hLPUQcOEkRIUHH4fAi2KhfdnGoX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4904
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: iXjOBnqtdUUZJsuDDl8H_r-b_t09X6vJ
X-Proofpoint-GUID: iXjOBnqtdUUZJsuDDl8H_r-b_t09X6vJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230088
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/21 4:02 AM, Hou Tao wrote:
> Hi,
> 
> On 12/20/2021 11:00 AM, Alexei Starovoitov wrote:
>> On Sun, Dec 19, 2021 at 01:22:42PM +0800, Hou Tao wrote:
>>> Hi,
>>>
>>> In order to use string as hash-table key, key_size must be the storage
>>> size of longest string. If there are large differencies in string
>>> length, the hash distribution will be sub-optimal due to the unused
>>> zero bytes in shorter strings and the lookup will be inefficient due to
>>> unnecessary memcpy().
>>>
>>> Also it is possible the unused part of string key returned from bpf helper
>>> (e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
>>> the lookup will fail with -ENOENT (as reported in [1]).
>>>
>>> The patchset tries to address the inefficiency by adding support for
>>> string key. During the key comparison, the string length is checked
>>> first to reduce the uunecessary memcmp. Also update the hash function
>>> from jhash() to full_name_hash() to reduce hash collision of string key.
>>>
>>> There are about 16% and 106% improvment in benchmark under x86-64 and
>>> arm64 when key_size is 256. About 45% and %161 when key size is greater
>>> than 1024.
>>>
>>> Also testing the performance improvment by using all files under linux
>>> kernel sources as the string key input. There are about 74k files and the
>>> maximum string length is 101. When key_size is 104, there are about 9%
>>> and 35% win under x86-64 and arm64 in lookup performance, and when key_size
>>> is 256, the win increases to 78% and 109% respectively.
>>>
>>> Beside the optimization of lookup for string key, it seems that the
>>> allocated space for BPF_F_NO_PREALLOC-case can also be optimized. More
>>> trials and tests will be conducted if the idea of string key is accepted.
>> It will work when the key is a string. Sooner or later somebody would need
>> the key to be a string and few other integers or pointers.
>> This approach will not be usable.
>> Much worse, this approach will be impossible to extend.
> Although we can format other no-string fields in key into string and still use
> one string as the only key, but you are right, the combination of string and
> other types as hash key is common, the optimization on string key will not
> be applicable to these common cases.
>> Have you considered a more generic string support?
>> Make null terminated string to be a fist class citizen.
>> wdyt?
> The generic string support is a good idea. It needs to fulfill the following
> two goals:
> 1) remove the unnecessary memory zeroing when update or lookup
> hash-table
> 2) optimize for hash generation and key comparison
> 
> The first solution comes to me is to add a variable-sized: struct bpf_str and
> use it as the last field of hash table key:
> 
> struct bpf_str {
>      /* string hash */
>      u32 hash;
>      u32 len;
>      char raw[0];
> };
> 
> struct htab_key {
>      __u32 cookies;
>      struct bpf_str name;
> };
> 
> For hash generation, the length for jhash() will be sizeof(htab_key). During
> key comparison, we need to compare htab_key firstly, if these values are
> the same,  then compare htab_key.name.raw. However if there are multiple
> strings in htab_key, the definition of bpf_str will change as showed below.
> The reference to the content of *name* will depends on the length of
> *location*. It is a little wired and hard to use. Maybe we can concatenate
> these two strings into one string by zero-byte to make it work.
> 
> struct bpf_str {
>      /* string hash */
>      u32 hash;
>      u32 len;
> };
> 
> struct htab_key {
>      __u32 cookies;
>      struct bpf_str location;
>      struct bpf_str name;
>      char raw[0];
> };

This probably work. The tracepoint has a similar mechanism without 
string hash. For example, for tracepoint sched/sched_process_exec,
the format looks like below:

# cat format
name: sched_process_exec
ID: 254
format:
         field:unsigned short common_type;       offset:0;       size:2; 
signed:0;
         field:unsigned char common_flags;       offset:2;       size:1; 
signed:0;
         field:unsigned char common_preempt_count;       offset:3; 
  size:1; signed:0;
         field:int common_pid;   offset:4;       size:4; signed:1;

         field:__data_loc char[] filename;       offset:8;       size:4; 
signed:1;
         field:pid_t pid;        offset:12;      size:4; signed:1;
         field:pid_t old_pid;    offset:16;      size:4; signed:1;

print fmt: "filename=%s pid=%d old_pid=%d", __get_str(filename), 
REC->pid, REC->old_pid

So basically, the 'filename' field is an offset from the start of the
tracepoint structure. The actual filename is held in that place.
The same mechanism can be used for multiple strings.

The only thing is that user needs to define and fill this structure
which might be a little bit work.

> 
> Another solution is assign a per-map unique id to the string. So the definition
> of bpf_str will be:
> 
> struct bpf_str {
>      __u64 uid;
> };
> 
> Before using a string, we need to convert it to a unique id by using bpf syscall
> or a bpf_helper(). And the mapping of string-to-[unique-id, ref cnt] will be saved
> as a string key hash table in the map. So there are twofold hash-table lookup
> in this implementation and performance may be bad.
> 
> Do you have other suggestions ?
> 
> Regards.
> Tao
>> .
> 
