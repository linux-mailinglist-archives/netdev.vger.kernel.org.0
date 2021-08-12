Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF0A3EA0B4
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhHLIjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhHLIjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:39:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC74C0617BB
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:38:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f5so7070871wrm.13
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MA81N0NeWN9Ki38uSmzYxOaNtPHxxWNteETqAlrd3HI=;
        b=l3bM1PfX5t/TUfd8HmTx+8EEsCFScQL3lPmhiwTCs5pNsamgPg2fd3CbtXrNK22/MT
         /JUGi29umlsqpFX41mrhB2abvKzNv3qqAvpBLusH5fIxmulOB8yWSWs+jDNK3i+v2DTg
         Xi4/X49bBX4PbfCDbLu8VrjbI2/RzybTqai8lnD885+1uaj9Jh+hDLHucEBJidM0ImUW
         D8ssHCWEQIGkQt9HEEO4bzOStd43a2Go+KSSJa2BxG+5GyOATdknKtLU+ktM3R+3vaKC
         hnDOamAY2YDGnUTrVMWyndc5w4VvSB8tSlOaQkNWbqir2XukooE34JtC03as91oUAjAo
         tYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MA81N0NeWN9Ki38uSmzYxOaNtPHxxWNteETqAlrd3HI=;
        b=kGiqkX914MuPtXRgFutWR8IByXbteD5blhKPO9g1zKvg95qsS+V5g9SriUgNiIN+nW
         NBQhU4btJZcHJURI90DqzNW0Mf00m4G1XhCD3ow/bzeDsurW0W7psuDZU4NOLHM1dVi4
         LomQ0XX+zm0V53rGaiwCgITIVvyEynImf3NbsIDWRyOIGQcHXFuPHPJfsVqeV6ChP+nP
         M+RzHNkvB+q2BeiQbfxZh/6uw8J8EmWBB+bz54iOnGk0gNXFVEPfUDS6xoBux8uvdfkJ
         C5qhXE0WlWR2O4R5VtGMFdjx31NELFPXlUu5Xq7r320V3BK4WGDsJgaTy4eoAza9yKql
         kXIQ==
X-Gm-Message-State: AOAM530IsyN6vZ6DGWyY5+NLAGHF4atP977Yw4Y38TyjsrWCi6qprRkx
        QE229HyWLLGjRooFuRcvayU=
X-Google-Smtp-Source: ABdhPJxOdAp+vPOBB8LDdcEGwg+8GXTLJ3EfrhDpenwDwzvR/Ia2qw+eLkbRGhofkps27NtPFR10+A==
X-Received: by 2002:adf:e590:: with SMTP id l16mr165256wrm.276.1628757523811;
        Thu, 12 Aug 2021 01:38:43 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:90a4:fe44:d3d1:f079? (2a01cb058192e70090a4fe44d3d1f079.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:90a4:fe44:d3d1:f079])
        by smtp.gmail.com with ESMTPSA id t15sm2078970wrw.48.2021.08.12.01.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 01:38:43 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: sja1105: unregister the MDIO buses during
 teardown
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210811115945.2606372-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0f212e62-cc3b-d90c-8956-b8cf837a8de8@gmail.com>
Date:   Thu, 12 Aug 2021 01:38:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811115945.2606372-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2021 4:59 AM, Vladimir Oltean wrote:
> The call to sja1105_mdiobus_unregister is present in the error path but
> absent from the main driver unbind path.
> 
> Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
