Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72E32B6840
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgKQPIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbgKQPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:08:42 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF24C0613CF;
        Tue, 17 Nov 2020 07:08:42 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c66so17468984pfa.4;
        Tue, 17 Nov 2020 07:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yu/K9MDzQlqf/QF4RaavB4uksqaawxhzJ50+1rdsBnk=;
        b=JIzdEBzYmPEMwt/tM3t7S0N+KgTIhh7EeqOd3VdKKIjHoO+RE2yDEjnOEUxnen+TO8
         ECxsbMLVtFqR5Ma1nrDTAAJPZaHGyzMm0dX99dO3pPQUSIScf0oVxi+NpqsnaoO8614U
         JxM312Y8tObtxObfkpKqwWGPrXafmNqdtOjbp76WiKlSedwBW4UBBzlJEpCAzKiXoy7O
         61TbqThRwqIH/RVEuPw9w5fgSCkjcaDuz4b52KRZ0yZhN/hmPltopAjaOve/VvEH0jIA
         OPcl9Y41wdkq4acYRlEhFp+LxAKQ5QhYlJxsd7CoOZQFM3Ahm7Ii8BY+2xXA1xJGYZ+V
         6inA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yu/K9MDzQlqf/QF4RaavB4uksqaawxhzJ50+1rdsBnk=;
        b=Pk7AtTC64lU/ziOK//Q3QtBxJE+b82Td1L/ZIfwfCxfWUkt4xdMj86LSFCM4NUNk77
         0MAL0aCmKitG0s6qxOj8CgJegILxFJLx3CQQyCXvtu7ao9rv2zihyPdyKW35i1jO93c8
         clPCG5oPR6U6h4/Yxri0HSnzCtrHTPsxiN488eQpnKXczNUvRNoYJE8uYjmKQUUxKlju
         0wAkBrZvWSL6lj80POQATLDPisVPRzEKMFXra2abrxfgXa4Gxs5G1Nr82cmEfRX2jq+5
         mjiwWCCLRG5De7mHsnrnbrMFrcyheb5uCEgOej2nYvu/f+1Bhmjrquh+XgvcWq6BvuR8
         mCEQ==
X-Gm-Message-State: AOAM530K1Eu3pnEr9D0A76TKxuZLPiStkuxdxZbmfJaUMT3BSOl674aP
        4NE6OELDk66ejvcdfv6s+fw=
X-Google-Smtp-Source: ABdhPJw5OKfITfkoQW3kgroBy5O1W5WB1dfp6D9z3L41/iNJTNsGWOGsyfhcWvEpskjULBG26ilkcA==
X-Received: by 2002:a62:51c4:0:b029:160:922:d7a1 with SMTP id f187-20020a6251c40000b02901600922d7a1mr18841093pfb.34.1605625721974;
        Tue, 17 Nov 2020 07:08:41 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d18sm21444243pfo.133.2020.11.17.07.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 07:08:41 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
 <20201110102552.GZ1551@shell.armlinux.org.uk> <87blg5qou5.fsf@microchip.com>
 <20201110151248.GA1551@shell.armlinux.org.uk> <87a6voqntq.fsf@microchip.com>
 <20201115121921.GI1551@shell.armlinux.org.uk> <877dqkqly5.fsf@microchip.com>
 <20201117134546.GA1797886@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
Message-ID: <b9c293f8-dcd2-47ab-7c35-d46a7eeec321@gmail.com>
Date:   Tue, 17 Nov 2020 07:08:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117134546.GA1797886@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2020 5:45 AM, Andrew Lunn wrote:
>>> Do you have the Marvell PHY driver either built-in or available as a
>>> module? I suspect the problem is you don't. You will need the Marvell
>>> PHY driver to correctly drive the PHY, you can't rely on the fallback
>>> driver for SFPs.
>> Correct.  I was using the generic driver and that does clearly not
>> work.  After including the Marvell driver the callback to the validate
>> function happens as expected.  Thanks for the support.
> 
> Hi Russell
> 
> Maybe we should have MDIO_I2C driver select the Marvell PHY driver?

It was suggested a while ago that MARVELL_PHY follow the SFP
configuration symbol and that we would warn when a CuSFP module was used
with the Generic PHY driver:

https://www.mail-archive.com/netdev@vger.kernel.org/msg253839.html

Eventually we did not make progress towards creating a list of modules
that would require a specialized PHY driver, maybe we can start now?
-- 
Florian
