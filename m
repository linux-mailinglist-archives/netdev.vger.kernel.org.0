Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8C5277E72
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIYDQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYDQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:16:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51DFC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 20:16:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2EBD135FCBB0;
        Thu, 24 Sep 2020 19:59:51 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:16:38 -0700 (PDT)
Message-Id: <20200924.201638.1709163985407685775.davem@davemloft.net>
To:     priyarjha.kernel@gmail.com
Cc:     netdev@vger.kernel.org, priyarjha@google.com, ncardwell@google.com,
        ycheng@google.com, edumazet@google.com
Subject: Re: [PATCH net] tcp: skip DSACKs with dubious sequence ranges
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924222314.3198543-1-priyarjha.kernel@gmail.com>
References: <20200924222314.3198543-1-priyarjha.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:59:51 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Priyaranjan Jha <priyarjha.kernel@gmail.com>
Date: Thu, 24 Sep 2020 15:23:14 -0700

> From: Priyaranjan Jha <priyarjha@google.com>
> 
> Currently, we use length of DSACKed range to compute number of
> delivered packets. And if sequence range in DSACK is corrupted,
> we can get bogus dsacked/acked count, and bogus cwnd.
> 
> This patch put bounds on DSACKed range to skip update of data
> delivery and spurious retransmission information, if the DSACK
> is unlikely caused by sender's action:
> - DSACKed range shouldn't be greater than maximum advertised rwnd.
> - Total no. of DSACKed segments shouldn't be greater than total
>   no. of retransmitted segs. Unlike spurious retransmits, network
>   duplicates or corrupted DSACKs shouldn't be counted as delivery.
> 
> Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks.
