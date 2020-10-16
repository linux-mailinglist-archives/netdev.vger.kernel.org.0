Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC52906BC
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408460AbgJPOAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:00:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59758 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408452AbgJPOAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 10:00:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTQHc-001zYk-OT; Fri, 16 Oct 2020 16:00:36 +0200
Date:   Fri, 16 Oct 2020 16:00:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: don't pad a cloned sk_buff
Message-ID: <20201016140036.GC456889@lunn.ch>
References: <20201016073527.5087-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016073527.5087-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 09:35:27AM +0200, Christian Eggers wrote:
> If the supplied sk_buff is cloned (e.g. in dsa_skb_tx_timestamp()),
> __skb_put_padto() will allocate a new sk_buff with size = skb->len +
> padlen. So the condition just tested for (skb_tailroom(skb) >= padlen +
> len) is not fulfilled anymore. Although the real size will usually be
> larger than skb->len + padlen (due to alignment), there is no guarantee
> that the required memory for the tail tag will be available
> 
> Instead of letting __skb_put_padto allocate a new (too small) sk_buff,
> lets take the already existing path and allocate a new sk_buff ourself
> (with sufficient size).

Hi Christian

What is not clear to me is why not change the __skb_put_padto() call
to pass the correct length?

   Andrew
