Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C7A6357FC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbiKWJtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbiKWJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:48:51 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C12BD14EA;
        Wed, 23 Nov 2022 01:45:58 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669196756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W7UAyIb+6WzyZxThrcENP/2tVOncA3VWyaK507FBvV4=;
        b=W2BTzxko4l5/tZr/RDsZFc4wmrSc6ocE1r7G/mRW0+AW/JQ8TbSks4VSipXeM3IltEpLSc
        sVn2/24MllnsPvPJo4YSzOqAZijl6Kli5UTma7JGoqgLqlLREYdqoB0KFcCl0c6p2FlWR9
        8mfo5bCtbPAJHYJwl9XkTP/039TGLMQ=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [syzbot] unregister_netdevice: waiting for DEV to become free (7)
To:     wangyufen <wangyufen@huawei.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
        Leon Romanovsky <leon@kernel.org>, chenzhongjin@huawei.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
References: <00000000000060c7e305edbd296a@google.com>
 <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
 <Y3wwOPmH1WoRj0Uo@ziepe.ca> <ecc8b532-4e80-b7bd-3621-78cd55fd48fa@huawei.com>
Message-ID: <2f54056f-0acf-e088-c6cc-9ffce77bbe24@linux.dev>
Date:   Wed, 23 Nov 2022 17:45:53 +0800
MIME-Version: 1.0
In-Reply-To: <ecc8b532-4e80-b7bd-3621-78cd55fd48fa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/22 11:28 AM, wangyufen wrote:
>
> 在 2022/11/22 10:13, Jason Gunthorpe 写道:
>> On Fri, Nov 18, 2022 at 02:28:53PM +0100, Dmitry Vyukov wrote:
>>> On Fri, 18 Nov 2022 at 12:39, syzbot
>>> <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    9c8774e629a1 net: eql: Use kzalloc instead of 
>>>> kmalloc/memset
>>>> git tree:       net-next
>>>> console output: 
>>>> https://syzkaller.appspot.com/x/log.txt?x=17bf6cc8f00000
>>>> kernel config: 
>>>> https://syzkaller.appspot.com/x/.config?x=9eb259db6b1893cf
>>>> dashboard link: 
>>>> https://syzkaller.appspot.com/bug?extid=5e70d01ee8985ae62a3b
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU 
>>>> Binutils for Debian) 2.35.2
>>>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=1136d592f00000
>>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=1193ae64f00000
>>>>
>>>> Bisection is inconclusive: the issue happens on the oldest tested 
>>>> release.
>>>>
>>>> bisection log: 
>>>> https://syzkaller.appspot.com/x/bisect.txt?x=167c33a2f00000
>>>> final oops: 
>>>> https://syzkaller.appspot.com/x/report.txt?x=157c33a2f00000
>>>> console output: 
>>>> https://syzkaller.appspot.com/x/log.txt?x=117c33a2f00000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to 
>>>> the commit:
>>>> Reported-by: syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com
>>>>
>>>> iwpm_register_pid: Unable to send a nlmsg (client = 2)
>>>> infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98
>>>> unregister_netdevice: waiting for vlan0 to become free. Usage count 
>>>> = 2
>>>
>>> +RDMA maintainers
>>>
>>> There are 4 reproducers and all contain:
>>>
>>> r0 = socket$nl_rdma(0x10, 0x3, 0x14)
>>> sendmsg$RDMA_NLDEV_CMD_NEWLINK(...)
>>>
>>> Also the preceding print looks related (a bug in the error handling
>>> path there?):
>>>
>>> infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98
>>
>> I'm pretty sure it is an rxe bug
>>
>> ib_device_set_netdev() will hold the netdev until the caller destroys
>> the ib_device
>>
>> rxe calls it during rxe_register_device() because the user asked for a
>> stacked ib_device on top of the netdev
>>
>> Presumably rxe needs to have a notifier to also self destroy the rxe
>> device if the underlying net device is to be destroyed?
>>
>> Can someone from rxe check into this?
>
> The following patch may fix the issue：
>
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4049,6 +4049,9 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
>         return 0;
>  err:
>         id_priv->backlog = 0;
> +       if (id_priv->cma_dev)
> +               cma_release_dev(id_priv);
> +
>         /*
>          * All the failure paths that lead here will not allow the 
> req_handler's
>          * to have run.
>

But it is the caller's responsibility to destroy it since commit 
dd37d2f59eb8.

> The causes are as follows:
>
> rdma_listen()
>   rdma_bind_addr()
>     cma_acquire_dev_by_src_ip()
>       cma_attach_to_dev()
>         _cma_attach_to_dev()
>           cma_dev_get()

Thanks for the analysis.

And for the two callers of cma_listen_on_dev, looks they have
different behaviors with regard to handling failure.

1. cma_listen_on_all which calls both
             list_del_init(&to_destroy->device_item)
     and
             rdma_destroy_id(&to_destroy->id)

2. cma_add_one invokes cma_process_remove to delete to_destroy,
cma_process_remove call both list_del_init(&id_priv->listen_item)
and list_del_init(&id_priv->device_item), but it doesn't call
rdma_destroy_id(&dev_id_priv->id) which is also different with
_cma_cancel_listens.

I am wondering if this is needed.

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc2222b85c88..48e283d1389b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5231,6 +5231,7 @@ static void cma_process_remove(struct cma_device 
*cma_dev)
                 cma_id_get(id_priv);
                 mutex_unlock(&lock);

+               rdma_destroy_id(&dev_id_priv->id);
                 cma_send_device_removal_put(id_priv);

                 mutex_lock(&lock);

Thanks,
Guoqing
