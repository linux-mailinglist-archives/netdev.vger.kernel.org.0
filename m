Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6E12D0981
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgLGDkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:40:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29768 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLGDkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 22:40:06 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B73SHol031925;
        Sun, 6 Dec 2020 19:38:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=atQosZhq71m48NiaMRCaP38+6ADpXcs+VsJRsRU7eBI=;
 b=jQ7m28TD50ebGr+iYtUUN+dI1CVqZigxSCQqSPDhtvd4rlyR5ugJIJ+hwQSOCHN8Prc5
 5TOjbqhs8NbGAPo128jbd4oOV0XVZd6AYMdmIUjSDzeTkVhTb7j3s57LocvW4TN6quJB
 8VVr9hOJvArmjGyou0kuUv6Xx4UAHBP7PzI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3588wnwnvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Dec 2020 19:38:32 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 6 Dec 2020 19:38:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7TrqvtL6Sifef6zqCRmkE7uzMAgRKcLYki/YoooeAOWzagftguy6B8ML+bhxape+gVHf6PMq6fgMMvrKnnA+CDmutWBQxOSjOdla+4h7Q6nv7MsDFlZRbgjx7cMDHX/1uGtvcUgawu5Jb4UAUiMXe8iB2V0anXv05kcUp+iFEy/kIYJRhDJ4kQ0kem31dbsrD8Rkj57WI38zK51fwbTvKsuCxtoRI3RIwWgkiGqZqPP/no7lP/c/uy9Ah8qW7+G5GrFS7K39t3kNxWQIev44FTTkfnrTQAbskfEJYMAT2LcHNxfimtrOfNvcObaifvSvlPfCyosSERdCb4yahrcKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atQosZhq71m48NiaMRCaP38+6ADpXcs+VsJRsRU7eBI=;
 b=baXlsNcSnj83rGB/dCLN2gYkoAe5makWE+TELB4eTm/ZKpH9FpehcJv5ilXr12nUkQlkEwAAaJ3l1Vqz/HPgkFjeRPol8q4z1C+DzkrB1hmXVolOG2fulTKus96LrcJTXEfVXgBikkKVAQl5QUIlDuQQPf3SHp6TBHr+GDuw+S35hAO5fAdzwPZEo8ORpbiWV2GfiwWbkjcJH04sFbd7ZCTzPc/TeyZcNPJavGfSMgG8hpAHn3pSta4otCELmqSrR/PHOeXP6hkVdE7kCo+q+JDj2k3czAvvkQuj5Lpd/zNVuN5hHZ0miA/scKV/zDp/bPYB2vR0CY11jZBqhcUYSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atQosZhq71m48NiaMRCaP38+6ADpXcs+VsJRsRU7eBI=;
 b=I1WZwMb/xVN+hwLVujYCrNMq/QpyUi/5+9LCkdq0oOlI81da7cXWcfIHMI9Ri1UsJF2jmi/DfiNorJ7CPfCkS1Wa2vlMmcvqfB4ijTEk/ICT2EtzG99ub6945Uj/scq2MmPueHzs198gHPVbqjPv1FrklhEkV79sxDmN0tV+Cqw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3302.namprd15.prod.outlook.com (2603:10b6:a03:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 03:38:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 03:38:30 +0000
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display
 helpers
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <quentin@isovalent.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <shuah@kernel.org>, <lmb@cloudflare.com>,
        <linux-kselftest@vger.kernel.org>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
 <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
 <alpine.LRH.2.23.451.2012060038260.1505@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a17e79e9-5db1-9ff2-6ffc-71249e7ae3e8@fb.com>
Date:   Sun, 6 Dec 2020 19:38:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <alpine.LRH.2.23.451.2012060038260.1505@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:209a]
X-ClientProxiedBy: MW4PR04CA0167.namprd04.prod.outlook.com
 (2603:10b6:303:85::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:209a) by MW4PR04CA0167.namprd04.prod.outlook.com (2603:10b6:303:85::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 03:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5acbf51-c8e9-4a17-707b-08d89a61909d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33029D39FE61192C3D9BCFA0D3CE0@BYAPR15MB3302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zM+6Lm0AQupkGmJuTLVzwh8einsMKi/XRK8DZGY5ubHykPK62IDWsKeSefo4KDVaZaslcXOVVQ4BCLG7/aynkkciWiVsqjgE6MFPBq98TsbSGPHWOMX1jlY80yEs90/Wvsx/eDb+EuX/9yAHbnHieuAvFNLfzkGnupDAt8GU3lS/KvGvhTkENtabeiUKLdeNZNvKKuzfHViHOENQa4OeYnL4M8QHl7b/7Jba9cusn0S5ZvRIc1RMpWfA3RmEPPiPY4C8k94z1SEcutxQWvr4oBKRpOY2Zm8QsWNCD9wisXGV/vKvCdWjZI+ldHXV9XQ7XryPXv4UIEOSCf4HJ+ZawG45T0cYzEWCWCiVjyPP95xNrwwhzZVCZH0mcBmV/6vSiix0xoH35owJKs8lVDJFuVVPmkVefnOrZcpAzh9s+lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(31686004)(316002)(86362001)(5660300002)(7416002)(6916009)(4326008)(36756003)(53546011)(8936002)(31696002)(16526019)(66556008)(478600001)(83380400001)(66476007)(66946007)(8676002)(52116002)(6486002)(186003)(2616005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1NVQ2RuZTIvQzRhMEhrNUtoMnV4b1BNNDRBTk15QXJnV20vQUVmWkdZbnd2?=
 =?utf-8?B?aGFlNndNdDhqNlgwZk9BY0dJMll5c01uY1V1V09tSWt1R1p3OGR2MXhOdDBh?=
 =?utf-8?B?UUFpSm5kYVh5dk1SREJjTEZEcmVBL1hic0NvYXRldlJjUGRFLzZzRmVIbC9l?=
 =?utf-8?B?SXkxZ2pzcjZCeW1CTVlFTngrbXdIS1Urdkd0YUxndlMyTnFRMjFjME5zWERE?=
 =?utf-8?B?VENTRTBUTjJoNjZjYnVSV2tOVzl3TnNqaEF0YXZza1ZnMEw0aXpPRzh0dm4x?=
 =?utf-8?B?dndDbjB2Vzl0VDNIcG82a084R2FUNG1aRjBWWE5lUmRTMUE1Ty9rL29ybERq?=
 =?utf-8?B?N25WbGJFbzFhSVltNm56cEg5bG84bVg5Y0FxV1JPWnlnRjVpOTQ4a3JweFZn?=
 =?utf-8?B?RlNOdDl1Q2puUFZva0pXeGg4U1V0REYxRHlCKzdiSFhkQU5qUHRub1V0Vit1?=
 =?utf-8?B?aDlGMGxGUjhuOEcvU0ZqRnUvU0grbGlkUlYwR0pKN3l1TU5zQWM1MERRMitF?=
 =?utf-8?B?djIxL3ZhYWlRMDkxTWZlQ0JBVkNSRXJ0KzF3T2h1akpUYSs3N0JFK3RpSFBT?=
 =?utf-8?B?bjBqUml0QktqQUEwSS9WMlJnWi9MWlhQUDRzTDVmY2h0eDZTOVMyNjBhaVB5?=
 =?utf-8?B?VmZ6dTJZNVN6ZWtiZnNLSlRpUEZncVhqdEpyUi9icTEyRXJJNWVNN2kxQUpk?=
 =?utf-8?B?Kzg1SzVWekJ3MEVBOHk3b0tIVXRhcTkzc1hQTjl0NFgza0c1ZDZIK3ZYMk02?=
 =?utf-8?B?UUw1MzBPa2dIdEJyVWh3QVZBclJyandsaFpuTHUvZnBKYTJadld6dGo3R0Vw?=
 =?utf-8?B?RnNmeThRenpnb1drTHNwRjFnRXBkWjZvRzNzcEJPL0RxbklOMm5ub2kwM0I3?=
 =?utf-8?B?Z3ZLbUhLZjFyTDdYWnJxbVJKSzFROWRVaGdBUVlWblVLK09HRXIrbGNidS9o?=
 =?utf-8?B?cXlUVklyS0cvN2VXenA3ZDFXQS9VREpMY3VaNHkyT1c1MXlWdjZyZkxiWUNa?=
 =?utf-8?B?RUtGb25uMldxdE93d3pqZ0tqZ1NtVFE1cDNGZjhTMnFBSUJsTitWUFpYdWxm?=
 =?utf-8?B?ZCtqYXdGZVBZajA2VlFXVDlsZXZjd3BkUDVMVFkyYmpnRGx2K1BvQStuaU42?=
 =?utf-8?B?bzdseE53YU4waElEZ2VxL2V3eVRlTEh5MC9aa0VMYm1jY1FkUlRNNHFRTksx?=
 =?utf-8?B?Tjg3RkxmUE1iS0QxRDl4VzJZdWFRR0JUSjcxSmF5K044b09aNC9WeGZKb0Iw?=
 =?utf-8?B?TXFuNkYvZksrUGdBcjg3dXVISjU1STZKOTh4Rit6Y2E3TmxtdDVsZTRFSVJ1?=
 =?utf-8?B?U1BXQjVYZ216ci96Mm5aMHQ4dnN4OGFzK3NPQjdRQkZ3b05aNlpzSU1meDJ3?=
 =?utf-8?B?dkxnMEQrSkVndmc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 03:38:30.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a5acbf51-c8e9-4a17-707b-08d89a61909d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+2Gpnc42AM4TU4qy+fSwXWPnN3tZh+P9p7mBIRX+hc78XQW+7s+TYvx0a/W8MIY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-07_02:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012070022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/20 4:43 PM, Alan Maguire wrote:
> 
> On Sat, 5 Dec 2020, Yonghong Song wrote:
> 
>>
>>
>> __builtin_btf_type_id() is really only supported in llvm12
>> and 64bit return value support is pushed to llvm12 trunk
>> a while back. The builtin is introduced in llvm11 but has a
>> corner bug, so llvm12 is recommended. So if people use the builtin,
>> you can assume 64bit return value. libbpf support is required
>> here. So in my opinion, there is no need to do feature detection.
>>
>> Andrii has a patch to support 64bit return value for
>> __builtin_btf_type_id() and I assume that one should
>> be landed before or together with your patch.
>>
>> Just for your info. The following is an example you could
>> use to determine whether __builtin_btf_type_id()
>> supports btf object id at llvm level.
>>
>> -bash-4.4$ cat t.c
>> int test(int arg) {
>>    return __builtin_btf_type_id(arg, 1);
>> }
>>
>> Compile to generate assembly code with latest llvm12 trunk:
>>    clang -target bpf -O2 -S -g -mcpu=v3 t.c
>> In the asm code, you should see one line with
>>    r0 = 1 ll
>>
>> Or you can generate obj code:
>>    clang -target bpf -O2 -c -g -mcpu=v3 t.c
>> and then you disassemble the obj file
>>    llvm-objdump -d --no-show-raw-insn --no-leading-addr t.o
>> You should see below in the output
>>    r0 = 1 ll
>>
>> Use earlier version of llvm12 trunk, the builtin has
>> 32bit return value, you will see
>>    r0 = 1
>> which is a 32bit imm to r0, while "r0 = 1 ll" is
>> 64bit imm to r0.
>>
> 
> Thanks for this Yonghong!  I'm thinking the way I'll tackle it
> is to simply verify that the upper 32 bits specifying the
> veth module object id are non-zero; if they are zero, we'll skip
> the test (I think a skip probably makes sense as not everyone will
> have llvm12). Does that seem reasonable?

This should work too and we do not need to add a note in
README.rst for this test then.

> 
> With the additional few minor changes on top of Andrii's patch,
> the use of __builtin_btf_type_id() worked perfectly. Thanks!
> 
> Alan
> 
