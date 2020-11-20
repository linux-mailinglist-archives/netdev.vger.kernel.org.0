Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FDD2BA212
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgKTFxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgKTFxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:53:11 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3698022244;
        Fri, 20 Nov 2020 05:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605851590;
        bh=egdtBs8wyUjmEg9PDHv7HQo2SxMmjcs/ndgPrKcly9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OzNsA3kWXCGcAQ5k3AMdMzGQwj/YPVns9bOrmXIT8Y/RK5tZgDUUlhOvClavC91N2
         UdT9DJ4oeRDKQ0G6mFiEXZfLs8N90/iruHlQU4qJvWs4Bpwe3n4g7IbjqcXvURb8rv
         Cq5jWrZEqhj1QY8bJsLc9nOqBShC14mEJt5/aVao=
Date:   Thu, 19 Nov 2020 21:53:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, prashant@broadcom.com,
        huangjw@broadcom.com, Eddie Wai <eddie.wai@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] bnxt_en: fix error return code in bnxt_init_board()
Message-ID: <20201119215309.0f9c4b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAKOOJTyJ_R6cTij0uZweOm2aFCDg+AG3qGcOSb=wsOSQKzL60g@mail.gmail.com>
References: <1605792621-6268-1-git-send-email-zhangchangzhong@huawei.com>
        <CAKOOJTyJ_R6cTij0uZweOm2aFCDg+AG3qGcOSb=wsOSQKzL60g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 10:53:23 -0800 Edwin Peer wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

> >         if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0 &&
> >             dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
> >                 dev_err(&pdev->dev, "System does not support DMA, aborting\n");
> > +               rc = -EIO;
> >                 goto init_err_disable;

Edwin, please double check if this shouldn't jump to 
pci_release_regions() (or maybe it's harmless 'cause 
PCI likes to magically release things on its own).

> >         }
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Applied thanks!
