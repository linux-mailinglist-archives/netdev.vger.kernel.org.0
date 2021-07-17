Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452E73CC388
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 15:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhGQNEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 09:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhGQNEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 09:04:46 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A54C06175F;
        Sat, 17 Jul 2021 06:01:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj21so16729902edb.0;
        Sat, 17 Jul 2021 06:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AE0vk+OWuD10Z0EqVPnQQ5x0ytDuchGXP77/oS4iF8w=;
        b=Gg1y0YAKvo0Fc2m2o1vuYshTnVDoA7AEjImeWOohdIoi86RJZkQ9EGTCNygubW7UC0
         iWF3gHPbv+OvaA6L/VxSeru3cY8xFDX3AQtEzr2W30cIN0JDF1Uo/IwO1AgZQ6unYQet
         /v5mHaAhdST8LsAcNoSt42YKdWLMXQAad+TtwKNhXVcfyXqu5b2j61dWRNxGJt4WuEb6
         /aRUj2nfjXLymb/CFQuNKmrCZ7jx45a/CvHxfyDCpHPpoV3diEvtmPCDIOc5J/sRnhhL
         89gECpkCFWK78McK6kEm3b+FdUvprUsVT7BaoKBMHDxdwAHArqlB/wzFq5l4Nv0j3r8g
         iRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AE0vk+OWuD10Z0EqVPnQQ5x0ytDuchGXP77/oS4iF8w=;
        b=DTln/tiwBfDlMKlBXpyWpRjLhVWNBAN6bTRXI57O6A4yxQsD4m/JRngQ7coK7SOx7q
         89rxYZZImvc2jSYeJR2QgBGIzDaLVQny4359sHqbxvYsiaeNUc8lVW4rHRNP8+pLFNj4
         rPZge08IJ2IvDZoF+yepUbPhAnw9pQExi61deEHpN0/KszA3eqYodJvEQ2lWjRuBPxIp
         hxDjgip7t/KD/lnofQHopLBRk8/EEBGJYb61JudPHcAsGoBoBK9SxPtUN+xMG+yLqRbh
         URBfpmodc9v4Ii3pbHfPn3BG66IWHRxE2RbfGV6ULhRDr4ayB41XgC2tAUx9X57bMr3e
         8qMQ==
X-Gm-Message-State: AOAM531tQs39uvnIT2ZFiPcktruMtL82Vd41zud7SduG9L2NqHsnfxBX
        hL1xRUQB28p1iC6CdDdzAwI=
X-Google-Smtp-Source: ABdhPJwwTfY3aDydN4vgqwZ+1IdTA9/4VbUMf3AZZ5O7FnIURRVd000FJGicxnOWF91vKjlOHvQaQA==
X-Received: by 2002:aa7:cfcf:: with SMTP id r15mr21810760edy.161.1626526905205;
        Sat, 17 Jul 2021 06:01:45 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id e24sm3857192ejx.100.2021.07.17.06.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 06:01:44 -0700 (PDT)
Date:   Sat, 17 Jul 2021 16:01:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Message-ID: <20210717130142.xm7ect5sc6i6hrii@skbuf>
References: <20210716153641.4678-1-ericwouds@gmail.com>
 <20210716210655.i5hxcwau5tdq4zhb@skbuf>
 <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 10:09:53AM +0200, Eric Woudstra wrote:
> You are right now there is a problem with vlan unaware bridge.
>
> We need to change the line to:
>
> if (vid > 1) reg[1] |= ATA2_IVL;
>
> I have just tested this with a vlan unaware bridge and also with vlan
> bridge option disabled in the kernel. Only after applying the if
> statement it works for vlan unaware bridges/kernel.

Ok, make sure to read Documentation/process/submitting-patches.rst for
how to add a Fixes: tag to your patch, Documentation/networking/netdev-FAQ.rst
for how to set the subject-prefix to "PATCH net" in your git-send-email command,
and send a fixup patch.
