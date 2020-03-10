Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA331804E9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCJRey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:34:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40047 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJRex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:34:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id e26so2332440wme.5;
        Tue, 10 Mar 2020 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U6f3jR5cofhDMdVNFUcl/FRQOrF4OSLHRtQNC4B+Oi8=;
        b=FRwhm0cQNHyipxPDI9vIQUW+Ec4nDYaTBIWWghGssIv+piLK9CCWRNsmCdonsspBar
         TQUL+1ZvHywmfRHRDVKop1lV8K3zYsIwJIwGmDHm/AHNNliuT4vZ3OWGXjEj8CLCYSU1
         uol6oDtkYy7bjZtJwMiPIw2DBJzscJSMnqbrRt8kyqlSj5IskCbJ9vIPbL+epOinPonG
         7L0c5p4qoLtiTxxe0/TJLpC0rFm/XEM0YKEnTb9gBdMZQc9E2NjgTSx8otgQ1In9jhh2
         wbAMriOc/kdhrqm5KOow8GX04nL/rRFITYeNqK7w5qa7ShqbjcybCaQXmt+jJWevUREx
         lxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U6f3jR5cofhDMdVNFUcl/FRQOrF4OSLHRtQNC4B+Oi8=;
        b=RATFXw7FcKmmzMEFAXhu1Wx7KIWnQksQee7LRUoMfVGQ6SfyI8PPmYdA6wKJrQz4Z0
         hfEq/gqJHccKniShUVix8TKgfnjat+9hCujGo5Zb+3CKoK57OSRQfLc1GWeC8wG7yEtF
         M9ml8mDZOSXPUZP1ljx5Hz/kueehKcKbVupDhEbgfkO9Lyo2RU+7xT5Jp9XsOYdQrsKE
         X6wtj5066PSfr0EKfSbqWa38lspF7qJy0WiheYVK20UqGcEvbrc3QWQvI+gVsOxn1vnS
         T+oWcXD56dHmkNhSiHvRKsENIX4iMShexWXwzWrXm3k70OUnpu25xV9Ipi4tWbzkD5st
         63rA==
X-Gm-Message-State: ANhLgQ3EYbZPxq1CJaGVJCDivjJmDyAU7e1eNeigaY8We3pHbf8lzTxA
        Nt+auG/cecSnKyBbDq9hh+hoLyKH
X-Google-Smtp-Source: ADFU+vsAPK0nYeD04cv505gseGdDytwmYzl5sltN/lxQAFAJN28wspA6e3P36YN5s6TXRghOdx6EMA==
X-Received: by 2002:a1c:68d5:: with SMTP id d204mr3144791wmc.15.1583861689764;
        Tue, 10 Mar 2020 10:34:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:6583:5434:4ad:491c? (p200300EA8F2960006583543404AD491C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6583:5434:4ad:491c])
        by smtp.googlemail.com with ESMTPSA id g5sm293669wrr.57.2020.03.10.10.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:34:49 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, B38611@freescale.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
References: <20200220233454.31514-1-f.fainelli@gmail.com>
 <20200223.205911.1667092059432885700.davem@davemloft.net>
 <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com>
 <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <09a562d9-e4ac-1467-e362-931cde51443c@gmail.com>
Date:   Tue, 10 Mar 2020 18:34:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2020 17:46, Florian Fainelli wrote:
> On 3/10/20 7:16 AM, Geert Uytterhoeven wrote:
>> Hi Florian, David,
>>
>> On Mon, Feb 24, 2020 at 5:59 AM David Miller <davem@davemloft.net> wrote:
>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>> Date: Thu, 20 Feb 2020 15:34:53 -0800
>>>
>>>> It is currently possible for a PHY device to be suspended as part of a
>>>> network device driver's suspend call while it is still being attached to
>>>> that net_device, either via phy_suspend() or implicitly via phy_stop().
>>>>
>>>> Later on, when the MDIO bus controller get suspended, we would attempt
>>>> to suspend again the PHY because it is still attached to a network
>>>> device.
>>>>
>>>> This is both a waste of time and creates an opportunity for improper
>>>> clock/power management bugs to creep in.
>>>>
>>>> Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>
>>> Applied, and queued up for -stable, thanks Florian.
>>
>> This patch causes a regression on r8a73a4/ape6evm and sh73a0/kzm9g.
>> After resume from s2ram, Ethernet no longer works:
>>
>>         PM: suspend exit
>>         nfs: server aaa.bbb.ccc.ddd not responding, still trying
>>         ...
>>
>> Reverting commit 503ba7c6961034ff ("net: phy: Avoid multiple suspends")
>> fixes the issue.
>>
>> On both boards, an SMSC LAN9220 is connected to a power-managed local
>> bus.
>>
>> I added some debug code to check when the clock driving the local bus
>> is stopped and started, but I see no difference before/after.  Hence I
>> suspect the Ethernet chip is no longer reinitialized after resume.
> 
> Can you provide a complete log? Do you use the Generic PHY driver or a
> specialized one? Do you have a way to dump the registers at the time of
> failure and see if BMCR.PDOWN is still set somehow?
> 
Maybe reason for the misbehavior is that mdio_bus_phy_may_suspend() is
checked also in mdio_bus_phy_resume(), what's not very logical based
on the naming. The call to phy_resume() therefore may be skipped.


> Does the following help:
> 
> diff --git a/drivers/net/ethernet/smsc/smsc911x.c
> b/drivers/net/ethernet/smsc/smsc911x.c
> index 49a6a9167af4..df17190c76c0 100644
> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -2618,6 +2618,7 @@ static int smsc911x_resume(struct device *dev)
>         if (netif_running(ndev)) {
>                 netif_device_attach(ndev);
>                 netif_start_queue(ndev);
> +               phy_resume(dev->phydev);
>         }
> 
>         return 0;
> 

