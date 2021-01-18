Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23C92FA7EC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407316AbhARRvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:51:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436687AbhARRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:50:30 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10IHlkOA014101;
        Mon, 18 Jan 2021 09:48:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=E+foa0BM+Hn97lAjt1lUhpr6sx6Ok2/4qYN1STf3sEs=;
 b=Di1QQ1BrJImYCJ4J98t4kOoziD6GPdSiDMK0Su1nUIUmCWF0e6BYqys5SzYWtrCpXcHz
 kD/xO3GwyRoPK+NSxX7BUqEbuTHXGOQrmAyE4f9CNg+e3r1kOM+QCYIUlJ8T9JB4pW9n
 TPoQujApbvWUJ7cA7XUK3u+UVA9nJcwNF8w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 363vps05b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Jan 2021 09:48:58 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 18 Jan 2021 09:48:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI9xL8UOkvW1WCDca/VH5aVP7zn0GT3fYgVlx+nRxvCzU6HNKQZKlSFUEWR4+mYE5ITgtg7BPEhTWd1NKCI/4Ct6dQUl0V7qsnkmshv/jJswNR+bFkOasZqQ8Gtum4fAXWzhfeRgg3ZuMEdHbTUHJkeaHLGYTpEZSvfTl85CRBjolRQxhf4kgtCWt5StlOIgFBBm/3ozQ4VS3VSiXXvrvnI/QXD8HxvL627wL/lDqRsshXmEWdOSj5Npnn85qseo1nPCskbfNzdNVysyBARcPgAnDBDK8ag2DlIaDgiHh1VXelUeZN37IS+JzTGg5KFk5SoIirCy1i/aGWiu951hoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+foa0BM+Hn97lAjt1lUhpr6sx6Ok2/4qYN1STf3sEs=;
 b=HOMw8Sqh1enM82KGSS9MYeUCaThhIbJT/vyZ2MINkaKQ03Qrq8rsVRrci57rfwO3mjf9XTgI8IFVNtT4jjFDv6AlQjiXaQjtNJxz/0vyIic0zUvwmQOwnzSe3ZiMqg4YgP9RYFrD2BaYBTj15CVUg3PqbF+758RQjUJvKPBWRKM+re5cgp8dDqH2fO6bbVqyHV9aEYBDY5r0cmS3NTZowU60uCKTd5tRjvZd/NVjEhFIteiFYLEUwgD4A6V9IGOtVpRMi38AMZR9Ub5IQ5e/gUzYsLIwSWnVVK0lQ/OQUrkpgBitza8BlWZDE7X9xmYBkwvE8M1HLsGigRdPLhLobQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+foa0BM+Hn97lAjt1lUhpr6sx6Ok2/4qYN1STf3sEs=;
 b=DM31QlF56LwUlGbT6InvJw54fkNNyWyyVIqFqir5AJ2LwW7VtvaQwEyY/cHfdvFojk3o30Ag50bzCjQMke72zgaNCl1CaTevesD787jFpN5CihKOx6e50AZKhcAQmXA4poFntcH+1JdfR5C97fPX0ABBK/2SXNfX8w/gpDxBolo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 17:48:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:48:56 +0000
Subject: Re: [PATCH v2 bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210116182133.2286884-1-qais.yousef@arm.com>
 <20210116182133.2286884-3-qais.yousef@arm.com>
 <e9d4b132-288d-594f-308c-132e89fcf63f@fb.com>
 <20210118121818.muifeogh4hvakfeb@e107158-lin>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fdda7117-e823-e240-4735-617a3df8a0cc@fb.com>
Date:   Mon, 18 Jan 2021 09:48:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210118121818.muifeogh4hvakfeb@e107158-lin>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4199]
X-ClientProxiedBy: MW4PR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:303:8c::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::10cf] (2620:10d:c090:400::5:4199) by MW4PR03CA0126.namprd03.prod.outlook.com (2603:10b6:303:8c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 17:48:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b68ddf80-c5c9-466d-3d0e-08d8bbd953d3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-Microsoft-Antispam-PRVS: <BYAPR15MB237651DDD7E7D2399C9C76F0D3A40@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0biiF8pXsipxwUQKyWqw+TNxg7vxum7/TVkaFgnm/nR8WzUZtT+moB4BJcoEqpuPtiOfMB6R5FfTlG9d8qxAJYdlYx/TloxQgR8+nD0TtlN7PB3khnUs0qUg2liMd38mXBP2QhRzOcOadWDfNuDtN0ONCCFH8Yj7d0tRyquF6xkkBFrShL1JYr+Xgt/er/1wtDohxpR2W/uzTwdu/a+qAr+lC55TS8aLXp/DgvDKfNC4gvH26cF6sF7OrHEdhK8kMGag75KwXfpq/0N3XngGZh1G3ow0OBh8KbhINxYXrvt4RWoXvErA8RfCOug0AKd2xsCGyH0VWflXgAQp52VW2DPVgGnfcBE3eVneO5L11oXg2GwV3jX+ekTG+zyNr2Y+wC0WLKVzsthIx91VfrQ4pN8v2/NjXvz60BgY8SIfYY+HVs/o7qWrCq/zmUNYgQu1BPuCspR/ECzuSf9WiqcfFqOmufk4KM2xlsXKaygtA84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(86362001)(54906003)(4326008)(52116002)(2616005)(66946007)(31696002)(316002)(8936002)(5660300002)(36756003)(66556008)(8676002)(66476007)(478600001)(2906002)(83380400001)(31686004)(53546011)(6916009)(16526019)(186003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckZ4RFhTR3NqOUlqZm9IYVZsbEh0VHd1UjFVYzBMM3VuZEx6aHZGOTVuK0s1?=
 =?utf-8?B?bHdNUUVaaEZjQkMvaXE4N01FNlY4ejhGUERmWFNIRlJtc0hhNXJtbGg4Y1l2?=
 =?utf-8?B?SG1aK1NLZVhOZ2dPZ3YrOW5xcm5vdklXaTZ3WHJvTTEzOEc1RjRjL1dsLzJn?=
 =?utf-8?B?d0lsRTNualJkQy9NUHZvNGU4Z0hQYUhXMkJGOWUvdGhidXVoNmtpQ3JxcW1t?=
 =?utf-8?B?elBlSW0rWkMwTEVrMkFiRXNTN3FmZXZnZUtYdjdaR0w0RTdnU3kwVzhoU3h2?=
 =?utf-8?B?YUFEVnpmbWFjMVdLWVhZelgwTmxDY25VU0JLWWNjdWsyQUNSMG1hbVNROWsv?=
 =?utf-8?B?UHhJM3AzanpCSmlDbGVrdW9ER0ExTzVJdEVTcjJlWlhOS0RRY1dGM1lEcXUr?=
 =?utf-8?B?dTg2U1lWQXd5bGtnSWNyWGtNR09za05idTlqWnpIU1JBa1JSaWt1UnMxaUg5?=
 =?utf-8?B?bEZHWm9OdmEyTzAxTkxYZ0dCSkdmQTFKTEQ0aVgyQXU5VGtHMnJCRzdzeHZC?=
 =?utf-8?B?SWU3OXNOalNGVGswSmlFb0FlbkJrU2hLSkVLYmdLOHVyME5tS1QzQjlFSW9M?=
 =?utf-8?B?NjhLTXJ0NUlWcjZQZmJwdVdQRU1VZnZCQXRLRW4xa2dYY3lwZG9aMlRyUzRt?=
 =?utf-8?B?bjBTQ0plZDNPS1lMOU1VZGFuMmtiY1g3V01ncm9vK3hhZG9jUDh0T1BVZ3NI?=
 =?utf-8?B?NHJGdGZZNEdrM2RxUG9XL0V6VC9QZ3VVaUloNERuLzFTdUJreTBUekRmNFN5?=
 =?utf-8?B?aTRjN1Btc2MvVGdtYWVYVEVaaGxUVldSMVQ3cjR4ZkY1MnpYWXZhVW5ZSzRL?=
 =?utf-8?B?RU43SUxIRFVVVmdoOUt4VGVnbkZlaHlyUkZ0SHJVSG13ZzJQS0txdkxDbE85?=
 =?utf-8?B?R1N6c1haVVVuWHBIOHhHTzAyWGdPK1FJcnFuUTJScUVxZEhoVUVpTnRaZ0Vi?=
 =?utf-8?B?OEI3em1MUU95aWJqVDNvQ3VtVWNGczZ6YTUvRlpoMzdua0lQcE00SHVTNUl2?=
 =?utf-8?B?V1BUYWlHbEIyQUc4Z3JFU0JZbEkzN3JwSUdlYUp4SzBKbVNvOTlHOHJBaGds?=
 =?utf-8?B?N3VWSUIzUlI1SVY3b25ub1p4UzJxODMrM1hFMDU5Q09pdWtyd0JaczRZR0ZY?=
 =?utf-8?B?N1ZZcHE0akF5YitSeHhDV2RpNUc3SVNGTFN6VEFyc2JRWkZMRytOVndKTWZt?=
 =?utf-8?B?blNnOTM1ODNlZEtwQ1draHRwbnA4Uml0T0c1cUt3cFFFdFF0OGw2YjZmUFY3?=
 =?utf-8?B?ZXBIRk5teDJRRUtWaVJ3cEVVUEZ5dnpXRzZFRjBDYlFVY2hDM3RGcTVSUmty?=
 =?utf-8?B?NGNuWTZLMEltbzVRQllyR20zMmowWWdHdHh5RVFIMGV1ODNQdDc0Q1hhcmg0?=
 =?utf-8?B?RE9MSlM4YUNFR1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b68ddf80-c5c9-466d-3d0e-08d8bbd953d3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 17:48:56.2904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQ24o80dPWWdCP8ya2/tdhgPCm6Gp2qOD2GIZ0hFiK3Gu/hu7+5pYU9eBzAgQsGq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_13:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/21 4:18 AM, Qais Yousef wrote:
> On 01/16/21 18:11, Yonghong Song wrote:
>>
>>
>> On 1/16/21 10:21 AM, Qais Yousef wrote:
>>> Reuse module_attach infrastructure to add a new bare tracepoint to check
>>> we can attach to it as a raw tracepoint.
>>>
>>> Signed-off-by: Qais Yousef <qais.yousef@arm.com>
>>> ---
>>>    .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
>>>    .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 21 ++++++++++++++-
>>>    .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  6 +++++
>>>    .../selftests/bpf/prog_tests/module_attach.c  | 27 +++++++++++++++++++
>>>    .../selftests/bpf/progs/test_module_attach.c  | 10 +++++++
>>>    5 files changed, 69 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
>>> index b83ea448bc79..89c6d58e5dd6 100644
>>> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
>>> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
>>> @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
>>>    		  __entry->pid, __entry->comm, __entry->off, __entry->len)
>>>    );
>>> +/* A bare tracepoint with no event associated with it */
>>> +DECLARE_TRACE(bpf_testmod_test_write_bare,
>>> +	TP_PROTO(struct task_struct *task, struct bpf_testmod_test_write_ctx *ctx),
>>> +	TP_ARGS(task, ctx)
>>> +);
>>> +
>>>    #endif /* _BPF_TESTMOD_EVENTS_H */
>>>    #undef TRACE_INCLUDE_PATH
>>> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
>>> index 2df19d73ca49..e900adad2276 100644
>>> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
>>> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
>>> @@ -28,9 +28,28 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
>>>    EXPORT_SYMBOL(bpf_testmod_test_read);
>>>    ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
>>> +noinline ssize_t
>>> +bpf_testmod_test_write(struct file *file, struct kobject *kobj,
>>> +		      struct bin_attribute *bin_attr,
>>> +		      char *buf, loff_t off, size_t len)
>>> +{
>>> +	struct bpf_testmod_test_write_ctx ctx = {
>>> +		.buf = buf,
>>> +		.off = off,
>>> +		.len = len,
>>> +	};
>>> +
>>> +	trace_bpf_testmod_test_write_bare(current, &ctx);
>>> +
>>> +	return -EIO; /* always fail */
>>> +}
>>> +EXPORT_SYMBOL(bpf_testmod_test_write);
>>> +ALLOW_ERROR_INJECTION(bpf_testmod_test_write, ERRNO);
>>> +
>>>    static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
>>
>> Do we need to remove __ro_after_init?
> 
> I don't think so. The structure should still remain RO AFAIU.

okay.

> 
>>
>>> -	.attr = { .name = "bpf_testmod", .mode = 0444, },
>>> +	.attr = { .name = "bpf_testmod", .mode = 0666, },
>>>    	.read = bpf_testmod_test_read,
>>> +	.write = bpf_testmod_test_write,
>>>    };
>>>    static int bpf_testmod_init(void)
>>> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
>>> index b81adfedb4f6..b3892dc40111 100644
>>> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
>>> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
>>> @@ -11,4 +11,10 @@ struct bpf_testmod_test_read_ctx {
>>>    	size_t len;
>>>    };
>>> +struct bpf_testmod_test_write_ctx {
>>> +	char *buf;
>>> +	loff_t off;
>>> +	size_t len;
>>> +};
>>> +
>>>    #endif /* _BPF_TESTMOD_H */
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
>>> index 50796b651f72..e4605c0b5af1 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
>>> @@ -21,9 +21,34 @@ static int trigger_module_test_read(int read_sz)
>>>    	return 0;
>>>    }
>>> +static int trigger_module_test_write(int write_sz)
>>> +{
>>> +	int fd, err;
>>
>> Init err = 0?
> 
> I don't see what difference this makes.
> 
>>
>>> +	char *buf = malloc(write_sz);
>>> +
>>> +	if (!buf)
>>> +		return -ENOMEM;
>>
>> Looks like we already non-negative value, so return ENOMEM?
> 
> We already set err=-errno. So shouldn't we return negative too?

Oh, yes, return -ENOMEM sounds right here.

> 
>>
>>> +
>>> +	memset(buf, 'a', write_sz);
>>> +	buf[write_sz-1] = '\0';
>>> +
>>> +	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
>>> +	err = -errno;
>>> +	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
>>> +		goto out;
>>
>> Change the above to
>> 	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
>> 	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", errno)) {

Here it should be ... "failed: %d\n", -errno.

>> 		err = -errno;
>> 		goto out;
>> 	}
> 
> I kept the code consistent with the definition of trigger_module_test_read().

The original patch code:

+static int trigger_module_test_write(int write_sz)
+{
+	int fd, err;
+	char *buf = malloc(write_sz);
+
+	if (!buf)
+		return -ENOMEM;
+
+	memset(buf, 'a', write_sz);
+	buf[write_sz-1] = '\0';
+
+	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
+	err = -errno;
+	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
+		goto out;
+
+	write(fd, buf, write_sz);
+	close(fd);
+out:
+	free(buf);
+
+	return 0;
+}

Even for "fd < 0" case, it "goto out" and "return 0". We should return
error code here instead of 0.

Second, "err = -errno" is set before checking fd < 0. If fd >= 0, err 
might inherit an postive errno from previous failure.
In trigger_module_test_write(), it is okay since the err is only used
when fd < 0:
         err = -errno;
         if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
                 return err;

My above rewrite intends to use "err" during final "return" statement,
so I put assignment of "err = -errno" inside the CHECK branch.
But there are different ways to implement this properly.


> 
> I'll leave it up to the maintainer to pick up the style changes if they prefer
> it this way.
> 
> Thanks for the ack and for the review.

No problem.

> 
> Cheers
> 
> --
> Qais Yousef
> 
