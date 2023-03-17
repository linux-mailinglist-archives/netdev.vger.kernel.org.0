Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A026BE1F6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCQHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQHfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:35:45 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E3876A8;
        Fri, 17 Mar 2023 00:35:43 -0700 (PDT)
Received: from maxwell ([109.42.112.148]) by mrelayeu.kundenserver.de
 (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis) id
 1MJn8J-1pxDxV14DR-00K6xA; Fri, 17 Mar 2023 08:28:28 +0100
References: <20230316095306.721255-1-jh@henneberg-systemdesign.com>
 <20230316131503.738933-1-jh@henneberg-systemdesign.com>
 <ZBOhy02DFBlnIQR1@shell.armlinux.org.uk>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net V2] net: stmmac: Fix for mismatched host/device DMA
 address width
Date:   Fri, 17 Mar 2023 08:22:57 +0100
In-reply-to: <ZBOhy02DFBlnIQR1@shell.armlinux.org.uk>
Message-ID: <87edpng7l9.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:5QIZD/zEoIlUl4J9g1YiRKLAvKnLDmfGku0rnPpP1GG1pOn9VFa
 gZ65HdQ0A+BnO6uOKrPi9+upVoPI97O/Vt5RPMeh+n9Yp7gDzxgJXLzIgNfbJoN0W+UT0+V
 g5vHPFtmWyMvG1ZqxHCzKb496+Q1ZfunoHrMGb8GRQla4ubIUed752mK8Q1uWvwhX6HNpJE
 Oo6tRW5cs3XaDQHjb2gzw==
UI-OutboundReport: notjunk:1;M01:P0:iO4irr/xORg=;fdACBsCyznXGQO24QIlMEjR+Ivb
 5M7ptgNSWPS3sCgBghotj4WccMMxp3AobAhwIPOJK82PtVl2AhAAy+9jHus5Hp1gK0mXJaHeT
 DAun+frkSqGnY4IpDOFezrIiJ5Z2vc25McOdt1/ez6MEgIUELG2PYgCdQITnqlS2ugZkI6AR0
 w7kno3PtcD6xT7sIz/yf1sNxQ2wFBL9SRugSWGMqhGErlM09TFUaEBRKBcukKXKK3Ajjinfex
 Daej7OhcHLiV7yqcBRZjJkK8X6ZiOIZw3772QxWfWFx4XhuhjtPRtxYwb0yIwYkV+sGjXVn5y
 5g2eavxAoD4kH4ablQPpLjeW35v80Syfx5hJzvnviOl4zIB+fwvFBCvmRNwQ7CP7n5/QZlNO/
 /sKrR+yaJ1P4yVakQj2l5zuvS/TOGL4ewa+CeCu2Nwn+b0x6VQSrrHckWIk19UV7Z65bTmnI6
 F9USa3Lp9CFymBTd53BJkj9HS4ftdneptcqqcBv1CIpvReUyINx6xo2QddxI7TP4rB8GJdFzY
 gNHuYxVxPMamnpaeUGNsOJDhaWkVSu1apUYgvOSLMmNnXUDoZ1R1IZ5UYJXKfnqjPAHY5G+QL
 UCyEQ4A1qeWWUEYTAg28xbIQFLCulxBuGimQHfCOt8iFQslglKr/254S3jCBoffiyu4VGxyAt
 e/OZkfN/LZPvu2Yq2aCWOSIrpzf7Ipb7TskrVH30TQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> On Thu, Mar 16, 2023 at 02:15:03PM +0100, Jochen Henneberg wrote:
>> Currently DMA address width is either read from a RO device register
>> or force set from the platform data. This breaks DMA when the host DMA
>> address width is <=32it but the device is >32bit.
>> 
>> Right now the driver may decide to use a 2nd DMA descriptor for
>> another buffer (happens in case of TSO xmit) assuming that 32bit
>> addressing is used due to platform configuration but the device will
>> still use both descriptor addresses as one address.
>> 
>> This can be observed with the Intel EHL platform driver that sets
>> 32bit for addr64 but the MAC reports 40bit. The TX queue gets stuck in
>> case of TCP with iptables NAT configuration on TSO packets.
>> 
>> The logic should be like this: Whatever we do on the host side (memory
>> allocation GFP flags) should happen with the host DMA width, whenever
>> we decide how to set addresses on the device registers we must use the
>> device DMA address width.
>> 
>> This patch renames the platform address width field from addr64 (term
>> used in device datasheet) to host_addr and uses this value exclusively
>> for host side operations while all chip operations consider the device
>> DMA width as read from the device register.
>> 
>> Fixes: 7cfc4486e7ea ("stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing")
>> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
>> ---
>> V2: Fixes from checkpatch.pl for commit message
>> 
>>  drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
>>  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  2 +-
>>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  4 +--
>>  .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |  2 +-
>>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 ++++++++++---------
>>  include/linux/stmmac.h                        |  2 +-
>>  6 files changed, 22 insertions(+), 19 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
>> index 6b5d96bced47..55a728b1b708 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
>> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
>> @@ -418,6 +418,7 @@ struct dma_features {
>>  	unsigned int frpbs;
>>  	unsigned int frpes;
>>  	unsigned int addr64;
>> +	unsigned int host_addr;
>
> Obvious question: is host_addr an address? From the above description it
> sounds like this is more of a host address width indicator.
>
> Maybe call these "dev_addr_width" and "host_addr_width" so it's clear
> what each of these are?

You are right. I chose the name because the original field was called
addr64 which follows the naming from the chip specification. I will
switch to host_dma_width which makes it more clear that it's a DMA
address width. For both the platform field as well as the driver's
private data.
