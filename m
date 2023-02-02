Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78B68880E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBBUKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBBUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:10:42 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D02381B09
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:10:36 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-50aa54cc7c0so41467797b3.8
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aMAjimDlKMwUcRFDQ6b+VBfedyOvbLyBE+vOI+tSfHA=;
        b=kyF+/plr5E/Ea/CcC8kG3DZtLYwmW3pbaj7ub7BWG0oOmUWEs0ikGKms709xZ3r46a
         fS7/eLvB6OiRfJsQp73/xjkOdf4G6I4FnffK8HFGbsX3nuet1hVVnM8RCxxsPhZqXauh
         yTbOzle222FWt7Wu3vu0dxPxYG5oHgB02m+paWO1aDZtPtA4vBqOc4bS2gapXOCToqGM
         UUzG8sVKIM+PeBZts0WxdKwxlr0k3szWFpNBVDkGgXGsfaK/35+ADzW+Tjti47JUCMCE
         zSkdeSfuPAXbUqU43dOSHwnYFZn5HT1g36N0MkXCDgfHIHxC3hbU6ACLIr2UwUTMAM5u
         ibWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMAjimDlKMwUcRFDQ6b+VBfedyOvbLyBE+vOI+tSfHA=;
        b=Fdz7RvX6qIoiB3Q7ZmsB6EKO9sSVWkx/dlui//sQtynqFt0PkUegRenULBzVFFKD7u
         kHlf9C4EqCN7iLg1l8ZXG6jB3kbcVS2c7HIRqiW0i3VBHl3Gc0sAOdGPAYCH04+yGQRX
         UvveLRao5TZdMAgmlgietkaps9Y7B97iJJH3EafbiCUNYwG7W9W54iLpLQvDOAqGgxpg
         f0+W/8DCL+GUA7lGVJXeU6NmeGsGvceI8ZcKeVjXdGAW0Br5/TpgWNbbxagCgSvxX8Ol
         VvT69xBMpyrmlCpN8trjbbwZjPaogNRsSIN0vzr4EgrMz3OLxZw3fMo7dkXvUQd8pTfC
         RUZQ==
X-Gm-Message-State: AO0yUKVZYzNilBKepjmFWjQ2WMzN0VyDuTbE/wWju7AiusLYyasTy84S
        RoKBIFT6+09lmFw8C1wv0snmlIF7JUkjshQFRbI+vA==
X-Google-Smtp-Source: AK7set9AqY68emvr60gryS7o515sri+M7IT/v1XYZ0VEeOpgfCcezGt7jhwHyJF5LmQMbsFZMGLvgpHWm+XynGoijC0=
X-Received: by 2002:a05:690c:39f:b0:50f:9101:875f with SMTP id
 bh31-20020a05690c039f00b0050f9101875fmr855576ywb.392.1675368635261; Thu, 02
 Feb 2023 12:10:35 -0800 (PST)
MIME-Version: 1.0
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
 <20230202014810.744-1-hdanton@sina.com> <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
In-Reply-To: <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Feb 2023 21:10:23 +0100
Message-ID: <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
To:     Alok Tiagi <aloktiagi@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
>
> On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
> > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
> > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
> > >             break;
> > >
> > > +   case SO_SETNETNS:
> > > +   {
> > > +           struct net *other_ns, *my_ns;
> > > +
> > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
> > > +                   ret = -EOPNOTSUPP;
> > > +                   break;
> > > +           }
> > > +
> > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
> > > +                   ret = -EOPNOTSUPP;
> > > +                   break;
> > > +           }
> > > +
> > > +           other_ns = get_net_ns_by_fd(val);
> > > +           if (IS_ERR(other_ns)) {
> > > +                   ret = PTR_ERR(other_ns);
> > > +                   break;
> > > +           }
> > > +
> > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
> > > +                   ret = -EPERM;
> > > +                   goto out_err;
> > > +           }
> > > +
> > > +           /* check that the socket has never been connected or recently disconnected */
> > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
> > > +                   ret = -EOPNOTSUPP;
> > > +                   goto out_err;
> > > +           }
> > > +
> > > +           /* check that the socket is not bound to an interface*/
> > > +           if (sk->sk_bound_dev_if != 0) {
> > > +                   ret = -EOPNOTSUPP;
> > > +                   goto out_err;
> > > +           }
> > > +
> > > +           my_ns = sock_net(sk);
> > > +           sock_net_set(sk, other_ns);
> > > +           put_net(my_ns);
> > > +           break;
> >
> >               cpu 0                           cpu 2
> >               ---                             ---
> >                                               ns = sock_net(sk);
> >               my_ns = sock_net(sk);
> >               sock_net_set(sk, other_ns);
> >               put_net(my_ns);
> >                                               ns is invalid ?
>
> That is the reason we want the socket to be in an un-connected state. That
> should help us avoid this situation.

This is not enough....

Another thread might look at sock_net(sk), for example from inet_diag
or tcp timers
(which can be fired even in un-connected state)

Even UDP sockets can receive packets while being un-connected,
and they need to deref the net pointer.

Currently there is no protection about sock_net(sk) being changed on the fly,
and the struct net could disappear and be freed.

There are ~1500 uses of sock_net(sk) in the kernel, I do not think
you/we want to audit all
of them to check what could go wrong...
