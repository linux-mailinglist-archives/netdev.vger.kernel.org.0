Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3C4CCFB2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 09:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiCDIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 03:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiCDINY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 03:13:24 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C6639E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 00:12:34 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r10so11458849wrp.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 00:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PTdhZ6zTG/wMEQhhzfPXGyXVYLVkCG56MpdGyRnOBVI=;
        b=Pmf2t9u+18kQH7IAPgSpCA8+P+Pr1LWI/Tnym4Tf38VqtV68KuJxIBW4bz4aPRJb7s
         FotOKu54Ei94IvCyVqRrl3FPSfRUncnyiIlnU/gYuZnoq7Lp93cs41oeygcIV6cQWiQL
         3MqAnA5QDBaQ76T9FM4jXL35WVoP0kdTjBo02o5U7BmCPeIfVlgf1fuVY/ZVIo6k/Bvm
         /8rQrxARhXJyy5IhFazUmOWGxxwpnwpYZApUBX1LMBi+4TpzForlhGfpPZ1v06IHBqCo
         vNZme2896fgkl8UDxpGKdaTOhqhgzNRhyfLG+ckucf1XBRWoKrlE9DureanSDGxQXV4j
         0p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PTdhZ6zTG/wMEQhhzfPXGyXVYLVkCG56MpdGyRnOBVI=;
        b=X2hRYIr7HNtf18riWcIbKEfHEJKEtU+52hb46A/WVpZ9CUtmc1/gAt4ycY7TXhM9+S
         3Zs4FZ9nD0eGWnCsnK5tqHG3QeCXPvuEwIteQMLipaj8Wwmh+kRPig2vFPzygCN10tv9
         9DXtZxiovthGwvix6zBguBI2OmfVtd9jcbl535hYzEzuASLX9pageaSNDSK2UEt9a/MY
         ALUGG8gz98SXji5iHo2YBbP05PnlB/OMx/N2QCD/eJL5uO43K2pJHF0yTHfA0xiFTDck
         3zsDM6cAKitsQCKK2Ql5QhKzYzJD5LuSFPG56w1f5gRBHyGe6YgtdFnqsBMGTuPMqh2V
         dotw==
X-Gm-Message-State: AOAM532vtG+XU1q3h4TtFDsQ8pG+KbDScUawZXRZmGApY9T3nxzk+qRl
        pVLfCVay2QSPCWHr1G1eqylp3A==
X-Google-Smtp-Source: ABdhPJzVw968hxMEIY0q2+bwjpWc6NSOwZs/15JsNkWcbOqqbxojEzQRti0Lz26wnPm3h5o1K7KOTg==
X-Received: by 2002:a05:6000:184e:b0:1f0:3569:ccac with SMTP id c14-20020a056000184e00b001f03569ccacmr8266477wri.680.1646381552773;
        Fri, 04 Mar 2022 00:12:32 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b0037c0342cb62sm13850215wmq.4.2022.03.04.00.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 00:12:32 -0800 (PST)
Date:   Fri, 4 Mar 2022 08:12:30 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <YiHJ7qFgkcC7igwq@google.com>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
 <YiETnIcfZCLb63oB@unreal>
 <20220303155645-mutt-send-email-mst@kernel.org>
 <20220304075039.rewrf3gnbbh3sdfl@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220304075039.rewrf3gnbbh3sdfl@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Mar 2022, Stefano Garzarella wrote:

> On Thu, Mar 03, 2022 at 04:01:06PM -0500, Michael S. Tsirkin wrote:
> > On Thu, Mar 03, 2022 at 09:14:36PM +0200, Leon Romanovsky wrote:
> > > On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
> > > > All workers/users should be halted before any clean-up should take place.
> > > >
> > > > Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index bbaff6a5e21b8..d935d2506963f 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  	int i;
> > > >
> > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > +		/* Ideally all workers should be stopped prior to clean-up */
> > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > +
> > > >  		mutex_lock(&dev->vqs[i]->mutex);
> > > 
> > > I know nothing about vhost, but this construction and patch looks
> > > strange to me.
> > > 
> > > If all workers were stopped, you won't need mutex_lock(). The mutex_lock
> > > here suggests to me that workers can still run here.
> > > 
> > > Thanks
> > 
> > 
> > "Ideally" here is misleading, we need a bigger detailed comment
> > along the lines of:
> > 
> > /*
> > * By design, no workers can run here. But if there's a bug and the
> > * driver did not flush all work properly then they might, and we
> > * encountered such bugs in the past.  With no proper flush guest won't
> > * work correctly but avoiding host memory corruption in this case
> > * sounds like a good idea.
> > */
> 
> Can we use vhost_vq_get_backend() to check this situation?
> 
> IIUC all the vhost devices clear the backend to stop the workers.
> This is not racy (if we do after the mutex_lock) and should cover all cases.

I can look into this too if you like.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
