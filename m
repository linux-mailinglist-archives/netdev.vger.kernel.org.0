Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264315B97A4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIOJlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIOJlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:41:00 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C383F32;
        Thu, 15 Sep 2022 02:40:59 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F9eVKj034547;
        Thu, 15 Sep 2022 04:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663234831;
        bh=9aFTZ8l8M7d4xqHqpevjI9HHFDEIb1JlWEjXqpc9pcE=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=ij/7a3AeR0VS55Ui1SQ7yxTIPeJJDLPdo5X0wKZHaykFRpeYjvsbbXx0sGzmZn1cZ
         OXgaqkC05ZnKQMtfJ9CHnJMv8xxypmZ3wEy5IeO4FaEZdHMY6E7WS0LEf2ag/mhZFc
         ia8av3u/66c4Lw+hcLsUlzvreN8UTCw8lllmBTrs=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F9eV4M009231
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 04:40:31 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 04:40:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 04:40:31 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F9eQPZ011593;
        Thu, 15 Sep 2022 04:40:26 -0500
Message-ID: <70bade48-278e-2df7-48a9-bd7780cdd025@ti.com>
Date:   Thu, 15 Sep 2022 15:10:25 +0530
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
Subject: Re: [PATCH 6/8] net: ethernet: ti: am65-cpsw: Add support for SGMII
 mode for J7200 CPSW5G
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-7-s-vadapalli@ti.com>
 <YyH7qTZL9Pv1DJdB@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyH7qTZL9Pv1DJdB@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 14/09/22 21:34, Russell King (Oracle) wrote:
> On Wed, Sep 14, 2022 at 03:20:51PM +0530, Siddharth Vadapalli wrote:
>> +#define MAC2MAC_MR_ADV_ABILITY_BASE		(BIT(15) | BIT(0))
>> +#define MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX	BIT(12)
>> +#define MAC2MAC_MR_ADV_ABILITY_1G		BIT(11)
>> +#define MAC2MAC_MR_ADV_ABILITY_100M		BIT(10)
>> +#define MAC2PHY_MR_ADV_ABILITY			BIT(0)
> 
> In addition to my other comments, this looks like a reimplementation of
> the LPA_SGMII* constants found in include/uapi/linux/mii.h

I was not aware of this. Thank you for letting me know. I will use the
existing constants in the v2 series.

Regards,
Siddharth.
