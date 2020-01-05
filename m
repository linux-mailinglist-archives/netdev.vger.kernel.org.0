Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D1F130A3C
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgAEWZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:25:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40622 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:25:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE89C1573FC06;
        Sun,  5 Jan 2020 14:25:31 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:25:31 -0800 (PST)
Message-Id: <20200105.142531.1912385676087452153.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, alobakin@dlink.ru,
        rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        vivien.didelot@gmail.com, hauke@hauke-m.de,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        sean.wang@mediatek.com, matthias.bgg@gmail.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com, sdf@google.com,
        daniel@iogearbox.net, songliubraving@fb.com, ppenkov@google.com,
        mcroce@redhat.com, jakub@cloudflare.com, edumazet@google.com,
        paulb@mellanox.com, komachi.yoshiki@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next] net: dsa: Remove indirect function call for
 flow dissection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102233657.12933-1-f.fainelli@gmail.com>
References: <20200102233657.12933-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:25:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  2 Jan 2020 15:36:53 -0800

> We only need "static" information to be given for DSA flow dissection,
> so replace the expensive call to .flow_dissect() with an integer giving
> us the offset into the packet array of bytes that we must de-reference
> to obtain the protocol number. The overhead was alreayd available from
> the dsa_device_ops structure so use that directly.
> 
> The presence of a flow_dissect callback used to indicate that the DSA
> tagger supported returning that information,we now encode this with a
> proto_off value of DSA_PROTO_OFF_UNPSEC if the tagger does not support
> providing that information yet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes since RFC:
> 
> - use a constant instead of the "magic" -1
> - update all tag drivers and build test correctly

At the very least the typos need to be fixed, so marking this changes
requested in patchwork just FYI...
