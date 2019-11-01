Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC2ECAA2
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfKAV7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfKAV7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 17:59:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8C47151AE761;
        Fri,  1 Nov 2019 14:59:23 -0700 (PDT)
Date:   Fri, 01 Nov 2019 14:59:23 -0700 (PDT)
Message-Id: <20191101.145923.2168876543627475825.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, tnagel@google.com
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101173219.18631-1-edumazet@google.com>
References: <20191101173219.18631-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 14:59:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  1 Nov 2019 10:32:19 -0700

> Historically linux tried to stick to RFC 791, 1122, 2003
> for IPv4 ID field generation.
> 
> RFC 6864 made clear that no matter how hard we try,
> we can not ensure unicity of IP ID within maximum
> lifetime for all datagrams with a given source
> address/destination address/protocol tuple.
> 
> Linux uses a per socket inet generator (inet_id), initialized
> at connection startup with a XOR of 'jiffies' and other
> fields that appear clear on the wire.
> 
> Thiemo Nagel pointed that this strategy is a privacy
> concern as this provides 16 bits of entropy to fingerprint
> devices.
> 
> Let's switch to a random starting point, this is just as
> good as far as RFC 6864 is concerned and does not leak
> anything critical.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Thiemo Nagel <tnagel@google.com>

Applied and queued up for -stable, thanks.
