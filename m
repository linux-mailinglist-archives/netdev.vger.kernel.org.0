Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF32DA0C5
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502553AbgLNTqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbgLNTqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:46:35 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F0FC0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 11:45:55 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id w127so16611683ybw.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 11:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ohZ5uZJUXYBrNuNkF0ucCV7B6UG0W6HKxpHvPN6AWuY=;
        b=DDr4BZNKxb7w2+7bBLcdwL2CFvUIivzoE9clMPw+Mi095CyXH6X3c2w6k3+CALxanb
         dEQrrwaNcJLQRUu8ATEEHzzbEQtkxDoCGzQ2moDyyuuWIzgmOorB7dlAX2yLT5vU5P4P
         1fF4tJuSMUcmhYSb4Iey3UmcxyhT8HohHxuQU4laaMYwqXnKk+vaSuh/+UulroVgZMKi
         8CX98vrYRRxJM2z327sFKdBEO8IPPhx30F5S2rydj4/lArdbG9oHvyvLyRoIifRtLWSD
         GqNNe1AJD23FG5KnxDvg2zVdd3Cp7QON20WQc9AxBs/EfwMZb4GoA6FJVsYmQBo66dQ5
         7kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ohZ5uZJUXYBrNuNkF0ucCV7B6UG0W6HKxpHvPN6AWuY=;
        b=WEfPITlgBxmkPSKsq+U2w22g1byh+ubmuBpKUeoC2ntVnhG9meOPmBbcgXXR/bSVf4
         7O0Krdpq2awPipHOboKFpQxhDTMfV7s5tXUkSLaH08Mk5BUVqbc0grvwUXRO9qI64d3q
         WfTIiW5mzCO+9SGbwQXHJycJ7EhA7DUS88USrtk2l+arlxRy/1DcIN3UNusFqNziufUF
         7Qut3xvAYyHF01Ds0rwBq1o/pHkJI0L5ZNaN3+zbXJKrdoYfFRKPPg2kNZwFECLzM9tT
         RDxiBLhXnZX+UZfH7EAYuBu5+iF+QavduIL0VE3prK8IomrWywJYkIr2DxsPnfbQU8pn
         3dpQ==
X-Gm-Message-State: AOAM530OfVJybkHlcZY8trWp7X4fQGqu07fbKtCTs2mutIU0XPDPSM1V
        99vmUK0CUIOr+RyAaqRw1jWKQzqEI2pQobfkCbpT4w==
X-Google-Smtp-Source: ABdhPJyH9bWcGnotoLF2c3+6PSAF6izqXFPSHKB3nrk45vQ9DOxW+8fFT9LWqoud8YqKqBLKnZEo3juTz/Jp1K66pxQ=
X-Received: by 2002:a25:ce47:: with SMTP id x68mr37773361ybe.139.1607975154185;
 Mon, 14 Dec 2020 11:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com> <20201209005444.1949356-3-weiwan@google.com>
 <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com> <20201214110203.7a1e8729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214110203.7a1e8729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 14 Dec 2020 11:45:43 -0800
Message-ID: <CAEA6p_CqD5kfPxXkMrNNh9TozfCCTdovMgjiS2Abf_KXxAJONA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Dec 2020 09:59:21 -0800 Wei Wang wrote:
> > On Sat, Dec 12, 2020 at 2:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Sat, 12 Dec 2020 14:50:22 -0800 Jakub Kicinski wrote:
> > > > > @@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
> > > > >             msleep(1);
> > > > >
> > > > >     hrtimer_cancel(&n->timer);
> > > > > +   napi_kthread_stop(n);
> > > >
> > > > I'm surprised that we stop the thread on napi_disable() but there is no
> > > > start/create in napi_enable(). NAPIs can (and do get) disabled and
> > > > enabled again. But that'd make your code crash with many popular
> > > > drivers if you tried to change rings with threaded napi enabled so I
> > > > feel like I must be missing something..
> > >
> > > Ah, not crash, 'cause the flag gets cleared. Is it intentional that any
> > > changes that disable NAPIs cause us to go back to non-threaded NAPI?
> > > I think I had the "threaded" setting stored in struct netdevice in my
> > > patches, is there a reason not to do that?
> >
> > Thanks for the comments!
> >
> > The reason that I did not record it in dev is: there is a slight
> > chance that during creation of the kthreads, failures occur and we
> > flip back all NAPIs to use non-threaded mode. I am not sure the
> > recorded value in dev should be what user desires, or what the actual
> > situation is. Same as after the driver does a
> > napi_disabe()/napi_enable(). It might occur that the dev->threaded =
> > true, but the operation to re-create the kthreads fail and we flip
> > back to non-thread mode. This seems to get things more complicated.
> > What I expect is the user only enables the threaded mode after the
> > device is up and alive, with all NAPIs attached to dev, and enabled.
> > And user has to check the sysfs to make sure that the operation
> > succeeds.
> > And any operation that brings down the device, will flip this back to
> > default, which is non-threaded mode.
>
> It is quite an annoying problem to address, given all relevant NAPI
> helpers seem to return void :/ But we're pushing the problem onto the
> user just because of internal API structure.
>
> This reminds me of PTP / timestamping issues some NICs had once upon
> a time. The timing application enables HW time stamping, then later some
> other application / orchestration changes a seemingly unrelated config,
> and since NIC has to reset itself it looses the timestamping config.
> Now the time app stops getting HW time stamps, but those are best
> effort anyway, so it just assumes the NIC couldn't stamp given frame
> (for every frame), not that config got completely broken. The system
> keeps running with suboptimal time for months.
>
> What does the deployment you're expecting to see looks like? What
> entity controls enabling the threaded mode on a system? Application?
> Orchestration? What's the flow?
>
I see your point. In our deployment, we have a system daemon which is
responsible for setting up all the system tunings after the host boots
up (before application starts to run). If certain operation fails, it
prints out error msg, and will exit with error. For applications that
require threaded mode, I think a check to the sysfs entry to make sure
it is enabled is necessary at the startup phase.


> "Forgetting" config based on driver-dependent events feels very fragile.
I think we could add a recorded value in dev to represent the user
setting, and try to enable threaded mode after napi_disable/enable.
But I think user/application still has to check the sysfs entry value
to make sure if it is enabled successfully.
