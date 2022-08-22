Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D07E59CA03
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiHVUcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiHVUcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:32:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4342B52829
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:32:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d1so145489edn.9
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=gUUJGDZZ7SmwoHkhrT602wMnsCfmfrGrVbXmH2wIM3g=;
        b=Z+tUKeClXChR4jRlQGg41fHbT2bJsJZqVxlH7TSDRnIKVcsWoXGws6FK/hz5EGuT4S
         yPu/tIYvMiV5u9nagc3sJ7K7VFdaJs3UH//tmuGoe95tcbMp5ov4mybmPAqUAwktzqOI
         V0PJNpbtkpzFVVxtumlOm80eN4+ci0qXNJMp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=gUUJGDZZ7SmwoHkhrT602wMnsCfmfrGrVbXmH2wIM3g=;
        b=NDECIT5rm16DZSXaTP0SbQpHd6qmSF9wMsDe7hahIrh74Du1QOFtBpxs542V2SH4w/
         EOj+coVvNrJpJGNYT293H9alL/yqVIhW+WThZYc76Gb/rSaeo3tGDwfcPKJ23TbiFrzk
         jTsMS87PZGmj4W23xDqWMI1wa9GblJM03IN3fC+DzZTdxMNVPOtB0VOmdSMg7SygWfqw
         QtFqhUPGj60fSd5BZQO+dK8FlvdF4OImiJO8ogzdrxVS6L60GThrRayAvPrTucydU9Yt
         arT3Fe8Z63UO58ybp21xbstQJtmHZwRaRCw8o5kiaIfErz3NWU3Iq6WJmeTNdxTOinOP
         Dcuw==
X-Gm-Message-State: ACgBeo3q7DIJK/nZ8OX7gMdFh1EQ3wdwptNtzZg31kG/73oyDmL71grR
        cvp6Vw9TZpSHkhRngmGkXLQxbb/lqXHALA+qjnw=
X-Google-Smtp-Source: AA6agR5aO9AS2pKZXW+fRNtkpy341L89uWjtidZfuux1dCFYyEnpe8Pr7gqBobVdH/iUxNt6r7DYsw==
X-Received: by 2002:a05:6402:438d:b0:446:a0b4:630d with SMTP id o13-20020a056402438d00b00446a0b4630dmr722707edc.118.1661200333470;
        Mon, 22 Aug 2022 13:32:13 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id z2-20020a50eb42000000b0044687e93f74sm252680edp.43.2022.08.22.13.32.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 13:32:12 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id d1so145411edn.9
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:32:12 -0700 (PDT)
X-Received: by 2002:a05:6000:1541:b0:222:cf65:18d7 with SMTP id
 1-20020a056000154100b00222cf6518d7mr11504823wry.659.1661200321380; Mon, 22
 Aug 2022 13:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220819221616.2107893-1-saravanak@google.com> <20220819221616.2107893-4-saravanak@google.com>
In-Reply-To: <20220819221616.2107893-4-saravanak@google.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 22 Aug 2022 13:31:47 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Wrf2k1gY9+B0WW6D2nhvSHNfWAQrW+y4Td=-u08xe+rQ@mail.gmail.com>
Message-ID: <CAD=FV=Wrf2k1gY9+B0WW6D2nhvSHNfWAQrW+y4Td=-u08xe+rQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] Revert "PM: domains: Delete usage of driver_deferred_probe_check_state()"
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Peng Fan <peng.fan@nxp.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>, iommu@lists.linux.dev,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 19, 2022 at 3:16 PM Saravana Kannan <saravanak@google.com> wrote:
>
> This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.
>
> Quite a few issues have been reported [1][2][3][4][5][6] on the original
> commit. While about half of them have been fixed, I'll need to fix the rest
> before driver_deferred_probe_check_state() can be deleted. So, revert the
> deletion for now.
>
> [1] - https://lore.kernel.org/all/DU0PR04MB941735271F45C716342D0410886B9@DU0PR04MB9417.eurprd04.prod.outlook.com/
> [2] - https://lore.kernel.org/all/CM6REZS9Z8AC.2KCR9N3EFLNQR@otso/
> [3] - https://lore.kernel.org/all/CAD=FV=XYVwaXZxqUKAuM5c7NiVjFz5C6m6gAHSJ7rBXBF94_Tg@mail.gmail.com/
> [4] - https://lore.kernel.org/all/Yvpd2pwUJGp7R+YE@euler/
> [5] - https://lore.kernel.org/lkml/20220601070707.3946847-2-saravanak@google.com/
> [6] - https://lore.kernel.org/all/CA+G9fYt_cc5SiNv1Vbse=HYY_+uc+9OYPZuJ-x59bROSaLN6fw@mail.gmail.com/
>
> Fixes: 5a46079a9645 ("PM: domains: Delete usage of driver_deferred_probe_check_state()")
> Reported-by: Peng Fan <peng.fan@nxp.com>
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Reported-by: Tony Lindgren <tony@atomide.com>
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Douglas Anderson <dianders@chromium.org>
