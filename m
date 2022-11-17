Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD562E3F3
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbiKQSSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbiKQSSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:18:32 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671F7AE4D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:18:28 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1322d768ba7so3124848fac.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tLa0hKjA9GOfaZoCfXhipYOOpTt3ShAuZvGXM0OsUH4=;
        b=cUWWJ9/H7LmDougtNe1jq+6N61GxqO6ADwcq4fYEHFFP69BzrPVNN3yKre5HzqII3W
         v7EDJXHPQmdo8PzSGGPmhQ/1PZ8vQ0ERMesoMIpSzRg6d0QP6bL1P+EQGVpH5iRpuAhg
         WkPX528/HIVlFMT7JzFWOr1bXBnTKbHJ7ut1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLa0hKjA9GOfaZoCfXhipYOOpTt3ShAuZvGXM0OsUH4=;
        b=eeWCcMpLV4efG3zRHFtxiuuD/ibO0ssnXYCgdg0wOqefLsm/UMF+CleNbqDyyIuDiQ
         4WR7MQC1E6PL5G8fEEZwDOJbhUhZY7zN1PV/jjf7/GZ6iL6/avsC/GuojH18pE3mW8Kc
         VvBDbkfessonE1EqSl1ng9hMEXNt4LgAsU4Y1+RB0bvCscsUUQwR0/Iu9b8A7lG88keW
         VXWa9ItJvzfOADBOYc+MibxNb/LPCNWXlhf/ip5i8XZCj6EmotYROaoEMDN+oKMRo5P4
         iz4CMqEXZaqJAzbGf0LNTG+GSuTHyQF+grzIxZkwq+tXhv3wqcsJ85RpIM8xDXiVaCPO
         d6Vw==
X-Gm-Message-State: ANoB5plqRXCzoOHcBV1Zr8897ln69fqKCW63av7EohAZdpqTSN5XqBgc
        7nA+Uy6Tz8JldRuD/v/A6F9nolS0EzFVoXSfYynSmA==
X-Google-Smtp-Source: AA0mqf6e5Hi2hX35v0tmRvnjU0cXdmkFcXS4bpSFybzqkModBqm4jbFeny5aOqhA88YzBHxkVI8/GrRv5uAWqjsXDzY=
X-Received: by 2002:a05:6870:bacb:b0:13a:dd16:9b83 with SMTP id
 js11-20020a056870bacb00b0013add169b83mr5018049oab.15.1668709104973; Thu, 17
 Nov 2022 10:18:24 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org> <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com> <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
 <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
 <CANn89i+9XRh+p-ZiyY_VKy=EcxEyg+3AdtruMnj=KCgXF7QtoQ@mail.gmail.com>
 <CAEXW_YS-d_URqjfcasNnqf3zhCKAny8dhhLifAxtrpz1XYd_=w@mail.gmail.com> <CANn89i+GcVzgg56fd9iO5Ma6vSUVvJmLHTvRwPMoYKMPR4G4Lw@mail.gmail.com>
In-Reply-To: <CANn89i+GcVzgg56fd9iO5Ma6vSUVvJmLHTvRwPMoYKMPR4G4Lw@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 17 Nov 2022 18:18:14 +0000
Message-ID: <CAEXW_YSyZswszFo-J6rEFsb2mAcXLytZaFSqi1L1LpSHWfTXMQ@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com,
        jiejiang@google.com, Thomas Glexiner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 5:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Nov 17, 2022 at 9:42 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
>
> >
> > Yes, I agree. Your comments here have not been useful (or respectful)
> > so I am Ok with that.
> >
> >  - Joel
>
> Well, I have discovered that some changes went in networking tree
> without network maintainers being involved nor CCed.
>
> What can I say ?
>
> It seems I have no say, right ?

Sorry, I take responsibility for that. FWIW, the rxrpc change is not
yet in Linus's tree.

Also FWIW, the rxrpc case came up because we detected that it does a
scheduler wakeup from the callback. We did both static and dynamic
testing to identify callbacks that do wakeups throughout the kernel
(kernel patch available on request), as the pattern observed is things
doing wakeups typically are for use cases that are not freeing memory
but something blocking, similar to synchronize_rcu(). So it was a
"trivial/obvious" change to make for rxrpc which I might have assumed
did not need much supervision because it just reverts that API to the
old behavior -- still probably no excuse.

Again, we can talk this out no problem. But I would strongly recommend
not calling it "crazy thing", as we did all due diligence for almost a
year (talking about it at LPC, working through various code paths and
bugs, 4 different patch redesigns on the idea (including the opt-in
that you are bringing up), including a late night debugging session to
figure this out etc).

Just to clarify, I know you review/maintain a lot of the networking
code and I really appreciate that (not praising just for the sake).
And I care about the kernel too, just like you.

thanks,

 - Joel


> commit f32846476afbe1f296c41d036219178b3dfb6a9d
> Author: Joel Fernandes (Google) <joel@joelfernandes.org>
> Date:   Sun Oct 16 16:23:04 2022 +0000
>
>     rxrpc: Use call_rcu_flush() instead of call_rcu()
>
>     call_rcu() changes to save power may cause slowness. Use the
>     call_rcu_flush() API instead which reverts to the old behavior.
>
>     We find this via inspection that the RCU callback does a wakeup of a
>     thread. This usually indicates that something is waiting on it. To be
>     safe, let us use call_rcu_flush() here instead.
>
>     Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
>
> diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
> index 22089e37e97f0628f780855f9e219e5c33d4afa1..fdcfb509cc4434b0781b76623532aff9c854ce60
> 100644
> --- a/net/rxrpc/conn_object.c
> +++ b/net/rxrpc/conn_object.c
> @@ -253,7 +253,7 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
>          * must carry a ref on the connection to prevent us getting here whilst
>          * it is queued or running.
>          */
> -       call_rcu(&conn->rcu, rxrpc_destroy_connection);
> +       call_rcu_flush(&conn->rcu, rxrpc_destroy_connection);
>  }
>
>  /*
