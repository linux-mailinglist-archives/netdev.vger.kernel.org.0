Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B3683851
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjAaVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjAaVHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:07:16 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864AFB472
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:07:15 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id o5so14786978qtr.11
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/KqgwUuD6mK0GVS8xfEzdupirXdhuWEOYQhCcJjWt0=;
        b=EqWGHeWRFp8XjnLvnazZTVEUTHPSWL0ARQAYn3yYMsrF3mQBidAAymu1ITaNd0iqmy
         6qxPKawzm39shUAFkotz6jLJUidSTV8vH7izshr0aL6x1mcp6efUo0DZ3LVuV67SplnQ
         jDRc6RJCZqnz4sMj7OcSH7EsHoiu7wNt7rrEMxJ287wIQxn8NveeLaQO60fPk4USs6dp
         b1bHi96heuYwHo1Gkwtw+fPdIByopbC6jWKuMDjmwHj91L3Q6pfkpr6OjqsL1yT9kpSi
         3Ews9e1Yoq6hpYug7pfS5+WlbCH3BbrAvbA6Rkr/9szg1tfeHWxNPbRhWKNhVl4ZyXmt
         VSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q/KqgwUuD6mK0GVS8xfEzdupirXdhuWEOYQhCcJjWt0=;
        b=u/2RU5GmI/EaYzzaxFrwBF+G+AluV7sODpXVJgK3ruv9Yutq1EXgk8F+wk9Dnu0D72
         vNc4z8WurRYEnaql63RzmkfN3uVC51fExp4TUf0UNG8ufOaL4MOl0q6Lvg2t1o1gd2rM
         BlStRLX+HKAEwAViRO/XgXFEhvbD4GOMOUR2HUmhwxPLCFRIXhlQuGRXGy1Gsolc/tOh
         DSaLkj9RZ52886k1fsxVLow/9vGPm4n0HzP+n3e/YOH2CPRtqqexE+FZE48LN/cIqTk4
         0Q+5DamVeWdISuIdJ7l/5Qa2lq3ZPrEK/1t3sh0y+0Z6bW0e2fOfokre35DBaygAqWrY
         oa9w==
X-Gm-Message-State: AO0yUKX1ki3oC3fX0Yt8z3QTGZcr2CjJngpCy3lT3B/moFocXDoCYnhY
        3DCe7j7Nhs57Jr1cxUHrbFxF01UxS7hBym+8ktWds637lqA=
X-Google-Smtp-Source: AK7set+Ss5s/7XhPJzclS8DScwaEh2tHZ/WCC6FLbKvN+95Wi0oqZfK6+WbRLftp8YhzEzeGGUF6Iqv4RqVS/i7KtWk=
X-Received: by 2002:ac8:5e10:0:b0:3b1:c62b:c140 with SMTP id
 h16-20020ac85e10000000b003b1c62bc140mr9670qtx.313.1675199234580; Tue, 31 Jan
 2023 13:07:14 -0800 (PST)
MIME-Version: 1.0
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
In-Reply-To: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Tue, 31 Jan 2023 13:07:03 -0800
Message-ID: <CAFXsbZpUdfkxxnH3Ex5BUmvnxJYP-4wQ2Ai7Wrvf-O7KaPF-aw@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Chris Healy <healych@amazon.com>

On Tue, Jan 31, 2023 at 1:03 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Jerome provided the information that also the GXL internal PHY doesn't
> support MMD register access and EEE. MMD reads return 0xffff, what
> results in e.g. completely wrong ethtool --show-eee output.
> Therefore use the MMD dummy stubs.
>
> Note: The Fixes tag references the commit that added the MMD dummy
> access stubs.
>
> Fixes: 5df7af85ecd8 ("net: phy: Add general dummy stubs for MMD register access")
> Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/meson-gxl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index c49062ad7..fbf5f2416 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -261,6 +261,8 @@ static struct phy_driver meson_gxl_phy[] = {
>                 .handle_interrupt = meson_gxl_handle_interrupt,
>                 .suspend        = genphy_suspend,
>                 .resume         = genphy_resume,
> +               .read_mmd       = genphy_read_mmd_unsupported,
> +               .write_mmd      = genphy_write_mmd_unsupported,
>         }, {
>                 PHY_ID_MATCH_EXACT(0x01803301),
>                 .name           = "Meson G12A Internal PHY",
> --
> 2.39.1
>
