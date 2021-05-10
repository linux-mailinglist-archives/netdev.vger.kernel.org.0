Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC443798FC
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhEJVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhEJVPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 17:15:44 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3002C061760;
        Mon, 10 May 2021 14:14:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so26565966ejo.13;
        Mon, 10 May 2021 14:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QLbwo71WM0BJbAl/EGoecFLgUfzS3/y+qzgb6yim0eQ=;
        b=jlYnfAddH/GkSgMEWGHp977A5beAdWrxUdThq3kfnSzLyp7ZPpEvzNoLhTXVNgt+f8
         yYRmowpJn4Ietulh544wgPnGgWvtlfdpBS62omN+jGXSpLlTSMKpC/H5wJkLc8W9IbLa
         bI2QDTOF9+nb1/P34B+XicqiAAE62TFgaTsbG9KqEWg4KBAE5jBIDDBtRi1AzFMZuwau
         7KkUhAJfKAPI8cKFt7gJ5CeDmRO2rPHtGPSg4cs0iGxSBsCxqJHstI+GmilN1daGqQt8
         f9Uu6k0OPtL+8ifAvdDb5R5vg1xaINcxR7T07fHcByVgu433/EbyHe6aHsp9OarD6k3o
         wyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QLbwo71WM0BJbAl/EGoecFLgUfzS3/y+qzgb6yim0eQ=;
        b=gUmma5FPVveRJ8hJVqkVtEJGDYT45QKPGDPKdPMep2aWUNB4uhv1UxvQiWnjyrLttR
         5oS+qQaS2aiy61T41Q6AMEj29bDVh22hXzsuI9xG87Zgko/J9nH+5M6Mjb2z8ZsMhiXj
         V5mGA2NM8DBYMmbwNqOWMNmGGSNCQ3vgrKSK+Jx+YhiVmUzOdaCe/4RBsSm2TTOptAly
         aa9Rx8DCoqXHop0DN/LcR1WEXIZhI2j/lDXKfgAds1KBp/jD03nfFeNNNBiZTDJ7mSA9
         WbTCtn6siHFx2d41lzZ1EghSolGiiOAPgBKX/pQuuLJSykr8yaFMmiRBh5fJGGLrGZAT
         y3xw==
X-Gm-Message-State: AOAM530QZqlVg8W+Z8TVZl7/4Ca0gVvlbjk87+5XMAD7NRYgvWEOR+A/
        q4307yrcUpggdq52aOBviwk=
X-Google-Smtp-Source: ABdhPJzbVrrnc7dXAiA9/aIhC+j3qP2USOh/TV01Pu6cZARE6/RyGNr0cKJaMRdTlvu0GrfWXJwkbQ==
X-Received: by 2002:a17:906:8468:: with SMTP id hx8mr27906682ejc.18.1620681277586;
        Mon, 10 May 2021 14:14:37 -0700 (PDT)
Received: from anparri ([151.76.108.233])
        by smtp.gmail.com with ESMTPSA id k5sm13962223edk.46.2021.05.10.14.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:14:37 -0700 (PDT)
Date:   Mon, 10 May 2021 23:14:30 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to
 generate requestIDs
Message-ID: <20210510211430.GA370521@anparri>
References: <20210415105926.3688-1-parri.andrea@gmail.com>
 <MWHPR21MB15936B2FBD1C1FE91C654F3DD74D9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210506174516.aiuuhu7oediqozv4@liuwe-devbox-debian-v2>
 <20210510173321.lfw4nha7wrzfgkkd@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510173321.lfw4nha7wrzfgkkd@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 05:33:21PM +0000, Wei Liu wrote:
> On Thu, May 06, 2021 at 05:45:16PM +0000, Wei Liu wrote:
> > On Thu, Apr 15, 2021 at 01:22:32PM +0000, Michael Kelley wrote:
> > > From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, April 15, 2021 3:59 AM
> > > > 
> > > > Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> > > > all issues with allocating enough entries in the VMbus requestor.
> > > > 
> > > > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > > > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > > > ---
> > > > Changes since RFC:
> > > >   - pass sentinel values for {init,reset}_request in vmbus_sendpacket()
> > > >   - remove/inline the storvsc_request_addr() callback
> > > >   - make storvsc_next_request_id() 'static'
> > > >   - add code to handle the case of an unsolicited message from Hyper-V
> > > >   - other minor/style changes
> > > > 
> > > > [1] https://lore.kernel.org/linux-hyperv/20210408161315.341888-1-parri.andrea@gmail.com/
> > > > 
> > > >  drivers/hv/channel.c              | 14 ++---
> > > >  drivers/hv/ring_buffer.c          | 13 +++--
> > > >  drivers/net/hyperv/netvsc.c       |  8 ++-
> > > >  drivers/net/hyperv/rndis_filter.c |  2 +
> > > >  drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
> > > >  include/linux/hyperv.h            | 13 ++++-
> > > >  6 files changed, 95 insertions(+), 49 deletions(-)
> > > 
> > > LGTM
> > > 
> > > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> > 
> > Although this patch is tagged with SCSI, I think it would be better if
> > this goes through the hyperv tree. Let me know if there is any
> > objection.
> 
> Andrea, please rebase this patch on top of hyperv-next. It does not
> apply as-is.

Sent  https://lkml.kernel.org/r/20210510210841.370472-1-parri.andrea@gmail.com

Thanks,
  Andrea
