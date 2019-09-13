Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4793B265D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfIMUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:00:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbfIMUAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:00:18 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69D93100086B9;
        Fri, 13 Sep 2019 13:00:17 -0700 (PDT)
Date:   Fri, 13 Sep 2019 20:44:34 +0100 (WEST)
Message-Id: <20190913.204434.1507890936678622830.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net-next] ip: support SO_MARK cmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911195051.166062-1-willemdebruijn.kernel@gmail.com>
References: <20190911195051.166062-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 13:00:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 11 Sep 2019 15:50:51 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Enable setting skb->mark for UDP and RAW sockets using cmsg.
> 
> This is analogous to existing support for TOS, TTL, txtime, etc.
> 
> Packet sockets already support this as of commit c7d39e32632e
> ("packet: support per-packet fwmark for af_packet sendmsg").
> 
> Similar to other fields, implement by
> 1. initialize the sockcm_cookie.mark from socket option sk_mark
> 2. optionally overwrite this in ip_cmsg_send/ip6_datagram_send_ctl
> 3. initialize inet_cork.mark from sockcm_cookie.mark
> 4. initialize each (usually just one) skb->mark from inet_cork.mark
> 
> Step 1 is handled in one location for most protocols by ipcm_init_sk
> as of commit 351782067b6b ("ipv4: ipcm_cookie initializers").
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Looks good, applied.
