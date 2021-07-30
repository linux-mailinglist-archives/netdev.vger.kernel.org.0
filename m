Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38C3DC16D
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 01:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhG3XIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 19:08:30 -0400
Received: from phobos.denx.de ([85.214.62.61]:33364 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhG3XI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 19:08:29 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 3CE7A82EE5;
        Sat, 31 Jul 2021 01:08:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1627686502;
        bh=Lsvzgm2/bT0i1czDftPYuhBl4C3X6EAaoI8Ypn/Y24Q=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Z42tDgf07XHT/9mOTJf+62fdat1v5vk/m9m9hDad08sXf+upYlW982iIDFPQSLiRi
         Ca2zlqd3b6fhipDCh5ojqRkBnI90zEpTJfjFdSSN2/euAItgZUzoFysgNsq/JB8+8H
         C321XnT3AdBvmNoEmnkaBQDUsvGOAk4RaFZhZD8VqJZiQKsp9CHj1y2uFqB38spGYy
         Lqw9krc8A/KY4dgsb23kwKgOJhFClQtvNO1i0TciRBdXnbsdIkHD558cfuhpuC7OHB
         FwPWX+k94y6iJ7/x2dG5muCTrp/UvcQjdC3INAgH/SQOHwGbQuk7viC20Je3RKX6bc
         ZS7xWZ9kjVExg==
Subject: Re: [PATCH v2] net: phy: micrel: Fix detection of ksz87xx switch
To:     Steve Bennett <steveb@workware.net.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
References: <20210730105120.93743-1-steveb@workware.net.au>
 <20210730225750.98849-1-steveb@workware.net.au>
From:   Marek Vasut <marex@denx.de>
Message-ID: <932a0c80-db3c-77ac-6bbe-101804329e02@denx.de>
Date:   Sat, 31 Jul 2021 01:08:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730225750.98849-1-steveb@workware.net.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/21 12:57 AM, Steve Bennett wrote:
> The logic for discerning between KSZ8051 and KSZ87XX PHYs is incorrect
> such that the that KSZ87XX switch is not identified correctly.
> 
> ksz8051_ksz8795_match_phy_device() uses the parameter ksz_phy_id
> to discriminate whether it was called from ksz8051_match_phy_device()
> or from ksz8795_match_phy_device() but since PHY_ID_KSZ87XX is the
> same value as PHY_ID_KSZ8051, this doesn't work.
> 
> Instead use a bool to discriminate the caller.
> 
> Without this patch, the KSZ8795 switch port identifies as:
> 
> ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Generic PHY]
> 
> With the patch, it identifies correctly:
> 
> ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Micrel KSZ87XX Switch]
> 
> Fixes: 8b95599c55ed24b36cf4 ("net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs")
> Signed-off-by: Steve Bennett <steveb@workware.net.au>

Looks obviously correct to me, and yes, this reinstates behavior before 
V3 of the original patch. Thanks!

Reviewed-by: Marek Vasut <marex@denx.de>
