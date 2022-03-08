Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941BB4D11C5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344848AbiCHILo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344928AbiCHILa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:11:30 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02A83E5CB
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 00:10:10 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id b5so27158874wrr.2
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 00:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bC4nX/4w2hAp8ne90xPCyTuVT60oAJGeczdCQbo0l3c=;
        b=QmDNjmplj+bPdQf7fQe47SUylL4K0+DMOKwd1ybuiZGCaFLMOK8TYpXB5AN6ao8waC
         3RZ+8T5oBvLk7sE8SOLy3Vz1qthxs76QJ5vxuIzAQn2tIcCjEx/kMREVsJJ8aV8zKTVg
         H+F+0e0ovnAOA9t3tYMnV8ptAl5j9ZBM5bIKWPUDTYj1jx2IDv6Dcp/OPIkhOrvT1Iac
         sB/7dFSog87yqWl1RZnPK5SURyoAx5s88de7qeZCRoVaffTncrbKpLpjju3MFchUQ6KE
         gCpshgv7aHnKpeJNFdT71GJq6SZgRbqKt3YqoJwgKbGm57vDDUhGBEiKEsWqgdR+jPje
         ny/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bC4nX/4w2hAp8ne90xPCyTuVT60oAJGeczdCQbo0l3c=;
        b=S7vpaYlIA6k1bRMHCQsz9SL5ur5vM5ltnIbpFvxVsfAJt57MNFoQCqMmgf2gRSSvtT
         eyYFJZY3hFTJDESBBwJm9vM9+sbHCHggbsH5s9yEKSkLcRttc2E1qQpU0D4bripM1ibM
         PH/YuQ9idi3VjdtuMlc0QoEa6TcDYDmfzMr8lORb9/cpLmX5fzsOcWi4pPQcul7AJ8HA
         igRSD3TQ/4OzmdoKnt6n+hESu8R3E+wa8V7SQ10tZWzdap+QqcgiQRiy0Pc9S4R9VvrK
         W99YnV8G5rQFlzi0r31SZ6iCxsZd/9Gppx6FxR3dGmj011j+ggbLRq+oJc9s+aufSDsR
         r7CA==
X-Gm-Message-State: AOAM532MW/Zh8t7bEHSj+pvW+NUQVa8ZX3hm5+TTKOOZCF6gg/ymWu3u
        u1Nab+coBZuVmktZ8i/xBdjNuQ==
X-Google-Smtp-Source: ABdhPJzUt2KoS6npL3OLj00DKa4VkVnkLSkI4Qmgp881qSFd1k1FRRraWZrqYUd/ozCf3xX3VYvw8Q==
X-Received: by 2002:adf:dcc2:0:b0:1f0:4c38:d6be with SMTP id x2-20020adfdcc2000000b001f04c38d6bemr11263420wrm.79.1646727008778;
        Tue, 08 Mar 2022 00:10:08 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f20-20020a05600c4e9400b003898e252cd4sm1555824wmq.12.2022.03.08.00.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:10:08 -0800 (PST)
Date:   Tue, 8 Mar 2022 08:10:06 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YicPXnNFHpoJHcUN@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiZeB7l49KC2Y5Gz@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Mar 2022, Greg KH wrote:

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

No, Syzbot doesn't report warnings, only BUGs and memory corruption.

> And what happens if the mutex is locked _RIGHT_ after you checked it?
> You still have a race...

No, we miss a warning that one time.  Memory is still protected.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
