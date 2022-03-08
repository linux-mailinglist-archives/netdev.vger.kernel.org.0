Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1C44D1743
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiCHM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244994AbiCHM2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:28:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48967657F
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 04:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646742477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9pf/IVqL8yE3g13OAwcuAVKQfPo53FP6ApFVilX1pcQ=;
        b=Xaz6E9FHXNT6J8nKCeQJmJE9R8IQ+9Z+J8IXOZYBlK+atQseyg5fLkrUqOs4cTviXAFNTy
        vzEsf/eACI5+G4c29XbHiKpdoOUyhhxHZy9VfkjjcKkmZ81fvHp3gpsrTLESjCXA7tlqnd
        7hmmWiN9N8seC1pxM0u2a9ki4P9aCd0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-sdzBmpDFNture1Dt_UnGNQ-1; Tue, 08 Mar 2022 07:27:53 -0500
X-MC-Unique: sdzBmpDFNture1Dt_UnGNQ-1
Received: by mail-ed1-f70.google.com with SMTP id n11-20020aa7c68b000000b0041641550e11so4144768edq.8
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 04:27:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9pf/IVqL8yE3g13OAwcuAVKQfPo53FP6ApFVilX1pcQ=;
        b=mmYb0oGe89Fl66hG5CcPXWo7/9DHspBWe1HEbVocSv+fEybLj/18Vp8Koj5LsANrNj
         hTyHOqamHxArwTqsU8LG6WRP3kXh+aYpW7+ErkAz7q/bhbA2Y/TxFhfQmv/Sge0SynhT
         y2DrXBauYDS/CmsRhb8WPHhA63sBKQbFHPCpmLhm26bsTw/XPtQFDKxwdJ6jImXhxeSa
         FMJDmU9gxjOBeXxQy9LA8v4kxTatbucoI3g+pj7eM242egrs6Fk3GzFiSp/ikUSVB27/
         ct3E26aIEq71cYl/3eWezWosogZ2lDOMvM3wLJL5rUyrRi0Z403poJPCqXGTdUDs1yGZ
         a7dg==
X-Gm-Message-State: AOAM5328V+taVs5X5iPk6hFDewZ9biwZZHB5Ldx7dfRkmpqRUNbwA9ua
        2Mt17zvsirwhPedSR2W+wBiv0bVkNH3dKArntFuvWZXQRiJE4eGuprLk9+JgKYjgQ/bzibRkoWD
        uysHNolOnjYkliR4E
X-Received: by 2002:a17:907:7242:b0:6da:b561:d523 with SMTP id ds2-20020a170907724200b006dab561d523mr13282179ejc.118.1646742471610;
        Tue, 08 Mar 2022 04:27:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRLddVnWaTYQ7CEcx+H/uBDYSK5MuBK5kvSFUyJcedIYo1CrA8Y49v9huSdkQH7zA4WWcJdw==
X-Received: by 2002:a17:907:7242:b0:6da:b561:d523 with SMTP id ds2-20020a170907724200b006dab561d523mr13282150ejc.118.1646742471316;
        Tue, 08 Mar 2022 04:27:51 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id p24-20020a1709061b5800b006da6435cedcsm5786231ejg.132.2022.03.08.04.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:27:50 -0800 (PST)
Date:   Tue, 8 Mar 2022 07:27:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308071718-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
 <Yicer3yGg5rrdSIs@google.com>
 <YicolvcbY9VT6AKc@kroah.com>
 <20220308055003-mutt-send-email-mst@kernel.org>
 <YidBz7SxED2ii1Lh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YidBz7SxED2ii1Lh@kroah.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 12:45:19PM +0100, Greg KH wrote:
> On Tue, Mar 08, 2022 at 05:55:58AM -0500, Michael S. Tsirkin wrote:
> > On Tue, Mar 08, 2022 at 10:57:42AM +0100, Greg KH wrote:
> > > On Tue, Mar 08, 2022 at 09:15:27AM +0000, Lee Jones wrote:
> > > > On Tue, 08 Mar 2022, Greg KH wrote:
> > > > 
> > > > > On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > > > > > On Mon, 07 Mar 2022, Greg KH wrote:
> > > > > > 
> > > > > > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > > > 
> > > > > > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > > > > > capture possible future race conditions which may pop up over time.
> > > > > > > > 
> > > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > > > 
> > > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > ---
> > > > > > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > > > > > >  1 file changed, 10 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > > > > > --- a/drivers/vhost/vhost.c
> > > > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > > >  	int i;
> > > > > > > >  
> > > > > > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > > > > > +		/* No workers should run here by design. However, races have
> > > > > > > > +		 * previously occurred where drivers have been unable to flush
> > > > > > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > > > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > > > > > +		 * corruption in those cases does seem preferable.
> > > > > > > > +		 */
> > > > > > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > > > > 
> > > > > > > So you are trading one syzbot triggered issue for another one in the
> > > > > > > future?  :)
> > > > > > > 
> > > > > > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > > > > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > > > > > you want that to happen?
> > > > > > 
> > > > > > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> > > > > 
> > > > > Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> > > > > has resulted in a huge number of kernel fixes because of that.
> > > > 
> > > > Everything is customisable in syzkaller, so maybe there are specific
> > > > builds which panic_on_warn enabled, but none that I'm involved with
> > > > do.
> > > 
> > > Many systems run with panic-on-warn (i.e. the cloud), as they want to
> > > drop a box and restart it if anything goes wrong.
> > > 
> > > That's why syzbot reports on WARN_* calls.  They should never be
> > > reachable by userspace actions.
> > > 
> > > > Here follows a topical example.  The report above in the Link: tag
> > > > comes with a crashlog [0].  In there you can see the WARN() at the
> > > > bottom of vhost_dev_cleanup() trigger many times due to a populated
> > > > (non-flushed) worker list, before finally tripping the BUG() which
> > > > triggers the report:
> > > > 
> > > > [0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000
> > > 
> > > Ok, so both happens here.  But don't add a warning for something that
> > > can't happen.  Just handle it and move on.  It looks like you are
> > > handling it in this code, so please drop the WARN_ON().
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Hmm. Well this will mean if we ever reintroduce the bug then
> > syzkaller will not catch it for us :( And the bug is there,
> > it just results in a hard to reproduce error for userspace.
> 
> Is this an error you can recover from in the kernel?
>  What is userspace
> supposed to know with this information when it sees it?

IIUC we are talking about a use after free here since we somehow
managed to have a pointer to the device in a worker while
device is being destroyed.

That's the point of the warning as use after free is hard to debug. You
ask can we recover from a use after free? 

As regards to the added lock, IIUC it kind of shifts the use after free
window to later and since we zero out some of the memory just before we
free it, it's a bit more likely to recover.  I would still like to see
some more analysis on why the situation is always better than it was
before though.

> > Not sure what to do here. Export panic_on_warn flag to modules
> > and check it here?
> 
> Hah, no, never do that :)
> 
> thanks,
> 
> greg k-h

