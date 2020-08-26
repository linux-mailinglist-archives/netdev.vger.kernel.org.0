Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E3252F2E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgHZNBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:01:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56552 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730098AbgHZNBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:01:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07QD183l079544;
        Wed, 26 Aug 2020 08:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598446868;
        bh=fSnhnNxPqIWbIxTmir4oQNv+5CcHdFvM0yNxIQ/wC0w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=on00NybfZK9gGkv2AsBLjXUF6owzFRP1dYQzYVnEF5bLzz/JJSMHAhrV6ak7VzmdD
         KM13P6EzqaroGbAoTtt0/SuJA7CivYXqmzel21tf48vVEVnaNfmZY3BlI1zx2g8VP9
         cdbq0ZcRVsjxBSo+KuMxgH6sHMoYlJ9g6oelE42o=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07QD17P7113730
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 08:01:07 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 26
 Aug 2020 08:01:07 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 26 Aug 2020 08:01:07 -0500
Received: from [10.250.68.181] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07QD17nT047205;
        Wed, 26 Aug 2020 08:01:07 -0500
Subject: Re: [PATCH] net: dp83869: Fix RGMII internal delay configuration
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Daniel Gorsulowski <daniel.gorsulowski@esd.eu>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
References: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
 <20200825133750.GQ2588906@lunn.ch>
 <b2c665e7-9566-6767-6ee3-39219a1bd4a3@ti.com>
 <20200826125859.GQ2403519@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <aa4b2078-2adf-02a9-094d-bb9695f13cf0@ti.com>
Date:   Wed, 26 Aug 2020 08:01:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200826125859.GQ2403519@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 8/26/20 7:58 AM, Andrew Lunn wrote:
> On Tue, Aug 25, 2020 at 02:57:35PM -0500, Dan Murphy wrote:
>> Andrew
>>
>> On 8/25/20 8:37 AM, Andrew Lunn wrote:
>>> On Tue, Aug 25, 2020 at 02:07:21PM +0200, Daniel Gorsulowski wrote:
>>>> The RGMII control register at 0x32 indicates the states for the bits
>>>> RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
>>>>
>>>>     RGMII Transmit/Receive Clock Delay
>>>>       0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
>>>>       0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
>>>>
>>>> This commit fixes the inversed behavior of these bits
>>>>
>>>> Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
>>> I Daniel
>>>
>>> I would like to see some sort of response from Dan Murphy about this.
>> Daniel had sent this privately to me and I encouraged him to send it in for
>> review.
>>
>> Unfortunately he did not cc me on the patch he sent to the list.
> You should be able to reply to this email with a Reviewed-by: and
> patchwork will do the right thing.

Yep.  I gave my ack on v2 of the patch set

Dan

>
> 	  Andrew
