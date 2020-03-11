Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DB61823C6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgCKVWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:22:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39244 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgCKVWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:22:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id f7so3834931wml.4;
        Wed, 11 Mar 2020 14:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zEBGqNmWMkfjp7ivVWJDStnNO+UDHuPLvuDXhLZVQUs=;
        b=UMF8S/HobM25YsLhi/9YE5JMe1VZlxnGiXBgNrvzJoAxzniYqtDbtNWNn+B1Y+Ztpz
         MfsSDuCIyK1RDV4vWnFfwz0cQqFdT/fJejeIzSidn7FMlEQyhbOWniV5ZlW5SHjgdllb
         SzTQYiIONoIqMgwJ0aPHgZJuG9d3z50uWdIPaVPuakXQdpVnRFfM5G8/5jzF9KaQ04bt
         Y2UYwg1GuYHxisoyyxbcIG9KKxogzm6C66URrEUTVcWxr6krxXadHbYu4Jchh0mwFbWq
         q4yIE7P9VgIXRX26DAEVTYDUAxhIO/S5OXECQud15b6g0lwntgNUlkjXzlr/0oFOSzIp
         Mfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zEBGqNmWMkfjp7ivVWJDStnNO+UDHuPLvuDXhLZVQUs=;
        b=gzh5dDIxELl0XrCIZQIAXZk72h4tvHKOpa+rnaA6HmIOnPRbTRbKu9VFFSNJ1SqbCM
         ObNQ27pKvqoFVwUOCWCR99EPEimU9Mcc2/Bts1xnGWx5WUyxyXPd1WX1Mmg/BniM021K
         r/tI1HDvHIgsmfK8foJAepQuv5CjDzyjqbxa/LEeizf+536Dol/bc50onJx1I4XHhW9x
         hxKGLXzfh7VBh4tnrrhEfdlbIsmgJr4cb4E+wzADHyJsU5JAMOcm9YTlAU4cnuumD0Vh
         stiW4TACYdITXfHGSPmbGvxnlnAGsoqYGDGO4hf6B7jA3PYEXTMsg/WFcBkssEDpxXEK
         csHA==
X-Gm-Message-State: ANhLgQ0Hug7DbhddtICcROwK1Qc8amo9cbG5vNay2ywBzzjBgZwFwqJo
        saP7J9hfIA4gf98EcpeOl/w+9OYr
X-Google-Smtp-Source: ADFU+vtTPgkZUZ+xcybs1bUaKk0QR5IVaGjMmnyNIP8AFwmwlOexaMQ/KMxo3oADFhzLkBH4YzKK7g==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr648895wmi.140.1583961755916;
        Wed, 11 Mar 2020 14:22:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:cddc:500b:7233:8488? (p200300EA8F296000CDDC500B72338488.dip0.t-ipconnect.de. [2003:ea:8f29:6000:cddc:500b:7233:8488])
        by smtp.googlemail.com with ESMTPSA id n11sm295851wrt.74.2020.03.11.14.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 14:22:35 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
References: <20200220233454.31514-1-f.fainelli@gmail.com>
 <20200223.205911.1667092059432885700.davem@davemloft.net>
 <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com>
 <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
 <CAMuHMdUMM0Q6W7A0mVgSf7XmF8yROZb3uzHPU1ETbMAfvTtfow@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ca2abe1a-a9ed-23c9-ceaa-b0042be49be9@gmail.com>
Date:   Wed, 11 Mar 2020 22:22:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUMM0Q6W7A0mVgSf7XmF8yROZb3uzHPU1ETbMAfvTtfow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.03.2020 10:17, Geert Uytterhoeven wrote:
> On Tue, Mar 10, 2020 at 5:47 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 3/10/20 7:16 AM, Geert Uytterhoeven wrote:
>>> Hi Florian, David,
>>>
>>> On Mon, Feb 24, 2020 at 5:59 AM David Miller <davem@davemloft.net> wrote:
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>> Date: Thu, 20 Feb 2020 15:34:53 -0800
>>>>
>>>>> It is currently possible for a PHY device to be suspended as part of a
>>>>> network device driver's suspend call while it is still being attached to
>>>>> that net_device, either via phy_suspend() or implicitly via phy_stop().
>>>>>
>>>>> Later on, when the MDIO bus controller get suspended, we would attempt
>>>>> to suspend again the PHY because it is still attached to a network
>>>>> device.
>>>>>
>>>>> This is both a waste of time and creates an opportunity for improper
>>>>> clock/power management bugs to creep in.
>>>>>
>>>>> Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>> Applied, and queued up for -stable, thanks Florian.
>>>
>>> This patch causes a regression on r8a73a4/ape6evm and sh73a0/kzm9g.
>>> After resume from s2ram, Ethernet no longer works:
>>>
>>>         PM: suspend exit
>>>         nfs: server aaa.bbb.ccc.ddd not responding, still trying
>>>         ...
>>>
>>> Reverting commit 503ba7c6961034ff ("net: phy: Avoid multiple suspends")
>>> fixes the issue.
>>>
>>> On both boards, an SMSC LAN9220 is connected to a power-managed local
>>> bus.
>>>
>>> I added some debug code to check when the clock driving the local bus
>>> is stopped and started, but I see no difference before/after.  Hence I
>>> suspect the Ethernet chip is no longer reinitialized after resume.
>>
>> Can you provide a complete log?
> 
> With some debug info:
> 
>     SDHI0 Vcc: disabling
>     PM: suspend entry (deep)
>     Filesystems sync: 0.002 seconds
>     Freezing user space processes ... (elapsed 0.001 seconds) done.
>     OOM killer disabled.
>     Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>     PM: ==== a3sp/ee120000.sd: stop
>     PM: ==== a3sp/ee100000.sd: stop
>     smsc911x 8000000.ethernet: smsc911x_suspend:2577
>     smsc911x 8000000.ethernet: smsc911x_suspend:2579 running
>     smsc911x 8000000.ethernet: smsc911x_suspend:2584
>     PM: ==== a3sp/ee200000.mmc: stop
>     PM: ==== c4/fec10000.bus: stop
>     PM: ==== a3sp/e6c40000.serial: stop
>     PM: ==== c5/e61f0000.thermal: stop
>     PM: ==== c4/e61c0200.interrupt-controller: stop
>     PM: == a3sp: power off
>     rmobile_pd_power_down: a3sp
>     Disabling non-boot CPUs ...
>     PM: ==== c4/e61c0200.interrupt-controller: start
>     PM: ==== c5/e61f0000.thermal: start
>     PM: ==== a3sp/e6c40000.serial: start
>     PM: ==== c4/fec10000.bus: start
>     PM: ==== a3sp/ee200000.mmc: start
>     smsc911x 8000000.ethernet: smsc911x_resume:2606
>     smsc911x 8000000.ethernet: smsc911x_resume:2625 running
>     PM: ==== a3sp/ee100000.sd: start
>     OOM killer enabled.
>     Restarting tasks ... done.
>     PM: ==== a3sp/ee120000.sd: start
>     PM: suspend exit
>     nfs: server aaa.bbb.ccc.ddd not responding, still trying
>     ...
> 
> But no difference between the good and the bad case, except for the nfs
> failures.
> 
>> Do you use the Generic PHY driver or a
>> specialized one?
> 
> CONFIG_FIXED_PHY=y
> CONFIG_SMSC_PHY=y
> 
> Just the smsc,lan9115 node, cfr. arch/arm/boot/dts/r8a73a4-ape6evm.dts
> 
>> Do you have a way to dump the registers at the time of
>> failure and see if BMCR.PDOWN is still set somehow?
> 
> Added a hook into "nfs: server not responding", which prints:
> 
>     MII_BMCR = 0x1900
> 
> i.e. BMCR_PDOWN = 0x0800 is still set.
> 
>> Does the following help:
>>
>> diff --git a/drivers/net/ethernet/smsc/smsc911x.c
>> b/drivers/net/ethernet/smsc/smsc911x.c
>> index 49a6a9167af4..df17190c76c0 100644
>> --- a/drivers/net/ethernet/smsc/smsc911x.c
>> +++ b/drivers/net/ethernet/smsc/smsc911x.c
>> @@ -2618,6 +2618,7 @@ static int smsc911x_resume(struct device *dev)
>>         if (netif_running(ndev)) {
>>                 netif_device_attach(ndev);
>>                 netif_start_queue(ndev);
>> +               phy_resume(dev->phydev);
>>         }
>>
> 
> Yes i does, after s/dev->/ndev->/.
> Thanks!
> 

This seems to be a workaround. And the same issue we may have with
other drivers too. Could you please alternatively test the following?
It tackles the issue that mdio_bus_phy_may_suspend() is used in
suspend AND resume, and both calls may return different values.

With this patch we call mdio_bus_phy_may_suspend() only when
suspending, and let the phy_device store whether it was suspended
by MDIO bus PM.

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 32a5ceddc..6d6c6a178 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -286,6 +286,8 @@ static int mdio_bus_phy_suspend(struct device *dev)
 	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
 
+	phydev->suspended_by_mdio_bus = 1;
+
 	return phy_suspend(phydev);
 }
 
@@ -294,9 +296,11 @@ static int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
-	if (!mdio_bus_phy_may_suspend(phydev))
+	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
+	phydev->suspended_by_mdio_bus = 0;
+
 	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8b299476b..118de9f5b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -357,6 +357,7 @@ struct macsec_ops;
  * is_gigabit_capable: Set to true if PHY supports 1000Mbps
  * has_fixups: Set to true if this phy has fixups/quirks.
  * suspended: Set to true if this phy has been suspended successfully.
+ * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
  * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
  * state: state of the PHY for management purposes
@@ -396,6 +397,7 @@ struct phy_device {
 	unsigned is_gigabit_capable:1;
 	unsigned has_fixups:1;
 	unsigned suspended:1;
+	unsigned suspended_by_mdio_bus:1;
 	unsigned sysfs_links:1;
 	unsigned loopback_enabled:1;
 
-- 
2.25.1






