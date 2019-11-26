Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B42A10A648
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKZWB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:01:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZWB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:01:56 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0866514D3D4D1;
        Tue, 26 Nov 2019 14:01:55 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:01:55 -0800 (PST)
Message-Id: <20191126.140155.381506426353243938.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH] net: mscc: ocelot: fix potential issues accessing skbs
 list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126104403.46717-1-yangbo.lu@nxp.com>
References: <20191126104403.46717-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 14:01:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Tue, 26 Nov 2019 18:44:03 +0800

> Fix two prtential issues accessing skbs list.
> - Protect skbs list in case of competing for accessing.
> - Break the matching loop when find the matching skb to
>   avoid consuming more skbs incorrectly. The ID is only
>   from 0 to 3, but the FIFO supports 128 timestamps at most.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Seriously, use skb_queue_head and associated helpers, we have
all of the infrastructure and arrangements for this.
