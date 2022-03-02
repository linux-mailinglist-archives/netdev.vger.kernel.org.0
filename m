Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C924CA888
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbiCBOwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiCBOwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:52:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DD9C38D8D
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 06:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646232682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3fg7E/wVm9novw7LlU1TTAanfNBt/gec/yk4Cr2PfyA=;
        b=GE4niSKGMmhshxyzfwYjF2BQ+Wz8keS7UGQaBpjgpDXnGMo7ije85e/0N/0Qn+3jxY8woW
        zlqN7jmCMZFzLQsWrp4zMbf+RMn58DWHe3qvTAhjOKJ7O1NwXY8nKVJz617J+ocn1Pj2c2
        fHYySwU1FnJxIYqem49rrgJ+MDcIerM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-Qkb1z88LPsmukTZ2NqbBtg-1; Wed, 02 Mar 2022 09:51:21 -0500
X-MC-Unique: Qkb1z88LPsmukTZ2NqbBtg-1
Received: by mail-wr1-f72.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so720121wrg.20
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 06:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3fg7E/wVm9novw7LlU1TTAanfNBt/gec/yk4Cr2PfyA=;
        b=FfzniTq6FXZE8XRaV55UVloWFDOGqSIjspnT/OnApKv6gw4up963OAkcm12s9wVor+
         UMqel4WYHQxn/mKYxT/huyeGsncy+5D9VgwfJR3iFad8hNjAoX0Qp4/HgICId4Gmn9y7
         2Alo3TAXWI9VzKqVX6VoMZ3JvGPGWVQobnvtCdFsQKj5Yz9fK8eToOY52SttLO2e/0Lm
         vbFz/Ntf7E4S/AcilxE68ob1aB+lhyCg0W5bL+lzJZ9uIDwTkelHCL43BKhnh6wk4z7T
         Arw6kbod3Bp6iWAflDPtn5vkpwyQCxQiEbQTudWKOAw9u3vldD61BTYdRUjJyUDGXoU1
         QAQg==
X-Gm-Message-State: AOAM531eGuZK/tYpUZt6iLk7Sl72qfLRmpt596+4uOsxNQMpYPT7ioZX
        BbQyO2TPqvniQMn0R1xen5iGFEm9OdfyOT3nE7uob+OzqejzO9LQJGpv4noPg2s1ltb8MGYV/FA
        R3qa3TLAA6jyrFQ+T
X-Received: by 2002:a1c:a382:0:b0:381:cfd:5564 with SMTP id m124-20020a1ca382000000b003810cfd5564mr94724wme.103.1646232678504;
        Wed, 02 Mar 2022 06:51:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgG53zJnBs87t0enH1Vr7OSUpE9VmdGsUbPEG/nzyOU4NmiWiPZnySacnC9rSCzqe/3NX4wg==
X-Received: by 2002:a1c:a382:0:b0:381:cfd:5564 with SMTP id m124-20020a1ca382000000b003810cfd5564mr94706wme.103.1646232678251;
        Wed, 02 Mar 2022 06:51:18 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c2f0100b00381821b4dbdsm5737493wmn.6.2022.03.02.06.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:51:16 -0800 (PST)
Date:   Wed, 2 Mar 2022 09:51:13 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302095045-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yh93k2ZKJBIYQJjp@google.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> 
> > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > during virtqueue clean-up and we mitigate the reported issues.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/vhost/vhost.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  	int i;
> > >  
> > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > +		mutex_lock(&dev->vqs[i]->mutex);
> > >  		if (dev->vqs[i]->error_ctx)
> > >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > >  		if (dev->vqs[i]->kick)
> > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  		if (dev->vqs[i]->call_ctx.ctx)
> > >  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > >  		vhost_vq_reset(dev, dev->vqs[i]);
> > > +		mutex_unlock(&dev->vqs[i]->mutex);
> > >  	}
> > 
> > So this is a mitigation plan but the bug is still there though
> > we don't know exactly what it is.  I would prefer adding something like
> > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> 
> As a rework to this, or as a subsequent patch?

Can be a separate patch.

> Just before the first lock I assume?

I guess so, yes.

> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog

