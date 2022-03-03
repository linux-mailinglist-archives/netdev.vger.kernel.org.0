Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0564CC618
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiCCTjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiCCTjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:39:16 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E665A156
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 11:38:30 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t11so9426305wrm.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 11:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=K/Uvx4MIMduNNDUv4nDfaCXMVJaGsHQl+DgmzbLveXQ=;
        b=e2UXZ2yMHjPpoZgPSa1aRHFYjLtrivnIS2MfokW9t+URqQaA2lz0Jk892K6CpV4Can
         fI2Dn7TVWCTVCMo/IbIhYVani9D/KsdjabsR13UQNjbxDvfYT8FQqnms61kik5HvSXLT
         8SNiyCOcpYUsDJd96EhjKTrn3qFsYHWOaiFvG0v+Og2ywiklUW45/qieIvuFe1kRN2Wq
         ABfxlSHYHSh1PvX3ydZW9WZP4x+sro+5PnYnjrbSJ035qgD5eiQXMsShISpMlpJsBfwc
         YCl4eCNMO1TVH1gA4Q/kAgG5fFFQ+sSGPMS9WqK3+W5lARa245KVDXUOXwNKDeEdoEMx
         XvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=K/Uvx4MIMduNNDUv4nDfaCXMVJaGsHQl+DgmzbLveXQ=;
        b=ugEOL5Cukxade8nnKUSr6jHhl/Cpn9lXCJ64kGfJ+UPh4al38tAceTLJSdw7bOLGEE
         ywPnNxaNo+dwcnfc7V6WCNsWw4rslwd6pTSEroIIt/G+HGNYMuX+Y6VgmcWgGLIGUgmK
         7EJTIJSRkS6LhXqUdcujOdWXUb/JUnBsZ6dqWus0QhSK4ltfr8vI19dSoYCmXswas6CI
         MVLCNtlx5b3OH5yWIf+St4fckot6oK9S+qmdN0Mc5+/9qHkw+zkfGrZ8raVzUTZne0eA
         wWCZB5M+pKxu3vB3qN336HDmEXvbI3RtbMxiJH4Av8f6iTrsNqX7AoZI90a+H/7eCbCZ
         UuSA==
X-Gm-Message-State: AOAM531Dm2o2132ZRqlN3eVn8PZo0s+fHi+6OqqQm/xTsd/FSbI+AWq0
        URHNlfIgq7mhkMSv6Siobpwjdg==
X-Google-Smtp-Source: ABdhPJxF1hwyx/TulXuxizSn127hf9j+oayH5mwMGUSVqCtOFlbiXVw7t2v5rHwBQTtwhb5/KdQc7A==
X-Received: by 2002:a5d:43c2:0:b0:1ed:c331:9a96 with SMTP id v2-20020a5d43c2000000b001edc3319a96mr29299741wrr.389.1646336308813;
        Thu, 03 Mar 2022 11:38:28 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id bi21-20020a05600c3d9500b003814de297fcsm9093215wmb.16.2022.03.03.11.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:38:28 -0800 (PST)
Date:   Thu, 3 Mar 2022 19:38:24 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <YiEZMHJ6urZTffsq@google.com>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
 <YiETnIcfZCLb63oB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiETnIcfZCLb63oB@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Mar 2022, Leon Romanovsky wrote:

> On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
> > All workers/users should be halted before any clean-up should take place.
> > 
> > Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index bbaff6a5e21b8..d935d2506963f 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	int i;
> >  
> >  	for (i = 0; i < dev->nvqs; ++i) {
> > +		/* Ideally all workers should be stopped prior to clean-up */
> > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > +
> >  		mutex_lock(&dev->vqs[i]->mutex);
> 
> I know nothing about vhost, but this construction and patch looks
> strange to me.
> 
> If all workers were stopped, you won't need mutex_lock(). The mutex_lock
> here suggests to me that workers can still run here.

The suggestion for this patch came from the maintainer.

Please see the conversation here:

https://lore.kernel.org/all/20220302082021-mutt-send-email-mst@kernel.org/

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
