Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF48E36715D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbhDURay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244743AbhDURaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394BB61459;
        Wed, 21 Apr 2021 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026213;
        bh=fd/ea915xSYvil7Pc9vQEzTo9L1LbRcNFel261FtMlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JkU8I5KkoNG2AiPM8roRsNgbaw9mufrgvrLZ0JN1PggvGlWQGo/5keO+Y+SnfWY+8
         WEROCK+OXl7iUHa1wzYTx9hpdPn05DiTIv7FQE2BdOyhAOnrQvhXTesIMVb/Ymn+8r
         e9JGH1JGgjS6pqetCKtvedCds5oK0IR5PVjraeM0ab54Eh3w0MzycCA0gcoFMVojdn
         9OfkNjJKRuGOuQi1LgqIlw6ZnLtUqrrcd6J7xMQvFoXVWsl9qNnVgd9osbRabxX8Sm
         qONRWeaT2utJBkNJSoDbxdZADYRW5xYdyTXaXRKQtMQQFrPxCbkVyfTpt5z0c3upRc
         FZAvCjuwDtgZA==
Date:   Wed, 21 Apr 2021 10:30:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: How to toggle physical link via ethtool
Message-ID: <20210421103012.45a3a64a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+sq2Ce+AW3HUhqxa2Q9+2G0BGTnjuzLdnLLBVfeY=_0s6dANQ@mail.gmail.com>
References: <CA+sq2Ce+AW3HUhqxa2Q9+2G0BGTnjuzLdnLLBVfeY=_0s6dANQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 18:12:16 +0530 Sunil Kovvuri wrote:
> Hi,
> 
> Have a query on how to bring down physical link (serdes) for a NIC interface.
> 
> I am under assumption that for a SR-IOV NIC, when user executes
> "ifconfig eth-pf down",
> it should not bring down physical link as there could be virtual
> interfaces still active.
> Let me know if this assumption itself is wrong.

How VFs operate is really implementation specific, so it'd be
interesting to hear from the vendors but IIUC bringing PF down 
should shut down the link.

What usually keeps the link up is stuff like NC-SI, but not VFs.

> If the assumption is correct and if user wants to intentionally bring
> down physical link for
> whatever reasons, then I do not see a way to do this. There are no
> commands either in
> 'ethtool' or 'ip link' to achieve this.
> 
> Would it be okay to add a ethtool command similar to 'ethtool
> --identify" to toggle physical link.
