Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216501CBD27
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgEIES4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:18:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgEIESz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:18:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0494DfM7011791;
        Fri, 8 May 2020 21:18:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GYBLcpjiSVxiF4iSPVLTv4h2aoq1wNDQPs6lf8PFuvk=;
 b=HZ8becYRPvnPtKpOs1VJFZ2ycHFRKyE6vrD6UOLSROSp3OrlHpjMMxgFk3d1u+IwmIHp
 eR92PipkrbzbZFkPFAaNguHpuVuxOJIO/4V7ppoPUcpIshOBgQQInWCJk+BB7ss+nXYC
 B4aUOeaShH7jBKMekJNrm2+pmvYpEi1btTU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtd17xax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 21:18:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 21:18:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj+BjMnNmPHKZcFTw3d5N2keop5eouQrRjdJRh9n1+7R6TRNby0XJvu1olqCTbFnYSjiv0fHSinCfUVbPP/s+hmMA6fl2qdco2HXPtpIsqaEACfzSLNbIyZfJr8XH8eK+5F23QnSK9cDUQzeS+wa7a5hG4dbpZs8kDk50ffGA2OiWOVE3vrckMEt3v48IiStdIxFbAwkBCnnnhxhe+Ru/NHEqtKerX8chPQlKpuS13nqBCDr7/lBpC0PuavnR1iM3tpP2Q7IuGnznJ5A5GAm1Z9MtyyauFYx7lyDiqAyviM1u/FvA7XuoSaNu1snRm6tl7EVH4UjSkEdnXuSsD8SzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYBLcpjiSVxiF4iSPVLTv4h2aoq1wNDQPs6lf8PFuvk=;
 b=ie7RZMK3LLeksyc2WaGWb1O4Jk0qi8JLoERnQU/b9NzlCeloGgbDQ2yJ2IBlLPoqq6IHryv4AmpBEB16mybl7VyHYpRYMORYbRvEs6rDT2iK066U71ir/MlPCbfejAvtF7dyBaDbfwjBqkpeXA7d0ZdDmBGYRlvXZcG1D/7qtQDXI+DTeijhlp74W13R1yJF4xTMw7doSmmD59WYjIuK29Nol9pKaAi4MJLrv5/PhDmWEbwbpG/BpLCDNf6T7YM0arLX/T4qISMtiA6Y08S6XbvFeoosw3jy/EgUleT5OcMgNVXANfYJTxIv1l0ECPIWhznNcfEUYHbmDlvWGi8aQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYBLcpjiSVxiF4iSPVLTv4h2aoq1wNDQPs6lf8PFuvk=;
 b=Y7nEJR533oOeOF0cHUCB1/JNhe3RXRiTJKOFJt27bprYRELA+9VceW+t0O/Xh+TsrUOIK5AB0684m0OExSVnTs25IAl+78E7iMad1Uk8V6RYGNJdfIMUWRvziv7M3Xnt5ziK5BF09sMgIMi1aeiAfh7NicyGKM33x1kXdjUTAYs=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3016.namprd15.prod.outlook.com (2603:10b6:a03:fd::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sat, 9 May
 2020 04:18:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 04:18:37 +0000
Subject: Re: [PATCH bpf-next v3 13/21] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053930.1544090-1-yhs@fb.com>
 <CAEf4BzabLpaMvJtTNtb88xJZzdjwwvcnfqSH=hq3bMiEt-gtmw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <931b683e-ccb5-f258-f5fb-549b2daf47b3@fb.com>
Date:   Fri, 8 May 2020 21:18:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzabLpaMvJtTNtb88xJZzdjwwvcnfqSH=hq3bMiEt-gtmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:a03:54::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:9bce) by BYAPR02CA0064.namprd02.prod.outlook.com (2603:10b6:a03:54::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sat, 9 May 2020 04:18:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:9bce]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1716d9e-7b6b-46e2-8147-08d7f3d00bcc
X-MS-TrafficTypeDiagnostic: BYAPR15MB3016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3016D47C898F2C4F760A6FD4D3A30@BYAPR15MB3016.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q7xLiJnDsioNr5GZ2tCaOxnO7ryRttn/5ZNm3grL4badN1LnPztp0yeGZTNPX2NZVIPKJg0dc7M22Z2JXek4AW91ejP6UkxshX6zq0YFZBTKoK6h7Evc3ZoF3hSiDD8jPmr9khWr7PF1QiyfhUDbT41Jms21NOCySIG2i7iiCa/Fgl8hb7D/Ov4j/oaX+66nbRSNhHP1o37BhwVLHDNgyl/TUu3sGUE4iO7szUhI+CGKN+Kxz79O19u/WrXm48QTfJEynVLlRDO8zinBebY6cysCFf01u2HWj3YS5w1XVIVeJK6jzoDtFm67VDni5s+TT5pv0s3DHo1vTQBaRKWy0RcAd7+XvqcW3UXJjbvG23O7gEc+UscJqrLd0oU7gvm+Lh+O9oVHjr/yu4ePrrRQLKm9AVunHh4OiSeEFOKpLx1s/s/C5ocY2qOE5kcIfufGKzj5dg9KpYZzsQJqEX12AslvRGb+6QjDgGd91O0fjukmEtPbNtJ7msQHU0/nb1wyD7HuEOVrB2dbDV2MPP9hHaf9U+4c7Gi8OEHWN0ApJur+05DivvOQTIf+Q/KVDPRe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(33430700001)(8936002)(8676002)(186003)(6506007)(66556008)(16526019)(66476007)(66946007)(316002)(33440700001)(54906003)(4326008)(53546011)(86362001)(6512007)(2906002)(31696002)(31686004)(2616005)(5660300002)(52116002)(6916009)(36756003)(478600001)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HsBO84CKkfTS5XtxA6aOCi7IfZexlgsYm5Ssxt6sLS3KfsFiXvyktDzsC61QcvrnB2QRwDPyTHlWN/eW7yMVjICsVuQvRdTZ5/FNb0pnKIJl83NdN2voRzX5KEYWzYdsmggSx1bdqHNATWPpy10geT/UFzwZbIPAxb9xtPY8VwLfzmPnVTQbaXHhPD7SspgBDMydjuy1z7sE0YoQI9/KFtTgrTvV1vqjLWcIrH7b2UdR5ExIYahWrQ5y8u7c0rgX5ypEufawY+SkCUWnyzFUG3bCsFjrmpp/19MZJEEBARhDuVPAlYtXIexVpCHhRAhfEOOJS6+LcfvfDQ60DGkZQlQjxzB9EyeAiUlv3lS+GduKyeEOjdiHN3F25T1Pdu03hbtE5NDA89Z62O+u3H2K477zIZjW4+qTdXFSSKaGiD20hDi7ygYR2FrbWsj7jTOSvsOr9QYE5/5aCeMVTDrOGzKXJWythz9Rdi2/qdiHSinIp3juNudMnBuRDsKE9fFQjA+LVu9lB4QtINTnFxw1Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: c1716d9e-7b6b-46e2-8147-08d7f3d00bcc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 04:18:37.5352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4E7doMo0FUvdfwsk+0Q8Tk5G/ZHODcSW83MOKCnxY6Jp1gMkq+MqgnxvfkTmjlh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3016
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_01:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 clxscore=1015 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 12:44 PM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Two helpers bpf_seq_printf and bpf_seq_write, are added for
>> writing data to the seq_file buffer.
>>
>> bpf_seq_printf supports common format string flag/width/type
>> fields so at least I can get identical results for
>> netlink and ipv6_route targets.
>>
>> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
>> specifically indicates a write failure due to overflow, which
>> means the object will be repeated in the next bpf invocation
>> if object collection stays the same. Note that if the object
>> collection is changed, depending how collection traversal is
>> done, even if the object still in the collection, it may not
>> be visited.
>>
>> bpf_seq_printf may return -EBUSY meaning that internal percpu
>> buffer for memory copy of strings or other pointees is
>> not available. Bpf program can return 1 to indicate it
>> wants the same object to be repeated. Right now, this should not
>> happen on no-RT kernels since migrate_disable(), which guards
>> bpf prog call, calls preempt_disable().
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/uapi/linux/bpf.h       |  32 +++++-
>>   kernel/trace/bpf_trace.c       | 200 +++++++++++++++++++++++++++++++++
>>   scripts/bpf_helpers_doc.py     |   2 +
>>   tools/include/uapi/linux/bpf.h |  32 +++++-
>>   4 files changed, 264 insertions(+), 2 deletions(-)
>>
> 
> Was a bit surprised by behavior on failed memory read, I think it's
> important to emphasize and document this. But otherwise:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> [...]
> 
>> +               if (fmt[i] == 's') {
>> +                       /* try our best to copy */
>> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>> +                               err = -E2BIG;
>> +                               goto out;
>> +                       }
>> +
>> +                       bufs->buf[memcpy_cnt][0] = 0;
>> +                       strncpy_from_unsafe(bufs->buf[memcpy_cnt],
>> +                                           (void *) (long) args[fmt_cnt],
>> +                                           MAX_SEQ_PRINTF_STR_LEN);
> 
> So the behavior is that we try to read string, but if it fails, we
> treat it as empty string? That needs to be documented, IMHO. My
> expectation was that entire printf would fail.

Let me return proper error. Currently, two possible errors may happen:
   - user provide an invalid address, yes, an error should be returned
     and we should not do anything
   - user provide a valid address, but it needs page fault happening
     to read the content. With current implementation,
     strncpy_from_unsafe will return fail. Future sleepable
     bpf program will help for this case, so an error means a
     real address error.

> 
> Same for pointers below, right?
> 
>> +                       params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
>> +
>> +                       fmt_cnt++;
>> +                       memcpy_cnt++;
>> +                       continue;
>> +               }
>> +
> 
> [...]
> 
