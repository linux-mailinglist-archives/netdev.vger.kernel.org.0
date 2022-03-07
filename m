Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1D74D0B48
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343816AbiCGWkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238584AbiCGWku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:40:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B49726FE
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646692794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJJnjNEDLDCxgTnNZiuLduAW9RdSuGCDd7yDQswPSHQ=;
        b=bM30475l+wKaH6ygQqbs2XsnHmdr3MyoYfOgYQsCTdjH/KHz2RvVOvGoTUWEMSLGTDigIf
        g1ASOTnZ6BvBaxclTFi9mRiYQoEUvm4x9qLrmz8IP1JgLhc7xn7T3vrij7HdSPvAZehgKR
        lhWKo+GzgT6o0IkJGu5g8F08jqYgY38=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-SmnvaDl3NzOI1C6tSx4rCA-1; Mon, 07 Mar 2022 17:39:53 -0500
X-MC-Unique: SmnvaDl3NzOI1C6tSx4rCA-1
Received: by mail-ed1-f72.google.com with SMTP id cf6-20020a0564020b8600b00415e9b35c81so91408edb.9
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 14:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJJnjNEDLDCxgTnNZiuLduAW9RdSuGCDd7yDQswPSHQ=;
        b=eftPsD/SCebg70qSgHd1GpHDKUBvhMJGB4n8tJjW3yMpRzB1YhyXjN3dSbF2T7lA9G
         EMteo4Vmf3Zgc5quT1F7wbmrXU5vxAIKgFqnejZbpKY89QQ4w2XrUIS0bqPBue1mUGxC
         QQSAaXGgGDSKtQVO2scR7/pHg2gq46csJwMFnpl/PnPZKnYm+YlLhcNRnXKo/aYVCgcG
         7bWctX0/03yjXQt1bcby03MZbC689hdIFUw4AICjWpeqsCrRaryvGhrVAqJ77U5MXX6t
         G1jZRo6LPF1m+u6UC2ho0bCPmUJDX6d6kNayJRVIsB/LxUvc1aajMxlT/UPSBSBRuamK
         rUAw==
X-Gm-Message-State: AOAM531i60gte57AOhopYznre2TERZ9ClcZjM180Ua9j2joijULk0SZw
        o0So61y3cB9meRJ0uzFxn2uOTZcGvAWI1BzI5kB4ZPnBKtEJGHnWOo6/vp6ZhZTpU6xy39NaT5Q
        +hZGJcGilOMlBgmCc
X-Received: by 2002:a50:f68b:0:b0:415:a36c:5c0b with SMTP id d11-20020a50f68b000000b00415a36c5c0bmr13019187edn.272.1646692791966;
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHmg2BC0xk8nWy9xaqU2GCk4lH6furT6guufXi8TPI/KI61k1O7Q5pN2MxtI0peMXSX0VM9Q==
X-Received: by 2002:a50:f68b:0:b0:415:a36c:5c0b with SMTP id d11-20020a50f68b000000b00415a36c5c0bmr13019168edn.272.1646692791770;
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id gf17-20020a170906e21100b006da960ce78dsm4913346ejb.59.2022.03.07.14.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
Date:   Mon, 7 Mar 2022 17:39:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220307173807-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiZeB7l49KC2Y5Gz@kroah.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 08:33:27PM +0100, Greg KH wrote:
> On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Also WARN() as a precautionary measure.  The purpose of this is to
> > capture possible future race conditions which may pop up over time.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe28..ef7e371e3e649 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	int i;
> >  
> >  	for (i = 0; i < dev->nvqs; ++i) {
> > +		/* No workers should run here by design. However, races have
> > +		 * previously occurred where drivers have been unable to flush
> > +		 * all work properly prior to clean-up.  Without a successful
> > +		 * flush the guest will malfunction, but avoiding host memory
> > +		 * corruption in those cases does seem preferable.
> > +		 */
> > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> 
> So you are trading one syzbot triggered issue for another one in the
> future?  :)
> 
> If this ever can happen, handle it, but don't log it with a WARN_ON() as
> that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> you want that to happen?
> 
> And what happens if the mutex is locked _RIGHT_ after you checked it?
> You still have a race...
> 
> thanks,
> 
> greg k-h

Well it's a symptom of a kernel bug. I guess people with panic on
warn are not worried about DOS and more worried about integrity
and security ... am I right?

-- 
MST

