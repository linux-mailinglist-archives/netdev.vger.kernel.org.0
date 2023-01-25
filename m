Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC3F67B32C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbjAYNWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:22:13 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDE217CCE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:22:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674652919; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AGoYk3etkO4cuy8S4RiFouyGuAPbd39eaJS6eywEljesqdLkYQO4Z9tbyiQNwr/35MV3VihSfie+nSqbV+aD1u3Ujq7IW9BsCYFYk0K89JD4TaSfTNHpoon8iQcZRvA57MGOxzoEEBrnU38Sp6MAiX1QfRyz5PtDJt8QjPl/KIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674652919; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=HkDVGi7gGAemgOA58Nd0zaHHgq3WoFabIpZM/UfrNLw=; 
        b=LrjwudL7VhzHexojMvIZL0WzmSG8n77KuH7muJDRgqMfbzI9MwYjhCg0EVVTzkAtIBs9JT4XYuNvpJ/CkNnheBnVW4//GQKJV/OZgoVPnniu/2YWbuWXY6+2My4WlKTWgq2dXC1ZRteL7UPVXiC8r1gtiTGWnykKJctkoO8ASTw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674652919;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=HkDVGi7gGAemgOA58Nd0zaHHgq3WoFabIpZM/UfrNLw=;
        b=F/reRanBIOck4K3atS2iYhgqFXYvk7Ojg6vC6GksOC1Qs2avyMIDKnTOwu3bIZL5
        E6gCcrwKxNmhVgtOdPkSIQ8v0Ks6pyl15ikhphQIwA1b554SfMMnA/Byf4+x2um1e6X
        OyMWmg67NzCxZqOiIuDuyg+DCg/vU2TlMvFYBZ+c=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674652916456642.2864765495663; Wed, 25 Jan 2023 05:21:56 -0800 (PST)
Message-ID: <6249fc14-b38a-c770-36b4-5af6d41c21d3@arinc9.com>
Date:   Wed, 25 Jan 2023 16:21:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: gmac1 issues with mtk_eth_soc & port 5 issues with MT7530 DSA
 driver
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     netdev <netdev@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
 <4583dd1b-707b-2ccd-33ed-36d376b989e5@arinc9.com>
Content-Language: en-US
In-Reply-To: <4583dd1b-707b-2ccd-33ed-36d376b989e5@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.01.2023 19:19, Arınç ÜNAL wrote:
> After testing stuff out, I've got things to share on these issues.
> 
> All of this is tested on the current net-next/main on GB-PC2 and Unielec 
> U7621-06.
> 
> On 13.09.2022 15:54, Arınç ÜNAL wrote:
>> I'd like to post a few more issues I stumbled upon on mtk_eth_soc and 
>> MT7530 DSA drivers. All of this is tested on vanilla 6.0-rc5 on GB-PC2.
>>
>> ## MT7621 Ethernet gmac1 won’t work when gmac1 is used as DSA master 
>> for MT7530 switch
>>
>> There’s recently been changes on the MT7530 DSA driver by Frank to 
>> support using port 5 as a CPU port.
>>
>> The MT7530 switch’s port 5 is wired to the MT7621 SoC’s gmac1.
>>
>> Master eth1 and slave interfaces initialise fine. Packets are sent out 
>> from eth1 fine but won't be received on eth1.
>>
>> This issue existed before Lorenzo’s changes on 6.0-rc1.
>>
>> I’m not sure if this is an issue with mtk_eth_soc or the MT7530 DSA 
>> driver.
> 
> Traffic from CPU goes out through DSA slave fine. Traffic from DSA slave 
> to CPU reaches, RX bytes go up on eth1, but nothing on tcpdump.
> 
> Recently, I tried this on a Bananapi BPI-R2 (MT7623NI SoC). Everything 
> works fine after setting up eth0, `ip l set up eth0`. It still works 
> after setting down eth0. This makes me believe that, on mtk_eth_soc.c, 
> there is code for opening the first MAC, which is actually needed to 
> make communication work on all MACs. It should be moved to a more 
> generic location where the code will run even when the first MAC is not 
> being used.
> 
> After fiddling with the MediaTek ethernet driver, I found out that gmac1 
> works only when hardware special tag parsing is disabled. This is the 
> case for the MT7621A and MT7623NI SoCs.
> 
> With Felix's commit 2d7605a729062bb554f03c5983d8cfb8c0b42e9c ("net: 
> ethernet: mtk_eth_soc: enable hardware DSA untagging"), hardware special 
> tag parsing is disabled only when at least one MAC does not use DSA.
> 
> If someone could give me code to test where this function is disabled 
> for these two SoCs, I'd appreciate it.
> 
> Currently this works:
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c 
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 801deac58bf7..3c462179dcf6 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3241,6 +3241,7 @@ static int mtk_open(struct net_device *dev)
>   {
>       struct mtk_mac *mac = netdev_priv(dev);
>       struct mtk_eth *eth = mac->hw;
> +    u32 val;
>       int i, err;
> 
>       if (mtk_uses_dsa(dev) && !eth->prog) {
> @@ -3258,15 +3259,15 @@ static int mtk_open(struct net_device *dev)
>               md_dst->u.port_info.port_id = i;
>               eth->dsa_meta[i] = md_dst;
>           }
> -    } else {
> -        /* Hardware special tag parsing needs to be disabled if at least
> -         * one MAC does not use DSA.
> -         */
> -        u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> -        val &= ~MTK_CDMP_STAG_EN;
> -        mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
>       }
> 
> +    /* Hardware special tag parsing needs to be disabled if at least
> +     * one MAC does not use DSA.
> +     */
> +    val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> +    val &= ~MTK_CDMP_STAG_EN;
> +    mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
> +
>       err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
>       if (err) {
>           netdev_err(dev, "%s: could not attach PHY: %d\n", __func__,

I've done some more tests and I'm confident this is caused by Felix's 
commit which enables hardware DSA untagging.

According to my tests on MT7621AT and MT7623NI SoCs, hardware DSA 
untagging is not supported on the second GMAC.

So I've got to disable this feature when the second gmac of MT7621 or 
MT7623 SoCs is enabled.

The MTK_GMAC1_TRGMII capability is only on the MT7621 and MT7623 SoCs 
which I see this problem on. I'm new to coding so I took an educated 
guess from the use of MTK_NETSYS_V2 to disable this feature altogether 
for MT7986 SoC.

I believe this check does it perfectly well. I tested it on both SoCs 
along with some debug info on different DTs.
- Only gmac0 as dsa master
- gmac0 & gmac1 as dsa master
- Only gmac1 as dsa master
- gmac0 as dsa master & gmac1 as non-dsa

if ((mtk_uses_dsa(dev) && !eth->prog) && !(mac->id == 1 && 
MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC1_TRGMII)))

Initially, I wanted to disable this feature on MT7621 and MT7623 SoCs 
altogether but there's no reason to do this with the check above.

As a last note, I would appreciate it if new features are only enabled 
on SoCs which were thoroughly tested.

Arınç
