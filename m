Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1312FE09
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgACUlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:41:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgACUlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:41:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40B04158B8EA3;
        Fri,  3 Jan 2020 12:41:18 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:41:17 -0800 (PST)
Message-Id: <20200103.124117.1761197014179324099.davem@davemloft.net>
To:     liran.alon@oracle.com
Cc:     csully@google.com, netdev@vger.kernel.org, sagis@google.com,
        jonolson@google.com, yangchun@google.com, lrizzo@google.com,
        adisuresh@google.com, eric.dumazet@gmail.com, si-wei.liu@oracle.com
Subject: Re: [PATCH v2] net: Google gve: Remove dma_wmb() before ringing
 doorbell
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103164459.71954-1-liran.alon@oracle.com>
References: <20200103164459.71954-1-liran.alon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:41:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>
Date: Fri,  3 Jan 2020 18:44:59 +0200

> Current code use dma_wmb() to ensure Rx/Tx descriptors are visible
> to device before writing to doorbell.
> 
> However, these dma_wmb() are wrong and unnecessary. Therefore,
> they should be removed.
> 
> iowrite32be() called from gve_rx_write_doorbell()/gve_tx_put_doorbell()
> should guaratee that all previous writes to WB/UC memory is visible to
> device before the write done by iowrite32be().
> 
> E.g. On ARM64, iowrite32be() calls __iowmb() which expands to dma_wmb()
> and only then calls __raw_writel().
> 
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Applied, thank you.
