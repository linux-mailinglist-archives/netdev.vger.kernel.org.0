Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC883E2C68
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhHFOUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237949AbhHFOUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:20:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F81CC0613CF;
        Fri,  6 Aug 2021 07:20:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so22982472pjb.2;
        Fri, 06 Aug 2021 07:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQyfH/B3o+r7i7GqomphHABujjYKyAefRA4WKRWOcMk=;
        b=hankjnwhHImOTCMQ4IzmrjIyTNmLskPlgmq0sYeqX+m3p+GMrH0ixj8SkYnTcB5Umb
         ny+zRAru39Orzo9Yir176ki8wMwLwdx9H7tEAj64UAmdCXuXwThR+6fMJKq37d/A/xvl
         304XjM5KJQwtBH7czyQ+2hRWhHu5QgCzmTb5NjT+rh4xlz8xeXzQEMyVeEDf47MmSbR4
         G8f1FTixfAmxDqel99IzfxuZzhXuHKbMbMK9xgfnKfCMGRaSAtTQruuvpJHk2jopRZ5I
         LGxwqqZSIJpDOKiLaHzSiIlOD2Ho0bXUwJ0/RY7dgK8fTj043pkH7IJUS52+V3wEefI5
         FxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQyfH/B3o+r7i7GqomphHABujjYKyAefRA4WKRWOcMk=;
        b=M/m8Sfg40uBYAuJRBIr4nIkdtLPZKLGiyXpIcvSzY/33FSAdUQrDR4I7oEPBhzxsy9
         pITs94+YTWHL6q/7zSaQSXChuonWUg2744ZB6rIkgYncFoTlU+h0B3YLKMgoPsTkkX55
         d8aiZNNKRwUnu1Jbdi3GzsG2JUHJpHF87KdjL401iTmlzFrQueSlWPaWBysHHpHNMmBi
         C2tTYlmORkCL4vVnrpiZvzVSPb5HmA4KVmFk11jx2WaDQYk85HpMPvmxoov6yNTMoIVt
         +TRPNTAKA88b7KLWtgnSpVhwYCDn06cU9H7zO8+ab+CbFc1CXqqlnt0AQ1tHnaClGUZB
         ifHA==
X-Gm-Message-State: AOAM530hM5mzn/EBEQ1xFRJkXZyqVr2Ronf94Oz/lE3615lpyRTqETxb
        iK5wtSVdSSSIgQ/DSEdlrQh7lssB+KFb2NzjJVc=
X-Google-Smtp-Source: ABdhPJzVseAOHYe2d5FFCv5CtRuFT6LvM0LifvBsAW56DD9NmHQQPfPVvJyPhACrN5iPJevxuz0AyTzgViPh/y1eDM4=
X-Received: by 2002:a17:90b:33c5:: with SMTP id lk5mr21611142pjb.129.1628259623884;
 Fri, 06 Aug 2021 07:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
 <20210806085413.61536-2-andriy.shevchenko@linux.intel.com> <CAHNKnsTPQp16FPuVxY+FtJVOXnSga7zt=K8bhXr2YG15M9Y0eQ@mail.gmail.com>
In-Reply-To: <CAHNKnsTPQp16FPuVxY+FtJVOXnSga7zt=K8bhXr2YG15M9Y0eQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 6 Aug 2021 17:19:44 +0300
Message-ID: <CAHp75VcbucQ4w1rki2NZvpS7p-z5b582HwWXDMW5G67C7C6f3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] wwan: core: Unshadow error code returned by ida_alloc_range))
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 5:14 PM Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> On Fri, Aug 6, 2021 at 12:00 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > ida_alloc_range)) may return other than -ENOMEM error code.
> > Unshadow it in the wwan_create_port().
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> A small nitpick, looks like "ida_alloc_range))" in the description is
> a typo and should be "ida_alloc_range()". Besides this:

Shall I resend?

> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thanks!

-- 
With Best Regards,
Andy Shevchenko
