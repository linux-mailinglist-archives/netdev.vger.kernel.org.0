Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16E240F78A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 14:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbhIQMcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhIQMce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 08:32:34 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCC6C061766
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 05:31:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v24so29348521eda.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 05:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s9ILYnUMx2WYrPzwGCAPHoHF5xr1796KjybCjen0tPc=;
        b=L8AowE4dpNhojfPTI7rc9oX0w5lzEtDlJMUNAUSLDO2cEMXvua0r7LZfOPW+wpD4gQ
         7KeOd0RWJ2gAKFOCXesTvJ5tuuUj6UWYARQ1+vXYCRvlf4WoJCGJG1UeSKKKm/kGl5kB
         Xofyzzqr5G2UesAXFFU0ZPzWEkhygTvvvSe4+1l9DA0zyTNnBWcZ36qL9vNbTqlJSMnp
         h1VT3XvwRcRdgHJBVw927gWj+G+Ub0aiKODCPoX2jZAF9tAG6gnhB8I3upC17VZIhRJX
         4zsg/tHuTdWhGj12GYkoiJTloL+Jxq10nSKDW5Pp+yPQZCObNJpIegTDJpuKHCWj8G5c
         iChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s9ILYnUMx2WYrPzwGCAPHoHF5xr1796KjybCjen0tPc=;
        b=HNbQ8EWGxpuNaoXBN6jKUDZZ5ypUO0b7Gth4gAXAO2rmGQ9vkzXvL7dm8C/KJzKMqc
         6JRpeVS/kjdOV7k+PWWdi+qYxtXpMm0Xr1Er1fEKrhP1RbKzbKKt18woqLfo8JirFyp6
         c55Lo1ryBAjkTv2QOR3FcQ8PnwPIw3mqRJQOZnojwa6qcpBPnFjh+/kpBFOOnUOVa6mC
         Lm62IGZ8C0wdKoBVxdxFSVMYcqOhmNDYFyiG2a0ku3/r+HeLTzW0lDbZzOI8Mu2qY2Ml
         ADkQADWwdZfKnXpMink37CHLrngJb8cws/AGBDekBr+FjEc9pfxalhFdQDvjk/mm7Jne
         kQrA==
X-Gm-Message-State: AOAM531iU8LzJrmeAHE2UGMn08z6Xuei15sIco0rRgP6KywMw3WJRPNU
        +wgL45xPF6JKJiM8TBsdUEo=
X-Google-Smtp-Source: ABdhPJxHxbiuCKyrYCOTH7E4BapDvpex6zgrI1hQquw5LGjFj9xm6ZuNGzHmOGWv4vXohP1+ziMw6Q==
X-Received: by 2002:a17:906:3c56:: with SMTP id i22mr12000355ejg.287.1631881870471;
        Fri, 17 Sep 2021 05:31:10 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b3sm2240728ejb.7.2021.09.17.05.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 05:31:09 -0700 (PDT)
Date:   Fri, 17 Sep 2021 15:31:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
Message-ID: <20210917123108.vhtfhy67ikk4k625@skbuf>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
 <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
 <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
 <20210917100051.254mzlfxwvaromcn@skbuf>
 <YUSIPMBSAT93oZKo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUSIPMBSAT93oZKo@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 02:21:16PM +0200, Andrew Lunn wrote:
> > > That DSA_PORT_TYPE_UNUSED would probably require investigating DSA & b53
> > > behaviour *and* discussing it with DSA maintainer to make sure we don't
> > > abuse that.
> >
> > How absent are these ports in hardware? For DSA_PORT_TYPE_UNUSED we do
> > register a devlink port, but if those ports are really not present in
> > hardware, I'm thinking maybe the easiest way would be to supply a
> > ds->disabled_port_mask before dsa_register_switch(), and DSA will simply
> > skip those ports when allocating the dp, the devlink_port etc. So you
> > will literally have nothing for them.
>
> The basic idea seems O.K, we just need to be careful.
>
> We have code like:
>
> static inline bool dsa_is_dsa_port(struct dsa_switch *ds, int p)
> {
> 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_DSA;
> }
>
> static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
> {
> 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
> }
>
> dsa_to_port(ds, p) will return NULL, and then bad things will happen.
>
> Maybe it would be safer to add DSA_PORT_TYPE_PHANTOM and do allocate
> the dp?

I think DSA is not yet large enough for us to take the defeatist
position of inserting bits of code that simply protect from other bits
of code.

Especially after these patches:
https://patchwork.kernel.org/project/netdevbpf/cover/20210810161448.1879192-1-vladimir.oltean@nxp.com/
the DSA core should basically never iterate over ports using
	for (port = 0; port < ds->num_ports; port++)
but instead using
	dsa_switch_for_each_port(dp, ds)
which basically ensures that we never dereference dsa_to_port(ds, p) for
a p with no associated dp (the "dp" from "dsa_switch_for_each_port" is
taken from a list).

Conversely, driver code is "mostly" event-driven, so DSA should only call
dsa_switch_ops methods for ports where the dp structure does exist.
What we would need to audit are just the drivers which set ds->disabled_port_mask
(b53, maybe ksz switches?). I guess that would be on the developer who
makes the change in those respective drivers to ensure that the "dp"
which is searched for does in fact exist.

My 2 cents anyway, I might be missing some trickier cases.
