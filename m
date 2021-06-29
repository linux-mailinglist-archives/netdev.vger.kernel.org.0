Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6153B777B
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhF2SAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:00:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234281AbhF2SAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:00:34 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15THoVod026863;
        Tue, 29 Jun 2021 10:57:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Nb9lTXwrQBl+PRr9TK2b0Hvu5pyWuHLj3bwpGx9GXL4=;
 b=J6MAxCclcgKxbK+Fa8QbzXfHcB7tTZKl5moymb/OeoPQfuMb96eGnsdVg/PSryjF90TN
 oxm1P/sOiNVO6Ph8lqMMpzWOJ8+egHE9aOM/iS/dQ89KlkBG2Dhk8Hj8CIf5tiicW6kA
 UHR9Jd3UBI97q8ofpl8G3PIClOTjUYotngI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39fkfgyau7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 10:57:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 10:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTxZ56sKMNw7WPZZL4I+pzNPL8n2vCwDWWNfuiLw8zKZdQby8cjENPeS90ZjRDoIO+eiw0/9HTi9sLgebv6L4bL9NoP55ktwjTd63ufv7ko3zdJxbII6b+ULatShqZIp8OQOyTk4OfSTwa/ETFqLZ9ywwoi/BLtZjlie78AsDDb+QqyhOzMOJWhPcjPQAg7Ax/IWhpoeeLXdilV+Ygx6XMy77BSZZHVh8ux1QBGisQAX4sWqzmB0wfPjwHfQRAQ5PNt1fh5CdH4Q9D8L3xyFOVRPrQSzVmLRdAK8geqHDclTsG11DCHS2uEMruaybRxV4nmUgpGeWRTW3nXriQIiVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb9lTXwrQBl+PRr9TK2b0Hvu5pyWuHLj3bwpGx9GXL4=;
 b=V7gWMo53talf4jU/NaNAKFnw26ZdQH4gtBe5BICvKlxZES/wjIkBxyAoyIijiLtq1I8p7jnlaonUX8LTQZMTA64HoQf0qFNzaTT346Rw8X2BEXyouBpIsvhilDjCib8dKoYB5wGrE7Mml7rl9uyuYqodT5llFj3uT2X3/GYMGCC1RW46A25/ElvZoDu4psBN3aw8THXyTdcldWTjnzfn9nGelW+YnUPKBta5ywOP3cFT7Ykkjlf5bd/EtzZsRXZ6ZfFjyCxXEFAGeWSEmCtgsgxzbFxEG/puGiEVMJohZYYrCrHROTw//U0jKvXu2PC6VIfBKDzwi3yyKsQ8NWzsKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3982.namprd15.prod.outlook.com (2603:10b6:806:88::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Tue, 29 Jun
 2021 17:57:49 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 17:57:49 +0000
Subject: Re: [PATCH bpf-next 6/8] bpf: tcp: bpf iter batching and lock_sock
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <20210625200446.723230-1-kafai@fb.com>
 <20210625200523.726854-1-kafai@fb.com>
 <6be60772-4d2a-30b0-5ebb-f857db31c037@fb.com>
 <20210629174458.2c5grwa37ehb55wo@kafai-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <387750f4-4610-0c37-60c5-06e5a1c98e63@fb.com>
Date:   Tue, 29 Jun 2021 10:57:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210629174458.2c5grwa37ehb55wo@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6625]
X-ClientProxiedBy: BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:6625) by BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 17:57:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc17125f-221a-496c-ba11-08d93b276882
X-MS-TrafficTypeDiagnostic: SA0PR15MB3982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB398273E6F2E652ADA6C78C78D3029@SA0PR15MB3982.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Po1ZrjMdWrIBX261tRRclXGWd3QjCvh0X88eG8shcoNi1Pb/y4Y4zPkisaiq46R+q6KztwZVKc/cU7yV/2fKwx0k1GKcjWPIwIrHW2wZbaFP3p6VKcAe6NDjXOwZuUzU2J5HaSQS4ZsjqHIytSAB4iX5pP0Kuva/eE4+9/PZA9AKCKfkVXU4BPe2H23MhGfgk03fVG73nqLCor8WlmKrNBS9ked0XdYxxnhgGuBZXSHHXpj0zV5AVF36SnlfjxFveTd2siT8JyTGdmfJaUa8Ao8ZcYxDhJ43g48ZJ692iK7rRdhRpeGSUYnNmErdMOFumKq6p02nUbANAeXL8rRQDzu2MzrM4oJnDVhz2KZ8gtERonPAZ5CcyvlnDUxYtD8sxQAbLhTgTJDJ0/m0VTNAHc0+elDWXGX97KW6wZ7mBeaXVIQhjeMhR/Nsj0IHjozpAhUcuod6q3yCjMftGsiQyj84Fc0bPcpIbkwelLzQ+4vL2zCMQ1XDDE2QHGvHHDwA9K/uUegbAKH6Ev716t98O/ouz3hUCqjRYIG+Lino/Sho2pcsV3zO9dPXcTrLS/dKcjJA0ffkveqqBpE500oUXtpDVr1beWv3MmXpWSOCACZB7sIDLGVErFJXAwHCj3g/4ixpZihxcNIBq+B3lt9W7tKH/VzQMxE6i63V7WGQMKyeg45TuVGTd7GrozvRxxczVhKmAbNmRCt19Ndy+pqpWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(2616005)(52116002)(83380400001)(6486002)(478600001)(31696002)(86362001)(2906002)(8936002)(54906003)(66556008)(316002)(8676002)(36756003)(5660300002)(66476007)(53546011)(31686004)(6636002)(38100700002)(16526019)(37006003)(4326008)(6862004)(66946007)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajFsQ2lORkFxdGJpWk54ZVZXcTRFSzFBWENKeVpwOUU0eThPRVI4QkxmVjJ5?=
 =?utf-8?B?THd5dTVGV0w5V0U2S1ZGQUFtell2SVovenZRQkVUQVh3Nk0yaUZ6SEY5OG9m?=
 =?utf-8?B?QXNQemRIMDhqWTFaeGlEaUhKQU9EelFLamdaT0hndTBtTDNwRUl1S2hKaXox?=
 =?utf-8?B?bWQ2YXE1L1N4VHo2aEQ0R3FkaThjb0p5TURHVDlnKzd3MVg0YVdqelROYTVL?=
 =?utf-8?B?MFUzeWpHbmxQd0FyTi9kSTM5LzVPKy90VmsxRjNmTnVUOTh1cFo2djRWTnBP?=
 =?utf-8?B?LzFadG94VmJINXVLeDZkbjdsa3orVmRkZHNKMi9HTnB6RzFtWFNNOC82ZlRy?=
 =?utf-8?B?Z0hsNUtXNWNxemZRVkVqN3RkWEhyWk5tZ0p6TXV0MXlUbDErNmwyN3dHbDBq?=
 =?utf-8?B?QkExZjhqUFl6QUxJY0J3ZXhjZ3NvVGZqdGJ0N2VwR0I3ZnJOb2cwamdpWkZF?=
 =?utf-8?B?Y3B6a1ZIWVVPaFBrWVVvd2VmUlJ6dEhyVDZQSzFiQjRoMzFoejZBZEtQM1BY?=
 =?utf-8?B?VWpUckVYMUovR254eHJWMlorTmp0ZGlOT2hDejF6eXdSaDlFU3FWek4zZHZB?=
 =?utf-8?B?Q3BwT2hzaGNEaDl0dnQ4NHQ0OVdxRzVGblJXc1oydFgwUElKRDdsdFI3ditR?=
 =?utf-8?B?VnUvZnlVSFJ4SFpJUUE3bHNlZU9WS2R4dUZ2RUo2MDh0T2x3U2dRTm9xcTlh?=
 =?utf-8?B?TTNZa0RkbVB4azhiVGlZMXcrZHlDcEFML05CY0VUNVFtUGgvRnJaQ3lHNUFi?=
 =?utf-8?B?dTAvR1R2WjI3THBJZjExeHNGVnl3ZmZObVJCYjA5VG5la1B4WENSUFpDT3NL?=
 =?utf-8?B?eEZKTmlFeDhXTTlvcXlXY2NOVmM0ZGtFbXlVbkpjc3lkNjlKL2daOVFZa2tE?=
 =?utf-8?B?MXd3Y2ppc1JlN2ZERHlBdFNxVE5UeGlTS3dnVmZyek9qWkRjYWpwekxoMC8y?=
 =?utf-8?B?QUJ3RnRydjl5RWxWUGRndU5IbkV2S1FBa0t5Y3ZHYkloY3N0WnduTTB2STY4?=
 =?utf-8?B?MFVLZ3daaHVxakZqUlVzR09zMExWRnI5cW9NSTAxOVZOQ1pNR3lCT0Fxa3p3?=
 =?utf-8?B?WEt6MEdmb3pDVVZhSEtkMXRyNDUwa21tWHhLR3B4Tjdtd3o5azY5c01EVG1N?=
 =?utf-8?B?RzFUcDlHb241cHprZ1ZjRXFEOGtWbFpjbnN6UHFiMEwrYzZpckV4RjF1TXc5?=
 =?utf-8?B?SUNIYkFmbnNsUHIxeSt1Mi9ia2owaUVVWnBucUlJQXppT0p2SUFsajZGQkFh?=
 =?utf-8?B?TTBiTDJkNXJVTVV0RERGbFZMYXBZVEVtTVdRNHpvOHdkc1dxZEVjS0FXM1FT?=
 =?utf-8?B?amtCN1gxN01xQjZtcm9rbUJ1RWFFODNMbGlWMjh6RSt3b2dVUjQrNkpCcmUz?=
 =?utf-8?B?SitGRGZob1VsQWcvWDZBZTJpZVdJcFZNNnJ3Z1RLY21HcUhGaE9WSEc5UnhZ?=
 =?utf-8?B?QXBlNWZKQll4TGYycDhXdlM5aGNRRXJrL3VYemswZm5NVXFGNit4VEpjbzF6?=
 =?utf-8?B?L1VjdGxIeldJYVhma3J5bEhjeDVpVDFLTk1MWnkyY0xEK0FEclVKM1BKdi9K?=
 =?utf-8?B?STFDSTZuY1lxRmdYazU3ODQyTU1kYmIvbktackU2dW8raEFmVkN0UkFteTZM?=
 =?utf-8?B?WHFjbzVCWGNCd1VaaXJHVGFuMm1hbk9kRHltQXJyZnFmaTdCbklLbW4zNTh3?=
 =?utf-8?B?WWVRMElYQmNzTmRucmlTSWN3WHNzYUg4YmR3YXo0VU1HR0VwN0hDeERPQUFM?=
 =?utf-8?B?bzZrR1FCWTFYWHI1cXNnUiswYmRYdURlYXo4Q2dFTjh6RUhlOXd6T2JMRC9n?=
 =?utf-8?Q?X9dmCX9NDt5p9CFuW7k/024t+YoL5qmkZwssE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc17125f-221a-496c-ba11-08d93b276882
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 17:57:49.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gjLFPc93qcqK1ydEgCpEwNH0kGevokAWzEKydHMVYwb91I3fTfzDn2cpWQy0EM/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3982
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Dzzj-9ZJm95lD3bh7hxsKgVT1gW1de2c
X-Proofpoint-ORIG-GUID: Dzzj-9ZJm95lD3bh7hxsKgVT1gW1de2c
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/21 10:44 AM, Martin KaFai Lau wrote:
> On Tue, Jun 29, 2021 at 10:27:17AM -0700, Yonghong Song wrote:
> [ ... ]
> 
>>> +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
>>> +				      unsigned int new_batch_sz)
>>> +{
>>> +	struct sock **new_batch;
>>> +
>>> +	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);
>>
>> Since we return -ENOMEM below, should we have __GFP_NOWARN in kvmalloc
>> flags?
> will add in v2.
> 
>>
>>> +	if (!new_batch)
>>> +		return -ENOMEM;
>>> +
>>> +	bpf_iter_tcp_put_batch(iter);
>>> +	kvfree(iter->batch);
>>> +	iter->batch = new_batch;
>>> +	iter->max_sk = new_batch_sz;
>>> +
>>> +	return 0;
>>> +}
>>> +
>> [...]
>>> +
>>>    static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
>>>    {
>>>    	struct bpf_iter_meta meta;
>>>    	struct bpf_prog *prog;
>>>    	struct sock *sk = v;
>>> +	bool slow;
>>>    	uid_t uid;
>>> +	int ret;
>>>    	if (v == SEQ_START_TOKEN)
>>>    		return 0;
>>> +	if (sk_fullsock(sk))
>>> +		slow = lock_sock_fast(sk);
>>> +
>>> +	if (unlikely(sk_unhashed(sk))) {
>>> +		ret = SEQ_SKIP;
>>> +		goto unlock;
>>> +	}
>>
>> I am not a tcp expert. Maybe a dummy question.
>> Is it possible to do setsockopt() for listening socket?
>> What will happen if the listening sock is unhashed after the
>> above check?
> It won't happen because the sk has been locked before doing the
> unhashed check.

Ya, that is true. I guess I probably mean TCP_TIME_WAIT and
TCP_NEW_SYN_RECV sockets. We cannot do setsockopt() for
TCP_TIME_WAIT sockets since user space shouldn't be able
to access the socket any more.

But how about TCP_NEW_SYN_RECV sockets?

> 
> Thanks for the review.
> 
