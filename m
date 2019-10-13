Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B833CD5747
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfJMSRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 14:17:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfJMSRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 14:17:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C2DF146D331B;
        Sun, 13 Oct 2019 11:17:06 -0700 (PDT)
Date:   Sun, 13 Oct 2019 11:17:05 -0700 (PDT)
Message-Id: <20191013.111705.2247028003804863450.davem@davemloft.net>
To:     soheil.kdev@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, soheil@google.com
Subject: Re: [PATCH net-next] tcp: improve recv_skip_hint for
 tcp_zerocopy_receive
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011032702.59998-1-soheil.kdev@gmail.com>
References: <20191011032702.59998-1-soheil.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 11:17:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
Date: Thu, 10 Oct 2019 23:27:02 -0400

> From: Soheil Hassas Yeganeh <soheil@google.com>
> 
> tcp_zerocopy_receive() rounds down the zc->length a multiple of
> PAGE_SIZE. This results in two issues:
> - tcp_zerocopy_receive sets recv_skip_hint to the length of the
>   receive queue if the zc->length input is smaller than the
>   PAGE_SIZE, even though the data in receive queue could be
>   zerocopied.
> - tcp_zerocopy_receive would set recv_skip_hint of 0, in cases
>   where we have a little bit of data after the perfectly-sized
>   packets.
> 
> To fix these issues, do not store the rounded down value in
> zc->length. Round down the length passed to zap_page_range(),
> and return min(inq, zc->length) when the zap_range is 0.
> 
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you.
