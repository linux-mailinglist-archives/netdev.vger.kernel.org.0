Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1E481698
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhL2UPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:15:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33654 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhL2UPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:15:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3DB9614D9;
        Wed, 29 Dec 2021 20:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00303C36AEA;
        Wed, 29 Dec 2021 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640808938;
        bh=7iyaFWLPgYjnHDSKKvd0Mh8/pRpkgZcI8x6NKYB2mnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WX82uNED7rbYUY9uxhIffcoGboMiIvqurlmdOLXYH+QmXSA6PIIUQ3LPeXjUgn7SW
         6CmL7+ZSc3Jcx5nzEsFuqF30IMMQ/WYHRiJPznqfwAQsxYvxr6AaA9u9ODXtpKCYzr
         j25LGAsMyo/UBdu2lN/uOTFSS6fBPHOwU0AbmUKvYuJdTIPTlC9j2L4RHA3/4uDfth
         hNTiizJA4l/3iVj9/oCnWDTvRtLN0JIUi2RYD20YTM43TQusv033n1cWnVVXBcc5h8
         0a84MFo09GzI7KT4aTz8P2sdsOzqLFDYX43mw1Y2hgssFuFCY6sZpUYzFfpqBt+Qa7
         8ts7LjuJOAU7w==
Date:   Wed, 29 Dec 2021 12:15:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] Documentation: fix outdated interpretation
 of ip_no_pmtu_disc
Message-ID: <20211229121536.06d270e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229031245.582451-1-xu.xin16@zte.com.cn>
References: <20211229031245.582451-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 03:12:45 +0000 cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The updating way of pmtu has changed, but documentation is still in the
> old way. See commit-id 28d35bcdd3925e7293408cdb8aa5f2aac5f0d6e3. So This

not a correct way to quote a commit, please use: %h (\"%s\")
as the format.

> patch fix interpretation of ip_no_pmtu_disc.
> 
> Besides, min_pmtu seems not to be discoverd, but set.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

How does the bot discover this sort of problem?

> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  Documentation/networking/ip-sysctl.rst | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c04431144f7a..dd5e53318805 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -25,9 +25,11 @@ ip_default_ttl - INTEGER
>  ip_no_pmtu_disc - INTEGER
>  	Disable Path MTU Discovery. If enabled in mode 1 and a
>  	fragmentation-required ICMP is received, the PMTU to this
> -	destination will be set to min_pmtu (see below). You will need
> -	to raise min_pmtu to the smallest interface MTU on your system
> -	manually if you want to avoid locally generated fragments.
> +	destination will be set to the smallest of the old MTU
> +        and ip_rt_min_pmtu (see __ip_rt_update_pmtu() in

I don't see how this is a meaningful distinction to someone reading
this documentation, more of a corner case.

> +        net/ipv4/route.c). You will need to raise min_pmtu to the
> +        smallest interface MTU on your system manually if you want to
> +        avoid locally generated fragments.

Use tabs instead of spaces.
 
>  	In mode 2 incoming Path MTU Discovery messages will be
>  	discarded. Outgoing frames are handled the same as in mode 1,
> @@ -49,7 +51,7 @@ ip_no_pmtu_disc - INTEGER
>  	Default: FALSE
>  
>  min_pmtu - INTEGER
> -	default 552 - minimum discovered Path MTU
> +	default 552 - minimum set Path MTU

Also not must of an improvement IMHO.

>  ip_forward_use_pmtu - BOOLEAN
>  	By default we don't trust protocol path MTUs while forwarding

