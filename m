Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBC26FBD8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIRL4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRL4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 07:56:03 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6F8C061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 04:56:03 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 19so4695230qtp.1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 04:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rnCNcyJ+ORHL39eFsoxo9j43T2JZmnemtJ7xnuqJTTw=;
        b=idvuJUf39ImMnIkNPJw+e/xsqkztf+s87K9ceQolnf4rklPo+VY8BwYxoacQIL2s0G
         D8MbovXigKCHoDQPheETO0msn42Bh5TuGmuMb891JFVuL+M9VtVcmwi92Ur9YEqFpZzF
         r1BWPek0KI5hXi9phON1b2iBGm8eaIn5jT8YmaIrORxCQXQAQL2ZigN+QuEDwyR+1sE6
         wJqv782gfx+5Kxje49CKpTUh1wqwY/JABgFIPsdL5be7qczXQMGAZPC/BgZ9NkgFKWdf
         VA5M+BoqYN557QrJvJ5WVlbNdNHgaw58BaCfT0t0oQ8HY6jsL1mCOqDdGo41KmTXno/0
         BS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rnCNcyJ+ORHL39eFsoxo9j43T2JZmnemtJ7xnuqJTTw=;
        b=iNa5IT01JYZi5BNlf8vDIz88ZadBFgowgrd8VK409IwsHgtc879CWonbkbXGCTrm6Z
         6GD72DpsCEvgP/cpNF1AnMqyEnW3M/x29rv4qPQ4DvnNnj4DnPERRxAIFTEHzQYJiyPE
         q28kdYqYRFJwR4LSRTVpx/XbDG7ghuu1Y7yEyHM3f/fT3Jwi0tW7f58+vJJTu0LUH0/Z
         leAK4slDJHGz++mAYVMyPT6N9guY+NLEAGqYJhjYacSlglc8Ims75XG7hmF0iTphiSPx
         PRn+Hf4nBFu9lK0ljwBG/c6Ql16QVW3yV12EQHXn9FVArTGOJUKNC8jN8oNDxKesnLim
         gBRw==
X-Gm-Message-State: AOAM531cxXGibZ9MkoxDicPWQuhfT02UD62D+9xDFBzCy7AtBf+Jbyhp
        MA6NiciUBnwG/dzI0GKqXj9ghQ==
X-Google-Smtp-Source: ABdhPJwqutILUpQIvYSS2YDA/0alNrYIPEY1qiLGYegrS4klzj+HRmTGg5QAi1WTL1jsv6eTnaA/OA==
X-Received: by 2002:ac8:3902:: with SMTP id s2mr33474369qtb.258.1600430162485;
        Fri, 18 Sep 2020 04:56:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x49sm1968116qtc.94.2020.09.18.04.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 04:56:01 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kJEzh-000wpa-7y; Fri, 18 Sep 2020 08:56:01 -0300
Date:   Fri, 18 Sep 2020 08:56:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918115601.GP8409@ziepe.ca>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> >> infrastructure for communication between multiple accelerators. Same
> >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> >> The RDMA implementation we did does NOT support some basic RDMA
> >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> >> library or to connect to the rdma infrastructure in the kernel. 
> > 
> > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > you can't add random device offloads as IOCTL to nedevs.
> > 
> > RDMA is the proper home for all the networking offloads that don't fit
> > into netdev.
> > 
> > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > all. I'm sure this can too.
> 
> Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> was suggested to go through the vfio subsystem instead.
> 
> I think this comes back to the discussion we had when EFA was upstreamed, which
> is what's the bar to get accepted to the RDMA subsystem.
> IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).

That is more or less where we ended up, yes.

I'm most worried about this lack of PD and MR.

Kernel must provide security for apps doing user DMA, PD and MR do
this. If the device doesn't have PD/MR then it is hard to see how a WQ
could ever be exposed directly to userspace, regardless of subsystem.

Jason
