Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63BA3E8C0C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhHKIlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhHKIlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:41:18 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D4CC0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:40:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o1-20020a05600c5101b02902e676fe1f04so3315244wms.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y6JJIyZHLMcKh4pILWQk/kZ3ywqmh+JXJGFylEQubUg=;
        b=nH2CGINQCWDJRVxHyJLa1yoY0SeqfVhrgyMze05cHLCw2Aq+Gs/07hX3uEy0lknEl+
         CV6bjfN+1LILnbF4Q5+5wBg+rZM2+/JEBSW9jXR3oIyDhBrQBQdOcUjGwHyZM9bFuMGj
         3I9/B9WwmkaGIsvUXxznhcUMEj58W2NR+b7YidFPIEzkarc1dgaqTes0Va8Cg6Aq4iXs
         +9vdVHoi14ZSo9Ix+v9Lew7fUCWQblEqZ78hze5b6gzXWadpYUQFoz1Gx6QegbW+fsq5
         Bke37mFpzJrjzy8r0nGT+BAPkeYFQCshIol16zTmfGKlsivM/eQzo3Maj7p6eb1K4M3n
         zw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y6JJIyZHLMcKh4pILWQk/kZ3ywqmh+JXJGFylEQubUg=;
        b=aR3D9CntN8woQCrwu36PNeepj89BBy0CfxHmJxUkk8z4eKbcFpvKpwWlm3uytMOHy5
         uV44hPc3GHzfdUgtELmlpNePTGUvyQKlY6Y6rswN/cRvuOqqDCpU5TUNL6PsW975kEjB
         UOz7MlStyKdEeLKQOmjPikBomXFF+tktHTr7bopwrqKefO3Z+sU6bL1XCtM/kT5MQCeC
         XzfnpMmzBg9bbV7O2REb0IRw7gVFdXm9u01Gjbe9QmSIqjDfhZPPo+cuG05ay+1m6I8O
         oiGMaKxwi4n2/vpJq4qVH/oEo7C+wpAlt7Vj0byL6eT0eSzxST435J+/VGFEwOyOQScE
         5t2Q==
X-Gm-Message-State: AOAM533rudU+jAcjoPmOB+/X0pocRjAIpHd3yrOMAz7vFPeFlqAGofg9
        AzqU3epexDpoKNdYERJtxCY=
X-Google-Smtp-Source: ABdhPJxbhJwBENW09QOKAMSTrK/Q55ae0IqZeKJx8cUOp0OQYw4k5mFY7ZtBoZIROQTe93BsxFsfXA==
X-Received: by 2002:a05:600c:2242:: with SMTP id a2mr26669061wmm.180.1628671253320;
        Wed, 11 Aug 2021 01:40:53 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:90a4:fe44:d3d1:f079? (2a01cb058192e70090a4fe44d3d1f079.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:90a4:fe44:d3d1:f079])
        by smtp.gmail.com with ESMTPSA id z17sm4882826wrr.66.2021.08.11.01.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:40:53 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 4/8] net: dsa: b53: express
 b53_for_each_port in terms of dsa_switch_for_each_port
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
 <20210810161448.1879192-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eaf6c96c-c942-05c3-ce66-0fa9821bf118@gmail.com>
Date:   Wed, 11 Aug 2021 01:40:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810161448.1879192-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2021 9:14 AM, Vladimir Oltean wrote:
> Merging the two allows us to remove the open-coded
> "dev->enabled_ports & BIT(i)" check from b53_br_join and b53_br_leave,
> while still avoiding a quadratic iteration through the switch's ports.
> 
> Sadly I don't know if it's possible to completely get rid of
> b53_for_each_port and replace it with dsa_switch_for_each_available_port,
> especially for the platforms that use pdata and not OF bindings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
