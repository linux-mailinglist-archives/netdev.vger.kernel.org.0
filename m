Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3730161D29
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgBQWGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:06:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgBQWGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:06:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5648815A9FC28;
        Mon, 17 Feb 2020 14:06:51 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:06:50 -0800 (PST)
Message-Id: <20200217.140650.510071134243739795.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: fix in frame extraction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217083133.20828-1-horatiu.vultur@microchip.com>
References: <20200217083133.20828-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:06:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 17 Feb 2020 09:31:33 +0100

> Each extracted frame on Ocelot has an IFH. The frame and IFH are extracted
> by reading chuncks of 4 bytes from a register.
> 
> In case the IFH and frames were read corretly it would try to read the next
> frame. In case there are no more frames in the queue, it checks if there
> were any previous errors and in that case clear the queue. But this check
> will always succeed also when there are no errors. Because when extracting
> the IFH the error is checked against 4(number of bytes read) and then the
> error is set only if the extraction of the frame failed. So in a happy case
> where there are no errors the err variable is still 4. So it could be
> a case where after the check that there are no more frames in the queue, a
> frame will arrive in the queue but because the error is not reseted, it
> would try to flush the queue. So the frame will be lost.
> 
> The fix consist in resetting the error after reading the IFH.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Applied and queued up for -stable.
