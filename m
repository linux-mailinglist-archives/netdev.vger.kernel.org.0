Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0638F2450
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbfKGBd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:33:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfKGBd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:33:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 689BE1502FACC;
        Wed,  6 Nov 2019 17:33:58 -0800 (PST)
Date:   Wed, 06 Nov 2019 17:33:55 -0800 (PST)
Message-Id: <20191106.173355.264262348695178120.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net 0/3] net/tls: add a TX lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105222436.27359-1-jakub.kicinski@netronome.com>
References: <20191105222436.27359-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 17:33:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue,  5 Nov 2019 14:24:33 -0800

> Some time ago Pooja and Mallesham started reporting crashes with
> an async accelerator. After trying to poke the existing logic into
> shape I came to the conclusion that it can't be trusted, and to
> preserve our sanity we should just add a lock around the TX side.
> 
> First patch removes the sk_write_pending checks from the write
> space callbacks. Those don't seem to have a logical justification.
> 
> Patch 2 adds the TX lock and patch 3 associated test (which should
> hang with current net).
> 
> Mallesham reports that even with these fixes applied the async
> accelerator workload still occasionally hangs waiting for socket
> memory. I suspect that's strictly related to the way async crypto
> is integrated in TLS, so I think we should get these into net or
> net-next and move from there.

Series applied and queued up for -stable, thanks Jakub.
