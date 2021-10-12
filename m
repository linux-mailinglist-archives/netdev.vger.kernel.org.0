Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995742ABDF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhJLS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhJLS1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 14:27:51 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30637C061570;
        Tue, 12 Oct 2021 11:25:48 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t9so867996lfd.1;
        Tue, 12 Oct 2021 11:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gCOXirZ2cq5DJbKFifbFUNDOv99CNHvvSgUfE0XtsO0=;
        b=YVOPC3+KUq4wsv980GgfrQsTqtQFCrclhQbslwVa1QPwZSmNovRHg7t2BdJMPpw5ic
         cZkTHIZR6udbtwe/pf9gM1UbtD+nTDgw3hwX+YUJ3H5D5HJgtZ10xSgMuNFM62HbJSk7
         y7DjH5XlHArvxbjn1cVyebb2xEP85Y0bZ48elJLpPWNxII49OFCUZiMSPVp4fEc6zFst
         bcfSMnj/5ZMtuudmh24SZ2zx1meOUGl2l4VtVA9pdRCy49FE98vT4WggvSGB7rREcUiJ
         Cn/ElCTVl4VEpfk3UVNZ0bM6g7Nae2YtfzkyrXf5MrmkpNZ3xOPOhl+kqoboMMy2VpCV
         Z8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCOXirZ2cq5DJbKFifbFUNDOv99CNHvvSgUfE0XtsO0=;
        b=Ya7tfZ31wdYPPC2dtWUgd3Hs/EEDDE/EGgLKHsStIXFibb8U3M6+j4SbQIPjxzjjDn
         tEiL+9hwGO22ml4NQ5BSrQjQGgdRBI9yLcvrjbiT27oNeCRa2LsEVVFx4MQOBiHFJLKj
         /y1J7tFbYhBZ4vYK2pNTBPVETqqfeE3iQ2F7rViQH6mTonKQtUydi7tu7o0HsmYGiXjB
         R4IEv5AvI77xPXzGvzZI0ZY8/HofPUKONDAFEL6XFiFO88JIDXiaDOy7XgMvo2Ds+LqI
         /mmWVCd/eIsa77PKyhyqQpFkEn2EYeGhqgleBpSIwpHfP+L+A+7ikUTv3NsJxy7u/Qe0
         xT5A==
X-Gm-Message-State: AOAM530qgfo1mq5i82u0evbUNExlq+ELsjEnvZXd3ZK5yOkttoiJbEGO
        irIeHTo49qTmX6WX7RtrIPE=
X-Google-Smtp-Source: ABdhPJyPG561NauME+yUkhCuca2C6xj1+2hGtyjYTzvRoupD+8s00vcG6NnKA5ZN9WYJWzZZel2nVA==
X-Received: by 2002:a19:4855:: with SMTP id v82mr34866062lfa.478.1634063146053;
        Tue, 12 Oct 2021 11:25:46 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.83.90])
        by smtp.gmail.com with ESMTPSA id l27sm620746lfk.53.2021.10.12.11.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 11:25:45 -0700 (PDT)
Subject: Re: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
 <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
Date:   Tue, 12 Oct 2021 21:25:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 9:23 PM, Biju Das wrote:

>>>>> This patch enables Receive/Transmit port of TOE and removes the
>>>>> setting of promiscuous bit from EMAC configuration mode register.
>>>>>
>>>>> This patch also update EMAC configuration mode comment from "PAUSE
>>>>> prohibition" to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC
>>>>> Pass Through".
>>>>
>>>>    I'm not sure why you set ECMR.RCPT while you don't have the
>>>> checksum offloaded...
>>>>
>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>> ---
>>>>> v2->v3:
>>>>>  * Enabled TPE/RPE of TOE, as disabling causes loopback test to fail
>>>>>  * Documented CSR0 register bits
>>>>>  * Removed PRM setting from EMAC configuration mode
>>>>>  * Updated EMAC configuration mode.
>>>>> v1->v2:
>>>>>  * No change
>>>>> V1:
>>>>>  * New patch.
>>>>> ---
>>>>>  drivers/net/ethernet/renesas/ravb.h      | 6 ++++++
>>>>>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>>>>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>>> index 69a771526776..08062d73df10 100644
>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>> @@ -204,6 +204,7 @@ enum ravb_reg {
>>>>>  	TLFRCR	= 0x0758,
>>>>>  	RFCR	= 0x0760,
>>>>>  	MAFCR	= 0x0778,
>>>>> +	CSR0    = 0x0800,	/* RZ/G2L only */
>>>>>  };
>>>>>
>>>>>
>>>>> @@ -964,6 +965,11 @@ enum CXR31_BIT {
>>>>>  	CXR31_SEL_LINK1	= 0x00000008,
>>>>>  };
>>>>>
>>>>> +enum CSR0_BIT {
>>>>> +	CSR0_TPE	= 0x00000010,
>>>>> +	CSR0_RPE	= 0x00000020,
>>>>> +};
>>>>> +
>>>>
>>>>   Is this really needed if you have ECMR.RCPT cleared?
>>>
>>> Yes it is required. Please see the current log and log with the
>>> changes you suggested
>>>
>>> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
>>> [   39.646891] ravb 11c20000.ethernet eth0: Link is Down
>>> [   39.715127] ravb 11c30000.ethernet eth1: Link is Down
>>> [   39.895680] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-
>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-
>> ffffffff:07, irq=POLL)
>>> [   39.966370] Microchip KSZ9131 Gigabit PHY 11c30000.ethernet-
>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c30000.ethernet-
>> ffffffff:07, irq=POLL)
>>> [   42.988573] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>> [   42.995119] ravb 11c20000.ethernet eth0: Link is Up - 1Gbps/Full -
>> flow control off
>>> [   43.052541] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>>> [   43.055710] ravb 11c30000.ethernet eth1: Link is Up - 1Gbps/Full -
>> flow control off
>>>
>>> EXIT|PASS||[422391:43:00] ||
>>>
>>> root@smarc-rzg2l:/rzg2l-test-scripts#
>>>
>>>
>>> with the changes you suggested
>>> ----------------------------
>>>
>>> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
>>> [   23.300520] ravb 11c20000.ethernet eth0: Link is Down
>>> [   23.535604] ravb 11c30000.ethernet eth1: device will be stopped after
>> h/w processes are done.
>>> [   23.547267] ravb 11c30000.ethernet eth1: Link is Down
>>> [   23.802667] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-
>> ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-
>> ffffffff:07, irq=POLL)
>>> [   24.031711] ravb 11c30000.ethernet eth1: failed to switch device to
>> config mode
>>> RTNETLINK answers: Connection timed out
>>>
>>> EXIT|FAIL||[422391:42:32] Failed to bring up ETH1||
>>>
>>> root@smarc-rzg2l:/rzg2l-test-scripts#
>>
>>    Hm... :-/
>>    What if you only clear ECMR.RCPT but continue to set CSR0?
> 
> We already seen, RCPT=0, RCSC=1 with similar Hardware checksum function like R-Car,
> System crashes.

   I didn't tell you to set ECMR.RCSC this time. :-)

> Regards,
> Biju

MBR, Sergey
