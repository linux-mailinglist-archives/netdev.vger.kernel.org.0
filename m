Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D265281A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfFYJap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:30:45 -0400
Received: from mx.0dd.nl ([5.2.79.48]:36794 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbfFYJap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 05:30:45 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id A93FD5FE8C;
        Tue, 25 Jun 2019 11:30:42 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="NjNPM79I";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 6B12D1CC959E;
        Tue, 25 Jun 2019 11:30:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 6B12D1CC959E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561455042;
        bh=Kf/dqJQS2EZRpdjzpHIdn9ywyvRtAEGJy1GooxfGZgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjNPM79Ia0xC+1OVgxBhpAQnzMvBYW2UuY05ryg1hqtdqGxBVCi7Kiw1+g0Gwyecz
         LTZhINi6UqyrQCzzM84X6oO8nEaz63Kj6QNi5iOmxYDunIN7mxjJ80ftsTJROO7ogW
         N/HuAXdgteDMyhjNt+VVpQ3t8PPIKSy7V6lCWN68Zd+tD+DWJ+AN0mWAdyRfrQY571
         Iqn1fYKOoKfyXXevNueMZEYf+MOs2/2Ue/3qxsZ3WWDg5x2+KhbSbWNk19U698oNWq
         QadjIuXhNcN4oLo+mCMhe9fZRUeug1CulqNSQ9O+Hw+cRYxUocHOipR1XuGDSzhBwk
         SUC5XMyO+hd1Q==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 25 Jun 2019 09:30:42 +0000
Date:   Tue, 25 Jun 2019 09:30:42 +0000
Message-ID: <20190625093042.Horde._8BNPFSzW6B9-CI8P6akHTh@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     sean.wang@mediatek.com, linux@armlinux.org.uk, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] dt-bindings: net: dsa: mt7530: Add
 mediatek,ephy-handle to isolate ext. phy
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-5-opensource@vdorst.com>
 <e6175753-eb99-63e5-767e-f82becbf8d1a@gmail.com>
In-Reply-To: <e6175753-eb99-63e5-767e-f82becbf8d1a@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Florian Fainelli <f.fainelli@gmail.com>:

Hi Florian

> On 6/24/19 7:52 AM, René van Dorst wrote:
>> On some platforum the external phy can only interface to the port 5 of the
>> switch because the RGMII TX and RX lines are swapped. But it still can be
>> useful to use the internal phy of the switch to act as a WAN port which
>> connectes to the 2nd GMAC. This gives WAN port dedicated bandwidth to
>> the SOC. This increases the LAN and WAN routing.
>>
>> By adding the optional property mediatek,ephy-handle, the external phy
>> is put in isolation mode when internal phy is connected to 2nd GMAC via
>> phy-handle property.
>
> Most platforms we have seen so far implement this logic with a mdio-mux,
> can you see if that is possible here? stmmac has plenty of examples like
> those.

May I don't understand it correctly, but all the devices are on the same MDIO
bus.
I tried to make a ASCII diagram to make it a bit more clear.

  +-------------------+                     
+----------------------------------------------+
  | SOC MT7621/3      |                    | MT7530 SWITCH              
                    |
  |   +-------------+ |(T)RGMII BUS        |  +-------------+    
INTERNAL                  |
  |   |  1st GMAC   <------------------------->  PORT 6     |   MII  
BUS  +----------+     |
  |   +-------------+ |                    |  +-------------+      
+------>  GMAC5   |     |
  |                   |                    |                      |     
   +----------+     |
  |   +-------------+ | RGMII BUS          |  +-------------+     |     
                    |
  |   |  2nd GMAC   <------------------+------>  PORT 5     +-----+     
   +----------+     |
  |   +-------------+ |                |   |  +-------------+      
+------>  PHY P0  +<--+ |
  |                   |                |   |                      |     
   +----------+   | |
  |   +-------------+ |  MDIO BUS      |   |                      |     
                  | |
  |   |  MDIO       +--------+         |   |                      |     
   +----------+   | |
  |   +-------------+ |      |         |   |                       
+------>  PHY P4  +<--+ |
  |                   |      |         |   |                            
   +----------+   | |
  +-------------------+      |         |    
+--------------------------------------------|-+
                             |         |       +-------------+          
                  |
                             |         |       |  EXTERNAL   |          
                  |
                             |         +------->  PHY AT8033 | SGMII  
BUS +----------+   |
                             |                 |              
+-----------> SFP CAGE |   |
                             +---------------->+             |          
   +----------+   |
                             |                 |             |          
                  |
                             |                 +-------------+          
                  |
                              
+----------------------------------------------------------+

I don't see why I need a MDIO mux. Devices; 2nd GMAC, external phy and port 5
share the same RGMII bus. Depending on the port 5 mux settings, port 5  
is acting
as a GMAC of PHY of port 0/4. As long as the unused devices doesn't drive the
RGMII bus we are good.

2nd GMAC RGMII control is currently set with a pinctrl "RGMII2".
Port 5 and external phy are done in mt7530_port5_setup() depending on the
device-tree.

Greats,

René

> --
> Florian



