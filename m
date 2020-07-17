Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492E9224554
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgGQUsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgGQUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:48:11 -0400
X-Greylist: delayed 211 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Jul 2020 13:48:11 PDT
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900B9C0619D2;
        Fri, 17 Jul 2020 13:48:11 -0700 (PDT)
Received: from [2a04:4540:1402:e200:f4bc:edb0:b75b:df61]
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1jwXH3-0005wm-4o; Fri, 17 Jul 2020 22:48:05 +0200
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
 <b16a6e8d-0799-388c-b98c-fe6e14611d9f@gmail.com>
From:   John Crispin <john@phrozen.org>
Message-ID: <64bbedb0-d985-668e-fb50-ffefdf3050e4@phrozen.org>
Date:   Fri, 17 Jul 2020 22:48:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b16a6e8d-0799-388c-b98c-fe6e14611d9f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17.07.20 22:39, Florian Fainelli wrote:
>
> On 7/17/2020 1:29 PM, Matthew Hagan wrote:
>>
>> On 16/07/2020 23:09, Jakub Kicinski wrote:
>>> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
>>>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
>>>>
>>>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>>>> ---
>>>>   Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>>>>   1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> index ccbc6d89325d..3d34c4f2e891 100644
>>>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> @@ -13,6 +13,14 @@ Optional properties:
>>>>   
>>>>   - reset-gpios: GPIO to be used to reset the whole device
>>>>   
>>>> +Optional MAC configuration properties:
>>>> +
>>>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
>>> Perhaps we can say a little more here?
>>>
>>  From John's patch:
>> "The switch allows us to swap the internal wirering of the two cpu ports.
>> For the HW offloading to work the ethernet MAC conencting to the LAN
>> ports must be wired to cpu port 0. There is HW in the wild that does not
>> fulfill this requirement. On these boards we need to swap the cpu ports."
>>
>> This option is somewhat linked to instances where both MAC0 and MAC6 are
>> used as CPU ports. I may omit this for now since support for this hasn't
>> been added and MAC0 is hard-coded as the CPU port. The initial intention
>> here was to cover options commonly set by OpenWrt devices, based upon
>> their ar8327-initvals, to allow migration to qca8k.
> If you update the description of the property, I do not see a reason why
> this should not be supported as of today, sooner or later you will need
> it to convert more devices to qca8k as you say.

correct, there will be patches soonish to make qcom dakota and 
hawkeye/cypress use qca8k as their switch fabric is 95% identical.  we 
already started working on it. it is mmio based rather than mdio based, 
so the patch is quite a large rework right now.

     John

