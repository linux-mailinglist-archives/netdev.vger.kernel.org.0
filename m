Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDA92F2439
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405508AbhALAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404263AbhALATq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B3BA22C7E;
        Tue, 12 Jan 2021 00:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410745;
        bh=zuaJq+OLLUWKATABd84HV6Mayq4PndWVpD6rTkqvMNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=px35yx56CKbpKrTSNYPNrd4UmYwixKM6KIowQYg5a6u7PbMMV9Zc9PiIcqYkrlrEP
         lRgA3pqqt0+AvBx3nQdo2twh6lOWR8CukkSCncV9mQ6RBPFYZELTUBDoMdcSf8LyR5
         dP0+aWDTbrSxKa+UGzE+9iEeF6aImMT8QFCraSfpavj13/dP7kBpOT16IDxr0byMlZ
         bgMtFPksf0hg45b0DgRH3VYuUSFrezc82KmKWxSwQqiwGBLoIT5ii8owVhLJhgAsuS
         G952xp3zHNWcIgMlVgsn4zOEtik+pyUWThZPL0+7lvvqN42xYvLMb9KJPH8Zdpx5WE
         O5U2pbXgMlxjw==
Date:   Mon, 11 Jan 2021 16:19:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: cope with SFPs that set both LOS
 normal and LOS inverted
Message-ID: <20210111161904.49049d9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/svz0qt5Jh63oiV@lunn.ch>
References: <E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk>
        <X/svz0qt5Jh63oiV@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 17:48:15 +0100 Andrew Lunn wrote:
> On Sun, Jan 10, 2021 at 10:58:32AM +0000, Russell King wrote:
> > The SFP MSA defines two option bits in byte 65 to indicate how the
> > Rx_LOS signal on SFP pin 8 behaves:
> > 
> > bit 2 - Loss of Signal implemented, signal inverted from standard
> >         definition in SFP MSA (often called "Signal Detect").
> > bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
> >         (often called "Rx_LOS").
> > 
> > Clearly, setting both bits results in a meaningless situation: it would
> > mean that LOS is implemented in both the normal sense (1 = signal loss)
> > and inverted sense (0 = signal loss).
> > 
> > Unfortunately, there are modules out there which set both bits, which
> > will be initially interpret as "inverted" sense, and then, if the LOS
> > signal changes state, we will toggle between LINK_UP and WAIT_LOS
> > states.
> > 
> > Change our LOS handling to give well defined behaviour: only interpret
> > these bits as meaningful if exactly one is set, otherwise treat it as
> > if LOS is not implemented.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
