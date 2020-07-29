Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED35231F2B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgG2NWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgG2NWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:22:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CDCC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:22:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mt12so1859027pjb.4
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SD/E4YtAAYBp08gYZlwE7ZG/Ux+KbAcjngepLIpRcrU=;
        b=KD3CfgaTa7xgkGO97qzZ2FP6Uk4VxUuWXnXZNey98YbbHhnI24UC/N92+tPTojUNO3
         F5TAuu439tNfsTXA4pzsJzuaGH5WA5wD/GYKeUetanDQgP1WxkDtjHLF2OzATN8QcpxD
         sXVmEdGJJLM2NbDqLsDZaJ/v2KiftRhACU65+Yb+0MYlNWFKys4rsJpxcFm25bC1uKJz
         NshxaiJCWg2Azv0GhVg9i0Qfi8x7pX6SaflzQHM0Ec6v/m+f294nB6+7AsY97BMlQjQn
         qKfuI1Nt3wLlfSSVcOHhLSi1earY60KWjBdOZtcBR7hDBqJS9V0l05Zw2CU1s1HIUbRp
         pgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SD/E4YtAAYBp08gYZlwE7ZG/Ux+KbAcjngepLIpRcrU=;
        b=QC1h2uD9Cj1zE9v7n2cRpkK3FeiG8ZYKQn68fjApgeG1UZIf2IBefIY9B3UjpOpSMm
         8El/+W+QV04Bd1MUsDmaodIuL+UdYRZq2Feu/7DyzqrzDMvwJ4HdI6otLTO8JaGvcFf7
         MUAvanyMvNUE/+HPUr4bskEGrOpQYIHE9A7v9yXpMtc/dpY3xlYlMaUW2JQDnCRLniTG
         ZARt1ZUfZxxNQ6Li9Ed4r2tRenRt+dF2bko4kHagLR/rsW5WACq7t6Hw03pd4LL97v1x
         a/FhxOPT2VWJijWRAMhSvwnBaSTwfEBTwUmpQJMOz0OsskzPf5eYSuqAdjmbZ1QlX/f5
         bjZg==
X-Gm-Message-State: AOAM533vrsMYLvekkae1T6yRsrcBw32y8dr8mkWnbc6LUJn76IVA5/I3
        lBxzdX3KQ53axxK+Tyv/CBP93a8o
X-Google-Smtp-Source: ABdhPJwv3RAv5pDvw/Cv/B9PMERCwJWxwvzapfzRmOBr0VA44zkDqvncEfZgdPMvsQY7gVaTu6zaNw==
X-Received: by 2002:a17:90a:fb50:: with SMTP id iq16mr1544567pjb.177.1596028959755;
        Wed, 29 Jul 2020 06:22:39 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e9sm2509422pfh.151.2020.07.29.06.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 06:22:39 -0700 (PDT)
Date:   Wed, 29 Jul 2020 06:22:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Petr Machata <petrm@mellanox.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
Message-ID: <20200729132236.GB23222@hoboy>
References: <20200727090601.6500-1-kurt@linutronix.de>
 <20200727090601.6500-5-kurt@linutronix.de>
 <87a6zli04l.fsf@mellanox.com>
 <875za7sr7b.fsf@kurt>
 <87pn8fgxj3.fsf@mellanox.com>
 <20200729100257.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729100257.GX1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 11:02:57AM +0100, Russell King - ARM Linux admin wrote:
> in other words, compare pointers, so that whether skb_push() etc has
> been used on the skb is irrelevant?

+1
