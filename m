Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A63265264
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgIJVQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgIJVPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:15:51 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0668BC061756;
        Thu, 10 Sep 2020 14:15:46 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id h9so1790253ooo.10;
        Thu, 10 Sep 2020 14:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BFCtXTuROc0+YYGPop04Dk+iiUlezsA+0NbzQBhD+BA=;
        b=GuD3TGmStXtihH8Sxv8w7dkoBPihevY3v9BGFDKVMp+7HFRNCzM+ojYulbfbw3lzVh
         Egul2zPj6VBeJQM7kBVVJLNlvhNYje/3IJuRSi/52MWfq2fpQzVo+ZPuxt+0hXyqYijd
         esXtFKqyodblu9iwD++CZEeeoB5JjwehGQcG2+QYC5rBEC9vr/PiLDNyumU235l6CrNi
         WgKJBTLvbfe4Fk4BElHk5G5wuI69rh9cNBS0gIykgUQxuHoruMFKh/CeMaFuNmYqSykS
         LTyVKYWz+lO7ZKlQpGz/z3ESKtcQeqOrQg5nRmddC8yXipIxVptwy1yojTMpwVlb+vXJ
         D8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BFCtXTuROc0+YYGPop04Dk+iiUlezsA+0NbzQBhD+BA=;
        b=fFAivLO7/bPX7vIn12F1fZaH9IPXrpv1Ggnf41gUeVjw4kPGPXAKxi5sv3gUzmn87l
         DLB+OFxTsDhb5TfSfXu8EDIooYu05Zg5Vm5gSx6iHpsRcHA8njJooFzz3vyHuG8EW5Tg
         gqtYU4QH2xTg+7kkQPKtM72NDDQ8mwpM/j2PMnhqvPVP2f8V1JoQ6NMc9NGYzcjrt9pM
         jym5wU9R3wsDXttkDzlqDmmfgJfMkg2tekmOnPYS4siEbNOYffnDvEMP7Daa4+C76Pui
         wIKVCLVDKfCeMUmys/pfBPJq585w23ndnjXvFIacUAUnHKqy6YvfFwOKqLDA0w8wmdP6
         NAjw==
X-Gm-Message-State: AOAM531Z8Z11dXH1g3EkfefAA5Osi8jKPnvcrGKkY4ebCsiWzG0huNSJ
        eg4XeNNVpnE7MuSEt8kA7VHoNzf1PneHY+ewbe0=
X-Google-Smtp-Source: ABdhPJyc58SU56Yz39kDkKsbOrktPwfoFXhHf6/Jso5xD3Rgi5BFy5TRwq1e66DV0J4w4LySieyUCaiWxbu/130vgiA=
X-Received: by 2002:a4a:d509:: with SMTP id m9mr6013838oos.77.1599772545342;
 Thu, 10 Sep 2020 14:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf127fssgiDEwYvv3rFW7iFFfKKZDE=oxDUbFBcwpz3yQkQ@mail.gmail.com> <a13199ce-0c73-920d-857d-3223144f41f0@gmail.com>
In-Reply-To: <a13199ce-0c73-920d-857d-3223144f41f0@gmail.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 11 Sep 2020 00:15:17 +0300
Message-ID: <CAFCwf13ak5NPc2BTWoA2cwHB5AUJjq5i1jOucbsJnwyyQCfQ4w@mail.gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:05 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 9/10/2020 1:32 PM, Oded Gabbay wrote:
> > On Thu, Sep 10, 2020 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Thu, 10 Sep 2020 23:16:22 +0300 Oded Gabbay wrote:
> >>> On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>>> On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
> >>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
> >>>>>   create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
> >>>>
> >>>> The relevant code needs to live under drivers/net/(ethernet/).
> >>>> For one thing our automation won't trigger for drivers in random
> >>>> (/misc) part of the tree.
> >>>
> >>> Can you please elaborate on how to do this with a single driver that
> >>> is already in misc ?
> >>> As I mentioned in the cover letter, we are not developing a
> >>> stand-alone NIC. We have a deep-learning accelerator with a NIC
> >>> interface.
> >>> Therefore, we don't have a separate PCI physical function for the NIC
> >>> and I can't have a second driver registering to it.
> >>
> >> Is it not possible to move the files and still build them into a single
> >> module?
> > hmm...
> > I actually didn't try that as I thought it will be very strange and
> > I'm not familiar with other drivers that build as a single ko but have
> > files spread out in different subsystems.
> > I don't feel it is a better option than what we did here.
> >
> > Will I need to split pull requests to different subsystem maintainers
> > ? For the same driver ?
> > Sounds to me this is not going to fly.
>
> Not necessarily, you can post your patches to all relevant lists and
> seek maintainer review/acked-by tags from the relevant maintainers. This
> is not unheard of with mlx5 for instance.
Yeah, I see what you are saying, the problem is that sometimes,
because everything is tightly integrated in our SOC, the patches
contain code from common code (common to ALL our ASICs, even those who
don't have NIC at all), GAUDI specific code which is not NIC related
and the NIC code itself.
But I guess that as a last resort if this is a *must* I can do that.
Though I would like to hear Greg's opinion on this as he is my current
maintainer.

Personally I do want to send relevant patches to netdev because I want
to get your expert reviews on them, but still keep the code in a
single location.

>
> Have you considered using notifiers to get your NIC driver registered
> while the NIC code lives in a different module?
Yes, and I prefered to keep it simple. I didn't want to start sending
notifications to the NIC driver every time, for example, I needed to
reset the SOC because a compute engine got stuck. Or vice-versa - when
some error happened in the NIC to start sending notifications to the
common driver.

In addition, from my AMD days, we had a very tough time managing two
drivers that "talk" to each other and manage the same H/W. I'm talking
about amdgpu for graphics and amdkfd for compute (which I was the
maintainer). AMD is working in the past years to unite those two
drivers to get out of that mess. That's why I didn't want to go down
that road.

Thanks,
Oded

> --
> Florian
