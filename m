Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63AF3DF6EB
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhHCVco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbhHCVcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:32:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCDC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 14:32:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so645109pji.5
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 14:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BTtZvpxttvQViWgOaO7ZmD0F1yQql2Bk1h/lcyE75K8=;
        b=sv0fdiGQDIXY7gNuQ/PZhz30slGWriDzqHLyS3hG7wj5cVTT9HnmhoPuFmpocFNNra
         T2knDj7II7K/sJTBv58qwOjEVkuYW4bh75SqTwgIv1zIfBumXndIFaS6vOcUiw4CeLEG
         4nvLYFfHRnSnQAjWojuN3bePmFeOVS/6SsdJ8UXGZd/cADo8YUA2yRcp3EeaTm/+ijTG
         XLMlFtpNnqxzXmSNcm6A+l0cZKaGmhfC3BByFIfXu96aHtWV0dWqUngg85mp5RdzkUmp
         b4XkveriTsTZrazns6PzHkCwuqM2Mk9K7lkTQwgQxDIrX2vDAE4urIPPt+cl3oyoINln
         1dOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BTtZvpxttvQViWgOaO7ZmD0F1yQql2Bk1h/lcyE75K8=;
        b=qeAPGUaH56dxvx9Oa4zfjQP98QQKDxWL8PMTNXO79l/hz1uUAWs408A4k7mnr3bFfC
         ioukeH/8wIGLaZ3u1lOx/CZpfqKvE1jKOAc0TFs2x7EsZgngWlhRBj434wkK34ppC/Xd
         ShP7glEUvPt+1ps+cuTAHM2FdHnvbiztNmKNhHhJ7ygBKNtQx9TxJ/kav2BDusEa/1z/
         fG+lhoSt5MO8YfZ7f8sahS3llAJI2qDsxXkKHzM229iJaJC9HnOrXv9XnYGiDrof8MGP
         CFpNub8Z8ucU5CXLqLVQu/UeqcNsvXiZI8rtkCSNE4ulQPSf4ErHyCcUkgRFsEhZ+/il
         Hpzw==
X-Gm-Message-State: AOAM530bbhM6ds8t3nguz+gfQ+u9p/2XdrPTy4btZLDtcuNdDsMq9X/d
        Wpl1MAwTrplHKy4T6tKBXVhZ9oVjIdiI+ek63zs=
X-Google-Smtp-Source: ABdhPJw50xQEJ1wWupq5b76mxISzHf6PNXjja5aWI/8IJZIjlen3N4dEyZnGwatnga26Pfg2Ss6QPrSsi90XH/xgTuk=
X-Received: by 2002:a65:4384:: with SMTP id m4mr408289pgp.428.1628026350459;
 Tue, 03 Aug 2021 14:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210803123921.2374485-1-kuba@kernel.org> <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
 <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 3 Aug 2021 14:32:19 -0700
Message-ID: <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
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

On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 3 Aug 2021 10:11:13 -0700 Cong Wang wrote:
> > On Tue, Aug 3, 2021 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > This reverts commit d4861fc6be581561d6964700110a4dede54da6a6.
> > >
> > > netdevsim is for enabling upstream tests, two weeks in
> > > and there's no sign of upstream test using the "mutli-queue"
> > > option.
> >
> > Since when netdevsim is *only* for upstream tests?
>
> Since it was created.

Why it was created only for upstream? IOW, what's wrong with
using it only for non-upstream tests?

BTW, we also use dummy device for testing, it is not only for
upstream. It is extremely odd to single netdevsim out. I don't
see any special reason here.

>
> > Even if so, where is this documented? And why not just point it
> > out when reviewing it instead of silently waiting for weeks?
>
> I was AFK for the last two weeks.

How about documenting it in netdev-FAQ (or literally any doc)?
This would save everyone's time.

>
> > > We can add this option back when such test materializes.
> > > Right now it's dead code.
> >
> > It is clearly not dead. We internally used it for testing sch_mq,
> > this is clearly stated in the git log.
>
> Please contribute those tests upstream or keep any test harness
> they require where such test are, out of tree.

Peilin will add tc-testing for sch_mq which requires this netdevsim
feature.

>
> > How did you draw such a conclusion without talking to authors?
>
> There is no upstream test using this code, and I did CC you, didn't I?

There are downstream tests, which are mentioned in changelog.

I am pretty sure upstream tests only cover part of the whole networking
code, if you really want to apply the rule, a lot of code are already dead.
Once again, I don't see any reason why you only treat netdevsim differently.
;)

>
> > But this does remind me of using netdevsim for tc-testing.
>
> Please bring the code back as part of the series adding upstream tests.

Please remove all those not covered by upstream tests just to be fair??

Thank you!
