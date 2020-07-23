Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F48922B6A3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGWTYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgGWTYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:24:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BE0C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:24:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B84B11D69C3B;
        Thu, 23 Jul 2020 12:07:32 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:24:16 -0700 (PDT)
Message-Id: <20200723.122416.892926303358645003.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH net] tcp: allow at most one TLP probe per flight
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723190006.1687271-1-ycheng@google.com>
References: <20200723190006.1687271-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 12:07:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Thu, 23 Jul 2020 12:00:06 -0700

> Previously TLP may send multiple probes of new data in one
> flight. This happens when the sender is cwnd limited. After the
> initial TLP containing new data is sent, the sender receives another
> ACK that acks partial inflight.  It may re-arm another TLP timer
> to send more, if no further ACK returns before the next TLP timeout
> (PTO) expires. The sender may send in theory a large amount of TLP
> until send queue is depleted. This only happens if the sender sees
> such irregular uncommon ACK pattern. But it is generally undesirable
> behavior during congestion especially.
> 
> The original TLP design restrict only one TLP probe per inflight as
> published in "Reducing Web Latency: the Virtue of Gentle Aggression",
> SIGCOMM 2013. This patch changes TLP to send at most one probe
> per inflight.
> 
> Note that if the sender is app-limited, TLP retransmits old data
> and did not have this issue.
> 
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks!
