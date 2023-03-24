Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048916C7D80
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjCXLwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCXLwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:52:33 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2462332C
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 04:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gvt5DL6fQG6Plq4wISGGK/VENRuOiPuD8pNsuXpIl+8=; b=sA6C8V9ZJy8Cw9Z97ezmTW/sgH
        NmTBPFOw0MRkJwOOUGXbDPQwA30CKckbI6PcIeCyNvuKIx0mRkXcwDEK8oteS0mO0ThDPfvvgX6UQ
        r99XB6VGPJQ90DCglcNMxZp0AMUiaZxKkcT9xz/I4Hl407hR2wR6MiR18BcYBvTU2r4U=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pffxq-006LMe-2v; Fri, 24 Mar 2023 12:52:10 +0100
Message-ID: <4462a0c2-f7ea-c81c-e12f-ec629113fc40@nbd.name>
Date:   Fri, 24 Mar 2023 12:52:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Aw: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s
 since 6.2-rc1
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16>
 <4a229d53-f058-115a-afc6-dd544a0dedf2@nbd.name>
 <ZBBs/xE0+ULtJNIJ@makrotopia.org>
 <trinity-b2506855-d27f-4e5c-bd20-d3768fa7505d-1679077409691@3c-app-gmx-bap25>
 <trinity-e199fc72-77d9-47f3-acb6-e11fbf66360b-1679144877213@3c-app-gmx-bs63>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-e199fc72-77d9-47f3-acb6-e11fbf66360b-1679144877213@3c-app-gmx-bs63>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.23 14:07, Frank Wunderlich wrote:
>> Gesendet: Freitag, 17. März 2023 um 19:23 Uhr
>> Von: "Frank Wunderlich" <frank-w@public-files.de>
>> An: "Daniel Golle" <daniel@makrotopia.org>
>> Cc: "Felix Fietkau" <nbd@nbd.name>, "Mark Lee" <Mark-MC.Lee@mediatek.com>, "Sean Wang" <sean.wang@mediatek.com>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg@gmail.com>, "John Crispin" <john@phrozen.org>, "AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
>> Betreff: Aw: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s since 6.2-rc1
>>
>> Hi,
>> > Gesendet: Dienstag, 14. März 2023 um 13:47 Uhr
>> > Von: "Daniel Golle" <daniel@makrotopia.org>
>> > An: "Felix Fietkau" <nbd@nbd.name>
>> > Cc: "Frank Wunderlich" <frank-w@public-files.de>, "Mark Lee" <Mark-MC.Lee@mediatek.com>, "Sean Wang" <sean.wang@mediatek.com>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg@gmail.com>, "John Crispin" <john@phrozen.org>, "AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
>> > Betreff: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s since 6.2-rc1
>> >
>> > Hi Felix,
>> > 
>> > On Tue, Mar 14, 2023 at 11:30:53AM +0100, Felix Fietkau wrote:
>> > > On 07.03.23 19:32, Frank Wunderlich wrote:
>> > > > Hi,
>> > > > 
>> > > > i've noticed that beginning on 6.2-rc1 the throughput on my Bananapi-R2 and Bananapi-R3 goes from 940Mbit/s down do 620Mbit/s since 6.2-rc1.
>> > > > Only TX (from SBC PoV) is affected, RX is still 940Mbit/s.
>> > > > 
>> > > > i bisected this to this commit:
>> > > > 
>> > > > f63959c7eec3151c30a2ee0d351827b62e742dcb ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
>> > > > 
>> > > > Daniel reported me that this is known so far and they need assistance from MTK and i should report it officially.
>> > > > 
>> > > > As far as i understand it the commit should fix problems with clients using non-GBE speeds (10/100 Mbit/s) on the Gbit-capable dsa
>> > > > interfaces (mt753x connected) behind the mac, but now the Gigabit speed is no more reached.
>> > > > I see no CRC/dropped packets, retransmitts or similar.
>> > > > 
>> > > > after reverting the commit above i get 940Mbit like in rx direction, but this will introduce the problems mentioned above so this not a complete fix.
>> > > I don't have a BPI-R2, but I tested on BPI-R3 and can't reproduce this
>> > > issue. Do you see it on all ports, or only on specific ones?
>> > 
>> > I also can't reproduce this if unsing any of the gigE ports wired via
>> > MT7531 on the R3. However, I can reproduce the issue if using a 1 GBit/s
>> > SFP module in slot SFP1 of the R3 (connected directly to GMAC2/eth1).
>> > 
>> > Users have reported this also to be a problem also on MT7622 on devices
>> > directly connecting a PHY (and not using MT7531).
>> > 
>> > In all cases, reverting the commit above fixes the issue.
>> 
>> 
>> made quick test with 6.3-rc1 on r3 without reverting the patch above and can confirm daniels test
>> 
>> it seems the problem is no more on switch-ports, but on eth1 i have massive packet loss...seems this caused by the same patch because i tested with reverted version and have no issue there.
> 
> on BPI-R2 the eth0/gmac0 (tested with wan-port) is affected. here i have in TX-Direction only 620Mbit.
> 
> I have no idea yet why there the gmac0 is affected and on r3 only gmac1.
> 
> But it looks differently...on r3 the gmac1 is nearly completely broken.
Please try this patch and let me know if it resolves the regression:

---
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -718,8 +718,6 @@ static void mtk_mac_link_up(struct phyli
  		break;
  	}
  
-	mtk_set_queue_speed(mac->hw, mac->id, speed);
-
  	/* Configure duplex */
  	if (duplex == DUPLEX_FULL)
  		mcr |= MAC_MCR_FORCE_DPX;


