Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D547B3AF1C7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFURVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:21:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhFURVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:21:33 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LH3ScX030912;
        Mon, 21 Jun 2021 13:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=e6h2FpKlxoU7qqe1zdHS8Jd/v5LFC72lgYo0nh9jI4k=;
 b=cnuZSHKzIW5ucrCIEUBeWJg0cTahBl0AgenyAobJait8GyqNXc7rnB7p6CUcGvNOcbHa
 ANeCTSNhUc36I+0jfmNNYsfCMe5uUI/SGbq/8VHXbrGe6P/lA1RTEVwisHJaoe7vYYAW
 BYqdZj8FZ2FtI5S4Mf2TYBHFcpcZfjGcLJDBazyYRh1VCdDtJPqG6HR8lTOR21iVxi0N
 XfAexVW+vKicN/DG7Kla37HI6OrRTlLDHjnljizQtrWNfxUzF5dJ4NuB4oLhDn7WXMJ0
 SFGEj0PCq0RjL4PuKsSpKaIJwqEgzS9VEyFGD+PIokpbDRs43WSGEXVMtIMSRm2UvpIi EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39aw7s3wg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 13:19:03 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LH3Vw6031192;
        Mon, 21 Jun 2021 13:19:02 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39aw7s3wfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 13:19:02 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LHCYmA031062;
        Mon, 21 Jun 2021 17:19:01 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 399879d4n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 17:19:01 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LHJ0LM24772872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 17:19:00 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A48AE2805C;
        Mon, 21 Jun 2021 17:19:00 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA8A52805A;
        Mon, 21 Jun 2021 17:18:57 +0000 (GMT)
Received: from [9.171.11.231] (unknown [9.171.11.231])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Jun 2021 17:18:57 +0000 (GMT)
Subject: Re: [syzbot] general protection fault in smc_tx_sendmsg
To:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, kadlec@netfilter.org, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <000000000000d154d905c53ad34d@google.com>
 <20210621175603.40ac6eaa@gmail.com>
From:   Guvenc Gulce <guvenc@linux.ibm.com>
Message-ID: <c8fd3740-8233-2b14-1fc9-57ecebc31ad8@linux.ibm.com>
Date:   Mon, 21 Jun 2021 19:18:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210621175603.40ac6eaa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WiqrJlTMgMYisZg0cvTXx7TxTv7-tS4s
X-Proofpoint-GUID: BDKy6KJDKJUme5T2sWHrfKvMtF5SI7HV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_10:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 clxscore=1011 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/06/2021 16:56, Pavel Skripkin wrote:
> On Sun, 20 Jun 2021 16:22:16 -0700
> syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com> wrote:
>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    0c337952 Merge tag 'wireless-drivers-next-2021-06-16'
>> of g.. git tree:       net-next
>> console output:
>> https://syzkaller.appspot.com/x/log.txt?x=1621de10300000 kernel
>> config:  https://syzkaller.appspot.com/x/.config?x=a6380da8984033f1
>> dashboard link:
>> https://syzkaller.appspot.com/bug?extid=5dda108b672b54141857 syz
>> repro:
>> https://syzkaller.appspot.com/x/repro.syz?x=121d2d20300000 C
>> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100bd768300000
>>
>> The issue was bisected to:
>>
>> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Wed Apr 21 07:51:08 2021 +0000
>>
>>      netfilter: arp_tables: pass table pointer via nf_hook_ops
>>
> I think, bisection is wrong this time :)
>
> It should be e0e4b8fa533858532f1b9ea9c6a4660d09beb37a ("net/smc: Add SMC
> statistics support")
>
>
> Some debug results:
>
> syzkaller repro just opens the socket and calls sendmsg. Ftrace log:
>
>
>   0)               |  smc_create() {
>   0)               |    smc_sock_alloc() {
>   0) + 88.493 us   |      smc_hash_sk();
>   0) ! 131.487 us  |    }
>   0) ! 189.912 us  |  }
>   0)               |  smc_sendmsg() {
>   0)   2.808 us    |    smc_tx_sendmsg();
>   0) ! 148.484 us  |  }
>
>
> That means, that smc_buf_create() wasn't called at all, so we need to
> check sndbuf_desc before dereferencing
>
> Something like this should work
>
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 075c4f4b4..e24071b12 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -154,7 +154,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>   		goto out_err;
>   	}
>   
> -	if (len > conn->sndbuf_desc->len)
> +	if (conn->sndbuf_desc && len > conn->sndbuf_desc->len)
>   		SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
>   
>   	if (len > conn->peer_rmbe_size)
>
>
> Thoughts?
>
>
> +CC Guvenc Gulce
>
>
> With regards,
> Pavel Skripkin

Thanks for analyzing the cause. Your approach would work but I would prefer that we
check the state of the socket before doing the statistics relevant if check. This will ensure
that smc_buf_create() was already called.
I am testing the fix at the moment which would look like the following:

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 075c4f4b41cf..289025cd545a 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -154,6 +154,9 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
                 goto out_err;
         }

+       if (sk->sk_state == SMC_INIT)
+               return -ENOTCONN;
+
         if (len > conn->sndbuf_desc->len)
                 SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);


