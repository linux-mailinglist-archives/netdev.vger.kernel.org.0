Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEBC2F56C0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbhANBww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbhANADP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:03:15 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0AC061786;
        Wed, 13 Jan 2021 16:00:30 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d17so5610406ejy.9;
        Wed, 13 Jan 2021 16:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OxkcNELkcCo/aMS9YNTMH8XO6gLQFInf3RW2jo57p2o=;
        b=PqDLE4/VPwfZX+brKhVkhTucguav9SJ0jN8BBlLU6Il0OqlarzFPkFmn8k5p1n0YCN
         owKhrluy+DPHKU72y5Rz0NOE39O/VThfnYJe1Znih5GSaFWwXCGFb075cE+bmlP/FXKi
         hwKjJozoF5D73+8yee+xK0h/d8sccVmjH6cOFJJDzFCmyszb69Ed84XvQkOyqO3nmAgx
         M3yy8dhA5cr9OGXLKUknE+QoYA+IR9R4rVd+S5EVBlM7pevDWXs2kH+yF5KqApRuUHFW
         zpRkpWIU73ORR2EWLDvMC58mZqm6gNQWkbtaR4jXzbskWC3PWRURiIBhdOY4JLI8ZIVp
         6sPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OxkcNELkcCo/aMS9YNTMH8XO6gLQFInf3RW2jo57p2o=;
        b=m8ndxzO1D3XeWz4yyQcn/VkBUTnd3iqUhW0kcgi2pZ8lo3b0mASG03rYgJI3G/vZ+m
         Fw/j3zsl77D3i7PVfzA2xNQa3kl4mhgb1encnldi0ynLZq+6bsRehh1Hrh7vxvJsPuOQ
         luxOgB2BY1GnrePhQ8eG6hDXlidEYjOFCx/P8FYVPgYr3ddaKc+APpCPqYjIuoRr7jFh
         Az8IUas9I6yb1VMlbwUohr62mBAcpCQocvgMNwS9DzzNBE42cOYRrcnVgcENSWDeIpa5
         luqem93vC+jMuZmmd7S4r7qWjbNEnal1ZUH5evepydFCbf/dRjGCx5kp8uIse9Nd4Q80
         VZWA==
X-Gm-Message-State: AOAM531rfaXt26V720+nRMgYf+vCZA6sF/zuB3mZqxqZfrssZ/u1s2iq
        vXTvz+kTRH5RGz9NbhHoRyY=
X-Google-Smtp-Source: ABdhPJz4UN+z3MR0r0/BbGmjZbw4opSgWZAGV5LOPo8h0B684A11rl0DB8Lsb+fwR3/QxQKBhMwYWw==
X-Received: by 2002:a17:906:3d6a:: with SMTP id r10mr2256707ejf.408.1610582428831;
        Wed, 13 Jan 2021 16:00:28 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r16sm1480325edp.43.2021.01.13.16.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:00:28 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:00:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/6] net: dsa: ksz: move tag/untag action
Message-ID: <20210114000027.sw5gkdedtwnhswi4@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <8e1cd9b167bd39c0f82ca8970a355cdfbc0fe885.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e1cd9b167bd39c0f82ca8970a355cdfbc0fe885.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:18PM +0100, Gilles DOFFE wrote:
> Move tag/untag action at the end of the function to avoid
> tagging or untagging traffic if only vlan 0 is handled.
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---

No matter how much you move the assignment around, there's no escaping
the truth that the Tag Removal bit in the Port Registers affects all
VLANs that egress a port, whereas the BRIDGE_VLAN_INFO_UNTAGGED flag
controls egress VLAN stripping per VLAN. Sorry, if you work with broken
hardware, you might as well treat it accordingly too.

And as to why the moving around would make any difference in the first
place, you need to do a better job explaining that. There is nothing
that prevents PORT_REMOVE_TAG from being written to the port, regardless
of the order of operations. Unless the order matters?
