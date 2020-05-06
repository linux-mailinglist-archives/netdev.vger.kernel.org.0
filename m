Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7FA1C7B6C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgEFUmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgEFUmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:42:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84666C061A0F;
        Wed,  6 May 2020 13:42:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7CF21210A3F0;
        Wed,  6 May 2020 13:42:12 -0700 (PDT)
Date:   Wed, 06 May 2020 13:42:09 -0700 (PDT)
Message-Id: <20200506.134209.2202487070619689100.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        eric.dumazet@gmail.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] virtio_net: fix lockdep warning on 32 bit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506000006.196646-1-mst@redhat.com>
References: <20200506000006.196646-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:42:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 5 May 2020 20:01:31 -0400

> -		u64_stats_update_end(&rq->stats.syncp);
> +		u64_stats_update_end_irqrestore(&rq->stats.syncp);

Need to pass flags to this function.
