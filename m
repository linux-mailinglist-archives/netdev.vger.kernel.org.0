Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB948719B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbiAGEDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:03:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27192 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345985AbiAGEDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:03:02 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2070v8XB009458;
        Thu, 6 Jan 2022 20:02:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RIb2QBSE3thhbQDBb2w/4oj68JdnYcLXqC2DaAaX19M=;
 b=LF91p6lwEJSDjuslgsuCck/o5udgTPADFNI+XQk9XPNGzkJI8QAg01pK9YbOBwiSgOSj
 tnCDoUiBAxZm+GyX2eQSvCNvpSmuLJF+Pe2VWLAA4CZVJ97xVRWNHW9alBCpfDM7Uenx
 8Oc/rKroY9xvLpRVYcbUvi6WA7xWmSNFi3c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3de4vj3aye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jan 2022 20:02:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 20:02:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRodqd//h3YwutsTSPl+9WsTkbcerIQh73jVkrg3mDxIrmDDEfjSIb9AiKSboMQzk9tYWYs+brNn1qhP/x78XtcjU9k4yp1OSKi2hCEQXy+ZKcJGbem9yxsXLD2TJkZuO7q/t2313GjUfJzYd37SrDVYV/reEjj+2bG6SC0x/1gpCqeFN/3MrKTp/7daV5NUT/jF6adnzgVn1F7hmc1AXywAGegSx2wA5Yt/r78lJ8YeZe/8Et57Ww4oSfXqL6iT4f0vuiHkf5ybsvcTkUjWmtPd6Sc5kESOrhRHLgv16Q8ghtyZiHRcG1OSp8WDMIS+S39dQGzOGFK5EU9qAyraAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIb2QBSE3thhbQDBb2w/4oj68JdnYcLXqC2DaAaX19M=;
 b=niHtpfpDwYTF53WGARYJwvPpqRDiVqaAaHlBbpI9GQMFbH7lJcKUlnZULVVlvGVdyVLRYZW6+EXdLrkBUGk2ZoiIuvTgd/QzSlwewN686zgkjsli2GkQGTXjshBw6H2+PhHgA1F4R/Lmc5tKFJorwv+q8LtdeKNatCgQvZiBB7OGExeX5SiVadR/o3rWMyPUOek0xt7bNMmAWwxbMDagZaKgHQ1kwTt5GyV7qQVZB+bmH80L/0FFpdXHNNk/2TDz3y8q4XhK7rbbAlJF4M4CmdVIoS6Mrx0LnC2MERt1I0C8eJp/wVlbUH7o6pQMpFWq1kNMk7hvjq12ZT4uKjs3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4222.namprd15.prod.outlook.com (2603:10b6:806:101::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 04:02:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 04:02:45 +0000
Message-ID: <eb8b590a-fb3c-efc0-b879-96d03f38c159@fb.com>
Date:   Thu, 6 Jan 2022 20:02:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: A slab-out-of-bounds Read bug in
 __htab_map_lookup_and_delete_batch
Content-Language: en-US
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
 <CAADnVQJK5mPOB7B4KBa6q1NRYVQx1Eya5mtNb6=L0p-BaCxX=w@mail.gmail.com>
 <CAFcO6XMxZqQo4_C7s0T2dv3JRn4Vq4RDFqJO6ZQFr6kZzsnx9g@mail.gmail.com>
 <bc4e05a5-5d97-2da0-0f18-b7fa55799158@fb.com>
 <CAFcO6XMrDkx_eyHx=hRYwmsg0PHeJ78Oyuf1AgD_RYM7FY1CFQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAFcO6XMrDkx_eyHx=hRYwmsg0PHeJ78Oyuf1AgD_RYM7FY1CFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:301:2::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0278ed5-bca0-4def-90f2-08d9d1928f46
X-MS-TrafficTypeDiagnostic: SN7PR15MB4222:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB422211B8C8960410C3FBD454D34D9@SN7PR15MB4222.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSvbBDRuO66PZhMpUAHQb0ZiAjAW/cWd7DjDomaiZIU43D6g/+zEL7Hb5xhGwDPas341Z2ISeI1/9uucMW2wjpMP4HNrYRvFur4Vzq7XUSSuGD/46xPh0YzwOVSzwZH0f/FJwxeeSOtZGfLhveN7ECUyFzCFBmMznMUYKSDgxqwiVptuaGNSOVnCnFQe1/XZu5R92LVFUON2Sb0MGMJHWAdgVT3zeNT8jx1itD5O4eM+sNwjxgig5ZZzFareoJU+ts3hJLlg2QCojHpAF7QWDNZ1aPM+VKnVmAANTSVfuG3TIPZmbw6fj818KgY1s2j1TUUvWMlS8GTjL0XDshPT0tN+KTMcjyxMgKQXcbirqpDGWEHfPrScfTTwxPDsPrS4ZQNvhmtkH23y9dmilSVHfDqMoyQp+ilc1UAMYlMwTqTuw/PoZbYSv88xCFAlpGDlevF2dK4f+ZZ6V37ChPrIvaC13KXztVRBBIJi8cLggEQZmaJ3C5bRgOT4mSAdG264845ecsH69LmOu4O3ajDMBdxIyG8aowdTzF229eR5cmR3adS4pDbmaClRg3uPPQqMdK2kYZe0DqVgeIDELa9HwcGcWkCXH/G3ghr6bWYZiSE6+G7UzKmMY8z1kUcfvmUHfpZ0UOz8pLnS+LjiXTCBSsOCRyRknyJaiI+V8fDM53IcVAQa8StKxo4Bmghc5Tpqw6FwNamdsCAxp62JZsmZchvIBuJArIGBg1a114SI4V4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66556008)(508600001)(52116002)(54906003)(6506007)(6916009)(36756003)(7416002)(8676002)(86362001)(4326008)(8936002)(66946007)(53546011)(5660300002)(83380400001)(66476007)(31686004)(38100700002)(6666004)(31696002)(186003)(6486002)(2616005)(6512007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTViRkhPUTZ0aXZPcjFKaFVRUDZqUkpWb1RTR2JnMXdoU0JrSVQ3MTQ0T0R0?=
 =?utf-8?B?YlcxL0ZFdTU2UXZITkxVTHAycmY0K21HSzFxK1V3OEh0KzZ0KzVSMGRhM3RQ?=
 =?utf-8?B?VmxpdEszb0RWWVpoN2tKa2hhaXZYQ2tTbEFMWm1BNS9ORklWRjMwUDRmQ1o1?=
 =?utf-8?B?dVRDdUNoWkEwZk9EbmdJVUw4MEFPemZicVFIM1p5dGtHZ3JnbDBKQ0dyTHl3?=
 =?utf-8?B?MHBabGUzNkhKZkJjSklxdTdWa0Q1Z1ozR2RNRDF1MDlqc0Vkd0RxTFlIL3kv?=
 =?utf-8?B?WUo3LzRmQTdISlRrN2tPY0V6cXU1MlRUbTY4MTh2b3lNUHFKRFgvQWhieXAr?=
 =?utf-8?B?eHNwejVIL3NPNUsrUGZxeTJiY29XWFJSUVBDd3lXUHhsSTR3ZytXTHZTNkd4?=
 =?utf-8?B?LzVpMmQ5MjFFL3RBaVZIWU5sVjN2aGpkVmplSlI0MkcxTDYrdW8zN3UweXNU?=
 =?utf-8?B?aTRtSmovRVdGVVEyNU55a0ZPOFd6eFFRVlNDNXVtLytUSlppVGZxVzM3L2p5?=
 =?utf-8?B?eGtpcm1ZaFBZRWRrY2l6YmtRTmZoMnZYUURjemdUVTNzZGdsV3NYNmMxUkh2?=
 =?utf-8?B?VTZpaVZ6ZGJWZjBmaXNlZTB6cE04dVNXeHQ0WVZDRzF3NFhkdVMwNzVhdk1U?=
 =?utf-8?B?SnlxdG8vSk9TVnFsSXJTM1U2SDZ5YVVSZ2c0V0lUaENkYTh0cEU1Mk5KV0Vo?=
 =?utf-8?B?SUluRXZxeitCOE5SQ3piejNSZW8vZkY0Q1hjbHkzdWdzMU9ndzRIa1pQd3Bm?=
 =?utf-8?B?WWpvQkI5cXlBbmFpcXZoNGhuVHBOTEpJNG5WRzduUnBrYUxIODNSSnRmdUhG?=
 =?utf-8?B?bkNZWVRZZi9lTk80WlR5ZUxEVHdzb2ZRQzBsMldGRDFxUGVZV3ZGUUxJZHRG?=
 =?utf-8?B?NFNCcFMzaGg5cWRCRlk1SURSNC9CaUNFSVNwaFBiQU5VYWhuK1NvUGxGZkRm?=
 =?utf-8?B?NmhkNVpUb08vREx0eDB1Mkh0c1Y4dlFER2dpQ0hjSVVmSXpVRlp0VCtDNzFF?=
 =?utf-8?B?OXJvNHVSdlp5eVczeGZXNU1PamRldlJ5OG5nOXVEdnQ5SmxYOTRRVEtKQjhY?=
 =?utf-8?B?NCtiRUhSTmxpY2EvbXduMUl0dCsrRUw3MWs4QmppM0lDN3FBRmM3UG1YYzRH?=
 =?utf-8?B?S1pKbkZrYzlxQ25xWFBxeXpXblRhWm1ycXJ3NlMwSERnL0xBTzEwTSt6MFlW?=
 =?utf-8?B?aDl2UmR6SVhkaUdhVXpXV0VxZTNCRXZHM2plUTM5YUs3NGJVdkcrbmp4ZnJP?=
 =?utf-8?B?NFNGa2tOZW00R3FSaldnR1lhMVk4OGdiTWFsZEZqU2VxdkNZZFB0MW1icDk0?=
 =?utf-8?B?QVlSYy9XcGxlSVRCR3dlTDBENjVpK1VlNENNYjdBSlQ4aVpSK3pMcFJuVFM1?=
 =?utf-8?B?S3RDdmV1c2xYaDRkUVgyWTM4UTAvN1hQajdLSFJJc2QwL1g4WnhmdVUyTUNn?=
 =?utf-8?B?V3I3dFNsbGdHSm1OVnZYamN5RlJFM1Njb1JyNklRUFJZTW8wNFJQSys1cEVG?=
 =?utf-8?B?RTMyTzN1TEE1M1NURzFmWnM5TjF2ODNvWWFwdDNpeUJJcWloZ0FDWkh2dWNk?=
 =?utf-8?B?dkx3cFRiTDFLb0NXYmZTTC9mQWtScm9ZcUtMZzBZcTJNcnh6ekUvMnc2WWNP?=
 =?utf-8?B?Z01ZTnpaS0xMWnFXYThrUGJjK1ExZVJCcWN5TVZMNm12dTZjb010WnJZV2Mw?=
 =?utf-8?B?LzIvQ1F5cEgyVUkyemwybUl6VTlPeFV3UmNOdXNiVjhVNmdXRThVUjdlbnBF?=
 =?utf-8?B?RlNiYjAwNVdzbmVWNlFWb3lrb2lVd2lxaEZLRWU5MG0ycWJyRVd4VGZoSUxX?=
 =?utf-8?B?TCtsd013N21NRWtDYUt4N0FZdDYvRTNpRkZyekF2YkU3WU15UnRiUy9BZ212?=
 =?utf-8?B?dmxaemZWOXg3dVo5b1krU1p5UlhkNlp4dUNCdzBYeVVSRFFFTE1vbzkrMDRK?=
 =?utf-8?B?cENxRnc0S3pialdkdXAxMkNYbHNwUTVrQmxQRUx1NkRCb0VDMmpBby85aCt1?=
 =?utf-8?B?aGNpKy9CWjVRN0dra2w3QlZhUElESXAyZXhPZlRYNVRNRDRwbGprR05TMzVr?=
 =?utf-8?B?c2krZW1rZ0F2Nzh6b2hoN0x2UnhvQlFnaXBWTDh1b0x5Q1dGK1FoTnhycXdV?=
 =?utf-8?Q?0YmaFbEWqICIcabyImlSvDhNv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0278ed5-bca0-4def-90f2-08d9d1928f46
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 04:02:44.9926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lfoLrTP6O7uGTlSRdYjCIt7opH3IPDmy0lYHI4jQ1PMLgHh0FF6lGMuSQLbJ+b0x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4222
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KKyF4ihAO98Nm6Y0SOndef9LUtoBvSl3
X-Proofpoint-GUID: KKyF4ihAO98Nm6Y0SOndef9LUtoBvSl3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_01,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 phishscore=0
 clxscore=1031 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/22 7:25 PM, butt3rflyh4ck wrote:
> Ok, I just reproduce the issue with the latest bpf-next tree.

I cannot reproduce with bpf-next tree. My bpf-next tree top commit is
   70bc793382a0 selftests/bpf: Don't rely on preserving volatile in 
PT_REGS macros in loop3

The config difference between mine and the one you provided.

$ diff .config ~/crash-config
--- .config     2022-01-06 19:29:10.859839241 -0800
+++ /home/yhs/crash-config      2022-01-06 19:27:22.262595087 -0800
@@ -2,16 +2,17 @@
  # Automatically generated file; DO NOT EDIT.
  # Linux/x86 5.16.0-rc7 Kernel Configuration
  #
-CONFIG_CC_VERSION_TEXT="gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-3)"
+CONFIG_CC_VERSION_TEXT="gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
  CONFIG_CC_IS_GCC=y
-CONFIG_GCC_VERSION=80500
+CONFIG_GCC_VERSION=90300
  CONFIG_CLANG_VERSION=0
  CONFIG_AS_IS_GNU=y
-CONFIG_AS_VERSION=23000
+CONFIG_AS_VERSION=23400
  CONFIG_LD_IS_BFD=y
-CONFIG_LD_VERSION=23000
+CONFIG_LD_VERSION=23400
  CONFIG_LLD_VERSION=0
  CONFIG_CC_CAN_LINK=y
+CONFIG_CC_CAN_LINK_STATIC=y
  CONFIG_CC_HAS_ASM_GOTO=y
  CONFIG_CC_HAS_ASM_INLINE=y
  CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
@@ -117,7 +118,7 @@
  CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
  CONFIG_USERMODE_DRIVER=y
  CONFIG_BPF_PRELOAD=y
-CONFIG_BPF_PRELOAD_UMD=m
+CONFIG_BPF_PRELOAD_UMD=y
  # CONFIG_BPF_LSM is not set
  # end of BPF subsystem

@@ -8456,7 +8457,6 @@
  # CONFIG_DEBUG_INFO_DWARF4 is not set
  # CONFIG_DEBUG_INFO_DWARF5 is not set
  # CONFIG_DEBUG_INFO_BTF is not set
-CONFIG_PAHOLE_HAS_SPLIT_BTF=y
  # CONFIG_GDB_SCRIPTS is not set
  CONFIG_FRAME_WARN=2048
  # CONFIG_STRIP_ASM_SYMS is not set

The main difference is compiler and maybe a couple of other things
which I think should not impact the result.

> On Fri, Jan 7, 2022 at 9:19 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 12/29/21 7:23 PM, butt3rflyh4ck wrote:
>>> Hi, the attachment is a reproducer. Enjoy it.
>>>
>>> Regards,
>>>      butt3rflyh4ck.
>>>
>>>
>>> On Thu, Dec 30, 2021 at 10:23 AM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Wed, Dec 29, 2021 at 2:10 AM butt3rflyh4ck
>>>> <butterflyhuangxx@gmail.com> wrote:
>>>>>
>>>>> Hi, there is a slab-out-bounds Read bug in
>>>>> __htab_map_lookup_and_delete_batch in kernel/bpf/hashtab.c
>>>>> and I reproduce it in linux-5.16.rc7(upstream) and latest linux-5.15.11.
>>>>>
>>>>> #carsh log
>>>>> [  166.945208][ T6897]
>>>>> ==================================================================
>>>>> [  166.947075][ T6897] BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x87/0xb0
>>>>> [  166.948612][ T6897] Read of size 49 at addr ffff88801913f800 by
>>>>> task __htab_map_look/6897
>>>>> [  166.950406][ T6897]
>>>>> [  166.950890][ T6897] CPU: 1 PID: 6897 Comm: __htab_map_look Not
>>>>> tainted 5.16.0-rc7+ #30
>>>>> [  166.952521][ T6897] Hardware name: QEMU Standard PC (i440FX + PIIX,
>>>>> 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
>>>>> [  166.954562][ T6897] Call Trace:
>>>>> [  166.955268][ T6897]  <TASK>
>>>>> [  166.955918][ T6897]  dump_stack_lvl+0x57/0x7d
>>>>> [  166.956875][ T6897]  print_address_description.constprop.0.cold+0x93/0x347
>>>>> [  166.958411][ T6897]  ? _copy_to_user+0x87/0xb0
>>>>> [  166.959356][ T6897]  ? _copy_to_user+0x87/0xb0
>>>>> [  166.960272][ T6897]  kasan_report.cold+0x83/0xdf
>>>>> [  166.961196][ T6897]  ? _copy_to_user+0x87/0xb0
>>>>> [  166.962053][ T6897]  kasan_check_range+0x13b/0x190
>>>>> [  166.962978][ T6897]  _copy_to_user+0x87/0xb0
>>>>> [  166.964340][ T6897]  __htab_map_lookup_and_delete_batch+0xdc2/0x1590
>>>>> [  166.965619][ T6897]  ? htab_lru_map_update_elem+0xe70/0xe70
>>>>> [  166.966732][ T6897]  bpf_map_do_batch+0x1fa/0x460
>>>>> [  166.967619][ T6897]  __sys_bpf+0x99a/0x3860
>>>>> [  166.968443][ T6897]  ? bpf_link_get_from_fd+0xd0/0xd0
>>>>> [  166.969393][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
>>>>> [  166.970425][ T6897]  ? lock_acquire+0x1ab/0x520
>>>>> [  166.971284][ T6897]  ? find_held_lock+0x2d/0x110
>>>>> [  166.972208][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
>>>>> [  166.973139][ T6897]  ? rcu_read_lock_bh_held+0xb0/0xb0
>>>>> [  166.974096][ T6897]  __x64_sys_bpf+0x70/0xb0
>>>>> [  166.974903][ T6897]  ? syscall_enter_from_user_mode+0x21/0x70
>>>>> [  166.976077][ T6897]  do_syscall_64+0x35/0xb0
>>>>> [  166.976889][ T6897]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> [  166.978027][ T6897] RIP: 0033:0x450f0d
>>>>>
>>>>>
>>>>> In hashtable, if the elements' keys have the same jhash() value, the
>>>>> elements will be put into the same bucket.
>>>>> By putting a lot of elements into a single bucket, the value of
>>>>> bucket_size can be increased to overflow.
>>>>>    but also we can increase bucket_cnt to out of bound Read.

But here bucket_size equals to bucket_cnt (the number of elements in a 
bucket), bucket_cnt has u32 type. The hash table max_entries maximum is
UINT_MAX, so bucket_cnt can at most be UINT_MAX. So I am not sure
how bucket_size/bucket_cnt could overflow. Even if bucket_cnt overflows,
it will wrap as 0 which should not cause issues either.

Maybe I missed something here. Since you can reproduce it, maybe you can 
help debug it a little bit more. It would be even better if you can 
provide a fix. Thanks.

>>
>> I tried the attachment (reproducer) and cannot reproduce the issue
>> with latest bpf-next tree.
>> My config has kasan enabled. Could you send the matching .config file
>> as well so I could reproduce?
>>
>>>>
>>>> Can you be more specific?
>>>> If you can send a patch with a fix it would be even better.
>>>>
>>>>> the out of bound Read in  __htab_map_lookup_and_delete_batch code:
>>>>> ```
>>>>> ...
>>>>> if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
>>>>> key_size * bucket_cnt) ||
>>>>>       copy_to_user(uvalues + total * value_size, values,
>>>>>       value_size * bucket_cnt))) {
>>>>> ret = -EFAULT;
>>>>> goto after_loop;
>>>>> }
>>>>> ...
>>>>> ```
[...]
