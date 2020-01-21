Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71333144122
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAUQAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgAUQAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:00:18 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF08217F4;
        Tue, 21 Jan 2020 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579622417;
        bh=ZFYk5ekHyabOghrVOademvyhLzqhW17ZooWX2WUjBCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCpuanlcriRAanyLgiICqIYuVF95Xq2+YkDi6/GsvNIxlDo32RE4KusbSr08l6QhQ
         ln014SnTqectIejbV9TX1lfqPHs0JHYfGQe9dBuC011B2qu6Fk1yXS4BPbbKEHCMKD
         r9KNEX0p64YppoKP3ixMVSll+4p1aIRvLvA41oXk=
Date:   Tue, 21 Jan 2020 08:00:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 01/17] octeontx2-pf: Add Marvell OcteonTX2 NIC driver
Message-ID: <20200121080015.0875a4bd@cakuba>
In-Reply-To: <1579612911-24497-2-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-2-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:35 +0530, sunil.kovvuri@gmail.com wrote:
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
> +	if (err) {
> +		dev_err(dev, "Unable to set DMA mask\n");
> +		goto err_release_regions;
> +	}
> +
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
> +	if (err) {
> +		dev_err(dev, "Unable to set consistent DMA mask\n");
> +		goto err_release_regions;
> +	}

please convert to using dma_set_mask_and_coherent()
