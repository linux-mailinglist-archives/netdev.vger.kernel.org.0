Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1028FCE8
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 05:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394154AbgJPD34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 23:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394150AbgJPD3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 23:29:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E55C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 20:29:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so2126721ior.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 20:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UX+7Jx/Oz85YwfHFflQ9/UHlh13DnPudEte+H7zJzUI=;
        b=i5dwHpdIx6HMFJVOQcjCYjfVtiJV3PiuNAvYDdkjSpviTaFlIXKWQphywLxC64PCbl
         D2ADK6p98XPo3CrmSBGO6QK+0dC2c5z522+WVzdmU/kOc+tz7BUa1SVBOUjVK+MIcP86
         HzGrHMXxwJ5OhweZMPOgbl8lpwpRtz0NrDonuoYph2SR9A7I2WzGc981Dce8sr/zVXP6
         zsVpC9CVIHY2fF/kNTFUDntYsfbBoSDGmakpjEk0lnp4sS/RWx3aZjDcteQhDBXWq2nQ
         tjBNedcMYKKtvMH8gM2W2p21CS9ZbSReklbIObpUv3y13eLFYC8gYQs1Vw282HPQI/Bj
         G+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UX+7Jx/Oz85YwfHFflQ9/UHlh13DnPudEte+H7zJzUI=;
        b=KSJiII52Ch3X1zOUsWo8ypAJQ2SSvSynQL7Kn/7dLJIrp1VldoLobRTYSo9a1731mx
         sGkTD+jSw/latmfvVE+EKiTkNkDLfIcz2D/mDulsLBWehwXPrLedKJK2n32FSAj+1sjZ
         89Z8IO5doB+g2Aqc7u8RBGC/5EluxB1bEnbnCVmUklnlyIz8KeQjA6FVWtpeDSHPmxFA
         J0M4OYluxpSpyMrjtvxtaLI6eBCKtj49dDI2h4ojyST+kqVLdhgd3v/vGsZWNNBgXfB3
         r0K6d7KFAkoiZ45jdy6kqqXiwP392rt26mBylvcWqmrmTFTHN3BetWNYGpH0b49D5jO/
         2mLQ==
X-Gm-Message-State: AOAM5337M+AeQnmhH/vRB72x0Oy9BokoP+tNJQ5exGe09CzoLtVt5Q0b
        nUw5CvvFav2wV41H5LnntgEtaR0sd1RNgnoNFOWSvLJ8cGkPkg==
X-Google-Smtp-Source: ABdhPJzgHpJs+Pikq1XRPAtq633BB5UVcoNDwODibmuaxAvy2a+t0WbQoW5158m5SrzIQ6SDYiCAHrlDtf8NPQaL9WU=
X-Received: by 2002:a05:6638:1696:: with SMTP id f22mr1201505jat.8.1602818994872;
 Thu, 15 Oct 2020 20:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
 <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
 <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com> <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 16 Oct 2020 08:59:43 +0530
Message-ID: <CALHRZurSx8JJj0cQ3dghXO0wesfNm0cS5tmzn_JrpM3wm9W3sQ@mail.gmail.com>
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

On Thu, Oct 15, 2020 at 9:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Oct 2020 17:53:07 +0530 sundeep subbaraya wrote:
> > Hi Jakub,
> >
> > On Thu, Oct 15, 2020 at 8:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 13 Oct 2020 15:56:28 +0530 sundeep.lkml@gmail.com wrote:
> > > > -static const struct npc_mcam_kex npc_mkex_default = {
> > > > +static struct npc_mcam_kex npc_mkex_default = {
> > > >       .mkex_sign = MKEX_SIGN,
> > > >       .name = "default",
> > > >       .kpu_version = NPC_KPU_PROFILE_VER,
> > >
> > > Why is this no longer constant? Are you modifying global data based
> > > on the HW discovered in the system?
> >
> > Yes. Due to an errata present on earlier silicons
> > npc_mkex_default.keyx_cfg[NIX_INTF_TX]
> > and npc_mkex_default.keyx_cfg[NIX_INTF_RX] needs to be identical.
>
> Does this run on the SoC? Is there no possibility that the same kernel
> will have to drive two different pieces of hardware?

If kernel runs on SoC with errata present then
npc_mkex_default.keyx_cfg[NIX_INTF_TX]
is modified to be same as npc_mkex_default.keyx_cfg[NIX_INTF_RX]. And if errata
is not applicable to SoC then npc_mkex_default.keyx_cfg[NIX_INTF_TX]
is unchanged
and the values present in TX and RX are programmed to TX and RX
interface registers.

Thanks,
Sundeep
