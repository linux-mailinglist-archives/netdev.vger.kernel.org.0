Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE773405DF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhCRMo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhCRMow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:44:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4C8C06174A;
        Thu, 18 Mar 2021 05:44:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l1so1247720plg.12;
        Thu, 18 Mar 2021 05:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9rE0tJpznlr6Ns/VvU6BMZweoj02KtdTWNNDOyyeFE=;
        b=G552MO7zcD7RYfTHJ4kCT7C874hod2hJkzRBsqtBJtRTU9px+61TW9VyaoADGYNtHZ
         pTja+//z52v7Ek7xavQtHZ9sysyFA+ED73lFSadoEJncd3ApOhPldvH+Gk3lQplQ94xi
         aeMfjPAHyzX61z1PmOGRN+5G71qMu5Yb3FOlAwP2W/ixGDLbtHuIIfWVW/u81FZ7WJN0
         v/J3x5IrZGVsw+OCRb7OF0mX5l3ajZwIWQUNQPaXnA1897TU/klaxTfCpktTOorqiHFY
         VZDkB/HNvTSvWjgm2Nw+gsw91s93ZQgBYMN77ZHH/PNHaO1pve+E0JgCNPblvpPBNp6M
         Yk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9rE0tJpznlr6Ns/VvU6BMZweoj02KtdTWNNDOyyeFE=;
        b=fUWCs636gUec41SumMgQZ2ZVAOnt4rP0WHAyACfEprTZZi1/yUPNE4563RrXeGU0P9
         GLlQV6WWBLfZ645V9ha+wPeAh4B0N+GTV1fOwDlO9WefKqnl7Ta9TuonB5x37D2hMYfb
         f3quBePmTV3WqJyDlEsszZzLUNOEJv+eNcaACB8hNJRqsyCUFF9ry+ZPrnWx7dZ6ec5m
         Xc5Aa+x+cl2BAGvU0WEdkrlo4WOR9wONgdZLQ0EqAAew5xuZ0o5rn13FZHL+/kZBK2lV
         ++jhRQ2bo+tvGpZitgGE1m+fFyVaikOti0+BAwAx1wYTaB4vpOddEqcxIGUsT+2lkrL4
         qpHQ==
X-Gm-Message-State: AOAM5329Usb+4nft1hu8PvwjOEzbvvDkG+esHor5/Bq7a3x5pKZOfP6L
        /ciDN6kpjZUuQL169SQhvGT1zMqenh3ryiK6HdU=
X-Google-Smtp-Source: ABdhPJya+MwPUimZnTCuEi8Fb+6qYbFJpRxFCYiMhyPih+jRE1gLYp2PIvEqb8nl5AjfwDw72YJHd5TXk8M5r79+AT0=
X-Received: by 2002:a17:90a:5d10:: with SMTP id s16mr4259176pji.126.1616071492251;
 Thu, 18 Mar 2021 05:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-5-aford173@gmail.com>
 <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 18 Mar 2021 07:44:41 -0500
Message-ID: <CAHCN7xLtDyfB5h5rWTLpiUgWY==2KmxYCOQkVSeU8DV8KB-NKg@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 2:04 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> > The AVB refererence clock assumes an external clock that runs
>
> reference
>
> > automatically.  Because the Versaclock is wired to provide the
> > AVB refclock, the device tree needs to reference it in order for the
> > driver to start the clock.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> i.e. will queue in renesas-devel (with the typo fixed) once the DT
> bindings have been accepted.
>

Who do I need to ping to get the DT bindings accepted?  They have an
acked-by from Rob.

adam

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
