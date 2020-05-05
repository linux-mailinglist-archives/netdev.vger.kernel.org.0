Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97551C53E6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgEELF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:05:27 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:55242 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbgEELF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 07:05:27 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045B5Ffc037803;
        Tue, 5 May 2020 06:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588676715;
        bh=umV3B0I90WivROOQuE1mue7ZnlXEBWCYNsNS60PidxE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=v2PIMyT/xLLLP77mLPoVDXUtJLvKbrHUxN72YgrIJCb8VvZoHp1l8WTXEz0FQQ14o
         MHYEFMKOH6e3H/joIN/Vnddo7zlh1vIm1cGIOFU1C/cVCl73qbhfdmmwJUzUKtgRrf
         K8AuRIPQulJ9XLRky3VX1rI5rt5PQVHU6eSzAenA=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045B5FjQ073523;
        Tue, 5 May 2020 06:05:15 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 06:05:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 06:05:14 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045B5BKn127153;
        Tue, 5 May 2020 06:05:12 -0500
Subject: Re: [PATCH net-next 3/7] net: ethernet: ti: am65-cpsw-nuss: enable
 packet timestamping support
To:     Anders Roxell <anders.roxell@linaro.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Networking <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-4-grygorii.strashko@ti.com>
 <CADYN=9L+RtruRYKah0Bomh7UaPGQ==N9trd0ZoVQ3GTc-VY8Dg@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <1bf51157-9fee-1948-f9ff-116799d12731@ti.com>
Date:   Tue, 5 May 2020 14:05:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CADYN=9L+RtruRYKah0Bomh7UaPGQ==N9trd0ZoVQ3GTc-VY8Dg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Anders,

On 05/05/2020 13:17, Anders Roxell wrote:
> On Fri, 1 May 2020 at 22:50, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>
>> The MCU CPSW Common Platform Time Sync (CPTS) provides possibility to
>> timestamp TX PTP packets and all RX packets.
>>
>> This enables corresponding support in TI AM65x/J721E MCU CPSW driver.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/ethernet/ti/Kconfig             |   1 +
>>   drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  24 ++-
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 172 ++++++++++++++++++++
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   6 +-
>>   4 files changed, 201 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>> index 1f4e5b6dc686..2c7bd1ccaaec 100644
>> --- a/drivers/net/ethernet/ti/Kconfig
>> +++ b/drivers/net/ethernet/ti/Kconfig
>> @@ -100,6 +100,7 @@ config TI_K3_AM65_CPSW_NUSS
>>          depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
>>          select TI_DAVINCI_MDIO
>>          imply PHY_TI_GMII_SEL
>> +       imply TI_AM65_CPTS
> 
> Should this be TI_K3_AM65_CPTS ?
> 
> I did an arm64 allmodconfig build on todays next tag: next-20200505
> and got this undefined symbol:
> 
> aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> function `am65_cpsw_init_cpts':
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:
> undefined reference to `am65_cpts_create'
> aarch64-linux-gnu-ld:
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> `am65_cpts_create'
> aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> function `am65_cpsw_nuss_tx_compl_packets':
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:
> undefined reference to `am65_cpts_tx_timestamp'
> aarch64-linux-gnu-ld:
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:(.text+0x4cf0):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> `am65_cpts_tx_timestamp'
> aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> function `am65_cpsw_nuss_ndo_slave_xmit':
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:
> undefined reference to `am65_cpts_prep_tx_timestamp'
> aarch64-linux-gnu-ld:
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:(.text+0x58fc):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> `am65_cpts_prep_tx_timestamp'
> aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> function `am65_cpsw_nuss_hwtstamp_set':
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:
> undefined reference to `am65_cpts_rx_enable'
> aarch64-linux-gnu-ld:
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:(.text+0x7564):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> `am65_cpts_rx_enable'
> aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-ethtool.o: in
> function `am65_cpsw_get_ethtool_ts_info':
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:
> undefined reference to `am65_cpts_phc_index'
> aarch64-linux-gnu-ld:
> /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:(.text+0xbe8):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> `am65_cpts_phc_index'
> make[1]: *** [/srv/src/kernel/next/Makefile:1114: vmlinux] Error 1
> make[1]: Target 'Image' not remade because of errors.
> make: *** [Makefile:180: sub-make] Error 2
> make: Target 'Image' not remade because of errors.

Sry, I can't reproduce it net-next. trying next...
What's your config?

-- 
Best regards,
grygorii
