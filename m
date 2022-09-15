Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3895B96CA
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIOI7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIOI7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:59:39 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CE56357;
        Thu, 15 Sep 2022 01:59:34 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F8x8TW046686;
        Thu, 15 Sep 2022 03:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663232348;
        bh=40RIuyJ2v1HtbWXuDnlrnW8RPk37ZglF34ofD503bS4=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=e6bzabUStOo5T8yO8QyySkKPtyAhaLQOdu0IzNLPYPl6WThhdxkxO3CvyMuESRKUr
         HBgzIoe13+R+HH+bj5pDYLr3ycGz1gLDzQjQmEo0LBIcg4TrFB5pmJaGbCEG4Mpmjd
         is+d28/hY8zW1pv6W+daAhYeMAyZTQvDqSVEIE4E=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F8x7GY066923
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 03:59:07 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 03:59:07 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 03:59:06 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F8x1kZ032248;
        Thu, 15 Sep 2022 03:59:01 -0500
Message-ID: <1c3facf9-1ecf-f090-e800-803d83a89e4b@ti.com>
Date:   Thu, 15 Sep 2022 14:29:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
 <YyH2GcLCAN+9GAn8@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyH2GcLCAN+9GAn8@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 14/09/22 21:11, Russell King (Oracle) wrote:
> On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 72b1df12f320..1739c389af20 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1494,10 +1494,50 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>  							  phylink_config);
>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>>  	struct am65_cpsw_common *common = port->common;
>> +	struct fwnode_handle *fwnode;
>> +	bool fixed_link = false;
>>  
>>  	if (common->pdata.extra_modes & BIT(state->interface))
>>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
>> +
>> +	/* Detecting fixed-link */
>> +	fwnode = of_node_to_fwnode(port->slave.phy_node);
>> +	if (fwnode)
>> +		fixed_link = !!fwnode_get_named_child_node(fwnode, "fixed-link");
>> +
>> +	if (fixed_link) {
>> +		/* In fixed-link mode, mac_link_up is not invoked.
>> +		 * Therefore, the relevant mac_link_up operations
>> +		 * have to be moved to mac_config.
>> +		 */
> 
> This seems very wrong. Why is mac_link_up() not invoked? Have you
> debugged this? It works for other people.
> 
> Please debug rather than adding hacks to drivers when you find
> things that don't seem to work.

I will debug and find out. I had assumed that mac_link_up() is not
invoked in fixed-link mode. Thank you for clarifying.

Regards,
Siddharth.
