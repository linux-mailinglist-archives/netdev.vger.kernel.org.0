Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E1F2E9F62
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhADVPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbhADVPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:15:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A549420679;
        Mon,  4 Jan 2021 21:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609794883;
        bh=P4hWOd3qnIPwvPYCJ/6mq+QZaC8rgGUKP0kd677snQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n3vGx+DAlBJ//WDvUYJvMmlYrACyhsUEqeUb0JoJJfLfvthm/ueCRjryMgsLWwgFe
         hMyt02fqZhWdqBvqVwyv2nwm9jcwlRGawLD7nYLFVP0ltWCo0P7xtFvDkZCsy6lh8L
         7irCng2Pq6a3PEL6f8WEo/jGVyTDivLkZexUV/+XCIlyY6ExXu+8zl9wgtWmrEMKT+
         h+z/Pc+nggVU2AnPpIdOy+4xahEOIJ7z8XL0HL1Qod66voM9/prYWeEz8/FiKI5JyS
         iBXP4i+EoZWNwd+fzarU7HLx5od5KT44qlW+xIFOd75Ta87v+7kMIYM2ZgRnZkqq42
         SWhnvUnXWJ3Eg==
Date:   Mon, 4 Jan 2021 13:14:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gnault@redhat.com
Subject: Re: [PATCH net v2 0/2] bareudp: fix several issues
Message-ID: <20210104131442.0ca9bf83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228152121.24160-1-ap420073@gmail.com>
References: <20201228152121.24160-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 15:21:21 +0000 Taehee Yoo wrote:
> This patchset is to fix problems when bareudp is used nestedly.
> 
> 1. If the NETIF_F_LLTX flag is not set, the lockdep warns about
> a possible deadlock scenario when bareudp interfaces are used nestedly.
> But, like other tunneling interfaces, bareudp doesn't need xmit lock.
> So, it sets NETIF_F_LLTTX.
> Lockdep no more warns about a possible deadlock scenario.
> 
> 2. bareudp interface calculates min_headroom when it sends a packet.
> When it calculates min_headroom, it uses the size of struct iphdr even
> the ipv6 packet is going to be sent.
> It would result in a lack of headroom so eventually occurs kernel panic.

Applied, thanks!
