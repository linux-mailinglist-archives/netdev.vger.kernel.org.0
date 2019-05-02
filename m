Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EED811180
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 04:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEBCbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 22:31:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfEBCbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 22:31:32 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C0361433EB17;
        Wed,  1 May 2019 19:31:31 -0700 (PDT)
Date:   Wed, 01 May 2019 22:31:27 -0400 (EDT)
Message-Id: <20190501.223127.269942837516364133.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pabeni@redhat.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] udp: fix GRO packet of death
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502015628.22215-1-edumazet@google.com>
References: <20190502015628.22215-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 19:31:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  1 May 2019 18:56:28 -0700

> syzbot was able to crash host by sending UDP packets with a 0 payload.
> 
> TCP does not have this issue since we do not aggregate packets without
> payload.
> 
> Since dev_gro_receive() sets gso_size based on skb_gro_len(skb)
> it seems not worth trying to cope with padded packets.
 ...
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Ugh :(

Applied and queued up for -stable, thanks Eric.
