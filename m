Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B671C1D8D30
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgESBhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:37:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgESBhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:37:06 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J1aprp017949;
        Mon, 18 May 2020 18:36:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kdkDRmBRw3AOdXl0cTNhLj6sfFXjj0a9j2kQ1tXWz9w=;
 b=JcpiRW9tnurdHbvWSEIH8U7wxYphafzPsFKPbXwhh7XOF30FuJ+qQdh++5Pun9hA7CXq
 7yqsmmKbsnVs9c3fEVcP+VTEmsYkYF7aMqvkVV9BwYI04nFhG9S3tz8JK+/fY2qBbAlw
 jCLk6S7vNNlgiKPwawN2GMe30MYa/F+wI2c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31305aba7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 18:36:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 18:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LriHpLeeaQPFeHiiPxjiHqQmKRVF0wDzxkFdbaiF98eDHdhMPBFViJ6BlgOWJ+vMDSkqfe7Bt+6TGsBDdCVdxfPKVrWcevG625X/iByj0oBJYqvaHXEJPa1fD/bISSBWXvhBBCNt/iocMZ+f9ZM8g1G8Pd26SaftVbRN8wqeeJ5UiXDUXkU2JESUVLh9UsdySfiSvWogvharYrOxuAv0pHRBOabbuFMJ2Zm4zUfRzs0mo0JoHovdRg9etuMzZOaFvg49bkBpX+SxxT/NmptcH301fpe1ZTSS1sa9RdRtZE6ioHxxf0I/QT7PGylLEzt8nBrQXkiEFTpApcngaUK44A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdkDRmBRw3AOdXl0cTNhLj6sfFXjj0a9j2kQ1tXWz9w=;
 b=IZZzcCbJ0idLeCXRzEGe/RHdg+Llvw+qvu3m79aX82rrnYr5N2dqfFnJJ7IjPNmQXauWzTF2pj6TuyXbl53qhqU5UMB/nuKd8UXVEwJ8RlWhwW++qUGIW+7/hw/UbR2DsJ6qXXb0e4Eui/q3NQuFq6R6K48axQe2yWrJ89hYllF6M+z37/oYJI1FXEuaMeV8dPa/2/+bcBrC6CbV7v1QdheCfX1mSH/hc1Wspk53kHMj85HVRNqPI8VPuzglnm9x8KkChBHwIngsVh4u7oZprZdhTna+AxpIDseTr5fa/PObPyeT3PybHoe7GW/rYUPIZoNgBTtmcg139GUGJPbasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdkDRmBRw3AOdXl0cTNhLj6sfFXjj0a9j2kQ1tXWz9w=;
 b=Ja0akDHBqJbY5RUP/qvCl1tXynVAwIezYrQA7CSafbfZsTOc233ZzfZtUOohZaMpEZ603PzxkgWKXbMeVv+17b8W797iYt2qtzBl6HIgyphh9NCO8gFSv4oh4pWqxOhlONM9jFz5vq14uoGw/J+wHbiBP2MeyMCrwg/4dvR0lQw=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3365.namprd15.prod.outlook.com (2603:10b6:a03:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Tue, 19 May
 2020 01:36:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 01:36:28 +0000
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Qian Cai <cai@lca.pw>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
 <45f9ef5d-18e3-c92f-e7a9-1c6d6405e478@fb.com>
 <CAEf4Bza4++AxxU4ikMEfjeYLMiudWqc=Tk=5iTeBBNRjZjZZkQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f2b1ee99-6250-13b7-83ea-d6f870ecf95d@fb.com>
Date:   Mon, 18 May 2020 18:36:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4Bza4++AxxU4ikMEfjeYLMiudWqc=Tk=5iTeBBNRjZjZZkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:f205) by BYAPR05CA0015.namprd05.prod.outlook.com (2603:10b6:a03:c0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.12 via Frontend Transport; Tue, 19 May 2020 01:36:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:f205]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0239befe-64be-4502-b867-08d7fb950cf6
X-MS-TrafficTypeDiagnostic: BYAPR15MB3365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33658059D690B8861F9C907FD3B90@BYAPR15MB3365.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykSyfJku/wvZ2TsI/Qrxl1Xkp2tfrnpC5YjC6/F9UNzgSnWCg5ArnWbR12oXmqZ6GDohiO4SkEOac5UUnex0+PRJDkaj9UBVJNLtU0M6zxJ/bwjsuoULCt6ie4XWM14y8lq2mtOisjmnagSgmrlc66Rt7xSiskAuo/oRsnvqS1Bs/+9G/vk5MjVwkTdUAIt4EwlVa7aRJ5ZM//XhXxpzSI+2c9y5D06OGaCYieeQ9diybk5F9U8FV5c5xuuxR/NSyQVZo+irfBNsz3+M712F0tTAwRx/drXaoP63afBhdc56Dx33R73GJDtigHDCIj5snbEQFv8m4eI2vWY3XrnRgu21wqDX7wzR49LIzzLP3YVIJWC7N+NUxIEk0EEO46k8E0+sl1qN4S5plpfzea0/17S3vji5PywiOdniwKtJX5yEyuUX/ZbmohgizjHsGURcViRi2bnZYYaGCk1PnUhM35WWcPD3XfPN/MwHXWYqQSsjSLmEAnFZyb+0ma1+bvEtAAwRbS2XnhBMOUJBB5Yex7wQuPmVwTc2C4qo9bGPBx42wDmk9CcsSXrsJyfbKNX3UGQtklgXSbjvuzfqXiaPCDBbTNqNjvPjS00dedLEI+TKAwp20wp+1rNnKph/zztPub7sqY7lnz8SWqcJr5xN2GwobdPCDkD10Ycn5+mrM/IMer3I6X38QwAsXKbTeUv0P0eH9FYn7WU6U4EErAt07pPpB0GTxBx52CgKLUX6BxI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10001)(366004)(39860400002)(376002)(346002)(396003)(136003)(6486002)(2906002)(7416002)(6512007)(52116002)(53546011)(6506007)(5660300002)(31686004)(86362001)(6916009)(66476007)(8936002)(31696002)(66556008)(8676002)(66946007)(16526019)(186003)(54906003)(36756003)(478600001)(2616005)(316002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tjKWj6v8Wbcm3tgg6CGvBThzEkvru9SOHLBtvMpouCqeQnrNtIr1KW8wzCR/TXbtLuUnm+llJl7CyR8isdrK8Xm4yyLM/vutg+KW/x1ob0IQvzkhpQvuON1eQX4df6rk1W0/8ujGjsGVQbkDtm+fH6j9eXe9uocN+Tzxr72Nsg6Aie50uRgBnDSOazHqbvPNt+zQ1cQUKJGFDJhkZU0qOmY8cPZvUjboKCLxZ6mBdUNcK/XQ6T1Sa5K7NNnsqwVO+TeJKG9yd8V+05jadNfRzAcZllEWqsx9HFqswc0CX0tTcbKUBhPmkGbTV48LYLpE9CJJly3gY9FA31ulnNXEp7d1JwUE484UbTV2FnsYtGLFRCGs0WCUPYCULWXgc7Egc0iXNmIBDKmyPDRGkx9agOxEmYGvB5HBT+B5U6i8Mplq1U6fryqUEAkgpgIGYOkYI1zXMEkxZfpTuwQK23wXag2c99P/FtdVrLzIn6WPqhcDjrvXIGcUqEL4FzXGjENjnQdEGYUDftL+G4eXrADJEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0239befe-64be-4502-b867-08d7fb950cf6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 01:36:28.4098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmmqETYodBihio51VHmhp2MfT16SusKiK8Z4sWvMWlVsTiJn1/667bWZSaDjqkij
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3365
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_11:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 spamscore=0 cotscore=-2147483648 clxscore=1015 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=27 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 6:30 PM, Andrii Nakryiko wrote:
> On Mon, May 18, 2020 at 6:00 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/18/20 5:25 PM, Andrii Nakryiko wrote:
>>> On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
>>>>
>>>> On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
>>>> <andrii.nakryiko@gmail.com> wrote:
>>>>>
>>>>> On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
>>>>>>
>>>>>> With Clang 9.0.1,
>>>>>>
>>>>>> return array->value + array->elem_size * (index & array->index_mask);
>>>>>>
>>>>>> but array->value is,
>>>>>>
>>>>>> char value[0] __aligned(8);
>>>>>
>>>>> This, and ptrs and pptrs, should be flexible arrays. But they are in a
>>>>> union, and unions don't support flexible arrays. Putting each of them
>>>>> into anonymous struct field also doesn't work:
>>>>>
>>>>> /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
>>>>> array member in a struct with no named members
>>>>>      struct { void *ptrs[] __aligned(8); };
>>>>>
>>>>> So it probably has to stay this way. Is there a way to silence UBSAN
>>>>> for this particular case?
>>>>
>>>> I am not aware of any way to disable a particular function in UBSAN
>>>> except for the whole file in kernel/bpf/Makefile,
>>>>
>>>> UBSAN_SANITIZE_arraymap.o := n
>>>>
>>>> If there is no better way to do it, I'll send a patch for it.
>>>
>>>
>>> That's probably going to be too drastic, we still would want to
>>> validate the rest of arraymap.c code, probably. Not sure, maybe
>>> someone else has better ideas.
>>
>> Maybe something like below?
>>
>>     struct bpf_array {
>>           struct bpf_map map;
>>           u32 elem_size;
>>           u32 index_mask;
>>           struct bpf_array_aux *aux;
>>           union {
>>                   char value;
>>                   void *ptrs;
>>                   void __percpu *pptrs;
>>           } u[] __aligned(8);
> 
> That will require wider code changes, and would look quite unnatural:
> 
> array->u[whatever].pptrs
> 
> instead of current
> 
> array->pptrs[whatever]

Right. There will be a tradeoff between to make it work vs.
some code ugliness :-). BTW, I don't have a strong preference
on how to solve this particular issue.

> 
>>     };
