Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0B3169B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfEaV16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:27:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaV15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:27:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C9F31500FF4D;
        Fri, 31 May 2019 14:27:57 -0700 (PDT)
Date:   Fri, 31 May 2019 14:27:56 -0700 (PDT)
Message-Id: <20190531.142756.672384459952948359.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: dsa: sja1105: Don't store frame type in
 skb->cb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529215126.13129-1-olteanv@gmail.com>
References: <20190529215126.13129-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:27:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 30 May 2019 00:51:26 +0300

> Due to a confusion I thought that eth_type_trans() was called by the
> network stack whereas it can actually be called by network drivers to
> figure out the skb protocol and next packet_type handlers.
> 
> In light of the above, it is not safe to store the frame type from the
> DSA tagger's .filter callback (first entry point on RX path), since GRO
> is yet to be invoked on the received traffic.  Hence it is very likely
> that the skb->cb will actually get overwritten between eth_type_trans()
> and the actual DSA packet_type handler.
> 
> Of course, what this patch fixes is the actual overwriting of the
> SJA1105_SKB_CB(skb)->type field from the GRO layer, which made all
> frames be seen as SJA1105_FRAME_TYPE_NORMAL (0).
> 
> Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
