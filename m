Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A43940CC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhE1KUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:20:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40186 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbhE1KUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:20:34 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1144A1FD2E;
        Fri, 28 May 2021 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622197138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBhUat4GnoA52vhi8JcgynrGRIIB4YwYrSWLCjF2Sr4=;
        b=EdSfkLqyDHiAd7FJQDYMa164amxKYbz7iftFwmLekoj9t7FCDOhfcAGqs+tqlUVB4/CBG0
        oOd0UNwx7lA+buiCE+eJ3DZ9p7Q4mlBsgGTbz3PGeX6TBbz8+Z8UyLSt6hD7Yhu6sykR1U
        hXqavcSZAu0WviEfg8aiGEi/j8N0558=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622197138;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBhUat4GnoA52vhi8JcgynrGRIIB4YwYrSWLCjF2Sr4=;
        b=7g63VftgwsXoUjqdPKXqlYISWrleEyV2XlA/R6kcGQp2Bgk8r8gbFmyBcfXAoCFmyrGWJ4
        FqlIDoIdHyuAc9Aw==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id D065711A98;
        Fri, 28 May 2021 10:18:57 +0000 (UTC)
Subject: Re: [RFC PATCH v6 03/27] nvme-fabrics: Expose
 nvmf_check_required_opts() globally
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210527235902.2185-1-smalin@marvell.com>
 <20210527235902.2185-4-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <f37e7e6f-be53-ca80-b170-311e52d687a1@suse.de>
Date:   Fri, 28 May 2021 12:18:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210527235902.2185-4-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 1:58 AM, Shai Malin wrote:
> From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> nvmf_check_required_opts() is used to check if user provided opts has
> the required_opts or not. if not, it will log which options are not
> provided.
> 
> It can be leveraged by nvme-tcp-offload to check if provided opts are
> supported by this specific vendor driver or not.
> 
> So expose nvmf_check_required_opts() globally.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/nvme/host/fabrics.c | 5 +++--
>  drivers/nvme/host/fabrics.h | 2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
