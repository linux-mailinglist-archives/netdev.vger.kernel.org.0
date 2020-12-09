Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB32D4D5C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbgLIWMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388308AbgLIWMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:12:17 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9825C0613CF;
        Wed,  9 Dec 2020 14:11:36 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id g20so868620plo.2;
        Wed, 09 Dec 2020 14:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uvqGywsXM1Q06kTXA1nF8b4vLpxDf9nEtyONmvLvXGM=;
        b=Zq+Yu3XA+wvyZdRM8e4Pv4WUDnljBil3Rdnd5/iH1zHyhnKqVybEqrRx39Zz63QOcb
         p0ihDZQ9gbeQttpFWswj/2RwondenZznIseagFYmycOS/WcZXmAZcTeqfIM5JP80ysK7
         a+35kvUWUcpCxllNG7OTejzO+GfGoCpUWv/U+SPJFCwobrKM7EIq/upg5QXtxNmzyQfT
         idKz6Z3fA0R8/rsWf28z81yHBfu78y1wfeDjoRvmDwUvWUmYOhKjhxAYIS9BnQGABdtI
         ISeSeMSLO6Wboq1aweV691RbGSHBJgxp/prfpPf/vxY6IV21QIPLpJz7OViXY6Ecmyp/
         lQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uvqGywsXM1Q06kTXA1nF8b4vLpxDf9nEtyONmvLvXGM=;
        b=JJfW7UnV4vHUn1VKqEd9xNERoCCqn2uNNpXWPj3EMsyMccj5WRuq2irBeQwM2AgKWI
         TWz3HjXiq4QCi7bMQIrGmC7m5NEdqPp1sXgXaKotCx6vW6IImBB41hyQv07kXKETpTD9
         bb0vVF4jU7rKjE4vvAqUsKKMm6EZiIpShGwu+wQcLg2VbtueqCsDpYZPoPwbZF02FKGI
         DJdWipeQl5Uh5moj8i5fJ60ciTmQxd8vepwQXXGRYOblhKlgnR9BW4WHuj9qjQ6o7aKx
         u3kKivhTf09kLKw/gXaDPVwFlUNgO7lXeT6SvQHdslvLWbNeQE9N+8mSjSdsYgZkuhY3
         vg2Q==
X-Gm-Message-State: AOAM533iO763QwIFhsdTvId1zehLKSChFAUGqdxFYfFozl0P2UWS4AjW
        vaMkzPL/UEI6XlD1fqS7FLDoPumQ/MpjTqSVyYc=
X-Google-Smtp-Source: ABdhPJybMiLB3zOCDvBDCHWNbqcFGl7t6+NdL85nhwmvdBI3ckmyzlz6A0GyjHO14bZReQdljGH0wJfxQUx6wOuAuGc=
X-Received: by 2002:a17:902:6b45:b029:d6:c43e:ad13 with SMTP id
 g5-20020a1709026b45b02900d6c43ead13mr3967084plt.77.1607551896394; Wed, 09 Dec
 2020 14:11:36 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
 <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
 <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de> <CAJht_ENOhnS7A6997CAP5qhn10NMYSVD3xOxcbPGQFLGb8z_Sg@mail.gmail.com>
In-Reply-To: <CAJht_ENOhnS7A6997CAP5qhn10NMYSVD3xOxcbPGQFLGb8z_Sg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 14:11:25 -0800
Message-ID: <CAJht_EPj-4bv6D=Ojz5KCbk0NTVfjRyEA3NmMw7etxrq8GKu8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 1:47 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Dec 9, 2020 at 1:41 AM Martin Schiller <ms@dev.tdt.de> wrote:
> >
> > Right.
> > By the way: A "Restart Collision" is in practice a very common event to
> > establish the Layer 3.
>
> Oh, I see. Thanks!

Hi Martin,

When you submit future patch series, can you try ensuring the code to
be in a completely working state after each patch in the series? This
makes reviewing the patches easier. After the patches get applied,
this also makes tracing bugs (for example, with "git bisect") through
the commit history easier.
