Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A367935EDB8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 08:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349376AbhDNGua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 02:50:30 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:45990 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbhDNGu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 02:50:28 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13E6nopT097466;
        Wed, 14 Apr 2021 01:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618382990;
        bh=7cU4D04kdyILGRVSuThWUQaMOQqDRIEfWPmylp2Mimk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=TkCt8oYzhmi/2AzqPsmlu89Y6ETx+rlasl/2DF/qR5gVqRtBRRqfxzr7yg0EfBgZ3
         U9cpaq+7Fw5W/zyrXLDLiBD2XDOLj9W06c+iTCCaQ+Jt3fQIFm4FH2W8i56bLn6iWC
         xixX7Pq56mhw5sksre/jPjqRSJ0nvlxduMR2qpwI=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13E6noWE035897
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Apr 2021 01:49:50 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 14
 Apr 2021 01:49:50 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 14 Apr 2021 01:49:50 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13E6niiC127386;
        Wed, 14 Apr 2021 01:49:45 -0500
Subject: Re: [PATCH 3/4] dt-bindings: net: can: Document transceiver
 implementation as phy
To:     Rob Herring <robh@kernel.org>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-4-a-govindraju@ti.com>
 <20210412175134.GA4109207@robh.at.kernel.org>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <e1c2b752-5a2b-e973-c188-5916d8a2e31f@ti.com>
Date:   Wed, 14 Apr 2021 12:19:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210412175134.GA4109207@robh.at.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 12/04/21 11:21 pm, Rob Herring wrote:
> On Fri, Apr 09, 2021 at 07:10:53PM +0530, Aswath Govindraju wrote:
>> From: Faiz Abbas <faiz_abbas@ti.com>
>>
>> Some transceivers need a configuration step (for example, pulling the
>> standby or enable lines) for them to start sending messages. The
>> transceiver can be implemented as a phy with the configuration done in the
>> phy driver. The bit rate limitation can the be obtained by the driver using
>> the phy node.
>>
>> Document the above implementation in the bosch mcan bindings
>>
>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>> ---
>>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> index 798fa5fb7bb2..2c01899b1a3e 100644
>> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> @@ -109,6 +109,12 @@ properties:
>>    can-transceiver:
>>      $ref: can-transceiver.yaml#
>>  
>> +  phys:
>> +    minItems: 1
> 
> maxItems: 1

Will add this in the respin.

> 
>> +
>> +  phy-names:
>> +    const: can_transceiver
> 
> Kind of a pointless name. You don't really need a name if there's a 
> single entry.
> 

This name used by devm_phy_optional_get() in m_can driver to get the phy
data structure.

Thank you for the review.

Regards,
Aswath

>> +
>>  required:
>>    - compatible
>>    - reg
>> -- 
>> 2.17.1
>>

