Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C091DF166
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgEVVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731036AbgEVVov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:44:51 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4062C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:44:49 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id j8so1012607ybj.12
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LkoycmjrUjG2eO8rPIf12+CxPcEEHL8Q13A65ENbvJs=;
        b=D9d6Rut8DjateF5fc2935suHYZRVbGkh9dYYwgSLIfIJpAKK/OwAM+66KuzOhqgAbm
         ve69I8YqGiNXxoFDM5cbT6ptsRJdxOTg9Pfe10AiPs5L3rjiwbXL3siGTOAjzIAMkfn0
         2tbvlnI+zJivmyNUUy/1tLXeETDsqpZ5lz0OPY3DJIWN8STlQ0ncK13SMldWye9G8m3+
         a9NSkPlNVFGxAD3OZtCvS/giO0lgv+YuMJRS1eskqPN8iH75Oj+qDZQCs+wMBuxuV19I
         pewR0x6lRf4nyKT4vPtaNQrf+ZNzra3dI6R6CsJVRCFnvZdNLKgdGt94+IdFeah3PiIM
         tp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LkoycmjrUjG2eO8rPIf12+CxPcEEHL8Q13A65ENbvJs=;
        b=T87xwjOXHEtZKjl/teSBvp5r9sxoKag00cI55kPMPYL6oT9EwcHxPWIeWE55YVwrFv
         u5SInbqOnVxQ7BjWp/u9a9B7fOF8zSGKJNTjHPQ7PNwbSKwcPGjzPD50ZyvvmSiVNs0d
         8o3aNVehCH26I2No3RKDCQaJH+vhAon/h+MGQgtGauPImNSn3LXKzUhSdbA6BP+P91JR
         tZNviwZWYlb16L4cXASiTt5YWYla1gl2xWkq2PINYOVUnPZp0XEd6zGZ02SN/mwGjjFS
         1XuKHVUPzqsGhKlDyvfSVYK7tlpGTUnH/Etne1lze8KT+H0CQjDhPOFai2KALf/No4WC
         +Wdw==
X-Gm-Message-State: AOAM5328AY/W/p21CAYPCqnaHdRT8EMFrh+c5DWsFJWHY1Czt3hPiT4Y
        Gha45O3TStoVlRAvdy8PcJzcemdbwy7OX3oJN0UFiA==
X-Google-Smtp-Source: ABdhPJw2VbkTj7xeMVWys92l/99Hyh+Ciov8Ua02SQWZ8T0401HW0D5XTdz0qh+mMxLW9nZ+DiKcafIe8Ufo6vaLwBc=
X-Received: by 2002:a25:1484:: with SMTP id 126mr25642394ybu.380.1590183888932;
 Fri, 22 May 2020 14:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200521182958.163436-1-edumazet@google.com> <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
 <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com> <217375c0-d49d-63b1-0628-9aaf7e4e42d0@gmail.com>
 <bebc5293-d5be-39b5-8ee4-871dd3aa7240@redhat.com> <2084be57-be94-6630-5623-2bd7bd7b7da2@gmail.com>
 <400644e2-7dac-103c-a07a-88287b1905d5@redhat.com>
In-Reply-To: <400644e2-7dac-103c-a07a-88287b1905d5@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 May 2020 14:44:37 -0700
Message-ID: <CANn89iL+gT7PSwuWhhWf8o7f1SgbqJ5+mdJ_bfBxOMbzjo_oMA@mail.gmail.com>
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Jon Maloy <jmaloy@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 2:37 PM Jon Maloy <jmaloy@redhat.com> wrote:
>
>
>
> On 5/22/20 4:10 PM, Eric Dumazet wrote:
> >
> > On 5/22/20 12:47 PM, Jon Maloy wrote:
> >>
> >> On 5/22/20 11:57 AM, Eric Dumazet wrote:
> >>> On 5/22/20 8:01 AM, Jon Maloy wrote:
> >>>> On 5/22/20 2:18 AM, Xin Long wrote:
> >>>>> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
> >>>>>> Resend to the list in non HTML form
> >>>>>>
> >>>>>>
> >>>>>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
> >>>>>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>>>>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
> >>>>>>>>> dst_cache_get() documents it must be used with BH disabled.
> >>>>>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
> >>>>>>>> preempt_disable().
> >>>>>>> rcu_read_lock() does not disable BH, never.
> >>>>>>>
> >>>>>>> And rcu_read_lock() does not necessarily disable preemption.
> >>>>> Then I need to think again if it's really worth using dst_cache here.
> >>>>>
> >>>>> Also add tipc-discussion and Jon to CC list.
> >>>> The suggested solution will affect all bearers, not only UDP, so it is not a good.
> >>>> Is there anything preventing us from disabling preemtion inside the scope of the rcu lock?
> >>>>
> >>>> ///jon
> >>>>
> >>> BH is disabled any way few nano seconds later, disabling it a bit earlier wont make any difference.
> >> The point is that if we only disable inside tipc_udp_xmit() (the function pointer call) the change will only affect the UDP bearer, where dst_cache is used.
> >> The corresponding calls for the Ethernet and Infiniband bearers don't use dst_cache, and don't need this disabling. So it does makes a difference.
> >>
> > I honestly do not understand your concern, this makes no sense to me.
> >
> > I have disabled BH _right_ before the dst_cache_get(cache) call, so has no effect if the dst_cache is not used, this should be obvious.
> Forget my comment. I thought we were discussing to Tetsuo Handa's
> original patch, and missed that you had posted your own.
> I have no problems with this one.
>

Ah, this now makes sense, I was not aware of Tetsuo patch.

You are absolutely right, Tetsuo Handa's patch is wrong.

Thanks
