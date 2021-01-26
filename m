Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E781304219
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 16:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406192AbhAZPPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 10:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406053AbhAZPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 10:00:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE371C061A29;
        Tue, 26 Jan 2021 06:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q8zSrOkZUfVVAD2RPXwAf5szQHGrfXRJx7Z8scfma+s=; b=iv7/I/bKOaKzsf9Xt2C+lpVDBe
        svBfrpEprvl4TV7+gFlHRnZyQhBhmgio2tap8Qe1ADwSQxk/RctEe74Yy526cTqoibXSNO++CwEo9
        dX/F+h4eG1fwcpms36HJmJw3vh6cFLjjkiNyLzkDZVZkGg4NfCQTJr4NmHZzIKP/JOqzqWHRks/wU
        o9NiMCmFY6QWoFGg+1e9IQr1WZs7IjSNHxOjF7LgliMZWG5QTtq0dzwfxpuVOd0/fvvOP6/zcc1Rk
        2XP4IeObKpxrS2kWOFCT93/neD97G6QXiFf6x6pMD56G+IWrA2m1pinViIubdcjHpL8tl5oiXSbkn
        xZZarrJA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4Pnd-005mUs-5O; Tue, 26 Jan 2021 14:58:43 +0000
Date:   Tue, 26 Jan 2021 14:58:33 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: Preemptible idr_alloc() in QRTR code
Message-ID: <20210126145833.GM308988@casper.infradead.org>
References: <20210126104734.GB80448@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126104734.GB80448@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:47:34AM +0000, Mark Rutland wrote:
> Hi,
> 
> When fuzzing arm64 with Syzkaller, I'm seeing some splats where
> this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
> radix_tree_node_alloc(), in a preemptible context:

I sent a patch to fix this last June.  The maintainer seems to be
under the impression that I care an awful lot more about their
code than I do.

https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
