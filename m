Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9348E387EFE
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345799AbhERRws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbhERRwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 13:52:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB72C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:51:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so5531134plc.6
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jUm8/rJRSYOFhNkdi7f6FwvrdKDgNUwnFrh19QWt3mw=;
        b=r96oHqYyHxj2++rGSnzEGbfZMf8I8GbUXPh/xVmjKYoSfvjxxAicYV6fg5k58d52Ku
         WtOoX4K7jZlU2Omzqwok5pmsztHogwNBTum3zY687nG7Tgv9Xb9GXAV9o0Z31GAkdBhc
         E6yOEDb0XHAj8ZVJHjajkyYnG9tm46/UezddhUAoJOYqQ0thcifi9Oa56PNuivpo1MxN
         iMNwJp44ua578xzqOuXaJzmC6ETadp/AwONb+0AZ0vJBoUtDW24tF+IKPg/VhN3O9+EV
         886gVbhRjsaBM9+WEtPY3KPWXGjPge0krhCSXa60SRvytux/4kAPbazFWR7wHMl8Tlkc
         Q2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jUm8/rJRSYOFhNkdi7f6FwvrdKDgNUwnFrh19QWt3mw=;
        b=uHySEtuyk1ZUCSt1NPmVAirNtjgcdskzPPcjOEbzTPDoauawLJv+Lfp9VMgM459o0U
         bqCgVsFeVj1yH028rv0eRJ22xBNmZ1QRxPA/vtrG6u0knYEmEI12BYPrrw4wTNxhzzOx
         XB05PKaE6RaSTSQv/019lCZ9YaT/d1shHZ2WI9AM7TdEzgrsINsNDC5dZHZmIrSG6PX4
         wQMtdyzQcNVyK98Tc4Or1TxCz/M/n9v12v8OKFndH0AnJTJeqaUZgg2/4oudB/x0NEwe
         JkpxUkS50M9nk8m2H9rnyZlrdwpZLffir/7Rgda4yCYH4ezDkPK8BzlPiJwTShKv5xfe
         +Ahg==
X-Gm-Message-State: AOAM530r1Ttio3qJjBEuWPlkO4Z3VCQQ0CMCfYr9dLLEs/6UXtPZQJdj
        +BU5a3GjWuAfNK/cWiGmgYM5im7iSlIkLw==
X-Google-Smtp-Source: ABdhPJy/QyLuF4TRlqnr3Kct2vLo9lyCyI9t+I4jWWiMHxa1AOBl+O5PruR8/9RcN6VBxbzbS5zrUw==
X-Received: by 2002:a17:90a:3bc6:: with SMTP id e64mr6467574pjc.156.1621360288646;
        Tue, 18 May 2021 10:51:28 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id v14sm13637660pgl.86.2021.05.18.10.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 10:51:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: mdio: provide shim implementation of
 devm_of_mdiobus_register
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20210518174924.1808602-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84619ad5-5b19-a848-a264-baadc75fc65c@gmail.com>
Date:   Tue, 18 May 2021 10:51:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518174924.1808602-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/2021 10:49 AM, Vladimir Oltean wrote:
> Similar to the way in which of_mdiobus_register() has a fallback to the
> non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
> a shim for the device-managed devm_of_mdiobus_register() which calls
> devm_mdiobus_register() and discards the struct device_node *.
> 
> In particular, this solves a build issue with the qca8k DSA driver which
> uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
