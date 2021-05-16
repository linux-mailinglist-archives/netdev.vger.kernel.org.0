Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A88381F23
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 15:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhEPNsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 09:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhEPNsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 09:48:50 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62103C061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 06:47:35 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so3374039otc.6
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 06:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1arTEe5aKd/oR0jJDOaxKM8WKXOl+5bRER2IyZbGro=;
        b=BjHP5zZqaICHFYqQvS5gLnkHd+qSiQT/CiZ6k++dq40iBSScw2eje/FKCJaRSqvdx3
         odnU0unPL/DLsOVBt5I0ZoxiDhut5jqm7NyGXWpMlbR4jQj9OJ+GBc3FjeiQrr1oap3u
         lVhIx4RJ3iYDRnen92EjX1YbG+FMAXLnSjmDsqtodwAdGEl0zEtzFQmyLDFeWZJ+RhmB
         Uo8smLpRG0FaEQWMdAbBtphTwb9UOhepDDjY4mEkF1GxGmfGMOtwYBzio7IJrpCc0uNr
         6tnd99VNt/jMfohcRouWb154kQ3TUTr21JLunmyQGrBczk+OuzYyan/mgenrJ6LE/bI4
         a4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1arTEe5aKd/oR0jJDOaxKM8WKXOl+5bRER2IyZbGro=;
        b=pBOUhCTHaWHvVrmqcQDhFItx6k2BwXL1QpGTHk7xzTW/75qwpdkcVKmCuQCJjXTyGY
         sHM/UzYyO3JwMchSmYu7rCHdl++/09f7cSmahAoSAGUz/62jtFcAinjMEm26BGebHUvX
         dlRmNkz3xN+JFlZa0vVJdhdwWAcMODLeCp61MWFN+iJps0JCenWHSE8KhJlcKFPcU5jD
         b2V+uNUkfeXg6wyL8qrWgE+M9VYqJz8u7MFJcr9+MzUmWjNgBAJf0elYXIFd3ffl60Gb
         7Iz+AKB/hzJ2y6O1FUdWUD99jw15feS2u1AfjO7AQiJ8dS4g8em87+SI79v9DH77MijU
         7kGA==
X-Gm-Message-State: AOAM530lnT+DxpsJ9GyAyLYPtkWQbKaXiOUzlqlVyKlajEXtDXRYhSKZ
        kWSn1OEAgVN1tBX7yU4r9kPVDoAyVPrJ3zMURaE=
X-Google-Smtp-Source: ABdhPJxiP75U7KHXQUu7ObYnV8qqQUgAfD0jKRPdeH6TTGubjcrJ3VMKRBrfB/Qn/luiQVf/rYuol3+0uVMhCoMuCfc=
X-Received: by 2002:a9d:4e88:: with SMTP id v8mr24232166otk.110.1621172854645;
 Sun, 16 May 2021 06:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210512212956.4727-1-ryazanov.s.a@gmail.com> <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
 <CAHNKnsSM6dcMDnOOEo5zs6wdzdA1S43pMpB+rkKpuuBrBxj3pg@mail.gmail.com> <YKD8f7wP2EzUU7PX@unreal>
In-Reply-To: <YKD8f7wP2EzUU7PX@unreal>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 16 May 2021 16:47:23 +0300
Message-ID: <CAHNKnsRrpSJtEVwjTV8dNLmmMFH+H0AmF=+22HVy39mMquNe8Q@mail.gmail.com>
Subject: Re: [PATCH net] netns: export get_net_ns_by_id()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Leon,

On Sun, May 16, 2021 at 2:05 PM Leon Romanovsky <leon@kernel.org> wrote:
> On Fri, May 14, 2021 at 11:52:51PM +0300, Sergey Ryazanov wrote:
> > On Fri, May 14, 2021 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 13 May 2021 00:29:56 +0300 Sergey Ryazanov wrote:
> > > > No one loadable module is able to obtain netns by id since the
> > > > corresponding function has not been exported. Export it to be able to
> > > > use netns id API in loadable modules too as already done for
> > > > peernet2id_alloc().
> > >
> > > peernet2id_alloc() is used by OvS, what's the user for get_net_ns_by_id()?
> >
> > There are currently no active users of get_net_ns_by_id(), that is why
> > I did not add a "Fix" tag. Missed function export does not break
> > existing code in any way.
>
> It is against kernel rule to do not expose APIs, even internal to the kernel,
> without real users. There are many patches every cycle that remove such EXPORT_*()s.
>
> EXPORT_*() creates extra entries in Module.symvers and can be seen as unnecessary
> namespace pollution.

Ok, I got it. Maintainers do not like uncontrollable API experiments
:) I have no more arguments and I give up. Jakub, please drop this
patch.

BTW, for those who might be interested in experimenting with netnsid.
I found another way to search netns by its id without the kernel
rebuild. get_net_ns_by_id() is a simple container for the idr_found()
invocation, which is wrapped with the RCU lock. So it is no big deal
to implement this function locally to a module.

--
Sergey
