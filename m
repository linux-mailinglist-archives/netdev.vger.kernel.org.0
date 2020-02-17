Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD616091C
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:41:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:41:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79649157A5E93;
        Sun, 16 Feb 2020 19:41:30 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:41:30 -0800 (PST)
Message-Id: <20200216.194130.1790846276699458141.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V2 1/3] net: ks8851-ml: Remove 8-bit bus accessors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215165419.3901611-1-marex@denx.de>
References: <20200215165419.3901611-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:41:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sat, 15 Feb 2020 17:54:17 +0100

> This driver is mixing 8-bit and 16-bit bus accessors for reasons unknown,
> however the speculation is that this was some sort of attempt to support
> the 8-bit bus mode.
> 
> As per the KS8851-16MLL documentation, all two registers accessed via the
> 8-bit accessors are internally 16-bit registers, so reading them using
> 16-bit accessors is fine. The KS_CCR read can be converted to 16-bit read
> outright, as it is already a concatenation of two 8-bit reads of that
> register. The KS_RXQCR accesses are 8-bit only, however writing the top
> 8 bits of the register is OK as well, since the driver caches the entire
> 16-bit register value anyway.
> 
> Finally, the driver is not used by any hardware in the kernel right now.
> The only hardware available to me is one with 16-bit bus, so I have no
> way to test the 8-bit bus mode, however it is unlikely this ever really
> worked anyway. If the 8-bit bus mode is ever required, it can be easily
> added by adjusting the 16-bit accessors to do 2 consecutive accesses,
> which is how this should have been done from the beginning.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
