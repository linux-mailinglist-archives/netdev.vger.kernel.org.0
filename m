Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A21C5600
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgEEMzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:55:48 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:50544 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgEEMzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 08:55:48 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045CtgJd100492;
        Tue, 5 May 2020 07:55:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588683342;
        bh=TFx+viVGB1RJAgHDimKDlop7ZpZlSmdHvKAad8iYbGk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OPSd7s7EyQGGbbs6oMhwkXOkxxVubFW4Hn6fLa9Mcm1djjT7WC5J6yQ4wCiTQzipJ
         e3zo/AellZ4yCplWQYc0fAPnM2yz9L4m/7BgsvCMGDTnbrWelqUHJ1xYpGlXHtaWxx
         OUBjKPr7UrAEt+R2bv5ZxIjMOVJlMWtU+3yd2V9A=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 045Ctgmi031790
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 May 2020 07:55:42 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 07:55:42 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 07:55:42 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045Ctchu036626;
        Tue, 5 May 2020 07:55:39 -0500
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
 <1bf51157-9fee-1948-f9ff-116799d12731@ti.com>
 <CADYN=9LfqLLmKNHPfXEiQbaX8ELF78BL-vWUcX-VP3aQ86csNg@mail.gmail.com>
 <CADYN=9LDCE2sQca12D4ow3BkaxXi1_bnc4Apu7pP4vnA=5AOKA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7c32cb2f-e0f3-8861-3cdc-ef3f922aa044@ti.com>
Date:   Tue, 5 May 2020 15:55:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CADYN=9LDCE2sQca12D4ow3BkaxXi1_bnc4Apu7pP4vnA=5AOKA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/05/2020 14:59, Anders Roxell wrote:
> On Tue, 5 May 2020 at 13:16, Anders Roxell <anders.roxell@linaro.org> wrote:
>>
>> On Tue, 5 May 2020 at 13:05, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>>
>>> hi Anders,
>>
>> Hi Grygorii,
> 
> Hi again,
> 
>>
>>>
>>> On 05/05/2020 13:17, Anders Roxell wrote:
>>>> On Fri, 1 May 2020 at 22:50, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>>>>
>>>>> The MCU CPSW Common Platform Time Sync (CPTS) provides possibility to
>>>>> timestamp TX PTP packets and all RX packets.
>>>>>
>>>>> This enables corresponding support in TI AM65x/J721E MCU CPSW driver.
>>>>>
>>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>> ---
>>>>>    drivers/net/ethernet/ti/Kconfig             |   1 +
>>>>>    drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  24 ++-
>>>>>    drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 172 ++++++++++++++++++++
>>>>>    drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   6 +-
>>>>>    4 files changed, 201 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>>>>> index 1f4e5b6dc686..2c7bd1ccaaec 100644
>>>>> --- a/drivers/net/ethernet/ti/Kconfig
>>>>> +++ b/drivers/net/ethernet/ti/Kconfig
>>>>> @@ -100,6 +100,7 @@ config TI_K3_AM65_CPSW_NUSS
>>>>>           depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
>>>>>           select TI_DAVINCI_MDIO
>>>>>           imply PHY_TI_GMII_SEL
>>>>> +       imply TI_AM65_CPTS
>>>>
>>>> Should this be TI_K3_AM65_CPTS ?
> 
> instead of 'imply TI_K3_AM65_CPTS' don't you want to do this:
> 'depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS'
> 
> 

this seems will do the trick.
Dependencies:
PTP_1588_CLOCK -> TI_K3_AM65_CPTS -> TI_K3_AM65_CPSW_NUSS

I'll send patch.

-- 
Best regards,
grygorii
