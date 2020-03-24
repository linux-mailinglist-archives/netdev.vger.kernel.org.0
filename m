Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6930191D66
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgCXXTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:19:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCXXTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:19:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 442EC159F477C;
        Tue, 24 Mar 2020 16:19:33 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:19:32 -0700 (PDT)
Message-Id: <20200324.161932.2119088651104512505.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: tag_8021q: replace
 dsa_8021q_remove_header with __skb_vlan_pop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324094534.29769-1-olteanv@gmail.com>
References: <20200324094534.29769-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:19:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 24 Mar 2020 11:45:34 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Not only did this wheel did not need reinventing, but there is also
> an issue with it: It doesn't remove the VLAN header in a way that
> preserves the L2 payload checksum when that is being provided by the DSA
> master hw.  It should recalculate checksum both for the push, before
> removing the header, and for the pull afterwards. But the current
> implementation is quite dizzying, with pulls followed immediately
> afterwards by pushes, the memmove is done before the push, etc.  This
> makes a DSA master with RX checksumming offload to print stack traces
> with the infamous 'hw csum failure' message.
> 
> So remove the dsa_8021q_remove_header function and replace it with
> something that actually works with inet checksumming.
> 
> Fixes: d461933638ae ("net: dsa: tag_8021q: Create helper function for removing VLAN header")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable.
