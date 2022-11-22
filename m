Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043B26333EA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKVD2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKVD2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:28:32 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E0725E87;
        Mon, 21 Nov 2022 19:28:30 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NGV8032Ryz15Mlk;
        Tue, 22 Nov 2022 11:28:00 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 11:28:28 +0800
Message-ID: <ecc8b532-4e80-b7bd-3621-78cd55fd48fa@huawei.com>
Date:   Tue, 22 Nov 2022 11:28:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [syzbot] unregister_netdevice: waiting for DEV to become free (7)
To:     Jason Gunthorpe <jgg@ziepe.ca>, Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
        Leon Romanovsky <leon@kernel.org>, <chenzhongjin@huawei.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
References: <00000000000060c7e305edbd296a@google.com>
 <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
 <Y3wwOPmH1WoRj0Uo@ziepe.ca>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <Y3wwOPmH1WoRj0Uo@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/22 10:13, Jason Gunthorpe 写道:
> On Fri, Nov 18, 2022 at 02:28:53PM +0100, Dmitry Vyukov wrote:
>> On Fri, 18 Nov 2022 at 12:39, syzbot
>> <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com> wrote:
>>>
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    9c8774e629a1 net: eql: Use kzalloc instead of kmalloc/memset
>>> git tree:       net-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17bf6cc8f00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9eb259db6b1893cf
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=5e70d01ee8985ae62a3b
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1136d592f00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1193ae64f00000
>>>
>>> Bisection is inconclusive: the issue happens on the oldest tested release.
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=167c33a2f00000
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=157c33a2f00000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=117c33a2f00000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com
>>>
>>> iwpm_register_pid: Unable to send a nlmsg (client = 2)
>>> infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98
>>> unregister_netdevice: waiting for vlan0 to become free. Usage count = 2
>>
>> +RDMA maintainers
>>
>> There are 4 reproducers and all contain:
>>
>> r0 = socket$nl_rdma(0x10, 0x3, 0x14)
>> sendmsg$RDMA_NLDEV_CMD_NEWLINK(...)
>>
>> Also the preceding print looks related (a bug in the error handling
>> path there?):
>>
>> infiniband syj1: RDMA CMA: cma_listen_on_dev, error -98
> 
> I'm pretty sure it is an rxe bug
> 
> ib_device_set_netdev() will hold the netdev until the caller destroys
> the ib_device
> 
> rxe calls it during rxe_register_device() because the user asked for a
> stacked ib_device on top of the netdev
> 
> Presumably rxe needs to have a notifier to also self destroy the rxe
> device if the underlying net device is to be destroyed?
> 
> Can someone from rxe check into this?

The following patch may fix the issue：

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4049,6 +4049,9 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
         return 0;
  err:
         id_priv->backlog = 0;
+       if (id_priv->cma_dev)
+               cma_release_dev(id_priv);
+
         /*
          * All the failure paths that lead here will not allow the 
req_handler's
          * to have run.



The causes are as follows:

rdma_listen()
   rdma_bind_addr()
     cma_acquire_dev_by_src_ip()
       cma_attach_to_dev()
         _cma_attach_to_dev()
	      cma_dev_get()
		
   cma_check_port()
   <--The return value is not zero， goto err

err：
<-- The error handling here is missing the operation of cma_release_dev.

> 
> Jason
