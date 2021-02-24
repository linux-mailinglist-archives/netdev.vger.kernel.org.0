Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1783F3243B4
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 19:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhBXSX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234087AbhBXSXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 13:23:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C78764E6B;
        Wed, 24 Feb 2021 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614190991;
        bh=EnFi/55V+CILhwHbo/1gt2B6Xv8s9abVKwt5UUP5A54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uoaxeHW6HWj4QzqRaMoBepvIjnzkjspTZD8xVUBl/q3bbU9B47PhInSCjXHBbzJqr
         Ls6Khsf0oJ1QjWBFQGLoSHZVGgAUc9t6L7OYv5taiaTNnJOjcnSDgSG8peIYGeoXS2
         3PBY12KYETNZG0v6UjXiGBIR6Tn6hELqar9Re2XiOGeRHqK5dDwDmRon6aK4VVMDWK
         H5HCXnjyIj5J8zwI7NT2sLjZJhgH1LKVpPyOHSeQ1Gw1zqo8aNUwSAKwdUHOh735Zs
         rhjPUbjevTtfdP9Qq3QTO6/nc0AaziLQO9PSmx8FqD/SQtPZZ01h+fTSUnC4+TCQPA
         ZyNhFNxSjibcQ==
Date:   Wed, 24 Feb 2021 10:23:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: rmnet: Support for
 downlink MAPv5 checksum offload
Message-ID: <20210224102307.4a484568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614110571-11604-3-git-send-email-sharathv@codeaurora.org>
References: <1614110571-11604-1-git-send-email-sharathv@codeaurora.org>
        <1614110571-11604-3-git-send-email-sharathv@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 01:32:50 +0530 Sharath Chandra Vurukala wrote:
> +/* MAP CSUM headers */
> +struct rmnet_map_v5_csum_header {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	u8  next_hdr:1;
> +	u8  header_type:7;
> +	u8  hw_reserved:7;
> +	u8  csum_valid_required:1;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	u8  header_type:7;
> +	u8  next_hdr:1;
> +	u8  csum_valid_required:1;
> +	u8  hw_reserved:7;
> +#else
> +#error	"Please fix <asm/byteorder.h>"
> +#endif
> +	__be16 reserved;
> +} __aligned(1);

This seems to be your first contribution so let me spell it out.

In Linux when maintainers ask you to do something you are expected 
to do it.

You can leave the existing bitfields for later, but don't add another.
