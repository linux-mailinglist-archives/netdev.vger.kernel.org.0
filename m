Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05433D2F04
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhGVUjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:39:24 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:33276 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhGVUjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 16:39:24 -0400
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2021 16:39:23 EDT
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6fj8-002yyA-IB; Thu, 22 Jul 2021 20:55:30 +0000
Date:   Thu, 22 Jul 2021 20:55:30 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, edumazet@google.com, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
Message-ID: <YPnbQvKgA8Fun9Ky@zeniv-ca.linux.org.uk>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-3-borisp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110325.371-3-borisp@nvidia.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:02:51PM +0300, Boris Pismenny wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> 
> When using direct data placement (DDP) the NIC writes some of the payload
> directly to the destination buffer, and constructs SKBs such that they
> point to this data. To skip copies when SKB data already resides in the
> destination we use the newly introduced routines in this commit, which
> check if (src == dst), and skip the copy when that's true.
> 
> As the current user for these routines is in the block layer (nvme-tcp),
> then we only apply the change for bio_vec. Other routines use the normal
> methods for copying.

Please, take a look at -rc1 and see the changes in lib/iov_iter.c in there.
