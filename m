Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A333DF736
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 00:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhHCWEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 18:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhHCWEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 18:04:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DEBC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 15:04:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nh14so153798pjb.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 15:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggnDE40oA0h2/cA2reKHlypvOeV8FnIoF6TIRY2rDnM=;
        b=cZdIlUlinznvCAsUOfTq+uecNUHwKPeCPsj5gwhs/SIMWUpl4uvDOQtXemM/kza0Kk
         RkBOpBEOTAfTwQRm7nEsC9rQY52hZ6FiWl4lzaWR121POUPEaamteeaF6iOKpBedwCXk
         7h5te7Q2Jsgq0jM8efYZcEiKoG4TlxXThogIVreNAu5LkTijGzhpw/LOIARRRGrkpJ3+
         UZySwJgBOEZ4dZq8wLitUMAnWoKQXH0Q4VQhPGxeCaxWu2HrOTuyWPoJ++42tafADG8z
         M2nd57OBIJ70jhP/87rc18jzimTTv45bPwJ1HewCIG/BMZ0ny57Eh5sJbWZXGf2nWSo5
         w4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggnDE40oA0h2/cA2reKHlypvOeV8FnIoF6TIRY2rDnM=;
        b=UQTctC5lGo3bqx0I0G3/mgWKrSbAs8T9karAsGlWmL+fbixWdSnL7kL15/1gDHJ0n9
         HPxgBfssv07b/0hdPBiJrCdSQBvSJLf5tCjow1quJuAB4Zhy1V5CqsWAUkACj5rMvi5y
         0ThfKY3NPg53hSCo+5fd/tYVlIMsfaKvqUKpndeFuiBX8oRhFVn6qzkE41L7TG0KBtye
         lfcg8zYcxzJ6dSklXdK6T4PsiWRpEmN58OwYSbb0S6CLD42rytldkjQCBKqVUvBvdSDh
         wjM9KhRU+5uwIl5+rkPoMQgIN+SQOH1l8RE/79aOVv5hF9bQ+DMuvQhWcVDtgSiEeZEX
         wSEQ==
X-Gm-Message-State: AOAM531XQlPJzlLHgATgueGmiXachPKkwBq6g0556kezyXM8i1YS+dd9
        6vViWJxG75WROAMv05oep0SVzuPyugEMDpnqGjE=
X-Google-Smtp-Source: ABdhPJzH1U2ZpqIDeVVEtS9Q5SbSg0H14VKOCtjC5dK0Y0sOHbRhDj+m2rm43ad7btDcJ9sinR+jiOCVVVMbYllIdGA=
X-Received: by 2002:a17:90a:bd8e:: with SMTP id z14mr24888253pjr.231.1628028277557;
 Tue, 03 Aug 2021 15:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210803123921.2374485-1-kuba@kernel.org> <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
 <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com> <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 3 Aug 2021 15:04:26 -0700
Message-ID: <CAM_iQpVcSyBTwduASCqp6tkkJrfXYsTJzCxuidvKraoym4-_vA@mail.gmail.com>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 2:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 3 Aug 2021 14:32:19 -0700 Cong Wang wrote:
> > On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 3 Aug 2021 10:11:13 -0700 Cong Wang wrote:
> > > > On Tue, Aug 3, 2021 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > Since when netdevsim is *only* for upstream tests?
> > >
> > > Since it was created.
> >
> > Why it was created only for upstream? IOW, what's wrong with
> > using it only for non-upstream tests?
> >
> > BTW, we also use dummy device for testing, it is not only for
> > upstream. It is extremely odd to single netdevsim out. I don't
> > see any special reason here.
>
> From my own experience companies which are serious about their
> engineering have a lot of code dedicated to testing. I don't think
> we can deal with all such code upstream.
>
> At the same time I want to incentivize upstreaming all of the tests
> which are widely applicable (i.e. not HW-specific).

So, nothing special for netdevsim? This seems applicable to all code,
not just netdevsim code.

>
> Last but not least test harnesses are really weird from functional, code
> lifetime and refactoring perspective. netdevsim is not expected to keep
> uAPI as long as in-tree tests do no break/are updated as well.

Sure. Our test is not any special, sch_mq is in upstream, only sch_mq
tests are not yet. Peilin will send out sch_mq tests very soon.

>
> > > > Even if so, where is this documented? And why not just point it
> > > > out when reviewing it instead of silently waiting for weeks?
> > >
> > > I was AFK for the last two weeks.
> >
> > How about documenting it in netdev-FAQ (or literally any doc)?
> > This would save everyone's time.
>
> Fair, I'll send a patch.

Great! Really appreciate it.

>
> > > > It is clearly not dead. We internally used it for testing sch_mq,
> > > > this is clearly stated in the git log.
> > >
> > > Please contribute those tests upstream or keep any test harness
> > > they require where such test are, out of tree.
> >
> > Peilin will add tc-testing for sch_mq which requires this netdevsim
> > feature.
> >
> > >
> > > > How did you draw such a conclusion without talking to authors?
> > >
> > > There is no upstream test using this code, and I did CC you, didn't I?
> >
> > There are downstream tests, which are mentioned in changelog.
> >
> > I am pretty sure upstream tests only cover part of the whole networking
> > code, if you really want to apply the rule, a lot of code are already dead.
> > Once again, I don't see any reason why you only treat netdevsim differently.
> > ;)
>
> I hope the first part of this response scheds some light.
>
> > > > But this does remind me of using netdevsim for tc-testing.
> > >
> > > Please bring the code back as part of the series adding upstream tests.
> >
> > Please remove all those not covered by upstream tests just to be fair??
>
> I'd love to remove all test harnesses upstream which are not used by
> upstream tests, sure :)

Many net/*/ code can be gone. Maybe start with net/netrom/? ;)

Thanks.
