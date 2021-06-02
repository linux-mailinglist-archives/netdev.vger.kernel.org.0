Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469DE398A6E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFBNaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:30:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34211 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhFBNaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:30:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 75A235C005A;
        Wed,  2 Jun 2021 09:28:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 02 Jun 2021 09:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=b
        HeXkbF7PvwsXcWBA66Xyay/weKYecQSlLwIvV/2OEo=; b=XBwGzzC1ogFFij2Os
        22qeO5mo4QKEoCwlNnOPqtF3wMkTRN0Ob89TWEN1psfO0PINwHc3qPGnzUH1ZbME
        rW1ZRm4TgPyq9luKq1n59SGCBmgv2O/pAJo5x9AEI2mRg1jkUYDW950Da8abWW0j
        EHJ6WDqn1+VYhMNT+RI3DHg/5/XzYp3I+keEaDe1zbsSm2RLY4wG2itUksfgRlqc
        ZjR3vyzgKQZ1MpF8WsexxcdBznOO598XywMZmDZdSOD9z6LMwQ581zCR6dFWvw4V
        x23L+yl6C5chOQTGR/v5MPlWWmHVEiQp6wgbebBJtri/qQw3BhRIkPHLUzO0GrXN
        l3g6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=bHeXkbF7PvwsXcWBA66Xyay/weKYecQSlLwIvV/2O
        Eo=; b=nonIEzU560WGMqfwElLCUueaHtt2kZZFdj5MzSU3a2c+L+XeDgh+Oxcja
        EynLVUVFKDRI9dMKchxHHCAvuly/gbRhcuN5QnBYE4gDqc67iWmI195gTEGpu/hY
        FWHVCg3DiTnSas8V07UslxyD1hmd0CDlbLlAhiK+eWvbkSh7Z/20KSh1+xVXIWZ7
        s+n8C0WyCKppw8Gn5ZjTeZLNnNKcXNESwaAUSY4Wcd016nLF+bRnGoF5vFASyVIS
        Jde3fDq8n8h0btgYy8+EEMyRg06C82GYLo+YcRXtPH2b7/5bPLEJokdnVXnhkosa
        6FVtqtuJaqB0/hA8HrGj4XjUUmVWA==
X-ME-Sender: <xms:eYe3YIpWoxaViKKaiqnb10joNsTe2eogJk_lf_Z0Q3MP4612pYFnxA>
    <xme:eYe3YOrweR48yVJ1oNv5gu4ZmMGtmtC0BpafmgmRlflRDaSDH_5WTwSF1SRMgpLrH
    ESoY_MysKYXCaM0v4Q>
X-ME-Received: <xmr:eYe3YNMndoOVzI2jCmIWP3SsJQlP2gPuWBnmIY8BrPW0HoIwMzI400gjDstaQQv2T6aK2RnqjhSa5UfnAORpTY0wwiSWtVBmn5Xp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeljedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthhqredttddtvdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpefgjeettdejgffgffdvteeutdehtdehgeehueetkeefgefhtdetjeekledu
    gedvudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:eYe3YP7yfRZ3He1Pwhqo29iH5vrCkbPveAWy2HsK4lpLqn4GWiPSPQ>
    <xmx:eYe3YH5uXD6PznHg6Fa0jMfkHxvcTKQ0XfNOHl_laBmkgl34AhUpVg>
    <xmx:eYe3YPjbrjmGj8XVWh3YugOMmoWcGPt0k_LyWfK5-nIfSG5ADZ68lQ>
    <xmx:eYe3YK1-I-AgbjtGftEaH0j01XDk-Pc1WY-x1kLxNj56JfXlGWYu7g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Jun 2021 09:28:24 -0400 (EDT)
Date:   Wed, 2 Jun 2021 15:28:22 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     nicolas saenz julienne <nsaenz@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20210602132822.5hw4yynjgoomcfbg@gilmour>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wrote:
> On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
> > > That is also how I boot my Pi4 at home, and I suspect you are right, =
if
> > > the VPU does not shut down GENET's DMA, and leaves buffer addresses in
> > > the on-chip descriptors that point to an address space that is managed
> > > totally differently by Linux, then we can have a serious problem and
> > > create some memory corruption when the ring is being reclaimed. I will
> > > run a few experiments to test that theory and there may be a solution
> > > using the SW_INIT reset controller to have a big reset of the control=
ler
> > > before handing it over to the Linux driver.
> >=20
> > Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
> > that the TX or RX DMA have been left running during the hand over from
> > the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to reduce
> > as much as possible the differences between your set-up and my set-up
> > but so far have not been able to reproduce the crash in booting from NFS
> > repeatedly, I will try again.
>=20
> FWIW I can reproduce the error too. That said it's rather hard to reprodu=
ce,
> something in the order of 1 failure every 20 tries.

Yeah, it looks like it's only from a cold boot and comes in "bursts",
where you would get like 5 in a row and be done with it for a while.

Maxime
