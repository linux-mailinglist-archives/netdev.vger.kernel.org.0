Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5EB1CBCEC
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 05:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgEIDSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 23:18:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728421AbgEIDSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 23:18:46 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0493FndY007034;
        Fri, 8 May 2020 20:18:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SvZvQBg5Q2IywHQPFfnaXliw0IjMa9Cp6Ob16fwtUo0=;
 b=kNBEVvZjnqjTUwSQgycUugT50QgVrlLobr23IX6L4cT6D8xMvLt8phIhb94bfUzCVFTZ
 x/NtKOalRILjaI0+WEIQ0ezcqiUq6qeNkXoqGdDeQEHBKA8c0xSyMSHppOYxufCQth6c
 f6GUldnFRETsY1k97tQQd4Bn62J7BvQpLww= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtdxykmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 20:18:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 20:18:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFO7f/SJmmSAM4Bcz0GvvNKlrxCPiGz8MxgY46BrVRuZjh3Es4RGKWG8z2zwa2NO+IsUEESL2zBeMLBuoLF7ZVBFsUgbkgr4bbjCZKC7Zp1gEC+Oe/XebkYP+XLc8rzvbVyoW/2de9EK08BIivXDkq6UdP/dd0m7qaLXejAsi6BgERulxIGAochtY4tRzsJwi408jBNlFf9+WZOQ4M4/bKkkdPa1UPSEIfN4zYuYPLan6asfQxp5VkOX1yFYcuFAN9f7lpnTPV3tptlHdT7Q2SZrSgQoGbOjFkLhd3PXib2Zcrv11nu14g+4guKsjdsQftfT+U0YaEa1RNUxOgf3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvZvQBg5Q2IywHQPFfnaXliw0IjMa9Cp6Ob16fwtUo0=;
 b=jHdgQx8NE7JkTwAVq3eEYRnrPeCWoSGyiKiK9EAacv5CoW9pK78hlnUga1PQ4WM5hXPQco1BXdQVd1tvOD0UEabz1U9TrgimWCRBZ9LSrBsUELHUUngB30iLHldRpPrR0S4ot5AlQinGnR+W+Y4qi0CJd8LJVKmSiINEDDW3MnChiPzxyuNnStPmPgCQfY0x/XzYa5erAQQP4woGiR9Zy6lTGUqnwmXPPyRguBIIzHUxwHcVlAEiWIDNXGAQmmNUrJIybTUal2LscoBwyIX/c+N1L9LG/Tpkm8LtGuj4wWF73XhP+sYnthncXkz2SmuLL4vIxcsoHKmA+C7/zh1LCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvZvQBg5Q2IywHQPFfnaXliw0IjMa9Cp6Ob16fwtUo0=;
 b=j++UXKEH6Emc+PgM/pTTh4xCniCTBM0ugbBHhMoP0mgwwT9K+x4FKjxeOYjQjURwMj04nQ+FyGm4R8+aF9nlCH8hG8Y25sg/lhKfTm2u/6i96cK+kL3bv3CKYbMTEjlrSq0BElcbQQeiZIeU22txnE4mNvdzmTqyKD0jtilWmtY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2661.namprd15.prod.outlook.com (2603:10b6:a03:15b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sat, 9 May
 2020 03:18:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 03:18:31 +0000
Subject: Re: [PATCH bpf-next v3 08/21] bpf: implement common macros/helpers
 for target iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053924.1543103-1-yhs@fb.com>
 <CAEf4BzZ1vD_F74gy5mx_s8+cbw4OuZwJxpW36CijE-RWxOf__g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a847e0ef-2308-ebf1-ca21-f30372fa2678@fb.com>
Date:   Fri, 8 May 2020 20:18:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzZ1vD_F74gy5mx_s8+cbw4OuZwJxpW36CijE-RWxOf__g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:a03:255::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from joshferguson-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:9bce) by BY3PR10CA0022.namprd10.prod.outlook.com (2603:10b6:a03:255::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sat, 9 May 2020 03:18:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:9bce]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca007cee-b971-43ee-f0e6-08d7f3c7a686
X-MS-TrafficTypeDiagnostic: BYAPR15MB2661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2661F1E9EDA589B86B4640E6D3A30@BYAPR15MB2661.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNKjJ8Rc89K+73y5KvC0HfgZVxVsuAe7+NYmc6+vJA5FTHeLyEkAY5W3If5eaJ14jUOwHG21mDHRZTg2Xhbc3J/34Y17gB6WRUczis8qToP6LoZzC09VfkLKcETtm8/j2ZxFA/ul7Uz/peOTF45gA5DkZS2ONJ7SBoFwVHGA8gUdz0Gkj9F0CZY9a4CmrT0QPkwrvYsSPymNDQD9D7AeJqSGzMHlNblrCJhwwcDCsG5PPzZck3ZMfNP6R0wtQRfewsu+mjFhjVzuJ261ZvSiL6iFuBnpHWZKfn+KmwafHetqWwyyUSZpeRnOviieeujfPdFgwwRVWY3KDPaisHV5C5fyK6cqM1rc7DIL217eqSDOoogSKOCkzBt9v2BpBWLLKxjUgv5OyQbLYIod8iPmtskoLpk5Ml/INQ2FoWs7/duQlue9PTPrIFZ1x83poWqGi5UH4yEi4nhLRNUeBJ7TNxgqxjEOTZYGkrc48d4m4G/EPp9nApAQNyKwjZ8UDlnTIeuNQufTL46M8aj4SLtJ40jsSaf87fC4nD5/AKtYOSUqZF/kGlCrKgz0qCFseGgi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(33430700001)(6512007)(8676002)(4326008)(6506007)(86362001)(2616005)(54906003)(53546011)(478600001)(186003)(6486002)(52116002)(16526019)(33440700001)(2906002)(6916009)(8936002)(31696002)(316002)(66476007)(31686004)(66556008)(36756003)(66946007)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: exV4hYnkmuV3o39xglyVxo5krBoHHELbLevC/wJT+UKzcTHlsni8gfJO8ylEcpLLbEb4zRhZJLb7+MSIbXEcpc+ToxXB8lv3kKZBnWYf4al28bRMF8dOKHDNfSB0HB+wR01Z15Fqzc5eRiliq5Km7axlSNZW1rgnr4syaEDWiMNIxckPg/8m3ODgR5Jqc91RlQdVrg8hwOSmHW9UCOE0aIh1RZXWVIZq+5b0gBNlQN4VFKDIp2Zjl2vKj4Yx1+HvcImuha9RUoo+kEeomuopI26ZsQXKGmIma2JUu6mYVx8FJOdKdTOoi51/+Gxe5cGsWen2W8On3u8skbI1OEop9zPqSh/HtI1WSKcTHza9x8BDMEpwlj73/012i2CvSz7EsNYoz1wiK9+l3V2HJq+GuLwmtSNybqgDcDLd5sV6wnUbyiZ6zjMt3mMmZziSlj48axD/4ZY85CtS0HrRD5/1VzV9BS3qWEY3ud2LbbdwjdodXnl16FkgnL47Fb3P7e3RoHdMjTarg8X3eihPEfGX7g==
X-MS-Exchange-CrossTenant-Network-Message-Id: ca007cee-b971-43ee-f0e6-08d7f3c7a686
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 03:18:31.6016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txVVfxtWKZEypLQqsxi3LRiK8LMW8DFSax7qRsP8BQr+ccf8rt2D3SvWdcATBKf0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 12:07 PM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Macro DEFINE_BPF_ITER_FUNC is implemented so target
>> can define an init function to capture the BTF type
>> which represents the target.
>>
>> The bpf_iter_meta is a structure holding meta data, common
>> to all targets in the bpf program.
>>
>> Additional marker functions are called before or after
>> bpf_seq_read() show()/next()/stop() callback functions
>> to help calculate precise seq_num and whether call bpf_prog
>> inside stop().
>>
>> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
>> are implemented so target can get needed information from
>> bpf_iter infrastructure and can run the program.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   | 11 ++++++
>>   kernel/bpf/bpf_iter.c | 86 ++++++++++++++++++++++++++++++++++++++++---
>>   2 files changed, 92 insertions(+), 5 deletions(-)
>>
> 
> Looks good. I was worried about re-using seq_num when element is
> skipped, but this could already happen that same seq_num is associated
> with different objects: overflow + retry returns different object
> (because iteration is not a snapshot, so the element could be gone on
> retry). Both cases will have to be handled in about the same fashion,
> so it's fine.

This is what I thought as well.

> 
> Hm... Could this be a problem for start() implementation? E.g., if
> object is still there, but iterator wants to skip it permanently.
> Re-using seq_num will mean that start() will keep trying to fetch same
> to-be-skipped element? Not sure, please think about it, but we can fix
> it up later, if necessary.

The seq_num is for bpf_program context. It does not affect how start()
behaves. The start() MAY retry the same element over and over again
if show() overflows or returns <0, but in which case, user space
should check the return error code to decide to retry or give up.

> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> [...]
> 
>> @@ -112,11 +143,16 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>                          err = PTR_ERR(p);
>>                          break;
>>                  }
>> +
>> +               /* get a valid next object, increase seq_num */
> 
> typo: get -> got

Ack.

> 
>> +               bpf_iter_inc_seq_num(seq);
>> +
>>                  if (seq->count >= size)
>>                          break;
>>
>>                  err = seq->op->show(seq, p);
>>                  if (err > 0) {
>> +                       bpf_iter_dec_seq_num(seq);
>>                          seq->count = offs;
>>                  } else if (err < 0 || seq_has_overflowed(seq)) {
>>                          seq->count = offs;
> 
> [...]
> 
