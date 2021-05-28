Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259AC3941D6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhE1Lcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 07:32:53 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40984 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbhE1Lck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 07:32:40 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BFDA51FD2F;
        Fri, 28 May 2021 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622201464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJxw7UVf69eXF5UvmrTiRioEhsiAIBBjkR3QOPBQWqA=;
        b=Kw8Tio8ovbOgf6ivMADd7BKZC/Oew6uQNeDoHqg7JS99zRxabEBCE1FIddCCVZhDCDk0QU
        SDz50C4blhi2Ijza+iTcCo9vW/Y5jstAYu23Dw/O2Jlh3gPsQgko2dVVxPDI5iuIP9Ticw
        LpAcHkW2t3rA1g6YwcxwLW36qVhMKPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622201464;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJxw7UVf69eXF5UvmrTiRioEhsiAIBBjkR3QOPBQWqA=;
        b=7HcCEusNIaAt8A+nIKqI3BMx9427wzbUaWQwGZIQImxOafcOIgeS6HwN3HZyg+h2RBQ8he
        HML+CmNk4TmJq5Cw==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 9378D11906;
        Fri, 28 May 2021 11:31:04 +0000 (UTC)
Subject: Re: [RFC PATCH v6 09/27] qed: Add TCP_ULP FW resource layout
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-10-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <4df85c04-16d6-478a-f55d-16042952bbc1@suse.de>
Date:   Fri, 28 May 2021 13:31:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-10-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> From: Omkar Kulkarni <okulkarni@marvell.com>
> 
> Add TCP_ULP as a storage common TCP offlload FW resource layout.
> This will be used by the core driver (QED) for both the NVMeTCP and iSCSI.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
>  drivers/net/ethernet/qlogic/qed/qed_cxt.c     | 18 ++++++++---------
>  drivers/net/ethernet/qlogic/qed/qed_cxt.h     |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_dev.c     |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_iscsi.c   | 20 +++++++++----------
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c     |  8 ++++----
>  drivers/net/ethernet/qlogic/qed/qed_ooo.c     |  2 +-
>  .../net/ethernet/qlogic/qed/qed_sp_commands.c |  2 +-
>  include/linux/qed/common_hsi.h                |  2 +-
>  include/linux/qed/qed_ll2_if.h                |  2 +-
>  11 files changed, 31 insertions(+), 30 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
