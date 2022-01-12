Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18F548C216
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352437AbiALKQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:16:52 -0500
Received: from mail-ua1-f50.google.com ([209.85.222.50]:36590 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346644AbiALKQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:16:50 -0500
Received: by mail-ua1-f50.google.com with SMTP id r15so3815227uao.3;
        Wed, 12 Jan 2022 02:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AaBS9lcIpGiYplkxy0SH9H40GoB4xDcu3Lw4CJ5mNt0=;
        b=2nEbHJL9sx+xgYMcS09fY/YnmnVDsehlBC6WbvRY9oyBZ/BU84FV5Scm40SXiHtVhA
         KVm5eLrktAxZveBdij+OCmmihbY9oo34dDvdrN2zpfiNQrLXBy/fTgxgjgk/V2YT+uFl
         HQ3xg3iHS39EPJDJoCvLOlEcgZlFQzJQdDZ7S8OAGWz/d45padGCpO120QKrnW6iCyv6
         19kq1fcwTTlSWkaXFZKLX9escCB28mu1lGkWDmtYqKjv2pj4QmbSUN6jGyYkV93j4iZh
         DVKTaySX0FO8uDvCXz/FJTcP6+ebiYD6dZLMgpxx5m6xWLi6iMx4dHI+tPpW2S3Gtaps
         BK9w==
X-Gm-Message-State: AOAM530t5THOlWDshIQOMaslmLtABLZF9ctQNF4ahnIV4bxKWwcdoXzj
        vn9i6OY3CgHZrTuRcSBVQ0SOQEM+tJp5BHUu
X-Google-Smtp-Source: ABdhPJy+j2vW7lELJMM4EDnk50EdyRDggDR+FbGVROyzlSS088jjylDkMTAuYoYKNtrd5Nh+eP4gzw==
X-Received: by 2002:a9f:354f:: with SMTP id o73mr3934081uao.115.1641982609105;
        Wed, 12 Jan 2022 02:16:49 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id a190sm2431532vkb.15.2022.01.12.02.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 02:16:48 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id m15so3773288uap.6;
        Wed, 12 Jan 2022 02:16:47 -0800 (PST)
X-Received: by 2002:a67:e905:: with SMTP id c5mr3674091vso.68.1641982607735;
 Wed, 12 Jan 2022 02:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-2-uli+renesas@fpond.eu>
 <CAMuHMdVs=NWR1bRuTku09nWT+PyyVCM6Fp1GVu5brCj=VjZZ-g@mail.gmail.com> <387311382.2900483.1641977755599@webmail.strato.com>
In-Reply-To: <387311382.2900483.1641977755599@webmail.strato.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 11:16:36 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUnQLKZhAvaOJKeoG7yF0kG14LX20KqehadH-gbW1B9_g@mail.gmail.com>
Message-ID: <CAMuHMdUnQLKZhAvaOJKeoG7yF0kG14LX20KqehadH-gbW1B9_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] clk: renesas: r8a779a0: add CANFD module clock
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Wed, Jan 12, 2022 at 9:56 AM Ulrich Hecht <uli@fpond.eu> wrote:
> > On 01/12/2022 9:44 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > --- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> > > +++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> > > @@ -136,6 +136,7 @@ static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
> > >         DEF_MOD("avb3",         214,    R8A779A0_CLK_S3D2),
> > >         DEF_MOD("avb4",         215,    R8A779A0_CLK_S3D2),
> > >         DEF_MOD("avb5",         216,    R8A779A0_CLK_S3D2),
> > > +       DEF_MOD("canfd0",       328,    R8A779A0_CLK_CANFD),
> >
> > The datasheet calls this "canfd".
> >
> > >         DEF_MOD("csi40",        331,    R8A779A0_CLK_CSI0),
> > >         DEF_MOD("csi41",        400,    R8A779A0_CLK_CSI0),
> > >         DEF_MOD("csi42",        401,    R8A779A0_CLK_CSI0),
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > i.e. will queue in renesas-clk-for-v5.18 with the above fixed.
>
> Don't do that! There already is a DIV4 clock called "canfd", and using that name twice breaks stuff. The BSP calls this clock "can-fd" for that reason.

Thanks, I stand corrected.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
