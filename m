Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8468C3ADF03
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhFTOZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhFTOZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:25:12 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB742C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:22:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p13so11718854pfw.0
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ENhL0KC61//c83vi/0IrW3ts2lCOKrlDjdBmagYekRc=;
        b=oQ8MExjBtEAudwRWi6SGoPMhJwhNa8Q/GiSzWDNqSxAq6ivk2GHu66xUzBsl3KLmcj
         FdRlPKMfwn3l1sSLh+YGA9ctj9EzsM6DOQJ8maGTbfAePpQOCwSKUFQMwNGlHYNCxCUS
         Q67YzLwwwRJ6kWNe+5wWGlEXD6XksPy6h/Rd7UqOhZUBu88lVfwltuLZTfWsn0K3kYhK
         swOHG7U9QDpAPnpH8mt+gFG8z1lCEyaNi0qOs3+Dar4Y9pDVshamLf+NfWWlh2pg4LoP
         1Qzb44T+YRKWOAXrnQehmkC4tIudyy1TFxP8LkSjMDEpgZLuKq4L3VSWKGTx62DtfFY/
         qzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ENhL0KC61//c83vi/0IrW3ts2lCOKrlDjdBmagYekRc=;
        b=bg7AgMl3GhTYgGBNlYYlR+Z2g2YRD5oGGjfwWHvOOi3rZJL83ydHXymgm5ZXSyfPT+
         7GlT9kjAJ94WFYOBzsz/tu1Z6RQD6N3wRjbH3O9+0GqcJBfre8pZ6JO/G3ojHsyeRV1V
         5Wk0+DJHL72qOaswulfa0yLKqX6lW9gd2CuQ8d0RjsRo2Rugz4hfJHgzhbgiQ+L1Ibg4
         uB6boLk0vRXTn+cdaeWTs4HWdPwr+dg9+otf105RZDC3GWCP/kLR9EgSZ6KCbmfs+avw
         UWdKb6Gd8dFusgScjXD822qWMyVwgf2OlDP6KMX45OPVCp7xbRCnbVmrnS1IBUrVTVLa
         k9rg==
X-Gm-Message-State: AOAM533zHTkiKHJXt1a6IZaNA80wMioAnZLsPoRVl1hOho/RcuxZ82By
        c1EMEy4U96nMNzmpIqEtFHM=
X-Google-Smtp-Source: ABdhPJypMeslFcPKHu9Z3E3O2r0z05gRVeVqdi5UPY3IZHIPybP1YxHhRoV/7vaNmN/W4vfRdyuwPA==
X-Received: by 2002:a63:2f05:: with SMTP id v5mr19268443pgv.449.1624198970271;
        Sun, 20 Jun 2021 07:22:50 -0700 (PDT)
Received: from [10.230.24.159] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id j3sm13075595pfe.98.2021.06.20.07.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 07:22:49 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: remove cross-chip support from the
 MRP notifiers
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35013403-6622-8a7b-025b-639e50691bb5@gmail.com>
Date:   Sun, 20 Jun 2021 07:22:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> With MRP hardware assist being supported only by the ocelot switch
> family, which by design does not support cross-chip bridging, the
> current match functions are at best a guess and have not been confirmed
> in any way to do anything relevant in a multi-switch topology.
> 
> Drop the code and make the notifiers match only on the targeted switch
> port.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
