Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5642298E1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 15:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbgGVNBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 09:01:25 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41600 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVNBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 09:01:24 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06MD1GME102428;
        Wed, 22 Jul 2020 08:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595422876;
        bh=e0Fl9xbtFL6/GecO1wWIq3UcZwXxZGiz1V+tmMPYAxI=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=BfprbN7UEHxyHqQR3UDnmQLbNvKA6D1zdaM31Bs2I8KRgwZmUVFxJk5qnttUbyKOU
         ryqYTdGfQPzhKDJ09PTHLI257n265rgq1VlnpN4TIl62xrtk537dNdVllfm+EXuWTT
         w6Ahvgi5wFJLPiWqxCcqsZ1H0FMcrIDbecRdV+9I=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06MD1GSC043056
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 08:01:16 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 22
 Jul 2020 08:01:16 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Jul 2020 08:01:16 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06MD1F27089425;
        Wed, 22 Jul 2020 08:01:15 -0500
Subject: Re: [net-next v4 PATCH 1/7] hsr: enhance netlink socket interface to
 support PRP
To:     Randy Dunlap <rdunlap@infradead.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200720165803.17793-1-m-karicheri2@ti.com>
 <20200720165803.17793-2-m-karicheri2@ti.com>
 <f1675af9-f057-0b7b-c245-e15ead602bbc@infradead.org>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <e88b6cd2-881a-ce4f-e749-351aadf48ed2@ti.com>
Date:   Wed, 22 Jul 2020 09:01:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f1675af9-f057-0b7b-c245-e15ead602bbc@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy

On 7/20/20 2:37 PM, Randy Dunlap wrote:
> On 7/20/20 9:57 AM, Murali Karicheri wrote:
>> diff --git a/net/hsr/Kconfig b/net/hsr/Kconfig
>> index 8095b034e76e..e2e396870230 100644
>> --- a/net/hsr/Kconfig
>> +++ b/net/hsr/Kconfig
>> @@ -4,24 +4,35 @@
>>   #
>>   
>>   config HSR
>> -	tristate "High-availability Seamless Redundancy (HSR)"
>> -	help
>> +	tristate "High-availability Seamless Redundancy (HSR & PRP)"
>> +	---help---
> 
> Just use:
> 	help
> 
> The use of "---help---" has been discontinued.
> 
Ok. Will update.
>> +	  This enables IEC 62439 defined High-availability Seamless
>> +	  Redundancy (HSR) and Parallel Redundancy Protocol (PRP).
>> +
>>   	  If you say Y here, then your Linux box will be able to act as a
>> -	  DANH ("Doubly attached node implementing HSR"). For this to work,
>> -	  your Linux box needs (at least) two physical Ethernet interfaces,
>> -	  and it must be connected as a node in a ring network together with
>> -	  other HSR capable nodes.
>> +	  DANH ("Doubly attached node implementing HSR") or DANP ("Doubly
>> +	  attached node implementing PRP"). For this to work, your Linux box
>> +	  needs (at least) two physical Ethernet interfaces.
>> +
>> +	  For DANH, it must be connected as a node in a ring network together
>> +	  with other HSR capable nodes. All Ethernet frames sent over the hsr
> 
> 	                                                                  HSR
> 
>> +	  device will be sent in both directions on the ring (over both slave
>> +	  ports), giving a redundant, instant fail-over network. Each HSR node
>> +	  in the ring acts like a bridge for HSR frames, but filters frames
>> +	  that have been forwarded earlier.
>>   
>> -	  All Ethernet frames sent over the hsr device will be sent in both
>> -	  directions on the ring (over both slave ports), giving a redundant,
>> -	  instant fail-over network. Each HSR node in the ring acts like a
>> -	  bridge for HSR frames, but filters frames that have been forwarded
>> -	  earlier.
>> +	  For DANP, it must be connected as a node connecting to two
>> +	  separate networks over the two slave interfaces. Like HSR, Ethernet
>> +	  frames sent over the prp device will be sent to both networks giving
> 
> 	                       PRP
> 
>> +	  a redundant, instant fail-over network. Unlike HSR, PRP networks
>> +	  can have Singly Attached Nodes (SAN) such as PC, printer, bridges
>> +	  etc and will be able to communicate with DANP nodes.
>>   
>>   	  This code is a "best effort" to comply with the HSR standard as
>>   	  described in IEC 62439-3:2010 (HSRv0) and IEC 62439-3:2012 (HSRv1),
>> -	  but no compliancy tests have been made. Use iproute2 to select
>> -	  the version you desire.
>> +	  and PRP standard described in IEC 62439-4:2012 (PRP), but no
>> +	  compliancy tests have been made. Use iproute2 to select the protocol
>> +	  you would like to use.
>>   
>>   	  You need to perform any and all necessary tests yourself before
>>   	  relying on this code in a safety critical system!
> 
> thanks.
> 

-- 
Murali Karicheri
Texas Instruments
