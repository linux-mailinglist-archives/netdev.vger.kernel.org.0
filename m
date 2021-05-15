Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0E13819F0
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhEOQqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 12:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhEOQqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 12:46:15 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD32C061573;
        Sat, 15 May 2021 09:45:00 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id l129so1956711qke.8;
        Sat, 15 May 2021 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Di0tqQRWLN116HzASz5hiSUHMEBmVNCl6fxRwEe3CFk=;
        b=f+jMnZN0cLBSqvApg/1qJq/cF1cVYc3CpgJKG8GQBoLex92Jp2NG9PuGnfZnIkifdp
         EHbAvdtIakodfGPxpErihof3l0WHWeGkVcvoxt9oUEofkDzNDJIIAhvGwBR0zZEIhRoY
         9Dr/qC8+m395QhSuoilv4Ljyb0VdVCQwff4Ifa58Iv7N2xFs5ceoHs4tfB0669zWBV5p
         bD6/ADBx1QvRYMTRQ17utQzZHxgzEtBcOboz1A6JhjdjkoQW47OE5vmH+OgxMzvsTMFo
         ZiNk15+bVeIXtjXTx1qboJNN0Qw8F6mZMMA6GibYC7LNIqgmlPbUHX6qf3hK7gvBRv3c
         /OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Di0tqQRWLN116HzASz5hiSUHMEBmVNCl6fxRwEe3CFk=;
        b=rD89NbRQdM+HCN1xIRLG0ulOHshtTFsYZ44opWc824R2wYtDcyFzMxl4PY/vF1jtap
         7QMS8OK3YEVJmU1B793d0t8MTGJK4DgzUg1TSi6e+96A5ly4bxgK02FMF7lwioGDW3mP
         PndvEvI+Q8lhir7Xj9YK7WE6oW2xhk9vPGx1JfSyTZsTeoWvqZjehDUubafpuB4YgKeP
         0yvD0x0NbT3KuEypABV9i5wsIQCZ1oGR5qCf67qCxhv6kdNa2nZlx3dH6Fr3QQYjOII2
         foz5uil6pePcYM+lGzflp7YVm+DyARVKcLxOgdKC2mk6N9o051+MdiQn7pYraso0C+TU
         Iavg==
X-Gm-Message-State: AOAM530e5afzmF7fYidLzlanFT7sz70ItMCgUayitmA4N5hnT93Jcp8t
        vgwLlr+PHvxf8an11w8fxKI=
X-Google-Smtp-Source: ABdhPJyLgyUXFdIj5scFIJV7gr8fsGegR4P4H4zNwmp6ri6zWh1k8GWiIoA1ywsmrJR5DvJlrLQZbw==
X-Received: by 2002:a37:a2c5:: with SMTP id l188mr49124178qke.413.1621097099495;
        Sat, 15 May 2021 09:44:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j25sm6847094qka.116.2021.05.15.09.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 09:44:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 May 2021 09:44:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next v4 05/11] net: bridge: mcast: prepare is-router
 function for mcast router split
Message-ID: <20210515164457.GA1387203@roeck-us.net>
References: <20210513132053.23445-1-linus.luessing@c0d3.blue>
 <20210513132053.23445-6-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210513132053.23445-6-linus.luessing@c0d3.blue>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 03:20:47PM +0200, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants make br_multicast_is_router() protocol
> family aware.
> 
> Note that for now br_ip6_multicast_is_router() uses the currently still
> common ip4_mc_router_timer for now. It will be renamed to
> ip6_mc_router_timer later when the split is performed.
> 
> While at it also renames the "1" and "2" constants in
> br_multicast_is_router() to the MDB_RTR_TYPE_TEMP_QUERY and
> MDB_RTR_TYPE_PERM enums.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>

Just in case this hasn't been reported yet. In next-20210514:

$ git grep br_multicast_is_router
net/bridge/br_input.c:                      br_multicast_is_router(br, skb)) {
net/bridge/br_multicast.c:      is_router = br_multicast_is_router(br, NULL);
net/bridge/br_private.h:br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
net/bridge/br_private.h:static inline bool br_multicast_is_router(struct net_bridge *br)
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Guenter
