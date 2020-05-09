Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10301CC598
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEIXrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726630AbgEIXrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:47:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0F9C061A0C;
        Sat,  9 May 2020 16:47:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so6318670wrt.5;
        Sat, 09 May 2020 16:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ih36Ii+QrnPToKP870PuOW1qN7rDAdr7kxFdcKOr708=;
        b=B2ApDDquO/lGhHMWLlF3klJ2H0RdcZLZ8GmUM8nK41IOm7TcBTm6Xpd4ndAf540K26
         +OFYJWrx7pohGHk4qoFVeQomDam60GHZe/3Gw7kvIqEoUJssqIws6YSlPkLTO3VqPtHX
         LX53cE+Mr6S2Q/kaWGJXn0NdzKLCHHt66PmOUmjDMbus3y7vbRmkwIH7NCdMuOFTm2mS
         7VK9UGD/JeJftifpzTtqv/c9NNTJIGffbWMsNtTsV+mbwbeu3vKfBh8ZURbPNFSEbL5r
         pGQUtWAw66mYpPdMt2aTLaM4dgpKhkh+uQbRTEmExtoJpmJHHERPJhpKb1Hz6zZHATRg
         LgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ih36Ii+QrnPToKP870PuOW1qN7rDAdr7kxFdcKOr708=;
        b=CdeOj0Lp9+6Eyk6vITkfI25L58DxOCNpDEdmtblyHl0u7kptViDbBH7OWVQ3rPZXUV
         /GN/bQWdTnlar4iAPqjxyp4Q4rWHdBVKGXsOXF3aZpcpqJjJ6RZ+Hb5xdH/imhHro2E5
         cZ5KyuN0tz0pCgkPThCO/xkLqpK7QF1NRj5JATq+NwfAK88ngdyywRxTiFJwm5V7VRxr
         bvrXX/EflG+8SwzkkisL1Ry/9prz4Y35YXyV00vLgUrcIkNLMzZfofd9aqcFmn956l8g
         pJLPARvN0C8XvkJmUMT/3mPs67Dr0EArF1WKDxi1DuhuTQ50nOBPwObUBypZ9cjOBFEp
         vr1Q==
X-Gm-Message-State: AGi0PuaiGxxBCYWsZwwQrfwMp3BHcJqg3Jc7h95GtOKOaFOjNOXWIUNL
        VXYYyYcpJEcW9clRfu6/dsY=
X-Google-Smtp-Source: APiQypIaY3tNRd3Z7VR53/FUC5adN2IdvlZymtF2dXkbPZhv/HS3hy4le190hsAmeDAlJLE2mySFXg==
X-Received: by 2002:a05:6000:1c5:: with SMTP id t5mr11317067wrx.229.1589068053987;
        Sat, 09 May 2020 16:47:33 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t4sm10631081wri.54.2020.05.09.16.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 16:47:33 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: phy: broadcom: add exp register access
 methods without buslock
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-2-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1335ee64-f337-3121-b694-9c164113b891@gmail.com>
Date:   Sat, 9 May 2020 16:47:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509223714.30855-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 3:37 PM, Michael Walle wrote:
> Add helper to read and write expansion registers without taking the mdio
> lock.
> 
> Please note, that this changes the semantics of the read and write.
> Before there was no lock between selecting the expansion register and
> the actual read/write. This may lead to access failures if there are
> parallel accesses. Instead take the bus lock during the whole access
> cycle.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
