Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D4282DF7
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgJDWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJDWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 18:10:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACBAC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 15:10:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42CE612782CBC;
        Sun,  4 Oct 2020 14:53:29 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:10:16 -0700 (PDT)
Message-Id: <20201004.151016.247027928254011553.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, martin.varghese@nokia.com,
        dcaratti@redhat.com
Subject: Re: [PATCH net] net/core: check length before updating Ethertype
 in skb_mpls_{push,pop}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
References: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:53:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Fri, 2 Oct 2020 21:53:08 +0200

> Openvswitch allows to drop a packet's Ethernet header, therefore
> skb_mpls_push() and skb_mpls_pop() might be called with ethernet=true
> and mac_len=0. In that case the pointer passed to skb_mod_eth_type()
> doesn't point to an Ethernet header and the new Ethertype is written at
> unexpected locations.
> 
> Fix this by verifying that mac_len is big enough to contain an Ethernet
> header.
> 
> Fixes: fa4e0f8855fc ("net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable, thanks.
