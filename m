Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1214135
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfEEQzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:55:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEEQzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 12:55:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FE8C14D99A6D;
        Sun,  5 May 2019 09:55:20 -0700 (PDT)
Date:   Sun, 05 May 2019 09:55:19 -0700 (PDT)
Message-Id: <20190505.095519.1938967372701152762.davem@davemloft.net>
To:     pebolle@tiscali.nl
Cc:     netdev@vger.kernel.org, bigeasy@linutronix.de,
        gigaset307x-common@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] isdn: bas_gigaset: use usb_fill_int_urb() properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501211903.14806-1-pebolle@tiscali.nl>
References: <20190501211903.14806-1-pebolle@tiscali.nl>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 09:55:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Wed,  1 May 2019 23:19:03 +0200

> The switch to make bas_gigaset use usb_fill_int_urb() - instead of
> filling that urb "by hand" - missed the subtle ordering of the previous
> code.
> 
> See, before the switch urb->dev was set to a member somewhere deep in a
> complicated structure and then supplied to usb_rcvisocpipe() and
> usb_sndisocpipe(). After that switch urb->dev wasn't set to anything
> specific before being supplied to those two macros. This triggers a
> nasty oops:
...
> No-one noticed because this Oops is apparently only triggered by setting
> up an ISDN data connection on a live ISDN line on a gigaset base (ie,
> the PBX that the gigaset driver support). Very few people do that
> running present day kernels.
> 
> Anyhow, a little code reorganization makes this problem go away, while
> avoiding the subtle ordering that was used in the past. So let's do
> that.
> 
> Fixes: 78c696c19578 ("isdn: gigaset: use usb_fill_int_urb()")
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Arnd's ISDN cleanup hasn't yet hit net-next so this still uses
> drivers/isdn. If people prefer to apply this after Arnd has exiled
> gigaset into staging, I'll gladly respin. 

Applied to 'net', queued up for -stable, and I'll deal with the
merge conflict :-/ :-) :-)
