Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065E2560C41
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 00:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiF2W0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 18:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiF2W0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 18:26:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3FA3633A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 15:26:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l68so5164330wml.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84p0yb2pKb0/mlqhXXfPPXMLX3/ZN9/6y/XnIJNI1Kk=;
        b=WL71/59quyzcZwTzbjYVhH5ZnVQDEcpcw7ItbNXzShOn/THC8wO8YUbOkC7/+RvKqd
         zMa5eIP2AL9aRJ3CusxegyqJsSWM3Fiozd6GhJ+TIVqrZ1/KgTOr40oXmXWk5S//q3F5
         SPD7nYA6UFrb21/NRTIo2qzZLFKxMzObtdh+i0yZFtLfL+6sEyr1lUg8oO/v3A7I9R1z
         C4cJw/pN62tDh0RAGG8ffrNbX3Cj65jivvw1FmR4fnNJLQ9bWT5XdC6Pu41X7gchdIHm
         i3dyaRwk7+WAbRd9JFWNp5aBUIVaYeNhepc5GmF6MHnFvMVhnoStcXWLumeijLd1FCVQ
         8Thg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84p0yb2pKb0/mlqhXXfPPXMLX3/ZN9/6y/XnIJNI1Kk=;
        b=u9lJZLLK7XH+3kWXx1/TzoCyr4GGwBlrqD3f+Uapkm0c/zYi8AnsPEjdWNmhew54qQ
         t4MwxHaZsPessXJ2+vY9Fj9GaQXztHh/NZte2SFUMO/jWpRdqadQIXJJg+/LiRngsYFn
         lgCQ6moayfUplFyK7N7HmC15udNCg0HbWDDdKAdGKYQyPqco2z0sYxwb4/wPeLLaSpcX
         roDl4VJ7yymKE3wqAZElGTLon7yR9I/rIDlqOOhvkdIuNckcwRUDvNF1iH4I4t5P4oKA
         Tbc5rfxGHsbkyWHSMwp6eiWehSNVyf2qp8EHxwPjbTiRxV0RmGOL5CeJQHvOArDZb4mM
         IViA==
X-Gm-Message-State: AJIora/ZZ7cOg+Z8urz6vhZxmzmtkfCtZ6cIeOCdLSy+c7x/IwFeG8/I
        4bOOfjRJB0906BhL/cRgIN6Leyb96RWOsk6bqEQkaQ==
X-Google-Smtp-Source: AGRyM1saKg+ielDtcLXxEB9pzGSzqFetxgZ4MJ0R9lsQ+QWXrQFJ1PPbu1xcp3shfOz8BNqDcnkw910kPR5ed0tYdAs=
X-Received: by 2002:a05:600c:4081:b0:3a0:47c4:8dd0 with SMTP id
 k1-20020a05600c408100b003a047c48dd0mr5951181wmh.178.1656541604449; Wed, 29
 Jun 2022 15:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150102.1582425-2-hch@lst.de> <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de> <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de> <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de> <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com> <Yryic4YG9X2/DJiX@google.com> <Yry6XvOGge2xKx/n@zx2c4.com>
In-Reply-To: <Yry6XvOGge2xKx/n@zx2c4.com>
From:   Kalesh Singh <kaleshsingh@google.com>
Date:   Wed, 29 Jun 2022 15:26:33 -0700
Message-ID: <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
Subject: Re: [PATCH] remove CONFIG_ANDROID
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        John Stultz <jstultz@google.com>,
        Saravana Kannan <saravanak@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 1:47 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Kalesh,
>
> On Wed, Jun 29, 2022 at 12:05:23PM -0700, Kalesh Singh wrote:
> > Thanks for raising this.
> >
> > Android no longer uses PM_AUTOSLEEP, is correct. libsuspend is
> > also now deprecated. Android autosuspend is initiatiated from the
> > userspace system suspend service [1].
> >
> > A runtime config sounds more reasonable since in the !PM_AUTOSLEEP
> > case, it is userspace which decides the suspend policy.
> >
> > [1] https://cs.android.com/android/platform/superproject/+/bf3906ecb33c98ff8edd96c852b884dbccb73295:system/hardware/interfaces/suspend/1.0/default/SystemSuspend.cpp;l=265
>
> Bingo, thanks for the pointer. So looking at this, I'm trying to tease
> out some heuristic that wouldn't require any changes, but I don't really
> see anything _too_ perfect. One fragment of an idea would be that the
> kernel treats things in autosuspending mode if anybody is holding open a
> fd to /sys/power/state. But I worry this would interact with
> non-autosuspending userspaces that also hold open the file. So barring
> that, I'm not quite sure.
>
> If you also can't think of something, maybe we should talk about adding
> something that requires code changes. In that line of thinking, how
> would you feel about opening /sys/power/userspace_autosuspender and
> keeping that fd open. Then the kernel API would have
> `bool pm_has_userspace_autosuspender(void)` that code could check.
> Alternatively, if you don't want refcounting fd semantics for that, just
> writing a "1" into a similar file seems fine?
>
> Any strong opinions about it? Personally it doesn't make much of a
> difference to me. The important thing is just that it'd be something
> you're willing to implement in that SystemSuspend.cpp file.

Hi Jason,

Thanks for taking a look. I'm concerned holding the sys/power/state
open would have unintentional side effects. Adding the
/sys/power/userspace_autosuspender seems more appropriate. We don't
have a use case for the refcounting, so would prefer the simpler
writing '0' / '1' to toggle semantics.

Thanks,
Kalesh

>
> Jason
