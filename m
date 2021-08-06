Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CAC3E2118
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241839AbhHFBmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232199AbhHFBmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 21:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6135C60FE7;
        Fri,  6 Aug 2021 01:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628214109;
        bh=FfK+ePBJBsaDkLWBUs4QMRQeq+FMOyhP/dXk4C5QRUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PVm56W2YrM/yJeH2wDmxYhNVhUnsoG32Orp9LlEzLxC/a3Uj/pb1w8KXLkI6lja7u
         ITTzKf0rpYI32U/o70OQ2LuzfGC0I9pNIX0+bFkKm++YDKnW0lv9BkJ4W2TO7/X65l
         ne+Ljtd7AggEajY5e6a2wMqls3YIUwtW4oBfv0bG+enob7WNDSTVjzcg8ZBMysB132
         gjE2Uyq5/I+z8bv2ceWC0dtG3MMv88syfkNbhCprnzGfPy28xfVm13VLnRI8ZoOcVc
         XL6ChHRsIR9oO2VpT7f5EKpqPaiC2N6udVZSU85kKMGtLbZMjeKFlVGitCXG+KMz+U
         9IO40UhFvziPQ==
Date:   Thu, 5 Aug 2021 18:41:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: ipa: reorder netdev pointer
 assignments
Message-ID: <20210805184148.46bc33e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210804153626.1549001-1-elder@linaro.org>
        <20210804153626.1549001-3-elder@linaro.org>
        <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 18:27:12 -0700 Jakub Kicinski wrote:
> On Wed,  4 Aug 2021 10:36:22 -0500 Alex Elder wrote:
> > Assign the ipa->modem_netdev and endpoint->netdev pointers *before*
> > registering the network device.  As soon as the device is
> > registered it can be opened, and by that time we'll want those
> > pointers valid.
> > 
> > Similarly, don't make those pointers NULL until *after* the modem
> > network device is unregistered in ipa_modem_stop().
> > 
> > Signed-off-by: Alex Elder <elder@linaro.org>  
> 
> This one seems like a pretty legit race, net would be better if you
> don't mind.

Ah, this set was already applied, don't mind me :)
