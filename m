Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF6688B33
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 00:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjBBX7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjBBX7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 18:59:00 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F006C728DC;
        Thu,  2 Feb 2023 15:58:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id pj3so3450789pjb.1;
        Thu, 02 Feb 2023 15:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZLUE4h1sqc7MySbUKRBEYcGGu756rHDYEhBHMqoe3o=;
        b=UoxLyfqSDWqaV4GeE8i3UHEP6i2oUc6EGHJltUEZOCv0Ev7uf2q3YPnbs2eFr5eHOV
         zFXl1NNcpc6tiZL1h0ig51Nb3qzgqiHGsL4qgL5w3BwyG+fpNbSk/PtJj5x+4RNFuGep
         f4e1bIB/26pRzspcZRgCgWTmKNZSvsSZ1Z1FasxdMoNLms8C+OqPBq22eNa6jCLquwCA
         eCSsSQOsndyXQtlILC8r4MG4uXsOdWOzXNwQhUYEzkS10Y7SO98H6ls3ECtfeqbfIOO8
         /qWiRYOA/R+LGSRP7cI0Q03VbjmBsB2SjaAWvmDpO7JTxy+38eRgx6XKeCr5cfaDeZWJ
         aiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZLUE4h1sqc7MySbUKRBEYcGGu756rHDYEhBHMqoe3o=;
        b=CzVG0Qev+W1KIJybFV20Pl1Dq+jqZbk4uXSzudRU67xNF9kLuD+PHIyY8RAT+U1XX9
         ylAhlvN8+fWojn1UWy2oCTu5T4mO+Dux+pDOPkXglfxL1mVSlzpaGyi8zceurX7qAOCw
         xdQv+BkGngKHmJsnMuiflcA6BhcPd5Ju4y8DTC3UUF+zFoXqaesy/M2ZBMBsBc0D2XHa
         iHiszJEwlsKUofaMr2PGM/kbR9AGECNyZ2tvE77AmYksrLg7lIR5/CX9n/hlGsQABzEK
         89skQ5NcYY9FGdWVRm+Kjk2bOdTRIOElaeqLIknL9xITySUcro6qTG6pYsiHInnlkDDs
         Ccew==
X-Gm-Message-State: AO0yUKVObkH9Nc2FfphQ9/P8P8Qx1nu92vwXfs7k2BHRGqFN7aTkEZNW
        85d0MJfxILpP7u+IjWp69v0=
X-Google-Smtp-Source: AK7set8YV+w4lOgomi3a/KhDR9OhXQsAl+NAVu3VhHD9Mr62epwrYLVzzChFLCDk3gr05WMkvfiUvg==
X-Received: by 2002:a17:903:2484:b0:193:1203:6e3f with SMTP id p4-20020a170903248400b0019312036e3fmr9179269plw.3.1675382338285;
        Thu, 02 Feb 2023 15:58:58 -0800 (PST)
Received: from ip-172-31-38-16.us-west-2.compute.internal (ec2-52-37-71-140.us-west-2.compute.amazonaws.com. [52.37.71.140])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ff0200b001869ba04c83sm223448plj.245.2023.02.02.15.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 15:58:57 -0800 (PST)
Date:   Thu, 2 Feb 2023 23:58:56 +0000
From:   Alok Tiagi <aloktiagi@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Hillf Danton <hdanton@sina.com>, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
Message-ID: <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com>
 <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
 <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:10:23PM +0100, Eric Dumazet wrote:
> On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
> >
> > On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> > > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> > > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> > > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
> > > >             break;
> > > >
> > > > +   case SO_SETNETNS:
> > > > +   {
> > > > +           struct net *other_ns, *my_ns;
> > > > +
> > > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> > > > +                   ret = -EOPNOTSUPP;
> > > > +                   break;
> > > > +           }
> > > > +
> > > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> > > > +                   ret = -EOPNOTSUPP;
> > > > +                   break;
> > > > +           }
> > > > +
> > > > +           other_ns = get_net_ns_by_fd(val);
> > > > +           if (IS_ERR(other_ns)) {
> > > > +                   ret = PTR_ERR(other_ns);
> > > > +                   break;
> > > > +           }
> > > > +
> > > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> > > > +                   ret = -EPERM;
> > > > +                   goto out_err;
> > > > +           }
> > > > +
> > > > +           /* check that the socket has never been connected or recently disconnected */
> > > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> > > > +                   ret = -EOPNOTSUPP;
> > > > +                   goto out_err;
> > > > +           }
> > > > +
> > > > +           /* check that the socket is not bound to an interface*/
> > > > +           if (sk->sk_bound_dev_if != 0) {
> > > > +                   ret = -EOPNOTSUPP;
> > > > +                   goto out_err;
> > > > +           }
> > > > +
> > > > +           my_ns = sock_net(sk);
> > > > +           sock_net_set(sk, other_ns);
> > > > +           put_net(my_ns);
> > > > +           break;
> > >
> > >               cpu 0                           cpu 2
> > >               ---                             ---
> > >                                               ns = sock_net(sk);
> > >               my_ns = sock_net(sk);
> > >               sock_net_set(sk, other_ns);
> > >               put_net(my_ns);
> > >                                               ns is invalid ?
> >
> > That is the reason we want the socket to be in an un-connected state. That
> > should help us avoid this situation.
> 
> This is not enough....
> 
> Another thread might look at sock_net(sk), for example from inet_diag
> or tcp timers
> (which can be fired even in un-connected state)
> 
> Even UDP sockets can receive packets while being un-connected,
> and they need to deref the net pointer.
> 
> Currently there is no protection about sock_net(sk) being changed on the fly,
> and the struct net could disappear and be freed.
> 
> There are ~1500 uses of sock_net(sk) in the kernel, I do not think
> you/we want to audit all
> of them to check what could go wrong...

I agree, auditing all the uses of sock_net(sk) is not a feasible option. From my
exploration of the usage of sock_net(sk) it appeared that it might be safe to
swap a sockets net ns if it had never been connected but I looked at only a
subset of such uses.

Introducing a ref counting logic to every access of sock_net(sk) may help get
around this but invovles a bigger change to increment and decrement the count at
every use of sock_net().

Any suggestions if this could be achieved in another way much close to the
socket creation time or any comments on our workaround for injecting sockets using
seccomp addfd?
