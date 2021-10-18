Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964CD4323FD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhJRQnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhJRQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:43:41 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDF1C06176A
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:41:29 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id o204so553313oih.13
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m/74ZeSghoGWz2Y5U8O6ZsL9J98hmrFFn2k+ASasuxI=;
        b=V/Sg2umzcGxAR3kKFG3Fy5qzN2KDcjvbNbDPZVaGE9ltjEXcESslh7PJ2o2/ybmpNP
         UFKEXP1js86ftmV1k/I7e/TrkYC6/wQSVyV+vk68P+lRlhHBXg7o+2ZGRYT/JZ6SJ9sC
         Rzo6euFvfLpT+re3VFTWKSb+c74m/3JcGY6wipnJ1dHRejNOXrIUSd1GaebdANSi3Qb7
         9Mcow/pJUlnMAbcheP/las1Om3h3m3i6zigpriw6Z/MENOdDrDyQkO9R7p7b9ZH8aNLU
         qKXLUBvNx2XeEqdc9CfCezeBu8rx3mP4+VPFrBP9p2Bpw2JTmyJzSb4QNdb5VMtNxwoL
         c/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m/74ZeSghoGWz2Y5U8O6ZsL9J98hmrFFn2k+ASasuxI=;
        b=GRQPnNW67BdBkUqPKr6ZLzt3Gyxxqyxl35cQxQ+n2z+dGNyJG/QEzGh6gVLcfQO82a
         h75xAdrD3KFAfgikcLEaYfN+G/GxsIlg8m3S4PwFAATMqFRwVN6hVOQjfsgzNo5s/Ax2
         0BcTGkuZ+KGBtRw1o6i1+4u6OZoF19DpNVdLFDy4Tp2X/yR+MPi3613UjqH+bSc6EFWw
         61vWq7do7lYrQOOxluQeouEFcCA/VaIcRjE4M29xpAPWpi68W5hNyCHh+aqIElBJZkY5
         VvvR2KOcHFxTD2zagLfpGCvsOyhAWy/5liAgoBY8i6TmwCzmA3vDaR5kL8DdAylngvNH
         owUA==
X-Gm-Message-State: AOAM530UrnwdTSlM4ePUhwtBe30vrFpHICyAsuqmniojxzKiAUs6P7bq
        Zd0xTQdFP/oEn0g7RIJHyDSS2QJoRteDRHmfo4D9+g==
X-Google-Smtp-Source: ABdhPJyhI/boD/Dqt4cOu1o+91uOGjUh5J0lLqztunxb38ijIyGLzE0BAxzGggtm1QdOFWnWdOHyLHlnrRrD206Ea5U=
X-Received: by 2002:aca:58d6:: with SMTP id m205mr737607oib.126.1634575288536;
 Mon, 18 Oct 2021 09:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211011141733.3999-1-stephan@gerhold.net> <20211011141733.3999-2-stephan@gerhold.net>
 <CAH=2NtwH9kmZBMsOkZkwiuN2mpmOTiAVtw3zC2O4xNdCgG8P4w@mail.gmail.com> <YW1u5UlmrypFxp9C@gerhold.net>
In-Reply-To: <YW1u5UlmrypFxp9C@gerhold.net>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 18 Oct 2021 22:11:17 +0530
Message-ID: <CAH=2Ntz9BLKpQCPtUOtHp6HDS8R6AQf5XVDUNbdRvYSn=pn8Rg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: dmaengine: bam_dma: Add
 "powered remotely" mode
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 18 Oct 2021 at 18:26, Stephan Gerhold <stephan@gerhold.net> wrote:
>
> On Mon, Oct 18, 2021 at 05:04:31PM +0530, Bhupesh Sharma wrote:
> > On Mon, 11 Oct 2021 at 20:12, Stephan Gerhold <stephan@gerhold.net> wrote:
> > >
> > > In some configurations, the BAM DMA controller is set up by a remote
> > > processor and the local processor can simply start making use of it
> > > without setting up the BAM. This is already supported using the
> > > "qcom,controlled-remotely" property.
> > >
> > > However, for some reason another possible configuration is that the
> > > remote processor is responsible for powering up the BAM, but we are
> > > still responsible for initializing it (e.g. resetting it etc). Add
> > > a "qcom,powered-remotely" property to describe that configuration.
> > >
> > > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > > ---
> > > Changes since RFC:
> > >   - Rename qcom,remote-power-collapse -> qcom,powered-remotely
> > >     for consistency with "qcom,controlled-remotely"
> > >
> > > NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
> > >       so this could also go through the dmaengine tree.
> > >
> > > Also note that there is an ongoing effort to convert these bindings
> > > to DT schema but sadly there were not any updates for a while. :/
> > > https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
> >
> > Seems you missed the latest series posted last week - [1]. Sorry I got
> > a bit delayed posting it due to being caught up in other patches.
> >
> > Maybe you can rebase your patch on the same and use the YAML bindings
> > for the qcom,bam_dma controller.
> >
> > [1]. https://lore.kernel.org/linux-arm-msm/20211013105541.68045-1-bhupesh.sharma@linaro.org/T/#t
> >
>
> Ah, you're right sorry! Seems like you sent it two days after I sent the
> v2 of this patch. Thanks a lot for continuing work on this! :)
>
> Since I already sent v3 of this patch earlier, I think it is best if
> I wait a bit first and see if Vinod has any comments or still wants to
> take it for 5.16. Should be simple to rebase either of our patches on
> the other one.

Sure, let's wait for Vinod's comments.

Regards,
Bhupesh
