Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE40498561
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbiAXQzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbiAXQzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:55:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AA3C061401
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 08:55:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id s5so23060697ejx.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 08:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=udfeJeFdx79BvfFLrEjgmFb8M0Tn21AoYYUBDKALlWc=;
        b=UzcDcwTvS13I+piOHSwWQhmPbTITcxNsS5npXnenI8oDfSriT0Hw5m8qi9nxNStSsg
         9ucHVE3dujYHwEVKbZ2ULnepfaP8IcqatFkS4NGisX5Uv1+s8eEjHp88HSGAcRdbeSG1
         r3Pxz4uk8kpO8xdUlK3PZ7j2lL4lFeC9iTmmNkgdlSPY9HmFZqxe5oxzf+ZiJKxnMlgy
         fm/5RG7JyccAlZHfTooDE//2I66+s1pXU1YrBbCA9RveaDWAAIIw4mXQbRbzxQo4Xcyb
         GTmADfXLHNeWhbUbfJ30Z4oIKIubP68GA8+LTYxsng6FEc8reH3h2r0THb70Ec8tTwsT
         qvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=udfeJeFdx79BvfFLrEjgmFb8M0Tn21AoYYUBDKALlWc=;
        b=cfXLyKHv7/WieKzP498uSvOqdhPVmQKcqvWti4GRmeI2SYpO1JerPJ3p46yucMyUbe
         gHxJ4yTy0gqj6OYexQvU65L3wCpZsUhGP29nG2NHOxHn38IU8ygPwog6as0T4VtgWv8+
         s4SNjJM74BQJlEk/MMGk3SXWQSNFv46FW+QQPywRNnbsnA7G3gATAVSUXxJKKxOnj4vg
         L5tHU3ijSuKVb8Rk5glpHFDFPdiz30XRX4TRIvx5D+MKALC+m3Q8Ku93vngYqRp2FCMa
         3tRsTrPRh3Ig7zgqBSLQS2LIUUNJ5A9B6bjatV6Jl6/U468W9aih8bTA47ZO/bBuCl30
         7Dpg==
X-Gm-Message-State: AOAM530uwZDRTW3x9FD0Pf6SPGg0XiXwAKoueGoJRZvLbG6q2wYxMdgO
        D2HqhHltHwxj2N+A0eebAJw=
X-Google-Smtp-Source: ABdhPJyIgAt/nePvCd0KfJuDllTZ3BZE8cTr1h07QAQ/oXOtGcTUZl1OILI02qgMbLDsprSvKGteEA==
X-Received: by 2002:a17:906:9b8e:: with SMTP id dd14mr1651283ejc.413.1643043337067;
        Mon, 24 Jan 2022 08:55:37 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id c22sm2061624eds.72.2022.01.24.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:55:36 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:55:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220124165535.tksp4aayeaww7mbf@skbuf>
References: <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 08:46:49AM -0800, Jakub Kicinski wrote:
> I thought for drivers setting the legacy NETIF_F_IP*_CSUM feature
> it's driver's responsibility to validate the geometry of the packet
> will work with the parser the device has. Or at least I think that's
> what Tom was pushing for when he was cleaning up the checksumming last
> (and wrote the long comment on the subject in skbuff.h).

Sorry Jakub, I don't understand what you mean to say when applied to the
context discussed here?
