Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398994CE0BF
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiCDXMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiCDXM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:29 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E126B27C501
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 15:11:39 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id s8so4758419pfk.12
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 15:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=SAq4oWjjvdZbWTVq1aiQrmAuvBUdtAXb+D99MJM6dmw=;
        b=RcaRZFFmQQfmEu7baM/5lzrhnkBFvweO+LjHOLeifU4g5ZGpzoWskFie9iSBnk2WL4
         u8zP3QSCjPiYnxbR2Dnqzjvso7QkMXgj9y7h1DO6qthKh7G3adtnnuPXxN4+fiLvftAH
         byOV7exWsVaK+BJIF6I+YjQDPITdu2XIqgaUjCNkl6NGJOqKseJC1Vpz3tkFMXOD9shU
         tQHuv2vJma56zBLVJMM1ftlCCrWPVP3Ot1e3YQUeRKXH/PHbh8oCzQmf0aWtOqIvkWxq
         IXXICT7au4mqmYsFz/aXP0L1KJvoq75962oYAs3WFoffJF17sKD+yq6zgfdC/7PLi/xg
         A1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=SAq4oWjjvdZbWTVq1aiQrmAuvBUdtAXb+D99MJM6dmw=;
        b=yZy1tGn9KcYWVKwIousRTej1fiRhglEmbfdJkE/c87+DCLvMLdrBm8/UnsHW5lwHHp
         xH+xqLtbjV2MyJzX7Qyz7lpNXB4f3UEDyd5u0BPB+NerHwMyKwsQWKbRgIZwuYD16IUJ
         Gis4TcXcVrWlfkSAEH1dOYXZNMNOy8C4g8hiNo1Kuyc9GuJtEkbeoNEq9JhUG1TccAyg
         0vN8n6O++pbN6G/1OZA5GdwGSrNR9xme+rAHnX+O6ckBqfnhRjt+r76Y8n2nzAQ8T0s5
         K0LipblpkVbkb2T+HOr33M3r/OuurDwbhDEZDLj4po1UwBp6gPft/pSLCq6EO9aiHwYy
         ze8g==
X-Gm-Message-State: AOAM530ZUlpllScrNCXrOl5woCbseSIbAMMFkJhzER3owOAZs6I71dCz
        Mvqe3NgU5c0DBp0Q6CnykRzUZcOFpDxK4Q==
X-Google-Smtp-Source: ABdhPJykm0JfxRRDKKcPP/oJPmQCVWwKoTXtE3M2nxTKdEGMz3zQ5BAPx2VdgSnGjO1PioU8DIf+Yw==
X-Received: by 2002:a63:4403:0:b0:375:6d5b:5aa7 with SMTP id r3-20020a634403000000b003756d5b5aa7mr540871pga.269.1646435499282;
        Fri, 04 Mar 2022 15:11:39 -0800 (PST)
Received: from [10.169.5.185] ([38.142.1.26])
        by smtp.googlemail.com with ESMTPSA id q24-20020aa79618000000b004e0e89985eesm6542758pfg.156.2022.03.04.15.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 15:11:38 -0800 (PST)
Message-ID: <010ede54-eb81-73ed-53a4-2f8e762984b1@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Dimitrios Bouras <dimitrios.bouras@gmail.com>
Subject: Transparently receive IP over LLC/SNAP
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URI_DOTEDU autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,
I hope I've addressed this properly - please be gentle in guiding me if otherwise (it's my first).

Many thanks,
Dimitri

 From my commit message for the branch on GitHub:
------------------8<------------------8<------------------8<------------------8<------------------
Add Ethernet over LLC SNAP RX capability to eth.c

Practical use cases exist where being able to receive Ethernet packets encapsulated in LLC SNAP is 
useful, while at the same time encapsulating replies (transmitting back) in LLC SNAP is not 
required. Accordingly, this is not an attempt to add full-blown support for IP over LLC SNAP, only a 
"hack" that "just works" -- see Alan's comment on the the Linux-kernel list on this subject ("Linux 
supports LLC/SNAP and various things over it (IPX/Appletalk DDP etc) but not IP over it, as it's one 
of those standards bodies driven bogosities which nobody ever actually deployed" -- 
http://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html). It is worth noting, however, that the 
networking stack in all recent versions of MS Windows behaves in the exact same way (receives 
LLC/SNAP-encapsulated IP just fine but replies in plain IP), even though this doesn't appear to be 
documented anywhere.
------------------8<------------------8<------------------8<------------------8<------------------

The unified patch follows:

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ebcc812735a4..1df5446af922 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -15,23 +15,24 @@
  *		Alan Cox, <gw4pts@gw4pts.ampr.org>
  *
  * Fixes:
- *		Mr Linux	: Arp problems
- *		Alan Cox	: Generic queue tidyup (very tiny here)
- *		Alan Cox	: eth_header ntohs should be htons
- *		Alan Cox	: eth_rebuild_header missing an htons and
- *				  minor other things.
- *		Tegge		: Arp bug fixes.
- *		Florian		: Removed many unnecessary functions, code cleanup
- *				  and changes for new arp and skbuff.
- *		Alan Cox	: Redid header building to reflect new format.
- *		Alan Cox	: ARP only when compiled with CONFIG_INET
- *		Greg Page	: 802.2 and SNAP stuff.
- *		Alan Cox	: MAC layer pointers/new format.
- *		Paul Gortmaker	: eth_copy_and_sum shouldn't csum padding.
- *		Alan Cox	: Protect against forwarding explosions with
- *				  older network drivers and IFF_ALLMULTI.
- *	Christer Weinigel	: Better rebuild header message.
- *             Andrew Morton    : 26Feb01: kill ether_setup() - use netdev_boot_setup().
+ *		Mr Linux		: Arp problems
+ *		Alan Cox		: Generic queue tidyup (very tiny here)
+ *		Alan Cox		: eth_header ntohs should be htons
+ *		Alan Cox		: eth_rebuild_header missing an htons and
+ *					  minor other things.
+ *		Tegge			: Arp bug fixes.
+ *		Florian			: Removed many unnecessary functions, code cleanup
+ *					  and changes for new arp and skbuff.
+ *		Alan Cox		: Redid header building to reflect new format.
+ *		Alan Cox		: ARP only when compiled with CONFIG_INET
+ *		Greg Page		: 802.2 and SNAP stuff.
+ *		Alan Cox		: MAC layer pointers/new format.
+ *		Paul Gortmaker		: eth_copy_and_sum shouldn't csum padding.
+ *		Alan Cox		: Protect against forwarding explosions with
+ *					  older network drivers and IFF_ALLMULTI.
+ *		Christer Weinigel	: Better rebuild header message.
+ *		Andrew Morton		: 26Feb01: kill ether_setup() - use netdev_boot_setup().
+ *		Dimitrios Bouras	: May 2021: transparently receive Ethernet over LLC/SNAP.
  */
 #include <linux/module.h>
 #include <linux/types.h>
@@ -157,6 +158,7 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	unsigned short _service_access_point;
 	const unsigned short *sap;
 	const struct ethhdr *eth;
+	const unsigned char *esn;
 
 	skb->dev = dev;
 	skb_reset_mac_header(skb);
@@ -185,9 +187,32 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(netdev_uses_dsa(dev)))
 		return htons(ETH_P_XDSA);
 
+	/* The protocol field is > 0x0600 so this is an Ethernet frame */
 	if (likely(eth_proto_is_802_3(eth->h_proto)))
 		return eth->h_proto;
 
+	/* Check for Ethernet protocol packets encapsulated in LCC SNAP.
+	 * If found, de-encapsulate transparently and feed them upwards
+	 * as if they were received inside normal Ethernet frames.
+	 *
+	 *    6      6     2      1      1     1      5    0-1492 0-38    4
+	 * +------+-----+-----+------+------+-----+-------+------+-----+-----+
+	 * | Dest | Src | Len | DSAP | SSAP | CTL | Proto | Data | Pad | FCS |
+	 * |      |     |     |  xAA |  xAA | x03 |       |      |     |     |
+	 * +------+-----+-----+------+------+-----+-------+------+-----+-----+
+	 */
+	esn = skb->data;
+	if (esn[0] == 0xAA && esn[1] == 0xAA && esn[2] == 0x03 &&
+	    esn[3] == 0x00 && esn[4] == 0x00 && esn[5] == 0x00) {
+		/* pull LLC header (3 bytes) and protocol ID (5 bytes) */
+		/* then recalculate the FCS checksum. After the call, */
+		/* skb->data will be pointing to the IP protocol payload */
+		skb_pull_rcsum(skb, 8);
+		/* pretend that this is an Ethernet frame by returning */
+		/* the encapsulated prototol code (2 LSBytes of Proto) */
+		return *(__be16 *)(esn + 6);
+	}
+
 	/*
 	 *      This is a magic hack to spot IPX packets. Older Novell breaks
 	 *      the protocol design and runs IPX over 802.3 without an 802.2 LLC
