Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AE7539D02
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349829AbiFAGKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349824AbiFAGKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:10:17 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B2350E01;
        Tue, 31 May 2022 23:10:16 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2516A4ZQ079034;
        Wed, 1 Jun 2022 01:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654063805;
        bh=X2lnrRO9o6cSNn26M09xwDW9Isoaa0xelVPjfV/VnZA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=rT9etXCAKTQnrKzlByExPMYtPVYd2Q1iPJcEAr3fqahSG6tr3MlLf/rU5OqTvkHg9
         ezvLEXzarCdjv9+j3Zv+ONTYUSZ71Hm+Pe+ztxITiInIMzbtmgBmujllJYYnsTKqnX
         HhN/2Vz2G/OhubSeVDVrhqXq/fRXoP3J3U2CO114=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2516A48h022179
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jun 2022 01:10:04 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 1
 Jun 2022 01:10:04 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 1 Jun 2022 01:10:04 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 25169w8b130862;
        Wed, 1 Jun 2022 01:09:59 -0500
Message-ID: <9f531f8d-9ff2-2ec9-504f-eed324ba86c6@ti.com>
Date:   Wed, 1 Jun 2022 11:39:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 3/3] net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext()
 to correct location
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-4-s-vadapalli@ti.com>
 <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 31/05/22 17:25, Russell King (Oracle) wrote:
> On Tue, May 31, 2022 at 05:00:58PM +0530, Siddharth Vadapalli wrote:
>> In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
>> as a QSGMII main or QSGMII-SUB port. This configuration is performed
>> by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.
>>
>> It is necessary for the QSGMII main port to be configured before any of
>> the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
>> interfaces come up before the QSGMII main port is configured.
>>
>> Fix this by moving the call to phy_set_mode_ext() from
>> am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
>> thereby ensuring that the QSGMII main port is configured before any of
>> the QSGMII-SUB ports are brought up.
> 
> This sounds like "if we're configured via port->slave.phy_if to be in
> QSGMII mode, then the serdes PHY needs to be configured before any of
> the QSGMII ports are used". Doesn't that mean that if
> port->slave.phy_if is QSGMII, then the port _only_ supports QSGMII
> mode, and conversely, the port doesn't support QSGMII unless firmware
> said it could be.
> 
> So, doesn't that mean am65_cpsw_nuss_init_port_ndev() should indicate
> only QSGMII, or only the RGMII modes, but never both together?

The phy-gmii-sel driver called by phy_set_mode_ext() configures the CPSW5G MAC
rather than the SerDes Phy. In the CPSW5G MAC, the QSGMII mode is further split
up as two modes that are TI SoC specific, namely QSGMII main and QSGMII-SUB. Of
the 4 ports present in CPSW5G (4 external ports), only one can be the main port
while the rest are the QSGMII-SUB ports. Only the QSGMII main interface is
responsible for auto-negotiation between the MAC and PHY. For this reason, the
writes to the CPSW5G MAC, mentioning which of the interfaces is the QSGMII main
interface and which ones are the QSGMII-SUB interfaces has to be done before any
of the interfaces are brought up. Otherwise, it would result in a QSGMII-SUB
interface being brought up before the QSGMII main interface is determined,
resulting in the failure of auto-negotiation process, thereby making the
QSGMII-SUB interfaces non-functional.

Thanks,
Siddharth.
