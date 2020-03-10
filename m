Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F111803E7
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCJQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:47:06 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33772 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCJQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:47:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id z65so11226011ede.0;
        Tue, 10 Mar 2020 09:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KaPldxTH/MOzYJHDrcn8FfN8mXWcToCgtBawkR0wyWs=;
        b=T7RnYrMI4PK8EB5ELCHeXakHQ1YvHx60EzqZmU0MB0KwtV/2WzGfSeUMw2kCfcFlCS
         rF0sDn4d00UIkPNSEcueRx8QH2rHAbL95thqO07lw89r3JrquAuaXsVw5Vn3iPTe6jnx
         yFkybxLId61q3oh4+WWKnjq8C1sfQOFjOkx8LxuwGU2oY9+2GE3IodsO62qS/lGhnXTw
         6qt4FyDnoFIJJzcuQKsmAzOT0kj+mU8S9m/FF1Vj3jG3evM4CwVMxeQCXL5JJX06CzG/
         r8daAcTLsRKdzUfrlWVVphWcR19CFmRv7fBnOg4tLKy1Y8DeYwncp+uX18V8d4jrEjxX
         y2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KaPldxTH/MOzYJHDrcn8FfN8mXWcToCgtBawkR0wyWs=;
        b=pw7Ncw+sslXroRf76x9gCDFNVdGeI0iwCpTTLhqtwYegXz5KSVO6PbSEetg6qpWzHE
         jSsnt1ygBlVhf6gynN8nc065/iD2xX15MTuDvuSgzZfREAq7gUIQg3yzNW1V/K9p2t5O
         joBLDi7NZ4XZs1sDBWEpF4rA2hZkBmmO2p3WrREWumfOM6QfUeKIEopBbM4BTnlU609d
         FqRkCs1iVe9XLFmgQw1hKNbwrcfBqAX5120ZDNQuo9zfXFf7lcwMu4AF6Ch/VDaTRZfq
         HH99hKE2yjAIW9RYCYv3SN+c/5kqTZPwYY/0qqTMpouG1CS+QIUUQ54IQ+Lzvunpwq9H
         y2wA==
X-Gm-Message-State: ANhLgQ1CHMfAdul6pTlQoAGE65AK1vyzGRsh6oPNBVL+/Ushj6w+FIHr
        XiPBiPGqABPc33OxMdwWTeVoEUYz
X-Google-Smtp-Source: ADFU+vsvuyXnQKzBQuTwVuG2o3ywflRkiQSuLRQe0z4hDMvawHwWfF/PB8W+Vq2jZW9Z9rlTMpTvKw==
X-Received: by 2002:a17:906:8409:: with SMTP id n9mr18238651ejx.253.1583858822169;
        Tue, 10 Mar 2020 09:47:02 -0700 (PDT)
Received: from [10.67.48.239] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j19sm506231edq.57.2020.03.10.09.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:47:01 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, B38611@freescale.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
References: <20200220233454.31514-1-f.fainelli@gmail.com>
 <20200223.205911.1667092059432885700.davem@davemloft.net>
 <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
Date:   Tue, 10 Mar 2020 09:46:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 7:16 AM, Geert Uytterhoeven wrote:
> Hi Florian, David,
> 
> On Mon, Feb 24, 2020 at 5:59 AM David Miller <davem@davemloft.net> wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Date: Thu, 20 Feb 2020 15:34:53 -0800
>>
>>> It is currently possible for a PHY device to be suspended as part of a
>>> network device driver's suspend call while it is still being attached to
>>> that net_device, either via phy_suspend() or implicitly via phy_stop().
>>>
>>> Later on, when the MDIO bus controller get suspended, we would attempt
>>> to suspend again the PHY because it is still attached to a network
>>> device.
>>>
>>> This is both a waste of time and creates an opportunity for improper
>>> clock/power management bugs to creep in.
>>>
>>> Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> Applied, and queued up for -stable, thanks Florian.
> 
> This patch causes a regression on r8a73a4/ape6evm and sh73a0/kzm9g.
> After resume from s2ram, Ethernet no longer works:
> 
>         PM: suspend exit
>         nfs: server aaa.bbb.ccc.ddd not responding, still trying
>         ...
> 
> Reverting commit 503ba7c6961034ff ("net: phy: Avoid multiple suspends")
> fixes the issue.
> 
> On both boards, an SMSC LAN9220 is connected to a power-managed local
> bus.
> 
> I added some debug code to check when the clock driving the local bus
> is stopped and started, but I see no difference before/after.  Hence I
> suspect the Ethernet chip is no longer reinitialized after resume.

Can you provide a complete log? Do you use the Generic PHY driver or a
specialized one? Do you have a way to dump the registers at the time of
failure and see if BMCR.PDOWN is still set somehow?

Does the following help:

diff --git a/drivers/net/ethernet/smsc/smsc911x.c
b/drivers/net/ethernet/smsc/smsc911x.c
index 49a6a9167af4..df17190c76c0 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2618,6 +2618,7 @@ static int smsc911x_resume(struct device *dev)
        if (netif_running(ndev)) {
                netif_device_attach(ndev);
                netif_start_queue(ndev);
+               phy_resume(dev->phydev);
        }

        return 0;
-- 
Florian
