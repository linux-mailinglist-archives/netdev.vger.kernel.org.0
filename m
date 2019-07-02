Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D805C73A
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfGBC1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:27:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfGBC1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:27:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3041A14DEB6DA;
        Mon,  1 Jul 2019 19:27:34 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:27:33 -0700 (PDT)
Message-Id: <20190701.192733.26575663343081553.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 0/3, net-next, v2] net: netsec: Add XDP Support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:27:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Sat, 29 Jun 2019 08:23:22 +0300

> This is a respin of https://www.spinics.net/lists/netdev/msg526066.html
> Since page_pool API fixes are merged into net-next we can now safely use 
> it's DMA mapping capabilities. 
> 
> First patch changes the buffer allocation from napi/netdev_alloc_frag()
> to page_pool API. Although this will lead to slightly reduced performance 
> (on raw packet drops only) we can use the API for XDP buffer recycling. 
> Another side effect is a slight increase in memory usage, due to using a 
> single page per packet.
> 
> The second patch adds XDP support on the driver. 
> There's a bunch of interesting options that come up due to the single 
> Tx queue.
> Locking is needed(to avoid messing up the Tx queues since ndo_xdp_xmit 
> and the normal stack can co-exist). We also need to track down the 
> 'buffer type' for TX and properly free or recycle the packet depending 
> on it's nature.
> 
> 
> Changes since RFC:
> - Bug fixes from Jesper and Maciej
> - Added page pool API to retrieve the DMA direction
> 
> Changes since v1:
> - Use page_pool_free correctly if xdp_rxq_info_reg() failed

Series applied, thanks.

I realize from the discussion on patch #3 there will be follow-ups to this.
