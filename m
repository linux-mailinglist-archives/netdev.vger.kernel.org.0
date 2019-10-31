Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AAEEB7EC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfJaTX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:23:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbfJaTX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:23:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECE6514FC9F70;
        Thu, 31 Oct 2019 12:23:28 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:23:28 -0700 (PDT)
Message-Id: <20191031.122328.1237720180513331270.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix handling of last subpacket of jumbo
 packet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157252402623.30237.12555934347853871645.stgit@warthog.procyon.org.uk>
References: <157252402623.30237.12555934347853871645.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:23:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 31 Oct 2019 12:13:46 +0000

> When rxrpc_recvmsg_data() sets the return value to 1 because it's drained
> all the data for the last packet, it checks the last-packet flag on the
> whole packet - but this is wrong, since the last-packet flag is only set on
> the final subpacket of the last jumbo packet.  This means that a call that
> receives its last packet in a jumbo packet won't complete properly.
> 
> Fix this by having rxrpc_locate_data() determine the last-packet state of
> the subpacket it's looking at and passing that back to the caller rather
> than having the caller look in the packet header.  The caller then needs to
> cache this in the rxrpc_call struct as rxrpc_locate_data() isn't then
> called again for this packet.
> 
> Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
> Fixes: e2de6c404898 ("rxrpc: Use info in skbuff instead of reparsing a jumbo packet")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks David.
