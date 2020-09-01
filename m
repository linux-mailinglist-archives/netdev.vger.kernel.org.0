Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6C1259F0D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgIATOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgIATOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:14:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEAFC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:14:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c142so1373734pfb.7
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5Y354IttvjgtdXZb+ds2Rcmt/Ircm6y93JJk5DLw24M=;
        b=qWrjwzvHjvBr/v0hL2lftK6SjEcPhv5Pu6A+vQL0tFw4F187Qp4ZaEN7t9fyANDUMl
         2AjBt1oUZUM+c6dB8i8n4wlZUM2bMzELhbKMNGv1nEbe3rNv55Ug7pNsCSwwXsCME140
         HaFvAyjN4RCd8NLoBl9ZvdmHX8Xl4OeYy0liAvycRzOBXpGDmmLok2V2cysn1hOMIP59
         SYb2aQoEb5Xr4AKCH9afISNZpL0S2LA98sAWtndG7urmh2Nfc3gD8B3cN1de8R3hdzOI
         KPUo7hYKGm8/Uxj7HGJ1uimj4NihySRkhuqLkkXmwpbxM64pGJNOf87t7yhzuGA2TUPD
         Rfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Y354IttvjgtdXZb+ds2Rcmt/Ircm6y93JJk5DLw24M=;
        b=rACwUbDh2OJ4135fPCn034uctg9cYC4bd86vfBHIPXiiyZnlMeKr8Zp/K/06x4lASD
         YLjfxFFQZVzDN0fdh+Vvmht6G2qA7+/LExxK8zqHZLBu3HUpcYkgr4gOgg3go4TOGrvm
         YCj9ZS0V7yP6Bfh0WQqP3oV3P8T0cpXPGaWSPtBaE+mDww94cc3ftBGmMAxlVb3JVqfr
         udQ0hdAWt0StgCJIhEtU25bzYQDRliox1jpk83fYBoI6IMTn2uMN9q669eUmeK7dXnbz
         s3uYJRuMbgDMJDIRn9gB2YjEco1PH+zhSNXsUsYfDdK3ohe30Uf8yBLUbDKUGkG4fAyR
         JEIw==
X-Gm-Message-State: AOAM531pG3K+2pjp6mhgR+ryw65nmxTYw+Ca0PjsMxhlyyzQhB44ZxWY
        NQSogkXaxS9pG22creStsVI=
X-Google-Smtp-Source: ABdhPJy3To7N2SiJDDMF73Cb6dhW5Epc+Jkl9+SomPXNDLE4VSNYgMh6m+fK2VlDzytH6Te1igyRvA==
X-Received: by 2002:a63:5552:: with SMTP id f18mr2606047pgm.298.1598987680225;
        Tue, 01 Sep 2020 12:14:40 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b6sm2220210pjz.33.2020.09.01.12.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 12:14:39 -0700 (PDT)
Subject: Re: [net-next PATCH 2/2 v2] net: dsa: rtl8366: Refactor VLAN/PVID
 init
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200901190854.15528-1-linus.walleij@linaro.org>
 <20200901190854.15528-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <15cda1ef-c145-990b-5318-eac70338c702@gmail.com>
Date:   Tue, 1 Sep 2020 12:14:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901190854.15528-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 12:08 PM, Linus Walleij wrote:
> The VLANs and PVIDs on the RTL8366 utilizes a "member
> configuration" (MC) which is largely unexplained in the
> code.
> 
> This set-up requires a special ordering: rtl8366_set_pvid()
> must be called first, followed by rtl8366_set_vlan(),
> else the MC will not be properly allocated. Relax this
> by factoring out the code obtaining an MC and reuse
> the helper in both rtl8366_set_pvid() and
> rtl8366_set_vlan() so we remove this strict ordering
> requirement.
> 
> In the process, add some better comments and debug prints
> so people who read the code understand what is going on.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

One question below:

[snip]

> +	/* Update the MC entry */
> +	vlanmc.member |= member;
> +	vlanmc.untag |= untag;
> +	vlanmc.fid = fid;

Is not there a problem with rtl8366_vlan_del() which is clearing the 
entire vlanmc structure when it it should be doing:

	vlanmc.member &= ~BIT(port);
	vlanmc.untag &= ~BIT(port);

or something along these lines?
-- 
Florian
