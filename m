Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FE6283226
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgJEIfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:35:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689CC0613CE;
        Mon,  5 Oct 2020 01:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tAxOuX/v9E+6UWI8owhCfQof30gLmdcbcFMQCnkbAo8=; b=Y763woh6YNI4wTWfZGtXS4zFOV
        lPpFkln7IAxMPzBrR87Mz+QsjRWiYyxipshLZmeYyRndYVS2neHDsh73UXXT3GDtDHVEcPvGYbGFa
        HofYe4QcwZ8Oyd5jCsjFKSRhoM9wuvjg/zh9/NheEkp9iLknfgjjR3XKhRmsPMNlgTDEH0rvJDJBw
        bDI0lgcQnEIkxzYqweKOKaxOixl51xKzvm7+Bq38jzN6r/Hi6Gzuz+AjZz7MSScNqdJelvhNBcJ2v
        FoGlfgPgUYmHpk/zxoG2V/6qzXPE1pLVVny6P+taau3MAIv4BilMO9I8A5BOdDgh9/gIBCqGqRh7n
        qSmYaiLA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPLy3-0000Nb-8f; Mon, 05 Oct 2020 08:35:35 +0000
Date:   Mon, 5 Oct 2020 09:35:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     davem@davemloft.net, Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        maximmi@mellanox.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: please revert [PATCH bpf-next v5 03/15] xsk: create and free buffer
 pool independently from umem
Message-ID: <20201005083535.GA512@infradead.org>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
 <1598603189-32145-4-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598603189-32145-4-git-send-email-magnus.karlsson@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please can you rever this?  This is the second xsk patch this year
that pokes into dma-mapping internals for absolutely not reason.

And we discussed this in detail the last time around: drivers have
absolutely no business poking into dma-direct.h and dma-noncoherent.h.
In fact because people do this crap I have a patch to remove these
headers that I'm about to queue up, so if this doesn't get reverted
the linux-next build will break soon.
