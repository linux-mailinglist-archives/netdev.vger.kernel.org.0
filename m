Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4A58FA3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 03:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF1BYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 21:24:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42622 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfF1BYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 21:24:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id k13so1806796pgq.9
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 18:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mj07bMa9XpdNovLagGSoAVyNpo1n+jxPLSHKUcSh4kg=;
        b=JX90ZJJ1NBY2KAnlqTJxDFQZRKc5mMDgFXUeyZna8/orD5KUqTS/zymo4JF/AP+YTs
         nf0DBjnJXUH1OAS5JzFAcFVVyXzOzJfFmNRkC1A3PNm05oWuWTYzlW7vLGbfu1ZGdsvr
         WXBdgOTAaSrv2Ow/Rmeg6xZ1mDV8jXcOTEQ7iwnUwg7VPpdhtaL0WXfDqwF0MWYy9iSM
         le2BEu9cC3ilNjfWlENaQnTka37KnuX5EuET24nDfigoTF0cP0SdRJe2xHSy/LBrQjJl
         dQugZyUpf++D4OJ73z0AU4DO+oDkbbR3l6kzQrYeh1vrPuMJHCBqFCrPhYFNJzDYZYb5
         YxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mj07bMa9XpdNovLagGSoAVyNpo1n+jxPLSHKUcSh4kg=;
        b=oA+yvD27Uru7rfCVK7icTw9KBj7RYclz4Ceato+XIFcXbdFS7ZLYeF5yb5c9iQdCzu
         Y3G+uwckT8wEsgFj7YuBq8xzmnoZerxYNWcN81U6Ek5q57Ed0CvTE2m+rvCWYt+jTW/0
         FehvfLmUx3spc3V2h3UTbytOfjniSX3axgh/KdmFJkfOhUK4AuE54me7PcXs+DC40h3d
         8riK4CQsoMl6CNtsikQF2hg7eVTPL6U2O/d6CjEK5EKNEyqHZGym2Ci+aP/V7XaT9xtN
         KNZTugZ2jdY9HF2Rjk9yeRpM+iu4h1rjDG0ayycYZljroe818+fqzM5hM0cRT+rJwko0
         +nqg==
X-Gm-Message-State: APjAAAXmKXCC8wyglGr99UdX5lGor/hVudz8yadaA8dC2kSo/e+l2+Yx
        of6+0RAYj/xkkGgIJHZa2ub+AMkndFQL438EV0a/FbCW
X-Google-Smtp-Source: APXvYqxdju5rCDJ8YNmK9i7mFAbNnEikHwnwNS9Y9br9XYWYR2g4golFKNX7OwQVjMc/VK+E7UfB+no3gnDo2RWiQvc=
X-Received: by 2002:a65:6204:: with SMTP id d4mr6639538pgv.104.1561685060477;
 Thu, 27 Jun 2019 18:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
 <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
 <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
 <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
 <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
 <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com>
 <CAM_iQpXj1A05FdbD93iWQp9Tcd6aW0BQ3_xFx8bNEbqA00RGAg@mail.gmail.com>
 <CAM_iQpV8Euk=NT4M7R5mAoS6_zU7aWBLRtkKEMatCxLAyaxSjQ@mail.gmail.com> <94260c8898834cfa8e5421933a2b5ea59680b970.camel@redhat.com>
In-Reply-To: <94260c8898834cfa8e5421933a2b5ea59680b970.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 27 Jun 2019 18:24:08 -0700
Message-ID: <CAM_iQpXQ1zsjuKdzAZZcjjy_NP9f_T=+-EMrg03KoTMWprvvsw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 3:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Wed, 2019-06-26 at 14:15 -0700, Cong Wang wrote:
> > Hi, Davide
> >
> > On Tue, Jun 25, 2019 at 12:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > It should handle this overflow case more gracefully, I hope.
> > >
> >
> > Please try this attached one and let me know if it works.
> > Hope I get it right this time.
> >
> > Thanks!
>
> hello Cong, and thanks a lot for the patch!
> I see it uses
>
>     (tmp <= id)
>
> as the condition to detect the overflow, and at each iteration it does
>
>     tmp = id, ++id
>
> so that 'tmp' contains the last IDR found in the tree and 'id' is the next
> tentative value to be searched for. When 'id' overflows, (tmp <= id)
> becomes false, and the 'for' loop exits.

Yes, thanks for testing it with tc actions.


> I tested it successfully with TC actions having the highest possible
> index: 'tc actions show' doesn't loop anymore. But with cls_flower (that
> uses idr_for_each_entry_continue_ul() ) I still see the infinite loop:
> even when idr_for_each_entry_continue_ul() is used, fl_get_next_filter()
> never returns NULL, because
>
>     (tmp <= id) && (((entry) = idr_get_next_ul(idr, &(id))) != NULL)
>
> calls idr_get_next_ul(idr, &(id)) at least once. So, even if
> idr_for_each_entry_continue_ul() detected the overflow of 'id' after the
> first iteration, and bailouts the for loop, fl_get_next_filter()
> repeatedly returns a pointer to the idr slot with index equal to
> 0xffffffff. Because of that, the while() loop in fl_walk() keeps dumping
> the same rule.


Good catch, it is actually the arg->cookie++ which causes the trouble
here.


> In my original patch I found easier to check for the overflow of
> arg->cookie in fl_walk(), before the self-increment, so I was sure that
>
>     arg->fn(tp, f, arg)
>
> was already called once when 'f' was the slot having the highest possible
> IDR. Now, I didn't check it, but I guess
>
>     refcount_inc_not_zero(&f->refcnt))
>
> in fl_get_next_filter() is always true during my test, so the inner
> while() loop is not endless, even when the idr has a slot with id equal to
> ULONG_MAX. Probably, to stay on the safe side, cls_flower needs both tests
> to be in place, what do you think?

I think we can just fold the nested loops into one for cls_flower and remove
the arg->cookie++.

What's more, arg->cookie could overflow too,seems we have to switch back to
arg->skip. I am not sure, if this is really a problem we can fix it separately.

Thanks.
