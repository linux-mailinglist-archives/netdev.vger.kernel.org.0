Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD93264159C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLCKOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiLCKOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:14:52 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623284DD7
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 02:14:51 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id y135so4286528yby.12
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 02:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0GRcZGiiUpykwuh4e++q4OmaCC+IGELXlGsq/0NOdGM=;
        b=UJ0a91s8abeTaPAedEfr4Wjo+WfmXOsArp5UTudw0qaaLUrCxNMFGF0ZwER+Q//DFX
         ain4XIfpIC56FNdgLAsJ7PUb2x1T9xAgBHy7zSLiVT1cV8yoJze5GtcJVpNnSn+cMIBS
         iyhlcUHPcVGbaORG2mxc2zCpXPVFLC6PEHQ0ZSp/6Rgobl7P4XuuG97GEmE5h8Ds/Pag
         Oq3qvAuVuOp1zK2fLuY3NW/pGZRZ5IjDGw/fH3MZJzfrrRjrDq9/yiT0dSBTZoiwk12e
         I20ggteiqClCZOzc8D5yY6D3xy70ItCn1ZoXESycVUZDF4NPtbfudnV7pRj78Hb1bgK0
         fWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0GRcZGiiUpykwuh4e++q4OmaCC+IGELXlGsq/0NOdGM=;
        b=BDWEd9r2WRYxySJKiAMtSsrs/3xZigzWCZugpl+UH38QdqsObmzewbnV4aOmuQ0xR5
         n5PzS0oeF+b9rjOn9vUZqaHIq8cKlk7/r8Vl0XPuwokjTyzXmvTkRK26J4yzrUHEGzlN
         h72PHeUHraZm6uOS7/yn0ZOfIeVIhAPLZfSN2DlmiNq1RFwk0oJ8KGw2slLPm4JjEt6p
         0ztjv3wKU50ty0F3P61fQDar2AAwAmofo2fXF4SV9yIpFS8Q4KjNN7pB7ZyjZ5GGVNwZ
         c3r7L2R781qvtMmNzbkeQmvC7RELOQnn+yGFoQfKmY9ZYe0luZObjJFf+p7iPXLClEv/
         qXdg==
X-Gm-Message-State: ANoB5pmS6U2biNNJgy5n31iIt0baLs9rS/MJQz+uIQR/9KdDV0oigAq+
        SmuuJKGIsRw4zGrcEiwYALLJ8BwR7NcwBFAH/OHn3g==
X-Google-Smtp-Source: AA0mqf7rHNUa8Dw3sQ45LPdqk95uye+g95p9EByvk10bjQFGqfBMwJOjSAYghvROHhvrPuVQCUorfF3B2KXN2vl964I=
X-Received: by 2002:a25:bc8a:0:b0:6ee:e865:c2e2 with SMTP id
 e10-20020a25bc8a000000b006eee865c2e2mr8659839ybk.206.1670062490892; Sat, 03
 Dec 2022 02:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20211015164809.22009-1-asmaa@nvidia.com> <20211015164809.22009-2-asmaa@nvidia.com>
In-Reply-To: <20211015164809.22009-2-asmaa@nvidia.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 3 Dec 2022 11:14:39 +0100
Message-ID: <CACRpkdbvR0+5gKUH7eE2tZ1H9DR-WiYyh9KSnUTesYiZ=AezNw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] gpio: mlxbf2: Introduce IRQ support
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        bgolaszewski@baylibre.com, davem@davemloft.net, rjw@rjwysocki.net,
        davthompson@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 6:48 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:

> Introduce standard IRQ handling in the gpio-mlxbf2.c
> driver.
>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Looks good to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
