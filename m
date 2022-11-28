Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE16639EC7
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 02:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiK1BVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 20:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK1BVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 20:21:40 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEB1215;
        Sun, 27 Nov 2022 17:21:39 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id j12so8745297plj.5;
        Sun, 27 Nov 2022 17:21:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJyNVXZ0Nag03x8wF+5JRQFWFO/c5LE8KY9nLBrkk88=;
        b=bLMyj4V5AWVB0OeRG/09OtV3gMmpTuJLlGhu6nz7ssByxfqschyx0S/n3XnkS1gFHu
         XBhI25l1OTaVevG8WDxxQ2dXXGLC/GT+WbI7bsNMDIhp/wG5F0ILl5LQHK8i6b9mhtnV
         vy8Fvv78MAU0eQXUUARcKM+ZgI+54eazUdTw3g0pUh89o7xFg4w+5OpBqz2a7Y5cb8T3
         jRmVVAYdRvwbjifbvjmw70BIMsEOoGGg17xmpHTSrEDaHwvYz6FJLlf2CFynyl3F9M+Q
         gH00e42S+H5AMWMe6cnfjtJ1i/bOe2dUG32lMRkQeomRhwPtcrnKeY+Q78WgkjH7ReDb
         eLNA==
X-Gm-Message-State: ANoB5pk3XxOjnKyJ3wPBIPCH1x5Kiad3zHT65tyJSy/sIuVepfgHV3r9
        r9CQ8jw9kJ35dsc6/5dmODpMs1uqKzsQlzkD/is=
X-Google-Smtp-Source: AA0mqf7lEZw8GreOflw9skrfxDXGuWTHslnxVt2egNsAVVjovt9K+mRepQD3N6d/JgviTgcqpE/ngSCFrCHerqBYZtc=
X-Received: by 2002:a17:902:b608:b0:189:7a8b:537d with SMTP id
 b8-20020a170902b60800b001897a8b537dmr7566610pls.95.1669598498489; Sun, 27 Nov
 2022 17:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4JJ8Dyz7urLz/IM@lunn.ch> <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
 <Y4N9IAlQVsdyIJ9Q@lunn.ch>
In-Reply-To: <Y4N9IAlQVsdyIJ9Q@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 10:21:27 +0900
Message-ID: <CAMZ6RqJHFyeG0ZMaAAfJ_30t-oucJVm05Et-H9DEgzbWj-K6vA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 00:08, Andrew Lunn <andrew@lunn.ch> wrote:
> > I checked, none of gcc and clang would trigger a warning even for a
> > 'make W=12'. More generally speaking, I made sure that my driver is
> > free of any W=12.
>
> That is good enough for me.
>
> > I do not care any more as long as it does not result in
> > undefined behaviour.
>
> Agreed. Hopefully sscanf cannot go completely wrong and go off the end
> of the buffer. That i would care about. Bit i guess the USB fuzzers
> would of hit such problems already.

On the surface, the sscanf() seems OK. It will break the while loop
when reaching the end of the format:
  https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L3429
or the end of the string:
  https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L3501
(I am skipping details here, there are other branches that will break
the while loop and all of them look good).

And me not being the first person using sscanf(), I hope that if a bug
existed, it would have already been spotted by some static
analysis/fuzzing/code review :)

That said, I think I answered all your comments. Can I get your
reviewed-by or ack tag? Thank you!


Yours sincerely,
Vincent Mailhol
