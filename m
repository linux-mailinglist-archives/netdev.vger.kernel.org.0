Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CAC2D96AC
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgLNKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:54:53 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55846 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725944AbgLNKyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:54:53 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEArEQ8024102;
        Mon, 14 Dec 2020 11:53:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=swqwm3JkRg58N/8FNiszAxWvcaShbbL+jaO0DhWTrwQ=;
 b=qu8AThVi1YT9cKAJL7iwXdkN/01zWOdfyb86Ovnbt0ncrxHEGRAr7/OAAHXUaelr9bfA
 rT7XWI+oprt57DUEkLBD/hm88AoVbfCw++FCtr72LdI3WtIRQvNhEGE0Cp0I8YVW9wag
 YMKIlZ7VoIEEiQt99BaDMGd5vzqbt2wYvH+dI1yfBHklQ78tmLf6J3lX5YPwqbRUrFRr
 e8Gq7ce3ZXtohEWLLFHgPm2xzSMtERMVHionoKoiDJLJQWoz0iIjf2fWE0STyCaMS+Jv
 xt9cC6UI83vSqQ2G3IVSXAIy2KgWOXVP2lKrHf+DJ1IiBG71FuDtG0h1gjLwes5p0WyM 7w== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 35cpwdtm62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 11:53:53 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id DA2AC100039;
        Mon, 14 Dec 2020 11:53:50 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9F10324C9E2;
        Mon, 14 Dec 2020 11:53:50 +0100 (CET)
Received: from lmecxl0912.lme.st.com (10.75.127.47) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Dec
 2020 11:53:50 +0100
Subject: Re: [RFC] net: stmmac: Problem with adding the native GPIOs support
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <8477f6be-eb8d-6b6f-33f2-835819542045@st.com>
Date:   Mon, 14 Dec 2020 11:52:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG3NODE3.st.com (10.75.127.9) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_04:2020-12-11,2020-12-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Serge,

Sorry I never used GPIO provided by DWMAC IP. Obviously, I think is to 
late for you to use GPIOs provided by your SoC directly. Unfortunately, 
it seems to be a "perfect" chicken and eggs problem :(.

Do you have possibilty to "play" with gpio setting. I mean change 
configuration of them (at least for reset one) before perform a DMA 
reset: If you have a pull-up on RST line and you could "disconnect" GPO 
inside GMAC then your PHY should remain on during DMA reset phase.

regards
Alex

On 12/14/20 10:25 AM, Serge Semin wrote:
> Hello folks,
> 
> I've got a problem, which has been blowing by head up for more than three
> weeks now, and I'm desperately need your help in that matter. See our
> Baikal-T1 SoC is created with two DW GMAC v3.73a IP-cores. Each core
> has been synthesized with two GPIOs: one as GPI and another as GPO. There
> are multiple Baikal-T1-based devices have been created so far with active
> GMAC interface usage and each of them has been designed like this:
> 
>   +------------------------+
>   | Baikal-T1 +------------+       +------------+
>   |   SoC     | DW GMAC    |       |   Some PHY |
>   |           |      Rx-clk+<------+Rx-clk      |
>   |           |            |       |            |
>   |           |         GPI+<------+#IRQ        |
>   |           |            |       |            |
>   |           |       RGMII+<----->+RGMII       |
>   |           |        MDIO+<----->+MDIO        |
>   |           |            |       |            |
>   |           |         GPO+------>+#RST        |
>   |           |            |       |            |
>   |           |      Tx-clk+------>+Tx-clk      |
>   |           |            |       |            |
>   |           +------------+       +------------+
>   +------------------------+
> 
> Each of such devices has got en external RGMII-PHY attached configured via the
> MDIO bus with Rx-clock supplied by the PHY and Tx-clock consumed by it. The
> main peculiarity of such configuration is that the DW GMAC GPIOs have been used
> to catch the PHY IRQs and to reset the PHY. Seeing the GPIOs support hasn't
> been added to the STMMAC driver it's the very first setup for now, which has
> been using them. Anyway the hardware setup depicted above doesn't seem
> problematic at the first glance, but in fact it is. See, the DW *MAC driver
> (STMMAC ethernet driver) is doing the MAC reset each time it performs the
> device open or resume by means of the call-chain:
> 
>    stmmac_open()---+
>                    +->stmmac_hw_setup()->stmmac_init_dma_engine()->stmmac_reset().
>    stmmac_resume()-+
> 
> Such reset causes the whole interface reset: MAC, DMA and, what is more
> important, GPIOs as being exposed as part of the MAC registers. That
> in our case automatically causes the external PHY reset, what neither
> the STTMAC driver nor the PHY subsystem expect at all.
> 
> Moreover the stmmac_reset() method polls the DMA_BUS_MODE.SFT_RESET flag
> state to be sure the MAC is successfully completed. But since the external
> PHY has got in reset state it doesn't generate the Rx-clk signal. Due to
> that the MAC-DMA won't get out of the reset state so the stmmac_reset()
> method will return timeout error. Of course I could manually restore the
> GPIOs state in the stmmac_reset() before start to poll the SFT_RESET flag,
> which may release the PHY reset. But that seems more like a workaround,
> because the PHY still has been in reset and need to be reinitialized
> anyway. Moreover some PHY may need to have more complicated reset cycle
> with certain delays between RST assertion/de-assertion, so the workaround
> won't work well for them.
> 
> To sum it up my question is what is the right way to resolve the problem
> described above? My first idea was to just move the MAC reset from the
> net-device open()/close() callbacks to the
> stmmac_dvr_probe()/stmmac_dvr_remove() functions and don't reset the whole
> interface on each device open. The problems we may have in that case is
> due to the suspend/resume procedures, which for some reason require the
> MAC reset too. That's why I need your help in this matter. Do you have any
> idea how to gently add the GPIOs support and don't break the STMMAC
> driver?
> 
> One more tiny question regarding the DW *MAC drivers available in kernel.
> Aside of the DW GMAC Baikal-T1 SoC has also got DW xGMAC v2.11a embedded
> with XPCS PHY attached. My question is what driver should we better use to
> handle our xGMAC interface? AFAICS there are three DW *MAC-related drivers
> the kernel currently provides:
> 1) drivers/net/ethernet/stmicro/stmmac
> 2) drivers/net/ethernet/amd/
> 3) drivers/net/ethernet/synopsys/
> xGBE interface is supported by the drivers 1) and 2). In accordance with
> https://www.spinics.net/lists/netdev/msg414148.html all xGMAC related
> parts should have been added to 2), but recently the XGMAC support has
> been added to 1). So I am confused what driver is now supposed to be used
> for new xGMACs?
> 
> Regards,
> -Sergey
> 
