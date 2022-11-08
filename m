Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB966210F6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKHMjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiKHMjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:39:22 -0500
X-Greylist: delayed 1013 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 04:39:21 PST
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0671BDF0D;
        Tue,  8 Nov 2022 04:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fgQwEkH8uRLIyzAJvAaLR6EdvjROWR71Np+0VG6O3UU=; b=nitwdRgJEnOLhDL6edIbrobgDb
        JT1qJTkHeOn2LIW+8O7bbLc0R4C827LiB7LNjnFFaqhkG25Ag252h700DcaYB87k4zAUV0UUeZhxV
        87CpusS+NrxvVOQNIOjRMe0QYVpHoWEgHjm1dbbAod4TT1UiIZ+YY/8pY9kyQkl0+5Nk=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osNcQ-000VU5-Uc; Tue, 08 Nov 2022 13:22:19 +0100
Message-ID: <6b38ec27-65a3-c973-c5e1-a25bbe4f6104@nbd.name>
Date:   Tue, 8 Nov 2022 13:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107093950.74de3fa1@pc-8.home>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
In-Reply-To: <20221107093950.74de3fa1@pc-8.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.11.22 09:39, Maxime Chevallier wrote:
>> On Fri,  4 Nov 2022 18:41:49 +0100 Maxime Chevallier wrote:
>> > This tagging protocol is designed for the situation where the link
>> > between the MAC and the Switch is designed such that the Destination
>> > Port, which is usually embedded in some part of the Ethernet
>> > Header, is sent out-of-band, and isn't present at all in the
>> > Ethernet frame.
>> > 
>> > This can happen when the MAC and Switch are tightly integrated on an
>> > SoC, as is the case with the Qualcomm IPQ4019 for example, where
>> > the DSA tag is inserted directly into the DMA descriptors. In that
>> > case, the MAC driver is responsible for sending the tag to the
>> > switch using the out-of-band medium. To do so, the MAC driver needs
>> > to have the information of the destination port for that skb.
>> > 
>> > Add a new tagging protocol based on SKB extensions to convey the
>> > information about the destination port to the MAC driver  
>> 
>> This is what METADATA_HW_PORT_MUX is for, you shouldn't have 
>> to allocate a piece of memory for every single packet.
> 
> Does this work with DSA ? The information conveyed in the extension is
> the DSA port identifier. I'm not familiar at all with
> METADATA_HW_PORT_MUX, should we extend that mechanism to convey the
> DSA port id ?
> 
> I also agree that allocating data isn't the best way to go, but from
> the history of this series, we've tried 3 approaches so far :
> 
>   - Adding a new field to struct sk_buff, which isn't a good idea
>   - Using the skb headroom, but then we can't know for sure is the skb
>     contains a DSA tag or not
>   - Using skb extensions, that comes with the cost of this memory
>     allocation. Is this approach also incorrect then ?
FYI, I'm currently working on hardware DSA untagging on the mediatek
mtk_eth_soc driver. On this hardware, I definitely need to keep the
custom DSA tag driver, as hardware untagging is not always available.
For the receive side, I came up with this patch (still untested) for
using METADATA_HW_PORT_MUX.
It has the advantage of being able to skip the tag protocol rcv ops
call for offload-enabled packets.

Maybe for the transmit side we could have some kind of netdev feature
or capability that indicates offload support and allows skipping the
tag xmit function as well.
In that case, ipqess could simply use a no-op tag driver.

What do you think?

---
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -972,11 +972,13 @@ bool __skb_flow_dissect(const struct net *net,
  		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
  			     skb->protocol == htons(ETH_P_XDSA))) {
  			const struct dsa_device_ops *ops;
+			struct metadata_dst *md_dst = skb_metadata_dst(skb);
  			int offset = 0;
  
  			ops = skb->dev->dsa_ptr->tag_ops;
  			/* Only DSA header taggers break flow dissection */
-			if (ops->needed_headroom) {
+			if (ops->needed_headroom &&
+			    (!md_dst || md_dst->type != METADATA_HW_PORT_MUX)) {
  				if (ops->flow_dissect)
  					ops->flow_dissect(skb, &proto, &offset);
  				else
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -11,6 +11,7 @@
  #include <linux/netdevice.h>
  #include <linux/sysfs.h>
  #include <linux/ptp_classify.h>
+#include <net/dst_metadata.h>
  
  #include "dsa_priv.h"
  
@@ -216,6 +217,7 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
  static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
  			  struct packet_type *pt, struct net_device *unused)
  {
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
  	struct dsa_port *cpu_dp = dev->dsa_ptr;
  	struct sk_buff *nskb = NULL;
  	struct dsa_slave_priv *p;
@@ -229,7 +231,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
  	if (!skb)
  		return 0;
  
-	nskb = cpu_dp->rcv(skb, dev);
+	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
+		unsigned int port = md_dst->u.port_info.port_id;
+
+		dsa_default_offload_fwd_mark(skb);
+		skb_dst_set(skb, NULL);
+		if (!skb_has_extensions(skb))
+			skb->slow_gro = 0;
+
+		skb->dev = dsa_master_find_slave(dev, 0, port);
+		if (skb->dev)
+			nskb = skb;
+	} else {
+		nskb = cpu_dp->rcv(skb, dev);
+	}
+
  	if (!nskb) {
  		kfree_skb(skb);
  		return 0;

