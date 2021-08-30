Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8BA3FBF07
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhH3Wgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbhH3Wgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:36:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDE7C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:35:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i6so24613161wrv.2
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CrKcMSpXHrmiJF32p1ZhxMfJjXS9+3LB/qPMUdM3UYw=;
        b=OAJ0fkXQDdSvQYlpNpyCV521ach5z87Iz9aFcbw5MLFSFulDGpjbSwUHQN3/VDAdbR
         crBbMXevABIV7O80WT+1rsDgNMuCDJKPd0iZCGG/zGQzLQfHxdso9LubgiBWETNA+Dqy
         LpnCj8erCJH/NOv0wl1j6AF8EQTz4M1k/4Gr05fDrZ9dio9iGbiiiTPFhoeOlYv28l5A
         zMX8vgTMdZdnPaeA/FjlfKcWLHZHzDh3vzXaagghclryk6Qog+UlNbsvx/MOAXHAxjzd
         KMcHLjQDmK1riJyM8U4EYmAtfPkCtDf9Fu8io9Ib2dPbrJ70QoU/yPROyRAybCUv7/Ny
         tzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CrKcMSpXHrmiJF32p1ZhxMfJjXS9+3LB/qPMUdM3UYw=;
        b=hyWwmIO8tSuK+uyXabZFrSubPNV4W30Yc23iNMrbF6KYf7mhxOKHxOZlMe1QEJZ1X0
         IUXsgrN1RwMqA9STpa56PiOXPkpHUHj2S9jQ2imgkWrpAERwZR7QNBeaBdyhxpRH4lLB
         VWjF40qU/IYSFsz8LKfNgRErA/WZo/URjzR1DIM5e90qpJLYIpnZJ3wn7hyaVlcuvO1m
         ul05V9Zd5sXc0LHaj43Ov586fIv+QT8vyL4GXwA9aQEPDfM8e9cccTcKAy6gArDeFCQt
         0CCkM+cfLnHnjrIL5SqZrIyWb4b8oJsv5i5STi0i/04gEEumVQpCLZRNGGTuXC01VYJv
         GNvg==
X-Gm-Message-State: AOAM53058Emb9dS309fOoEuQx/iwvHW5ekaWEYhnIV6SZToGWDIxd88P
        zamuc7FU7e6clGo7Ot5gYmI=
X-Google-Smtp-Source: ABdhPJwUHLTd3g3/AKB06APlsWB/0wD9cDmQe4N3ZEcjUKaFvpvvfjcg5blvwMd3v7W96lO7s2WwNA==
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr15915578wrc.158.1630362947851;
        Mon, 30 Aug 2021 15:35:47 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id u17sm255694wmm.33.2021.08.30.15.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:35:47 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:35:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 2/5 v2] net: dsa: rtl8366: Drop custom VLAN
 set-up
Message-ID: <20210830223546.22vl4zm2o4m5adjf@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-3-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830214859.403100-3-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:48:56PM +0200, Linus Walleij wrote:
> This hacky default VLAN setup was done in order to direct
> packets to the right ports and provide port isolation, both
> which we now support properly using custom tags and proper
> bridge port isolation.
> 
> We can drop the custom VLAN code and leave all VLAN handling
> alone, as users expect things to be. We can also drop
> ds->configure_vlan_while_not_filtering = false; and let
> the core deal with any VLANs it wants.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Please keep this review tag when posting v3.
