Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAFC2BBF89
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 15:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgKUOOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 09:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgKUOOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 09:14:03 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2A0C061A4A
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:14:02 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c198so11774238wmd.0
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IWYFKF/mJ+HUJoPCxsHdk7pAqaDwieEIuOGknNJBkGE=;
        b=T5kzv0DqSCFOItJlu9zICD7Mvo71KO8n2HK1FPPMevYCRmL3oFyxfWBoQ3uWLUti+f
         zYUc6sMQvjXZKlrZZaB9hJ+tEX3Fs3JzeqzfxAZEjoJ+duUlL4VOUM79R50TS4F8OGSa
         WWkDEMixMKiqwkbvRco+h5W+IMoW7hTI6XLM4Bt/hN7i1Fr6GGH7w4Jq+2k5KkkI78w6
         8YlFJgB3ZTJW6RjkWOwmJETzneES9a1ANCaykUz4nXsYEVfRNk5AYgzSmClfaUK5ebpu
         IO9NGeO5y06M+Tn+kyVwGen8IJRqa+E8qrcIJOLvXZjZEnxHO0kbNFII5yHeZCB+QUXO
         zKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IWYFKF/mJ+HUJoPCxsHdk7pAqaDwieEIuOGknNJBkGE=;
        b=SgjhtxgwO9VttOIdg00E3NrGplRs7tRfyg6B9iqGHibj68Mhb+EAf+pY+QXGLEMS/3
         iK4Cedy1+hErN411eeg3baPuDiDiiV9b4Uk0pIVtQ4kqTWLatEtbBIt7CgM71flTXls6
         4XThxFaj3NrDg9qKB2ipdF0fcstxhUxyX1kbZBd8+0dp7H30sQaKK3o3awb77Er56/85
         p3rsPL7fciWyw5JmR/rHAFY++rGob9oZOcnSJOhtiBRu6U9w+GgY3m5FbwON9Aw9U7r1
         b4C5qT0986MpUwDLZ+hUI+f3JjBfMlDU5JPQiaoZSh9K6E1TjpZ913fNgPdY8wPwOo3y
         QxmQ==
X-Gm-Message-State: AOAM531wuwBdp9uE6ibeHamuss3tm1XVlzP3xY+BzgSgztSNmQa79R0m
        zeKOx/uuWDqTYpoDhCvIgHIWSXOaof3pwflyiL8=
X-Google-Smtp-Source: ABdhPJwh+gQ2mbKXw8vN5oViDyMNpn5R8RMKiFi8GDqjtHa3AWKn3to7d/4Mu3/AdMYvKrlqx0MukA==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr14764169wme.0.1605968040759;
        Sat, 21 Nov 2020 06:14:00 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q1sm1519818wrj.8.2020.11.21.06.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 06:14:00 -0800 (PST)
Date:   Sat, 21 Nov 2020 15:13:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     George Cherian <george.cherian@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, masahiroy@kernel.org,
        willemdebruijn.kernel@gmail.com, saeed@kernel.org
Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Message-ID: <20201121141359.GE3055@nanopsycho.orion>
References: <20201121040201.3171542-1-george.cherian@marvell.com>
 <20201121040201.3171542-3-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121040201.3171542-3-george.cherian@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 21, 2020 at 05:02:00AM CET, george.cherian@marvell.com wrote:
>Add health reporters for RVU NPA block.
>NPA Health reporters handle following HW event groups
> - GENERAL events
> - ERROR events
> - RAS events
> - RVU event
>An event counter per event is maintained in SW.
>
>Output:
> # devlink health
> pci/0002:01:00.0:
>   reporter npa
>     state healthy error 0 recover 0
> # devlink  health dump show pci/0002:01:00.0 reporter npa
> NPA_AF_GENERAL:
>        Unmap PF Error: 0
>        Free Disabled for NIX0 RX: 0
>        Free Disabled for NIX0 TX: 0
>        Free Disabled for NIX1 RX: 0
>        Free Disabled for NIX1 TX: 0

This is for 2 ports if I'm not mistaken. Then you need to have this
reporter per-port. Register ports and have reporter for each.

NAK.
