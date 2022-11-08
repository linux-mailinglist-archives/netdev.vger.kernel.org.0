Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C2621C97
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKHS7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKHS7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:59:07 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EB95E3FB
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:59:05 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id a5so23899689edb.11
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=61ZB7BZd7CUPH5RTkWLYWpyStnL3hubIYZcLW3GBhlM=;
        b=TROy8mnM4gUsrLJGbuhdhUDv135mtweeOG4slsBmVvTI2lR9KlD/GFM4Y0H/IBTrq7
         rqxKWV3L6QS9qahLg+R0qljUG8YwTBsls4bbzwkiJquQ0a+HCgkHyiOWrXp+a2C1HO1K
         WvrFHuWryc/7/YxfSQsInRv5+/gaEwVptoyoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61ZB7BZd7CUPH5RTkWLYWpyStnL3hubIYZcLW3GBhlM=;
        b=4OBSxb1PCv/PoZkmSOq5ZX8oadtkHDg5q+VJVh+4hdQwLYQB+3kEmXRiHTsfB1a/tJ
         nIR8heK8d9/BTwwKTX9GmEOhb4sE2KNrnXabO1zQNN8aix0ocADM0TRNioimuIKfJdvS
         ku7qHstvtuWLdlWC7S5nErneb9NM4a6G85GVq0t/aEDv3wjgJ8LWuM8D9tlSX2mV0MqC
         X5K3xXn0pJGQpfjV2uybFFY2mzZPLbInyAjMdal2o0aXv0h3gqETAgTVcbz7Isi6RFzv
         VCq1TsjKiyrFMLhaKLfrvKsK7sg8JXgUrW0/7ujajWMLuaiVoukmN2awPKJfB5zYz0Y+
         nAxw==
X-Gm-Message-State: ACrzQf3MBt7Cs1C+moxB5PpZ2IEvaSATIEpI5Uru7skAvBbAjydGg0bW
        wBjDtKUnlYm9LZsaPX5nlDwuSg==
X-Google-Smtp-Source: AMsMyM69YhJT1KQ0oVMD08z8PNsr3e20NHRiUCZg/aUjANM9D33BtLHoEihjSXB3va0Jo+W0DCh+/A==
X-Received: by 2002:a05:6402:b0e:b0:461:f7a8:3e3a with SMTP id bm14-20020a0564020b0e00b00461f7a83e3amr56756709edb.372.1667933943719;
        Tue, 08 Nov 2022 10:59:03 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id 19-20020a170906309300b0079800b8173asm4976875ejv.158.2022.11.08.10.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:59:03 -0800 (PST)
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com> <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain> <87bkprprxf.fsf@cloudflare.com>
 <63617b2434725_2eb7208e1@john.notmuch> <87a6574yz0.fsf@cloudflare.com>
 <63643449b978a_204d620851@john.notmuch>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Date:   Tue, 08 Nov 2022 19:49:23 +0100
In-reply-to: <63643449b978a_204d620851@john.notmuch>
Message-ID: <87fsetqnm2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 02:36 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Tue, Nov 01, 2022 at 01:01 PM -07, John Fastabend wrote:
>> > Jakub Sitnicki wrote:
>> >> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
>> >> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
>> >> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
>> >> >> > On 10/17, Cong Wang wrote:
>> >> >> >> From: Cong Wang <cong.wang@bytedance.com>
>> >> >> >
>> >> >> >> Technically we don't need lock the sock in the psock work, but we
>> >> >> >> need to prevent this work running in parallel with sock_map_close().
>> >> >> >
>> >> >> >> With this, we no longer need to wait for the psock->work synchronously,
>> >> >> >> because when we reach here, either this work is still pending, or
>> >> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
>> >> >> >> the first case asynchronously, and we need to bail out the second case
>> >> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
>> >> >> >
>> >> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
>> >> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
>> >> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
>> >> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
>> >> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> >> >> >
>> >> >> > This seems to remove the splat for me:
>> >> >> >
>> >> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
>> >> >> >
>> >> >> > The patch looks good, but I'll leave the review to Jakub/John.
>> >> >> 
>> >> >> I can't poke any holes in it either.
>> >> >> 
>> >> >> However, it is harder for me to follow than the initial idea [1].
>> >> >> So I'm wondering if there was anything wrong with it?
>> >> >
>> >> > It caused a warning in sk_stream_kill_queues() when I actually tested
>> >> > it (after posting).
>> >> 
>> >> We must have seen the same warnings. They seemed unrelated so I went
>> >> digging. We have a fix for these [1]. They were present since 5.18-rc1.
>> >> 
>> >> >> This seems like a step back when comes to simplifying locking in
>> >> >> sk_psock_backlog() that was done in 799aa7f98d53.
>> >> >
>> >> > Kinda, but it is still true that this sock lock is not for sk_socket
>> >> > (merely for closing this race condition).
>> >> 
>> >> I really think the initial idea [2] is much nicer. I can turn it into a
>> >> patch, if you are short on time.
>> >> 
>> >> With [1] and [2] applied, the dead lock and memory accounting warnings
>> >> are gone, when running `test_sockmap`.
>> >> 
>> >> Thanks,
>> >> Jakub
>> >> 
>> >> [1]
>> >> https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
>> >> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
>> >
>> > Cong, what do you think? I tend to agree [2] looks nicer to me.
>> >
>> > @Jakub,
>> >
>> > Also I think we could simply drop the proposed cancel_work_sync in
>> > sock_map_close()?
>> >
>> >  }
>> > @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
>> >  	saved_close = psock->saved_close;
>> >  	sock_map_remove_links(sk, psock);
>> >  	rcu_read_unlock();
>> > -	sk_psock_stop(psock, true);
>> > -	sk_psock_put(sk, psock);
>> > +	sk_psock_stop(psock);
>> >  	release_sock(sk);
>> > +	cancel_work_sync(&psock->work);
>> > +	sk_psock_put(sk, psock);
>> >  	saved_close(sk, timeout);
>> >  }
>> >
>> > The sk_psock_put is going to cancel the work before destroying the psock,
>> >
>> >  sk_psock_put()
>> >    sk_psock_drop()
>> >      queue_rcu_work(system_wq, psock->rwork)
>> >
>> > and then in callback we
>> >
>> >   sk_psock_destroy()
>> >     cancel_work_synbc(psock->work)
>> >
>> > although it might be nice to have the work cancelled earlier rather than
>> > latter maybe.
>> 
>> Good point.
>> 
>> I kinda like the property that once close() returns we know there is no
>> deferred work running for the socket.
>> 
>> I find the APIs where a deferred cleanup happens sometimes harder to
>> write tests for.
>> 
>> But I don't really have a strong opinion here.
>
> I don't either and Cong left it so I'm good with that.
>
> Reviewing backlog logic though I think there is another bug there, but
> I haven't been able to trigger it in any of our tests.
>
> The sk_psock_backlog() logic is,
>
>  sk_psock_backlog(struct work_struct *work)
>    mutex_lock()
>    while (skb = ...)
>    ...
>    do {
>      ret = sk_psock_handle_skb()
>      if (ret <= 0) {
>        if (ret == -EAGAIN) {
>            sk_psock_skb_state()
>            goto  end;
>        } 
>       ...
>    } while (len);
>    ...
>   end:
>    mutex_unlock()
>
> what I'm not seeing is if we get an EAGAIN through sk_psock_handle_skb
> how do we schedule the backlog again. For egress we would set the
> SOCK_NOSPACE bit and then get a write space available callback which
> would do the schedule(). The ingress side could fail with EAGAIN
> through the alloc_sk_msg(GFP_ATOMIC) call. This is just a kzalloc,
>
>    sk_psock_handle_skb()
>     sk_psock_skb_ingress()
>      sk_psock_skb_ingress_self()
>        msg = alloc_sk_msg()
>                kzalloc()          <- this can return NULL
>        if (!msg)
>           return -EAGAIN          <- could we stall now
>
>
> I think we could stall here if there was nothing else to kick it. I
> was thinking about this maybe,
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 1efdc47a999b..b96e95625027 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -624,13 +624,20 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  static void sk_psock_skb_state(struct sk_psock *psock,
>                                struct sk_psock_work_state *state,
>                                struct sk_buff *skb,
> -                              int len, int off)
> +                              int len, int off, bool ingress)
>  {
>         spin_lock_bh(&psock->ingress_lock);
>         if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
>                 state->skb = skb;
>                 state->len = len;
>                 state->off = off;
> +               /* For ingress we may not have a wakeup callback to trigger
> +                * the reschedule on so need to reschedule retry. For egress
> +                * we will get TCP stack callback when its a good time to
> +                * retry.
> +                */
> +               if (ingress)
> +                       schedule_work(&psock->work);
>         } else {
>                 sock_drop(psock->sk, skb);
>         }
> @@ -678,7 +685,7 @@ static void sk_psock_backlog(struct work_struct *work)
>                         if (ret <= 0) {
>                                 if (ret == -EAGAIN) {
>                                         sk_psock_skb_state(psock, state, skb,
> -                                                          len, off);
> +                                                          len, off, ingress);
>                                         goto end;
>                                 }
>                                 /* Hard errors break pipe and stop xmit. */
>
>
> Its tempting to try and use the memory pressure callbacks but those are
> built for the skb cache so I think overloading them is not so nice. The
> drawback to above is its possible no memory is available even when we
> get back to the backlog. We could use a delayed reschedule but its not
> clear what delay makes sense here. Maybe some backoff...
>
> Any thoughts?

I don't have any thoughts on the fix yet, but I have a repro.

We can use fault injection [1]. For some reason it's been disabled on
x86-64 since 2007 (stack walking didn't work back then?), so we need to
patch the kernel slightly.

Also, to better target the failure, just for this case, I've de-inlined
alloc_sk_msg(). But in general testing we can just inject any alloc
under sk_psock_backlog().

Incantation looks like so:

#!/usr/bin/env bash

readonly TARGET_FUNC=alloc_sk_msg
readonly ADDR=($(grep -A1 ${TARGET_FUNC} /proc/kallsyms | awk '{print "0x" $1}'))

exec bash \
     ../../fault-injection/failcmd.sh \
     --require-start=${ADDR[0]} --require-end=${ADDR[1]} \
     --stacktrace-depth=32 \
     --probability=50 --times=100 \
     --ignore-gfp-wait=N --task-filter=N \
     -- \
     ./test_sockmap

We won't get a message in dmesg (even with --verbosity=1 set) because
we're allocating with __GFP_NOWARN, and fault injection interface
doesn't provide a way to override that. But we can obseve the 'times'
count go down after ./test_sockmap blocks (also confirmed with a printk
added on -EAGAIN error path).

This is what I observe:

bash-5.1# ./repro.sh
# 1/ 6  sockmap::txmsg test passthrough:OK
# 2/ 6  sockmap::txmsg test redirect:OK
# 3/ 1  sockmap::txmsg test redirect wait send mem:OK
# 4/ 6  sockmap::txmsg test drop:OK
# 5/ 6  sockmap::txmsg test ingress redirect:OK <-- blocked here
^Z
[1]+  Stopped                 ./repro.sh
bash-5.1# cat /sys/kernel/debug/failslab/times
99
bash-5.1#

Kernel tweaks attached below.

-jkbs

[1] https://www.kernel.org/doc/html/latest/fault-injection/fault-injection.html

---8<---

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3fc7abffc7aa..32c5329b0dd9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1963,7 +1963,6 @@ config FAIL_SUNRPC
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
-	depends on !X86_64
 	select STACKTRACE
 	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e6b9ced3eda8..0f7dc67a3708 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -500,7 +500,7 @@ bool sk_msg_is_readable(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_msg_is_readable);
 
-static struct sk_msg *alloc_sk_msg(gfp_t gfp)
+static noinline struct sk_msg *alloc_sk_msg(gfp_t gfp)
 {
 	struct sk_msg *msg;
 
diff --git a/tools/testing/fault-injection/failcmd.sh b/tools/testing/fault-injection/failcmd.sh
index 78dac34264be..887dd4553cae 100644
--- a/tools/testing/fault-injection/failcmd.sh
+++ b/tools/testing/fault-injection/failcmd.sh
@@ -212,7 +212,7 @@ done
 echo $oom_kill_allocating_task > /proc/sys/vm/oom_kill_allocating_task
 echo $task_filter > $FAULTATTR/task-filter
 echo $probability > $FAULTATTR/probability
-echo $times > $FAULTATTR/times
+printf "%#x" $times > $FAULTATTR/times
 
 trap "restore_values" SIGINT SIGTERM EXIT
 
