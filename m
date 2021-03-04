Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CD532DD88
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 00:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhCDXAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 18:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCDXAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 18:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA3864FF1;
        Thu,  4 Mar 2021 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898851;
        bh=h8OtW+EVLYdr2UvVl3jhQH0r+BdVHRK2H9GoLb9XVJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JiOPNImtpG0s1B0GTWBZoQFPD6s9qgM8FZgjqqXGfqI0lIkHNXIPd69D8xeuYzIyM
         jB073V0j7vYfY5e4btkLoQqYeIG1vIkDWuuNuOe6ZShQs8ewtlXBgra5CxGePBVNLu
         0OrrHGBb9imAbIg+TYB5J6hIr9SuULXIwRErdHmmjxbGKjhg7Rs7jJlZ4J1mxToH2g
         qj4MDOf6WPMszv/JugeogAg0KFDaeEfImmQb7+F1b0It21SG76JXklTe8Ob8VcDr7S
         uScarCVOUO6eTE8+zvKbLZM+o6QQ3KNuZpgAp3vjOAD59vf34momzCp0KcEtlJR96o
         xtk0O3KmlN2vg==
Date:   Thu, 4 Mar 2021 17:00:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 112/141] net: rose: Fix fall-through warnings for Clang
Message-ID: <20210304230049.GB106177@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <a1b09757cea712d628d1651477f459c8f4d65300.1605896060.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1b09757cea712d628d1651477f459c8f4d65300.1605896060.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:38:32PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break statements instead of
> letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/rose/rose_route.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
> index 6e35703ff353..c0e04c261a15 100644
> --- a/net/rose/rose_route.c
> +++ b/net/rose/rose_route.c
> @@ -347,6 +347,7 @@ static int rose_del_node(struct rose_route_struct *rose_route,
>  				case 1:
>  					rose_node->neighbour[1] =
>  						rose_node->neighbour[2];
> +					break;
>  				case 2:
>  					break;
>  				}
> @@ -508,6 +509,7 @@ void rose_rt_device_down(struct net_device *dev)
>  					fallthrough;
>  				case 1:
>  					t->neighbour[1] = t->neighbour[2];
> +					break;
>  				case 2:
>  					break;
>  				}
> -- 
> 2.27.0
> 
