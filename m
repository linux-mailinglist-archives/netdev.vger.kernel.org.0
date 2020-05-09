Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2731CBDC4
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgEIFbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:31:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9632 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725820AbgEIFbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 01:31:02 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0495UPIe008436;
        Fri, 8 May 2020 22:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5AeiGsvFSjah+CnJcK4Pf8eSupd7kQ8BkoCI4lC6CQA=;
 b=QEnIsH2nVPWvO8+nhgzRe0ftCG0ABXueJuKTss4xlEVtJExalibm2g8sBIz8B/0ZTUuO
 pBzaSqZYbFJF6uOSgb3jMIveeYWGK1mrIzYXVtw70Yg5+NluAYjS39YHDPJpuzSVr5fm
 8ksESlHryxmcoWBeP5cgKeLK5YWNin7qAJQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30wnu0r4x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 22:30:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 22:30:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVTI+glKjEwHPZyomtwc8hviQV1TxnZXo+nWZ6QywM4DVZ5fuppGQtbSiU8EkmURolCaK6nJ5Ikm2+NeYltrbAP2yGRpNrBmUgf2SK5Jm93cY5Mgv8Ciqu+HYy8IMYxnY6jJsJ5Kuj9Yifa4zytkjczObv/7FBA5xt3+NAOyVJPZ6P7RB3qjUrO7I8X/3rkoR7q+OXeaW4nAufvUSmBCH1vvm98sxPlkrGZP1g6pCB9afky1SvNP2sfC/lPQ1D39ctrdluVS5gxpjKkVTY4LuVj26jT3VP9FMQtIqMZfaHZaGA2+Em3Wp9Xm1I6zNZ3JK7fSMov6DQ30l2yNx1UG1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AeiGsvFSjah+CnJcK4Pf8eSupd7kQ8BkoCI4lC6CQA=;
 b=YALY+G5j1Fu9eNQSa5Nk1JYTtRKZ0iOMXHuiOAqey1W398eRRkpqNg8D/pHGMfdSX87aanObXy1D8qUhFwgExY2e8V6MnmSK6Fh5mU1+pPPTcCto4bUty1jYTHBAEWSLIhnWWKiI8fcX5jXT3GQUH2QgLV+9yT+qZqgoNZd374svhJbtdSDYktSomMb+tX/fEfw4aGiz+G0R523B95oM9HU61i2LUIsML+McrDLF1ENzMHhnKcLICIHle9FLauUt+mjdTmEVT9RvaUTH7Hj8zYVFoCv5/nRTaDdptt/D4gHcfU90SQFVNJGnk/Tv0I8kdpSnXmbEDOPhgTkVk2Mmkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AeiGsvFSjah+CnJcK4Pf8eSupd7kQ8BkoCI4lC6CQA=;
 b=Py0bsWwXTY88/x7ov0Fd1cyKM5s//0foVTxAmVpSU+q15yX57XswxP6ajcusNBXRREdp/9iyKyxmgSH8OWCEzCWEyu6AOdP1imu4uShVGVF9zwO79UctPlN7HlEO27EwxbKK27SteCEtFnJl+ib+RFucgu0J75d9tQic9xnwauk=
Received: from BLAPR15MB3761.namprd15.prod.outlook.com (2603:10b6:208:275::14)
 by BLAPR15MB3921.namprd15.prod.outlook.com (2603:10b6:208:27f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sat, 9 May
 2020 05:30:45 +0000
Received: from BLAPR15MB3761.namprd15.prod.outlook.com
 ([fe80::383e:a5b8:f87:f45d]) by BLAPR15MB3761.namprd15.prod.outlook.com
 ([fe80::383e:a5b8:f87:f45d%8]) with mapi id 15.20.2979.028; Sat, 9 May 2020
 05:30:45 +0000
Subject: Re: [PATCH bpf-next v3 13/21] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053930.1544090-1-yhs@fb.com>
 <CAEf4BzabLpaMvJtTNtb88xJZzdjwwvcnfqSH=hq3bMiEt-gtmw@mail.gmail.com>
 <931b683e-ccb5-f258-f5fb-549b2daf47b3@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <f78b0a02-9469-32c5-d8af-78335010660b@fb.com>
Date:   Fri, 8 May 2020 22:30:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <931b683e-ccb5-f258-f5fb-549b2daf47b3@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To BLAPR15MB3761.namprd15.prod.outlook.com
 (2603:10b6:208:275::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::10d4] (2620:10d:c090:400::5:7fc5) by BYAPR11CA0104.namprd11.prod.outlook.com (2603:10b6:a03:f4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sat, 9 May 2020 05:30:44 +0000
X-Originating-IP: [2620:10d:c090:400::5:7fc5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b833a46c-deec-43d9-46c0-08d7f3da1f61
X-MS-TrafficTypeDiagnostic: BLAPR15MB3921:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR15MB3921C88564E4AE44BB6A154DD7A30@BLAPR15MB3921.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwlqhZqKxsCXhhp2YERymJSe1cH7e7GhUbg/OTgRgVPShnp6iYm3nGNnXtuurc5dCYhTW4fIK8Rn9Sc4gB9P2+hr2rgw46BwOLr2MI5kEvpD95lCXv+frldlK1ywNlsJdPQpsjxQeVOF15xVxhw8sXIcf7bP+AbBTjx4WWXL2VZsCNin7FEd9Sd2bbU+QS6WgwnFgR254KLCGKFxmzBdlaONmEyo35kLBNy7AnYzrLBkP65YGXWPuyZUN9NrTdwqVnvQqoJq+eIJnxKXdcKFA2iaVCakXLIFmDT34Xbep6owi55pIvAKu16dUdpQhVtMc4H+VE8A8PcCTwWamrVnwcPY7naWLn5fBDYjG2eejvY+CkDiB+sDW0IkjJGsF7M384cc6CMq0u363F0x/ATISPwmx2IMjB/Q4boewsNFGRaPw/c004FW/fnlXCreUU9/UJb5b9HNChySeDTonsp88BLzkJmeAW/piyM7my7ncAJ/mySfY7woyCfpKDf+/H/2vLW26cB89rL/wg7mHxzV+w804qa3SW+t1Xke22XdBczuyYD7dzl5ROrcsuXJgRA1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3761.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(346002)(366004)(136003)(376002)(33430700001)(36756003)(86362001)(52116002)(316002)(53546011)(2906002)(2616005)(4326008)(33440700001)(6486002)(186003)(16526019)(6666004)(5660300002)(66556008)(66946007)(66476007)(8936002)(31686004)(54906003)(110136005)(31696002)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EY9lzRXKV9vSPfx5exedpSHdrqDGBi8X95W1LoDZAmHFcoUE+Ta9sBi0Qmu46vIrbRHGeJFq3z1pLConOPi0YbLwR3Jiar5s+7wpBXH0bj5HVtTNZYPSvCLoqiv+gAhs1AV+dIaNUDeNg45B/3AEOG7TFMlbIK7MsJk5QxeIQ4ECcBSBoQ2mJyRx80zss9a2AhyuIJFslEQyps3ZwRQVMza3d9MvB2PRhopzZg69crWzzDfU53EfQuy6wZ3KkHvyJYyI34qHHKAqDBozozfYBMYnyvt9b1CcDIM9BVxE85CxrUewOvysoPRhIYdURU2J8tYgZMPOOyQWyJAHF+aZGhhiS2qRF4aRau5twVsA1peauUsYvh5AKl4B8vVLW9jbPTAiQndDwK+x8ZhzYcMchU5cw1PHFSaoJXmVyiqAEbXqXVrMDy41gNULNcWtDiiNj8jM/DIdgoYwksQ8iXRk4vHD9a1XcoQ6BbFMaVFGJ1syt60VDl+M0QzFUCxeQ3xmxJ2Cl/zv60DlHTtrjqEfoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b833a46c-deec-43d9-46c0-08d7f3da1f61
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 05:30:45.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQRCVO1AVgPxLbgjtTcX52FQX/5Fsg9Hs15znL8mrxLe7Ga0iDar33T4YsPM2H+T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3921
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_01:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 9:18 PM, Yonghong Song wrote:
> 
> 
> On 5/8/20 12:44 PM, Andrii Nakryiko wrote:
>> On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>> Two helpers bpf_seq_printf and bpf_seq_write, are added for
>>> writing data to the seq_file buffer.
>>>
>>> bpf_seq_printf supports common format string flag/width/type
>>> fields so at least I can get identical results for
>>> netlink and ipv6_route targets.
>>>
>>> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
>>> specifically indicates a write failure due to overflow, which
>>> means the object will be repeated in the next bpf invocation
>>> if object collection stays the same. Note that if the object
>>> collection is changed, depending how collection traversal is
>>> done, even if the object still in the collection, it may not
>>> be visited.
>>>
>>> bpf_seq_printf may return -EBUSY meaning that internal percpu
>>> buffer for memory copy of strings or other pointees is
>>> not available. Bpf program can return 1 to indicate it
>>> wants the same object to be repeated. Right now, this should not
>>> happen on no-RT kernels since migrate_disable(), which guards
>>> bpf prog call, calls preempt_disable().
>>>
>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>> ---
>>>   include/uapi/linux/bpf.h       |  32 +++++-
>>>   kernel/trace/bpf_trace.c       | 200 +++++++++++++++++++++++++++++++++
>>>   scripts/bpf_helpers_doc.py     |   2 +
>>>   tools/include/uapi/linux/bpf.h |  32 +++++-
>>>   4 files changed, 264 insertions(+), 2 deletions(-)
>>>
>>
>> Was a bit surprised by behavior on failed memory read, I think it's
>> important to emphasize and document this. But otherwise:
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>
>> [...]
>>
>>> +               if (fmt[i] == 's') {
>>> +                       /* try our best to copy */
>>> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>>> +                               err = -E2BIG;
>>> +                               goto out;
>>> +                       }
>>> +
>>> +                       bufs->buf[memcpy_cnt][0] = 0;
>>> +                       strncpy_from_unsafe(bufs->buf[memcpy_cnt],
>>> +                                           (void *) (long) 
>>> args[fmt_cnt],
>>> +                                           MAX_SEQ_PRINTF_STR_LEN);
>>
>> So the behavior is that we try to read string, but if it fails, we
>> treat it as empty string? That needs to be documented, IMHO. My
>> expectation was that entire printf would fail.
> 
> Let me return proper error. Currently, two possible errors may happen:
>    - user provide an invalid address, yes, an error should be returned
>      and we should not do anything
>    - user provide a valid address, but it needs page fault happening
>      to read the content. With current implementation,
>      strncpy_from_unsafe will return fail. Future sleepable
>      bpf program will help for this case, so an error means a
>      real address error.

It matches what bpf_trace_printk() is doing.
I suggest to defer any improvements to later patches.
Both should be consistent.
