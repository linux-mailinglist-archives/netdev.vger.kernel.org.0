Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916DF41A3C7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhI0XXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 19:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238012AbhI0XXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 19:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11EA611C0;
        Mon, 27 Sep 2021 23:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632784889;
        bh=JJTr33zj+Ep0ir5ZbryubTtFkgqFXPxTh5Fzu4iOX0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6FAjkVh3B2TDZEZBHW1Y7jxeSG5Ll6uZ1JUKo4h0r4jF9Z3ZE4MBMMyLS4zQ4Dyf
         2W1oU0ti4ItAg3byjP0w4IUpD5ny6ANANCNUqjhONL8hHfvXZEtDji1lnom5UxdcLl
         29U7CGtvBOxzAlGRYX7fEg+Q3XeSqSnftMcXHgtnoHVKfjxp+IvG1rk6n+y6yWvDyP
         UhGmVIDV+/TOTtgUgU00dFBZYKHCb+nMhkOYYmMBI8ngOU28v4cNQkpdkNqVIr+ru9
         8BlPmrEDGNAcycQqpZaOgD2NB+0gilbjsWzR0vDK65IN928eNPSvWEpD3VmkqwcpKV
         hFp2f2cy51gUw==
Date:   Mon, 27 Sep 2021 16:21:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bailey Forrest <bcf@google.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
Message-ID: <20210927162128.4686b57d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com>
References: <20210723231957.1113800-1-bcf@google.com>
        <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
        <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Sep 2021 13:21:30 -0700 Bailey Forrest wrote:
> Apologies, resending as text
> 
> On Mon, Sep 27, 2021 at 2:59 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > On Sat, Jul 24, 2021 at 1:19 AM Bailey Forrest <bcf@google.com> wrote:  
> > >
> > > Some variables become unused when `CONFIG_NEED_DMA_MAP_STATE=n`.
> > >
> > > We only suppress when `CONFIG_NEED_DMA_MAP_STATE=n` in order to avoid
> > > false negatives.
> > >
> > > Fixes: a57e5de476be ("gve: DQO: Add TX path")
> > > Signed-off-by: Bailey Forrest <bcf@google.com>  
> >
> > Hi Bailey,
> >
> > I see that the warning still exists in linux-5.15-rc3 and net-next,
> > I'm building with my original patch[1] to get around the -Werror
> > warnings.
> >
> > Can you resend your patch, or should I resend mine after all?
> >
> >       Arnd
> >
> > [1] https://lore.kernel.org/all/20210721151100.2042139-1-arnd@kernel.org/  
> 
> Hi David/Jakub,
> 
> Any thoughts on my patch? I'm open to alternative suggestions for how
> to resolve this.
> 
> This patch still works and merges cleanly on HEAD.

Looks like fixing this on the wrong end, dma_unmap_len_set() 
and friends should always evaluate their arguments.
