Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA3235E6C
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfFENzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:55:32 -0400
Received: from mx-relay06-hz1.antispameurope.com ([94.100.132.206]:40612 "EHLO
        mx-relay06-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbfFENzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:55:32 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay06-hz1.antispameurope.com;
 Wed, 05 Jun 2019 15:55:13 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 5 Jun
 2019 15:54:40 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
Date:   Wed, 5 Jun 2019 15:54:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605133102.GF19627@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay06-hz1.antispameurope.com with 63E0410C4DD
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:2.436
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Here is my device tree
>>
>> mdio { 
>>                 #address-cells = <1>;
>>                 #size-cells = <0>;
>>
>>                 switch0: switch0@0 {
>>                         compatible = "marvell,mv88e6085";
>>                         reg = <0x0>;
>>                         pinctrl-0 = <&lcd_d06_pins>;
>>                         reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
>>
>>                         dsa,member = <0 0>;
>>
>>                         ports {
>>                                 #address-cells = <1>;
>>                                 #size-cells = <0>;
>>
>>                                 port@0 {
>> /* Changed reg to 0xc too, same error message */
>>                                         reg = <0x0>;
>>                                         label = "Serdes0";
>>                                         phy-handle = <&switch0phy0>;
>>                                 };
>>
>>                                 port@1 {
>> /* Changed reg to 0xd too, same error message */
>>                                         reg = <0x1>;
>>                                         label = "Serdes1";
>>                                         phy-handle = <&switch0phy1>;
>>                                 };
>> 				
>> 				port@2 {
>>                                         reg = <0x2>;
>>                                         label = "lan1";
>>                                         phy-handle = <&switch0phy2>;
>>                                 };
>>
>>                                 port@3 {
>>                                         reg = <0x3>;
>>                                         label = "lan2";
>>                                         phy-handle = <&switch0phy3>;
>>                                 };
>>
>>                                 port@4 {
>>                                         reg = <0x4>;
>>                                         label = "lan3";
>>                                         phy-handle = <&switch0phy4>;
>>                                 };
> You don't need to list phy-handle for the internal PHYs. It should
> just find them.
>
>>                         mdio {
>>                                 #address-cells = <1>;
>>                                 #size-cells = <0>;
>>                                 switch0phy0: switch0phy0@0 {
>> /* Changed reg to 0 too, same error message */
>> 					 reg = <0xc>;
>>                                 };
>>                                 switch0phy1: switch0phy1@1 {
>> /* Changed reg to 1 too, same error message */
>>                                         reg = <0xd>;
>>                                 };
>>                                 switch0phy3: switch0phy3@3 {
>>                                         reg = <0x3>;
>>                                 };
>>                                 switch0phy4: switch0phy4@4 {
>>                                         reg = <0x4>;
>>                                 };
>>                         };
>>
>>                         mdio1 {
>> 				compatible = "marvell,mv88e6xxx-mdio-external";
>>                                 #address-cells = <1>;
>>                                 #size-cells = <0>;
>>
>>                                 switch0phy2: switch0phy2@2 {
>>                                         reg = <0x2>;
>>                                 };
>>                                 switch0phy6: switch0phy6@6 {
>>                                         reg = <0x6>;
>>                                 };
>>                         };
> I doubt this second mdio bus is correct. The 6390 uses that, but i
> don't think any other family does. The older generations have one MDIO
> bus for both internal and external PHYs.
>
> One other idea. Take a look at the data sheet. Can the MDIO pins also
> be used for GPIO? Do they default to GPIO or MDIO? For the 6390 they
> default to GPIO and there is code to reconfigure them for MDIO.
>
> 	Andrew

Hi Andrew,

okay, thanks so far. I'll look into the code. The GPIO configuration is 
a good point. I remember that we did something there (Normal SMI bit).

I removed all phy-handle for the internal ports and in the mdio part 
is only port 2 and 6 by now. But the Serdes ports are still not be
recognized. So maybe there is still something wrong?

Benjamin

