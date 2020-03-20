Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6718D2F0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTPb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:31:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18714 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgCTPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:31:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KFPEM1030106;
        Fri, 20 Mar 2020 08:31:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CrnJfLnMDYChrZYjBZrycjRFL++2TP/CcczkICy+Wxk=;
 b=CB0btDDF+kQfBYzDaFs6zxW4EstDC0Bua/7SOAX1rcoXMgYxiDvwL8P4uMwcVA1aBjJQ
 WjLME0Ytp6fmnRg0wnuRlItrKyv52MyGSu2ce8rtpYNAYZODFg2PMDpe+/vJ0uTEUvBb
 9Gw5EymaXT4WtNeEo6UTUlNzlv1EGlqdhpc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvg25c5dt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Mar 2020 08:31:10 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 08:31:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP+2rQaGzCW/A09XlEftwSdkf8h07jZd24WMxEOckBQMux7RXipJPQxlT+ADVLayUzMMVMeklN8OZAnJXX6ULS8IYfIUdUCwRBGbCuIwMZx9W03BOtkZLfwbNu+5rCu3T8SHwlbRS7hXic/5EnBAlZ7LxTFB8R2ybrb5egCdZDU720BSyCtI6ubiboIa4DoFUbev41KgM57nvqnra9vJemxpOd7wligCap4ls9H8eZbj44Qmk/XsRUDJhRSCcMte9eQuecKEBpBxQAm3Cz+oN2QpLOc1e1PNmT22rspNOjhZynj8sZ/edmFBZdlPJ9TZ6Gx6zFslWqjomRw5CehQng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrnJfLnMDYChrZYjBZrycjRFL++2TP/CcczkICy+Wxk=;
 b=axTEcErMfRcNNPVKuzUoppZ/lOuYhBURfeeUAhvxpocqcfy8PTRJgmMokOye0zVBGR7YV9aDj0JV80BpjEXuvGDjNvP66P3lZdjQm7Qyprf02hldFs7Jy5Gr0fkHYPvzS/BN6tJ1Xy3gLfoMOvtNGIaGAa0Ci7ztJhx8tnDlR6Z4Eom9QNK0CkciUcAGHVSxRCQQjI3wZJG1e8QbT2oIJiC+tCzPKa7F3NnkAjOO75WqgdeJ0RSDivroqZAp1Td078s+UwfdeD9ikLEnO8Ohnca//41tdB/pdrACfwl5zyM3mtqS5cRgXBlHY6Rr8Q2W1g283CVjgSqcjC8w9HYlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrnJfLnMDYChrZYjBZrycjRFL++2TP/CcczkICy+Wxk=;
 b=AVCpnGFFJ85crvE1ogaBWyd9wenHMkTm+rJFf8qeah0GoUMQCpdLiYnK9daXRhNMp8amdkSYWaou9rIyD0HIdq1dhmGrZsK++cztgeuLX05RjOjRSElED1SoCWB0IPlCmmarGuDhPckKqm0BoYz7WWpJCtqUSiLFxqLzqg2nYAg=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3833.namprd15.prod.outlook.com (2603:10b6:303:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Fri, 20 Mar
 2020 15:31:06 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 15:31:06 +0000
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
 <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7bf271b1-4909-d12d-bc65-d18790f7683e@fb.com>
Date:   Fri, 20 Mar 2020 08:31:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:300:103::32) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from bcho-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a280) by MWHPR12CA0070.namprd12.prod.outlook.com (2603:10b6:300:103::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 15:31:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:a280]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde4e5a3-a373-40e9-b6ed-08d7cce3b530
X-MS-TrafficTypeDiagnostic: MW3PR15MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38330C6EB2AB5FB9D910DF74D3F50@MW3PR15MB3833.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(366004)(136003)(396003)(199004)(186003)(2906002)(81156014)(8676002)(110136005)(966005)(66476007)(66946007)(66556008)(5660300002)(66574012)(81166006)(54906003)(478600001)(16526019)(2616005)(53546011)(4326008)(86362001)(52116002)(31696002)(31686004)(6512007)(36756003)(8936002)(6506007)(6486002)(7416002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3833;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5/de+3YFm4Iov2SZizn6ATep0sw1kNcPAnPcQhWZt/t+qTKuL3p3luy4df28L4a7VWshnxUJz0KV9brIK/PGIEePDHBXuhVynBMwrnveyp1sOKO57UWdE6RiKIxHQGj/+34b9KSQX1bTHDINSD0lvQRYwnLqUfZHvLOsQrsft/UIfdV16OWhrxZMt74sy5zAln2i/L/C3k74eQKTMcII3sCwlgacZKAED9x/nUGyz1QfN/MwetwQxDkiKuWEm6MDpWfvPRXNrvaDCFIm2NdoSAJ2J/K+po/7P3wsLutMOqhe38Zfh2mJH4nC0Two7cYj6WbTuhD3yz/lxOE0M+Drr8TpyAtHDnjk1DJ+AynUSce4Ry1mj/t8uOCCxpO9jYEXTCjzBuGa6qzO7wsCSWcv2XiBgs/+OIKnhnCsZIkxmFRHnf8IVQ7pCGCiWiDl74BI/8s4ToEYKIrS5BcZvjyZDmjDpsX9NV5WLHwRgi8xBxtn67OYTbil/uPSwQBoG80IMuMzrTyvLghkVWamecfLw==
X-MS-Exchange-AntiSpam-MessageData: RkNB+CoSBJl1tBY7pWliQKy6U0qvcN4CBTRvmk3yph54mxachZMN6Kr5XP1SAnBwVZQY+Ia+BtisnWmu+CQHqoCND0qSMqA0WvbCPycfWBpWqZlr4nOp/OQXzpd0ka96XA2+yyS4mtRSkDDWZCz6iNJBDutgsKlgNwGZEtmJljAeQ4ICX3fDSZekiidpR0jd
X-MS-Exchange-CrossTenant-Network-Message-Id: fde4e5a3-a373-40e9-b6ed-08d7cce3b530
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 15:31:06.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KzJ0f4daqpsa09772Z8NGB6Mw4J9vcBIKnXE2Ndv0yesXE9q1t1MdES+W7Y+AgC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3833
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_05:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0 clxscore=1015
 spamscore=0 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 8:24 AM, Daniel Borkmann wrote:
> On 3/20/20 10:48 AM, Greg Kroah-Hartman wrote:
>> For the bpf syscall, we are relying on the compiler to properly zero out
>> the bpf_attr union that we copy userspace data into.  Unfortunately that
>> doesn't always work properly, padding and other oddities might not be
>> correctly zeroed, and in some tests odd things have been found when the
>> stack is pre-initialized to other values.
>>
>> Fix this by explicitly memsetting the structure to 0 before using it.
>>
>> Reported-by: Maciej Żenczykowski <maze@google.com>
>> Reported-by: John Stultz <john.stultz@linaro.org>
>> Reported-by: Alexander Potapenko <glider@google.com>
>> Reported-by: Alistair Delva <adelva@google.com>
>> Cc: stable <stable@vger.kernel.org>
>> Link: 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__android-2Dreview.googlesource.com_c_kernel_common_-2B_1235490&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Fz_Xc6psG64uMowK2qpH0gTLj0NQE7k1CTWb5fODVeg&s=WKW0vq8WBALfwsSq5xGGWwxuLWKfI0DNN9XVMc1DkcE&e= 
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   kernel/bpf/syscall.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index a91ad518c050..a4b1de8ea409 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -3354,7 +3354,7 @@ static int bpf_map_do_batch(const union bpf_attr 
>> *attr,
>>   SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, 
>> unsigned int, size)
>>   {
>> -    union bpf_attr attr = {};
>> +    union bpf_attr attr;
>>       int err;
>>       if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
>> @@ -3366,6 +3366,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr 
>> __user *, uattr, unsigned int, siz
>>       size = min_t(u32, size, sizeof(attr));
>>       /* copy attributes from user space, may be less than 
>> sizeof(bpf_attr) */
>> +    memset(&attr, 0, sizeof(attr));
> 
> Thanks for the fix, there are a few more of these places. We would also 
> need
> to cover:
> 
> - bpf_prog_get_info_by_fd()
> - bpf_map_get_info_by_fd()
> - btf_get_info_by_fd()

Not sure whether in these places existing approach will cause
kernel failure or not. They did not call CHECK_ATTR, e.g.,
for bpf_prog_info structure.

> 
> Please add these as well to your fix.
> 
>>       if (copy_from_user(&attr, uattr, size) != 0)
>>           return -EFAULT;
>>
>> base-commit: 6c90b86a745a446717fdf408c4a8a4631a5e8ee3
>>
> 
