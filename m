Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3126B41DEEC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350583AbhI3Q0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350367AbhI3Q01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 12:26:27 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE56C06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 09:24:44 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id q81so6395942qke.5
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 09:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oVCTC+nt3p3+hMxDZO10YpzPmIzmwpHDbufnIhpB5sw=;
        b=Qzvudx/7eTIRT7u9f/lsM4lO+MLgg9dJvfErxgBhnEydnevVQWd23+D5YUSGowYATg
         5LHFyriFS29ECLsNuDA85jLdOXHfRyzXgbJK/06ZjgAk8HVJonpWUIlnVMatc67PxWT1
         dn7yqZLpL85aZ8BeVtsKxdoUsWqTIj59egY14M/B//S1wnOh3KRf/3FL55A1Ucv+9BLn
         jZPeDKdfHkv+LAbUR5/w9ZQdrTCYAyvVBBbLp+uFkKln1Y/zLhjlaaUsKhBgTmEBItm+
         qlUqzUZVxpXlGnSKyFyL0+KmJa1pa0URiUh1DxnXvMKSutxbzIzA/l2jhx2tK1C9ilDH
         ds/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oVCTC+nt3p3+hMxDZO10YpzPmIzmwpHDbufnIhpB5sw=;
        b=V5OTzDmUEXwmH2NlqgQoiG4m4PBoVp2cAl9RuGuhxAnbZOD3DoTIwLM13Xl5sSRLUD
         HkPSRBdLMj4mb0/3xPSdDA6N8Udduz2R5A6E9uHDA6vyFavlO0uBMDAuQc5HTFaAcE8e
         yxwdYflHoCf4nDypTsba4kNcxUdHKLr2bFwsmvZvw6wlN4aR9zEevkvyFHrjPNYDduQ9
         TL5CLPUoIxSKbOfCjyVeilm3YJQ657w+Uean9FjoP2odJIMKpdlro7sYI8Z4JN1U5e4h
         FuXi1pvT8v6LHlOhJZBM6xc8GldUJXNP2slReDqjgbRFVKFaXMM00eHsKwFpiSBUNB94
         jyAQ==
X-Gm-Message-State: AOAM533At52BrHlobPpCB2k1wK51X719ZdGLl0qVImYNZaa+FLxyNjb2
        Wv3dd47s4ydzbF33pJyj4G80pw==
X-Google-Smtp-Source: ABdhPJwg8n4C63Fas9mtIKb7ayOW8k3lmOKYhJda6CIKMcYnXdwDezyohMM/ijUu5YJfcNLzaFD4WA==
X-Received: by 2002:a37:d4f:: with SMTP id 76mr5649048qkn.385.1633019083624;
        Thu, 30 Sep 2021 09:24:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id y15sm1798840qko.78.2021.09.30.09.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 09:24:43 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mVyrS-000Hjq-5V; Thu, 30 Sep 2021 13:24:42 -0300
Date:   Thu, 30 Sep 2021 13:24:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210930162442.GB67618@ziepe.ca>
References: <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
 <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
 <20210930144752.GA67618@ziepe.ca>
 <d5b68bb7-d4d3-e9d8-1834-dba505bb8595@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5b68bb7-d4d3-e9d8-1834-dba505bb8595@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 06:32:07PM +0300, Max Gurtovoy wrote:
> > Just prior to open device the vfio pci layer will generate a FLR to
> > the function so we expect that post open_device has a fresh from reset
> > fully running device state.
> 
> running also mean that the device doesn't have a clue on its internal state
> ? or running means unfreezed and unquiesced ?

The device just got FLR'd and it should be in a clean state and
operating. Think the VM is booting for the first time.

> > > > driver will see RESUMING toggle off so it will trigger a
> > > > de-serialization
> > > You mean stop serialization ?
> > No, I mean it will take all the migration data that has been uploaded
> > through the migration region and de-serialize it into active device
> > state.
> 
> you should feed the device way before that.

I don't know what this means, when the resuming bit is set the
migration data buffer is wiped and userspace should beging loading
it. When the resuming bit is cleared whatever is in the migration
buffer is deserialized into the current device internal state.

It is the opposite of saving. When the saving bit is set the current
device state is serialized into the migration buffer and userspace and
reads it out.

> 1. you initialize at  _RUNNING bit == 001b. No problem.
> 
> 2. state stream arrives, migration SW raise _RESUMING bit. should it be 101b
> or 100b ? for now it's 100b. But according to your statement is should be
> 101b (invalid today) since device state can change. right ?

Running means the device state chanages independently, the controlled
change of the device state via deserializing the migration buffer is
different. Both running and saving commands need running to be zero.

ie commands that are marked invalid in the uapi comment are rejected
at the start - and that is probably the core helper we should provide.

> 3. Then you should indicate that all the state was serialized to the device
> (actually to all the pci devices). 100b mean RESUMING and not RUNNING so
> maybe this can say RESUMED and state can't change now ?

State is not loaded into the device until the resuming bit is
cleared. There is no RESUMED state until we incorporate Artem's
proposal for an additional bit eg 1001b - running with DMA master
disabled.

Jason
