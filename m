Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2827253A61
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHZWvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgHZWvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:51:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A06C061574;
        Wed, 26 Aug 2020 15:51:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 492F8128F6DFA;
        Wed, 26 Aug 2020 15:34:30 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:51:16 -0700 (PDT)
Message-Id: <20200826.155116.1238002224655277772.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Set network_header
 before transmitting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826030353.75645-1-xie.he.0141@gmail.com>
References: <20200826030353.75645-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:34:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Tue, 25 Aug 2020 20:03:53 -0700

> Set the skb's network_header before it is passed to the underlying
> Ethernet device for transmission.
> 
> This patch fixes the following issue:
> 
> When we use this driver with AF_PACKET sockets, there would be error
> messages of:
>    protocol 0805 is buggy, dev (Ethernet interface name)
> printed in the system "dmesg" log.
> 
> This is because skbs passed down to the Ethernet device for transmission
> don't have their network_header properly set, and the dev_queue_xmit_nit
> function in net/core/dev.c complains about this.
> 
> Reason of setting the network_header to this place (at the end of the
> Ethernet header, and at the beginning of the Ethernet payload):
> 
> Because when this driver receives an skb from the Ethernet device, the
> network_header is also set at this place.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
