Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9120EA52
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgF3AfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgF3AfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:35:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA78720760;
        Tue, 30 Jun 2020 00:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593477319;
        bh=KBmUTWrG93ENkO07tKesnl5kivSN3j2CtPaBFAdgfY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zfYVeUoSATL27kpxgjL8IlQEdwmRo9q6TX33ruLpLSInROW4Bg7uaB/znM10mmmch
         Y7TDli4Mu1jHgT9gAMKz+pEYcynmfLfcgbviDbzSVy1BKRZ9iM1h2Glkq32I7IyGkz
         c49m0iomoa+Cw7e7l4nm+vc1RUEV6a+grDxd+Aew=
Date:   Mon, 29 Jun 2020 17:35:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers are
 RX only
Message-ID: <20200629173517.40716282@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629214919.1196017-2-elder@linaro.org>
References: <20200629214919.1196017-1-elder@linaro.org>
        <20200629214919.1196017-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 16:49:15 -0500 Alex Elder wrote:
> The INIT_HOL_BLOCK_EN and INIT_HOL_BLOCK_TIMER endpoint registers
> are only valid for RX endpoints.
> 
> Have ipa_endpoint_modem_hol_block_clear_all() skip writing these
> registers for TX endpoints.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_endpoint.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 9f50d0d11704..3f5a41fc1997 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -642,6 +642,8 @@ static int ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
>  	u32 offset;
>  	u32 val;
>  
> +	/* assert(!endpoint->toward_ipa); */
> +
>  	/* XXX We'll fix this when the register definition is clear */
>  	if (microseconds) {
>  		struct device *dev = &ipa->pdev->dev;
> @@ -671,6 +673,8 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
>  	u32 offset;
>  	u32 val;
>  
> +	/* assert(!endpoint->toward_ipa); */

What are these assert comments for? :S
