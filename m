Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458F88A92A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfHLVT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfHLVT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 17:19:26 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DD0206C2;
        Mon, 12 Aug 2019 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565644765;
        bh=dHo2t329Id4otpA/Rrjyv9seqUsvy6Z6EEJcEyMJIMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XyRII+3I9wWVWSEqAOP7ZcGdiajnySWhn+aeL+QjbQeopq1r8BppDCR7LG+WCZTaC
         rhX8JnwudyqzoxJPmWfE9gCemQK+DLgIsu4tnU1xB8d8BwM4X/tFP/ypcGwOIo0ei5
         qidMBcxIItLjf+ISX6m2+F3bbZnLUpPWTUODQd9U=
Date:   Mon, 12 Aug 2019 14:19:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     bjorn.topel@intel.com, linux-mm@kvack.org,
        xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
Message-Id: <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
In-Reply-To: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
        <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 15:43:26 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
> established already and are part of configuration interface.
> 
> But for 32-bit systems, while AF_XDP socket configuration, the values
> are to large to pass maximum allowed file size verification.
> The offsets can be tuned ofc, but instead of changing existent
> interface - extend max allowed file size for sockets.


What are the implications of this?  That all code in the kernel which
handles mapped sockets needs to be audited (and tested) for correctly
handling mappings larger than 4G on 32-bit machines?  Has that been
done?  Are we confident that we aren't introducing user-visible buggy
behaviour into unsuspecting legacy code?

Also...  what are the user-visible runtime effects of this change? 
Please send along a paragraph which explains this, for the changelog. 
Does this patch fix some user-visible problem?  If so, should be code
be backported into -stable kernels?

