Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90CE62D7E8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiKQKVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKQKVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:21:48 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632FE4D5F3;
        Thu, 17 Nov 2022 02:21:47 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2AHALHI0061122;
        Thu, 17 Nov 2022 04:21:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1668680477;
        bh=1De6ZNKbg2j0x/QVoDCpW43TacEFtRXxzRB+E01qZxk=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=GIYOHL7lJ67CLhmmWaGmNCj7Gs5FEfQU44qLBl4hzkJ3DNjRShERXiVmFU7qV4ksr
         KuYcopfDU2Y4Jw3Z0X4JBCWXNRq26scaAwZwHk1Kx1AoEix7M628CjH2wBqdwJeUwJ
         9VNXV7N38acXTjC5WtGfBhybOPCUp3LGCvEajtVE=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2AHAGHBA113502
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Nov 2022 04:16:17 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 17
 Nov 2022 04:16:17 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 17 Nov 2022 04:16:17 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2AHAGBQT087369;
        Thu, 17 Nov 2022 04:16:11 -0600
Message-ID: <b27f69fb-dd93-c852-01e4-a6346c88e9b3@ti.com>
Date:   Thu, 17 Nov 2022 15:46:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v5 3/3] net: ethernet: ti: am65-cpsw: Add support
 for SERDES configuration
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>
References: <20221109042203.375042-1-s-vadapalli@ti.com>
 <20221109042203.375042-4-s-vadapalli@ti.com>
 <d5f0dea1b9ce5f8d2187875adb1d73e747e21916.camel@redhat.com>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <d5f0dea1b9ce5f8d2187875adb1d73e747e21916.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

On 10/11/22 18:36, Paolo Abeni wrote:
> hello,
> 
> On Wed, 2022-11-09 at 09:52 +0530, Siddharth Vadapalli wrote:
> [...]
> 
>> +static void am65_cpsw_disable_serdes_phy(struct am65_cpsw_common *common)
>> +{
>> +	struct device_node *node, *port_np;
>> +	struct device *dev = common->dev;
>> +	const char *name = "serdes-phy";
>> +	struct phy *phy;
>> +
>> +	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
>> +
>> +	for_each_child_of_node(node, port_np) {
>> +		phy = devm_of_phy_get(dev, port_np, name);
> 
> The above will try to allocate some memory and can fail. Even if the
> the following code will handle a NULL ptr, the phy will not be
> disabled.
> 
> I think it's better if you cache the serdes phy ptr in
> am65_cpsw_init_serdes_phy() and you use such reference here, without
> resorting to devm_of_phy_get().

Thank you for reviewing the patch. I plan on creating a new "struct
phy*" member named "serdes_phy" in the struct "am65_cpsw_slave_data"
defined in the file "am65-cpsw-nuss.h", and store the SerDes phy in this
member, during the execution of the am65_cpsw_init_serdes_phy()
function. Please let me know if I can proceed with this implementation.

Regards,
Siddharth.
