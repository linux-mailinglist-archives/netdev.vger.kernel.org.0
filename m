Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC023BF8F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgHDTDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:03:41 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60230 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgHDTDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:03:40 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 074J3bJV079864;
        Tue, 4 Aug 2020 14:03:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596567817;
        bh=yWgCW5KbK2eJHRxDOk+Qm7j4TT2dgASbjS77VQEojpk=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=GDSpGctHznoIJLJ8AtCS193cBxCNteA2yXvdvHGW7InExC5bf9aaOi6GP3w42CYxg
         YHlOsFGfGCgCYYZqhQqhyY33B5pzDxkNWik/GHCa5ocXLALXTWy4T4OWpdrwGY6vIe
         bW3j91jJrTxtSND+87VDi7flAFQOhISAkLqxakiw=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 074J3bhs114451
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Aug 2020 14:03:37 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 4 Aug
 2020 14:03:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 4 Aug 2020 14:03:36 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 074J3a0G043881;
        Tue, 4 Aug 2020 14:03:36 -0500
Subject: Re: [net-next v5 PATCH 0/7] Add PRP driver
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
 <20200727.122120.336438917999066726.davem@davemloft.net>
 <fb10c323-d5c2-93d6-9784-51ff632fb3ff@ti.com>
Message-ID: <15ee164a-5b00-c834-0532-545ac1407989@ti.com>
Date:   Tue, 4 Aug 2020 15:03:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fb10c323-d5c2-93d6-9784-51ff632fb3ff@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On 7/30/20 9:41 AM, Murali Karicheri wrote:
> Hi Dave,
> 
> On 7/27/20 3:21 PM, David Miller wrote:
>> From: Murali Karicheri <m-karicheri2@ti.com>
>> Date: Wed, 22 Jul 2020 10:40:15 -0400
>>
>>> This series is dependent on the following patches sent out to
>>> netdev list. All (1-3) are already merged to net/master as of
>>> sending this, but not on the net-next master branch. So need
>>> to apply them to net-next before applying this series. v3 of
>>> the iproute2 patches can be merged to work with this series
>>> as there are no updates since then.
>>>
>>> [1] https://marc.info/?l=linux-netdev&m=159526378131542&w=2
>>> [2] https://marc.info/?l=linux-netdev&m=159499772225350&w=2
>>> [3] https://marc.info/?l=linux-netdev&m=159499772425352&w=2
>>>
>>> This series adds support for Parallel Redundancy Protocol (PRP)
>>> in the Linux HSR driver as defined in IEC-62439-3. PRP Uses a
>>> Redundancy Control Trailer (RCT) the format of which is
>>> similar to HSR Tag. This is used for implementing redundancy.
>>   ...
>>
>> Series applied to net-next, thank you.
>>
> Thanks for applying this series. Just wondering who will
> pick up the v3 of the iproute2 patch I have posted to go
> with this.
>May I know who will merge the below series to go with this
PRP kernel series?

Thanks

Murali
> https://marc.info/?l=linux-netdev&m=159499933326135&w=2
> 
> I will reply to that thread as well.
> 
> Thanks

-- 
Murali Karicheri
Texas Instruments
