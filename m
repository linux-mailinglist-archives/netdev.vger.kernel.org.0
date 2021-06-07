Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04A39E119
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFGPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:48:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55652 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFGPsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:48:02 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E70C91FDA5;
        Mon,  7 Jun 2021 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623080769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6X+lxKL1u5/eOeJjN6PYASQ1G5DrjjeKa0CNe67un7I=;
        b=RGuD5SsR1msLK3siKs9xdLspo0PSp93/9J0jcl05iGIIQ8Qp7Yhp2PJbeLrqZs63LtosrU
        zz0cYySqe23hxXTKkzN/EBOF/Z+s/GEDLM0TLMUlVVnnP8+hpQHbJ3PcENTYN8Mtb4xoy3
        XUHHLwkcLtBQUOFIWXXomDcVbzwpFwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623080769;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6X+lxKL1u5/eOeJjN6PYASQ1G5DrjjeKa0CNe67un7I=;
        b=GHeecwf530mrbLBiUPAMnLsWuKm7byYAsKm97Y1U94hf687Cya5MpCJtW9n6evNoZ81N1n
        YODo4jDq97aMhcDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 886D2118DD;
        Mon,  7 Jun 2021 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623080769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6X+lxKL1u5/eOeJjN6PYASQ1G5DrjjeKa0CNe67un7I=;
        b=RGuD5SsR1msLK3siKs9xdLspo0PSp93/9J0jcl05iGIIQ8Qp7Yhp2PJbeLrqZs63LtosrU
        zz0cYySqe23hxXTKkzN/EBOF/Z+s/GEDLM0TLMUlVVnnP8+hpQHbJ3PcENTYN8Mtb4xoy3
        XUHHLwkcLtBQUOFIWXXomDcVbzwpFwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623080769;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6X+lxKL1u5/eOeJjN6PYASQ1G5DrjjeKa0CNe67un7I=;
        b=GHeecwf530mrbLBiUPAMnLsWuKm7byYAsKm97Y1U94hf687Cya5MpCJtW9n6evNoZ81N1n
        YODo4jDq97aMhcDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id afmOIEE/vmBldwAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 15:46:09 +0000
Subject: Re: [PATCH 5/8] nvme-tcp-offload: Add controller level implementation
To:     Shai Malin <smalin@marvell.com>, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com, Arie Gershberg <agershberg@marvell.com>
References: <20210602184246.14184-1-smalin@marvell.com>
 <20210602184246.14184-6-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <87a2822c-c5ac-13d1-336a-b96045c3de5b@suse.de>
Date:   Mon, 7 Jun 2021 17:46:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602184246.14184-6-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/21 8:42 PM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> In this patch we implement controller level functionality including:
> - create_ctrl.
> - delete_ctrl.
> - free_ctrl.
> 
> The implementation is similar to other nvme fabrics modules, the main
> difference being that the nvme-tcp-offload ULP calls the vendor specific
> claim_dev() op with the given TCP/IP parameters to determine which device
> will be used for this controller.
> Once found, the vendor specific device and controller will be paired and
> kept in a controller list managed by the ULP.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  drivers/nvme/host/tcp-offload.c | 481 +++++++++++++++++++++++++++++++-
>  1 file changed, 476 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
