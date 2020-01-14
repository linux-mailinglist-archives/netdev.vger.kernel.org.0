Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9113B294
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgANTFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:05:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:05:42 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E36071523E3CB;
        Tue, 14 Jan 2020 11:05:40 -0800 (PST)
Date:   Tue, 14 Jan 2020 11:05:40 -0800 (PST)
Message-Id: <20200114.110540.167706052695553298.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pfrenard@gmail.com,
        stefan.wahren@i2se.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: usb: lan78xx: limit size of local TSO packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200113172711.122918-1-edumazet@google.com>
References: <20200113172711.122918-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 11:05:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 Jan 2020 09:27:11 -0800

> lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
> bytes in the aggregated packets it builds, but does
> nothing to prevent large GSO packets being submitted.
> 
> Pierre-Francois reported various hangs when/if TSO is enabled.
> 
> For localy generated packets, we can use netif_set_gso_max_size()
> to limit the size of TSO packets.
> 
> Note that forwarded packets could still hit the issue,
> so a complete fix might require implementing .ndo_features_check
> for this driver, forcing a software segmentation if the size
> of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.
> 
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>

Applied and queued up for -stable, thanks Eric.
