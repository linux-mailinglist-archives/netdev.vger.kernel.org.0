Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B002CFFE2
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgLFAFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:05:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgLFAFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607213060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1PTMv1jAtpeUWcWGndewRsnjj2i/VAGcX/7/u2jZ/18=;
        b=ZOfFtJ1mBC9w/1hd0IdwDJ8g9KTDrLw+grHOqLQfQVHhnTUL2xFkp7fGqBANIdCHYsGjrj
        WlnjYpD3joitAussEasKRtDUaRqIPyfFoSsnXx7P9nEhHrAFePHYRKHYU5tGQrE5vrRFQx
        G1ndtGUpAdnqi6AjzdlyT65f3u7csr0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-DVH4yBizMgSdZa5Bp2a_lA-1; Sat, 05 Dec 2020 19:04:18 -0500
X-MC-Unique: DVH4yBizMgSdZa5Bp2a_lA-1
Received: by mail-oi1-f198.google.com with SMTP id t3so4708192oij.18
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 16:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1PTMv1jAtpeUWcWGndewRsnjj2i/VAGcX/7/u2jZ/18=;
        b=tLaFA8j7ygZH17aMjZYWzgDvmZOF3HWQVOvKVkXBe9EaglDJBvcXcws9UN4UfR63+6
         vN4hhYwl8z+rheiqeJ+c+9R3CWFgcOlUiTJr1kUp1LTf0EJwDjjxStUWuFlxtVFzGUc8
         otteISMtKz66RBlkel+dax4LMEB67bo7Z+Y1bq5KRkm/AxJYPpa8X0Dvvgq32qYR8xDy
         EMMMz30qxS/bhO/Dfegtn59NWgVMwGsLoJuV4o4i2DEfYPnfxqsxwR76WP9fscjphfjy
         +LMnRKG5+RlRlwOxjKUepwFaLxVQB/N5AZXjLA7hwrkYOFb3tZr+ycYetrjEfA44H6J9
         UvJQ==
X-Gm-Message-State: AOAM530/G+QdzdnVgRcswkI/5+sJymfMzLN4+2KDKoQz6sH+Xo+laLET
        l1jf74aMK9wSsqXR/9dg8Vo0uax5Fr81SOKw60SicIqb1bVWeT/MUSjW1+VCJZvsBjEGTC7h6kA
        SSwe6ZpZZdiVtiAHCQI6K/fgXdekaEP9R
X-Received: by 2002:aca:6255:: with SMTP id w82mr7519549oib.5.1607213057482;
        Sat, 05 Dec 2020 16:04:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFASe4IQPGbORhy64eXin9gvvpa2Q7MkG9KikJp4t+e2hQKh81wiczxdbjtlzDqM7t0yrTxamAW4wxxBCSdY8=
X-Received: by 2002:aca:6255:: with SMTP id w82mr7519542oib.5.1607213057241;
 Sat, 05 Dec 2020 16:04:17 -0800 (PST)
MIME-Version: 1.0
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
 <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sat, 5 Dec 2020 19:04:06 -0500
Message-ID: <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com>
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Limin Wang <lwang.nbl@gmail.com>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> > Under relatively recent kernels (v4.4+), creating a vlan subport on a
> > LRO supported parent NIC may turn LRO off on the parent port and
> > further render its LRO feature practically unchangeable.
>
> That does sound like an oversight in commit fd867d51f889 ("net/core:
> generic support for disabling netdev features down stack").
>
> Are you able to create a patch to fix this?

Something like this, perhaps? Completely untested copy-pasta'd
theoretical patch:

diff --git a/net/core/dev.c b/net/core/dev.c
index 8588ade790cb..a5ce372e02ba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9605,8 +9605,10 @@ int __netdev_update_features(struct net_device *dev)
        features = netdev_fix_features(dev, features);

        /* some features can't be enabled if they're off on an upper device */
-       netdev_for_each_upper_dev_rcu(dev, upper, iter)
-               features = netdev_sync_upper_features(dev, upper, features);
+       netdev_for_each_upper_dev_rcu(dev, upper, iter) {
+               if (netif_is_lag_master(upper) || netif_is_bridge_master(upper))
+                       features = netdev_sync_upper_features(dev,
upper, features);
+       }

        if (dev->features == features)
                goto sync_lower;
@@ -9633,8 +9635,10 @@ int __netdev_update_features(struct net_device *dev)
        /* some features must be disabled on lower devices when disabled
         * on an upper device (think: bonding master or bridge)
         */
-       netdev_for_each_lower_dev(dev, lower, iter)
-               netdev_sync_lower_features(dev, lower, features);
+       if (netif_is_lag_master(dev) || netif_is_bridge_master(dev)) {
+               netdev_for_each_lower_dev(dev, lower, iter)
+                       netdev_sync_lower_features(dev, lower, features);
+       }

        if (!err) {
                netdev_features_t diff = features ^ dev->features;

I'm not sure what all other upper devices this excludes besides just
vlan ports though, so perhaps safer add upper device types to not do
feature sync on than to choose which ones to do them on?

-- 
Jarod Wilson
jarod@redhat.com

