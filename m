Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D4739815A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFBGpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhFBGpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:45:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AA6C06174A
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 23:43:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1137091pjb.5
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 23:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNCMYsORB2O0j+rBwqWrKCHuWb02Rwsv7Zd/jYnQBrk=;
        b=rkYL51hNyBUVvfeo/Ts/JWjairp3sLaw8Wab8dcs76zfYyT09yCrHcNLwOWMR806h8
         gn9b6kUEb0NBHt9jqHV2MwecHtMN2l3CYF+JnSspfE4WxvKI+8zqnXDBcYwfBcH8Ozgi
         hNeDHnCkCrI4A+hR9EsFwBT5eah0PQrS/raMOFwqM0UdlxJAUbrdIlYJDLzwHp4C4JND
         5/LTOKTnzpihFIQ/xyLwdax2EMVril6A3WFFhg+tef3TUmazybvPKERhfxiMSBfG7bjE
         /UHGyfKmaVkggFvqEH/mPGFYqCfnCH6YeqrC5/KnySr+OPLl6e+8hMraL+ekWOYrC7md
         sbuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNCMYsORB2O0j+rBwqWrKCHuWb02Rwsv7Zd/jYnQBrk=;
        b=JmW7U3rJ2Rx3ul1xpdcXXcClo7k99eQlW5X24UN+8jmwJHPmpXESpZHds52kAn0AQS
         qh2hcuXkos3TCqjhnOBgRH37G7LUdY1ExzFKgpBvCNb3yJqim0ryFDlxNWBXlzXr95e/
         x5MUTvV1Aekf53iaPxaouB6WaTUUrZr1qMP5rCXnjbyeEgXTYVBIEz2TJ1hZRHl3mQhG
         Ngl1iC/nQdmRWFJXEESrKW3VGXYLoooMdkkx0tCL9Wru3QZUjBJ33eJKHF9Gy0JvGmbn
         R5oTl51or3rfjVQJuKOz/pqV1ghsksXeM5Uo9hMQDP8YOgAMSGG80RU/G6hsmhPfv6W4
         Mi8g==
X-Gm-Message-State: AOAM531Vb2FVL6MoQ6OkFW6rjRP9TKjlxQ+x4l6MYVnKJXjz0PPR2djU
        jmWBufuF7XHHySLzv7bcaMEP0VFOXJiBQG8WV8jfgw==
X-Google-Smtp-Source: ABdhPJyZZUSH0rWkcmogDw1e5BiGDx0GJaN5/8zaj5DMGQU+UY2y+F3XsOlz/Io/znrXPSF4Jc2ce+AJf1LBq2YjMss=
X-Received: by 2002:a17:902:d64e:b029:ef:8b85:d299 with SMTP id
 y14-20020a170902d64eb02900ef8b85d299mr29459130plh.27.1622616207614; Tue, 01
 Jun 2021 23:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210601080538.71036-1-johannes@sipsolutions.net>
 <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
 <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com> <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
In-Reply-To: <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 2 Jun 2021 08:52:45 +0200
Message-ID: <CAMZdPi8Ca3YRaVWGL6Fjd7yfowQcX2V2RYNDNm-2kQdEZ-Z1Bw@mail.gmail.com>
Subject: Re: [RFC 3/4] wwan: add interface creation support
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 at 12:35, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>
> > > +int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
> > > +                     void *ctxt)
> > > +{
> > > +       struct wwan_dev_reg *reg;
> > > +       int ret;
> > > +
> > > +       if (WARN_ON(!parent || !ops))
> > > +               return -EINVAL;
> > > +
> > > +       mutex_lock(&wwan_mtx);
> > > +       list_for_each_entry(reg, &wwan_devs, list) {
> > > +               if (WARN_ON(reg->dev == parent)) {
> > > +                       ret = -EBUSY;
> > > +                       goto out;
> > > +               }
> > > +       }
> >
> > Thanks for this, overall it looks good to me, but just checking why
> > you're not using the wwan_dev internally to create-or-pick wwan_dev
> > (wwan_dev_create) and register ops to it, instead of having a global
> > new wwan_devs list.
>
> Uh, no good reason. I just missed that all that infrastructure is
> already there, oops.

OK no prob ;-), are you going to resubmit something or do you want I
take care of this?

Regards,
Loic
