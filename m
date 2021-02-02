Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741BC30B981
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhBBIUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhBBITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:19:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE59C061573;
        Tue,  2 Feb 2021 00:18:55 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f16so1501787wmq.5;
        Tue, 02 Feb 2021 00:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Kr9Epl1kAlnX6nt81Nq6kJoyLjYKyuMq30muLpi2p8=;
        b=kypzQ3DWrVZOA8QOrjdX2Sr1ociC5v585XN+sviQzHeBvVgYJ6vSYdBpZg+JzakTcq
         oXvyfzzCBCu6c+bNBfsjlIQDfQGmjXK1UuXTpDJ2AvQ/UtE3EmfWbUvaHsI2mdZsdc9y
         Art3KRmO587DP603ZjbxqylDmIzxdEmk3rEo5Kr4LZVvp08//ehHC9Yx3dRIw0rV7Yr/
         5ToBMqJaDRqZwogF0mUICL28A6eoxtBR9iLK6+B3hQOkGmy/BxVYg9FIdnvexCfaoefp
         maWOy+xDZ+w/wtDCBRL3ElP1/QYaGNRMWA47HgW5FjMYJBwinxDOzNyQY+/augRVirtW
         DDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Kr9Epl1kAlnX6nt81Nq6kJoyLjYKyuMq30muLpi2p8=;
        b=agJN4zt3BA0m9+dLV8iTtTMcNQQmXUArh4R4yu8D6zgCAiceScCqwD5Ca8rcEZMhe8
         3tScppL7BGd22xUyL7w+nJh8p6RcH3wThZv9obNsP5uYPPJ/kefbL1EUstrS8JkahYxZ
         uChkLDf/U3/YS87E3kk4rcOJpUoi1rE13hKqURw92kBueBTTGx9x81HX8U4hVrFIo+QY
         ymK8vg798BGYQme4oBIeY3riZdhi7CkePJ889kOQ+gVXbPQepfXnaT67uI01xsbEsih2
         WYpmUQDhWptOTSnY3BvKtP9CebbSmGTvTWA32BUxcALyHXd75xOJeEBSm8VVAi8ewEv2
         tbAA==
X-Gm-Message-State: AOAM533T876ukwtYwlZ62vw7Y86+A/8HfISLrHtXCxYk5tupXKuHhtCn
        8m01ipQut6Wkx/ajNzHbbf4=
X-Google-Smtp-Source: ABdhPJxWH7AgJ6Gtf9tHMpXuVnG+g43O3ZVUDlHb9iJCAjQKpTmuQfdlrcJrclc6I+ImUA+OrC9Spw==
X-Received: by 2002:a7b:cbd5:: with SMTP id n21mr2478654wmi.5.1612253934526;
        Tue, 02 Feb 2021 00:18:54 -0800 (PST)
Received: from anparri (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id c62sm1883575wmd.43.2021.02.02.00.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:18:54 -0800 (PST)
Date:   Tue, 2 Feb 2021 09:18:43 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        skarade@microsoft.com, juvazq@microsoft.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] hv_netvsc: Copy packets sent by Hyper-V out
 of the receive buffer
Message-ID: <20210202081843.GA3923@anparri>
References: <20210126162907.21056-1-parri.andrea@gmail.com>
 <161196780649.27852.15602248378687946476.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161196780649.27852.15602248378687946476.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi net maintainers,


On Sat, Jan 30, 2021 at 12:50:06AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Tue, 26 Jan 2021 17:29:07 +0100 you wrote:
> > Pointers to receive-buffer packets sent by Hyper-V are used within the
> > guest VM.  Hyper-V can send packets with erroneous values or modify
> > packet fields after they are processed by the guest.  To defend against
> > these scenarios, copy (sections of) the incoming packet after validating
> > their length and offset fields in netvsc_filter_receive().  In this way,
> > the packet can no longer be modified by the host.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v2,net-next] hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer
>     https://git.kernel.org/netdev/net-next/c/0ba35fe91ce3

I'd have some fixes on top of this and I'm wondering about the process: would
you consider fixes/patches on top of this commit now? would you rather prefer
me to squash these fixes into a v3? other?

Thanks,
  Andrea
