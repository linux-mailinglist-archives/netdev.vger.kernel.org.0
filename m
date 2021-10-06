Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E6423B54
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbhJFKRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237771AbhJFKRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:17:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DABC061753
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 03:15:40 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so7726396edc.13
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 03:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9jg2gV7HlZaHw772V01x31CgaFv32hehBcrJ8P6I/IA=;
        b=DU2PjFOA69eqBgsLSINYTdCLB8Zr9VB0G5Vwk5Esr4/fvyOquub8go5HmzMADPp/ta
         l2s467pwQB6TdWa30kBPvblLHM5dfwHeXUpqCpcMra5Fs+8pbOqz+LNfHgMpbKMmZOu/
         56xT4Y5zhUEdAni2kBhHar+6e8Uzf8AryA7WEd1e2M+Uiv2tT6Y4+OPteMNPEXF802pI
         s8XcUuG7KxP2lRxn7zg8pCyLzKklDAiSL+u03tlYKn06MvkuYCA0vIqyDHdMuT1+hoDP
         i63EJtlrPjRnM4tCC6V8KjM6uaT1rQ7jIZzqoig9FHPF6tbx7Dhz8UDTfOL4w+IttDnZ
         M7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9jg2gV7HlZaHw772V01x31CgaFv32hehBcrJ8P6I/IA=;
        b=7T+qGm2pubakWT/cjgLHkOO57Dv+doloTJzZWqyTN8byJTIVrDV2MZ9d/yJdpl68Wu
         hpxUxkDLrq5vXrKs3cz0LHTgSnP5BGrHboI3CGoOYIo53p42b3RbKB7Oqd5jAXp6Nc6r
         aK/TGkLfo0OryRDhODr4NX41IF04OnhNf98wIZNvrJGv1+NMzqApbyzjmBFzHU6egaiP
         WzY90nHVAYLT63ZIYcicaDwv5kyIu2YmGtIpDnjL3WYTQyRaEyT9oa9i2ghZACYx0ruq
         XCfF0RiIUDpmUBXOXtlu/8kyDOfvsNlazMgiy+4G6t/W7U6bpOvMME3GGTi5bjPF7h63
         +L1A==
X-Gm-Message-State: AOAM533sb2foAQHZCo76/Jgskg5ye+suBY93KnbbJZebuHCtUYjZTEd5
        EIVdT4dbhlydom5/WhFGWpc=
X-Google-Smtp-Source: ABdhPJxElzpHa5MhzLHVcD/sx6yOQfclI5m7qrGr0w6yy6IPN1TqrGtSSM+hpVoCDCzcFtNLUYc8rg==
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr30717360ejz.518.1633515338715;
        Wed, 06 Oct 2021 03:15:38 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id f1sm4680912edz.47.2021.10.06.03.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:15:38 -0700 (PDT)
Date:   Wed, 6 Oct 2021 13:15:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 2/3 v5] net: dsa: rtl8366rb: Support fast aging
Message-ID: <20211006101536.6eiehao2brs5sxyw@skbuf>
References: <20211005194704.342329-1-linus.walleij@linaro.org>
 <20211005194704.342329-3-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211005194704.342329-3-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 09:47:03PM +0200, Linus Walleij wrote:
> This implements fast aging per-port using the special "security"
> register, which will flush any learned L2 LUT entries on a port.
> 
> The vendor API just enabled setting and clearing this bit, so
> we set it to age out any entries on the port and then we clear
> it again.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
