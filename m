Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F50288D85
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389597AbgJIP6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389380AbgJIP6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:58:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B12B222261;
        Fri,  9 Oct 2020 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602259087;
        bh=GIccIXTeOUkQO5mcfwWty2R6qImlNZ3E/Biu8uzF2Jw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=huvcr2uaG6zkbu0CTBPjcrAaGJTGsbbmzjJIjAensB3zmkYPy5stFz8FuZ0L0J7d3
         wsuPNcnmTLxZ4CLeVgI6iebUIn6mFzMhqgkOJQg1a225707CTEzw4mNKq2DdHEj+TT
         6wQN+YBrrir4B5p8Cel3orA8xmsQmzeX0DGgKN9U=
Date:   Fri, 9 Oct 2020 08:58:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
Message-ID: <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
References: <20201008162749.860521-1-john@metanate.com>
        <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 16:54:06 +0200 Heiner Kallweit wrote:
> I'm thinking about a __napi_schedule version that disables hard irq's
> conditionally, based on variable force_irqthreads, exported by the irq
> subsystem. This would allow to behave correctly with threadirqs set,
> whilst not loosing the _irqoff benefit with threadirqs unset.
> Let me come up with a proposal.

I think you'd need to make napi_schedule_irqoff() behave like that,
right?  Are there any uses of napi_schedule_irqoff() that are disabling
irqs and not just running from an irq handler?
