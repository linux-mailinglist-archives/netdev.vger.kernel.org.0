Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D368ABF2
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 19:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjBDSoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 13:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjBDSoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 13:44:14 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E7C1632F;
        Sat,  4 Feb 2023 10:44:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso1912393pjb.4;
        Sat, 04 Feb 2023 10:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqYt9g6AFqNm6rbEG0gvrXgdEtTQwUJ8dtb6JRDh6lM=;
        b=HySefaM8ppVO2gTyuhnFHaomMMuXSNUflZHhoBsrJtyYOfWoVgLRnLP7/R3YiDip2U
         A9xZdewZMKEC3qxN6uEwh/dieVOkKZ4PMGU6x+u9MU+sjlinV0g24vTr/TIZ2hxEoRbh
         L2hYGJJSmvxUOyZ3RvpMJ5N+6PLaffdHgkNQEq3l9KKyzPBBYP+Z7gJkRTvNW5zmN+JS
         LHhBG/sAhS9lhl/74440Nnk6HePPWMnVnWPBskAFe2CgMBDXJ4s2/UZSboUWBVbfo6y8
         BBPxuoL5gYgsWEFRTuC9UB8PTSDYf5hP4zbPAKRwWXaffOOsm+vOalR2QmJfo6lWrMwZ
         M59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqYt9g6AFqNm6rbEG0gvrXgdEtTQwUJ8dtb6JRDh6lM=;
        b=3xhzm1isouRvxUkYe7zt9+VusvAyXCRSptAmSsWkL1yeKyRUG4+55LQiQIzQJEnwrx
         e4qeuI3lsHCc3AeW15fOZ/qaB0EnqllaJIzgC/gCAUWlNCV7y3GNdieEjqIW2lRB1QJr
         gcv002RymssxuQ5aD7M1r4sHyvFEi8cwaIq4wgI2JgLK4CYmpFJ1cwTvYP9QaLjA2WD4
         0UXl1FS5SIlSGr+4eo+QagnpIhO7fMI1i+ITT9GHc2LLrRG0iDB2Q13lpc6jC96Q6+dB
         0hUT5ZVI82RW7bPiRY3kOxqBCMhTqJN5fXPddh2oWnlw9FyPmrZ6VAxtHDcy2A/PHtyj
         X0fw==
X-Gm-Message-State: AO0yUKW7Q2NWnFLOcBr6E0RozYoorXzARXrMzhIEtRhPo1gNf5i1wc1a
        pyDXF6qC64ciFHnmJWJ4VUw=
X-Google-Smtp-Source: AK7set8atgpNU869HwOIb299A6k9OhBoRhryH/T/rOucAP5gZA3UryJk5gF0qjrjutOEqyRLGtTswA==
X-Received: by 2002:a17:903:41cf:b0:198:e8c6:859a with SMTP id u15-20020a17090341cf00b00198e8c6859amr5417858ple.0.1675536251611;
        Sat, 04 Feb 2023 10:44:11 -0800 (PST)
Received: from ip-172-31-38-16.us-west-2.compute.internal (ec2-52-37-71-140.us-west-2.compute.amazonaws.com. [52.37.71.140])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902868600b00192fe452e17sm3774293plo.162.2023.02.04.10.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 10:44:11 -0800 (PST)
Date:   Sat, 4 Feb 2023 18:44:09 +0000
From:   Alok Tiagi <aloktiagi@gmail.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tycho@tycho.pizza
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
Message-ID: <Y96neSjTtm2kRetn@ip-172-31-38-16.us-west-2.compute.internal>
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com>
 <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
 <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iL-RtzMdVuBeM_c4PPqZxk28hVwNhs9vMhwTyJwVhqS9A@mail.gmail.com>
 <Y91JduiSy6mDCQ2a@ip-172-31-38-16.us-west-2.compute.internal>
 <87tu0278kt.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu0278kt.fsf@email.froward.int.ebiederm.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 03:17:06PM -0600, Eric W. Biederman wrote:
> Alok Tiagi <aloktiagi@gmail.com> writes:
> 
> > On Fri, Feb 03, 2023 at 04:09:12PM +0100, Eric Dumazet wrote:
> >> On Fri, Feb 3, 2023 at 12:59 AM Alok Tiagi <aloktiagi@gmail.com> wrote:
> >> >
> >> > On Thu, Feb 02, 2023 at 09:10:23PM +0100, Eric Dumazet wrote:
> >> > > On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
> >> > > >
> >> > > > On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> >> > > > > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> >> > > > > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> >> > > > > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
> >> > > > > >             break;
> >> > > > > >
> >> > > > > > +   case SO_SETNETNS:
> >> > > > > > +   {
> >> > > > > > +           struct net *other_ns, *my_ns;
> >> > > > > > +
> >> > > > > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> >> > > > > > +                   ret = -EOPNOTSUPP;
> >> > > > > > +                   break;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> >> > > > > > +                   ret = -EOPNOTSUPP;
> >> > > > > > +                   break;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           other_ns = get_net_ns_by_fd(val);
> >> > > > > > +           if (IS_ERR(other_ns)) {
> >> > > > > > +                   ret = PTR_ERR(other_ns);
> >> > > > > > +                   break;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> >> > > > > > +                   ret = -EPERM;
> >> > > > > > +                   goto out_err;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           /* check that the socket has never been connected or recently disconnected */
> >> > > > > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> >> > > > > > +                   ret = -EOPNOTSUPP;
> >> > > > > > +                   goto out_err;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           /* check that the socket is not bound to an interface*/
> >> > > > > > +           if (sk->sk_bound_dev_if != 0) {
> >> > > > > > +                   ret = -EOPNOTSUPP;
> >> > > > > > +                   goto out_err;
> >> > > > > > +           }
> >> > > > > > +
> >> > > > > > +           my_ns = sock_net(sk);
> >> > > > > > +           sock_net_set(sk, other_ns);
> >> > > > > > +           put_net(my_ns);
> >> > > > > > +           break;
> >> > > > >
> >> > > > >               cpu 0                           cpu 2
> >> > > > >               ---                             ---
> >> > > > >                                               ns = sock_net(sk);
> >> > > > >               my_ns = sock_net(sk);
> >> > > > >               sock_net_set(sk, other_ns);
> >> > > > >               put_net(my_ns);
> >> > > > >                                               ns is invalid ?
> >> > > >
> >> > > > That is the reason we want the socket to be in an un-connected state. That
> >> > > > should help us avoid this situation.
> >> > >
> >> > > This is not enough....
> >> > >
> >> > > Another thread might look at sock_net(sk), for example from inet_diag
> >> > > or tcp timers
> >> > > (which can be fired even in un-connected state)
> >> > >
> >> > > Even UDP sockets can receive packets while being un-connected,
> >> > > and they need to deref the net pointer.
> >> > >
> >> > > Currently there is no protection about sock_net(sk) being changed on the fly,
> >> > > and the struct net could disappear and be freed.
> >> > >
> >> > > There are ~1500 uses of sock_net(sk) in the kernel, I do not think
> >> > > you/we want to audit all
> >> > > of them to check what could go wrong...
> >> >
> >> > I agree, auditing all the uses of sock_net(sk) is not a feasible option. From my
> >> > exploration of the usage of sock_net(sk) it appeared that it might be safe to
> >> > swap a sockets net ns if it had never been connected but I looked at only a
> >> > subset of such uses.
> >> >
> >> > Introducing a ref counting logic to every access of sock_net(sk) may help get
> >> > around this but invovles a bigger change to increment and decrement the count at
> >> > every use of sock_net().
> >> >
> >> > Any suggestions if this could be achieved in another way much close to the
> >> > socket creation time or any comments on our workaround for injecting sockets using
> >> > seccomp addfd?
> >> 
> >> Maybe the existing BPF hook in inet_create() could be used ?
> >> 
> >> err = BPF_CGROUP_RUN_PROG_INET_SOCK(sk);
> >> 
> >> The BPF program might be able to switch the netns, because at this
> >> time the new socket is not
> >> yet visible from external threads.
> >> 
> >> Although it is not going to catch dual stack uses (open a V6 socket,
> >> then use a v4mapped address at bind()/connect()/...
> >
> > We thought of a similar approach by intercepting the socket() call in seccomp
> > and injecting a new file descritpor much earlier but as you said we run into the
> > issue of handling dual stack sockets since we do not know in advance if its
> > going to be used for a v4mapped address.
> 
> I would suggest adding a default ipv4 route from your ipv6 network
> namespaces to your ipv4 network namespace, but that only works for
> outbound traffic.  The inbound traffic problem is classically solved
> via nat.
> 
> That you are not suggesting using nat has me thinking there is something
> subtle in what you are trying to do that I am missing.
> 
> Perhaps your userspace can do:
> 
> 	previous_netns = open("/proc/self/ns/net");
> 	setns(ipv4_netns);
> 	socket();
> 	setns(previous_netns);
> 
> 
> As the network namespace is per thread this is atomic if you add
> the logic to block signals around it.
> 
> Eric

That is correct, we are not using nat, but we are providing a mechanism for the
users of our container platform to move to ipv6 only while keeping egress
connectivity to their ipv4 destinations. We are doing this transparently without
any change in user code, but by intercept networking syscalls in a container
manager running in a dedicated ipv4 only network namespace. Our current solution
as described in my original commit message has limitations and we are looking
for a way to switch a sockets namespace from the ipv6 only container network
namespace to the dedicated ipv4 network namespace which really simplifies our
design.

Since our userspace is the container workload we have no control over how they
instantiate their sockets.

