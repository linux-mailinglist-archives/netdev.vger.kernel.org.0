Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33B753A451
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352818AbiFALsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiFALsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:48:04 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59321A394;
        Wed,  1 Jun 2022 04:48:02 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 251BlQg6125756;
        Wed, 1 Jun 2022 06:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654084046;
        bh=Rnm7X2DBSI6XtsSy2/7nA/I9r/eUjb6iINN70jWdMCo=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=O+P0FuiV0inSOjxVvphfzlpR9GT1NDNbLGC5TUA+TkonHC3AXakxKG2HVmp9APK0B
         p3v/9S/XFnp51ab1TAFh/DvHJc5r8E06v2VBC3OZGoGehtkeSnT59bGrLoYqNgUhPd
         yO1u1EvVAd3nO1vCnlvuW7lDo5Gu8SRe8qqgX83I=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 251BlQan031626
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jun 2022 06:47:26 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 1
 Jun 2022 06:47:26 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 1 Jun 2022 06:47:25 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 251BlKWM121446;
        Wed, 1 Jun 2022 06:47:21 -0500
Message-ID: <b4921687-3bf1-4b35-3eb5-d022b9949574@ti.com>
Date:   Wed, 1 Jun 2022 17:17:19 +0530
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
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-4-s-vadapalli@ti.com>
 <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
 <9f531f8d-9ff2-2ec9-504f-eed324ba86c6@ti.com>
 <YpcjaOdXHC+uYJ2J@shell.armlinux.org.uk>
 <41277985-28c9-9bf0-8b24-6acc40391ef2@ti.com>
 <Ypc3myH2SgGwUmMF@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <Ypc3myH2SgGwUmMF@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 01/06/22 15:25, Russell King (Oracle) wrote:
> On Wed, Jun 01, 2022 at 02:59:47PM +0530, Siddharth Vadapalli wrote:
>> Hello Russell,
>>
>> On 01/06/22 13:59, Russell King (Oracle) wrote:
>>> On Wed, Jun 01, 2022 at 11:39:57AM +0530, Siddharth Vadapalli wrote:
>>>> Hello Russell,
>>>>
>>>> On 31/05/22 17:25, Russell King (Oracle) wrote:
>>>>> On Tue, May 31, 2022 at 05:00:58PM +0530, Siddharth Vadapalli wrote:
>>>>>> In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
>>>>>> as a QSGMII main or QSGMII-SUB port. This configuration is performed
>>>>>> by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.
>>>>>>
>>>>>> It is necessary for the QSGMII main port to be configured before any of
>>>>>> the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
>>>>>> interfaces come up before the QSGMII main port is configured.
>>>>>>
>>>>>> Fix this by moving the call to phy_set_mode_ext() from
>>>>>> am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
>>>>>> thereby ensuring that the QSGMII main port is configured before any of
>>>>>> the QSGMII-SUB ports are brought up.
>>>>>
>>>>> This sounds like "if we're configured via port->slave.phy_if to be in
>>>>> QSGMII mode, then the serdes PHY needs to be configured before any of
>>>>> the QSGMII ports are used". Doesn't that mean that if
>>>>> port->slave.phy_if is QSGMII, then the port _only_ supports QSGMII
>>>>> mode, and conversely, the port doesn't support QSGMII unless firmware
>>>>> said it could be.
>>>>>
>>>>> So, doesn't that mean am65_cpsw_nuss_init_port_ndev() should indicate
>>>>> only QSGMII, or only the RGMII modes, but never both together?
>>>>
>>>> The phy-gmii-sel driver called by phy_set_mode_ext() configures the CPSW5G MAC
>>>> rather than the SerDes Phy. In the CPSW5G MAC, the QSGMII mode is further split
>>>> up as two modes that are TI SoC specific, namely QSGMII main and QSGMII-SUB. Of
>>>> the 4 ports present in CPSW5G (4 external ports), only one can be the main port
>>>> while the rest are the QSGMII-SUB ports. Only the QSGMII main interface is
>>>> responsible for auto-negotiation between the MAC and PHY. For this reason, the
>>>> writes to the CPSW5G MAC, mentioning which of the interfaces is the QSGMII main
>>>> interface and which ones are the QSGMII-SUB interfaces has to be done before any
>>>> of the interfaces are brought up. Otherwise, it would result in a QSGMII-SUB
>>>> interface being brought up before the QSGMII main interface is determined,
>>>> resulting in the failure of auto-negotiation process, thereby making the
>>>> QSGMII-SUB interfaces non-functional.
>>>
>>> That confirms my suspicion - if an interface is in QSGMII mode, then
>>> RGMII should not be marked as a supported interface to phylink. If the
>>
>> CPSW5G MAC supports both RGMII and QSGMII modes, so wouldn't it be correct to
>> mark both RGMII and QSGMII modes as supported? The mode is specified in the
>> device-tree and configured in CPSW5G MAC accordingly.
>>
>>> "QSGMII main interface" were to be switched to RGMII mode, then this
>>> would break the other ports. So RGMII isn't supported if in QSGMII
>>> mode.
>>
>> Yes, if the QSGMII main interface were to be switched to RGMII mode, then it
>> would break the other ports. However, the am65-cpsw driver currently has no
>> provision to dynamically change the port modes once the driver is initialized.
> 
> If there is no provision to change the port mode, then as far as
> phylink is concerned, you should not advertise that it supports
> anything but the current mode - because if phylink were to request
> the driver change the mode, the driver can't do it.
> 
> So, you want there, at the very least:
> 
> 	if (phy_interface_mode_is_rgmii(port->slave.phy_if))
> 		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
> 	else
> 		__set_bit(PHY_INTERFACE_MODE_QSGMII, port->slave.phylink_config.supported_interfaces);
> 
> which will still ensure that port->slave.phy_if is either a RGMII
> mode or QSGMII.

Thank you for reviewing the patch. I will send v2 for this series implementing
the fix suggested above.

Thanks,
Siddharth.
