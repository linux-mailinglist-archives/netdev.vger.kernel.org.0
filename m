Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4098E689DC2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbjBCPNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbjBCPMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:12:50 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71652A58DC
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:10:33 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id a1so6563338ybj.9
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 07:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oM1VZ26VMzyeaMXfXCF0KI1F+A9gkfxg4J5wcG7w8r4=;
        b=PDTZr0Lmh+qWPPwlNmv4VOIgyBqx1VQi+ZkI5uG6OWcbQGP2AgOzV4u7oDRHOxP9Ax
         u1pQqumqmr6KpA8bUcJ0rRaLAKaqc49hbGagDvVeFLKFzgtLRzmVyzLYHHT1W/dg/uh1
         gT3CoSnUgiPCEiw6CXjVJAsjL1HzYZ8qswinkvnY85vuKVXqfB4U4jJA7/UUIJGFzWyA
         QI2Dj4znYFYWgE+KKRvucqYbNT93BI/RbRxpZ8vEuEcTRV/gqAoaRmWnrHZxlOwjj/4z
         whyyV4xSoNGZ2n0NmAemrTywt+7eeRAjh2/3HYa1pgq60lMme4o9B0BXmpPhEj2vK15g
         O8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oM1VZ26VMzyeaMXfXCF0KI1F+A9gkfxg4J5wcG7w8r4=;
        b=G2n+37K5t98svG74fUHktYxIuUoei/lxT0c8ttIBrBiHnfGXinfW1Vnh+rjYrD6pAn
         WRkSQzp5j7/Yj8VTi3pBca6L0ApXi0Ci1Jiuko+oKzgwEB0hEwBBQOBc9M2lO+46gvBF
         vaq6D5oWObsIADTvLlQrE0NScXsWWFq9iey7f/aAGM5pKjIOE632U1pmEtbiw9D0XfL1
         vkkqIkFysvi9BRwzxkb7cylJzGjqqUPdL2p2+vmMGL0E97085SVofP72g99hcG+cblpM
         rmvHW0QchlXAVUzjW0i6gQDzTyeK7UZTtp+1eFWPxl8Z+47/N/yNXHn0ZSiFmF3SGolC
         4DfQ==
X-Gm-Message-State: AO0yUKUzzrfcdnl8zsNLRom/GymRVRyKYuXWaIYz/Xv3lZcx8/OFPt3z
        5nnTyt561kagib2zYncrrtS9OMkujmYsFyU02UcVtA==
X-Google-Smtp-Source: AK7set+EroEX00FdhlN+nDb0LqTCzvNmLfRjuN9I3dELplssEf9m3RiTPxBm3aoR7QT3/ZyX00mwYd2X5rE/UFjUt5U=
X-Received: by 2002:a25:2f47:0:b0:860:c986:cea1 with SMTP id
 v68-20020a252f47000000b00860c986cea1mr526344ybv.532.1675436963817; Fri, 03
 Feb 2023 07:09:23 -0800 (PST)
MIME-Version: 1.0
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com> <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com> <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
In-Reply-To: <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Feb 2023 16:09:12 +0100
Message-ID: <CANn89iL-RtzMdVuBeM_c4PPqZxk28hVwNhs9vMhwTyJwVhqS9A@mail.gmail.com>
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
To:     Alok Tiagi <aloktiagi@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 12:59 AM Alok Tiagi <aloktiagi@gmail.com> wrote:
>
> On Thu, Feb 02, 2023 at 09:10:23PM +0100, Eric Dumazet wrote:
> > On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
> > >
> > > On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> > > > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> > > > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> > > > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
> > > > >             break;
> > > > >
> > > > > +   case SO_SETNETNS:
> > > > > +   {
> > > > > +           struct net *other_ns, *my_ns;
> > > > > +
> > > > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> > > > > +                   ret = -EOPNOTSUPP;
> > > > > +                   break;
> > > > > +           }
> > > > > +
> > > > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> > > > > +                   ret = -EOPNOTSUPP;
> > > > > +                   break;
> > > > > +           }
> > > > > +
> > > > > +           other_ns = get_net_ns_by_fd(val);
> > > > > +           if (IS_ERR(other_ns)) {
> > > > > +                   ret = PTR_ERR(other_ns);
> > > > > +                   break;
> > > > > +           }
> > > > > +
> > > > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> > > > > +                   ret = -EPERM;
> > > > > +                   goto out_err;
> > > > > +           }
> > > > > +
> > > > > +           /* check that the socket has never been connected or recently disconnected */
> > > > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> > > > > +                   ret = -EOPNOTSUPP;
> > > > > +                   goto out_err;
> > > > > +           }
> > > > > +
> > > > > +           /* check that the socket is not bound to an interface*/
> > > > > +           if (sk->sk_bound_dev_if != 0) {
> > > > > +                   ret = -EOPNOTSUPP;
> > > > > +                   goto out_err;
> > > > > +           }
> > > > > +
> > > > > +           my_ns = sock_net(sk);
> > > > > +           sock_net_set(sk, other_ns);
> > > > > +           put_net(my_ns);
> > > > > +           break;
> > > >
> > > >               cpu 0                           cpu 2
> > > >               ---                             ---
> > > >                                               ns = sock_net(sk);
> > > >               my_ns = sock_net(sk);
> > > >               sock_net_set(sk, other_ns);
> > > >               put_net(my_ns);
> > > >                                               ns is invalid ?
> > >
> > > That is the reason we want the socket to be in an un-connected state. That
> > > should help us avoid this situation.
> >
> > This is not enough....
> >
> > Another thread might look at sock_net(sk), for example from inet_diag
> > or tcp timers
> > (which can be fired even in un-connected state)
> >
> > Even UDP sockets can receive packets while being un-connected,
> > and they need to deref the net pointer.
> >
> > Currently there is no protection about sock_net(sk) being changed on the fly,
> > and the struct net could disappear and be freed.
> >
> > There are ~1500 uses of sock_net(sk) in the kernel, I do not think
> > you/we want to audit all
> > of them to check what could go wrong...
>
> I agree, auditing all the uses of sock_net(sk) is not a feasible option. From my
> exploration of the usage of sock_net(sk) it appeared that it might be safe to
> swap a sockets net ns if it had never been connected but I looked at only a
> subset of such uses.
>
> Introducing a ref counting logic to every access of sock_net(sk) may help get
> around this but invovles a bigger change to increment and decrement the count at
> every use of sock_net().
>
> Any suggestions if this could be achieved in another way much close to the
> socket creation time or any comments on our workaround for injecting sockets using
> seccomp addfd?

Maybe the existing BPF hook in inet_create() could be used ?

err = BPF_CGROUP_RUN_PROG_INET_SOCK(sk);

The BPF program might be able to switch the netns, because at this
time the new socket is not
yet visible from external threads.

Although it is not going to catch dual stack uses (open a V6 socket,
then use a v4mapped address at bind()/connect()/...
