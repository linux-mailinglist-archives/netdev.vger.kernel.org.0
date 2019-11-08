Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF1F4076
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfKHGhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:37:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHGhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:37:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CNijAZshoMwJR20b7qKf+ZniwDLWKjrDhAzbp2wJNJ4=; b=WRsfhR/j7iM6vH+dmWg/sruIi
        uLl2UPDUxo2rYptfqOAVY6PReTarn9H3uEn4AGxOMOB8qdEX/2LEohLRDDE+z8JWzo57oLIUt1ip0
        Y4P9MOmwYJ6JKve0itY5zUmX1Q4pm8T52GXkrtvTs1CH9KpZNXqwo6HqlFwUpJ0+AiATwO7OSp4JM
        4+Q1OKjCSw12B4PyIQLiowQv4tB4hUIq81fHhfnLuPu0xsqL1Tne9CFCL4mAbycFhuv9OvwMH0DCp
        mzrPiuvtK/f5uh88+qGXBjQaZxoZbA2Jk7GvPqh7ZetwzQUTH3WzKT0Dbq6GnqxDTEYF4MZ2n/8kn
        ZpaAngp6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSxtj-0006Wp-Bd; Fri, 08 Nov 2019 06:37:31 +0000
Date:   Thu, 7 Nov 2019 22:37:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params
 for mediated device
Message-ID: <20191108063731.GA24679@infradead.org>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-16-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-16-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:08:31AM -0600, Parav Pandit wrote:
> Implement dma ops wrapper to divert dma ops to its parent PCI device
> because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.

Yikes.  I've been trying hard to get rid of pointless dma_map_ops
instance.  What upper layers use these child devices, and why can't
they just use the parent device for dma mapping directly?
