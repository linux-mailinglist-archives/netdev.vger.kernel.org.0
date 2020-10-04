Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A56282E0D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 00:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgJDWPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgJDWPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 18:15:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F06C0613CE;
        Sun,  4 Oct 2020 15:15:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E377212784833;
        Sun,  4 Oct 2020 14:58:49 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:15:35 -0700 (PDT)
Message-Id: <20201004.151535.2244486201194283232.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan: lapb: Replace the skb->len checks
 with pskb_may_pull
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201004004619.291065-1-xie.he.0141@gmail.com>
References: <20201004004619.291065-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:58:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Sat,  3 Oct 2020 17:46:19 -0700

> The purpose of these skb->len checks in these drivers is to ensure that
> there is a header in the skb available to be read and pulled.
> 
> However, we already have the pskb_may_pull function for this purpose.
> 
> The pskb_may_pull function also correctly handles non-linear skbs.
> 
> (Also delete the word "check" in the comments because pskb_may_pull may
> do things other than simple checks in the case of non-linear skbs.)
> 
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

This is excessive.

On transmit the header will be in the linear area, especially
if it is only one byte in size.

You're adding a lot of extra checks, function calls, etc. which are
frankly unnecessary.

I'm not applying this unless you can prove that a non-linear single
header byte is possible in these code paths.  And you'll need to add
such proof to your commit message.

Thank you.
