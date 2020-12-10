Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751EE2D514A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgLJDZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbgLJDYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:24:54 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF2C0613CF;
        Wed,  9 Dec 2020 19:24:14 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6F6CD4D259C1A;
        Wed,  9 Dec 2020 19:23:52 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:23:51 -0800 (PST)
Message-Id: <20201209.192351.1592604556832105313.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net-next v2] net: hdlc_x25: Remove unnecessary
 skb_reset_network_header calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209014013.4996-1-xie.he.0141@gmail.com>
References: <20201209014013.4996-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:23:52 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Tue,  8 Dec 2020 17:40:13 -0800

> 1. In x25_xmit, skb_reset_network_header is not necessary before we call
> lapb_data_request. The lapb module doesn't need skb->network_header.
> So there is no need to set skb->network_header before calling
> lapb_data_request.
> 
> 2. In x25_data_indication (called by the lapb module after some data
> have been received), skb_reset_network_header is not necessary before we
> call netif_rx. After we call netif_rx, the code in net/core/dev.c will
> call skb_reset_network_header before handing the skb to upper layers
> (in __netif_receive_skb_core, called by __netif_receive_skb_one_core,
> called by __netif_receive_skb, called by process_backlog). So we don't
> need to call skb_reset_network_header by ourselves.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks.
