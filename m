Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42665F575
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbjAEVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbjAEVBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:01:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317A535933
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672952443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tzR1wuYK3UmrwZ+hCZQA6kbAzh2uxHYFM70DAhZqBlU=;
        b=JOZ5aTRGg4niU5T7/GnLhMQIZFPkt5Q/8gmE8vT9taDF0yoN8HnHAGiOmQCKGJs9qb0OXb
        ePf3iQqvCwGq4I4UIQ6O8EiFRavcr0larmFrkMLseCKxDpAtM2ox0m9/ZRr+LEOmtn2aYm
        I9iG83Jd7WK/yZptJN1Br6cXkc4GWEE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-jzudp9ikPL-iKemDCm3EHg-1; Thu, 05 Jan 2023 16:00:42 -0500
X-MC-Unique: jzudp9ikPL-iKemDCm3EHg-1
Received: by mail-pg1-f199.google.com with SMTP id k16-20020a635a50000000b0042986056df6so17383664pgm.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 13:00:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzR1wuYK3UmrwZ+hCZQA6kbAzh2uxHYFM70DAhZqBlU=;
        b=6nq1r8mNn82p4WaJoR1+JxzEkGXNZTVd4Zco16rJKNyN/eXgPKbvo6G7Mw/tEkKmW3
         YeYCu+nfRCRcXLie6W6BYeJT2tFtqE98RTqLuxtR8bnFSCvKG9OJDGlGoK/df1fAGOo/
         MIRtsqYZSPXFI61R+DMNZJwby+27eSnPyl/tlYPPE0IOjgkvR+58aGUI+9iSyjSOc69K
         dfgTFSuI8hSCWMNMt8LzSp05tBSoJSfL+1YqJDgyFQi3INAhOfpWk6O5fRghUQgZ7EtY
         t92hKloEU2knXUGw2GxLTEvEMyI+NbtQDo2/CvIyuaaNpFLqTjfxwXIo7yeI+SqwdNP/
         ZevA==
X-Gm-Message-State: AFqh2koAaYojajHbBnFBYMdP3i6leTnzrjRwN+f93kaAf2mOcg9ZQJwg
        Mt9JwBMWPPPD8Ar6EKL7ZJMgB0NP3n9RCuU5r5ejkFzEucP98Y1CRTUGtjd0nYcGjU8MM8LvSpx
        m7anFgJi4lTDJXsMC
X-Received: by 2002:a17:902:f604:b0:192:55ab:88fe with SMTP id n4-20020a170902f60400b0019255ab88femr59519109plg.56.1672952440604;
        Thu, 05 Jan 2023 13:00:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsStt8vIjhcmCC1xPxFgNuYCD+E2HWcvG2z9NLpGXZEusMwS+11yc/i6oZSoLkZhcemO6CG4A==
X-Received: by 2002:a17:902:f604:b0:192:55ab:88fe with SMTP id n4-20020a170902f60400b0019255ab88femr59519092plg.56.1672952440362;
        Thu, 05 Jan 2023 13:00:40 -0800 (PST)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id i9-20020a170902cf0900b0018999a3dd7esm26316946plg.28.2023.01.05.13.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 13:00:39 -0800 (PST)
Date:   Fri, 6 Jan 2023 06:00:35 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dmytro@shytyi.net, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: Fix deadlock in mptcp_sendmsg()
Message-ID: <Y7c6c+5h25bEcn/A@kernel-devel>
References: <20230105201205.1087439-1-syoshida@redhat.com>
 <548fc9cf-b674-f37e-8ff7-9abae0bf15a8@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548fc9cf-b674-f37e-8ff7-9abae0bf15a8@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 12:26:29PM -0800, Mat Martineau wrote:
> On Fri, 6 Jan 2023, Shigeru Yoshida wrote:
> 
> > __mptcp_close_ssk() can be called from mptcp_sendmsg() with subflow
> > socket locked.  This can cause a deadlock as below:
> > 
> > mptcp_sendmsg()
> >  mptcp_sendmsg_fastopen() --> lock ssk
> >    tcp_sendmsg_fastopen()
> >       __inet_stream_connect()
> >          mptcp_disconnect()
> >             mptcp_destroy_common()
> >                __mptcp_close_ssk() --> lock ssk again
> > 
> > This patch fixes the issue by skipping locking for subflow socket
> > which is already locked.
> > 
> 
> Hi Shigeru -
> 
> I believe this has already been fixed by:
> 
> 7d803344fdc3 ("mptcp: fix deadlock in fastopen error path")
> 
> It is in the net repo:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

Hi Mat,

Thank you so much for your prompt response.  I've missed above patch.
Yes, the patch fixed the same issue.

Thank you~

Shigeru

> 
> ...but hasn't been merged to net-next or Linus' tree yet. Jakub said to
> expect a net PR today, which should get the fix both upstream and in to
> net-next.
> 
> Thanks,
> 
> Mat
> 
> > Fixes: d98a82a6afc7 ("mptcp: handle defer connect in mptcp_sendmsg")
> > Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> > ---
> > net/mptcp/protocol.c | 15 +++++++++------
> > net/mptcp/protocol.h |  4 ++--
> > 2 files changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index f6f93957275b..979265f66082 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -1672,9 +1672,9 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
> > 	lock_sock(ssk);
> > 	msg->msg_flags |= MSG_DONTWAIT;
> > 	msk->connect_flags = O_NONBLOCK;
> > -	msk->is_sendmsg = 1;
> > +	msk->sendmsg_locked_sk = ssk;
> > 	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, len, NULL);
> > -	msk->is_sendmsg = 0;
> > +	msk->sendmsg_locked_sk = NULL;
> > 	msg->msg_flags = saved_flags;
> > 	release_sock(ssk);
> > 
> > @@ -2319,7 +2319,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
> > 	if (dispose_it)
> > 		list_del(&subflow->node);
> > 
> > -	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
> > +	if (msk->sendmsg_locked_sk != ssk)
> > +		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
> > 
> > 	if (flags & MPTCP_CF_FASTCLOSE) {
> > 		/* be sure to force the tcp_disconnect() path,
> > @@ -2335,7 +2336,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
> > 		tcp_disconnect(ssk, 0);
> > 		msk->subflow->state = SS_UNCONNECTED;
> > 		mptcp_subflow_ctx_reset(subflow);
> > -		release_sock(ssk);
> > +		if (msk->sendmsg_locked_sk != ssk)
> > +			release_sock(ssk);
> > 
> > 		goto out;
> > 	}
> > @@ -2362,7 +2364,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
> > 		/* close acquired an extra ref */
> > 		__sock_put(ssk);
> > 	}
> > -	release_sock(ssk);
> > +	if (msk->sendmsg_locked_sk != ssk)
> > +		release_sock(ssk);
> > 
> > 	sock_put(ssk);
> > 
> > @@ -3532,7 +3535,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > 	/* if reaching here via the fastopen/sendmsg path, the caller already
> > 	 * acquired the subflow socket lock, too.
> > 	 */
> > -	if (msk->is_sendmsg)
> > +	if (msk->sendmsg_locked_sk)
> > 		err = __inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags, 1);
> > 	else
> > 		err = inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags);
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index 955fb3d88eb3..43afc399e16b 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
> > @@ -294,8 +294,7 @@ struct mptcp_sock {
> > 	u8		mpc_endpoint_id;
> > 	u8		recvmsg_inq:1,
> > 			cork:1,
> > -			nodelay:1,
> > -			is_sendmsg:1;
> > +			nodelay:1;
> > 	int		connect_flags;
> > 	struct work_struct work;
> > 	struct sk_buff  *ooo_last_skb;
> > @@ -318,6 +317,7 @@ struct mptcp_sock {
> > 	u32 setsockopt_seq;
> > 	char		ca_name[TCP_CA_NAME_MAX];
> > 	struct mptcp_sock	*dl_next;
> > +	struct sock	*sendmsg_locked_sk;
> > };
> > 
> > #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
> > -- 
> > 2.39.0
> > 
> > 
> 
> --
> Mat Martineau
> Intel
> 

