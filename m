Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7110B3BE
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfK0Qo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:44:59 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:40960 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfK0Qo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:44:59 -0500
Received: by mail-vk1-f195.google.com with SMTP id p191so4285549vkf.8
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLduStRhUgw//fIV8vy/vD9GbKcVyTQ44unSzDqK0rQ=;
        b=dmXdbPgeTVz99a7k5et7WG3Ku20W+5kMGnuu7sGgQM7iozwlXTdJG5SoVMCZRhavdL
         HvoiPalidifJZuKMpNStgi32ghEj1pmSdYl13aGKH3Rb2j784H+bT91YtxcbzzicGL8X
         LUznJaWmCVlNUNjQ21hTwv26HG+DUTALiMUvu6KCNSpiJfayaHUez0FTaGtxoTHSEmr8
         neBQT6oNycBwhZGcgsuv8KF3qnZ+lXRECnprIBbcJDQglZlQ3VQ0vbiDwNW05Jdh+p2O
         57+TquqTABTtByXJ9Ehgol+WqRPyZhF9vWYcWjEH+mc9TlwPGSeUgZ2VDK5WlGxkfY78
         cn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLduStRhUgw//fIV8vy/vD9GbKcVyTQ44unSzDqK0rQ=;
        b=FxYRUmG13Sn6XAq6d4RdZ/PF81wxGmRr+64Cx/PJEf3aJ49VEsdgdPs7Z79WJNCE6N
         T5Y3/HiYT1alp/y2ffPn5LseuAm/OYTQhNC0YDqbObnLs9kVvLEUzhUJkyCVdcezLRYS
         v449Oo+K0SmwpqXdhaNX52T7G+r3Vsgt3wvCK4UPMbJOltWJGYf69TEXhicyKBDKs+Ie
         TTDMAmh1OlXEsuDeCzyNz1+gXViRzdXLO5Mj6AhMVgAzV1MZbaU/lzXa1QYC1tsLNmCH
         1AQcVgWZmdWPNhGoU9adSLwffUqDzzomFyqvP0vVm8oP+cBlLWUICNaQr1/fdsd1+AXq
         syXA==
X-Gm-Message-State: APjAAAVIwZ4vQleiOmvMC4rhK98bzTxjCtZ4Wlmvk4V83atCsIzUsJwo
        NaTFAwGu5fTWGasJZfxZpPXMUd8d+htyWDt7UvfXqg==
X-Google-Smtp-Source: APXvYqz8EV/fgCRGfDaSavf/FFlDhi8zP5CuDNfYntpzGwDZ70yJs67BXTRWoUCqqWpyaMzeOKT7Y3aoO31ZLYKOYAs=
X-Received: by 2002:ac5:ce13:: with SMTP id j19mr1474716vki.97.1574873097533;
 Wed, 27 Nov 2019 08:44:57 -0800 (PST)
MIME-Version: 1.0
References: <20191127052059.162120-1-brianvv@google.com> <20191127082655.2e914675@hermes.lan>
In-Reply-To: <20191127082655.2e914675@hermes.lan>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 27 Nov 2019 08:44:46 -0800
Message-ID: <CANP3RGctgy98FsyeHq+aVk2S=N8ndY0Y+qMkZUhTB=26H_Y3Rg@mail.gmail.com>
Subject: Re: [PATCH iproute2] tc: fix warning in q_pie.c
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What compiler is this?
> The type seems correct already.  The type of double / unsigned long is double.
> And the conversion may give different answer.

Probably some recent version of clang with -Wall.

That said, I think the warning/error is correct.
UINT64 doesn't fit in double (which is also 64 bits, but includes sign
and exponent) - you lose ~13 bits of precision.
I'm not aware of a way to (natively) divide a double by a uint64
without the loss (not that it really matters since the double doesn't
have the requisite precision in the first place).

Why do you think the conversion will give a different answer?
Isn't this exactly what the compiler will do anyway?
It's not like we have long double anymore...
