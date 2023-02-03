Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB9868A0D0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbjBCRuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbjBCRuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:50:50 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE3783F8;
        Fri,  3 Feb 2023 09:50:48 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k13so6037989plg.0;
        Fri, 03 Feb 2023 09:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEm7fmys02qKnl0xXNPaVbUx5HvkvW/capEyugpYu90=;
        b=dKqUAXFfsFJzfRKLi2wMrrUvHIz6nntb5AdB1QsZHzQQ4CeZMXnGBl0NbQeKpeJoQq
         MbejZhgZWadnFU3Gh7SvhOYwjmpyBPoUJ4i7ABgv9kuv1pgOZ5b0c3T3q9hsbTttgun+
         iurNnhvZBEouQ8WPcUURrRRjWt03gAP9C42kH4V9IU+R+tO3JwT+T/ZN16DMUIvHNjMP
         WhIPhPfkIOeJEGnLoQR5NFKRXtNxjsBW67OuOzHuTXTRT3KsyPvhKojn+/LoOmtDINZB
         Es/plj2F68ID4w1dYbycgCGCpWxr5Xry6tZS+DLLH2CWv8n2cJPh2dJ3bb8Grd0U+i0R
         2Ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEm7fmys02qKnl0xXNPaVbUx5HvkvW/capEyugpYu90=;
        b=BAm30+WplNQUyVa7cC5gEim/Bd9ya9Qn2hChTI9fdxgUVlN6onz0RIxemF63JlxkuW
         owBkvILcwKkKaU152LfR8NNcVazHBNrcDPXejZkrHkJUDhYtsPBgs+Tr0x/87iQ1YLCL
         +hOHBDiRJFIOIhdYj5hr/YQ39t0ek7b1yO+IO42ef/snA9DYOGdmpI6LBqDPtq0MpNaP
         2u0c5jYmWPHxCmxov0JDkkw+slhXG/jXEqyAW06Bxk3JZPeThyati+ChKV9x1+8DDLR8
         u3Mltm2Qkefs71v670WL/9zbnD04JjSKdA+HeKSsHDSoWd58fZC/Rbw7/pa2HGCSnlmP
         gEOQ==
X-Gm-Message-State: AO0yUKVlvEHvektbCV/WSnXfyjU4I13FehKNkaASLFWK8SWiVcnvL3Pk
        ZsL8WyiNfhdeN+0a/c3oKsM=
X-Google-Smtp-Source: AK7set+IhFpM/0Z35m7NvTtko1Kgj615r8OrKMK7hGUGf/giMKEV4amuQK9I+6DcEQ7ORt3eTd9n2w==
X-Received: by 2002:a17:90a:e2c2:b0:22c:868a:ef56 with SMTP id fr2-20020a17090ae2c200b0022c868aef56mr9754961pjb.2.1675446648044;
        Fri, 03 Feb 2023 09:50:48 -0800 (PST)
Received: from ip-172-31-38-16.us-west-2.compute.internal (ec2-52-37-71-140.us-west-2.compute.amazonaws.com. [52.37.71.140])
        by smtp.gmail.com with ESMTPSA id q69-20020a17090a1b4b00b0023086f9af77sm161358pjq.8.2023.02.03.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:50:47 -0800 (PST)
Date:   Fri, 3 Feb 2023 17:50:46 +0000
From:   Alok Tiagi <aloktiagi@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Hillf Danton <hdanton@sina.com>, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
Message-ID: <Y91JduiSy6mDCQ2a@ip-172-31-38-16.us-west-2.compute.internal>
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com>
 <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
 <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iL-RtzMdVuBeM_c4PPqZxk28hVwNhs9vMhwTyJwVhqS9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL-RtzMdVuBeM_c4PPqZxk28hVwNhs9vMhwTyJwVhqS9A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:09:12PM +0100, Eric Dumazet wrote:
> On Fri, Feb 3, 2023 at 12:59 AM Alok Tiagi <aloktiagi@gmail.com> wrote:
> >
> > On Thu, Feb 02, 2023 at 09:10:23PM +0100, Eric Dumazet wrote:
> > > On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
> > > >
> > > > On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> > > > > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> > > > > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> > > > > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
> > > > > >             break;
> > > > > >
> > > > > > +   case SO_SETNETNS:
> > > > > > +   {
> > > > > > +           struct net *other_ns, *my_ns;
> > > > > > +
> > > > > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> > > > > > +                   ret = -EOPNOTSUPP;
> > > > > > +                   break;
> > > > > > +           }
> > > > > > +
> > > > > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> > > > > > +                   ret = -EOPNOTSUPP;
> > > > > > +                   break;
> > > > > > +           }
> > > > > > +
> > > > > > +           other_ns = get_net_ns_by_fd(val);
> > > > > > +           if (IS_ERR(other_ns)) {
> > > > > > +                   ret = PTR_ERR(other_ns);
> > > > > > +                   break;
> > > > > > +           }
> > > > > > +
> > > > > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> > > > > > +                   ret = -EPERM;
> > > > > > +                   goto out_err;
> > > > > > +           }
> > > > > > +
> > > > > > +           /* check that the socket has never been connected or recently disconnected */
> > > > > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> > > > > > +                   ret = -EOPNOTSUPP;
> > > > > > +                   goto out_err;
> > > > > > +           }
> > > > > > +
> > > > > > +           /* check that the socket is not bound to an interface*/
> > > > > > +           if (sk->sk_bound_dev_if != 0) {
> > > > > > +                   ret = -EOPNOTSUPP;
> > > > > > +                   goto out_err;
> > > > > > +           }
> > > > > > +
> > > > > > +           my_ns = sock_net(sk);
> > > > > > +           sock_net_set(sk, other_ns);
> > > > > > +           put_net(my_ns);
> > > > > > +           break;
> > > > >
> > > > >               cpu 0                           cpu 2
> > > > >               ---                             ---
> > > > >                                               ns = sock_net(sk);
> > > > >               my_ns = sock_net(sk);
> > > > >               sock_net_set(sk, other_ns);
> > > > >               put_net(my_ns);
> > > > >                                               ns is invalid ?
> > > >
> > > > That is the reason we want the socket to be in an un-connected state. That
> > > > should help us avoid this situation.
> > >
> > > This is not enough....
> > >
> > > Another thread might look at sock_net(sk), for example from inet_diag
> > > or tcp timers
> > > (which can be fired even in un-connected state)
> > >
> > > Even UDP sockets can receive packets while being un-connected,
> > > and they need to deref the net pointer.
> > >
> > > Currently there is no protection about sock_net(sk) being changed on the fly,
> > > and the struct net could disappear and be freed.
> > >
> > > There are ~1500 uses of sock_net(sk) in the kernel, I do not think
> > > you/we want to audit all
> > > of them to check what could go wrong...
> >
> > I agree, auditing all the uses of sock_net(sk) is not a feasible option. From my
> > exploration of the usage of sock_net(sk) it appeared that it might be safe to
> > swap a sockets net ns if it had never been connected but I looked at only a
> > subset of such uses.
> >
> > Introducing a ref counting logic to every access of sock_net(sk) may help get
> > around this but invovles a bigger change to increment and decrement the count at
> > every use of sock_net().
> >
> > Any suggestions if this could be achieved in another way much close to the
> > socket creation time or any comments on our workaround for injecting sockets using
> > seccomp addfd?
> 
> Maybe the existing BPF hook in inet_create() could be used ?
> 
> err = BPF_CGROUP_RUN_PROG_INET_SOCK(sk);
> 
> The BPF program might be able to switch the netns, because at this
> time the new socket is not
> yet visible from external threads.
> 
> Although it is not going to catch dual stack uses (open a V6 socket,
> then use a v4mapped address at bind()/connect()/...

We thought of a similar approach by intercepting the socket() call in seccomp
and injecting a new file descritpor much earlier but as you said we run into the
issue of handling dual stack sockets since we do not know in advance if its
going to be used for a v4mapped address.

