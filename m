Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D71250BC2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgHXWis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgHXWis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:38:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23789C061574;
        Mon, 24 Aug 2020 15:38:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9320312909FBC;
        Mon, 24 Aug 2020 15:22:01 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:38:47 -0700 (PDT)
Message-Id: <20200824.153847.768272520909717006.davem@davemloft.net>
To:     ashiduka@fujitsu.com
Cc:     sergei.shtylyov@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820094307.3977-1-ashiduka@fujitsu.com>
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:22:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Date: Thu, 20 Aug 2020 18:43:07 +0900

> When this driver is built as a module, I cannot rmmod it after insmoding
> it.
> This is because that this driver calls ravb_mdio_init() at the time of
> probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
> after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod
> cannot be performed.
> 
> $ lsmod
> Module                  Size  Used by
> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
> 
> Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
> rmmod is possible in the ifdown state.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Applied and queued up for -stable, thanks.
