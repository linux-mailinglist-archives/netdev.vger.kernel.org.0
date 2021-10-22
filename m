Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E413437FC5
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhJVVJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbhJVVJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:09:10 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63221C061767
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:06:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r2so4379557pgl.10
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=gHw+pn9DDB0LiQkFqaDLxnynpJ8V6eTVZios7QCTe0o=;
        b=m31/iya9ayFgkIjwWrfetKAtkISELLXtpQb/0k4PRUM8eLW9lf4Oril/F1v6vrfOK5
         RGSFOVTR+zVmyIiHKWSb54w2WAKsJwgj6AtYe7fimAR5XVrGZOVjye0ZqFByCtc20Lgx
         gU7MO73oCbMarymtXulQcfCG2QEZiRzkgDivgqNxsiAf47uvxv9o/wo9xtF5r6NGeV5h
         bRaw8d3OGKugzHSHD7G3ave4OZiI6m5a0FymtR/wuQi5vwIPWzaYpvWa54ULhJw6ukun
         8s+ny2m08XbJkWui0Z36ZDHcQP3+tLx+ydRzGJWAmQiceG8v0w/koBXzK3MiALIARcPg
         7cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gHw+pn9DDB0LiQkFqaDLxnynpJ8V6eTVZios7QCTe0o=;
        b=FL5zE2HB/LRCzvzbtz4E8e8tUK2N3vBS7rB9zYPUZq0lq6oMH/B1+X9eHnmeAUYBBe
         CGckqjy1rk9eqmTqUdljHCGbR3TYZ0E6FPgdxlc89igbNAmXqzsv5J/Me23ha5vC5hyW
         h4buy0M8fPvidT9hgc6+DYGUzksF3rLX6Rmx4wpMRYOlu5/M/E6KLpWjZsG2VIgomOGO
         qvLwtg7FoL1My7dY8QD4K3Em3IO2+r4D5RUjHea73nVJ5d7Mynz876rBOWfinNW/dGhY
         a2GsAMJQ+OhxntcrKJ64fdW6oTZsTTv1PoWlNF7Y5XV9PUV/arvFiCNN7lDRVIHEAS7c
         +ipw==
X-Gm-Message-State: AOAM53093EdFEqr+m0xw9nOzRle07QkdRn/5r6vf3o0qLs0NCeiiZfaE
        IKgb5K5tdVfLRHAzhYfmR9GvbiPxczE=
X-Google-Smtp-Source: ABdhPJxUdUVdgJBm6YQVuo2G9kQcvbEfV0/rr84MAapglTE6ZuIVnkk7NcGw6Uu9ktX9V4ZFRX/U+g==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr1581854pgc.173.1634936811696;
        Fri, 22 Oct 2021 14:06:51 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id u1sm5383579pjy.17.2021.10.22.14.06.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 14:06:51 -0700 (PDT)
Message-ID: <8b2b8f0e5648a237722c5f3cb6c6d2d8542f1054.camel@gmail.com>
Subject: Re: [PATCH v6 2/3] net: ndisc: introduce ndisc_evict_nocarrier
 sysctl parameter
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Date:   Fri, 22 Oct 2021 14:03:27 -0700
In-Reply-To: <20211022180058.1045776-3-prestwoj@gmail.com>
References: <20211022180058.1045776-1-prestwoj@gmail.com>
         <20211022180058.1045776-3-prestwoj@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[snip]

> @@ -1810,10 +1811,19 @@ static int ndisc_netdev_event(struct
> notifier_block *this, unsigned long event,
>                 in6_dev_put(idev);
>                 break;
>         case NETDEV_CHANGE:
> +               idev = in6_dev_get(dev);
> +               if (!idev)
> +                       evict_nocarrier = true;
> +               else {
> +                       evict_nocarrier = idev-
> >cnf.ndisc_evict_nocarrier ||
> +                                         net->ipv6.devconf_all-
> >ndisc_evict_nocarrier;

Whoops, this should be &&

> +                       in6_dev_put(idev);
> +               }
> +
>                 change_info = ptr;
>                 if (change_info->flags_changed & IFF_NOARP)
>                         neigh_changeaddr(&nd_tbl, dev);
> -               if (!netif_carrier_ok(dev))
> +               if (evict_nocarrier && !netif_carrier_ok(dev))
>                         neigh_carrier_down(&nd_tbl, dev);
>                 break;
>         case NETDEV_DOWN:


