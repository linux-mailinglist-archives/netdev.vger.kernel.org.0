Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A193539CF3
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349753AbiFAGGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243583AbiFAGGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:06:16 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1BD6FA35;
        Tue, 31 May 2022 23:06:15 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 25165rQB028781;
        Wed, 1 Jun 2022 01:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654063553;
        bh=o58GPHpSfMrNtcPoXLXC45PlGOEAXm5Hicr+kbxgAAM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=Ge5DDgxyRVQVPW/13G2xotnhrnAFpALyt0RhGLZpTCnORTzUxL6jvtf26farqri00
         PWWU4UQNGw/1Md9vGHFcMMu/my5whJn228sYkb5xfPG9XIgy4WvhIgUsyn8piZGlaY
         QNYvJ99ZZfxysJTZ1qJoql+ujN2fNZwBKZU6jguY=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 25165rnp010401
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jun 2022 01:05:53 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 1
 Jun 2022 01:05:53 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 1 Jun 2022 01:05:53 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 25165hef032372;
        Wed, 1 Jun 2022 01:05:45 -0500
Message-ID: <670b070f-ed0c-a1e0-1a3c-875ee36ca134@ti.com>
Date:   Wed, 1 Jun 2022 11:35:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/3] net: ethernet: ti: am65-cpsw: Add support for QSGMII
 mode
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
 <20220531113058.23708-3-s-vadapalli@ti.com>
 <YpYBBp8Io116bBwM@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YpYBBp8Io116bBwM@shell.armlinux.org.uk>
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

On 31/05/22 17:20, Russell King (Oracle) wrote:
> On Tue, May 31, 2022 at 05:00:57PM +0530, Siddharth Vadapalli wrote:
>>  static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
>>  				      const struct phylink_link_state *state)
>>  {
>> -	/* Currently not used */
>> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
>> +							  phylink_config);
>> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>> +
>> +	if (state->interface == PHY_INTERFACE_MODE_QSGMII)
>> +		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>> +		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
> 
> What about writing this register when the interface mode isn't QSGMII?

In TI's J7200 device, there are two CPSW MACs namely CPSW2G and CPSW5G. While
CPSW5G supports QSGMII mode, CPSW2G does not. The same am65-cpsw-nuss driver is
used to control both CPSW2G and CPSW5G. Thus, the am65_cpsw_nuss_mac_config()
function is called for both CPSW2G and CPSW5G MACs. The SGMII CONTROL Register
is only present for CPSW5G. Thus, the write should only be performed for QSGMII
mode which is supported only by CPSW5G.

Functionally, always writing to the register even if the mode is not QSGMII does
not cause any problems, as long as it is CPSW5G MAC that is being used.

Thinking about it again, I will add a compatible to differentiate CPSW2G ports
from CPSW5G ports in order to make it cleaner, so that the register can always
be written to if the CPSW5G ports are used, irrespective of the interface mode.

Thanks,
Siddharth.
