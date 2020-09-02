Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E0525AF1F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIBPeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgIBPeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:34:12 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE94C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 08:34:11 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ef16so2392824qvb.8
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qUX9x7tN2/cZS0qqgKTf1o6WdvsTJbK/ikSJXEcKLw4=;
        b=V1o/7C014RhbotQJeKIozZ4CGi308uNXRLf/ORULUUHb5jHw9hjQ1RrPHpcbic/jHu
         qm8QyAv9nZPHmYy+gbwzkHlcYHvlw3ktqdnNKp3jXK1bByzkCBBI7lOtxfOQKrjVTmFj
         ahpd0tdUMdi9O7WiDaSpdo6dC0DBz+UvFJWldCrNTCb3Au+F5veZwj8j+ZamMl9PKX7B
         8tCX5MLR6qAGIcEORfEoGbOF7jgUx0YzoTDCSV54KNI95BnxkVqdZohOcICQG/uIpZnF
         V0ng6keDEpLkf/A/JNdMQLFh7aCbq67r6LfGIY7RqNSqEWUNjgOQhKrtQrEa5OKAUUDX
         94Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qUX9x7tN2/cZS0qqgKTf1o6WdvsTJbK/ikSJXEcKLw4=;
        b=MXEisiormofm50hwdUugUXfGU98bb4+tHZFXdlxFFiiH14TaBinqvEkVeU9pjFBykp
         prgdYa9s4WkHj+f0L72fhHu3SJy+Zv1LFubOSk4kCe+CuLDHaN4D5WTYVPp0KeJQEc3H
         +HQ9TP6Bg3k0kUlZEzpUtmkIOjczzMRGaCwCe5GV+mA/6j7+lsTDLvSq13Y89Zj5ExqN
         lBI7eJhTrMZemLr47VTTL+jdvD7WUGAJCgpKpINVDJeEGvHwqrrFSwsjHTwwJ8dfyofv
         YpNp4ORWGCtbd6IpsGjUWvKGpvzDOLC+/F+B90EVqOmIU5c/fgTR/XzGDU8ypLZJp8zj
         NMXQ==
X-Gm-Message-State: AOAM530laHZCw5fI/nalLHGISZVrne0dmoky6Q/mkc1np7cc4UE5lTGR
        HCMHjdcQoqC+qdrxxw4NxP4diUdz7w==
X-Google-Smtp-Source: ABdhPJwSjts4yXqiGMXZavY+L2jwiWfOhJ6gYxzCcDDxM0zf/dcT1XFkq8M32389smlOzC6DzSHLCw==
X-Received: by 2002:ad4:5101:: with SMTP id g1mr1868664qvp.104.1599060850901;
        Wed, 02 Sep 2020 08:34:10 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id z6sm4972643qkl.39.2020.09.02.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 08:34:10 -0700 (PDT)
Date:   Wed, 2 Sep 2020 11:34:02 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] ipv6: Fix sysctl max for fib_multipath_hash_policy
Message-ID: <20200902153402.GA4801@ICIPI.localdomain>
References: <20200902131659.2051734-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902131659.2051734-1-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 04:16:59PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit added the possible value of '2', but it cannot be set. Fix
> it by adjusting the maximum value to '2'. This is consistent with the
> corresponding IPv4 sysctl.
> 
> Before:
> 
> # sysctl -w net.ipv6.fib_multipath_hash_policy=2
> sysctl: setting key "net.ipv6.fib_multipath_hash_policy": Invalid argument
> net.ipv6.fib_multipath_hash_policy = 2
> # sysctl net.ipv6.fib_multipath_hash_policy
> net.ipv6.fib_multipath_hash_policy = 0
> 
> After:
> 
> # sysctl -w net.ipv6.fib_multipath_hash_policy=2
> net.ipv6.fib_multipath_hash_policy = 2
> # sysctl net.ipv6.fib_multipath_hash_policy
> net.ipv6.fib_multipath_hash_policy = 2
> 
> Fixes: d8f74f0975d8 ("ipv6: Support multipath hashing on inner IP pkts")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv6/sysctl_net_ipv6.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
> index fac2135aa47b..5b60a4bdd36a 100644
> --- a/net/ipv6/sysctl_net_ipv6.c
> +++ b/net/ipv6/sysctl_net_ipv6.c
> @@ -21,6 +21,7 @@
>  #include <net/calipso.h>
>  #endif
>  
> +static int two = 2;
>  static int flowlabel_reflect_max = 0x7;
>  static int auto_flowlabels_min;
>  static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
> @@ -150,7 +151,7 @@ static struct ctl_table ipv6_table_template[] = {
>  		.mode		= 0644,
>  		.proc_handler   = proc_rt6_multipath_hash_policy,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= SYSCTL_ONE,
> +		.extra2		= &two,
>  	},
>  	{
>  		.procname	= "seg6_flowlabel",
> -- 
> 2.26.2
> 

Thanks for catching.

Reviewed-by: Stephen Suryaputra <ssuryaextr@gmail.com>
