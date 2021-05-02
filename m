Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD7370B59
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhEBLio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:38:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:42426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhEBLin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:38:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DBAA0AE00;
        Sun,  2 May 2021 11:37:50 +0000 (UTC)
Subject: Re: [RFC PATCH v4 20/27] qedn: Add connection-level slowpath
 functionality
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-21-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <95009c8e-330f-fd99-781c-cb2b80263ba2@suse.de>
Date:   Sun, 2 May 2021 13:37:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-21-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> This patch will present the connection (queue) level slowpath
> implementation relevant for create_queue flow.
> 
> The internal implementation:
> - Add per controller slowpath workqeueue via pre_setup_ctrl
> 
> - qedn_main.c:
>    Includes qedn's implementation of the create_queue op.
> 
> - qedn_conn.c will include main slowpath connection level functions,
>    including:
>      1. Per-queue resources allocation.
>      2. Creating a new connection.
>      3. Offloading the connection to the FW for TCP handshake.
>      4. Destroy of a connection.
>      5. Support of delete and free controller.
>      6. TCP port management via qed_fetch_tcp_port, qed_return_tcp_port
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/hw/qedn/Makefile    |   5 +-
>   drivers/nvme/hw/qedn/qedn.h      | 173 ++++++++++-
>   drivers/nvme/hw/qedn/qedn_conn.c | 508 +++++++++++++++++++++++++++++++
>   drivers/nvme/hw/qedn/qedn_main.c | 208 ++++++++++++-
>   4 files changed, 883 insertions(+), 11 deletions(-)
>   create mode 100644 drivers/nvme/hw/qedn/qedn_conn.c
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
