Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0191225E4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 08:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfLQHvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 02:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfLQHvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 02:51:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B26F206D8;
        Tue, 17 Dec 2019 07:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576569094;
        bh=1E8uWoPIbWivZlT6LMDRe7vHB1L2KARa+dNYQ093htA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5cTRKtVmcgVlKyPf/+Fq4NZ+a142ya2cOGUf2jqac16wYpl17JcmEhE6lVbW1E0G
         TSAw+4C26bJwSP5USnIf9leKB2cR/wpxTUlPIQ6G35x7YXAqB/QIA4vD8vHL/AmExi
         MOjHYC52jYgvFRzZXvvXHkENMJtJY04E6KPegZB0=
Date:   Tue, 17 Dec 2019 08:51:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aviraj CJ <acj@cisco.com>
Cc:     peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH stable v4.4 1/2] net: stmmac: use correct DMA buffer size
 in the RX descriptor
Message-ID: <20191217075132.GC2474507@kroah.com>
References: <20191217055228.57282-1-acj@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217055228.57282-1-acj@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 09:52:27PM -0800, Aviraj CJ wrote:
> upstream 583e6361414903c5206258a30e5bd88cb03c0254 commit
> 
> We always program the maximum DMA buffer size into the receive descriptor,
> although the allocated size may be less. E.g. with the default MTU size
> we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> memory may get corrupted.
> 
> Program DMA using exact buffer sizes.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [acj: backport to v4.4 -stable :
> - Modified patch since v4.4 driver has no support for Big endian
> - Skipped the section modifying non-existent functions in dwmac4_descs.c and
> dwxgmac2_descs.c ]
> Signed-off-by: Aviraj CJ <acj@cisco.com>

I can't take stable patches for an older tree and have it "skip" newer
stable trees.  To be specific, this patch is already in the 4.19.41
release, but if I were to take it into the 4.4.y tree, then anyone
upgrading to 4.9.y or 4.14.y afterward would run into the same issue.

So can you also send backports to 4.9.y and 4.14.y so that I can take
this fix into all trees?

Same for patch 2/2.

thanks,

greg k-h
