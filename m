Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19F43C9E25
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhGOME1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhGOME0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:04:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCC9C06175F;
        Thu, 15 Jul 2021 05:01:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l7so7418329wrv.7;
        Thu, 15 Jul 2021 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRyUbi5VIG0vSzwP6HRl5JUNRctmMQF6hywTD8MaKnk=;
        b=c6fyB3JHulWmVHAqhAC6vTlBPw63h7m6J2q1ExoWibiCxPd5nymMk0GA5WsqW7/lsE
         JwmV8WmeycHG8OVg3fa7j9XbmzzzSWsv1uWfDvg+m8LZ9hKGH+ovCsRRnH4lIEIab9Fs
         +vunMCgB/ZOFu2z1x5MEy16qjHBGys6tqfIFY2QzFc/jWkXDXJH7aKncZX772WvKaZZY
         HXfdksESSXlCl9Nlsx8a+QNZknx/YRMHubkNqCWMvxIsgHBBOOLqv5C8hp7MHs/suMbN
         Bua3WsbGQ1Ooi2teXKUuS+e4EwEE3Et2iJ8ppgcd+bf4GUyWz44sPd0yxR1NaXqsKIXG
         tBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRyUbi5VIG0vSzwP6HRl5JUNRctmMQF6hywTD8MaKnk=;
        b=ZM/pR+TNc15thTpCe9nEvDZTPmg3zcJ4B9Hpl/2pvuMCI7oAmYyM/dY35LHlmMaG4x
         eSx9r1SrPz/zcSlFxAK0iDlDyj2lUunrhuKhQGlcGEHSazY7SsxWBwx/91LAvkrZninq
         ttgQHXiyjYYewY/UOAgp/hQv5jDjFlmCMUUEhdX+7wDd7l102dDf7VreLhLqtR7IP9ta
         wEPuhV9OB6kSKILk2tPa0DFyxykr+nU0lUTHjnEKZdW/HCYHA1GAp1nDYzWBE13FYinn
         askrvwdAR8NfNU9oZkfZrdJV8JeQu77uXU4h5mO7xChmxQQiw4pzY+7IO+iwX1DTHh8K
         6Tmg==
X-Gm-Message-State: AOAM532Gph6+tPidqzCBAZzFUrizHW64OQCKr+WvfCoOZvjBFEUZdoB/
        KUu+5i0L80A9AdmXFVukNWPGChMpIeU=
X-Google-Smtp-Source: ABdhPJxqFT1UDc9OUVGfgmurEWV1hpJN8VbhQsnBgxhli0jKDqGiTp5mVQsnB7lS//DPr1QcNtFJLw==
X-Received: by 2002:a5d:4c50:: with SMTP id n16mr5095363wrt.249.1626350491061;
        Thu, 15 Jul 2021 05:01:31 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id l15sm6483617wrv.87.2021.07.15.05.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 05:01:30 -0700 (PDT)
Date:   Thu, 15 Jul 2021 15:01:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should
 depend on NET_DSA_MV88E6XXX
Message-ID: <20210715120129.comqj4lqiwcusj7q@skbuf>
References: <0f880ee706a5478c7d8835a8f7aa15d3c0d916e3.1626256421.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f880ee706a5478c7d8835a8f7aa15d3c0d916e3.1626256421.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 11:58:12AM +0200, Geert Uytterhoeven wrote:
> Making global2 support mandatory removed the Kconfig symbol
> NET_DSA_MV88E6XXX_GLOBAL2.  This symbol also served as an intermediate
> symbol to make NET_DSA_MV88E6XXX_PTP depend on NET_DSA_MV88E6XXX.  With
> the symbol removed, the user is always asked about PTP support for
> Marvell 88E6xxx switches, even if the latter support is not enabled.
> 
> Fix this by reinstating the dependency.
> 
> Fixes: 63368a7416df144b ("net: dsa: mv88e6xxx: Make global2 support mandatory")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
