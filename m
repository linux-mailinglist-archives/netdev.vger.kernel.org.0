Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4892B141B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgKMCC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgKMCCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 21:02:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02465216C4;
        Fri, 13 Nov 2020 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605232975;
        bh=XOfMvZfYVUhLUcp9EhMuSDDS523FtEpzKjb+gc15pYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEOknqAUeehP16boxE3GTmDgeqUPfEaq1cDiwMfX/EwPeirb18dG7/1ONRr5lOsCt
         FnYaxiDNBl+o+DATYq0A2zcayjRyZlE+5IGeDe8L0cZkaJ90neoR7b0LwK5hD2+zmO
         YWBiaG2FeucaT2y6S1mwohnFh9KgVhdi1QZm5jrw=
Date:   Thu, 12 Nov 2020 18:02:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: Re: [PATCH net v2] net: x25: Increase refcnt of "struct x25_neigh"
 in x25_rx_call_request
Message-ID: <20201112180254.66be25cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112103506.5875-1-xie.he.0141@gmail.com>
References: <20201112103506.5875-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 02:35:06 -0800 Xie He wrote:
> The x25_disconnect function in x25_subr.c would decrease the refcount of
> "x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.
> 
> However, the x25_rx_call_request function in af_x25.c, which is called
> when we receive a connection request, does not increase the refcount when
> it assigns the pointer.
> 
> Fix this issue by increasing the refcount of "struct x25_neigh" in
> x25_rx_call_request.
> 
> This patch fixes frequent kernel crashes when using AF_X25 sockets.
> 
> Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks!
