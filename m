Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8182C29279C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJSMpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSMpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:45:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68848C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:45:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z5so4151510iob.1
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXK9ReYKLbFXy8GK/doeVSVXt8TVCpNY9PBdu8b006U=;
        b=iyWQIvbEcahZ3R8GikudW78qOTnMxxaB0/U28nKQa7fDkar5m/SparjevdyoEgogqR
         6ZXlYn90OI0Q/kIic0TWgxovBtRQO6ceUOS/fbSHYGMzK3QMzzV4cnT88FTzkLndKm6B
         YA1ej7AXkjhOf5lSc7L6KE9l9gfWXP6benpzhiWJDR5zBKtWtkr+nEXHIOqsT3g2H09I
         q/ininQ0C1GOyl/BVbXBjd8j8CakJAjrlf34O3LoSwBY8LTmO1k3jUWKqzHnBUxt3Wxn
         5xWS9h6OXu8kDZ5h7YLzKnNhICBdydqonNwBlQXA3Kkivw+rCaIe7wXccUPeCsa+sv+N
         cMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXK9ReYKLbFXy8GK/doeVSVXt8TVCpNY9PBdu8b006U=;
        b=kHzxIyZ3E4mbWb501npmWIBDEFtVepll8QFL+64/JRa9SkyIwlVoZxRsKU4DGy3CFI
         dkn0ouD7xMBP7sH2x7wvit1ovU2ujznLVdnxeaTo9RgowGQDrAAUhhbji6mmlu4uJyGk
         3gQy0GTIusahX7tH3iy7lj7Jq24mbFZVb+er/SvoLBOIevplHK1/AAYoSHJ8mu9DKrR7
         ef9fxSFIpYnXaJGcM0PNDrO62Ka19pNLv2y9fjemLGJKY/47iFnSM7+WGDp+9p5q1h/0
         e/cpACzXdqmaqCysKT6Kc79i0uVBti6A7TbB+JusCtxvvH0yIRgCuhDn3KRbDYnh+2ZS
         uGLQ==
X-Gm-Message-State: AOAM530OFaGi4ZdUG4CQM0Ug+NXM3JxzP2sFbSIMGYel4kKSU46Evl99
        VU7popbUzHvJAhVi/PBEhoW9YgUmIFKIXVUsHV0=
X-Google-Smtp-Source: ABdhPJwjerD7M29kMu0ngai6+IRlM9dmpQI24b6Qo3i+8j9GlhYNK2G1w54JwXmkN16msUErvTKWfT8ihuN8fCFBMdw=
X-Received: by 2002:a6b:4e16:: with SMTP id c22mr10574132iob.26.1603111517866;
 Mon, 19 Oct 2020 05:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
 <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
 <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
 <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZurSx8JJj0cQ3dghXO0wesfNm0cS5tmzn_JrpM3wm9W3sQ@mail.gmail.com>
 <20201016104851.01ac62f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupNF-k-iAY2jO3JOWvdAMUQG_EAkgBWicYkutsWR3f-3Q@mail.gmail.com> <20201018091130.016f651f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018091130.016f651f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 19 Oct 2020 18:15:06 +0530
Message-ID: <CALHRZuq+_CojmKZgrNdzM0LSA4tn9jgpyk2m3F-j=87vM1FKjg@mail.gmail.com>
Subject: Re: [net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        rsaladi2@marvell.com, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sun, Oct 18, 2020 at 9:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 17 Oct 2020 10:22:26 +0530 sundeep subbaraya wrote:
> > > Let me rephrase the question - can the AF driver only run on the SoC
> > > or are there configurations in which host can control the AF?
> > >
> > > I see that Kconfig depends on ARM64 but is that what you choose
> > > to support or a HW limitation?
> >
> > AF driver only run on SoC and SoC is ARM64 based. Host cannot control the AF.
> > Depends on ARM64 is HW limitation.
>
> Okay, modifying the global data is probably acceptable then.
>
> Nothing else caught my eye here, please repost when net-next reopens.
>
> Thanks!

Sure. Will post again.

Thanks,
Sundeep
