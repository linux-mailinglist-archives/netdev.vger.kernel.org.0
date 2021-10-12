Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438D342AB83
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhJLSFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhJLSFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 14:05:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADB5C061746;
        Tue, 12 Oct 2021 11:03:07 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id n8so521927lfk.6;
        Tue, 12 Oct 2021 11:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=skyesUyr3B+Ax6gjLiY8YmtziteIDjVpYdY0ROX95BM=;
        b=IKpocSl2WvdU/Vh6bS2aNZwBO6/kr4NGRPh2o8Gu4VVGfi0p8Xwq1EEH597xi6PCJC
         r/+hJry30K7YBgautpKW+rj8m2yvsSFoiUSBIWY01DYWkMC5UwLlZqHNP8mMX7JWE1pz
         k/koHNlzehRIF0NGFKsbysJcRxceOYdWOx/+Ib+guDoOyhEGtpAv5pi0VTYJMJWdRfFs
         IAqgP4NLJ7u9zlD9jKQf85OT0S9Cx+tJXaiwmv4n30H0GO9tcLpOrpBgCeFU4GPVGPgi
         T0d0WWt1plxLM7a+MI+DEajRu/b4dO7eEx6cWKMnriQD9l61mH/2KrrZnNOcXRJEJ6AB
         Xt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=skyesUyr3B+Ax6gjLiY8YmtziteIDjVpYdY0ROX95BM=;
        b=rpc/Xc7XU/A4g4RFiQAScCe+cuyR8TRkkF3jWqrjLcFf7+ApOZrd8SENHPELfGr8Zq
         jJuYj7pAteRRED/Hn+ZFfNP14Ro7q3c81ADrvt69EL0QvQUqqZveWgysP5IFrjKfHL8q
         H8DoOVY7FDu24Y9EoKfVpaMO3iJ5rkArnxPCld0/giw8iqbnGR+EDhxmuaepyDuo4y+9
         zs+NdC+v6oOpW2fpk7zyg+50mjWuw07gwVun/5S79noVtUmkYHrLQw013fw4Crs9qmGp
         7nleBl7O/GjANbNT20+/o4b1NkXvjTdjN8PICdaft6XBriRNdBg1xjqJm+PJ/uHJwcWa
         Hfpw==
X-Gm-Message-State: AOAM530LsarcAlF4z2b9YepO2fAjESuZDt0XqRt0D3Z7uOYM+UZDypsA
        4Fo7tCqCpMktBVLIQTTlrW0=
X-Google-Smtp-Source: ABdhPJxqgHXGABpdnTfyFKUJiK4QTUIFXx/asxB0D7Y1M9N+gacl2qRMMvtwmDscXLkkQOqe0cmmhQ==
X-Received: by 2002:a05:6512:16a7:: with SMTP id bu39mr36961158lfb.578.1634061786049;
        Tue, 12 Oct 2021 11:03:06 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.83.90])
        by smtp.gmail.com with ESMTPSA id 24sm191487lft.191.2021.10.12.11.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 11:03:05 -0700 (PDT)
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
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
Date:   Tue, 12 Oct 2021 21:03:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 8:52 PM, Biju Das wrote:

>>> This patch enables Receive/Transmit port of TOE and removes the
>>> setting of promiscuous bit from EMAC configuration mode register.
>>>
>>> This patch also update EMAC configuration mode comment from "PAUSE
>>> prohibition" to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC
>>> Pass Through".
>>
>>    I'm not sure why you set ECMR.RCPT while you don't have the checksum
>> offloaded...
>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>> v2->v3:
>>>  * Enabled TPE/RPE of TOE, as disabling causes loopback test to fail
>>>  * Documented CSR0 register bits
>>>  * Removed PRM setting from EMAC configuration mode
>>>  * Updated EMAC configuration mode.
>>> v1->v2:
>>>  * No change
>>> V1:
>>>  * New patch.
>>> ---
>>>  drivers/net/ethernet/renesas/ravb.h      | 6 ++++++
>>>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>> b/drivers/net/ethernet/renesas/ravb.h
>>> index 69a771526776..08062d73df10 100644
>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>> @@ -204,6 +204,7 @@ enum ravb_reg {
>>>  	TLFRCR	= 0x0758,
>>>  	RFCR	= 0x0760,
>>>  	MAFCR	= 0x0778,
>>> +	CSR0    = 0x0800,	/* RZ/G2L only */
>>>  };
>>>
>>>
>>> @@ -964,6 +965,11 @@ enum CXR31_BIT {
>>>  	CXR31_SEL_LINK1	= 0x00000008,
>>>  };
>>>
>>> +enum CSR0_BIT {
>>> +	CSR0_TPE	= 0x00000010,
>>> +	CSR0_RPE	= 0x00000020,
>>> +};
>>> +
>>
>>   Is this really needed if you have ECMR.RCPT cleared?
> 
> Yes it is required. Please see the current log and log with the changes you suggested
> 
> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
> [   39.646891] ravb 11c20000.ethernet eth0: Link is Down
> [   39.715127] ravb 11c30000.ethernet eth1: Link is Down
> [   39.895680] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-ffffffff:07, irq=POLL)
> [   39.966370] Microchip KSZ9131 Gigabit PHY 11c30000.ethernet-ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c30000.ethernet-ffffffff:07, irq=POLL)
> [   42.988573] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   42.995119] ravb 11c20000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> [   43.052541] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   43.055710] ravb 11c30000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off
> 
> EXIT|PASS||[422391:43:00] ||
> 
> root@smarc-rzg2l:/rzg2l-test-scripts#
> 
> 
> with the changes you suggested
> ----------------------------
> 
> root@smarc-rzg2l:/rzg2l-test-scripts# ./eth_t_001.sh
> [   23.300520] ravb 11c20000.ethernet eth0: Link is Down
> [   23.535604] ravb 11c30000.ethernet eth1: device will be stopped after h/w processes are done.
> [   23.547267] ravb 11c30000.ethernet eth1: Link is Down
> [   23.802667] Microchip KSZ9131 Gigabit PHY 11c20000.ethernet-ffffffff:07: attached PHY driver (mii_bus:phy_addr=11c20000.ethernet-ffffffff:07, irq=POLL)
> [   24.031711] ravb 11c30000.ethernet eth1: failed to switch device to config mode
> RTNETLINK answers: Connection timed out
> 
> EXIT|FAIL||[422391:42:32] Failed to bring up ETH1||
> 
> root@smarc-rzg2l:/rzg2l-test-scripts#

   Hm... :-/
   What if you only clear ECMR.RCPT but continue to set CSR0?

MBR, Sergey
