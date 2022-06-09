Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261C0544DC3
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbiFINdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243948AbiFINdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:33:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C68546174
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654781594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7eSqOGTybG9EtKoOIjU4Yprkieq4QzoxbYpNEitBhc=;
        b=G0s+h1CTIn6kNFE6Wr+kiOF8rKUnS2MeNKcX5d21WSQGraIE55oIcn2vSeX6qwrI5y7IxZ
        b6wKekHrGJaVf4arHMtLJMHCUYfEbYR+/WFgvNCcL1NkO2rrgb6SPvwMbGi15rQZytGBwR
        Rgwps8dG0TEFsC6YDJfvSJdLD9ip5Wc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-bSrOGI51P-qswiZM1q4ktQ-1; Thu, 09 Jun 2022 09:33:13 -0400
X-MC-Unique: bSrOGI51P-qswiZM1q4ktQ-1
Received: by mail-qt1-f198.google.com with SMTP id c1-20020ac81101000000b002f9219952f0so18694802qtj.15
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:33:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=H7eSqOGTybG9EtKoOIjU4Yprkieq4QzoxbYpNEitBhc=;
        b=kq0RinH3lNiC610CRcRHw7eI/LHDZhD7E7vlIlPeeGqGzd1/fU68hfF+dSJqBWrxle
         jkzo6BgScFYBpabfAz1jNEbKE9e/4OfF4rjIe5v1z9eFqUzywbztYCjURk9lGboJlBMy
         IRyi4Kr73ejSKU4Z1GVNWIar1RLcShR0KJtbhmJxU0J9ShZpi34h0hl8nwbyri6AFGFy
         J5+32OIQv2uyr7gDwdpecjaw1IQWQ3ngOuva/08DvQ+euT4eyxIPgRmWh8RYfXG+y2vP
         36kF09OD/e8t+dfDx66zNxhkf+l0NAfYhL2iX58lDOAXWvqG8+aLVpqDYPEhmwE/U9zA
         dt9g==
X-Gm-Message-State: AOAM5318cUM+cBxZtsPGbE8lo1DW9ndJnHZU0x/aCYTvchqs/5H0YOET
        WP/1Rc4EWR/DBdcHWCO34zQP9aDHxMhjJ4E47M6RNub+EU5pqECgt5YToqdIUt6GZEnqtGtNaRI
        pDq8tOkL1gGMG+pdW
X-Received: by 2002:a05:622a:50b:b0:2f3:e227:628a with SMTP id l11-20020a05622a050b00b002f3e227628amr30652672qtx.533.1654781592582;
        Thu, 09 Jun 2022 06:33:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytTKcTFaK2lX1ZkHRQjnPUGtGghjPzfCznnjWmX0xo6brMn0kWP7lorj9/JkZtk75Y7zGHOQ==
X-Received: by 2002:a05:622a:50b:b0:2f3:e227:628a with SMTP id l11-20020a05622a050b00b002f3e227628amr30652593qtx.533.1654781591771;
        Thu, 09 Jun 2022 06:33:11 -0700 (PDT)
Received: from gerbillo.redhat.com ([146.241.113.202])
        by smtp.gmail.com with ESMTPSA id z19-20020ac87f93000000b002f936bae288sm17833782qtj.87.2022.06.09.06.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 06:33:11 -0700 (PDT)
Message-ID: <548f2a708c106fbc8784b1c4c7740643749a3952.camel@redhat.com>
Subject: Re: [PATCH v3] net: ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, thomas@osterried.de
Date:   Thu, 09 Jun 2022 15:33:02 +0200
In-Reply-To: <4ccdba76.5ee33.181489cd6e4.Coremail.duoming@zju.edu.cn>
References: <20220608012923.17505-1-duoming@zju.edu.cn>
         <22175690a4e89a78abcb8244dfd0bdd0005267a5.camel@redhat.com>
         <4ccdba76.5ee33.181489cd6e4.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-09 at 21:17 +0800, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Thu, 09 Jun 2022 10:41:02 +0200 Paolo wrote:
> 
> > On Wed, 2022-06-08 at 09:29 +0800, Duoming Zhou wrote:
> > > The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
> > > and block until it receives a packet from the remote. If the client
> > > doesn`t connect to server and calls read() directly, it will not
> > > receive any packets forever. As a result, the deadlock will happen.
> > > 
> > > The fail log caused by deadlock is shown below:
> > > 
> > > [  369.606973] INFO: task ax25_deadlock:157 blocked for more than 245 seconds.
> > > [  369.608919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  369.613058] Call Trace:
> > > [  369.613315]  <TASK>
> > > [  369.614072]  __schedule+0x2f9/0xb20
> > > [  369.615029]  schedule+0x49/0xb0
> > > [  369.615734]  __lock_sock+0x92/0x100
> > > [  369.616763]  ? destroy_sched_domains_rcu+0x20/0x20
> > > [  369.617941]  lock_sock_nested+0x6e/0x70
> > > [  369.618809]  ax25_bind+0xaa/0x210
> > > [  369.619736]  __sys_bind+0xca/0xf0
> > > [  369.620039]  ? do_futex+0xae/0x1b0
> > > [  369.620387]  ? __x64_sys_futex+0x7c/0x1c0
> > > [  369.620601]  ? fpregs_assert_state_consistent+0x19/0x40
> > > [  369.620613]  __x64_sys_bind+0x11/0x20
> > > [  369.621791]  do_syscall_64+0x3b/0x90
> > > [  369.622423]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > > [  369.623319] RIP: 0033:0x7f43c8aa8af7
> > > [  369.624301] RSP: 002b:00007f43c8197ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> > > [  369.625756] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f43c8aa8af7
> > > [  369.626724] RDX: 0000000000000010 RSI: 000055768e2021d0 RDI: 0000000000000005
> > > [  369.628569] RBP: 00007f43c8197f00 R08: 0000000000000011 R09: 00007f43c8198700
> > > [  369.630208] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff845e6afe
> > > [  369.632240] R13: 00007fff845e6aff R14: 00007f43c8197fc0 R15: 00007f43c8198700
> > > 
> > > This patch moves the skb_recv_datagram() before lock_sock() in order that
> > > other functions that need lock_sock could be executed. What`s more, we
> > > add skb_free_datagram() before goto out in order to mitigate memory leak.
> > > 
> > > Suggested-by: Thomas Osterried <thomas@osterried.de>
> > > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > > Reported-by: Thomas Habets <thomas@@habets.se>
> > > ---
> > > Changes in v3:
> > >   - Add skb_free_datagram() before goto out in order to mitigate memory leak.
> > > 
> > >  net/ax25/af_ax25.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> > > index 95393bb2760..62aa5993093 100644
> > > --- a/net/ax25/af_ax25.c
> > > +++ b/net/ax25/af_ax25.c
> > > @@ -1665,6 +1665,11 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> > >  	int copied;
> > >  	int err = 0;
> > >  
> > > +	/* Now we can treat all alike */
> > > +	skb = skb_recv_datagram(sk, flags, &err);
> > > +	if (!skb)
> > > +		goto done;
> > > +
> > 
> > Note that this causes a behavior change: before this patch, calling
> > recvmsg() on unconnected seqpacket sockets returned immediatelly with
> > an error (due to the the check below), now it blocks. 
> > 
> > The change may confuse (== break) user-space applications. I think it
> > would be better replacing skb_recv_datagram with an open-coded variant
> > of it releasing the socket lock before the
> > __skb_wait_for_more_packets() call and re-acquiring it after such call.
> > Somewhat alike __unix_dgram_recvmsg().
> 
> Thank you for your time and suggestions!
> I think the following method may solve the problem.
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 95393bb2760..51b441c837c 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1675,8 +1675,10 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>                 goto out;
>         }
> 
> +       release_sock(sk);
>         /* Now we can treat all alike */
>         skb = skb_recv_datagram(sk, flags, &err);
> +       lock_sock(sk);
>         if (skb == NULL)
>                 goto out;
> 
> The skb_recv_datagram() is free of race conditions and could be re-entrant.
> So calling skb_recv_datagram() without the protection of lock_sock() is ok.
> 
> What's more, releasing the lock_sock() before skb_recv_datagram() will not
> cause UAF bugs. Because the sock will not be deallocated unless we call
> ax25_release(), but ax25_release() and ax25_recvmsg() could not run in parallel.
> 
> Although the "sk->sk_state" may be changed due to the release of lock_sock(),
> it will not influence the following operations in ax25_recvmsg().

One of the downside of the above is that recvmsg() will unconditionally
acquire and release the socket lock twice which can have non
trivial/nasty side effects on process scheduling.

With the suggested change the socket lock will be released only when
recvmsg will block and that should produce nicer overal behavior.

Cheers,

Paolo

