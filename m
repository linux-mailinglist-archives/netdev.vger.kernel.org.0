Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF6234650
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgGaM4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:56:34 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35216 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgGaM4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:56:34 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06VCtnL3072864;
        Fri, 31 Jul 2020 07:55:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596200149;
        bh=G0Xwps0ejxflqoHl3XO1DxMChXYTwyfCeHdlWawZgZM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hPeub8/uhiPJiPnQexCCq+I8i4yVTdU7I8ltqC8iEggn6U9mhvT18Da2E8lE7EKpR
         +DC/kbWPdOcwxoByGjY36mroT/Ef/Osl49Noma1LhLLERnxF5LsmKb8XTPZdLTpCzZ
         U8x2PH2kaQSRehPDIZhzqW6C+YC/sf5pz/Etr28g=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06VCtmoh084940
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 07:55:48 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 31
 Jul 2020 07:55:48 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 31 Jul 2020 07:55:48 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06VCtf5N125012;
        Fri, 31 Jul 2020 07:55:44 -0500
Subject: Re: [PATCH v3 5/9] ethernet: ti: am65-cpts: Use generic helper
 function
To:     Kurt Kanzenbach <kurt@linutronix.de>, Arnd Bergmann <arnd@arndb.de>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-6-kurt@linutronix.de>
 <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com> <87ime5ny3e.fsf@kurt>
 <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com>
 <87lfiz29di.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <f30d3a4f-6cf3-1d46-397e-baa27b3c8ade@ti.com>
Date:   Fri, 31 Jul 2020 15:55:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87lfiz29di.fsf@kurt>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/07/2020 14:48, Kurt Kanzenbach wrote:
> On Thu Jul 30 2020, Arnd Bergmann wrote:
>> On Thu, Jul 30, 2020 at 11:41 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>> On Thu Jul 30 2020, Grygorii Strashko wrote:
>>>> On 30/07/2020 11:00, Kurt Kanzenbach wrote:
>>>>> +    msgtype = ptp_get_msgtype(hdr, ptp_class);
>>>>> +    seqid   = be16_to_cpu(hdr->sequence_id);
>>>>
>>>> Is there any reason to not use "ntohs()"?
>>>
>>> This is just my personal preference, because I think it's more
>>> readable. Internally ntohs() uses be16_to_cpu(). There's no technical
>>> reason for it.
>>
>> I think for traditional reasons, code in net/* tends to use ntohs()
>> while code in drivers/*  tends to use be16_to_cpu().
>>
>> In drivers/net/* the two are used roughly the same, though I guess
>> one could make the argument that be16_to_cpu() would be
>> more appropriate for data structures exchanged with hardware
>> while ntohs() makes sense on data structures sent over the
>> network.
> 
> I see, makes sense. I could simply keep it the way it was, or?

  I prefer ntohs() as this packet data.

-- 
Best regards,
grygorii
