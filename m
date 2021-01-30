Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6F309648
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA3Ph1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhA3Pgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 10:36:44 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C25C061788;
        Sat, 30 Jan 2021 07:25:54 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so17462451ejc.1;
        Sat, 30 Jan 2021 07:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqcFFEuKwMFDfHYsIZTE7xLgUq5U9UVTHAU3xuRpnSg=;
        b=SzeluwXkgRxTv1k0K7I+dcrAQ1xFaYiaau8KqjkQm2V7k+KAvU5f9xDX/B7AsXD1mM
         MAAW0kO09LvMqhdqe5ACkW3wlEJteAyB2wdqWa7q44IJakZyGFmbcrN3e51oKF+b9EDR
         6wMfAmdS/P4sTuP6t99PXkSXmW87U8ouwsxyES53y59WNrgO1ckoU7lBuyQIO0jxoK70
         GONSDRNHVhH1CX/tPwibx6vH2VzcT187T7wBnFIqBh+Ces/HaoLloCbFOJXFUpHpMLpb
         ZkkCy4m3g0OSmH35rTTvN4Bl9U3uTIIOvo/7IIZ07PmXJat1F+wU9sj6hSpw41p031I3
         OkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqcFFEuKwMFDfHYsIZTE7xLgUq5U9UVTHAU3xuRpnSg=;
        b=hibQ4qTGFprpcwaBD28tj9ZN4siJUXm1Nn3PbJNxC8mcH+vX42fQYUv9zMaqW/zAKe
         a9z2b9+1Qd20LZB692mKJSzlgHBzAUU1TlM9+M4FBPE9gU9h7kYrNCUjW2ebp9LJZO3F
         s445t6TOD3BY1zHcx2g2MYjH+xkX5IHFWJj8IWKp9xT3d8VmuhgLdXRV/PcFfajzMJUe
         0TAZdKPKZHoN4f3qpdMqEFplDmz320MBln0l7OXFHXT9phG1B81Fj/5mzT5dwZb608HN
         ev1+4w5RZRXeTilAWk51kMtquDmgHtJdxB5ZdI8WBg2fTjepxNm/0Lq/bm3gzEScYQK0
         LZZQ==
X-Gm-Message-State: AOAM533rRuqst5omp4H7R5QSu4AwtPanuvRsoNQ/qH/Piu3iP/wJA7oI
        gSnEEagif4HSAqlE/9bb/qWydHA9saR82nh4EOCt3Z1Kfwo=
X-Google-Smtp-Source: ABdhPJy3DpsFAiYHGP+861HMF23s+lFZB/akyoEkcKjSKvw+R30OG5F2juz0qay1zDIZVLbxPMR+9yEnoGYrsYcKTic=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr9545792ejd.119.1612020352598;
 Sat, 30 Jan 2021 07:25:52 -0800 (PST)
MIME-Version: 1.0
References: <20210129202019.2099259-1-elder@linaro.org> <20210129202019.2099259-10-elder@linaro.org>
In-Reply-To: <20210129202019.2099259-10-elder@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 30 Jan 2021 10:25:16 -0500
Message-ID: <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
>
> The channel stop and suspend paths both call __gsi_channel_stop(),
> which quiesces channel activity, disables NAPI, and (on other than
> SDM845) stops the channel.  Similarly, the start and resume paths
> share __gsi_channel_start(), which starts the channel and re-enables
> NAPI again.
>
> Disabling NAPI should be done when stopping a channel, but this
> should *not* be done when suspending.  It's not necessary in the
> suspend path anyway, because the stopped channel (or suspended
> endpoint on SDM845) will not cause interrupts to schedule NAPI,
> and gsi_channel_trans_quiesce() won't return until there are no
> more transactions to process in the NAPI polling loop.

But why is it incorrect to do so?

From a quick look, virtio-net disables on both remove and freeze, for instance.

> Instead, enable NAPI in gsi_channel_start(), when the completion
> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
> when finally disabling the interrupt.
>
> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
> NAPI polling is done before moving on.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
=
> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>         struct gsi_channel *channel = &gsi->channel[channel_id];
>         int ret;
>
> -       /* Enable the completion interrupt */
> +       /* Enable NAPI and the completion interrupt */
> +       napi_enable(&channel->napi);
>         gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
>
>         ret = __gsi_channel_start(channel, true);
> -       if (ret)
> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> +       if (!ret)
> +               return 0;
> +
> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> +       napi_disable(&channel->napi);
>
>         return ret;
>  }

subjective, but easier to parse when the normal control flow is linear
and the error path takes a branch (or goto, if reused).
