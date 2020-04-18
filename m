Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F11AF544
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgDRWEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:04:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E94C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:04:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2881B12770043;
        Sat, 18 Apr 2020 15:04:49 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:04:48 -0700 (PDT)
Message-Id: <20200418.150448.1291076574525454160.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        mcr@sandelman.ca, stefan@datenfreihafen.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: rpl: fix full address compression
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415130653.6791-1-alex.aring@gmail.com>
References: <20200415130653.6791-1-alex.aring@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:04:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Wed, 15 Apr 2020 09:06:53 -0400

> This patch makes it impossible that cmpri or cmpre values are set to the
> value 16 which is not possible, because these are 4 bit values. We
> currently run in an overflow when assigning the value 16 to it.
> 
> According to the standard a value of 16 can be interpreted as a full
> elided address which isn't possible to set as compression value. A reason
> why this cannot be set is that the current ipv6 header destination address
> should never show up inside the segments of the rpl header. In this case we
> run in a overflow and the address will have no compression at all. Means
> cmpri or compre is set to 0.
> 
> As we handle cmpri and cmpre sometimes as unsigned char or 4 bit value
> inside the rpl header the current behaviour ends in an invalid header
> format. This patch simple use the best compression method if we ever run
> into the case that the destination address is showed up inside the rpl
> segments. We avoid the overflow handling and the rpl header is still valid,
> even when we have the destination address inside the rpl segments.
> 
> Signed-off-by: Alexander Aring <alex.aring@gmail.com>

Applied, thank you.
