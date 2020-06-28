Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1C720CAB2
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgF1VA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:00:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726080AbgF1VA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:00:28 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05SKtvHD018343;
        Sun, 28 Jun 2020 14:00:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cD1RrrOXAAIaLq8HgR0iI72VtEcHBwLR6ot6IuNiAE4=;
 b=bPjCyQEqDwqnRfTosPMkrsbKzxPSQUjRqLLz9gmm1vEVfOyAl1d/j+Ytc6IcK0kgd/dj
 yl3QcKLLFj+td2tyqF+x1ky853GWXULPO/+fuXWhMKzfntntdT5+t1fKrcVnJWnpCWXI
 /8H8UxRYB37j1VY3Tqgx2Xp2weXM2IPHSEM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31x1kymjcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Jun 2020 14:00:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 14:00:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMqRQqMxBr30/c3ltFF5DoHF5T+0YPJQwUBX8n/0/dLZPeckuspjlEa/dNVq3bAxZCK6agaVaXllyieETXW+g0lhmhCcMX+1nLzpr1DMd/aALqudlP4tqthHwvWdtb2nNJ2pR0uTsi01ZWuodN1m2917Zx4XM7Jd8BYn9Hz/O9TsS9ZXMO9/o+VmuEfiLATzFND8ikyYTB8LVRwHWSnIBW2S+J2/eBdzMQ+7CH+Z6jkDBfPQoHbUfbJyATPBK5nYyG4oPzynAjPShX/b+vB5pOATz4lcYfNQS1f7OUwQoySF5EAwMhGyFlTuLI5AVDih/r7wqSd7A5DwqSYldHcREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD1RrrOXAAIaLq8HgR0iI72VtEcHBwLR6ot6IuNiAE4=;
 b=keSoA2Cd/qwxTiq5x9H2T/ozmHLC/k4oWC7d7UsTccy2ND5bYReHd6ffFA7zp+Ok9SmuSROSx5gG50ztrnwBMVNvuNnyjB20qbmrfoEfHaqjKRxbVgfpVjGjVhkdEtA7/6JV1xdawQgkiJHErdOAZwxlAddIEV61/BB2d/2+UTCldMwb5kdM/cP7dHSw18KRsOpsyxxHBdba0bjsu9ATWf29HntRFKs2tqWxqPQ544N60DHqCHllmTr5ddhVGrA9cQx1BKkLl13F2qe2bAhjZ2/ibe8ladKBR6GYK2qBcNBHC0ZMQJSn58OwhIXh6PjPLjyZDjatRe+YXqDJNHYpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD1RrrOXAAIaLq8HgR0iI72VtEcHBwLR6ot6IuNiAE4=;
 b=X3r3Yu96+EGZmKKgbmdJH5pVzQAmB2XS3yfkfDZbkFVfkbXmDWwO0b5rBGGpKfkGNzEqGLY0toXJq219bpYiSdo2yc8gAl60lOhQHRVrH/Yx5QE4uTCqw3WuSkuOajs8hKI5b+k7oTBXVKakA1r/ovpmqdQ9QNRF5tBjYIGYo9o=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 20:59:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 20:59:57 +0000
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
 <20200628201608.GG2988321@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7c0a5ea0-9425-071d-0f41-b7e5c5ef04f0@fb.com>
Date:   Sun, 28 Jun 2020 13:59:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200628201608.GG2988321@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::42) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1085] (2620:10d:c090:400::5:860f) by BYAPR05CA0029.namprd05.prod.outlook.com (2603:10b6:a03:c0::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.12 via Frontend Transport; Sun, 28 Jun 2020 20:59:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:860f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd732151-f214-40b1-2e73-08d81ba636e2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB282414C364855706825C11B8D3910@BYAPR15MB2824.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhFyVzB1BITEt7xCEGeDZ14kJwGjfcg3+jpEoK4q2/mvn/Wq+96tqVNj/zbeZ+zq9C9o05lRevPC1fctVXCY4BOR71v4FqATYk/dEAgYYVnSi3gKeR1yO09RsidyQpsUv0LS4yWL+MG5e93kXub+5oNyepNvVGwjECasxmA3ut13TC0l6aqsSWgbQvCH5VyELQ5+L9HYx3BfqjSIU0hkZUyHlcuhwFqu68AuJa0RGz+qW4E6zwhos0dXK/9G2zOhMAwX3GMRsmSRJuUqUulr85YSLptdeCyRbkp6K5+6MycgjOtoO3vlQvwBG00HGLQIabxOa/9AkLD7pW4OynYsWpEDYDJMSRCGee4DRuqkJbEmkgrKxpbSJpte9eMqdMGK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(4326008)(52116002)(66476007)(86362001)(66556008)(36756003)(53546011)(83380400001)(54906003)(66946007)(2616005)(186003)(16526019)(2906002)(6486002)(8676002)(8936002)(7416002)(478600001)(31696002)(31686004)(316002)(5660300002)(6916009)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: guCWBLe3OvKlVSbiaflGQZmyTKGo3y8YmEuV/Vo9MO5SPPAWkr1PSZMVMvhHjFWV85hrTnN9mHbv+eTiDhKoEFG4uSU9ug+6EXHgx264cO8TgD3L4FJ1MiI8SfguzzLX6QAmibHBbZKu3zDiC5YpVpShXa3bWSefV6cHPVEjYr5H2QH71gqoqtonJWXR5g7+/pbsvBvyb49kMvbi0fN/2G26RfSWQsQiC6Hw3k+ePbTCRRnEDHxG/Xc7kNQYnlL19b3T8DX75vwmNbLgNh+xa5PFZ4wx/dYsJUPmWRCnFhlr/01s9XMhtza62P+AwTNGW8/08E5EVxYlG69J3k8UAtI5wUoHBVwPrClTM2Ybq+aVjaPEEoN1smeM/h+q2ZI/5+kLPGJlTRm6/kMByv/jIWOjlUqLjaS8BULnKf8re6Tdk/vYolxQgpcHo5MIyEMq6O4hxeqO2MGDtD6JIQDAL3lHrOvHTeTmUJABMF9mFbTXwTA2R3GHFXcJDV1/jv9RZbu2TXLxXk+ns/pIf2zQ9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: bd732151-f214-40b1-2e73-08d81ba636e2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 20:59:57.3558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CVUuV0LkHl3hAroQnOulozVf1apAS3kZ3ZG336foXAHYzz3Btegkshf5aEPpqlj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 cotscore=-2147483648 spamscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/20 1:16 PM, Jiri Olsa wrote:
> On Fri, Jun 26, 2020 at 02:36:37PM -0700, Yonghong Song wrote:
> 
> SNIP
> 
>>> -	}
>>> -
>>> -	t = btf_type_by_id(btf_vmlinux, t->type);
>>> -	if (!btf_type_is_ptr(t))
>>> -		return -EFAULT;
>>> -	t = btf_type_by_id(btf_vmlinux, t->type);
>>> -	if (!btf_type_is_func_proto(t))
>>> -		return -EFAULT;
>>> -
>>> -	args = (const struct btf_param *)(t + 1);
>>> -	if (arg >= btf_type_vlen(t)) {
>>> -		bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
>>> -			fnname, arg);
>>> +	if (WARN_ON_ONCE(!fn->btf_id))
>>
>> The original code does not have this warning. It directly did
>> "ret = READ_ONCE(*btf_id);" after testing reg arg type ARG_PTR_TO_BTF_ID.
> 
> not sure why I put it in there, it's probably enough guarded
> by arg_type having ARG_PTR_TO_BTF_ID, will remove
> 
>>
>>>    		return -EINVAL;
>>> -	}
>>> -	t = btf_type_by_id(btf_vmlinux, args[arg].type);
>>> -	if (!btf_type_is_ptr(t) || !t->type) {
>>> -		/* anything but the pointer to struct is a helper config bug */
>>> -		bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
>>> -		return -EFAULT;
>>> -	}
>>> -	btf_id = t->type;
>>> -	t = btf_type_by_id(btf_vmlinux, t->type);
>>> -	/* skip modifiers */
>>> -	while (btf_type_is_modifier(t)) {
>>> -		btf_id = t->type;
>>> -		t = btf_type_by_id(btf_vmlinux, t->type);
>>> -	}
>>> -	if (!btf_type_is_struct(t)) {
>>> -		bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
>>> -		return -EFAULT;
>>> -	}
>>> -	bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
>>> -		arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
>>> -	return btf_id;
>>> -}
>>> +	id = fn->btf_id[arg];
>>
>> The corresponding BTF_ID definition here is:
>>    BTF_ID_LIST(bpf_skb_output_btf_ids)
>>    BTF_ID(struct, sk_buff)
>>
>> The bpf helper writer needs to ensure proper declarations
>> of BTF_IDs like the above matching helpers definition.
>> Support we have arg1 and arg3 as BTF_ID. then the list
>> definition may be
>>
>>    BTF_ID_LIST(bpf_skb_output_btf_ids)
>>    BTF_ID(struct, sk_buff)
>>    BTF_ID(struct, __unused)
>>    BTF_ID(struct, task_struct)
>>
>> This probably okay, I guess.
> 
> right, AFAIK we don't have such case yet, but would be good
> to be ready and have something like
> 
>    BTF_ID(struct, __unused)
> 
> maybe adding new type for that will be better:
> 
>    BTF_ID(none, unused)

Maybe we can have a separate macro BTF_ID_UNUSED macro
which simply adds 4 bytes hole in the .btf_ids* section.

> 
> jirka
> 
