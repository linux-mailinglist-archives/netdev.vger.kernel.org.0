Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A342BBF7E9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfIZRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfIZRtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:49:53 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26ABC21D56;
        Thu, 26 Sep 2019 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569520192;
        bh=kP05L1VtWm0y0NjRMIPLGQQM0rNIo2l0olK+f3fUens=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CQHFgJpC7iv1c09UB6lNP1yZh9pZUqUl/xGXh3YazcMSYAwYmoCzOcFXa04Yzu7jd
         aUYC4fTpdWUm6nbOn/why4QCJi5jCLuiebfN6cqWsz0dLwcMU8gs2Grw0BQe7Tpqqr
         HTGTREKzSqyXjoZ3p+RvEexLjQUAP2zwNlrhcFeI=
Date:   Thu, 26 Sep 2019 20:49:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
Message-ID: <20190926174948.GE14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-16-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926164519.10471-16-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:14AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add miscellaneous utility functions and headers.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/osdep.h  |  108 ++
>  drivers/infiniband/hw/irdma/protos.h |   96 ++
>  drivers/infiniband/hw/irdma/status.h |   70 +
>  drivers/infiniband/hw/irdma/utils.c  | 2333 ++++++++++++++++++++++++++
>  4 files changed, 2607 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
>  create mode 100644 drivers/infiniband/hw/irdma/protos.h
>  create mode 100644 drivers/infiniband/hw/irdma/status.h
>  create mode 100644 drivers/infiniband/hw/irdma/utils.c
>
> diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
> new file mode 100644
> index 000000000000..5885b6fa413d
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/osdep.h
> @@ -0,0 +1,108 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2019, Intel Corporation. */
> +
> +#ifndef IRDMA_OSDEP_H
> +#define IRDMA_OSDEP_H
> +
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/vmalloc.h>
> +#include <linux/string.h>
> +#include <linux/bitops.h>
> +#include <linux/pci.h>
> +#include <net/tcp.h>
> +#include <crypto/hash.h>
> +/* get readq/writeq support for 32 bit kernels, use the low-first version */
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +
> +#define MAKEMASK(m, s) ((m) << (s))

It is a little bit over-macro.

Thanks
