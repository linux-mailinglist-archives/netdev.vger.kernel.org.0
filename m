Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756912FAA53
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437426AbhARTiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436985AbhARTgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:36:41 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7BEC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:36:00 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id rv9so6471684ejb.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g5GN3vH4HSdjQiRrOkjF3rRgo4vaid8HPktGh+A6N28=;
        b=XmvKz2N8Z/rESq8CtbVUZuaZXQoH4Qh8i0mvWloPYXG9O0l8huh/d9TYE6MjF/mQ7E
         yO1iIjUg4npIZcOYvuptYBjrRK4IIFnf67IOXu9Sp0HPP3UTu1PBWMFZT4Qs+XFATaUq
         UROQjH/xpoDfmckJZKTGwCYHzeJbo9Yln5RLli8a0kQslstws5q9DjwspMuI+AjVZuqu
         zxTM/nQn8XeemTIhHY59fbakUtAaiKwjbqavDmha1drwiXswnansvYzwtJnyamd2yvCJ
         NEd8mhXPS+h2RNs0KPOq9lG52c4Hw15kw9A/m7UfWfvEzASdnMY9Ob9ObmcArg4SyfPg
         nCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g5GN3vH4HSdjQiRrOkjF3rRgo4vaid8HPktGh+A6N28=;
        b=fOZGlz6poNeF0WI5MGEDmMt3gvi1v/ceUgYqtW3YBZ6ouWugpNqFaaoqGKoS0+Iewk
         k3/5mdy/CzYVLQdiBtZHFhQjpOJlWxcF7elH931lUdlUfcLBHiDTfxHTs1S086ZJXbne
         Ce3kT4ofSOSbFtyeBF1iVqOeTLlz3m8R+lV1zUpUla9YsPMbEbD3GvySG/UiUG+i9ieN
         //yXgLu/hBDtPW4wpdHEkZQwPn4/5DH8qZ6xOdJWgDY43gN3PpDuEOCyUfLXy0+bKPXS
         e4D8E6urnGQqGU8cAjo3KIpmO/00Ua42Xp7mfRx4UPEHM13/8PM0y1nIxAIu1C1+0PdE
         hd1Q==
X-Gm-Message-State: AOAM5306GNROGOs8xgbnqADfmm5UKEkcopXfU4PZAtEMeFM84iiMxFwf
        aZY4CqJr0nqlIm3aSNB0cDaj5pOOKs8=
X-Google-Smtp-Source: ABdhPJzCWpz/2Oym8lZbEkAKXl7mPbmm5PzWlVaU2u/yg1Hkee7+Zgri69npuJSuGp3doLbSlfGgRg==
X-Received: by 2002:a17:906:5285:: with SMTP id c5mr817742ejm.17.1610998559341;
        Mon, 18 Jan 2021 11:35:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dm1sm4567788edb.72.2021.01.18.11.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 11:35:58 -0800 (PST)
Date:   Mon, 18 Jan 2021 21:35:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH v2 net-next 01/14] net: mscc: ocelot: allow offloading of
 bridge on top of LAG
Message-ID: <20210118193557.cwa4nvxdbuulldou@skbuf>
References: <20210116005943.219479-1-olteanv@gmail.com>
 <20210116005943.219479-2-olteanv@gmail.com>
 <20210116172623.2277b86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210117123744.erw2i34oap5xkapo@skbuf>
 <20210118110447.3c31521a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118110447.3c31521a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 11:04:47AM -0800, Jakub Kicinski wrote:
> On Sun, 17 Jan 2021 14:37:44 +0200 Vladimir Oltean wrote:
> > That being said, if we want to engage in a rigid demonstration of
> > procedures, sure we can do that. I have other patches anyway to fill the
> > pipeline until "net" is merged back into "net-next" :)
> 
> If you don't mind I'd rather apply the fix to net, and the rest on
> Thu/Fri after the trees get merged.

Sure, I already split this patch and sent it to "net":
https://patchwork.kernel.org/project/netdevbpf/patch/20210118135210.2666246-1-olteanv@gmail.com/
