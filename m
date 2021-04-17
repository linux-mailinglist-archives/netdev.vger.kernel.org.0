Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A9A363075
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhDQNzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhDQNzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 09:55:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52606C061574;
        Sat, 17 Apr 2021 06:54:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i3so9824754edt.1;
        Sat, 17 Apr 2021 06:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwbXOEfw/hpTzD4hhTkstPphtWsfZTra37TCCCrtY84=;
        b=sPI3XPceh+wzpsQW6flE9OtViinFEbi/tneD3luRPZoawpv9l7XAmkkdUG2ChVygdE
         whv2VOrrWLneqFlT4ejHnVmHfHjPzCfbkT58gjCuI4CuimVgu9Sr4UXddlUCghDxO5IU
         mTr50e8nUf1LEDJXyXT/GrEfuqIK77XI4vaRAVwR0SCii5bpGE3p+xto+o/7R/hPmHYr
         cwAOwPYQOeadpxLa91ZVNBOtJ+H8SQ8leIzF+Ya6Do5RTNpLe0ZseUUS0rswfTH/FyRm
         cNn8binRD3E7KCpTB1ncWGW6hRilDUbADBzG4fI5eNl5g+jz0okT8tgNZ7a12zUeCGKF
         nelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwbXOEfw/hpTzD4hhTkstPphtWsfZTra37TCCCrtY84=;
        b=MZ0eajFAv2hVaB9Y4Rw0IptJbGahUo1LgPUjONr9jLL4er0wzN3G8ElMpl9CZs14bp
         1RPkaRiUGmKnvYgqXtJZOCzp9L17QTQnnLFiljW1xuE/AJQgy1zhFzyGeRtF6C++PeuU
         Vc0A7MDztAH6KvM7M4Nts6O6wr6LthK+DviJTYD8nzYu+JisryCt/S87/79dQbgZEBKG
         mBffsIA58HmioJq5cWrVm2qxRHcuMOCK0aZ0GdqArUt0Yxz5Xmqhse+26E+1MIvz3Fsa
         47TU6aKFXbWZexobTk7wTzGpnUCZgwcbTkRG9lGIyDFpSqMpJVD4pucDNv08/hnx3+VN
         uOjg==
X-Gm-Message-State: AOAM531KntlBVju4QB3LFH74uHhK/S3+WQLQlwTCtjVRT1GGSAujZSpy
        7zOAocnrSkK2Mu+csncxzKvtGaT2Edl+oedkG2k=
X-Google-Smtp-Source: ABdhPJwphSsgjfmY6bf7Zp5OmyrMvNCEsUL9E55kZxOq+KCz976opRnejwfP8hrs6KBMVnkjvAEm4KIvo1nhTS50/gM=
X-Received: by 2002:a05:6402:382:: with SMTP id o2mr9326951edv.370.1618667690889;
 Sat, 17 Apr 2021 06:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-5-aford173@gmail.com>
 <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Sat, 17 Apr 2021 08:54:39 -0500
Message-ID: <CAHCN7xJrmQgC=skC7UJuzshUnf06D4nHrv1grrW8QV-+07dgKA@mail.gmail.com>
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

Geert,

Since the refclk update and corresponding dt-bindings are in net-next,
are you OK applying the rest of the DT changes so they can get into
5.13?

adam
>
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
