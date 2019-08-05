Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0D825E8
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfHEUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:16:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33594 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:16:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A97FC154316E3;
        Mon,  5 Aug 2019 13:16:11 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:15:52 -0700 (PDT)
Message-Id: <20190805.131552.1289253403274923799.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Subject: Re: [PATCH net 1/2] net/tls: partially revert fix transition
 through disconnect with close
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801213602.19634-1-jakub.kicinski@netronome.com>
References: <20190801213602.19634-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:16:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  1 Aug 2019 14:36:01 -0700

> Looks like we were slightly overzealous with the shutdown()
> cleanup. Even though the sock->sk_state can reach CLOSED again,
> socket->state will not got back to SS_UNCONNECTED once
> connections is ESTABLISHED. Meaning we will see EISCONN if
> we try to reconnect, and EINVAL if we try to listen.
> 
> Only listen sockets can be shutdown() and reused, but since
> ESTABLISHED sockets can never be re-connected() or used for
> listen() we don't need to try to clean up the ULP state early.
> 
> Fixes: 32857cf57f92 ("net/tls: fix transition through disconnect with close")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied and queued up for -stable.
