Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25F8358C24
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhDHS0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHS0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:26:33 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D4FC061760;
        Thu,  8 Apr 2021 11:26:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so933567wmg.0;
        Thu, 08 Apr 2021 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2yYVECD1X30uGENzlM/iMQrCDbEjlIytowbLivMLjEA=;
        b=gh5C65fmaDWyuod8vffEJHmef/WoEGHIpyvLdgEYdMZJiA9yWmLIB7D6y+J5wih1Ae
         2VlC1+fa7w9mI0OM1aujQgseHto7LBqGf6aPuzfmoeaHvltijJzj51ip+eI85T1HZQsl
         olfgFh+NJzV3uGHGfoSPi4vcMnS46g+TmTwtoi4cEbE4D7qOL6lR+Y02SfKPYwodNfBY
         HRyE2Iz4KHvcrlOawnul4wgh2VLN/QcFRNXt7HOb8wjuGZtkSBawZ3JaI7nPaFAqML2J
         sMQzM8E3XRrKrmjTHC6IrmyhkTUVXaMri9sf63zApPYDLW92p3r4QhSxbwXXJZAVnjyT
         Y42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2yYVECD1X30uGENzlM/iMQrCDbEjlIytowbLivMLjEA=;
        b=MzXfT5mfBQaOToHxCbyV/VKFmWq5cw8ScG6ZUNIoW8r6xw0cb/bLYHvCP6j5Bxjnx0
         /jdnvb+9VGEnL4569MD01CF5SdBz4Ee8Y8QXAoAJH4JvX9l772K1BHmZZ9niYOSow/Z2
         8yCZxYZOx5aTd/EGsJKkyOugCmjRenTzrpf/PH2Zf4ePxm6r7n9F+0arpoEoQfRnrT1F
         uh8IJWlxrkabJIu9RB4SEgPeiJxU+72hp7IBEFWH5rK+R1iNuOBzgmxLv9yrSwgqQj5Z
         cz/ZnvP+5jU7sI4Q1xWkOAPC5YWr1WDurVjTugssU2eOnKcMWE25kFruTkx+ultu3OdV
         018w==
X-Gm-Message-State: AOAM5328wutlYVURUHSPWjlGDwqtbt23PxeQbnKkj/O2dpERvStV5RZ6
        ybvKlDzQKnG0X7VMkOF3cJLH8Jzt61nCDl9dH2M=
X-Google-Smtp-Source: ABdhPJy0U2G9uZmxZ298LlINBODzVz8nR/Q6bhFWdKM32tacyvo7pU4FU0fOOyICRq6qU3zPaWkBbahCHoM+xTKaGJs=
X-Received: by 2002:a7b:c003:: with SMTP id c3mr10122956wmb.59.1617906380650;
 Thu, 08 Apr 2021 11:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com> <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com>
In-Reply-To: <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 14:26:09 -0400
Message-ID: <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Thu, Apr 8, 2021 at 2:22 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Just an idea:
> RX_HEAD_PADDING is an alias for NET_IP_ALIGN that can have two values:
> 0 and 2
> The two systems you use may have different NET_IP_ALIGN values.
> This could explain the behavior. Then what I proposed should work
> for both of you: frame_length - ETH_FCS_LEN

Yes, good point! I was thinking the exact same thing just now.
Subtracting 2 + RX_HEAD_PADDING from the frame length made no sense.

George, I will send a patch for you to try shortly. Except if you're
already ahead :)
