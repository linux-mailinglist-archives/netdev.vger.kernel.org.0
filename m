Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200BF42FD44
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbhJOVO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234257AbhJOVOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 17:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634332368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weAZOzcimLn9TcTx54d1qD50QofXmr04GPHd/Nkp3yc=;
        b=JObowBwiSYH/dtQ2WF5Xhp+N1votHfxEusaYGOjnthQbfmdUNpCOLeL3Aq+4QF4tqoLgOe
        swcCnUflagmPPbB1Vu87bkkShcK8hE8zy47igfmpnw54Gm147jCMQtt5eRf+1K36Nw73NT
        iriEinVdfRaXehtDYJAGhIRJAeLM03o=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-kyh_y3fWPYmlGxJACcG-Aw-1; Fri, 15 Oct 2021 17:12:47 -0400
X-MC-Unique: kyh_y3fWPYmlGxJACcG-Aw-1
Received: by mail-ot1-f72.google.com with SMTP id y22-20020a9d4616000000b0054e84ab2a68so6292174ote.16
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 14:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=weAZOzcimLn9TcTx54d1qD50QofXmr04GPHd/Nkp3yc=;
        b=8Mr5W5gGkOeDW0DTA7udvH6qgqec4tSK60Gj7kp4sBpBG9kyq1WqIWOCczfeAfkYmv
         USbSTISsSMz6ND1O1uAUs6b8r959ZvD1ZmY5WgbB2w/wTS03RnUPgZRpvT13CxrusAum
         erADqlCvRaMB6BPStdeE1GLA8wyC/OmoNEzDy9tHCxn1NTLt6MlGudbd4gBBhBbWfADa
         1umsaTR3O8rQTrCpSRro0s/TiEUBBnoKQmbP/yHDT6zE3vtl3BsloVFf7k3NWHecMtc+
         trkxzIeGKkymR5/uS2mvo4sn+qP93ZF59omXdCR38IcFj8DKYgxnV9XFSRYYhL+rY4ol
         djSw==
X-Gm-Message-State: AOAM531SKIOAKLfH367kwsVBt+E3t0DMeCgEBPfXtT4qKt+dYZ11rM0Z
        70nybgA+UmxvGZbt1AASpsqdgs9hChL3m79e/0sAmzMb2pKHEptq2S3dVdz56LhE85UbHVma0Yq
        BIVarc37EaVoYdgy8
X-Received: by 2002:a4a:b282:: with SMTP id k2mr10450166ooo.11.1634332366171;
        Fri, 15 Oct 2021 14:12:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoAojjBNArO7t601HnDHe1CSsfX+KCR+pGZCiebFDNtXd/IxGPbZjTG6dLcXRMcmQeR3Rs9g==
X-Received: by 2002:a4a:b282:: with SMTP id k2mr10450141ooo.11.1634332365962;
        Fri, 15 Oct 2021 14:12:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q15sm1434362otm.15.2021.10.15.14.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 14:12:45 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:12:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let
 vfio_pci_core drivers trap device RESET
Message-ID: <20211015151243.3c5b0910.alex.williamson@redhat.com>
In-Reply-To: <20211015200328.GG2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-13-yishaih@nvidia.com>
        <20211015135237.759fe688.alex.williamson@redhat.com>
        <20211015200328.GG2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 17:03:28 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Oct 15, 2021 at 01:52:37PM -0600, Alex Williamson wrote:
> > On Wed, 13 Oct 2021 12:47:06 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> > > Add infrastructure to let vfio_pci_core drivers trap device RESET.
> > > 
> > > The motivation for this is to let the underlay driver be aware that
> > > reset was done and set its internal state accordingly.  
> > 
> > I think the intention of the uAPI here is that the migration error
> > state is exited specifically via the reset ioctl.  Maybe that should be
> > made more clear, but variant drivers can already wrap the core ioctl
> > for the purpose of determining that mechanism of reset has occurred.  
> 
> It is not just recovering the error state.
> 
> Any transition to reset changes the firmware state. Eg if userspace
> uses one of the other emulation paths to trigger the reset after
> putting the device off running then the driver state and FW state
> become desynchronized.
> 
> So all the reset paths need to be synchronized some how, either
> blocked while in non-running states or aligning the SW state with the
> new post-reset FW state.

This only catches the two flavors of FLR and the RESET ioctl itself, so
we've got gaps relative to "all the reset paths" anyway.  I'm also
concerned about adding arbitrary callbacks for every case that it gets
too cumbersome to write a wrapper for the existing callbacks.

However, why is this a vfio thing when we have the
pci_error_handlers.reset_done callback.  At best this ought to be
redundant to that.  Thanks,

Alex

