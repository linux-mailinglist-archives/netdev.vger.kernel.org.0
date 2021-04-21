Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646D2366FAB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbhDUQD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbhDUQDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:03:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6995CC06174A;
        Wed, 21 Apr 2021 09:03:21 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u21so64313822ejo.13;
        Wed, 21 Apr 2021 09:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wjm2V8u1ETN6t9NVbeWLUphBIt6mO0zsCxAklfCFw/E=;
        b=S0+5dSFhP6EcjKm/HSOdO49eP2TNeCFrOoj6kYhIAWGvr+XLpkCVpvsi2lekuQ2jBM
         oEaU2Tc8nqXCAXCpElwbx2oFxGYMZfRuygdibM1B669uAGjUfbbyqUrM13cbxVaTrFkX
         GwpyeSjbgEEkLijFCpyFUWpbobJMa6Wqeloh3XAszKbK56pSG8OrUCK+uIjpWv7IdHST
         /75eGIQgP8PI1VvpOqqQlZtZ8p0rpVmEotM2XWyzMNBlMorIXrS34g3auSgPZCFyP/xB
         HYvfQ1ppecKaBzLkOsrk5QL3LzMH4N7d34bP//W9sxwhE/iljYk+yITZ9Z+qmjC2rAm4
         ZIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wjm2V8u1ETN6t9NVbeWLUphBIt6mO0zsCxAklfCFw/E=;
        b=ZESk2eH39rtHYXhipa2LYCepYyk2b/TRV+fgiM8Cvsu5U9MGHejov6bbjKvXk/fLDX
         y4qNP0VaHW+BZw9GdNs57oaOr6K/APlJaHBFlc2MZFJ76tR2bqm5tZCmCb7zEZiyDjUy
         32Q6DfXKnLIMK+4X9cwmt9vD46MlViRq+qyyw7Puxa+js2QUju+fnE6ofVaGzhA6yDjT
         OBUEY+11WtD8pgb6aqkTRuQ326Dq5Ouo+S8OY1Tvnn2suW6M2ImHxB8kTzNTIq4p9evR
         aUTKVeHICZDBQA7FVX+p1v6Y76pXkc3NnpV/RWxNN2vp8+cw1PaR5Pc6OB2Xocn4Gzhq
         ABWg==
X-Gm-Message-State: AOAM532SWqFcXnR+6GYqpRf1y0miwNnPPBmSlcipazjeRrXP6w4g6QZC
        N+qiov9VkPw5yRFCdMF1ebqxGtFWhw5AiwZmyFDcAtwZXs6akA==
X-Google-Smtp-Source: ABdhPJzTFkmTZh3l+T5B4KgpzvZ7I6sMkd2W5G+JIogn9VGIrsCvMpgVgsGpTIHtiL/SOEGztTHTyB7+SwFpc9JWwVE=
X-Received: by 2002:a17:906:e5a:: with SMTP id q26mr33469816eji.263.1619020999982;
 Wed, 21 Apr 2021 09:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210421140505.30756-1-aford173@gmail.com> <3937a792-8985-10c1-b818-af2fbc2241df@gmail.com>
In-Reply-To: <3937a792-8985-10c1-b818-af2fbc2241df@gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 21 Apr 2021 11:03:08 -0500
Message-ID: <CAHCN7xJa9RsK0kbGR8JCV1i2WdPXjYQDJ5hqYNzdQZWxcyPoGg@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 9:25 AM Sergei Shtylyov
<sergei.shtylyov@gmail.com> wrote:
>
> On 4/21/21 5:05 PM, Adam Ford wrote:
>
> > The call to clk_disable_unprepare() can happen before priv is
> > initialized.
>
>    This still doesn't make sense for me...
>
I need an external reference clock enabled by a programmable clock so
I added functionality to turn it on.  [1] When I did it, I was
reminded to disable the clock in the event of an the error condition.
I originally added a call to clk_disable_unprepare(priv->refclk)
under the label called out_release, but a bot responded to me that we
may jump to this error condition before priv is initialized.

This fix is supposed to create a new label so the errors that happen
after the refclk is initialized will get disabled, but any errors that
happen before the clock is initialized will handle errors like they
did before.

Does that help explain things better?

adam

[1] - https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2

> > This means moving clk_disable_unprepare out of
>                                          ^ call
> > out_release into a new label.
> >
> > Fixes: 8ef7adc6beb2 ("net: ethernet: ravb: Enable optional refclk")
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
>
>
> [...]
>
> MBR, Sergei
