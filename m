Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBA82FC653
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbhATBRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730274AbhATBPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 20:15:51 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2633C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 17:15:07 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id j67so3828163vkh.11
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 17:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Brf3WO950D1Q6AZvZIOD9DGe8ISGSWxrv8pGr/tlzMU=;
        b=EtQvUWk7uKUBuqxqWiTn1+cdCMqvcZrSNSg8dh7GOx17/dg+ptQEJHeRtha9a92jku
         Sn4hT0kwZn4e12PMw3rDhCetZBM8MM8v7kohIMohZhkW/CdymAyhbCA0f52O1Ks4nr/a
         Oc9MtFvU5z1xziTTFDR9wDfpEybEbAsofBCBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Brf3WO950D1Q6AZvZIOD9DGe8ISGSWxrv8pGr/tlzMU=;
        b=WqcPZhKrZJJLCrihJkmqHIE2uI4zlPwj6MLcUbYFg5PiCiH23ZVXjGCuUTiKPiXpn7
         auatWwq6KFCK2IwxdfkfmM3g5zB1EIwFt4R2EY9qc64ekPsvjFnarCA5gg+2XxsGIl6o
         vYxm3kMrfnc07a7yBQSlYydeIS8OEp9PDiwfIlflWJLjDW2oc8DVOuQHdgCR748JsLXK
         kHvyNVLazJzghtVfBQoPdcq8HD94votqstgw0Rt1g4IbAG1b1x3g6IQRmP3tu4ChhUy+
         0eVLanCX71uhAAISkS1A/ZEp7D3htZtpKoQnlVHv57xhvrAdJeuGmfx954RFl2iBmT5J
         xIQQ==
X-Gm-Message-State: AOAM5307IcjQwpppcS11Qz4/OvNOZ6sLb0MWAyrMQKp1FwZ3u24POX1A
        wzgmaHJXxMgiP6BqQaMH+ZrDmDeBYflCgzMxtXr4fg==
X-Google-Smtp-Source: ABdhPJxzzWtdGxD8t0BxB6bMkRuGxNx8eneoxGE+jzu/u6mGGowOJfIQW7qV2QQ0cP//HwTe3jP7meGJRcmxG+Rw7eU=
X-Received: by 2002:a1f:1c4c:: with SMTP id c73mr5018609vkc.22.1611105306635;
 Tue, 19 Jan 2021 17:15:06 -0800 (PST)
MIME-Version: 1.0
References: <20210116052623.3196274-1-grundler@chromium.org>
 <20210116052623.3196274-3-grundler@chromium.org> <20210119134558.5072a1cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANEJEGsd8c1RYnKXsWOhLFDOh89EXAUtLUPMrbWf+2+yin5kHw@mail.gmail.com>
 <CANEJEGvoSWDWN19PnYJB9ubKgfyEvX4g=rvi9ezEJ9n+NUevbA@mail.gmail.com> <20210119170546.189e12d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119170546.189e12d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Wed, 20 Jan 2021 01:14:55 +0000
Message-ID: <CANEJEGu0LVdFN3caZ9ya1h4MWAQrMWw9gzdjJZ+t+9Y8mB2NRw@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 1:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 Jan 2021 00:59:17 +0000 Grant Grundler wrote:
> > > > Thanks for the patch, this looks like an improvement over:
> > > >
> > > > 59b4a8fa27f5 ("CDC-NCM: remove "connected" log message")
> > > >
> > > > right? Should we bring the "network connection: connected" message back?
> > >
> > > Yes, we can revert Roland's patch. I didn't see that one.
> > >
> > > > Do you want all of these patches to be applied to 5.11 and backported?
> > >
> > > Yes to 5.11. Only the 3rd one really needs to be applied to stable kernels.
> >
> > Sorry - I was thinking 5.11 was -next (and that's incorrect).
> >
> > As you suggested below, only the 3rd one really needs to be applied to
> > 5.11 and other stable kernels.
>
> Cool, would you mind reposting just the 3rd patch separately, and
> tagged as [PATCH net] so that CI can give it a shaking?

Done :)

> We'll go from there with the rest.

Awesome - thank you!

cheers,
grant

>
> > >
> > > > Feels to me like the last one is a fix and the rest can go into -next,
> > > > WDYT?
> > >
> > > Exactly.
