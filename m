Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5887563CF0E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 07:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiK3GAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 01:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiK3GAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 01:00:13 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795B1408C;
        Tue, 29 Nov 2022 22:00:09 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2AU5xkF1081064;
        Tue, 29 Nov 2022 23:59:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669787986;
        bh=78rsLXykjczu6kP5J3eoU0JCxXRmcnETH8Wn4USwCPs=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=shlqltwAusJ80dlMn6ozaJgacCsfvHbOfppFHnSPyu7Xlg/9w+IZtqSvdfapizO3w
         ZxGa89EgNKCu79qQDUVsJOe3v+yUMFj1bZWCY46KXYZWOU9i6OcZ+rK5yF9qKGNIOY
         hp+u+CoAdx+2oGa/XxtL696rOss5u24AUozOb4jY=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2AU5xk6A008147
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Nov 2022 23:59:46 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 29
 Nov 2022 23:59:45 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 29 Nov 2022 23:59:45 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2AU5xfef030346;
        Tue, 29 Nov 2022 23:59:42 -0600
Message-ID: <56cc4929-5c15-0345-4d7c-2dbc5d40fbee@ti.com>
Date:   Wed, 30 Nov 2022 11:29:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <spatton@ti.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix RGMII configuration
 at SPEED_10
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20221129050639.111142-1-s-vadapalli@ti.com>
 <CALs4sv29ZdyK-k0d9_FrRPd_v_6GrC_NU_dYnU5rLWmYxVM2Zg@mail.gmail.com>
 <20221129164619.mq3b4y4cxj2vvl24@skbuf>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20221129164619.mq3b4y4cxj2vvl24@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 29/11/22 22:16, Vladimir Oltean wrote:
> On Tue, Nov 29, 2022 at 11:16:42AM +0530, Pavan Chebbi wrote:
>> Looks like this patch should be directed to net-next?
> 
> Do you know more about what CPSW_SL_CTL_EXT_EN does, exactly? I'm not
> able to assess the impact of the bug being fixed. What doesn't work?
> Maybe Siddharth could put more focus on that.

The CPSW_SL_CTL_EXT_EN bit is used to control in-band mode v/s forced
mode of operation. Setting the bit selects in-band mode while clearing
it selects forced mode. Thus, if the bit isn't set for certain variants
of RGMII mode, then those variants of RGMII mode will not work in
in-band mode of operation.

Please refer to the patch at [1] which corresponds to the commit being
fixed. That patch intended to convert the existing driver to utilize the
PHYLINK framework. In that process, the following line:
if (phy->speed == 10 && phy_interface_is_rgmii(phy))
was removed from the am65_cpsw_nuss_adjust_link() function and added in
the am65_cpsw_nuss_mac_link_up() function in the same patch as:
if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
instead of:
if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))

Due to the above, the already existing support for in-band mode of
operation for all RGMII mode variants was accidentally changed to
support for in-band mode of operation for just the
PHY_INTERFACE_MODE_RGMII variant.

[1]
https://patchwork.kernel.org/project/netdevbpf/patch/20220309075944.32166-1-s-vadapalli@ti.com/

Regards,
Siddharth.
