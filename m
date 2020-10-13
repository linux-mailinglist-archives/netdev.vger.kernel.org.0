Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104EA28C902
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389872AbgJMHOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:14:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389853AbgJMHOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:14:00 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09D7A1vl012959;
        Tue, 13 Oct 2020 00:13:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1gDJaBbsmq1rmOBko4/rSdiyGnOVMdka0i3B2eim/wU=;
 b=KpnsIGV4ojze34mjayO2lpwGImiH+oDh3lvL/Rm9ZXaSxIGG3tyc8yJ2slZKY6fa9+KZ
 Ri/qtPBpkd9x4ULgPyu3g1VBpLGiSvXs/nVq5CEX5KugJ3Z2jJXQsbGTPUjwAHSlOQ5c
 ZHz/mEMXa23lhrFPey4+fB3SMXsSrtFhaNg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3453aah0c4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 13 Oct 2020 00:13:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 13 Oct 2020 00:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRUP2tyhWZ3jl9eZLQ3a3sCGy08xHPOKu8FapOBnm5HH/tgKQUchRbwVaUyrsyiQan9QZJHyTfjrhSaiVYwtFlUOGnFIUK+CsBJUuR/viGYSI8vsxqN5joToDAvNE3JhJvcZL79bVYnqhwHJoQEI1QU8hFPdQJEVFmUVOac2yPHRwzqceZkfpKV9KHuCqfHh+AcxcJJXNV9o19/hCHERttb6FRqVVhtPRv0sDjkNpJX8ywS0AXSrwkAUD/V5r2A24k8ixf6Mr2uNqWmRCntF3khRNPx4wH22H5NXy7TjeEqQCIOAbsI2p0vlXK1aK73HwuGEtAfYW3IooV9/CAqzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gDJaBbsmq1rmOBko4/rSdiyGnOVMdka0i3B2eim/wU=;
 b=EOAUc/DX5eBhPmV2PgIAn8OEWzbIh1pdj8Eoqc2DguET+vTW1jICBCG9mkNczHXLvLCh6bhDB5JE+zmLc0x1MLUsjNucBicvog4XqCGHYL9Dk4FsT6ikFlpddAUUrNO1VLOgRrKOC673tqx0Y3f/8JEkSeKPCkMPObyFDF4bdOPKS6VtVG3Uwz/QVLm6lgAGlofxUHsWsuHe1FfQQkC/9HvrABwIklzHsxW4OYEhGjmzUBetK2UCWY/X/7iHzWYkWyOwUwh9LKCZlr21wHFaprT9yJONt29cWNiKeHiNByYp1Zx99zMZfu7BPtPQV3tfZEBAGvoUX3taGPPcMjFIrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gDJaBbsmq1rmOBko4/rSdiyGnOVMdka0i3B2eim/wU=;
 b=IcDPoCoZtzuprZGJ7GPv/UXs3jlx5aD+zF6wGgW/RDh3Il4NltUkeK80rM13pAGUtaoBfq28a9N1qVE2C5sgOSB2hPxQCWwLyZnucY+zqAoV1OHpPnNvl/c3DbveGQHWAL3kcBWcwO56HK4DyssziX3Mgc7Yp4xQiliaJkT0goE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 13 Oct
 2020 07:13:42 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 07:13:42 +0000
Subject: Re: [PATCH net] net: fix pos incrementment in ipv6_route_seq_next
To:     Vasily Averin <vvs@virtuozzo.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20201013000920.2120450-1-yhs@fb.com>
 <1bf4d0da-e257-b860-38e9-75ad8c999d91@virtuozzo.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fffa4642-e1e6-29c4-6cac-7b4fd1ec1997@fb.com>
Date:   Tue, 13 Oct 2020 00:13:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <1bf4d0da-e257-b860-38e9-75ad8c999d91@virtuozzo.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:7058]
X-ClientProxiedBy: MWHPR22CA0072.namprd22.prod.outlook.com
 (2603:10b6:300:12a::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::19cf] (2620:10d:c090:400::5:7058) by MWHPR22CA0072.namprd22.prod.outlook.com (2603:10b6:300:12a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.30 via Frontend Transport; Tue, 13 Oct 2020 07:13:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 909e647f-a415-4011-77e1-08d86f4783de
X-MS-TrafficTypeDiagnostic: BYAPR15MB4086:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40862CD47D505CDBEC44C754D3040@BYAPR15MB4086.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f33At5FxODOvq7ypfb+jf2PdY91fo1fUlrtOoISUtg0XUfIxChaQpR1EGKS1DA+/wgAlW1kEvcIJ9DmabkLjip8Ww7yD8W0RyB+I4elaeKYV5fm5+oBgGAQnVVc1X3WIx/D4Vm5qPLJbC1OZf5LZG/t3I7Z+CQbNVeuM0BxmoxZ/MZEEQzF72iDjtW9AjbKn4m6uIOnLzPjeozm7/e8jCg3Qo4hCHTgzGjk+Ajsh6JLjx1FCLptnMDmSrEB1yE1XYiBGuv6/b+nfRgTcK5vixqsftmeBbAwxuGgrPqRPexQEF0v/f+BgtV/hgNRGd/15kDzC3++JY/Pc9g7Jv8am1TS2OllasSgyvjfKyxQY2HN+DTIlr6YoOavUi6duoMZv+x6oa5gfkAZD/8kzYt1RRvDPRFxypW5pB/aEY5S80M/fx+DV7aqJZLnw8r+YzVX8MBZUOapM0B7fmjD2PeP4Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(376002)(39860400002)(5660300002)(31696002)(83380400001)(54906003)(83080400001)(53546011)(316002)(2616005)(6486002)(186003)(66476007)(8936002)(36756003)(478600001)(966005)(31686004)(8676002)(4326008)(66946007)(2906002)(66556008)(16526019)(52116002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZLJzt9yE/ZBch5kUnnH+yGesG8aebPoXTqYmduZOhUkI5RW2xxXaLd1UHMidD6WYWOlBsc6ZWzr19x94TJdwLfk4E/3a38+sgs7TM8YTAhJBMluINqEmayfhmuoq+bIWF92Dwa4bQN313BD92gmDJc1qEZqAgG6kCj/Ex5LmVpZzTuZOs2ssi61tJxjSP60BWRWLGSljUzllqofeTKQ1h4GuVZdt0Akno/eeL7tGRXnNX4BDmRHVa41HnkIrT7wfjC1uBe4Ja3TaU7dwaCWD+JLRK6ZD+1Mei7M8IiissX+ShLnG9ORnFaaIbk97AfwbafmahPzmhTqQBa6AusiWM+poAq6XbfZGg9bUI9Sn0o2vur0IrZHp7x8/cI6gd2BDYTnNWFkmjNk8vIrWpubGjZIHOW1fqoLocemqq55I+CIrJZKf3zJMsAkUlIHZe7Fgul4pIK9kmC8mHBifg4ESiLtmPzBaOw6INHuALdwnmHxpCCvqrvyRKtbKbzWwVns7bk4zWdcqQ9Cf5F0JswD+P5CGO9oQVLKMOXEs1B5t+6Iu3sIOG2sf8njYOYM81QShd6BTLVToHgeQoH9qnoHv9N2/vC4ncme7paQDRnmmcs/kux0+wZNNFSGWzWZsxBLlcJRT9WZOGovAbYfsO8jVp5IZqhuKggahA7LPF540g9A=
X-MS-Exchange-CrossTenant-Network-Message-Id: 909e647f-a415-4011-77e1-08d86f4783de
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 07:13:42.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GQzjb2K803qu6BjLi7/foWZFNvJnQ3e0ceDBIDOkqVxpKNbFbZE/arU/bGLQeY+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-13_02:2020-10-13,2020-10-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/20 11:56 PM, Vasily Averin wrote:
> Dear Yonghong Song,
> thank you for reporting the problem.
> As far as I understand the problem here is that pos is incremented in .start function.

Yes.

> 
> I do not,like an idea to avoid increment in ipv6_route_seq_next()
> however ipv6_route_seq_start can provide fake argument instead.
> 
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2618,8 +2618,9 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
>          iter->skip = *pos;
>   
>          if (iter->tbl) {
> +               loff_t p;
>                  ipv6_route_seq_setup_walk(iter, net);
> -               return ipv6_route_seq_next(seq, NULL, pos);
> +               return ipv6_route_seq_next(seq, NULL, &p);
>          } else {
>                  return NULL;
>          }

This should work too.

I am fine with the change. I will wait until tomorrow for
additional comments, if any, about this fake point approach vs.
my approach, before sending v2.

> 
> In this case patch subject should be changed accordingly.
> 
> Thank you,
> 	Vasily Averin
> 
> On 10/13/20 3:09 AM, Yonghong Song wrote:
>> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
>> tried to fix the issue where seq_file pos is not increased
>> if a NULL element is returned with seq_ops->next(). See bug
>>    https://bugzilla.kernel.org/show_bug.cgi?id=206283
>> The commit effectively does:
>>    - increase pos for all seq_ops->start()
>>    - increase pos for all seq_ops->next()
>>
>> For ipv6_route, increasing pos for all seq_ops->next() is correct.
>> But increasing pos for seq_ops->start() is not correct
>> since pos is used to determine how many items to skip during
>> seq_ops->start():
>>    iter->skip = *pos;
>> seq_ops->start() just fetches the *current* pos item.
>> The item can be skipped only after seq_ops->show() which essentially
>> is the beginning of seq_ops->next().
>>
>> For example, I have 7 ipv6 route entries,
>>    root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>>    00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    0+1 records in
>>    0+1 records out
>>    1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>>    root@arch-fb-vm1:~/net-next
>>
>> In the above, I specify buffer size 4096, so all records can be returned
>> to user space with a single trip to the kernel.
>>
>> If I use buffer size 128, since each record size is 149, internally
>> kernel seq_read() will read 149 into its internal buffer and return the data
>> to user space in two read() syscalls. Then user read() syscall will trigger
>> next seq_ops->start(). Since the current implementation increased pos even
>> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
>> record is #1.
>>
>>    root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
>>    00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>> 4+1 records in
>> 4+1 records out
>> 600 bytes copied, 0.00127758 s, 470 kB/s
>>
>> To fix the problem, do not increase pos for seq_ops->start() and the
>> above `dd` command with `bs=128` will show correct result.
>>
>> Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
>> Cc: Vasily Averin <vvs@virtuozzo.com>
>> Cc: Andrii Nakryiko <andriin@fb.com>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   net/ipv6/ip6_fib.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
>> index 141c0a4c569a..5aac5094bc41 100644
>> --- a/net/ipv6/ip6_fib.c
>> +++ b/net/ipv6/ip6_fib.c
>> @@ -2582,10 +2582,10 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>>   	struct net *net = seq_file_net(seq);
>>   	struct ipv6_route_iter *iter = seq->private;
>>   
>> -	++(*pos);
>>   	if (!v)
>>   		goto iter_table;
>>   
>> +	++(*pos);
>>   	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
>>   	if (n)
>>   		return n;
>>
