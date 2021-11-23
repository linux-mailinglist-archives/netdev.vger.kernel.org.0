Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B670845B010
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbhKWX37 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Nov 2021 18:29:59 -0500
Received: from mail-yb1-f176.google.com ([209.85.219.176]:39864 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKWX35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:29:57 -0500
Received: by mail-yb1-f176.google.com with SMTP id v203so1848138ybe.6;
        Tue, 23 Nov 2021 15:26:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MGa8R8PmTZ9AIUNlXC04NS72g29Wm45DV8iml8HYRbA=;
        b=4I6NlNVulS9Ozd2HgVIjC8VZ3GY5nS1nbpYoxkPyK++n0ELrrOfIRzQuTXzwLN6mPo
         vDOPSxbecUDWVE4JnFDCcP1hrDkzWE2o/pZVo1hBAlbeJ2u0WGOMsdhNFnaR2jTBjhQu
         01J12YEePvpwyBuYrL+rJXpR1PSB2bRUoU4As4N1wrNPsvec1poY15F+OJfmzeSIVqb+
         CucYvcKNsURvMXFOCVSDC+9bV8aKpsb30Ld3hzqbWXZV/6gUEqK4FmTpQ8HoLKPfmZRY
         AFJhQMsoFX4AZlTJmw5xI1zcKvtkhwDlU2nCOfiY7JwzZ4W5EjVGX974ylZVKCKCI6ee
         80PQ==
X-Gm-Message-State: AOAM533haSZ4vf/sj2D6Wof4rK+6PsFEyZinaUcndH6m381jnnbWmfrF
        7jm69YdkuUAqk8amNfMAhRnq0c6YefW3JbRvwqajZl5whsU=
X-Google-Smtp-Source: ABdhPJxRKWRo7oLdXDrow4b4fFm2faOVEKoLcb3Qp7VSqWqi7Tc0iYe6CUYAU7gvwP3x4nCmeGms+iDChov2Slw7MRE=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr11523358ybg.62.1637710008392;
 Tue, 23 Nov 2021 15:26:48 -0800 (PST)
MIME-Version: 1.0
References: <20211119161850.202094-1-mailhol.vincent@wanadoo.fr>
 <38544770-9e5f-1b1b-1f0a-a7ff1719327d@hartkopp.net> <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
 <73c3b9cb-3b46-1523-d926-4bdf86de3fb8@hartkopp.net>
In-Reply-To: <73c3b9cb-3b46-1523-d926-4bdf86de3fb8@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 24 Nov 2021 08:26:37 +0900
Message-ID: <CAMZ6RqKiy0FXa0RLhAeG+=R37WhFAmLamXCJM_T1f7TaSrs-gw@mail.gmail.com>
Subject: Re: [PATCH] can: bittiming: replace CAN units with the SI metric
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 24 Nov. 2021 à 05:53, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> Hi Vincent,
> On 22.11.21 03:22, Vincent MAILHOL wrote:
> > Le lun. 22 nov. 2021 à 03:27, Oliver Hartkopp <socketcan@hartkopp.net> a écrit :
>
>
> >>>    #include <linux/kernel.h>
> >>> +#include <linux/units.h>
> >>>    #include <asm/unaligned.h>
> >>>
> >>>    #include "es58x_core.h"
> >>> @@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
> >>>        .bittiming_const = &es581_4_bittiming_const,
> >>>        .data_bittiming_const = NULL,
> >>>        .tdc_const = NULL,
> >>> -     .bitrate_max = 1 * CAN_MBPS,
> >>> -     .clock = {.freq = 50 * CAN_MHZ},
> >>> +     .bitrate_max = 1 * MEGA,
> >>> +     .clock = {.freq = 50 * MEGA},
> >>
> >> IMO we are losing information here.
> >>
> >> It feels you suggest to replace MHz with M.
> >
> > When I introduced the CAN_{K,M}BPS and CAN_MHZ macros, my primary
> > intent was to avoid having to write more than five zeros in a
> > row (because the human brain is bad at counting those). And the
> > KILO/MEGA prefixes perfectly cover that intent.
> >
> > You are correct to say that the information of the unit is
> > lost. But I assume this information to be implicit (frequencies
> > are in Hz, baudrate are in bits/second). So yes, I suggest
> > replacing MHz with M.
> >
> > Do you really think that people will be confused by this change?
>
> It is not about confusing people but about the quality of documentation
> and readability.
>
> >
> > I am not strongly opposed to keeping it either (hey, I was the
> > one who introduced it in the first place). I just think that
> > using linux/units.h is sufficient.
> >
> >> So where is the Hz information then?
> >
> > It is in the comment of can_clock:freq :)
> >
> > https://elixir.bootlin.com/linux/v5.15/source/include/uapi/linux/can/netlink.h#L63
>
> Haha, you are funny ;-)
>
> But the fact that you provide this URL shows that the information is not
> found or easily accessible when someone reads the code here.
>
> >>> -     .bitrate_max = 8 * CAN_MBPS,
> >>> -     .clock = {.freq = 80 * CAN_MHZ},
> >>> +     .bitrate_max = 8 * MEGA,
> >>> +     .clock = {.freq = 80 * MEGA},
>
> What about
>
> +     .bitrate_max = 8 * MEGA, /* bits per second */
> +     .clock = {.freq = 80 * MEGA}, /* Hz */
>
> which uses the SI constants but maintains the unit?

This works with. Actually, I also hesitated to add such comments
when writing this patch. For the sake of the quality of the
documentation, I will prepare a v2.


Yours sincerely,
Vincent Mailhol
