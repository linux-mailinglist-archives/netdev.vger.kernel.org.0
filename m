Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008B430AFBA
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhBASqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhBASpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:45:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C39CC061573;
        Mon,  1 Feb 2021 10:44:57 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a9so7620090ejr.2;
        Mon, 01 Feb 2021 10:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8+WtpLzvSzCDusr/oGZuPfG2Y+S6t2NjXiqdDh53xI=;
        b=WFoOdTVj2gp2KTDmDJs4HV7BYqQnNJAtqKBw/LQ6rD7exQQiONehNZk4oqRZ9gWRxf
         bjPgHAyWJpv4d/BQ3w/UoqDYpoEexCz6CWf134r/8SAr86FG2/y8a0ul8m8QHAG4MILG
         xvpsAxQ3j9E+Uwd/dOpURhtH8ddckYjG3z4CVUZ/y6CdqApNkdIb32SslEHz+0fYv4cw
         fc+otZBQd/bryGudPelUTWV7JuodWchU3cNg88u0GkjgD+w5s2f6HYBeOUUuXgyQuP42
         NgFqg+aqy1L2v0+He8QiFdSGf/i8YeiEyJbjJdPEdm+SoaVq390m89pPoQWLWpCZq3nQ
         N2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8+WtpLzvSzCDusr/oGZuPfG2Y+S6t2NjXiqdDh53xI=;
        b=UNVKmFB4wvgNOCC26h6FgbFHNjp1yRDhRIaNROQRGC+O9Y0WoXzn7M/rYYhvFcny4p
         47jJCBWL3qqMxHDVSBBt6sdTrPcsagvnmI2pB1828I6gEHsP9jb0Y0Eco2TIFCJze1Ca
         kyqEGXcfGY1hRZaHS82An2HaRemSGfRa+RctOJ+bK7vsBkiGJ3DpG+TO1zV4H9tS60zj
         8MjTK+ecmY56YAaDbj40ynCwJl+eMg/6hOEl2RA+AhQLS1dAwhLAs9H6fSKiWNkiunhs
         e/Fgw5C5nyuPXujk9Wj9IB5IdnzuO9K7vmjT8Wa3M4k2p084tuDkftX8cs8eJ03hR1ng
         fkVg==
X-Gm-Message-State: AOAM533ULo1l79jPHpGakdZ9BK2oPLSQe5DVbmWawC9EOKlxHinYIYZV
        oNlFqQUtKubbIxYVKqLFVb58TEgmjADXuNufV88=
X-Google-Smtp-Source: ABdhPJwGcBcVEQNitkcUvllYju02Dp0PjxrUiOHQfslGGui/UdGyJIzfVQMgvlbIlqnR/HEH+pcgOsNES5MPWqfsUnQ=
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr19304966ejt.56.1612205095839;
 Mon, 01 Feb 2021 10:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20210201172850.2221624-1-elder@linaro.org>
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 13:44:20 -0500
Message-ID: <CAF=yD-LerEd9ZyLSFOaW3JqjvWUrp5L0jVvyuJU56atmT=G1oQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/7] net: ipa: don't disable NAPI in suspend
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

On Mon, Feb 1, 2021 at 12:28 PM Alex Elder <elder@linaro.org> wrote:
>
> This is version 2 of a series that reworks the order in which things
> happen during channel stop and suspend (and start and resume), in
> order to address a hang that has been observed during suspend.
> The introductory message on the first version of the series gave
> some history which is omitted here.
>
> The end result of this series is that we only enable NAPI and the
> I/O completion interrupt on a channel when we start the channel for
> the first time.  And we only disable them when stopping the channel
> "for good."  In other words, NAPI and the completion interrupt
> remain enabled while a channel is stopped for suspend.
>
> One comment on version 1 of the series suggested *not* returning
> early on success in a function, instead having both success and
> error paths return from the same point at the end of the function
> block.  This has been addressed in this version.
>
> In addition, this version consolidates things a little bit, but the
> net result of the series is exactly the same as version 1 (with the
> exception of the return fix mentioned above).
>
> First, patch 6 in the first version was a small step to make patch 7
> easier to understand.  The two have been combined now.
>
> Second, previous version moved (and for suspend/resume, eliminated)
> I/O completion interrupt and NAPI disable/enable control in separate
> steps (patches).  Now both are moved around together in patch 5 and
> 6, which eliminates the need for the final (NAPI-only) patch.
>
> I won't repeat the patch summaries provided in v1:
>   https://lore.kernel.org/netdev/20210129202019.2099259-1-elder@linaro.org/
>
> Many thanks to Willem de Bruijn for his thoughtful input.
>
>                                         -Alex
>
> Alex Elder (7):
>   net: ipa: don't thaw channel if error starting
>   net: ipa: introduce gsi_channel_stop_retry()
>   net: ipa: introduce __gsi_channel_start()
>   net: ipa: kill gsi_channel_freeze() and gsi_channel_thaw()
>   net: ipa: disable interrupt and NAPI after channel stop
>   net: ipa: don't disable interrupt on suspend
>   net: ipa: expand last transaction check
>
>  drivers/net/ipa/gsi.c | 138 ++++++++++++++++++++++++++----------------
>  1 file changed, 85 insertions(+), 53 deletions(-)

Acked-by: Willem de Bruijn <willemb@google.com>
