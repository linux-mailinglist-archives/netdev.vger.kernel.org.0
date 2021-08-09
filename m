Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6003E4E27
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhHIUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhHIUx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13A0961019;
        Mon,  9 Aug 2021 20:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628542415;
        bh=VxjNPYWZUiQJduiJINk5u08LoDlzM1BFYtxKoZ0PqjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Le3Wg2uSqGKjxozUllFPAR1ZeOOpaHLAwVQlCmBSdTkf+E2jAgiw+otWdZTVQFvWi
         mlJ/el8KlkKThkDJIbpFKajmf3TjfLeDZ6iKpt7wRX9WZkPHBRHdfBoM8odaT9B4hl
         zYJNbLsZQ9ea3F7n08WoQ6xKUUnwe9ZXhaKG+yMk93Ax4Jz7aAALoy0PZk7hqOEMxJ
         /3j3mxW0xKfgFJHXdgkwI3A19eifzSCZiZhLkCsB4j9YpbV6D/9R8JUi4ot35BilmW
         9I0BdNR6QvMR4fb8hSe9QzoP4BfrVHHBB0J2OMNw4+uMXsGCLm7VyeHZneH15UqIIz
         l4kqKLj/h7ifA==
Date:   Mon, 9 Aug 2021 13:53:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>
Subject: Re: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
Message-ID: <20210809135334.79f000e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809140109.32595-1-rocco.yue@mediatek.com>
References: <20210809140109.32595-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 22:01:09 +0800 Rocco Yue wrote:
> +static inline size_t inet6_iframtu_msgsize(void)
> +{
> +	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> +	     + nla_total_size(IFNAMSIZ)	/* IFLA_IFNAME */
> +	     + nla_total_size(4);	/* IFLA_INET6_RA_MTU */
> +}

Please don't use 'static inline' in C sources, static is enough
