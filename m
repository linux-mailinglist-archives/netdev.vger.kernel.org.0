Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB7F2967BF
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373578AbgJVXxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373574AbgJVXxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 19:53:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C74720724;
        Thu, 22 Oct 2020 23:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603410821;
        bh=XTuP5V6m1sgf8FYoUOE8gLVuSS7t2nTxM3D1KfsKd1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FfYmnRDQzAynKO+YjC12hyiUuqoe/WmLQggexxKwvtp8RyUjMIzhAwTL4IvyoUtYW
         n/cePtQWwB7xwagWFzux6t8/S4VNODAk1DFE2wdMP8TR3vg5eNQ2F0EF71kp7HeOS+
         IKR6LSYpuJH7S8Oz3eFAw4up7+OLbCz0M0OTKLis=
Date:   Thu, 22 Oct 2020 16:53:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net 3/7] cxgb4/ch_ktls: creating skbs causes panic
Message-ID: <20201022165340.34068bb4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022101019.7363-4-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
        <20201022101019.7363-4-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 15:40:15 +0530 Rohit Maheshwari wrote:
> Creating SKB per tls record and freeing the original one causes
> panic. There will be race if connection reset is requested. By
> freeing original skb, refcnt will be decremented and that means,
> there is no pending record to send, and so tls_dev_del will be
> requested in control path while SKB of related connection is in
> queue.
>  Better approach is to use same SKB to send one record (partial
> data) at a time. We still have to create a new SKB when partial
> last part of a record is requested.
>  This fix introduces new API cxgb4_write_partial_sgl() to send
> partial part of skb. Present cxgb4_write_sgl can only provide
> feasibility to start from an offset which limits to header only
> and it can write sgls for the whole skb len. But this new API
> will help in both. It can start from any offset and can end
> writing in middle of the skb.
> 
> Fixes: 429765a149f1 ("chcr: handle partial end part of a record"
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Fixes tag: Fixes: 429765a149f1 ("chcr: handle partial end part of a record"
Has these problem(s):
	- Subject has leading but no trailing parentheses
