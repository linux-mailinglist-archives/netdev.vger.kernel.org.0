Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7E486A34
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbiAFSzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243082AbiAFSzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:55:24 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C747C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 10:55:24 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id y130so10110343ybe.8
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 10:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bYklUVQjHe1AjfBK1kYtqPoo415C0s9/LvGvTkzvUnE=;
        b=erG93Ur1E+iWw7UoTMag8a89H6GTrwAzsH7/iIb+Ap1Sg+C16xVUay2wVQ+DiRf5x1
         0H5ncxmg1xw4OE9Ebq0cThoONH6ZZs2bsuIQ/lj5xEFAqB+9Ni81SIkGzjflv25IOiiI
         ET53TZ9IAC5m7Htd5f4Y+1vSezvIZxJ8EC+qTeVN6xjCX33fV/tCfx3AwBGClrTIBQMP
         dao34nZeZorQVYuqLslOJNQ68tj/lUBbilZr56SwZl0UNFTykkhrW0WNyAs9+axFHNEa
         7kxKfaIRGcjEAQkbmPviiyJ40pd67knUF9x/qf96BUDxt8Ck05S4K4IDoxlDYxr14EaP
         NeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bYklUVQjHe1AjfBK1kYtqPoo415C0s9/LvGvTkzvUnE=;
        b=WrsgXWXSux1fj6YzMDuFA9ipxzkxX8KPyG/yt2XQ01rvvfzS42NHA4spbtDFi+bbzF
         DdY6LfWaqclATsYQoZ5+t3m6rGnhxcviCayHJDsWBXR2Iswwjt800pMNsli/mHW0/Wzy
         VZXtNDXIhqKu0DFFaUni3dQAJDBHMWBSv1QvFuAQ8BkPTXSHpAzdnETV1Lw2ILnORW0l
         FkQ3LbLFgWn7o4NNTAN52JWoTOkakBSuuAidsROIcd/u4oBHRSq2gjapJBqBvsOs4j/l
         Mihxcg3E9VSaZjUcXCVC/AxpaeIJBIZHrd6ZWok/3+IhMYH6nCKtweHTaYuJ1EMLuUyf
         pk4A==
X-Gm-Message-State: AOAM533qAFH9edlsGH610QiMAvCQ5gb6veVePzAuzBd87fZKd9jp+5V/
        jlaEaYvvKyfKp5U/4cvOclMqQzaYFUznGKvHFFZRQA==
X-Google-Smtp-Source: ABdhPJwP7IoP7NjRDzy6p2ZfiXQERQTg7y1bsLXHR1HfXsnuH67L4XK1GX2wGhd4FGF7AXhCrc6Ab211f51ySRHvsjM=
X-Received: by 2002:a25:a06:: with SMTP id 6mr2351823ybk.5.1641495323045; Thu,
 06 Jan 2022 10:55:23 -0800 (PST)
MIME-Version: 1.0
References: <CA+wXwBRbLq6SW39qCD8GNG98YD5BJR2MFXmJV2zU1xwFjC-V0A@mail.gmail.com>
 <CANn89iLbKNkB9bzkA2nk+d2c6rq40-6-h9LXAVFCkub=T4BGsQ@mail.gmail.com>
 <CA+wXwBTQtzgsErFZZEUbEq=JMhdq-fF2OXJ7ztnnq6hPXs_L3Q@mail.gmail.com> <CANn89iKTw5aZ0GvybkO=3B17HkGRmFKcqz9FqJFuo5r--=afOA@mail.gmail.com>
In-Reply-To: <CANn89iKTw5aZ0GvybkO=3B17HkGRmFKcqz9FqJFuo5r--=afOA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Jan 2022 10:55:12 -0800
Message-ID: <CANn89iKBqPRHFy5U+SMxT5RUPkioDFrZ5rN5WKNwfzA-TkMhwA@mail.gmail.com>
Subject: Re: Expensive tcp_collapse with high tcp_rmem limit
To:     Daniel Dao <dqminh@cloudflare.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 10:52 AM Eric Dumazet <edumazet@google.com> wrote:

> I think that you should first look if you are under some kind of attack [1]
>
> Eventually you would still have to make room, involving expensive copies.
>
> 12% of 16MB is still a lot of memory to copy.
>
> [1] Detecting an attack signature could allow you to zap the socket
> and save ~16MB of memory per flow.

I forgot to ask, have you set tcp_min_snd_mss to a sensible value ?

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=5f3e2bf008c2221478101ee72f5cb4654b9fc363
