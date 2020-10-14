Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC8328E930
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgJNXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgJNXaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:30:20 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0812078A;
        Wed, 14 Oct 2020 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602718220;
        bh=vyv1Lw21EZsvgtDr0IaKBBfPkAhRje6PnLiOpTq5E5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f9mHYFDstQRP7bqIKfSnesVOKCUWUPIUOuPPlhYlDUkXX0Xvu8NNd4GIgqQTAh1B6
         cbMiV3FE1FovKuPzzmIqLwQKKV5wvUAjhrGm6lfxBj8Xgd/6S+U0dv0LcIGvzgq5Zy
         thgbgr+xtvbqaRPR4J+ibbFJ2O1gUfSk4r0fgrtE=
Date:   Wed, 14 Oct 2020 16:30:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Message-ID: <20201014163018.0c2a4fc7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:22 +0000 Henrik Bjoernlund wrote:
> +	if (config->mdlevel > 7) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "MD level is invalid");
> +		return -EINVAL;
> +	}
> +	/* The MEP-ID is a 13 bit field in the CCM PDU identifying the MEP */
> +	if (config->mepid > 0x1FFF) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "MEP-ID is invalid");
> +		return -EINVAL;
> +	}

If I'm reading patch 7 correctly these parameters come from netlink,
right? In that case please use the netlink policies to check things
like ranges or correct values.
