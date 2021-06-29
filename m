Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5430D3B7814
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhF2S6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:58:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234139AbhF2S6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:58:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TIho5H029062;
        Tue, 29 Jun 2021 11:55:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zMX7kIKdifiTtuWWs2DfObu5cAxF9cT/BmSUYv23KfY=;
 b=JPKJ2t2R5RHYrJuVxA2jTyTCmWmirQJZxIB9w3ux32AZqhKdRL3Q+2grWaXBDiEpMJXD
 gHJLmMm+4t/aED745Zxm3bE2cewrDkWHodzFV+xXFu3SJRyXQG+Zwzx6Fr9tN/MUPXWe
 X8eJuDribz2zUQh54AftzjeC4ycQrn4vV8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39fg3ask65-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 11:55:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 11:55:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgIHg3qN2G8SGr8osa4glVfJdNPIekI9Ju+5vBF3knXLtoLKdS0i1o/IP3KvwkmStjU/SYbFP3079bZKgyl5LRNigP9WxGoVu0Gx1Pk4FdSC+wnozk0YXSfo8BquRSyRxxLMNUclzGA2PO/VbWEeY8Or57/JFJO8ojP4BAwxP185D8QNa1aSJs2gj2UnLNPtb6iCJPL6qmFn4fh9MObkIlMDaf3ujij03WjedMsOZOc0+CUcTqnYsZwahjawmWFqcbiOZeLFf/41I0qMKcUAZxwqyTZKSciOYuVOlLmYzW9t0iVrLq76YnOSf/BZOxnqO63Y6bemXF2tSb/xxwIv1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMX7kIKdifiTtuWWs2DfObu5cAxF9cT/BmSUYv23KfY=;
 b=KHxWhHY+aUlN2R3/L07PDF0rbeu+4PqCQ6WcSX59IlcuEp5TnsD0f1TU0ZMcBw6Hwaskv24w+Gkhhgf9bpJnoqUv0DgEFsDpjU0A0d9ATwPudTcbIjPbxAvMJ9F+b/KE61VqxlWdpf3xOzVTpkgyHCZ43rcMoFbWc6NzKbekhkNkboege+ztqWsxJkBrcFAe57gH4pUiztfcAwNO3753jEXcfu04KJaNpXILYDl77f/bTnv9Ye30SFuZK3RlLQgKpwREpyGX9qZEeuAioLoAZvEN4WS5kBFjXFkn+KbQMX1dkladybbJm288Nh6lM1pJKWGqqYhdrunz8N/gyMVabQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2333.namprd15.prod.outlook.com (2603:10b6:805:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 18:55:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 18:55:55 +0000
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
 <387750f4-4610-0c37-60c5-06e5a1c98e63@fb.com>
 <20210629180603.itvt3kupjnsexa7y@kafai-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6e5864b8-ab64-68a6-b2d3-d5c9b9468f57@fb.com>
Date:   Tue, 29 Jun 2021 11:55:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210629180603.itvt3kupjnsexa7y@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6625]
X-ClientProxiedBy: BY5PR17CA0056.namprd17.prod.outlook.com
 (2603:10b6:a03:167::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:6625) by BY5PR17CA0056.namprd17.prod.outlook.com (2603:10b6:a03:167::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Tue, 29 Jun 2021 18:55:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77723760-02ad-493f-5f72-08d93b2f865c
X-MS-TrafficTypeDiagnostic: SN6PR15MB2333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2333A3016A8F32BFC8737824D3029@SN6PR15MB2333.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ve6Qz1FpOg0PX0LjZuISvo2E5AR0c8n13DaS8MxDyjvFRm+tiacWHu2bziI6djEACRGiGUjNy8GXWBxOcDbT4J66t5UC0kSWyfcMjTErW4jr1BhqJEubbRE6LDzkAh/za07ipnJX3bX4OhWK/xQ8+Dv6L2dOnl+nQlftYUL9Lbpmq9nBwIqMKxnBSC/Tu37X+TvX/chqMiUg4W1JI7KcB7JCG6kq9uM9R0fGjL2TtRwmLPDMkctj+1/XC3xTWgrunpiKoVmWrLAYkg+HT7eeoJA+MgPLmfnRH/LjHndOvDTAnge1QLINDahz6sLLc4DtpkF3PcrG8SJTT8Q53ukuteD79kk3ixyuz1jOxqu590X7OJ+KQ7lMhds+E/B6xqP0zD9fxCS2YSIXYJsN1T0UxNNZgJOQBMnU8I9/ykhCZ2VgOjGkCZpbeAmOUiB+hMQ+j0X7PkY6oq6VUBzUsMFBYTr2ecwkjEDNn2z+Vm3W9kQPNqgJ+dvbLUUaYKxcpykE0OhPKYj/yjcBudDepLx6za6yud/WxVUq45MQ8v5o0Cs/8EV6APGJVeHNfLage4NarDp4xpjhUdtNT3IQKvw7kM52YfpQSzJTJWBiXZmhoDQkv7qWHKyph/bAooObXmsYE5qqjneLzlgeTS4oBxwXppip3q/JNOUdJq2r9WNLbus9dUiqnnEZOzA3y5Idt7O3fBQ/tmt5X7lUJxqtyHFTVFTr2OBRAn9qPI+cmcwtcagQ27UVRc+v0ekdYUAfsSa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(36756003)(6636002)(478600001)(6486002)(83380400001)(6862004)(8936002)(8676002)(52116002)(66476007)(66556008)(316002)(66946007)(31696002)(86362001)(16526019)(31686004)(186003)(38100700002)(2616005)(37006003)(2906002)(53546011)(5660300002)(54906003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0U0blBwWEZOMU1zbjNTWGFDcll4Tk9YZ2haWEg1cWVOY2EyVCtrRGljV2py?=
 =?utf-8?B?anVVcERHV1Bmb1RlNnJoMTNVbG1ySHVERm9zS2d5VEgyTGVXNWRnakpCL0sx?=
 =?utf-8?B?ZHkvRFowMHhnckxUZm56MXorRHlXTU9GaGFydnM1M1ZsYzM1RHlYbXFJZWVj?=
 =?utf-8?B?T1U1WUtwQ0l0NU9uSkVsQkJHV1VERW0rMUpiNDUrWkJ1bjQ3SXFHM09uWHVv?=
 =?utf-8?B?S3N6UVg4MDBvdTBTNmhiOXRBRnJCU2twU01PdEtmejF2dkFLMDd4cGRCYlpm?=
 =?utf-8?B?ZkxGd2Q2R2tSaWR2Tm0xWmZ1bTRVaUZmR3JKVTZPQkcwNmpaTjJEcEJOeXFB?=
 =?utf-8?B?TFhRV1FxZlFVOXFrVGJ0cU1JOWpUdktRaU1takJyMWFSd1h4WDRYMlZtNk5o?=
 =?utf-8?B?emhCSmY2dFdNalo2U2RQdHNYVEptSUxOSFBWRThCcmExcG5NMzcwaXpyNHdN?=
 =?utf-8?B?NzM2NW94aGJRbmpRUEw5aHhqUzQvTUFRSHFSWkU1STJjRFlMeUJOK3dReU9v?=
 =?utf-8?B?bDZ3amxkRHQyMGV0UGZYSmdhZGVIZE50V0FaY0poL0Ryd0R0d3VwZEo0RG9J?=
 =?utf-8?B?Q21leHhYc2hwZUFTVjRScFE2aTFGVDg0SEMzUERRR21YVlFWYUJaTi92dXVH?=
 =?utf-8?B?YjRyalFPQ3ZHc2dvbDBxNU9WSUZBWGtrQlBIK0lXSEdZOC8rOTJTdWsvaito?=
 =?utf-8?B?bDBQTW8wQmUwRUluOUp5ZlZaSnRKQ0RIN3p5QnBkTkozaDZuV3o5SUFRWUN3?=
 =?utf-8?B?YllsMU9TeDM1STQ5VFFRMjFiTzBzc21iTnpQWlBQdzdtN3E5bU5iUXZZeHRi?=
 =?utf-8?B?Mkl0akJqYVRzdjlPSlJILzR1bWZBSmRPVFNZeWlpV3FoK2VqZDMvYkRzNWsr?=
 =?utf-8?B?UklNR3pxVnRRVG56NGxUWkQ2L0tCWXRIdWZMZEN6RVd3UnFKcFhGRGF5LzFV?=
 =?utf-8?B?a29oQUlWcHArRnkydE5YbmFsUmdxRlNCS3FlUmdCTjNFNUdYVnF2bCtRVXlY?=
 =?utf-8?B?dWdsRnpOR3NRMjRNVXNHc1dHa1BncEtxWDI5R0JSTzZ3WC9rNEo5U1pUb3hV?=
 =?utf-8?B?MkhwQ3NqK0FqWHQvZXJoRzhSMWswQkxsUHNoK3JqeitLWmhnZnJ1QlpMZ0RY?=
 =?utf-8?B?YUhBMEtRQ01vNzRwTzhTT1JIdE5wYlJsb29XNTMxcitnYytLVHVKUlNraWlF?=
 =?utf-8?B?TVlyaVpoS1dHQnVGY1dqb1VxTkY5VjVpVEhPZFhuSWJ3b3FZZnRrdjRHT2ZK?=
 =?utf-8?B?dnMzWkNHdjNhS1FsT1FodDdxbVZZOVdoSlRpTzZWem1nMmZnUVdkRktha2k5?=
 =?utf-8?B?SG1zN1lqRkRLaEFjcC9GSzFIRWtXazl3ZmxLc0dyVTlZVmZTQUtxaTFHSUky?=
 =?utf-8?B?bzRTQkwrT1VJWFdyOWpjdlZVZy8rMnBrTytrVFR5ZDhINEVWSWQ2cTR2c3FK?=
 =?utf-8?B?c3dEWmc0VVFZTlFUSHN2VTV3WDlyRCt2S3ZNdzBJUElLaTFqT3hxY3k3TEwv?=
 =?utf-8?B?Ym5oRlN2eS80RFl6VnpLOVdXYTBOUytzRG4xYVpwMHU2YWxkUy9CNWlxM0hv?=
 =?utf-8?B?cWxKZzJOZHRFWFQ5YjVacHMwMG5TUzY1amZvOXBxM3o4TWNIbHJGVTgzZ3o0?=
 =?utf-8?B?M3JRWDlSWjJtbTl1dEc3QnNXM3MwZGh6Ujh0dGsrT3lYZG95RDYzdHhNTTM3?=
 =?utf-8?B?bGRtZk1OVS9CRFBpVVRsZHJENitzM1BRQWQ4eHRLdUJGNkZmdnZFeGtSQ2Iv?=
 =?utf-8?B?VDdJRlV1UnE1RG9tTVRmK09JYkMwQTFhbWJYbEFZcEJWdWx2QmFJc2tYd0RU?=
 =?utf-8?Q?SfUleMPg6r8sGCb+rwdRiGCkDJAZ9yS4cZ5xA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77723760-02ad-493f-5f72-08d93b2f865c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 18:55:55.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvuxmzJbOUQM2PW3DGcJPTclxVZx3DeZ2GPZfDLfZJGT7obS/Wa7ptKK7hmKUP8Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2333
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: o_iahVZCS3eQ-IcG0rx3gxuDPTIWla52
X-Proofpoint-ORIG-GUID: o_iahVZCS3eQ-IcG0rx3gxuDPTIWla52
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/21 11:06 AM, Martin KaFai Lau wrote:
> On Tue, Jun 29, 2021 at 10:57:46AM -0700, Yonghong Song wrote:
>>
>>
>> On 6/29/21 10:44 AM, Martin KaFai Lau wrote:
>>> On Tue, Jun 29, 2021 at 10:27:17AM -0700, Yonghong Song wrote:
>>> [ ... ]
>>>
>>>>> +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
>>>>> +				      unsigned int new_batch_sz)
>>>>> +{
>>>>> +	struct sock **new_batch;
>>>>> +
>>>>> +	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);
>>>>
>>>> Since we return -ENOMEM below, should we have __GFP_NOWARN in kvmalloc
>>>> flags?
>>> will add in v2.
>>>
>>>>
>>>>> +	if (!new_batch)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	bpf_iter_tcp_put_batch(iter);
>>>>> +	kvfree(iter->batch);
>>>>> +	iter->batch = new_batch;
>>>>> +	iter->max_sk = new_batch_sz;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>> [...]
>>>>> +
>>>>>     static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
>>>>>     {
>>>>>     	struct bpf_iter_meta meta;
>>>>>     	struct bpf_prog *prog;
>>>>>     	struct sock *sk = v;
>>>>> +	bool slow;
>>>>>     	uid_t uid;
>>>>> +	int ret;
>>>>>     	if (v == SEQ_START_TOKEN)
>>>>>     		return 0;
>>>>> +	if (sk_fullsock(sk))
>>>>> +		slow = lock_sock_fast(sk);
>>>>> +
>>>>> +	if (unlikely(sk_unhashed(sk))) {
>>>>> +		ret = SEQ_SKIP;
>>>>> +		goto unlock;
>>>>> +	}
>>>>
>>>> I am not a tcp expert. Maybe a dummy question.
>>>> Is it possible to do setsockopt() for listening socket?
>>>> What will happen if the listening sock is unhashed after the
>>>> above check?
>>> It won't happen because the sk has been locked before doing the
>>> unhashed check.
>>
>> Ya, that is true. I guess I probably mean TCP_TIME_WAIT and
>> TCP_NEW_SYN_RECV sockets. We cannot do setsockopt() for
>> TCP_TIME_WAIT sockets since user space shouldn't be able
>> to access the socket any more.
>>
>> But how about TCP_NEW_SYN_RECV sockets?
> _bpf_setsockopt() will return -EINVAL for non fullsock.

That makes sense. I think whether we could block calling 
bpf_setsockopt() for unsupported sockets outside bpf program.
But indeed letting bpf to do filtering in such cases should
be simpler.
