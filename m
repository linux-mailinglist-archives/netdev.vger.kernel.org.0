Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E27118F7B7
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCWOwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:52:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29462 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgCWOwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 10:52:21 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02NEeG5u006812;
        Mon, 23 Mar 2020 07:52:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1ZxjZAQzRVu+7l4bl1cDwMRf9G9F1kgLWFUulN0R518=;
 b=ZfaGjb6Opq0b/XgZQ/M9fMWL2qf2JuCDTn50p70+Tg/a2uBg8p53Gf6hq9Ff0hKZpuUd
 5wbv1NgGT5CIUeRB7+vQ0ricBaw2r5rrYdwOJGmgEY4wTOTnn8KtRuqiAvIES/9Sq991
 9J6BcZEx74fgwlV4A999zExNunzh5hA++ps= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ywgekr6wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Mar 2020 07:52:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 23 Mar 2020 07:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAqHOCuyeepEjsZhBVWxrLywIbNIhMBfy+nB6dN3dufqCZhNbyb1Pe6M97USrQRziOeyHfBpmH4nvDAgsVfI3ZcSbTb8wIp7Jcg23AX42+5UWFrgNzCXxgDJTUrSQUNMLVv3hYYplHO78A9K15cyNwb5I/eQ4Fn7ZxkD0IcT5j1aYy8RVO5KSU0teCsy5MzrWcHbUQn8Xy85H1jKeKv3VypalAmYTuACeyOsCRfOCZZSAVrg4aIEshDmX7ARIv2mIwZCw8/5kVGyiL4AKTVBAwyAYuTL+kJGej83tlVCUsElMU02DaEjpeBRlvH5odXNwDKT+nHMuCVXpLJzsAzhrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZxjZAQzRVu+7l4bl1cDwMRf9G9F1kgLWFUulN0R518=;
 b=FeC/9QkvodUYKZPKEzcGzjIpC/1dppDVb+dmbdfA3uFGQu7iPWGvml8RBe/x+2OHD4aQEKiVVtUYD0zdUAbzPjVBSUPze66nRVkUQPXT1dIf6zLTxCi+V3oHFM1seionSQKYhYhIGo7Re1RX/YOWQPdMQcL3Fv86b8fMD6sU1uYQrVeOn7+aUwEDIU0Tzj2T/u/0Dz7euYLeJ3j1z7bImee8xr1vEYN4doLBVu4sZ0oQOlGl0vBbzJNlAuqaUiX7wsRx0IgUkZKdFbfeBJbrD8wZNwyLPd1rEb2GWjLlIAQaKuN6+BjnxuJNdHt7lFv56+VJuDENbuQY8J0SLdKwNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZxjZAQzRVu+7l4bl1cDwMRf9G9F1kgLWFUulN0R518=;
 b=bYNWi+/pitDGTkhXm5Ulb/A+QrnVNIF41G9irGcWbiQoB7Z1jev+ll5kaD3ZRH7CvY0cc73aFLXZRzo946OWPETHNZKT7EqBOo/GVQLpas37C39vIkWApxDuKf7/hHxW/xMw9T3oFxorDPYNR1HzjgtYisomvfY87Ulp2hWH2i8=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4060.namprd15.prod.outlook.com (2603:10b6:303:4e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 14:52:04 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 14:52:03 +0000
Subject: Re: [PATCH] bpf: fix build warning - missing prototype
To:     Jean-Philippe Menil <jpmenil@gmail.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200322140844.4674-1-jpmenil@gmail.com>
 <b08375c6-81ce-b96d-0b87-299f966f4d84@fb.com>
 <20200323074247.wdkfualyvf3n6vlo@macbook>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7c27e51f-6a64-7374-b705-450cad42146c@fb.com>
Date:   Mon, 23 Mar 2020 07:52:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200323074247.wdkfualyvf3n6vlo@macbook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:300:4b::31) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:2131) by MWHPR02CA0021.namprd02.prod.outlook.com (2603:10b6:300:4b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Mon, 23 Mar 2020 14:52:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:2131]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30158b9-e108-4a54-ae42-08d7cf39bfdc
X-MS-TrafficTypeDiagnostic: MW3PR15MB4060:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB40608DD85E10696DB8FA69A6D3F00@MW3PR15MB4060.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(376002)(39860400002)(346002)(199004)(52116002)(4326008)(8936002)(316002)(6512007)(53546011)(6506007)(81156014)(8676002)(36756003)(6486002)(5660300002)(81166006)(16526019)(54906003)(186003)(2906002)(66556008)(66476007)(66946007)(6916009)(478600001)(31686004)(31696002)(2616005)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4060;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrH1sfXX+32vzUFIefgRyO2wPQysjYaAvLPHSx80u6ZOeYbVdJcxYvoGDiQAu6i1bqARhHRCHMsgwCbY14O8Nlkhx5jt84I6KrA/iHFiAHjbNS1Fd/OQ9hLE59lHruvhWO4QDVDRJbKlzz1+swz+6CvJl12uVf/BHUwDwwAkgn8U2y/4mJa5qPzoNFLuyJjr3HancQURUguuUOQyKR3y77XUsBBTsqtwJfS1fu/Ix+T4a0QcLmBtEWZxjQaqRoZ3XYjAhqsLuQpAKaHpB17cUzaRanKzXGC7MHYrmGMIv1Kame2KVlnaB2r3S82D2SMkDAxv8/IZq1NRdiDi5K9V3HSd8HcwbOlE1mMc13HgZpSzWF2/4WxYmRQ0n5FfHanYGT4rWhZ3+XYOvYPbAs31g4gZGg2BwsFnprfrzktTIFUsdmgp7Nat9TCxWU4blmCy
X-MS-Exchange-AntiSpam-MessageData: Asv98byATP1oXQsowzFVvoKBqWRH768SsxW896bpbQnFSr+Ypo49eHbmZYP2AhbiW+RYtuly+YuOpcTTaeWsOj6aIRu686YHAmP4a87iaRBkX360boyIYyfU+MSg+f5/lETBrq6JIurWv6vqMqm7Rns9Hkb66FCtpwgJnq57E49V7tFWfj2XUt5IU7zWJ/nN
X-MS-Exchange-CrossTenant-Network-Message-Id: a30158b9-e108-4a54-ae42-08d7cf39bfdc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 14:52:03.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yojw0Z7Ffm5BV5IYtvNPJ6fUTKX/GoytKIy1Y62S8cr2CRdEd/2chxZHRwCT8zAg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4060
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_05:2020-03-21,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003230085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/20 12:42 AM, Jean-Philippe Menil wrote:
> On 22/03/20 at 10:32pm, Yonghong Song wrote:
>>
>>
>> On 3/22/20 7:08 AM, Jean-Philippe Menil wrote:
>>> Fix build warning when building net/bpf/test_run.o with W=1 due
>>> to missing prototype for bpf_fentry_test{1..6}.
>>>
>>> These functions are only used in test_run.c so just make them static.
>>> Therefore inline keyword should sit between storage class and type.
>>
>> This won't work. These functions are intentionally global functions
>> so that their definitions will be in vmlinux BTF and fentry/fexit kernel
>> selftests can run against them.
>>
>> See file 
>> linux/tools/testing/selftests/bpf/progs/{fentry_test.c,fexit_test.c}.
>>
> 
> I can see now, thanks for the pointer.
> I totally missed that.
> 
> So, in order to fix the warnings, better to declare the prototypes?
> (compiling with W=1 may be a bit unusual).

Right, you can add prototypes in the same file (test_run.c) to silence 
the warning.

> 
>>>
>>> Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
>>> ---
>>>  net/bpf/test_run.c | 12 ++++++------
>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>> index d555c0d8657d..c0dcd29f682c 100644
>>> --- a/net/bpf/test_run.c
>>> +++ b/net/bpf/test_run.c
>>> @@ -113,32 +113,32 @@ static int bpf_test_finish(const union bpf_attr 
>>> *kattr,
>>>   * architecture dependent calling conventions. 7+ can be supported 
>>> in the
>>>   * future.
>>>   */
>>> -int noinline bpf_fentry_test1(int a)
>>> +static noinline int bpf_fentry_test1(int a)
>>>  {
>>>      return a + 1;
>>>  }
>>> -int noinline bpf_fentry_test2(int a, u64 b)
>>> +static noinline int bpf_fentry_test2(int a, u64 b)
>>>  {
>>>      return a + b;
>>>  }
>>> -int noinline bpf_fentry_test3(char a, int b, u64 c)
>>> +static noinline int bpf_fentry_test3(char a, int b, u64 c)
>>>  {
>>>      return a + b + c;
>>>  }
>>> -int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
>>> +static noinline int bpf_fentry_test4(void *a, char b, int c, u64 d)
>>>  {
>>>      return (long)a + b + c + d;
>>>  }
>>> -int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
>>> +static noinline int bpf_fentry_test5(u64 a, void *b, short c, int d, 
>>> u64 e)
>>>  {
>>>      return a + (long)b + c + d + e;
>>>  }
>>> -int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void 
>>> *e, u64 f)
>>> +static noinline int bpf_fentry_test6(u64 a, void *b, short c, int d, 
>>> void *e, u64 f)
>>>  {
>>>      return a + (long)b + c + d + (long)e + f;
>>>  }
>>>
> 
