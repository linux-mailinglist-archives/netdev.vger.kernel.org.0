Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AD06319A8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 07:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKUGNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 01:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUGNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 01:13:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAB51C433;
        Sun, 20 Nov 2022 22:13:04 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so9947775pjb.0;
        Sun, 20 Nov 2022 22:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OV11tEKdURQZUrs7ehAT/2ws7vz9Y0OivCqwY68xbRE=;
        b=qhbEJ2DGJ1oUiS+Fbt/Z5n914OLq6RXGEGonk5/upwdEHw1P9YuCWBoE5nPog+kIJL
         0W0C/zeTGQ+dWRylfIq/A0ALRbS1MnJRccGm2gUfszWLhLEGEDo4jN/u7kHt8gsj0hH9
         n99h2V3xU/VpUUOgCg4nuFfFIi7CEUc4kPBSgwqjhq4RS3+f4xxLE9Gvnh+wMu3zDnpk
         oECsGHPbY1RemHKbFhwnCNtYku/zAWpCDyQMLP6AhwfyJsaXQGLqrlNP3GlbfeBV1P68
         f7RAix/xWle13EcgcI/Fwmj7wyqJahMhlRaaSbnd78G4YVmS1Ehnegyy15BL1L9Riapa
         CfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OV11tEKdURQZUrs7ehAT/2ws7vz9Y0OivCqwY68xbRE=;
        b=mZFbqhkJBK0l4kn28klPYrQBHDcKUZ4gADZ10SDkUHMNR+FjFPNEZWQkUK5+wkv/yA
         47V0lutaLEhsJPXzM1w0Cq1mG0fmflQgq9M5bYcsZJOQWMYwF7b3QX9iymm1t2d8Lt6p
         AL2TfnwFQ4nngX1lQNXeqxRIpHPVT2fb2GCDyT3rCJJgjZAK8tWPxsAslLnTjRIid0dB
         df1kF5uDcKSEH6goNXwo9sBQ3PuiwiJoG7QCNUnZh1mfXN6ucNBV76qBakvuYfaGjDwI
         X9RVkvS5C0gAbeREejuPKVC/SJIl/czKB0SuT05MqG+H4kgyNklV/MNKrFNGOnekyrSw
         FAug==
X-Gm-Message-State: ANoB5plFMqNF3CFm2SUwf58EH3CftSe01lAhKhm/03j70SNNE/JyL9qV
        NzDGqCeXp+vwACtCB96tM30=
X-Google-Smtp-Source: AA0mqf6YMjBxSaXjIgZFMcvij8jGZXwccZj6lTQ2sPKp2QWY9g0ohmZJKfiR2FAfO41VlhA9MCAUng==
X-Received: by 2002:a17:902:a3c9:b0:179:f580:bca5 with SMTP id q9-20020a170902a3c900b00179f580bca5mr1754992plb.139.1669011183687;
        Sun, 20 Nov 2022 22:13:03 -0800 (PST)
Received: from localhost ([2605:59c8:6f:2810:8ccd:b278:6268:540])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902f60100b00186ac4b21cfsm8678132plg.230.2022.11.20.22.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 22:13:02 -0800 (PST)
Date:   Sun, 20 Nov 2022 22:13:01 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <637b16ed8c32d_b7b220877@john.notmuch>
In-Reply-To: <Y3kiTNKPawbxsgZh@pop-os.localdomain>
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
 <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
 <87bkprprxf.fsf@cloudflare.com>
 <63617b2434725_2eb7208e1@john.notmuch>
 <87a6574yz0.fsf@cloudflare.com>
 <63643449b978a_204d620851@john.notmuch>
 <Y3kiTNKPawbxsgZh@pop-os.localdomain>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Nov 03, 2022 at 02:36:09PM -0700, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> > > On Tue, Nov 01, 2022 at 01:01 PM -07, John Fastabend wrote:
> > > > Jakub Sitnicki wrote:
> > > >> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
> > > >> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
> > > >> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> > > >> >> > On 10/17, Cong Wang wrote:
> > > >> >> >> From: Cong Wang <cong.wang@bytedance.com>
> > > >> >> >
> > > >> >> >> Technically we don't need lock the sock in the psock work, but we
> > > >> >> >> need to prevent this work running in parallel with sock_map_close().
> > > >> >> >
> > > >> >> >> With this, we no longer need to wait for the psock->work synchronously,
> > > >> >> >> because when we reach here, either this work is still pending, or
> > > >> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
> > > >> >> >> the first case asynchronously, and we need to bail out the second case
> > > >> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
> > > >> >> >
> > > >> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> > > >> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
> > > >> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
> > > >> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > >> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > >> >> >
> > > >> >> > This seems to remove the splat for me:
> > > >> >> >
> > > >> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
> > > >> >> >
> > > >> >> > The patch looks good, but I'll leave the review to Jakub/John.
> > > >> >> 
> > > >> >> I can't poke any holes in it either.
> > > >> >> 
> > > >> >> However, it is harder for me to follow than the initial idea [1].
> > > >> >> So I'm wondering if there was anything wrong with it?
> > > >> >
> > > >> > It caused a warning in sk_stream_kill_queues() when I actually tested
> > > >> > it (after posting).
> > > >> 
> > > >> We must have seen the same warnings. They seemed unrelated so I went
> > > >> digging. We have a fix for these [1]. They were present since 5.18-rc1.
> > > >> 
> > > >> >> This seems like a step back when comes to simplifying locking in
> > > >> >> sk_psock_backlog() that was done in 799aa7f98d53.
> > > >> >
> > > >> > Kinda, but it is still true that this sock lock is not for sk_socket
> > > >> > (merely for closing this race condition).
> > > >> 
> > > >> I really think the initial idea [2] is much nicer. I can turn it into a
> > > >> patch, if you are short on time.
> > > >> 
> > > >> With [1] and [2] applied, the dead lock and memory accounting warnings
> > > >> are gone, when running `test_sockmap`.
> > > >> 
> > > >> Thanks,
> > > >> Jakub
> > > >> 
> > > >> [1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
> > > >> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
> > > >
> > > > Cong, what do you think? I tend to agree [2] looks nicer to me.
> > > >
> > > > @Jakub,
> > > >
> > > > Also I think we could simply drop the proposed cancel_work_sync in
> > > > sock_map_close()?
> > > >
> > > >  }
> > > > @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
> > > >  	saved_close = psock->saved_close;
> > > >  	sock_map_remove_links(sk, psock);
> > > >  	rcu_read_unlock();
> > > > -	sk_psock_stop(psock, true);
> > > > -	sk_psock_put(sk, psock);
> > > > +	sk_psock_stop(psock);
> > > >  	release_sock(sk);
> > > > +	cancel_work_sync(&psock->work);
> > > > +	sk_psock_put(sk, psock);
> > > >  	saved_close(sk, timeout);
> > > >  }
> > > >
> > > > The sk_psock_put is going to cancel the work before destroying the psock,
> > > >
> > > >  sk_psock_put()
> > > >    sk_psock_drop()
> > > >      queue_rcu_work(system_wq, psock->rwork)
> > > >
> > > > and then in callback we
> > > >
> > > >   sk_psock_destroy()
> > > >     cancel_work_synbc(psock->work)
> > > >
> > > > although it might be nice to have the work cancelled earlier rather than
> > > > latter maybe.
> > > 
> > > Good point.
> > > 
> > > I kinda like the property that once close() returns we know there is no
> > > deferred work running for the socket.
> > > 
> > > I find the APIs where a deferred cleanup happens sometimes harder to
> > > write tests for.
> > > 
> > > But I don't really have a strong opinion here.
> > 
> > I don't either and Cong left it so I'm good with that.
> 
> It has been there because of the infamous warnings triggered in
> sk_stream_kill_queues(). We have to wait for flying packets, but this
> _may_ be changed after we switch to tcp_read_skb() where we call
> skb_set_owner_sk_safe().
> 
> 
> > 
> > Reviewing backlog logic though I think there is another bug there, but
> > I haven't been able to trigger it in any of our tests.
> > 
> > The sk_psock_backlog() logic is,
> > 
> >  sk_psock_backlog(struct work_struct *work)
> >    mutex_lock()
> >    while (skb = ...)
> >    ...
> >    do {
> >      ret = sk_psock_handle_skb()
> >      if (ret <= 0) {
> >        if (ret == -EAGAIN) {
> >            sk_psock_skb_state()
> >            goto  end;
> >        } 
> >       ...
> >    } while (len);
> >    ...
> >   end:
> >    mutex_unlock()
> > 
> > what I'm not seeing is if we get an EAGAIN through sk_psock_handle_skb
> > how do we schedule the backlog again. For egress we would set the
> > SOCK_NOSPACE bit and then get a write space available callback which
> > would do the schedule(). The ingress side could fail with EAGAIN
> > through the alloc_sk_msg(GFP_ATOMIC) call. This is just a kzalloc,
> > 
> >    sk_psock_handle_skb()
> >     sk_psock_skb_ingress()
> >      sk_psock_skb_ingress_self()
> >        msg = alloc_sk_msg()
> >                kzalloc()          <- this can return NULL
> >        if (!msg)
> >           return -EAGAIN          <- could we stall now
> 
> Returning EAGAIN here makes little sense to me, it should be ENOMEM and
> is not worth retrying.

The trouble with not retrying is we would drop the skb. And unless
the application retries this could hang the application. So we
really need to try hard to send the sk_buff.

> 
> For other EAGAIN cases, why not just reschedule this work since state is
> already saved in sk_psock_work_state?

For EAGAIN sure. For ENOMEM above I simply didn't want to get in a
loop where we hit it a bunch of times with no backoff. I'm testing
a patch now so can send tomorrow.

> 
> Thanks.
