Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D54341476
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 06:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhCSFBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 01:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhCSFAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 01:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D6164F04;
        Fri, 19 Mar 2021 05:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616130053;
        bh=Wr4Wb60Mr3RSfVxG8NCV+R0EnH2fSgOiF/fqgrqH5EA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pSDTloAvPnl2nG2jyTjdCyFyHmNBTNhU/FBQ55RBPkreutgNYBdepPyv3aXAitJhR
         64fMIK9Ure4IFIvkbRFq1E5vsQLj0lTbUrF+v+vNCCFxhO8nzWnO7NUKKxukVSSXUB
         W6/CHBYhcvYCjYPKIUxBHzeMJ036PgyFTv0aOjB2dJrMacx0DATG1PO/R1u+/5JhLa
         7aobWeGMYWaeH3BIGU73ZLw7Hc+68LzWFALBvnzwNdOS69ewAA0tER36uT72PMQ9AV
         Mq6VyT0wnyo9XkxKnT65Zu9d9Z/SZZSAalVFaOk0Dy9Oum0fSKkSNMuZDMF3bno4Iv
         QFQ+uRSd7w78w==
Date:   Fri, 19 Mar 2021 07:00:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
Message-ID: <YFQwAYL15nEkfNf7@unreal>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319042923.1584593-5-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 11:29:23PM -0500, Alex Elder wrote:
> Convert some commented assertion statements into real calls to
> ipa_assert().  If the IPA device pointer is available, provide it,
> otherwise pass NULL for that.
> 
> There are lots more places to convert, but this serves as an initial
> verification of the new mechanism.  The assertions here implement
> both runtime and build-time assertions, both with and without the
> device pointer.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_reg.h   | 7 ++++---
>  drivers/net/ipa/ipa_table.c | 5 ++++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
> index 732e691e9aa62..d0de85de9f08d 100644
> --- a/drivers/net/ipa/ipa_reg.h
> +++ b/drivers/net/ipa/ipa_reg.h
> @@ -9,6 +9,7 @@
>  #include <linux/bitfield.h>
>  
>  #include "ipa_version.h"
> +#include "ipa_assert.h"
>  
>  struct ipa;
>  
> @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
>  			BCR_HOLB_DROP_L2_IRQ_FMASK |
>  			BCR_DUAL_TX_FMASK;
>  
> -	/* assert(version != IPA_VERSION_4_5); */
> +	ipa_assert(NULL, version != IPA_VERSION_4_5);

This assert will fire for IPA_VERSION_4_2, I doubt that this is
something you want.

Thanks
