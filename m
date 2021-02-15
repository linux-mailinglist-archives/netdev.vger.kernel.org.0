Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226B431C335
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBOUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhBOUuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:50:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366E1C061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 12:49:26 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id y26so13317903eju.13
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pfNEStwFcWqPoh/uiEp7DHsqWq4a322a/UhRl3ZxrMo=;
        b=TrCZjIaUBM2KdX3xnO4Jsd08raEB138jHpfHjMkpthG0aWqErnwVrKSGcUVBtZ6k6B
         2EF6SPRE+PATEfu/wT5ppi6FFMMU76MII37Fqmnw2KsjGPoh9N2jolhk1e2g6ctkvxS/
         RyczpVIBLVekPoMfcPm9IR+I/F7vJiQUZYAIKlzEZEs40TlA7sPcoXIC2rwAzBuDi3ZV
         bMBm5iD5+92MPbeGSYikfwWDuOB4dz9UjeDONcze7brlhfpvqdvvKKHAjgwVk2OwH6eK
         StmeRpVReZ5Okqm1tHNSw9bfzHm6d7JYB3A5o2XffecLGMry4FQqbulYnPiBEzYm3OtC
         pxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pfNEStwFcWqPoh/uiEp7DHsqWq4a322a/UhRl3ZxrMo=;
        b=gTEppwHOeHu7WVJILYTk2JIceHq7FAPj+lWHPl2Zhf17ljEDttkM4BLpmviCNo6L7M
         wdE6X0siuxPp8oDbOnJ9RrkuKO3XBKdv8kV6FtgJSlNRbfbFPfGa05ahrYBvtabHVL8s
         kRVXbfxFzyhyKsRySrzSvSK+2Qqme96iYgt6yifmOzWkoZa1jGk3loCk/kQ2COfJr6XB
         3XAnbpYqUq2OBta8nn+0eP283uDXXKGFoMYxdWipqb4NLvAz+xaDVJvAYEPIBXwN9+pd
         gvC1mHrV+chCGBu1qAcXegfje64/MLArP07JYmf3Lq4nuZFGYWTUwQ3GRV9x/SIeTENy
         iZYw==
X-Gm-Message-State: AOAM532DeT2UKu1zudJGEfTRJggkjY2AckW8zWxwxF39N9yKSi4pU0Bj
        eBGLFY+Ad/iHpRfIG2CzoSw=
X-Google-Smtp-Source: ABdhPJyEFkQCzFAR6qGDO23TW0xDg2xTnNHEgdS9lqsSFosFVKRkZnQ4Ua5Nf/mqp7pxYSzzfT1Neg==
X-Received: by 2002:a17:906:3801:: with SMTP id v1mr17738235ejc.353.1613422164902;
        Mon, 15 Feb 2021 12:49:24 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i18sm11042565edt.68.2021.02.15.12.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 12:49:24 -0800 (PST)
Date:   Mon, 15 Feb 2021 22:49:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, kurt@linutronix.de,
        woojung.huh@microchip.com, linus.walleij@linaro.org,
        hauke@hauke-m.de, jiri@resnulli.us, ivecera@redhat.com,
        roopa@nvidia.com, nikolay@nvidia.com, dqfext@gmail.com,
        idosch@idosch.org
Subject: Re: [PATCH net-next 0/5] Propagate extack for switchdev VLANs from
 DSA
Message-ID: <20210215204922.p35mczveuoagpg3i@skbuf>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <161342160865.4070.3346635751399377653.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161342160865.4070.3346635751399377653.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 08:40:08PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Sat, 13 Feb 2021 22:43:14 +0200 you wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > This series moves the restriction messages printed by the DSA core, and
> > by some individual device drivers, into the netlink extended ack
> > structure, to be communicated to user space where possible, or still
> > printed to the kernel log from the bridge layer.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net-next,1/5] net: bridge: remove __br_vlan_filter_toggle
>     https://git.kernel.org/netdev/net-next/c/7a572964e0c4
>   - [net-next,2/5] net: bridge: propagate extack through store_bridge_parm
>     https://git.kernel.org/netdev/net-next/c/9e781401cbfc
>   - [net-next,3/5] net: bridge: propagate extack through switchdev_port_attr_set
>     https://git.kernel.org/netdev/net-next/c/dcbdf1350e33
>   - [net-next,4/5] net: dsa: propagate extack to .port_vlan_add
>     https://git.kernel.org/netdev/net-next/c/31046a5fd92c
>   - [net-next,5/5] net: dsa: propagate extack to .port_vlan_filtering
>     https://git.kernel.org/netdev/net-next/c/89153ed6ebc1
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Ouch, I wasn't expecting you to merge these patches.
I had told Nikolay in patch 3 that I was going to resend after the merge window:
https://patchwork.kernel.org/project/netdevbpf/patch/20210213204319.1226170-4-olteanv@gmail.com/

Nonetheless, since there's going to be a short window of build breakage
in net-next when CONFIG_SWITCHDEV=n and/or CONFIG_BRIDGE_VLAN_FILTERING=n
regardless of whether you revert the series now or wait a bit, can I
just send the fixup patch for the function prototypes? Shouldn't take me
more than 15 minutes or so.
