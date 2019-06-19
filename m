Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE584BCBA
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfFSPYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:24:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfFSPYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 11:24:54 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86F3F15254B37;
        Wed, 19 Jun 2019 08:24:52 -0700 (PDT)
Date:   Wed, 19 Jun 2019 11:24:49 -0400 (EDT)
Message-Id: <20190619.112449.511488634807501138.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org, toke@toke.dk,
        tariqt@mellanox.com, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        mcroce@redhat.com
Subject: Re: [PATCH net-next v2 00/12] xdp: page_pool fixes and in-flight
 accounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 08:24:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Tue, 18 Jun 2019 15:05:07 +0200

> This patchset fix page_pool API and users, such that drivers can use it for
> DMA-mapping. A number of places exist, where the DMA-mapping would not get
> released/unmapped, all these are fixed. This occurs e.g. when an xdp_frame
> gets converted to an SKB. As network stack doesn't have any callback for XDP
> memory models.
> 
> The patchset also address a shutdown race-condition. Today removing a XDP
> memory model, based on page_pool, is only delayed one RCU grace period. This
> isn't enough as redirected xdp_frames can still be in-flight on different
> queues (remote driver TX, cpumap or veth).
> 
> We stress that when drivers use page_pool for DMA-mapping, then they MUST
> use one packet per page. This might change in the future, but more work lies
> ahead, before we can lift this restriction.
> 
> This patchset change the page_pool API to be more strict, as in-flight page
> accounting is added.

Series applied, thanks Jesper.
