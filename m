Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B575326A7B
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBZXpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhBZXpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:45:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B5064EFA;
        Fri, 26 Feb 2021 23:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383098;
        bh=dEaRhcmyFCzj248hiTK2l3Emc3/GnGJvEvLBYW/GUjU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UEIvrxSJu8q8sdY/L3E5wfYm1KSaT8N8lXXXTPgqHU3iTDpOdhh3wRDsYreia25l5
         PfUdDIJHgcjK9ATY+VT3CQqyB3OA4j84VNMDS20OH+3cKO4rTShjx16n/iAOP5gB4I
         W6vIcR308qmyAAT2wrKYYTHhP/fu0ks6CFyOgpXi667Vz52ZIw7utQ7NOc2QDqG+Sc
         oGEKtrfY1wLXrmJLXhxy4+ZIYXMVLKBgAQ/UYUKjmxHPXWIFzVP3T1ROOcUNpJbk1D
         Y3QxRF2e0yAXACjMefAJuHeNlWptG28E/q21xlzzH0qArIy7PdKkAhuHhLVwMm+yaX
         ZcFGDE1Uy1naA==
Date:   Fri, 26 Feb 2021 15:44:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/1] net: fec: ptp: avoid register access when ipg
 clock is disabled
Message-ID: <20210226154457.71094945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226152331.GD26140@hoboy.vegasvil.org>
References: <20210225211514.9115-1-heiko.thiery@gmail.com>
        <20210226152331.GD26140@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 07:23:31 -0800 Richard Cochran wrote:
> On Thu, Feb 25, 2021 at 10:15:16PM +0100, Heiko Thiery wrote:
> > When accessing the timecounter register on an i.MX8MQ the kernel hangs.
> > This is only the case when the interface is down. This can be reproduced
> > by reading with 'phc_ctrl eth0 get'.
> > 
> > Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
> > the igp clock is disabled when the interface is down and leads to a
> > system hang.
> > 
> > So we check if the ptp clock status before reading the timecounter
> > register.
> > 
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > ---
> > v2:
> >  - add mutex (thanks to Richard)
> > 
> > v3:
> > I did a mistake and did not test properly
> >  - add parenteses
> >  - fix the used variable  

On Fri, 26 Feb 2021 08:22:50 +0100 Heiko Thiery wrote:
> Sorry for the noise. But just realized that I sent a v3 version of the
> patch but forgot to update the subject line (still v2). Should I
> resend it with the correct subject?

No need, looks like patchwork caught the right version.

> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
