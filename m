Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBA27D194
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbfGaWxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:53:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32830 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGaWxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:53:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so32680996pfq.0
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J5fdy7Wd9FHVlBYpOs7Z6b4FYMlCutBaVHd3ZTvQnx8=;
        b=jcvbyeO2Rb27mNd8+lNcStEOaoRfSBfIecOdeOrvehK1UDI3XXjVpnaSL1Y5VbgW0o
         S43AF7PCzFEJIzJb7T9OY8rvM6899WR8raNH7Q1x+ulDZXGVgvvBio39kalP+YHLuWWX
         9fFavIJ3A1Upf0jJXLMFN6P/tCRtAc+4DZDVsEm0eQ5TDR78H73gh/rbMhAEU6bfxNTg
         grHUKYAFHED5LCNQSvcLQTDqwBygF07HXRgwjJqDJRUw9xXVBvZsDBeKVGK/o94BfIb7
         ZkSAS3k+LQqjoxBxsKIk5YWLFT5xTrWE117kWcnAxP/Mah8wyBd32ATujwmACKDQoKh+
         8NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J5fdy7Wd9FHVlBYpOs7Z6b4FYMlCutBaVHd3ZTvQnx8=;
        b=EiB4bjh9Sakz9L/kyOHpVSDzftLyGUy8Sh2x3QbmOrekNB+rLgBEDh+0ZNnyaQq6/Z
         yJl8T62E2UWd01byTueiTt8NYb7nxxvsIpUbUyvJijpDC87gsg8oHn9+Tc6qgVQSPVWw
         qy4JKT3xQvd/zxbHr//HsKcR+Dx8vmrEe+R5BLwNL2tZ07T0SbZKhISQnpJzKIdPi25A
         jvg7lOFuPfEOSLoKo+c1bOghK6NXRY0jjs1jHn0HI4zNBovniK4nWVdBxPJZEvtuy/EV
         232iCpEYNFQYsMp3MF9lLDVe0D3wH+xrBTUfCL5Ii1cajnEoF+9CoBTGU3emM9qJQ4y3
         dmjQ==
X-Gm-Message-State: APjAAAWnmf2CJ7tEpN/VgOsQlYvrxQ3hurMTAmpTfi14rp8PiAdbllJG
        U3kF/z0kvqikAHnMp8kjp6ngC9cL
X-Google-Smtp-Source: APXvYqw2iGgfavbMtasargiQy6HXHinRozneVKQp1jvdntL0M9Ibd5QpMWPBFGHiCtK48lDQdqdGFw==
X-Received: by 2002:a17:90a:9bca:: with SMTP id b10mr5142192pjw.90.1564613625545;
        Wed, 31 Jul 2019 15:53:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h70sm64404924pgc.36.2019.07.31.15.53.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:53:45 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:53:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
Subject: Re: [PATCH net v3] net: bridge: move vlan init/deinit to
 NETDEV_REGISTER/UNREGISTER
Message-ID: <20190731155338.15ff34cb@hermes.lan>
In-Reply-To: <20190731224955.10908-1-nikolay@cumulusnetworks.com>
References: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
        <20190731224955.10908-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  
> -int br_vlan_init(struct net_bridge *br)
> +static int br_vlan_init(struct net_bridge *br)
>  {
>  	struct net_bridge_vlan_group *vg;
>  	int ret = -ENOMEM;
> @@ -1083,6 +1085,8 @@ int br_vlan_init(struct net_bridge *br)
>  	return ret;
>  
>  err_vlan_add:
> +	RCU_INIT_POINTER(br->vlgrp, NULL);
> +	synchronize_rcu();

Calling sychronize_rcu is expensive. And the callback for
notifier is always called with rtnl_head. 

Why not just keep the pointer initialization back in the
code where bridge is created, it was safe there.
