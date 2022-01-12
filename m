Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089A348CE9B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiALW5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:57:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55172 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbiALW4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:56:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D5D5B8208C
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC41C36AE9;
        Wed, 12 Jan 2022 22:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642028210;
        bh=JFnlIv3M1b+SkMb35nThSdAQRMiTaaJeohD/Orw+2zY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YpOO3ZIlhZUIWEKttSNADbciq1o7dIxQP5u3E43w30Awzv0/mLdbsgHRDTwN7x7e3
         h18JWajd7BGxjzsvR9iCIei02AKdgWRH50Jn4ppHJGnsPUmhdGlq8EvYUY7F/FgMOq
         KqtKMn106+7MfREy4Par6hpyl3ps1G//dxWV+B/388mLtmJfAxStykSgbipLfSubzX
         z+xj/jBCFvF0TyOqvNMh57tHCKPCmCbTgx3zqgbkTbGL2VeMDz8CHqaap73h8Q6X2t
         cSofnQGArmumA9ZMS29oLtDtNitfyQdgs0OhZYlgm72OSyLAATXdWG67UNT6FAUds1
         U4Sb6r9rUh+qw==
Date:   Wed, 12 Jan 2022 14:56:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
Message-ID: <20220112145648.7e0c0d9c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110015636.245666-4-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220110015636.245666-4-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:56:31 -0800 Dimitris Michailidis wrote:
> +static int fun_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct funeth_priv *fp = netdev_priv(dev);
> +	struct hwtstamp_config cfg;
> +
> +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +		return -EFAULT;
> +
> +	if (cfg.flags)           /* flags is reserved, must be 0 */
> +		return -EINVAL;
> +

This check was moved to the core in 9c9211a3fc7a ("net_tstamp: add new
flag HWTSTAMP_FLAG_BONDED_PHC_INDEX")
