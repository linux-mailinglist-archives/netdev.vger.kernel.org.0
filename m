Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEB367813C
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjAWQUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbjAWQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:20:00 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1BE3B3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:19:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674490783; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=oCx8e8W+grbdOeMJC9L149R8JibaiSbpAY0d509tkW4zmURuG/OX55j/vI+dwOylg+BJ+IiQNIAWaiZA5jeXheTHtvV342UPNIWjRBq9pH3lF1A3g+YBw/R/4W2PGomj+7gTlawKi5+ZaEkt2M7z4g9UHIP8sruqLVo6Z4dR9Es=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674490783; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zzEVfypFruRZxe6qb11Nu8zD2LS8z5PrPX/LqgoMW6U=; 
        b=MesHTE881v1guHwqQ26qdwlo0AL9FH8kD3M64LxYCorY0T1UylvutBAjZ5YcaPMX1mRlRLtZ+Ra735/4fFu1ps29Grxr/PcPPizILb8BZUost0IzvzqhIMQqRnL0d/isKnx7ngcVyX701FWxWMxRCXtqo9yTyQQg6uX2qE5yS0k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674490783;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=zzEVfypFruRZxe6qb11Nu8zD2LS8z5PrPX/LqgoMW6U=;
        b=P1OSTv2mAQie3JpnvDENX8UvyGfGUjKKavqp97f6MMMDTt2wLZsI5RVjF89qtsM6
        OEI0traryHgKBh35EpUBO4paomJcJ5ZZgvSH57+FHo2bP91SRxI3G0OCAJZ+xTol0jw
        Ke9HzBYfdIwg72zIuiuHtTZL3lQemOqeLdEnqhk4=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674490774962177.10149079846167; Mon, 23 Jan 2023 08:19:34 -0800 (PST)
Message-ID: <4583dd1b-707b-2ccd-33ed-36d376b989e5@arinc9.com>
Date:   Mon, 23 Jan 2023 19:19:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: gmac1 issues with mtk_eth_soc & port 5 issues with MT7530 DSA
 driver
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     netdev <netdev@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
In-Reply-To: <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After testing stuff out, I've got things to share on these issues.

All of this is tested on the current net-next/main on GB-PC2 and Unielec 
U7621-06.

On 13.09.2022 15:54, Arınç ÜNAL wrote:
> I'd like to post a few more issues I stumbled upon on mtk_eth_soc and 
> MT7530 DSA drivers. All of this is tested on vanilla 6.0-rc5 on GB-PC2.
> 
> ## MT7621 Ethernet gmac1 won’t work when gmac1 is used as DSA master for 
> MT7530 switch
> 
> There’s recently been changes on the MT7530 DSA driver by Frank to 
> support using port 5 as a CPU port.
> 
> The MT7530 switch’s port 5 is wired to the MT7621 SoC’s gmac1.
> 
> Master eth1 and slave interfaces initialise fine. Packets are sent out 
> from eth1 fine but won't be received on eth1.
> 
> This issue existed before Lorenzo’s changes on 6.0-rc1.
> 
> I’m not sure if this is an issue with mtk_eth_soc or the MT7530 DSA driver.

Traffic from CPU goes out through DSA slave fine. Traffic from DSA slave 
to CPU reaches, RX bytes go up on eth1, but nothing on tcpdump.

Recently, I tried this on a Bananapi BPI-R2 (MT7623NI SoC). Everything 
works fine after setting up eth0, `ip l set up eth0`. It still works 
after setting down eth0. This makes me believe that, on mtk_eth_soc.c, 
there is code for opening the first MAC, which is actually needed to 
make communication work on all MACs. It should be moved to a more 
generic location where the code will run even when the first MAC is not 
being used.

After fiddling with the MediaTek ethernet driver, I found out that gmac1 
works only when hardware special tag parsing is disabled. This is the 
case for the MT7621A and MT7623NI SoCs.

With Felix's commit 2d7605a729062bb554f03c5983d8cfb8c0b42e9c ("net: 
ethernet: mtk_eth_soc: enable hardware DSA untagging"), hardware special 
tag parsing is disabled only when at least one MAC does not use DSA.

If someone could give me code to test where this function is disabled 
for these two SoCs, I'd appreciate it.

Currently this works:

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c 
b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 801deac58bf7..3c462179dcf6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3241,6 +3241,7 @@ static int mtk_open(struct net_device *dev)
  {
  	struct mtk_mac *mac = netdev_priv(dev);
  	struct mtk_eth *eth = mac->hw;
+	u32 val;
  	int i, err;

  	if (mtk_uses_dsa(dev) && !eth->prog) {
@@ -3258,15 +3259,15 @@ static int mtk_open(struct net_device *dev)
  			md_dst->u.port_info.port_id = i;
  			eth->dsa_meta[i] = md_dst;
  		}
-	} else {
-		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA.
-		 */
-		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
-		val &= ~MTK_CDMP_STAG_EN;
-		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
  	}

+	/* Hardware special tag parsing needs to be disabled if at least
+	 * one MAC does not use DSA.
+	 */
+	val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+	val &= ~MTK_CDMP_STAG_EN;
+	mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
+
  	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
  	if (err) {
  		netdev_err(dev, "%s: could not attach PHY: %d\n", __func__,

---

ChatGPT Remarks

Since I'm very slowly learning C, I had ChatGPT help with a compilation 
warning. And answer a question that neither DuckDuckGo or Google could 
answer.

Me:

> What is CDMP Ingress Control

ChatGPT:

> CDMP (Control Data Media Processor) Ingress Control is a feature of MediaTek Ethernet controllers that allows for the manipulation of the incoming data traffic before it is processed by the CPU.
> 
> It includes a set of rules and filters that can be applied to the incoming data traffic to selectively forward, drop, or redirect it to different queues. The CDMP Ingress Control feature is used to improve the performance and security of the Ethernet controller by allowing for the efficient handling of large amounts of data traffic.
> 
> For example, it can be used to prioritize certain types of traffic, such as voice or video, over others, or to drop unwanted traffic, such as spam or malicious packets. The CDMP Ingress Control feature also includes a set of statistics counters that allow for monitoring of the traffic and performance of the Ethernet controller.

Me:

> Could you make this warning go away by fixing the code below?
> 
> drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function ‘mtk_open’:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c:3266:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
>  3266 |  u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
>       |  ^~~
> 
> The code:
> 	u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> 	val &= ~MTK_CDMP_STAG_EN;
> 	mtk_w32(eth, val, MTK_CDMP_IG_CTRL);

ChatGPT:

> To fix the warning, the declaration of the variable "val" should be moved before any statements or expressions.
> 
> Here's how the code should look:
> 
> u32 val;
> val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
> val &= ~MTK_CDMP_STAG_EN;
> mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
> 
> By moving the declaration of the variable before any statements or expressions, the C90 standard is no longer violated.
> 
> It's worth noting that it's often a good practice to initialize variables at the point of declaration, this way you can make sure the variable is always initialized before it's used.

Me:

> It didn't work, now I get this error:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function ‘mtk_open’:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c:3266:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
>  3266 |  u32 val;
>       |  ^~~

ChatGPT:

> It looks like the error message you're seeing is related to the location of the variable declaration within the function. It appears that the variable "val" is being declared within a block of code that has statements or expressions before it, which is what is causing the "ISO C90 forbids mixed declarations and code" warning.
> 
> One way to fix this issue would be to move the variable declaration to the beginning of the function, before any statements or expressions.
> 
> You can also move the variable declaration to the top of the file, as a global variable.
> 
> Another way would be to make sure that the variable is declared before any statements or expressions in the block of code.
> 
> It's also possible that you're missing some header files or the variable definition is not correct. I would recommend checking that the variable definition is correct and that the correct header files are included in the code.
> 
> Please also note that you can also try to change your compile flag to a later standard (C99, C11) if they are available and supported by your compiler, this way you can avoid this warning.

This is ridiculous. I wonder if it could read the Linux kernel 
repository and fix/optimise code, dt-bindings, etc.
This thing could fix DT warnings accordingly with documentation much 
much much faster than a human can.

> 
> ---
> 
> ## MT7530 sends malformed packets to/from CPU at port 5 when port 6 is 
> not defined on devicetree
> 
> In this case, I can see eth1 receiving traffic as the receive counter on 
> ifconfig goes up with the ARP packets sent to the mt7621 CPU.
> 
> I see the mt7621 CPU not responding to the ARP packets (no malformed 
> packets or anything), which likely means ARP packets received on the 
> mt7621 CPU side are also malformed.
> 
> I think this confirms that the above issue is related to the MT7530 DSA 
> driver as I can see eth1 receiving traffic in this case.
> 
> Packet capture of the malformed packets are in the attachments.

This issue is still there for MT7621A but not MT7623NI. But now that the 
issue above is fixed (and I figured out how to boot vanilla Linux kernel 
with buildroot filesystem so I can include tcpdump with the image), I 
can see the malformed frames on the DSA master interface too.

> 
> ---
> 
> ## MT7621 Ethernet gmac1 won’t work when gmac0 is not defined on devicetree
> 
> eth0 interface is initalised even though it’s not defined on the 
> devicetree, eth1 interface is not created at all.
> 
> This is likely not related to the MT7530 DSA driver.

This is not an issue. gmac1 is named eth0 since gmac0 is not enabled. 
Opening network interfaces from MACs are named in arithmetic order.

Arınç
