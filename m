Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CCE1E50B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfENWUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:20:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfENWTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:19:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EDEB14BFF362;
        Tue, 14 May 2019 15:19:08 -0700 (PDT)
Date:   Tue, 14 May 2019 15:19:07 -0700 (PDT)
Message-Id: <20190514.151907.811132511902610611.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com
Subject: Re: [PATCH v2 net] tcp: fix retrans timestamp on passive Fast Open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513173205.212181-1-ycheng@google.com>
References: <20190513173205.212181-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:19:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Mon, 13 May 2019 10:32:05 -0700

> Commit c7d13c8faa74 ("tcp: properly track retry time on
> passive Fast Open") sets the start of SYNACK retransmission
> time on passive Fast Open in "retrans_stamp". However the
> timestamp is not reset upon the handshake has completed. As a
> result, future data packet retransmission may not update it in
> tcp_retransmit_skb(). This may lead to socket aborting earlier
> unexpectedly by retransmits_timed_out() since retrans_stamp remains
> the SYNACK rtx time.
> 
> This bug only manifests on passive TFO sender that a) suffered
> SYNACK timeout and then b) stalls on very first loss recovery. Any
> successful loss recovery would reset the timestamp to avoid this
> issue.
> 
> Fixes: c7d13c8faa74 ("tcp: properly track retry time on passive Fast Open")
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>

Applied and queued up for -stable, thanks.
