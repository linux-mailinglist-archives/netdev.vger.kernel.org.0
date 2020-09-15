Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460D8269CE0
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIOENB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:13:01 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60746 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOENA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:13:00 -0400
Received: from [192.168.0.114] (unknown [49.207.201.19])
        by linux.microsoft.com (Postfix) with ESMTPSA id 363FF2010AE6;
        Mon, 14 Sep 2020 21:12:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 363FF2010AE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1600143179;
        bh=qNTa4CcYPQWe6lZO7eD9EUP/G1TwoX4W5tI0RZxPALM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aZ5d676DLS5WnKCA9EF0DbVil9/K5Ytx24SWozRkajbMIBKFzdhcTdoZDtiw7wD95
         uFk+BHZafIcLQ5T+mFPErmcfV0PyJ3bBbGndXtQJoAweJHjKt6vG8fSRuURh4rIR7d
         SmVNbP6XBOvZsgra5oz8ju+zeSDFme9rKlXjp4/Q=
Subject: Re: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use
 new tasklet_setup() API
To:     Saeed Mahameed <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>
Cc:     "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "petkan@nucleusys.com" <petkan@nucleusys.com>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
 <5ab44bd27936325201e8f71a30e74d8b9d6b34ee.camel@nvidia.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <87508263-99f1-c56a-5fb1-2f4700b6b375@linux.microsoft.com>
Date:   Tue, 15 Sep 2020 09:42:51 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5ab44bd27936325201e8f71a30e74d8b9d6b34ee.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>>
>> ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
>> introduced a new tasklet initialization API. This series converts
>> all the net/* drivers to use the new tasklet_setup() API
>>
>> This series is based on v5.9-rc5
>>
>> Allen Pais (12):
>>    net: mvpp2: Prepare to use the new tasklet API
>>    net: arcnet: convert tasklets to use new tasklet_setup() API
>>    net: caif: convert tasklets to use new tasklet_setup() API
>>    net: ifb: convert tasklets to use new tasklet_setup() API
>>    net: ppp: convert tasklets to use new tasklet_setup() API
>>    net: cdc_ncm: convert tasklets to use new tasklet_setup() API
>>    net: hso: convert tasklets to use new tasklet_setup() API
>>    net: lan78xx: convert tasklets to use new tasklet_setup() API
>>    net: pegasus: convert tasklets to use new tasklet_setup() API
>>    net: r8152: convert tasklets to use new tasklet_setup() API
>>    net: rtl8150: convert tasklets to use new tasklet_setup() API
>>    net: usbnet: convert tasklets to use new tasklet_setup() API
>>
>>
> 
> You are only converting drivers which are passing the taskelt struct as
> data ptr, most of other drivers are passing the container of the
> tasklet as data, why not convert them as well, and let them use
> container_of to find their data ? it is really straight forward and
> will help convert most of net driver if not all.
> 

from_tasklet uses container_of internally. use of container_of is 
avoided cause it end being really long.
