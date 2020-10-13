Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FD328C8D4
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 08:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgJMG4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 02:56:43 -0400
Received: from mail-eopbgr70124.outbound.protection.outlook.com ([40.107.7.124]:3559
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727353AbgJMG4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 02:56:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=herp7XSJYUoHBMGXInPc4grARoWwHVaftJtJyn7zeVuCiZWUmJWwfaEdFyOpWikcE0BiQV1iTNyLdofi3iBdLD4TMUp1hbB++wBBtlmcVO1iWqDZGjksRwJMVXiCAG1x9/EWk+4bm0aNm5rlcxOPdMP4u3wAnbUr/L7eh/UI24TnUlfwUZUTE8AwmD/8MBQqPw/6sAqQM1eI13a4F3frNk+71tjlsc7G2t8/4mbAUhLsy4yNxgXwz2/uF2lBk60L5qLYH4tVpDco0GNbU+iRR5AweTV6vtWcMsLn99M6abN9w+yEhDZzTX/h08OLMwvfSzsmue2JjLcyj7jPM6UKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM8WbQeTnDX+x0rgX8cR6uhs+n42TSBXCOsIsk63sh4=;
 b=DDGmYRnxY/JW6W97tRNUU9tEKyiX7TPgAwEkt44MEztb9+ICD8jM0qQdIjJt2cDlAMIGAi72Wjzotkes9pz7U1ZECuwrTqQnq1hUi92G1KWH8Wvwm5xcBRsvNJM3gDQ4wzQdY7fzor1bqZdrQOPwevUBJImqNbmaEYIsChOS/jTyoWVoWF6kCjIPshX3lCkhvwn+kYcwpmRGjc48J8ME0h7CC5By3NS4aEVEecGR+QgWp27ZU7HicjomO65Utvhl2QxfuhoeYGDBKFNglLiwFp8kCCSV4JkrurEA5tJoxhVhgtv4zxkJQeeqG86x1Kh5/ilTXKxu1m+DS31N/37dxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM8WbQeTnDX+x0rgX8cR6uhs+n42TSBXCOsIsk63sh4=;
 b=KZb/p5JXpMB6yKwIEXLmFlTL+WZQoGz2nfa7/JO8YAu2Ixej5+Ex0i0IxxFWUpeFDPC6Ojkuf4ZyZ3U9trVwRw1n/bPnKVJjs4VLTCji36t9JHpMUuS3mZeR8GU2Y4R/0qe62Vrj+xETph4YuseUXSwVCCZCRrDSPvMOOmarIgI=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB3933.eurprd08.prod.outlook.com
 (2603:10a6:803:dd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Tue, 13 Oct
 2020 06:56:38 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a%8]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 06:56:38 +0000
Subject: Re: [PATCH net] net: fix pos incrementment in ipv6_route_seq_next
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20201013000920.2120450-1-yhs@fb.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <1bf4d0da-e257-b860-38e9-75ad8c999d91@virtuozzo.com>
Date:   Tue, 13 Oct 2020 09:56:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201013000920.2120450-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR04CA0068.eurprd04.prod.outlook.com
 (2603:10a6:208:1::45) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR04CA0068.eurprd04.prod.outlook.com (2603:10a6:208:1::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Tue, 13 Oct 2020 06:56:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40b5c320-0d7c-4d9f-a525-08d86f452161
X-MS-TrafficTypeDiagnostic: VI1PR08MB3933:
X-Microsoft-Antispam-PRVS: <VI1PR08MB393393D6AF509BBCF5CF7638AA040@VI1PR08MB3933.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:147;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laZL19gNy7Lzo1ojiyFPBJq0qciY1HDXw5pZxjWtVAX51ywAVQu4X99dTk6lb+yI9aFD6CfYlSeK/l64Zm0Ugmsul2gUHT5Ow8got77OsOPZ0DMsUbE/l/h9amJNEZpWYuNTYfwGEOyt7eQ0x0JjpG4DnXRSeKS+geJEOA6KnHt02dZqxFHc4Yzoylt+Nu5Doc73dBMCokZwxmsu2i9B+5DE6ZLqQcncox0XRoRTaw/lFyAuvOgx0vtXhxrpZ7nDZXuRHhJFVy2N1qToKWx+pJVThoIQ3RzXfx+QNU14MOtyqr60Ikv6YXAgUJDBgxbSUUYALN4iBLuwYD73SVolJYZOhpbF5whD+pi9vsghNrubJ7tIDgZ1Vj5tiYVWdfDkTGBJVzMIuOsPny1uxFafx25A9Mb8l2TZa1hxFr//wFUGQ8+7r0rwKVJ3X25Xci1dBkFutIfNfGhGx8IMw57dwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39830400003)(86362001)(31696002)(4326008)(83080400001)(31686004)(8676002)(53546011)(2906002)(26005)(83380400001)(8936002)(2616005)(66946007)(36756003)(52116002)(16526019)(5660300002)(478600001)(966005)(186003)(316002)(16576012)(54906003)(956004)(6486002)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bWWYGPI/Gh1f3rVkWT8v0yAerOdHJ8XhD/wmdoY4UtkKjJSJ/HVvg9gH7tO4XR6Gn2ebPM+RGe9tFMfII+wev4nhFog7egUlPlhCpITtAXtqm4Ndhz4jLj8wAq5lvdJMuD+PjR/4L46R4vOcX2ohtPDkaQzyx+zqCfVqRzz0aNUC8cxwHqXn5TkuFMBrmebWnbg2656HtCJuYFclCuATnh6q4BXne8UYs7eTqAYyDsG90CLcrIYgjvhc9KWnyel81wkwY1OHC+ZOoDx6peGU7HEMScBBZipdVmDmdZIZnJT6YDmSsLqwC44fo8a6VAhO1M+pNTN901a0iuEwAA+QU9FaJaftUYlMtSsjU1SrtmteG01OdNBYWi5ljdovmLd3Vvj1hsQGvzrQSgExR4+sSYwDp5KT6WaejDKcaWNcCTLOulBzU7Eem7JbfQRrRbJDxq6OV45dwtYC9vcPfOdNDe+a6W83zrHSsEJ7vZEylwsMTA2XlKTKfBKfhFP9DRTpBtGXpGlZZutEO5DIdsDHs/didHNF3Qr6Kwh1f8XbQlohrBfQSjW71YYONxEdbwUGVkLh6bnjChXwZG5TEy2kEztaUoqwS7TuuEQvlQKmTKmKl7RCYQQpSPSge6ko82y5AacS5JXlUeQdttzrk6ReKA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b5c320-0d7c-4d9f-a525-08d86f452161
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 06:56:38.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGuU9U+y/aR5Po7Mx9eEl0EzCZlRPdS56sn9up8/y4EchmoDa6tbjssmVUJ8ehbyquwNbTUwzlxFPnnrV5ApaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3933
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Yonghong Song,
thank you for reporting the problem.
As far as I understand the problem here is that pos is incremented in .start function.

I do not,like an idea to avoid increment in ipv6_route_seq_next()
however ipv6_route_seq_start can provide fake argument instead. 

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2618,8 +2618,9 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
        iter->skip = *pos;
 
        if (iter->tbl) {
+               loff_t p;
                ipv6_route_seq_setup_walk(iter, net);
-               return ipv6_route_seq_next(seq, NULL, pos);
+               return ipv6_route_seq_next(seq, NULL, &p);
        } else {
                return NULL;
        }

In this case patch subject should be changed accordingly.

Thank you,
	Vasily Averin

On 10/13/20 3:09 AM, Yonghong Song wrote:
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
> 
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().
> 
> For example, I have 7 ipv6 route entries,
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   0+1 records in
>   0+1 records out
>   1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>   root@arch-fb-vm1:~/net-next
> 
> In the above, I specify buffer size 4096, so all records can be returned
> to user space with a single trip to the kernel.
> 
> If I use buffer size 128, since each record size is 149, internally
> kernel seq_read() will read 149 into its internal buffer and return the data
> to user space in two read() syscalls. Then user read() syscall will trigger
> next seq_ops->start(). Since the current implementation increased pos even
> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
> record is #1.
> 
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> 4+1 records in
> 4+1 records out
> 600 bytes copied, 0.00127758 s, 470 kB/s
> 
> To fix the problem, do not increase pos for seq_ops->start() and the
> above `dd` command with `bs=128` will show correct result.
> 
> Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  net/ipv6/ip6_fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 141c0a4c569a..5aac5094bc41 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2582,10 +2582,10 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  	struct net *net = seq_file_net(seq);
>  	struct ipv6_route_iter *iter = seq->private;
>  
> -	++(*pos);
>  	if (!v)
>  		goto iter_table;
>  
> +	++(*pos);
>  	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
>  	if (n)
>  		return n;
> 
