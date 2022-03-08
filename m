Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75D4D18F1
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347083AbiCHNSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbiCHNSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:18:05 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9381348E76
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:17:07 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u1so28461793wrg.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DlKhxu+LqVz17YluSD/2WMyqg3I/bzdDeK8Xd5lH4Nc=;
        b=tUpT+l/kDbEnrxwoPe0cSlkoHFeIwcOIW34nEeAfTPLzg9g3X3m+2wb+kf6CF5WruS
         0uHfQcbl0j3HUZrgH5zNoEOadjHjWWZTyypxkET0RXrAYoWU0Jt3Pjv8KbMxMvpb3KVR
         glykef1q0jt6Zr/UshpSLSB5H5CAsbcCvI9ZGfV21RY3q4jb1xdUew2vLy55dsDZ2dlc
         m47imykZZVCdCkiLfI+A7NccsHLepDUnd3nnTWnCLXuKfrtxE+P8Uv5OeWTBry+vJB7z
         9Mi2D4JmgdpMQ82s+1oeuJaLQRSx5zs4EUGATFnb4xNMQ6XQwISOyNY7NOI1gjPJpyeK
         uTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DlKhxu+LqVz17YluSD/2WMyqg3I/bzdDeK8Xd5lH4Nc=;
        b=lmqh9Ktct8cxGu9goEhRcmuro8PQpPb7gJ+Hp26HU2bJJlwrinc6AcgDhleTQSfklo
         n0usNAZ48ttJVugFvMgJ3nAYu5luolr1vZofzdryS1zm/qNnRfP6tENTQRqFIJ7enypP
         U6JpZudBx1ypVGn+nr7uRc2caCDf3HdwjKOe+GpRP2YWJIaB1WbvKoPV3KLlO4v1WB7g
         GNirKx0tETUxbhvmjKFgM/+XTU+dBqCFp5xNIfPDAanpiBwheJapHEmZpSMci6HLkLio
         2/Vx4jLSFj7Tm1PY/IG33QbkBiUMgqYhF3J7McXem/8GZjRBSbWpr99NtJpwkCCHksol
         65sQ==
X-Gm-Message-State: AOAM5315yAgdbIFd0rcdoFcNQR1gFekax0SZnkCagQGXJfBGqEbhDduR
        I70TVUEGHTPJGTtBm32fx2cosw==
X-Google-Smtp-Source: ABdhPJwbgYMOFPI4IWRNj/NoVcAezAtsLTQB67NBB/7Wxh6IySHxoNz1f7HejTNRMpjkOwC4T7R9yw==
X-Received: by 2002:a05:6000:1acf:b0:1f0:5e62:9b28 with SMTP id i15-20020a0560001acf00b001f05e629b28mr11817701wry.448.1646745426018;
        Tue, 08 Mar 2022 05:17:06 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b002036515dda7sm2022427wru.33.2022.03.08.05.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:17:05 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:17:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YidXT6zP1QN5KZUs@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
 <Yicer3yGg5rrdSIs@google.com>
 <YicolvcbY9VT6AKc@kroah.com>
 <20220308055003-mutt-send-email-mst@kernel.org>
 <YidBz7SxED2ii1Lh@kroah.com>
 <20220308071718-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308071718-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Mar 2022, Michael S. Tsirkin wrote:

> On Tue, Mar 08, 2022 at 12:45:19PM +0100, Greg KH wrote:
> > On Tue, Mar 08, 2022 at 05:55:58AM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Mar 08, 2022 at 10:57:42AM +0100, Greg KH wrote:
> > > > On Tue, Mar 08, 2022 at 09:15:27AM +0000, Lee Jones wrote:
> > > > > On Tue, 08 Mar 2022, Greg KH wrote:
> > > > > 
> > > > > > On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > > > > > > On Mon, 07 Mar 2022, Greg KH wrote:
> > > > > > > 
> > > > > > > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > > > > 
> > > > > > > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > > > > > > capture possible future race conditions which may pop up over time.
> > > > > > > > > 
> > > > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > > > > 
> > > > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > > ---
> > > > > > > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > > > > > > >  1 file changed, 10 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > > > > > > --- a/drivers/vhost/vhost.c
> > > > > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > > > >  	int i;
> > > > > > > > >  
> > > > > > > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > > > > > > +		/* No workers should run here by design. However, races have
> > > > > > > > > +		 * previously occurred where drivers have been unable to flush
> > > > > > > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > > > > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > > > > > > +		 * corruption in those cases does seem preferable.
> > > > > > > > > +		 */
> > > > > > > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > > > > > 
> > > > > > > > So you are trading one syzbot triggered issue for another one in the
> > > > > > > > future?  :)
> > > > > > > > 
> > > > > > > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > > > > > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > > > > > > you want that to happen?
> > > > > > > 
> > > > > > > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> > > > > > 
> > > > > > Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> > > > > > has resulted in a huge number of kernel fixes because of that.
> > > > > 
> > > > > Everything is customisable in syzkaller, so maybe there are specific
> > > > > builds which panic_on_warn enabled, but none that I'm involved with
> > > > > do.
> > > > 
> > > > Many systems run with panic-on-warn (i.e. the cloud), as they want to
> > > > drop a box and restart it if anything goes wrong.
> > > > 
> > > > That's why syzbot reports on WARN_* calls.  They should never be
> > > > reachable by userspace actions.
> > > > 
> > > > > Here follows a topical example.  The report above in the Link: tag
> > > > > comes with a crashlog [0].  In there you can see the WARN() at the
> > > > > bottom of vhost_dev_cleanup() trigger many times due to a populated
> > > > > (non-flushed) worker list, before finally tripping the BUG() which
> > > > > triggers the report:
> > > > > 
> > > > > [0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000
> > > > 
> > > > Ok, so both happens here.  But don't add a warning for something that
> > > > can't happen.  Just handle it and move on.  It looks like you are
> > > > handling it in this code, so please drop the WARN_ON().
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Hmm. Well this will mean if we ever reintroduce the bug then
> > > syzkaller will not catch it for us :( And the bug is there,
> > > it just results in a hard to reproduce error for userspace.
> > 
> > Is this an error you can recover from in the kernel?
> >  What is userspace
> > supposed to know with this information when it sees it?
> 
> IIUC we are talking about a use after free here since we somehow
> managed to have a pointer to the device in a worker while
> device is being destroyed.
> 
> That's the point of the warning as use after free is hard to debug. You
> ask can we recover from a use after free? 
> 
> As regards to the added lock, IIUC it kind of shifts the use after free
> window to later and since we zero out some of the memory just before we
> free it, it's a bit more likely to recover.  I would still like to see
> some more analysis on why the situation is always better than it was
> before though.

With the locks in place, the UAF should not occur.

The issue here is that you have 2 different tasks processing the
same area of memory (via pointers to structs).  In these scenarios you
should always provide locking and/or reference counting to prevent
memory corruption or UAF.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
