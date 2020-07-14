Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E46F21EBA5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgGNImB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:42:01 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37554 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgGNImA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:42:00 -0400
Received: by mail-oi1-f193.google.com with SMTP id 12so13327377oir.4;
        Tue, 14 Jul 2020 01:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQnzKz3C/NevNjTlEZYFL5iXV3ehjQViqfoH5iOv3SM=;
        b=ZXEtkG+Wam84TPU/nvD5Wwj0MonII4buXn2A4y2s2Y3L2GtprWNx7EMJra5L96QT3j
         nYkx05Idwq6j8lVh6THDI51bJcoVcNQyhnTAwqu3s4wAG8EwM6/RIEHUxIfZMJbLtAz2
         BbmSP+zeSy3UCs7hwqg6Lg4Bx+7nxxlQWQXVu954QqC11CEGD+DWVxQeU1OZzrMte7QF
         V2yhiILIg1hgILs0AUkd8TCG9602QltCBIQ4Xonhhws6xEt751XZQIxhb0GRwfuxz2ql
         Fixvq4PJMegWvuR/NEpBgR5/4FoFInxyGsYQsz7rBDwKBB4TBDUpezEtgA9feW0XHMni
         TBdQ==
X-Gm-Message-State: AOAM531WbWsLPXEW/IpMQASLjoDCmgt9XphcndZaHn/JFRcW7JeB3RcT
        fCxCDUy0rVsnpO0glmEowRgJOBNtlQivzD97c/U=
X-Google-Smtp-Source: ABdhPJwxHQ4k7EDiUkAc1gcDGSS4Uw8Rp1iYZBGwEma0KUZbSrLDof4x63mIGl3zVqSk/DDgD3zmVlx4dejHfmNAQO0=
X-Received: by 2002:aca:ac10:: with SMTP id v16mr2626302oie.153.1594716118642;
 Tue, 14 Jul 2020 01:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV4zzrk_=-2Cmgq8=PKTeU457iveJ58gYekJ-Z8SXqaCQ@mail.gmail.com> <CA+V-a8tB0mA17f51GMQQ-Cj_CUXze_JjTahrpoAtmwuOFHQV6g@mail.gmail.com>
In-Reply-To: <CA+V-a8tB0mA17f51GMQQ-Cj_CUXze_JjTahrpoAtmwuOFHQV6g@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 10:41:47 +0200
Message-ID: <CAMuHMdXM3qf266exJtJrN0XAogEsJoM-k3FON9CjX+stLpuMFA@mail.gmail.com>
Subject: Re: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
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

Hi Prabhakar,

On Tue, Jul 14, 2020 at 10:30 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Tue, Jul 14, 2020 at 9:09 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Jul 13, 2020 at 11:35 PM Lad Prabhakar
> > <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > > From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > >
> > > Add support for RZ/G2H (R8A774E1) SoC IPMMUs.
> > >
> > > Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/iommu/ipmmu-vmsa.c
> > > +++ b/drivers/iommu/ipmmu-vmsa.c
> > > @@ -751,6 +751,7 @@ static const struct soc_device_attribute soc_rcar_gen3[] = {
> > >  static const struct soc_device_attribute soc_rcar_gen3_whitelist[] = {
> > >         { .soc_id = "r8a774b1", },
> > >         { .soc_id = "r8a774c0", },
> > > +       { .soc_id = "r8a774e1", },
> >
> > Adding an entry to soc_rcar_gen3_whitelist[] doesn't do anything, unless
> > you also add the same entry to soc_rcar_gen3[].
> >
> I think the comment "For R-Car Gen3 use a white list to opt-in slave
> devices." is misleading.  Booting through the kernel I do see iommu
> groups (attached is the logs).

Indeed. Without an entry in soc_rcar_gen3[], the IPMMU is enabled
unconditionally, and soc_rcar_gen3_whitelist[] is ignored.
That's why you want an entry in both, unless you have an R-Car Gen3
SoC where the IPMMU works correctly with all slave devices present.
Perhaps soc_rcar_gen3[] should be renamed to soc_rcar_gen3_greylist[]
(or soc_rcar_gen3_maybelist[]) to make this clear?

> Also the recent patch to add
> "r8a77961" just adds to soc_rcar_gen3_whitelist.

Oops, commit 17fe16181639801b ("iommu/renesas: Add support for r8a77961")
did it wrong, too.

> > >         { .soc_id = "r8a7795", .revision = "ES3.*" },
> > >         { .soc_id = "r8a77961", },
> > >         { .soc_id = "r8a77965", },

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
