Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641F321F18F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgGNMjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:39:54 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33142 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgGNMjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:39:51 -0400
Received: by mail-ot1-f68.google.com with SMTP id h13so12929224otr.0;
        Tue, 14 Jul 2020 05:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1gkM+uPTnitshLBuV08goagb6Ra5DyU+s9EwRHXtZeQ=;
        b=mfkgj4eGLF/mS6HqwU2jRhvquP2KbIWOqQVHucEbNhtAlIGrgbXdXbsPnTkayf14FE
         oQg/z0nbq0N+stgN7htDaEcBL5b8DITSlN2vdoPC/vnB3zkOh6sRIKIDyXcD/1Lhgpx7
         m+8MBQqD39qOni3D0FQ2zPI0yLuLo/dvpXpuVO8fTJCWIv33HKy4tP1k5rwtAIhtdVpv
         UaVqpCj6ZFTqN4K68xtGjsnmaVhCwf5aMHL/Xha/LRqNAcGfXsOX9uM8yCjmJAKJPaH9
         5/ifjivkwWjaZvYMaZXQ2q80AIvuA3d9wqLnZCear2qONGYWSW+PuDfaQGwbDI7nK4AI
         Mg4A==
X-Gm-Message-State: AOAM5326I/hh7zqgBgwJ88VvQbW6sEr26AX/NfYV4yASaSuSSOLlPDNM
        yHg8earbspn+2BzeO70WnYQNYum9VJMV/FRyviQ=
X-Google-Smtp-Source: ABdhPJwQEGIYICCEl9+rMfVmtnnA3KEy1Oav7DAM0WyYTDfpBWgrg5GEkZrfN+c/weUUf5GnvXRjVxzrNetFysb/vow=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr3637009otb.107.1594730390491;
 Tue, 14 Jul 2020 05:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV4zzrk_=-2Cmgq8=PKTeU457iveJ58gYekJ-Z8SXqaCQ@mail.gmail.com>
 <CA+V-a8tB0mA17f51GMQQ-Cj_CUXze_JjTahrpoAtmwuOFHQV6g@mail.gmail.com>
 <CAMuHMdXM3qf266exJtJrN0XAogEsJoM-k3FON9CjX+stLpuMFA@mail.gmail.com> <TY2PR01MB3692A868DD4E67D770C610E3D8610@TY2PR01MB3692.jpnprd01.prod.outlook.com>
In-Reply-To: <TY2PR01MB3692A868DD4E67D770C610E3D8610@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 14:39:39 +0200
Message-ID: <CAMuHMdUry12MnLvVgmd7NJ+Gv4mA86qKKfsQobP1o-ohzKm=RQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-san,

On Tue, Jul 14, 2020 at 1:42 PM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Geert Uytterhoeven, Sent: Tuesday, July 14, 2020 5:42 PM
> > On Tue, Jul 14, 2020 at 10:30 AM Lad, Prabhakar
> > <prabhakar.csengg@gmail.com> wrote:
> > > On Tue, Jul 14, 2020 at 9:09 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Mon, Jul 13, 2020 at 11:35 PM Lad Prabhakar
> > > Also the recent patch to add
> > > "r8a77961" just adds to soc_rcar_gen3_whitelist.
> >
> > Oops, commit 17fe16181639801b ("iommu/renesas: Add support for r8a77961")
> > did it wrong, too.
>
> Thank you for the point it out. We should add r8a77961 to the soc_rcar_gen3[].
> However, I don't know why I could not realize this issue...
> So, I investigated this a little and then, IIUC, glob_match() which
> soc_device_match() uses seems to return true, if *pat = "r8a7796" and *str = "r8a77961".

Are you sure about this?
I enabled CONFIG_GLOB_SELFTEST, and globtest succeeded.
It does test glob_match("a", "aa"), which is a similar test.

To be 100% sure, I added:

--- a/lib/globtest.c
+++ b/lib/globtest.c
@@ -59,6 +59,7 @@ static char const glob_tests[] __initconst =
        "1" "a\0" "a\0"
        "0" "a\0" "b\0"
        "0" "a\0" "aa\0"
+       "0" "r8a7796\0" "r8a77961\0"
        "0" "a\0" "\0"
        "1" "\0" "\0"
        "0" "\0" "a\0"

and it still succeeded.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
