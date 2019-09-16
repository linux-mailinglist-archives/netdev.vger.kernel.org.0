Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A861B3500
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfIPHDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:03:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfIPHDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:03:07 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2C2A1510890B;
        Mon, 16 Sep 2019 00:03:04 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:03:03 +0200 (CEST)
Message-Id: <20190916.090303.994115261056261585.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kraig@google.com,
        zabele@comcast.net, pabeni@redhat.com, mark.keaton@raytheon.com,
        willemb@google.com
Subject: Re: [PATCH net] udp: correct reuseport selection with connected
 sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
References: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:03:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 12 Sep 2019 21:16:39 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> UDP reuseport groups can hold a mix unconnected and connected sockets.
> Ensure that connections only receive all traffic to their 4-tuple.
> 
> Fast reuseport returns on the first reuseport match on the assumption
> that all matches are equal. Only if connections are present, return to
> the previous behavior of scoring all sockets.
> 
> Record if connections are present and if so (1) treat such connected
> sockets as an independent match from the group, (2) only return
> 2-tuple matches from reuseport and (3) do not return on the first
> 2-tuple reuseport match to allow for a higher scoring match later.
> 
> New field has_conns is set without locks. No other fields in the
> bitmap are modified at runtime and the field is only ever set
> unconditionally, so an RMW cannot miss a change.
> 
> Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
> Link: http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks.
