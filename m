Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D72F565B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbhANBqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbhANA5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:57:45 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EB6C061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:57:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n26so5778228eju.6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n01Kmt/L++GKHit0hC3GLS7EuaeGbU0d9RonEJwhoA0=;
        b=HvyzRZlv40DEBhH8Nb9wv517Inc5/aN4VTS70KlohxDky1Yj+5jvey3vLlyM66I2uj
         PpxfAarBM3qBX0tPHSo5MJnowJ91nQq7BjVSpb72+wuygI4RqjAKABoxm/jj2hAuisk7
         e+xLdDPUq8L6E7+WoZNL/r/kR2ig46MXCK7j2FwogHqxA7Yaj8grnzOyVLOF5ikLK+on
         cPmy2+tRHUFyfTzuj6T/ZxGQZFTXuF7S+vZYpC7WCs1G4UogIN0M8d/QdPPZvwj8paLx
         63K1Hg9qKYLkMFFO7tMg/Hbsao77gPDy5Ayugvd6QX69zQSBFozed1cAnN4e8cKVKxov
         Mekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n01Kmt/L++GKHit0hC3GLS7EuaeGbU0d9RonEJwhoA0=;
        b=mnI7xOEcioYssdGEC18CCH3Zb2PM3HmhbaYv/kqFCthEnhdKdHZncFsYvxO3LLry2t
         +AmMow4y6mIZv5qYrQomWg0GNTf1tv2abw4oCs3Gb56xlwAcIu+t6YGSwjnw1R7pFYJH
         ROZcZO9InCm1ZVI/Y9favEN+r6oCys0IkapHTaPou7QPfFGiHXVahkOfgsr9UFdOYFpO
         lJfsjHOPGknuC1loF6M7Lln6oBvQktNEA6q6mZI+mJTIV1XZjZgCSUP/VK0bNcDynh1c
         DdkgrnMDFRwmg/JDdqsQUFBPqDW7TLqb9OfbELR07fC1YteJhMUKg6T9E3/IelIi9uFE
         hWow==
X-Gm-Message-State: AOAM531+flQX/80JZjLwWcyQYZZSDhfOP4N9osaBHbWkrtBntlN/nkNx
        P05TJu2vNe/HaW6HARSGEio=
X-Google-Smtp-Source: ABdhPJxSGnRAiawSTyhPZ2emqxxqsc+8IKwBZkKQD39OqaLrxtZaqlMPnrWlMGzrFqrHXYVsStpL9g==
X-Received: by 2002:a17:906:3711:: with SMTP id d17mr3393031ejc.121.1610585823354;
        Wed, 13 Jan 2021 16:57:03 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m9sm1492861edd.18.2021.01.13.16.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:57:02 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:57:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: felix: offload port priority
Message-ID: <20210114005701.lgwcle3j2jypu35u@skbuf>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-3-olteanv@gmail.com>
 <X/+D+2AgnOqCxb2d@lunn.ch>
 <62d9811f-93e4-9d9b-c159-76c35fa919dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d9811f-93e4-9d9b-c159-76c35fa919dc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 03:37:49PM -0800, Florian Fainelli wrote:
> You are passing the whole dsa_mall_skbedit_tc_entry  structure here,
> only to look up priority, would it make sense for now to pass
> skbedit->priority as a parameter which would be matching the function
> name and what it is dealing with?

Actually I am passing a pointer to it, which should be more or less
equal in size to an integer. But I can pass just the priority, sure.
