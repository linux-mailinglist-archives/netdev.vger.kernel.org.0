Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347C71E9578
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgEaEnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaEnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:43:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3BDC05BD43;
        Sat, 30 May 2020 21:43:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A1A9128FCC74;
        Sat, 30 May 2020 21:43:39 -0700 (PDT)
Date:   Sat, 30 May 2020 21:43:37 -0700 (PDT)
Message-Id: <20200530.214337.1492575923118562439.davem@davemloft.net>
To:     clew@codeaurora.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Allocate workqueue before kernel_bind
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
References: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:43:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>
Date: Thu, 28 May 2020 16:05:26 -0700

> A null pointer dereference in qrtr_ns_data_ready() is seen if a client
> opens a qrtr socket before qrtr_ns_init() can bind to the control port.
> When the control port is bound, the ENETRESET error will be broadcasted
> and clients will close their sockets. This results in DEL_CLIENT
> packets being sent to the ns and qrtr_ns_data_ready() being called
> without the workqueue being allocated.
> 
> Allocate the workqueue before setting sk_data_ready and binding to the
> control port. This ensures that the work and workqueue structs are
> allocated and initialized before qrtr_ns_data_ready can be called.
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Chris Lew <clew@codeaurora.org>

Applied, thank you.
