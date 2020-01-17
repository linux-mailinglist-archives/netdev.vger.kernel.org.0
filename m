Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA7141D9B
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgASLb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgASLb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:26 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93A0714C928F8;
        Sun, 19 Jan 2020 03:31:25 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:32:19 -0800 (PST)
Message-Id: <20200117.043219.1348996138082295599.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: systemport: Fixed queue mapping in internal
 ring map
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116210859.7376-1-f.fainelli@gmail.com>
References: <20200116210859.7376-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 16 Jan 2020 13:08:58 -0800

> We would not be transmitting using the correct SYSTEMPORT transmit queue
> during ndo_select_queue() which looks up the internal TX ring map
> because while establishing the mapping we would be off by 4, so for
> instance, when we populate switch port mappings we would be doing:
> 
> switch port 0, queue 0 -> ring index #0
> switch port 0, queue 1 -> ring index #1
> ...
> switch port 0, queue 3 -> ring index #3
> switch port 1, queue 0 -> ring index #8 (4 + 4 * 1)
> ...
> 
> instead of using ring index #4. This would cause our ndo_select_queue()
> to use the fallback queue mechanism which would pick up an incorrect
> ring for that switch port. Fix this by using the correct switch queue
> number instead of SYSTEMPORT queue number.
> 
> Fixes: 3ed67ca243b3 ("net: systemport: Simplify queue mapping logic")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, but I had to fix the SHA1-ID of the Fixes tag to be:

    Fixes: 25c440704661 ("net: systemport: Simplify queue mapping logic")

Thanks.
