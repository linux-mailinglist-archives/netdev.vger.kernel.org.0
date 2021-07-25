Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127773D5088
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 01:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGYWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 18:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhGYWUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 18:20:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A08AC061757;
        Sun, 25 Jul 2021 16:01:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso4348403pjo.1;
        Sun, 25 Jul 2021 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+ALUZlEdLAU5IQc/san9Pi5d86kHUWtIdunhuw0mio=;
        b=hB/bRQUN8VG5eZuzjPDLZBeqjbZORDKP82Kc/agWS+hUKSHqq8P/jnE/OA+6xFz2qI
         5sry5nx5pe4pIN0VuBxZnzUNRsoM6RX6b/7fOZR+n318hxfUKgHy40XpX7Vm+jfj1Rla
         SO7mEKQjYWMtJfWdmOEYc+x4ay8tEHJqZYELtvhfagWjbyJ0ePgxv7raLY63IfNU0Hv0
         CpDusEBktG0LSJmrBZd9nFdMK1hm3c7bm5vK0BhwBVuGOqupoBKPchihwlegdmXk5CVk
         th6V71nwrYzd8540s+21Od9Okr6PQZ/Lf3sS/sV0ap74dxR9zCYCQMeVsoO6LJ4WTMu2
         JPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+ALUZlEdLAU5IQc/san9Pi5d86kHUWtIdunhuw0mio=;
        b=CkLIx5J5Ti1gX1pjuREoUX7f3YD2U0VeDFOfhKSkyCaSZJySBjWTM0o2rHsTT35OH0
         UUxJL1V56Ykhoww51wbgYQn9W7zJrNDyNRiTGMq3ZLsWFhzcrEXAl6G+XAACw9pHwYpY
         Rw6xEjLnSkQCou2/zs7Z+LAfclZRkNTlcH+pb435jSjAMdAgSj3FdYD9vECd05XuX706
         w/nPeEmaXYvVGF4sbzVB1ATlwivtaEJd4yegU95Jrz8u9FYpm2erfHKd0GnM7d7V/4Nq
         9//dETYRBJMJ6iTMjE8j3TjRAsE9RxtdttDOvxxyP0vNFH2yHiO9PZg45BaIK6cluuXq
         vQTg==
X-Gm-Message-State: AOAM530Vk7FeFqYxsSl2sOQ3MV0FNMjlbcRxRNhg6Co9dXW/yYHiRgPg
        VnbR2Ao+CyJJVGvEXdZaK4tzeQM5VXAz6Q==
X-Google-Smtp-Source: ABdhPJyhMarO+kGIMwW/8bpscX8wtq8DhAVxeDfyV3FUMBMaPUbFNBfJn8nboVDHPvjJDkgD7NdC8Q==
X-Received: by 2002:a17:902:b713:b029:12b:b249:693f with SMTP id d19-20020a170902b713b029012bb249693fmr12027747pls.17.1627254076881;
        Sun, 25 Jul 2021 16:01:16 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:235d:88a7:4ee9:fac6:a616])
        by smtp.gmail.com with ESMTPSA id i8sm11874581pjh.36.2021.07.25.16.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 16:01:15 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id CB66BC3C1F; Sun, 25 Jul 2021 20:01:12 -0300 (-03)
Date:   Sun, 25 Jul 2021 20:01:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Chen Shen <peterchenshen@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: delete addr based on sin6_scope_id
Message-ID: <YP3tOORtoNHZXQdt@horizon.localdomain>
References: <20210725124339.72884-1-peterchenshen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210725124339.72884-1-peterchenshen@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The fix is right, but a couple of small changes:

On Sun, Jul 25, 2021 at 08:43:39PM +0800, Chen Shen wrote:
> sctp_inet6addr_event deletes 'addr' from 'local_addr_list' when setting
> netdev down, but it has possibility to delete the incorroct entry (match
                                                          ^ typo

> the first one with the same ipaddr, but the different 'ifindex'), if
> there are some netdevs with the same 'local-link' ipaddr added already.
> It should delete the entry depending on 'sin6_addr' and 'sin6_scope_id'
> both, otherwise, the endpoint will call 'sctp_sf_ootb' if it can't find
> the accroding association when receives 'heartbeat', and finally will
         ^^ typo

> reply 'abort' which causes the test case for NOKIA SYSCOM GW failed.
> 
...
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 52c92b8d827f..66ebf1e3383d 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -100,7 +100,9 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
>  					&net->sctp.local_addr_list, list) {
>  			if (addr->a.sa.sa_family == AF_INET6 &&
>  					ipv6_addr_equal(&addr->a.v6.sin6_addr,
> -						&ifa->addr)) {
> +						&ifa->addr) &&
> +					addr->a.v6.sin6_scope_id ==
> +						ifa->idev->dev->ifindex) {

The indentation here is not right. It was wrong already, but lets
seize the moment and fix it. This is how it should look like:

 			if (addr->a.sa.sa_family == AF_INET6 &&
 			    ipv6_addr_equal(&addr->a.v6.sin6_addr,
					    &ifa->addr) &&
			    addr->a.v6.sin6_scope_id ==	ifa->idev->dev->ifindex) {

Thanks,
Marcelo

>  				sctp_addr_wq_mgmt(net, addr, SCTP_ADDR_DEL);
>  				found = 1;
>  				addr->valid = 0;
> -- 
> 2.19.0
> 
