Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A38290F3F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411719AbgJQFaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411626AbgJQF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:29:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F8DC05BD2B
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 21:52:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u19so6582688ion.3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 21:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/yg7qlMZ54JiZqUTw4dWysM5s8d1l10Ti7zxSdJ1Vg=;
        b=fBWKHSaneT8dFuvCbrnZS/RpyNXczaSf4cUeB3c+I+WLXId1GPggb0XJcnlShd/oRA
         hBh2wYTSBSx66pPTYQPjuoAisRkDghQP2AdlhClF/MJnD4QAxw+Xl5PT+jQbXlJsfe3h
         88kRrawRBQa7Lmwebw3sHZXhX7w6GqGucpMtT/Cp4VpzvS9As5I2Yquyz9e6TuB9Z99k
         c9RRE2wazV3dAD+p1tJsM1jJMY2wr/CUZzMVP5snuV+QdnFpjN6806gykDIeedY1uTLe
         YcO0eJz283FNFkEoxApBbnnTq9dT4CQp68HhD+unpdkRrksMll4GnZjgereVt9VHmILS
         WHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/yg7qlMZ54JiZqUTw4dWysM5s8d1l10Ti7zxSdJ1Vg=;
        b=BujcGBKTGBstDlYYo7rRMGqTvC+qQBEnrYjYnd84ClMHM9de97Atl5s7n7IHkPrgE7
         /2Dq+gBQ27TnaD+5iAZDHMHF54Xo4GQWLQsfKgWUzPicW0WQlN18XyG6PewVDkZOx8AK
         oLRtEw5O3iiVqyRYomhImj11kU5FBXY3soCkD+DjEDjldlUdnccpEM5nJ1e8u6CKwsKr
         7Z/P3FBzUOMQCxvlnME9/WlF/kg0Jqf9ZjaREuzFHs116y9+BDtSMdDwqYkC6OTDWVFz
         Uo09PnTMHeswF0q7xUAAyng8eBEh/c+TQJNeHtQKpa64v8/WQzM9J137uSPfdkVGO5Jb
         LxAA==
X-Gm-Message-State: AOAM530z0t+yEjMs03abDRkvO57/wbLtQ5N4brROHGZTh0DpC94+vqJR
        ocvvJ9opOJmj0c+/Yxuv/yM2dPkMMtCsDORwgjQ=
X-Google-Smtp-Source: ABdhPJyZ8MbwlrN+3rbPmehOsMqJ9X6Y66/4MSMZt+3dYVmXplCUPVKZttcCmpQL+BG+m5P7XZAVNlAyZi0Rpy0V9eQ=
X-Received: by 2002:a6b:b2cb:: with SMTP id b194mr4781103iof.132.1602910357774;
 Fri, 16 Oct 2020 21:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
 <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
 <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
 <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZurSx8JJj0cQ3dghXO0wesfNm0cS5tmzn_JrpM3wm9W3sQ@mail.gmail.com> <20201016104851.01ac62f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016104851.01ac62f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sat, 17 Oct 2020 10:22:26 +0530
Message-ID: <CALHRZupNF-k-iAY2jO3JOWvdAMUQG_EAkgBWicYkutsWR3f-3Q@mail.gmail.com>
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

On Fri, Oct 16, 2020 at 11:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 16 Oct 2020 08:59:43 +0530 sundeep subbaraya wrote:
> > On Thu, Oct 15, 2020 at 9:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 15 Oct 2020 17:53:07 +0530 sundeep subbaraya wrote:
> > > > Hi Jakub,
> > > >
> > > > On Thu, Oct 15, 2020 at 8:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Tue, 13 Oct 2020 15:56:28 +0530 sundeep.lkml@gmail.com wrote:
> > > > > > -static const struct npc_mcam_kex npc_mkex_default = {
> > > > > > +static struct npc_mcam_kex npc_mkex_default = {
> > > > > >       .mkex_sign = MKEX_SIGN,
> > > > > >       .name = "default",
> > > > > >       .kpu_version = NPC_KPU_PROFILE_VER,
> > > > >
> > > > > Why is this no longer constant? Are you modifying global data based
> > > > > on the HW discovered in the system?
> > > >
> > > > Yes. Due to an errata present on earlier silicons
> > > > npc_mkex_default.keyx_cfg[NIX_INTF_TX]
> > > > and npc_mkex_default.keyx_cfg[NIX_INTF_RX] needs to be identical.
> > >
> > > Does this run on the SoC? Is there no possibility that the same kernel
> > > will have to drive two different pieces of hardware?
> >
> > If kernel runs on SoC with errata present then
> > npc_mkex_default.keyx_cfg[NIX_INTF_TX]
> > is modified to be same as npc_mkex_default.keyx_cfg[NIX_INTF_RX]. And if errata
> > is not applicable to SoC then npc_mkex_default.keyx_cfg[NIX_INTF_TX]
> > is unchanged and the values present in TX and RX are programmed to TX and RX
> > interface registers.
>
> Let me rephrase the question - can the AF driver only run on the SoC
> or are there configurations in which host can control the AF?
>
> I see that Kconfig depends on ARM64 but is that what you choose
> to support or a HW limitation?

AF driver only run on SoC and SoC is ARM64 based. Host cannot control the AF.
Depends on ARM64 is HW limitation.

Thanks,
Sundeep
