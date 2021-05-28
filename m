Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8683394243
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhE1MDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:03:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41208 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbhE1MDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:03:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8DCA61FD2E;
        Fri, 28 May 2021 12:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622203288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28Ql1fFOwHfGvjGlsFOqzm5hrcryr9KIZc8+TcoIlRA=;
        b=rfafd+TeaZQrNT39BKAX1RgJ+bcYD/Rs3rHs8N/q64d5raxAWfffo2hBplr9OS0X2cljrS
        ftNyY2bvIxXMaQWL81+Ruuff+jiBlgu8TySAp8aPxUJmelVxlPcRr/KXGWVtZ/mCm6uaBd
        JKc1Y1ziwpGBA6Zh2OT1P/4oG3CdI1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622203288;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28Ql1fFOwHfGvjGlsFOqzm5hrcryr9KIZc8+TcoIlRA=;
        b=U6d5DrMBqQcLRms71v6dqZknwv6Qigi+BZowmQsVUAnr6JvfWr2VvtAi15m3P74nKSwz9m
        LnJUGMj5odjdosAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 56F0A11A98;
        Fri, 28 May 2021 12:01:28 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 6Hx9FJjbsGCqGQAALh3uQQ
        (envelope-from <hare@suse.de>); Fri, 28 May 2021 12:01:28 +0000
Subject: Re: [RFC PATCH v6 10/27] qed: Add NVMeTCP Offload PF Level FW and HW
 HSI
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-11-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <e83f1143-042e-0e0a-01e1-8e8720f8ffa8@suse.de>
Date:   Fri, 28 May 2021 14:01:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-11-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> This patch introduces the NVMeTCP device and PF level HSI and HSI
> functionality in order to initialize and interact with the HW device.
> The patch also adds qed NVMeTCP personality.
> 
> This patch is based on the qede, qedr, qedi, qedf drivers HSI.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/Kconfig           |   3 +
>  drivers/net/ethernet/qlogic/qed/Makefile      |   2 +
>  drivers/net/ethernet/qlogic/qed/qed.h         |   5 +
>  drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  26 ++
>  drivers/net/ethernet/qlogic/qed/qed_dev.c     |  48 ++-
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h     |   4 +-
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  32 +-
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c     |   3 +
>  drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |   3 +-
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c | 282 ++++++++++++++++++
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  51 ++++
>  drivers/net/ethernet/qlogic/qed/qed_ooo.c     |   3 +-
>  drivers/net/ethernet/qlogic/qed/qed_sp.h      |   2 +
>  .../net/ethernet/qlogic/qed/qed_sp_commands.c |   1 +
>  include/linux/qed/nvmetcp_common.h            |  54 ++++
>  include/linux/qed/qed_if.h                    |  22 ++
>  include/linux/qed/qed_nvmetcp_if.h            |  72 +++++
>  17 files changed, 593 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
>  create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
>  create mode 100644 include/linux/qed/nvmetcp_common.h
>  create mode 100644 include/linux/qed/qed_nvmetcp_if.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
