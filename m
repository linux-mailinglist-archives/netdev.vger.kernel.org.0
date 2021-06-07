Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5432539E139
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFGPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:51:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39242 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhFGPvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:51:39 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 642FE219B6;
        Mon,  7 Jun 2021 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623080987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8DP83ezEIRx09dRuboZviqfN18ugIBwF8ldlpJk2No=;
        b=cHxfr4TB9WZQ8+5qJ1EWxRYVA6pR1OD531xB1fpbRSca9OMNFjHK+gtz0cq76cP2Pt1xLZ
        IOAtA2KEthX1QU3mbxyi8RZX9zyFYEaKCNzrOIDJ6NgvEnG/aYu05kes1HgHAAEPjA1ZFO
        pw/yQxVFwzt60l1FcZYqaaYU+oIDSOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623080987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8DP83ezEIRx09dRuboZviqfN18ugIBwF8ldlpJk2No=;
        b=lOLp5JUGNHQpER+764JZSLjcvk09v+PXHCE8W2bMDggoVEth6lN6fkGjwKXophdQLoIwWa
        lObGzkGH55Z7N7AA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 3AE64118DD;
        Mon,  7 Jun 2021 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623080987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8DP83ezEIRx09dRuboZviqfN18ugIBwF8ldlpJk2No=;
        b=cHxfr4TB9WZQ8+5qJ1EWxRYVA6pR1OD531xB1fpbRSca9OMNFjHK+gtz0cq76cP2Pt1xLZ
        IOAtA2KEthX1QU3mbxyi8RZX9zyFYEaKCNzrOIDJ6NgvEnG/aYu05kes1HgHAAEPjA1ZFO
        pw/yQxVFwzt60l1FcZYqaaYU+oIDSOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623080987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8DP83ezEIRx09dRuboZviqfN18ugIBwF8ldlpJk2No=;
        b=lOLp5JUGNHQpER+764JZSLjcvk09v+PXHCE8W2bMDggoVEth6lN6fkGjwKXophdQLoIwWa
        lObGzkGH55Z7N7AA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 25LqDRtAvmBieQAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 15:49:47 +0000
Subject: Re: [PATCH 7/8] nvme-tcp-offload: Add queue level implementation
To:     Shai Malin <smalin@marvell.com>, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com, Dean Balandin <dbalandin@marvell.com>
References: <20210602184246.14184-1-smalin@marvell.com>
 <20210602184246.14184-8-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <68d83513-aaf1-4956-367e-ab69ca1d37ce@suse.de>
Date:   Mon, 7 Jun 2021 17:49:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602184246.14184-8-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/21 8:42 PM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> In this patch we implement queue level functionality.
> The implementation is similar to the nvme-tcp module, the main
> difference being that we call the vendor specific create_queue op which
> creates the TCP connection, and NVMeTPC connection including
> icreq+icresp negotiation.
> Once create_queue returns successfully, we can move on to the fabrics
> connect.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  drivers/nvme/host/tcp-offload.c | 417 +++++++++++++++++++++++++++++---
>  drivers/nvme/host/tcp-offload.h |   4 +
>  2 files changed, 393 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
