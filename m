Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93FB29204F
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgJRVuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJRVuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 17:50:14 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797D3C061755;
        Sun, 18 Oct 2020 14:50:14 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id m65so4983425qte.11;
        Sun, 18 Oct 2020 14:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LW7NtPMGJ2R8VOhKgzw6sjc10vh2YbY8kQEEkfju8fA=;
        b=BT6sX70H+s8KhgIkqlKxOTyt7nLW9Zkkp/pWMqwoIwpRPwASphI99ISJJY/DrRq4YB
         tuxxuQta89p2LltScao7kwUamcV10d6qq0/0GsMri9Y5uCbzF0DQIPVBZym6oh2w8IRp
         jGv4FzahYM8UB3UvXODpIfq1ilK2uqq9Xd/9k1Vp0D25EYeZvsrsLMiSOVKbh0jHo8ly
         ZwpyiDfjYzQI7omWM6lYTXWC4WxC4zXCwovEKbG2sVh0lXA3kgHlfvQ9kncK/jS7lzXB
         WtZ4PQbPMGBo2Fvzsm14b4aTThFD0/Vsyl0CynTIq6qQwMl+W5yJA342KaaYBMt5xICG
         NkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LW7NtPMGJ2R8VOhKgzw6sjc10vh2YbY8kQEEkfju8fA=;
        b=A54fIiuMEzcWU81kWizVMjWexILYSifLNSzkHPsvY2YrLg8OawjexicsjeQJnFnBDX
         lFgMcBFXA82PdWXGIIPhsA9feRYqx1SsNLbcJ/ziaN4LYnD1cKUMCksOLHy3lFXz5KLL
         mu9EmHYogFvkDCXUl8CHzXsYLO+k6XJR5vHxIizc57xHGVrJllBoAsjDznA1f3vEv4gq
         7r/cDjJ56/USRGuhaG/HGaCbsUTFN5E6xSa5feLVxVzOgJvtHqkKZCTYXCcsqR5D9EDP
         B2OZD0jdfFS8VVd8PckfIcCDEueSt7zf1C/eHHzfQ2kzEXzjmS452U49hb5WZ726v4sf
         2NGA==
X-Gm-Message-State: AOAM533U1Tx5J8OhD7nMqzqK4J++qB+CTP2+s6UHp1PSbvAYT+XXA4Gn
        4VQzZkhSxbqT6YowujhmHWmAgdDYog4L64/VD5A=
X-Google-Smtp-Source: ABdhPJw59Z9ZSI7YkUnrDX/NzYUwLZIQMERPV41io/elXdvNyA/Ph+eIMdFGNAEYy/TP8jUOuq9oIUb3paHWMlURueE=
X-Received: by 2002:aed:2983:: with SMTP id o3mr12423656qtd.285.1603057812125;
 Sun, 18 Oct 2020 14:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Sun, 18 Oct 2020 23:50:00 +0200
Message-ID: <CAFLxGvxsHD6zvTJSHeo2gaoRQfjUPZ6M=5BirOObHFjGqnzfew@mail.gmail.com>
Subject: Re: [PATCH] arch: um: convert tasklets to use new tasklet_setup() API
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        3chas3@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stefanr@s5r6.in-berlin.de, Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sebastian Reichel <sre@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Helge Deller <deller@gmx.de>, dmitry.torokhov@gmail.com,
        jassisinghbrar@gmail.com, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        Mark Brown <broonie@kernel.org>, martyn@welchs.me.uk,
        manohar.vanga@gmail.com, mitch@sfgoth.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-um <linux-um@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        devel@driverdev.osuosl.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 11:17 AM Allen Pais <allen.cryptic@gmail.com> wrote:
>
> From: Allen Pais <allen.lkml@gmail.com>
>
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>  arch/um/drivers/vector_kern.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Anton, can you please review this patch?

-- 
Thanks,
//richard
