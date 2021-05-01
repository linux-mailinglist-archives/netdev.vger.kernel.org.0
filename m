Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15EC370729
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhEAMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 08:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:37102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231972AbhEAMUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 08:20:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FBC5B253;
        Sat,  1 May 2021 12:19:48 +0000 (UTC)
Subject: Re: [RFC PATCH v4 09/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and
 NVMF_REQUIRED_OPTS definitions
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-10-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <62c750cb-b757-510e-a2fa-849f8f89d6e2@suse.de>
Date:   Sat, 1 May 2021 14:19:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-10-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
> to header file, so it can be used by transport modules.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/fabrics.c | 7 -------
>   drivers/nvme/host/fabrics.h | 7 +++++++
>   2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
> index 604ab0e5a2ad..55d7125c8483 100644
> --- a/drivers/nvme/host/fabrics.c
> +++ b/drivers/nvme/host/fabrics.c
> @@ -1001,13 +1001,6 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
>   }
>   EXPORT_SYMBOL_GPL(nvmf_free_options);
>   
> -#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> -#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
> -				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> -				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
> -				 NVMF_OPT_DISABLE_SQFLOW |\
> -				 NVMF_OPT_FAIL_FAST_TMO)
> -
>   static struct nvme_ctrl *
>   nvmf_create_ctrl(struct device *dev, const char *buf)
>   {
> diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
> index 888b108d87a4..b7627e8dcaaf 100644
> --- a/drivers/nvme/host/fabrics.h
> +++ b/drivers/nvme/host/fabrics.h
> @@ -68,6 +68,13 @@ enum {
>   	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
>   };
>   
> +#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> +#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
> +				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> +				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
> +				 NVMF_OPT_DISABLE_SQFLOW |\
> +				 NVMF_OPT_FAIL_FAST_TMO)
> +
>   /**
>    * struct nvmf_ctrl_options - Used to hold the options specified
>    *			      with the parsing opts enum.
> 

Why do you need them? None of the other transport drivers use them, why you?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
