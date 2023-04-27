Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74E6EFF61
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbjD0Cbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242905AbjD0Cba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:31:30 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D79730FB
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:31:14 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a606135408so7537640a34.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682562673; x=1685154673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WySIrgzWHhxuffFB2/mn8dPJ614lvN5q2OG+38Q9m2A=;
        b=K5bukTPGQB9EU8Iq/DxiCaOciWeaCVIAHIeVkHuEqdkrW7xvudb9Ko4wUaUBCi35Qs
         dokxW133JopnSY1NHYQvVWPn4lSPdDpTO+P7F7NQDiRe90/KWkvMGzZeudjj8UywImMk
         j+B3UcZwaDxvOgTUO6RCDr4rIVPIFIP9vkt2I98nobpLjDvEQzrG8PqGz/W0ly4Xg+Hi
         nd+5dBOiP1eNMUhcS+HTECsWkwrhSrrbsZgHx7kBK8eayW+eiDpP/MjJNUbD1AH4MH/n
         +Z9/1oVvM66e7ROZDdjWySOjKWNsJvyma3opM67OzlXYzX+E+dgTU6vvRDLEt1XjZW9r
         23Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682562673; x=1685154673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WySIrgzWHhxuffFB2/mn8dPJ614lvN5q2OG+38Q9m2A=;
        b=GidhF1gkis+OcFaRQdEZGW/dC/beIpgPjfuTVGO6aD6xnBa0aPDCxLgKDnyWFHBxub
         29ci5HW/VBiyEktPUh/XRWuS+4Eqn7FLJJnV6XD5XXfl5chGVX56KO9jGF2rA1fWReR6
         HU+2ppQAjj1TzIqXT8Y1sYpJ6K12PVdizd4EQu/wWXDHlGKdSHF0ynLtyhOoILzC95Jt
         7oYLLEeReglZCvGm1SAa081mFw8G8mYed1LTbpXWBO+gBx4sbNCDUM83SVKJJNxIOqS8
         PcqZ+3qhTYXJj0cQiTI4hXTaYoYOnBK0gBa833Fl7opOAvxYt8f20WazaiOtn1zNmahp
         R9OQ==
X-Gm-Message-State: AAQBX9f/YkzoTY76ZR1tzz8tlnTjw7dzkkK4WLK8ZzfvvbgyxYCnMfl0
        EogKgpTYmCbkhRg3CdJIbyZjZQ==
X-Google-Smtp-Source: AKy350afl2RKnRM28Wvt2Arjfduxr5EQHGE/8szkIoNxdDSxnMpHqhecimyXMhNU92m6wY65PxDZyg==
X-Received: by 2002:a9d:6b14:0:b0:69f:1c85:bb90 with SMTP id g20-20020a9d6b14000000b0069f1c85bb90mr12755606otp.26.1682562673429;
        Wed, 26 Apr 2023 19:31:13 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a? ([2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a])
        by smtp.gmail.com with ESMTPSA id g4-20020a9d6484000000b006a144b97e73sm7427965otl.74.2023.04.26.19.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 19:31:13 -0700 (PDT)
Message-ID: <52543fdc-6f27-138b-ef66-a99fb51c655c@mojatatu.com>
Date:   Wed, 26 Apr 2023 23:31:07 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Content-Language: en-US
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com,
        vladbu@nvidia.com, hdanton@sina.com
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org> <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
 <20230417230011.GA41709@bytedance> <20230426233657.GA11249@bytedance>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230426233657.GA11249@bytedance>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2023 20:42, Peilin Ye wrote:
> +Cc: Vlad Buslov, Hillf Danton
> 
> Hi all,
> 
> On Mon, Apr 17, 2023 at 04:00:11PM -0700, Peilin Ye wrote:
>> I also reproduced this UAF using the syzkaller reproducer in the report
>> (the C reproducer did not work for me for unknown reasons).  I will look
>> into this.
> 
> Currently, multiple ingress (clsact) Qdiscs can access the per-netdev
> *miniq_ingress (*miniq_egress) pointer concurrently.  This is
> unfortunately true in two senses:
> 
> 1. We allow adding ingress (clsact) Qdiscs under parents other than
> TC_H_INGRESS (TC_H_CLSACT):
> 
>    $ ip link add ifb0 numtxqueues 8 type ifb
>    $ echo clsact > /proc/sys/net/core/default_qdisc
>    $ tc qdisc add dev ifb0 handle 1: root mq
>    $ tc qdisc show dev ifb0
>    qdisc mq 1: root
>    qdisc clsact 0: parent 1:8
>    qdisc clsact 0: parent 1:7
>    qdisc clsact 0: parent 1:6
>    qdisc clsact 0: parent 1:5
>    qdisc clsact 0: parent 1:4
>    qdisc clsact 0: parent 1:3
>    qdisc clsact 0: parent 1:2
>    qdisc clsact 0: parent 1:1
> 
> This is obviously racy and should be prohibited.  I've started working
> on patches to fix this.  The syz repro for this UAF adds ingress Qdiscs
> under TC_H_ROOT, by the way.
> 
> 2. After introducing RTNL-lockless RTM_{NEW,DEL,GET}TFILTER requests
> [1], it is possible that, when replacing ingress (clsact) Qdiscs, the
> old one can access *miniq_{in,e}gress concurrently with the new one.  For
> example, the syz repro does something like the following:
> 
>    Thread 1 creates sch_ingress Qdisc A (containing mini Qdisc a1 and a2),
>    then adds a cls_flower filter X to Qdisc A.
> 
>    Thread 2 creates sch_ingress Qdisc B (containing mini Qdisc b1 and b2)
>    to replace Qdisc A, then adds a cls_flower filter Y to Qdisc B.
> 
>    Device has 8 TXQs.
> 
>   Thread 1               A's refcnt   Thread 2
>    RTM_NEWQDISC (A, locked)
>     qdisc_create(A)               1
>     qdisc_graft(A)                9
> 
>    RTM_NEWTFILTER (X, lockless)
>     __tcf_qdisc_find(A)          10
>     tcf_chain0_head_change(A)
>   ! mini_qdisc_pair_swap(A)
>              |                        RTM_NEWQDISC (B, locked)
>              |                    2    qdisc_graft(B)
>              |                    1    notify_and_destroy(A)
>              |
>              |                        RTM_NEWTFILTER (Y, lockless)
>              |                         tcf_chain0_head_change(B)
>              |                       ! mini_qdisc_pair_swap(B)
>     tcf_block_release(A)          0             |
>     qdisc_destroy(A)                            |
>     tcf_chain0_head_change_cb_del(A)            |
>   ! mini_qdisc_pair_swap(A)                     |
>              |                                  |
>             ...                                ...
> 
> As we can see there're interleaving mini_qdisc_pair_swap() calls between
> Qdisc A and B, causing all kinds of troubles, including the UAF (thread
> 2 writing to mini Qdisc a1's rcu_state after Qdisc A has already been
> freed) reported by syzbot.

Thanks for the analysis. It makes total sense.
After going through the call chains, please correct me if my ELI5 is wrong:

'clsact_init()' is called for B when dev has miniq_ingress set to 'A', 
therefore copying a pointer to the miniq_qdisc with lifetime bound to 
'A' in a miniq_qdisc_pair with lifetime bound to 'B' therefore raising 
an UAF after A is destroyed and B is manipulated.

> 
> To fix this, I'm cooking a patch that, when replacing ingress (clsact)
> Qdiscs, in qdisc_graft():
> 
>    I.  We should make sure there's no on-the-fly lockless filter requests
>        for the old Qdisc, and return -EBUSY if there's any (or can/should
>        we wait in RTM_NEWQDISC handler?
Makes sense.

> 
>    II. We should destory the old Qdisc before publishing the new one
>        (i.e. setting it to dev_ingress_queue(dev)->qdisc_sleeping, so
>        that subsequent filter requests can see it), because
>        {ingress,clsact}_destroy() also call mini_qdisc_pair_swap(), which
>        sets *miniq_{in,e}gress to NULL >
> Future Qdiscs that support RTNL-lockless cls_ops, if any, won't need
> this fix, as long as their ->chain_head_change() don't access
> out-of-Qdisc-scope data, like pointers in struct net_device.

Probably worth a comment somewhere in the code

> 
> Do you think this is the right way to go?  Thanks!
> 
> [1] Thanks Hillf Danton for the hint:
>      https://syzkaller.appspot.com/text?tag=Patch&x=10d7cd5bc80000
> 
> Thanks,
> Peilin Ye
> 

