Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57678400873
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350656AbhICXv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350650AbhICXvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:51:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0597CC061757
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 16:50:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q3so461629plx.4
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 16:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sI5mw6LIP7RxrUNroMiQOnFceG4QMDVv+KPeJXakV2g=;
        b=AsB6SRHfXoPQz1mRQDJROAiGaSNZZxqu+VSdEbNEEwZ9uyhvEwLWMWWYF0yWsM1JjE
         AkO1JtpCIzWpJpE/LMst40JzH3pH1aPm0zatKbUdVwz5Iq8IrrYcbJJj9TGxA190S8UZ
         /4zl0xNuEAvDws3NH1dpyOIRzPpRjz88q46XAJnq31XZ9nCFrvM7Z7ofZq9JkRlc59OF
         0WJVsEREaA0/GJSH8PMSf7Cixe/uvG6bQNkBqBFWZ0tEYtyOW+KTE+jH8rsRceSA+D70
         9VPelmJJiP2bfXNzowsM+l3RT70wbu/+VCrFAR/Qvev1FYw9vqHPqzqXnVCvmsYmvNBC
         WYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sI5mw6LIP7RxrUNroMiQOnFceG4QMDVv+KPeJXakV2g=;
        b=cNXFywqTWhZuNDM4gpZAyWnSU5/yTn8uOPk70k3d7ltmz+xhW7IxzFF/T+VpjwE5k/
         ZWegF6AH3yFD6UpAzy6iuKftmOUgPbwat9ud8QWXAZsayfOwzlMOz5VRhxRDl1rsp1tI
         Yh3wHFRkNpPzujZg8QAWeWxA6u6UO05iCm9PoLuDtA+7aDvbpv1aHEmBYSpYaftM6H8G
         m/vgkKs4GlZTKiAGTmk1wedxKj9phBsac1ES4KO3qiQSI+pzfsaC0iEIJ7OeO7o2TQbA
         IQP/o8PMdA8WvC5xO1p20ZPvCz7jQ+3RhLAUce+zBkXy4H9vUVnGg1+BvC6yg6FYhtYZ
         GgUQ==
X-Gm-Message-State: AOAM531N2lG7IFI6FQQI1co2RhKFadIt4tB3KdQ4WLRwhlS4d+QtIQCo
        d6XxnquleEcQmiwtMganvT0BNgCe0/ohmsoJxtw=
X-Google-Smtp-Source: ABdhPJw/vEDtBeDDgHQKDs69LExGj7Wc2x8sDveI1VuaETejMr9M8FUofVYUOrgbE72K/Zxs4z7gzB4eVtVkFeyJFW8=
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr1387182pjr.66.1630713054493;
 Fri, 03 Sep 2021 16:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
 <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com>
 <YS38YB9JTSHeYgJG@dcaratti.users.ipa.redhat.com> <CAM_iQpUnR-DvMBSWnagCJg98JMT_nMWNbQ8Ea0kC4yCBcFFRqA@mail.gmail.com>
 <YS/oZ+f0Nr8eQkzH@dcaratti.users.ipa.redhat.com>
In-Reply-To: <YS/oZ+f0Nr8eQkzH@dcaratti.users.ipa.redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 3 Sep 2021 16:50:43 -0700
Message-ID: <CAM_iQpWRZCS0=v7xGP_ce4RtCt0RwZDTjK1=6AueT_jLOJSYwg@mail.gmail.com>
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict'
 to 'quantum'
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 1:54 PM Davide Caratti <dcaratti@redhat.com> wrote:
> uh, maybe I get the point.
>
> we can do a INIT_LIST_HEAD(&cl[i].alist) in ets_qdisc_init() with 'i' ranging
> from 0 to TCQ_ETS_MAX_BANDS - 1, then the memset() in [1] needs to be
> replaced with something that clears all members of struct ets_class except
> 'alist'. At this point, the INIT_LIST_HEAD() line in ets_qdisc_change() can be
> removed.
>
> I can re-run the kseltest and eventually send a patch for that (targeting
> net-next, no need to rush), is that ok for you?

Sure, whatever works for you.

Thanks.
