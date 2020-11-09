Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBD22AC078
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgKIQGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgKIQGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:06:02 -0500
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCA6C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:06:02 -0800 (PST)
Received: by mail-ua1-x943.google.com with SMTP id k12so448441uae.13
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rC48CYvTJIQv0fsMklNv2JMQOQlURjmraHjjzyoRLOo=;
        b=on1YHZt5nYdvhBddU4Fk4qCde6fuY8VocK5YD3fE/VnP+6s/j34FBC7zK0EciLgsE9
         +FT29qMjHyKyFLNrSSBjwjdwfPjWBddmplGwprRNWvtpAQxh9ED+10/V1C4hAz4Q3mf5
         oc7yynIYsDsWmEWm6JOETrqdD7XB6/oviCJccTTQEcTeTfxDufaViX5YOxHXl0HbWsVK
         zQihp+O5Ldf1Hxn29H+jI8v4T64DTSDS1Ah0Ig8U98SxHfK2hkvtMJf9kH4unp1SGUJM
         8ejHz//v6L6QePUvxnT+BqZ/hQvvSaU5Kw54g3I5OI30pkevkZdTvHnN7xPd2WL/JGl9
         gmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rC48CYvTJIQv0fsMklNv2JMQOQlURjmraHjjzyoRLOo=;
        b=mRm3HGH0q6HwASWmO2WMXRt4LImhGdmwHPj1dixkSbyOrXEXkNzuRRiZzTPv6p8DbG
         5xGHGawHKlUCrJmkcAXpokhVaSnfdmI6J6eRZnwTIgz4wW1xdvwruNqh/WsOHE4dZ3yN
         nKRN4xdiPHrvvwIUqxRll2Z+rJrIxnT2g3nQqDa468RIUF6cHuSoDd9hD5oFXuPZT99B
         UpR/Y3kSUc0gnYKn9EsNVNtHEJfhNKA80vz2Jz//T4anw7dHSJgJLAgSntv/jsUr1pKg
         DMDeBfn384GWU0GKf78izhW93a+8lVrs4y2DVHQqr8owHZvSGcPJi8VU0uWJO0y+8HQQ
         7ZoA==
X-Gm-Message-State: AOAM532VBSRAA10LOvhtMDyzEePe06Pgd/ZB48oG/rtopNMZCi0vznk/
        0z8zoPj9qvdtAHBgM8Lj772pJYPXN/2I2Ns6kiKVkA==
X-Google-Smtp-Source: ABdhPJzvdLDJ7gVQ9v2DRtouUmE/EDZxwSc4RcTUsRweJ75uvezHCLpqLTRg3JEO7xR5iUkNdqlVcEtg/DPS6UPV4Jc=
X-Received: by 2002:ab0:4e0e:: with SMTP id g14mr7094795uah.19.1604937961379;
 Mon, 09 Nov 2020 08:06:01 -0800 (PST)
MIME-Version: 1.0
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
 <20201109150416.1877878-2-zhangqilong3@huawei.com> <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
 <CAPDyKFr-XCAWKQiN29s-=XusqqPSqumK9wZVePT+5C7J43BKqA@mail.gmail.com> <CAJZ5v0gZo=kvWWSOTzNaYohr1Yk0iiZnj3+WZbq+jK3HXLu16g@mail.gmail.com>
In-Reply-To: <CAJZ5v0gZo=kvWWSOTzNaYohr1Yk0iiZnj3+WZbq+jK3HXLu16g@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 9 Nov 2020 17:05:23 +0100
Message-ID: <CAPDyKFpDE9Hw4xnmv43X3CxwF6LU0X1qOV0wymzRw8MPCQKLkA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] PM: runtime: Add a general runtime get sync
 operation to deal with usage counter
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 at 16:54, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Mon, Nov 9, 2020 at 4:50 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > On Mon, 9 Nov 2020 at 16:20, Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Mon, Nov 9, 2020 at 4:00 PM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > > >
> > > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > > it brings a trouble to the usage counter processing. Many callers forget
> > > > to decrease the usage counter when it failed. It has been discussed a
> > > > lot[0][1]. So we add a function to deal with the usage counter for better
> > > > coding.
> > > >
> > > > [0]https://lkml.org/lkml/2020/6/14/88
> > > > [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520095148.10995-1-dinghao.liu@zju.edu.cn/
> > > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > > ---
> > > >  include/linux/pm_runtime.h | 30 ++++++++++++++++++++++++++++++
> > > >  1 file changed, 30 insertions(+)
> > > >
> > > > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > > > index 4b708f4e8eed..6549ce764400 100644
> > > > --- a/include/linux/pm_runtime.h
> > > > +++ b/include/linux/pm_runtime.h
> > > > @@ -386,6 +386,36 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > > >  }
> > > >
> > > > +/**
> > > > + * pm_runtime_general_get - Bump up usage counter of a device and resume it.
> > > > + * @dev: Target device.
> > > > + *
> > > > + * Increase runtime PM usage counter of @dev first, and carry out runtime-resume
> > > > + * of it synchronously. If __pm_runtime_resume return negative value(device is in
> > > > + * error state), we to need decrease the usage counter before it return. If
> > > > + * __pm_runtime_resume return positive value, it means the runtime of device has
> > > > + * already been in active state, and we let the new wrapper return zero instead.
> > > > + *
> > > > + * The possible return values of this function is zero or negative value.
> > > > + * zero:
> > > > + *    - it means resume succeeed or runtime of device has already been active, the
> > > > + *      runtime PM usage counter of @dev remains incremented.
> > > > + * negative:
> > > > + *    - it means failure and the runtime PM usage counter of @dev has been balanced.
> > >
> > > The kerneldoc above is kind of noisy and it is hard to figure out what
> > > the helper really does from it.
> > >
> > > You could basically say something like "Resume @dev synchronously and
> > > if that is successful, increment its runtime PM usage counter.  Return
> > > 0 if the runtime PM usage counter of @dev has been incremented or a
> > > negative error code otherwise."
> > >
> > > > + */
> > > > +static inline int pm_runtime_general_get(struct device *dev)
> > >
> > > What about pm_runtime_resume_and_get()?
> >
> > We already have pm_runtime_get_if_active() - so perhaps
> > pm_runtime_get_if_suspended() could be an option as well?
>
> It doesn't work this way, though.
>
> The "get" happens even if the device has not been suspended.

Yes, that's right - so pm_runtime_resume_and_get() is probably the
best we can pick then.

Kind regards
Uffe
