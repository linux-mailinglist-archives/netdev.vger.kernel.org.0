Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B652976DD
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754635AbgJWSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460555AbgJWSXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 14:23:06 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43194208FE;
        Fri, 23 Oct 2020 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603477385;
        bh=BDvsAL1BXlqK3Ru7FE0wBVk/qe9/Th/2RAp81DHYrMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFN8xgxBAcOQKkTC9XcdhGiPiEykJ3sBQaZSceC6MfUIY0Exds/UcQkAlDwVLBH7H
         WqYdgWqPq3gQFYNGzK9lLdjNbfZAFNdc8CyttVdPUoRhWGWObNjleJxRLSvnP/55fl
         XjxTT1ySwLTZ+G8q2pov8UvDncNXidfF7B+0BhGI=
Date:   Fri, 23 Oct 2020 11:23:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
Message-ID: <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
References: <cover.1603469145.git.gnault@redhat.com>
        <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 18:19:43 +0200 Guillaume Nault wrote:
> Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
> mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
> need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.

Does it generate an error or a warning? I don't know much about soft
dependencies, but I'd think it's optional.

> diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
> index d672ab72ab12..b83093bcb48f 100644
> --- a/net/mpls/Kconfig
> +++ b/net/mpls/Kconfig
> @@ -33,6 +33,7 @@ config MPLS_ROUTING
>  config MPLS_IPTUNNEL
>  	tristate "MPLS: IP over MPLS tunnel support"
>  	depends on LWTUNNEL && MPLS_ROUTING
> +	select NET_MPLS_GSO
>  	help
>  	 mpls ip tunnel support.
>  

