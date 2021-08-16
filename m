Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EA93ED99C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhHPPMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236634AbhHPPMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0952260ED5;
        Mon, 16 Aug 2021 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629126729;
        bh=uMo8LGfOpe/Almoc8bvAMBEGmqtUS03nPV5PwNh4VaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NI4STxOvEvDLYkD7cp4EEsv7L1JSA2zVa86AjYMQEt7F0nAhYRfHwh0nuCLtpE4LR
         vzJQdTCeVjixYe3wvkbhORrDwIAhUlEmbl1X4tzJv1tWG4+vTy4qnYkmzJgnUY/CKk
         rTOiYmwPhqQhim0CZVdGtL0BXlsBonMY0aI38U76onGVUblLRHDXk4WL0/i2Ou2tB/
         yAwZjbwNhzpgiWXDdOGqEtEImzkkNPvL5uCH3lmUP6HpI0GjmhHvZMs8nxeSNDI+R5
         fvfIO4W375ehpFLSvnh/VKr2FWb1U48j8SbhyNysnYgb+HCe+YVr5PsrfdkOLQraFP
         KGfhKiozb7CeA==
Date:   Mon, 16 Aug 2021 08:12:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
Message-ID: <20210816081208.522ac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <874kbuapod.wl-maz@kernel.org>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
        <871r71azjw.wl-maz@kernel.org>
        <YROmOQ+4Kqukgd6z@orome.fritz.box>
        <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com>
        <87o8a49idp.wl-maz@kernel.org>
        <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com>
        <20210812121835.405d2e37@linux.microsoft.com>
        <874kbuapod.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 12:05:38 +0100 Marc Zyngier wrote:
> > A possible fix, which takes in account also the XDP headroom for
> > stmmac_rx_buf1_len() only could be (only compile tested, I don't have
> > the hardware now):  
> 
> However, this doesn't fix my issue. I still get all sort of
> corruption. Probably stmmac_rx_buf2_len() also need adjusting (it has
> a similar logic as its buf1 counterpart...)
> 
> Unless you can fix it very quickly, and given that we're towards the
> end of the cycle, I'd be more comfortable if we reverted this patch.

Any luck investigating this one? The rc6 announcement sounds like there
may not be that many more rc releases for 5.14.
