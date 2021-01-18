Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E62FA31F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392986AbhAROco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:32:44 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44191 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404967AbhAROcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:32:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1C745580592;
        Mon, 18 Jan 2021 09:31:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 09:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; h=
        references:from:to:cc:subject:in-reply-to:date:message-id
        :mime-version:content-type; s=fm1; bh=XWHQ+oMKkwzmcYNTFcHiwG//X9
        y+6nazEe2+q7+ittE=; b=sWYvgGCjGIF7TUS8BomF4IPYkE46gXhLi02QdqKwM/
        iJPy/9rok1HaEqJOF9t07x8MUhkN3IkOGRc8lo89mdyYbjb3oVuOTGjVuKoYrL2T
        vyX1jDPAnzndriGPsy/pK1NjFAOZ6o1YH3JYj7wTsX1SP0vATnfuLGpRWkxOKiOz
        u3LcN0zjIvlhHkNlC4OdoQxuPQpZJ7S+I3jcw2xVJ5R1AuO5HI3OFdCekN+rqBqv
        kK0/YrPFqfUbM1Ch1WFn0hfJQjJExYpIpHFpXGhp4pYLztdLlvoKkXv3EJD8tm70
        1x1XRXlh1cjNHHyAywMnZL2gN/p7Ytbc8JGWhitBrloQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XWHQ+o
        MKkwzmcYNTFcHiwG//X9y+6nazEe2+q7+ittE=; b=fGoiag+FB4dm1X9/dc0raW
        zrqbAf5Kb9iXF9Dzuz9eM2NUtUII2gFEK7nFa/Rpmb2lNsG/ENxpDlFfjLhc1fFW
        weIW7y2Y/1UDHuhNfYmGce6pQyBBj6+OtrTcAHsCwZ1aO9L+TGbtls9ob5i0Csf6
        nB7p/NHFsIBV3dFvpdBRr+3T7NS5o9v3fk4a/bvhw8sXe3NO3KsYNnVKtKb230xb
        k1NXQrUV/Nvjmq5AUfJkp1tJdp3zhFhxW2NPt/ElV4fzddepE0excTSWJbL+5Uny
        qe+hhF7msPrb3gXwWdlzsv+pAxHxzH1HJyRNinegQtt1d6q5zZfEeSUN6fNe1qTw
        ==
X-ME-Sender: <xms:tZsFYA9NMcwbQPC_6waGbviE0eOKu0j8hKEj1zJP7tgaqdu1i_inYg>
    <xme:tZsFYCX8oSM4Hwb9daASBk2lSTitMibK7oTLKPgmep0dqffr766i6tApC2vpc1gUr
    xZxImZDuhO3hDBe8YQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpehffgfhvffujgffkfggtgesthdtredttdertdenucfhrhhomhepgghlrgguuceu
    uhhslhhovhcuoehvlhgrugessghushhlohhvrdguvghvqeenucggtffrrghtthgvrhhnpe
    fhiedvfffgfeefteethfffleeukeekieefkeeigfehgfevudfggeffveeifeduhfenucfk
    phepiedvrddvtdehrddufeehrdduhedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepvhhlrggusegsuhhslhhovhdruggvvh
X-ME-Proxy: <xmx:tZsFYGCRb-5kIjMOtvmV1co4BI01eRwRlsXJdeWF3RDFSqnM4QlRGA>
    <xmx:tZsFYDwuGztWBQhP2t4cjk7b3RufElwWawQlt3OBCzY-Sr0xkA_l1A>
    <xmx:tZsFYDAbNyaM5USOciwNSHzpladj6seayJ62natI4FVuToIslZwpxg>
    <xmx:t5sFYEdL3tfLJubHSnLlN-gLN-bqKtVkt2kR7aCq4gnmozWRRLoUlFe_CKM>
Received: from vlad-x1g6 (u5543.alfa-inet.net [62.205.135.152])
        by mail.messagingengine.com (Postfix) with ESMTPA id E71331080067;
        Mon, 18 Jan 2021 09:31:15 -0500 (EST)
References: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
 <acba35f6-2e29-903f-6eb8-a50dde25a147@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com,
        syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com,
        syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Briana Oursler <briana.oursler@gmail.com>
Subject: Re: [Patch net-next] net_sched: fix RTNL deadlock again caused by
 request_module()
In-reply-to: <acba35f6-2e29-903f-6eb8-a50dde25a147@mojatatu.com>
Date:   Mon, 18 Jan 2021 16:31:14 +0200
Message-ID: <87im7u9v0t.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 17 Jan 2021 at 17:15, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2021-01-16 7:56 p.m., Cong Wang wrote:
>> From: Cong Wang <cong.wang@bytedance.com>
>> tcf_action_init_1() loads tc action modules automatically with
>> request_module() after parsing the tc action names, and it drops RTNL
>> lock and re-holds it before and after request_module(). This causes a
>> lot of troubles, as discovered by syzbot, because we can be in the
>> middle of batch initializations when we create an array of tc actions.
>> One of the problem is deadlock:
>> CPU 0					CPU 1
>> rtnl_lock();
>> for (...) {
>>    tcf_action_init_1();
>>      -> rtnl_unlock();
>>      -> request_module();
>> 				rtnl_lock();
>> 				for (...) {
>> 				  tcf_action_init_1();
>> 				    -> tcf_idr_check_alloc();
>> 				   // Insert one action into idr,
>> 				   // but it is not committed until
>> 				   // tcf_idr_insert_many(), then drop
>> 				   // the RTNL lock in the _next_
>> 				   // iteration
>> 				   -> rtnl_unlock();
>>      -> rtnl_lock();
>>      -> a_o->init();
>>        -> tcf_idr_check_alloc();
>>        // Now waiting for the same index
>>        // to be committed
>> 				    -> request_module();
>> 				    -> rtnl_lock()
>> 				    // Now waiting for RTNL lock
>> 				}
>> 				rtnl_unlock();
>> }
>> rtnl_unlock();
>> This is not easy to solve, we can move the request_module() before
>> this loop and pre-load all the modules we need for this netlink
>> message and then do the rest initializations. So the loop breaks down
>> to two now:
>>          for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
>>                  struct tc_action_ops *a_o;
>>                  a_o = tc_action_load_ops(name, tb[i]...);
>>                  ops[i - 1] = a_o;
>>          }
>>          for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
>>                  act = tcf_action_init_1(ops[i - 1]...);
>>          }
>> Although this looks serious, it only has been reported by syzbot, so it
>> seems hard to trigger this by humans. And given the size of this patch,
>> I'd suggest to make it to net-next and not to backport to stable.
>> This patch has been tested by syzbot and tested with tdc.py by me.
>> 
>
> LGTM.
> Initially i was worried about performance impact but i found nothing
> observable. We need to add a tdc test for batch (I can share how i did
> batch testing at next meet).
>
> Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> cheers,
> jamal

Hi,

Thanks for adding me to the thread!
I ran our performance tests with the patch applied and didn't observe
any regression.

Regards,
Vlad

