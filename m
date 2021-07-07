Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3981A3BF27C
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 01:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhGGXfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhGGXfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 19:35:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFFAC061574;
        Wed,  7 Jul 2021 16:32:34 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j34so2865229wms.5;
        Wed, 07 Jul 2021 16:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQfug0IHv4zPVKKbJZrt/5kYXexS/UlEn7UIdBqjdy0=;
        b=LAWwwJqdNgjFcpi4SE+Ab48hR+5topHfVlfE1xj5KtLe5QirRqVneBa/P5KlxU6syQ
         Ns5eUckdJE9rhr8LCBBp0RVl6TdCd1Xf+gKWPkBMtuWKHuF8xcuxq3C4QwIPAh3ytaZr
         pURIMUCXlcMsknxknx5gPxW7JRO89FoVZRn2Q4yvzFgUwoj07qYez2RELuxAl4wF6yZp
         yH9sXSKr44EN6a50SByQalvAUtNeBLIuOngHqK83lBKaeoCtn5qPT50SkJfUS9yfQHsx
         FEon4AhUXeE56LpEnoahkpn0hZp37xOgHhmgpu1FTJfo+Ry95ixR7NfZO0pXGBm8eyZF
         CNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQfug0IHv4zPVKKbJZrt/5kYXexS/UlEn7UIdBqjdy0=;
        b=BzDRkZC696CPcqNZy78wg0msbK1DKLl9J16UBntS+Bbsciwgs4yunkJ1+vTwk8U69U
         h6S4/gCYJuDB14FsUCh7c+T3U1Gvl2u48UhlhsX8XEc6f43wrCRo3NZSyO/hT2Xqi5Ww
         rrHjkKL3zrUllSE8IyeouM82P7ediQz/LOQ69bCM4n1o96jy560/IZhAAwmypBhEnBFq
         jzASNkKGTd/feXzqa3j2AkVTrWx432WXkX4sziBlN8pJ3M2hbaPJi8fKfWsyOmrbhNY7
         pMGCUQVyTj0lFOMLozXqrPKZYXVj/6HJUGgIN/Ys+FatSW91s+CgbbfTIIm4ohm3JIX6
         /9Cg==
X-Gm-Message-State: AOAM530tlMaA2ih7WQWzCs6mKojToTPjfD+MeFVWhMGWzVSAq2syjLYw
        M0GsWuKTic/Id6idgeeedhcIN7UJFXjsouY/nwM=
X-Google-Smtp-Source: ABdhPJwPoDiNqiFkOfb2Qdr5lC15YXtFZuvpIyIUyx67hU04fAjkhwuzb0CqPqbNCnQoOA+B0MY22o19Dsvy/c/qEuY=
X-Received: by 2002:a1c:7915:: with SMTP id l21mr1680459wme.62.1625700753215;
 Wed, 07 Jul 2021 16:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
 <CAD-N9QWZTRWv0HYX9EpYCiGjeCPkiRP1SLn+ObW8zK=s4DTrhQ@mail.gmail.com>
 <CAB_54W6VkOQ+Cf4gmwzJyQpjyK5MRqsGXkQD3fPa2UC2iLudtQ@mail.gmail.com> <CAD-N9QXZWA2rEYQV=E7ifqVTGA_ZLZJp=EA8GMLKufD7CMoyjQ@mail.gmail.com>
In-Reply-To: <CAD-N9QXZWA2rEYQV=E7ifqVTGA_ZLZJp=EA8GMLKufD7CMoyjQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 7 Jul 2021 19:32:22 -0400
Message-ID: <CAB_54W6BcPZYj+XTJgFXjktOcMs-RfL-ahfNs3K_yYu9_r4Rcg@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 7 Jul 2021 at 19:15, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Thu, Jul 8, 2021 at 2:55 AM Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wed, 7 Jul 2021 at 12:11, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > On Wed, Jul 7, 2021 at 11:56 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
> > > > must be present to fix GPF.
> > >
> > > I double-check the whole file, and there is only one similar issue
> > > left in Line 421.
> > >
> >
> > What about "hwsim_del_edge_nl()" line 483, I think it has the same issue?
>
> Eric already submitted a patch [1] to fix this function and the patch
> is already merged in the mainline.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0303b30375dff5351a79cc2c3c87dfa4fda29bed

ah, yes. Thanks.

- Alex
