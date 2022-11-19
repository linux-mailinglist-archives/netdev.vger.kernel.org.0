Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DFB63104D
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 19:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKSShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 13:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKSShL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 13:37:11 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE51140B5;
        Sat, 19 Nov 2022 10:37:03 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id d7so5615264qkk.3;
        Sat, 19 Nov 2022 10:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=erHGU1CnK47F8AJ7fpnd0e87oDzUNmIZBwVyU7/DHk4=;
        b=ZSMIS55kAaZEvbinqdynt4bnEYN7BPjagw+qAUakJAorgTxjJw4JN+q6B+T/Wbl+rT
         /Qw9GJXtoFxCToW38xrvBdkumJm0WFIShm+OJRranE0Ofnz5ttPVXSJCtCXlIZdtqEKW
         ypaaY9SipQZGLwhAMZXHlyTkt6HBky0vyC80FIOi6UnzdpBctWAL0pvAKiJip+MkPMSM
         UI1I9qjYjZrNpActA5ExXwedLowp2u6OGlDr7rjfuoumlOTfNXap28ZOdpho1wnnA1T2
         uiGmY9mo+7GAIoSjHScW7UzCJMBKbXvZDalQ4zKcFUDWQY2b2Nw795DTY30IKta20QP4
         H5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erHGU1CnK47F8AJ7fpnd0e87oDzUNmIZBwVyU7/DHk4=;
        b=xaRCKRLHZ7tNV+XG9zq5vubTzX5JMvOf7L7+TEt7nm77HUTXUssznqDiLntcwRjXn7
         1X6KQN5qA1KUtF0OGhxjLeWlaW22f82zQmkFNOcF7SfkJo1/49CQGrXv+I2dPEtMyDDc
         wo/gtiy606oaBaqmqNhPA1t6+MOM3M0nUA1X2zMRQ69HPCoUllq5Iu14QmbFneczRIq1
         o50gLUtwCd/pp/py/lbSHzZEv54BTQemB4rjcRSXyFu8iusIJ6VhUOA0nrzNsTlQeplO
         3AH/4vImlsLIJTMUUAyrap1ikd3BeCAlWuX/SMr+U2aZ6aBdVDxsLx6t5PL2fv5p3nT1
         D23A==
X-Gm-Message-State: ANoB5pnYwKattz3jkdoMZeWBApB0iaOsKDZDygjuY5ub4OR/g+/GteVN
        1ms/1nXIxV7W6tUgcz8U4Z4=
X-Google-Smtp-Source: AA0mqf54h2kVYFjSfj2RQZr3U3bSm8SOkIVfBI0IRqOqiExwIKse3VEW/MhMTfVPyQ+JCSORVDbHGw==
X-Received: by 2002:a37:c402:0:b0:6ee:e139:596c with SMTP id d2-20020a37c402000000b006eee139596cmr10820379qki.606.1668883022106;
        Sat, 19 Nov 2022 10:37:02 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:82fe:d8bd:30c3:4cf8])
        by smtp.gmail.com with ESMTPSA id bl3-20020a05620a1a8300b006fae7e6204bsm5098124qkb.108.2022.11.19.10.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 10:37:01 -0800 (PST)
Date:   Sat, 19 Nov 2022 10:37:00 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Message-ID: <Y3kiTNKPawbxsgZh@pop-os.localdomain>
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
 <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
 <87bkprprxf.fsf@cloudflare.com>
 <63617b2434725_2eb7208e1@john.notmuch>
 <87a6574yz0.fsf@cloudflare.com>
 <63643449b978a_204d620851@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63643449b978a_204d620851@john.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 02:36:09PM -0700, John Fastabend wrote:
> Jakub Sitnicki wrote:
> > On Tue, Nov 01, 2022 at 01:01 PM -07, John Fastabend wrote:
> > > Jakub Sitnicki wrote:
> > >> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
> > >> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
> > >> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> > >> >> > On 10/17, Cong Wang wrote:
> > >> >> >> From: Cong Wang <cong.wang@bytedance.com>
> > >> >> >
> > >> >> >> Technically we don't need lock the sock in the psock work, but we
> > >> >> >> need to prevent this work running in parallel with sock_map_close().
> > >> >> >
> > >> >> >> With this, we no longer need to wait for the psock->work synchronously,
> > >> >> >> because when we reach here, either this work is still pending, or
> > >> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
> > >> >> >> the first case asynchronously, and we need to bail out the second case
> > >> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
> > >> >> >
> > >> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> > >> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
> > >> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
> > >> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > >> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > >> >> >
> > >> >> > This seems to remove the splat for me:
> > >> >> >
> > >> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
> > >> >> >
> > >> >> > The patch looks good, but I'll leave the review to Jakub/John.
> > >> >> 
> > >> >> I can't poke any holes in it either.
> > >> >> 
> > >> >> However, it is harder for me to follow than the initial idea [1].
> > >> >> So I'm wondering if there was anything wrong with it?
> > >> >
> > >> > It caused a warning in sk_stream_kill_queues() when I actually tested
> > >> > it (after posting).
> > >> 
> > >> We must have seen the same warnings. They seemed unrelated so I went
> > >> digging. We have a fix for these [1]. They were present since 5.18-rc1.
> > >> 
> > >> >> This seems like a step back when comes to simplifying locking in
> > >> >> sk_psock_backlog() that was done in 799aa7f98d53.
> > >> >
> > >> > Kinda, but it is still true that this sock lock is not for sk_socket
> > >> > (merely for closing this race condition).
> > >> 
> > >> I really think the initial idea [2] is much nicer. I can turn it into a
> > >> patch, if you are short on time.
> > >> 
> > >> With [1] and [2] applied, the dead lock and memory accounting warnings
> > >> are gone, when running `test_sockmap`.
> > >> 
> > >> Thanks,
> > >> Jakub
> > >> 
> > >> [1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
> > >> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
> > >
> > > Cong, what do you think? I tend to agree [2] looks nicer to me.
> > >
> > > @Jakub,
> > >
> > > Also I think we could simply drop the proposed cancel_work_sync in
> > > sock_map_close()?
> > >
> > >  }
> > > @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
> > >  	saved_close = psock->saved_close;
> > >  	sock_map_remove_links(sk, psock);
> > >  	rcu_read_unlock();
> > > -	sk_psock_stop(psock, true);
> > > -	sk_psock_put(sk, psock);
> > > +	sk_psock_stop(psock);
> > >  	release_sock(sk);
> > > +	cancel_work_sync(&psock->work);
> > > +	sk_psock_put(sk, psock);
> > >  	saved_close(sk, timeout);
> > >  }
> > >
> > > The sk_psock_put is going to cancel the work before destroying the psock,
> > >
> > >  sk_psock_put()
> > >    sk_psock_drop()
> > >      queue_rcu_work(system_wq, psock->rwork)
> > >
> > > and then in callback we
> > >
> > >   sk_psock_destroy()
> > >     cancel_work_synbc(psock->work)
> > >
> > > although it might be nice to have the work cancelled earlier rather than
> > > latter maybe.
> > 
> > Good point.
> > 
> > I kinda like the property that once close() returns we know there is no
> > deferred work running for the socket.
> > 
> > I find the APIs where a deferred cleanup happens sometimes harder to
> > write tests for.
> > 
> > But I don't really have a strong opinion here.
> 
> I don't either and Cong left it so I'm good with that.

It has been there because of the infamous warnings triggered in
sk_stream_kill_queues(). We have to wait for flying packets, but this
_may_ be changed after we switch to tcp_read_skb() where we call
skb_set_owner_sk_safe().


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

Returning EAGAIN here makes little sense to me, it should be ENOMEM and
is not worth retrying.

For other EAGAIN cases, why not just reschedule this work since state is
already saved in sk_psock_work_state?

Thanks.
