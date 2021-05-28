Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C87B3940CB
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhE1KUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:20:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60552 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbhE1KT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:19:59 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3A043218B3;
        Fri, 28 May 2021 10:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622197104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xwzxPsqkRs33JFbxt2zkP1hnKW16XUAwJ7jZ33Dcx0=;
        b=n4cgimD+8eAxXX+9t7cHQRlox6GheamXBsS6fKXLEWMvvdGdp4n4fRT3qzZCFmG7Hz1cVP
        SXhJHUY9FjZ/TDKextxTosQ75U2V4tKhsHzqysBHME5t+6ZxS1+BcwCFX51lAjrBhVYbRq
        wW6TK6l7OQUsXt4IcxuANaHMnTx5wzA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622197104;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xwzxPsqkRs33JFbxt2zkP1hnKW16XUAwJ7jZ33Dcx0=;
        b=G86OMUJ6ggBLRJl3meZkVluLc/THDuA1OyKH5AKI31Mrh/vF8pth6EfdaTDW7mla5Tc9D0
        L+GMv7jjgThdASCg==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id EDE0211A98;
        Fri, 28 May 2021 10:18:23 +0000 (UTC)
Subject: Re: [RFC PATCH v6 02/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and
 NVMF_REQUIRED_OPTS definitions
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-3-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <e0a36dc7-f5f2-e7b6-7368-323769c54caa@suse.de>
Date:   Fri, 28 May 2021 12:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-3-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
> to header file, so it can be used by the different HW devices.
> 
> NVMeTCP offload devices might have different limitations of the
> allowed options, for example, a device that does not support all the
> queue types. With tcp and rdma, only the nvme-tcp and nvme-rdma layers
> handle those attributes and the HW devices do not create any limitations
> for the allowed options.
> 
> An alternative design could be to add separate fields in nvme_tcp_ofld_ops
> such as max_hw_sectors and max_segments that we already have in this
> series.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Acked-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/host/fabrics.c | 7 -------
>  drivers/nvme/host/fabrics.h | 7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
