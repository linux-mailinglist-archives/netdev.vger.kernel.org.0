Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EAC26FD88
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgIRMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIRMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:50:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E3AC061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:50:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so5884718qka.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KAoPuTEzUmIe2wdxaRxMUqqp3YdtmLOZgXAXpjKRNsk=;
        b=QyJDbsqV+Clftle8r/t/pW701Y/xrp6nUJ3MlzmLFCL32GerNaErkVHXxBR5FtLcuE
         DjRIlx9mDzvwBV1qDo2wZUwIjWI27lrH2c1lCsovl4kYcbSdvNnau+k8cP18rJSDvG1L
         sGi0QcjouM6J0NHgJEdxsmuLb3yLqhb99Dq2cRUle5JcDjD22B1rCwyCq9YY86oIVbCw
         QqJzm+r2mcrE75S6SO/bTsMGVaezkZTEKr9uRuGfKtn3NSzQPYnRQGxjpOKopN4HgsfS
         kFr7dzmb/BHaUb7btWWeU259YSwwO8x+I1AuoJLMaULNgrqkMdz0EImj6xmYaymMrEzv
         g1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KAoPuTEzUmIe2wdxaRxMUqqp3YdtmLOZgXAXpjKRNsk=;
        b=VCJe+zC/C6FaiepL9PRTHJTQvjKlDaY+iVajMobpyw0ZIum99K5gboQwiCpNXnxic9
         HIgPblwqsaeXDjFqp+wgGryI3EJ7WmymD4oDb+bqdtaT3tu8bfwXImUUqQNqt+ZCFmxh
         bsvCDjFEvOWKSM4wSCnLIhGHQllY/TcZCE8ol1NZ5e3B24CG2SO3NjJrYig/gn9Spfoq
         IAJ41GzriLPp77oZpLkDxgbyss6Vue3d68nsGCrXwsCxblGaiTu2nYsZ7Fz9XiiNPBQo
         pK0uk254ldIxZnhVNlaVXB6WOE98jxBFkQ69Wb+3fRwmu+d40emuGUk8CYfD6G311ciY
         txug==
X-Gm-Message-State: AOAM5318qhVNVNez9Z40RoNqWL6WyqUBCzSmvdQq5a0fUqfFYP1tBsNU
        M/jxLmM/C3yF5kFw0mPj2sYHeQ==
X-Google-Smtp-Source: ABdhPJw907l05mss1ldyLf/9wiOK6C5YwGtGpEhTGyHGuXCXNATWIp2kIEIi+FlDBdV5O02aKx9WRQ==
X-Received: by 2002:a37:4a57:: with SMTP id x84mr32144214qka.17.1600433416085;
        Fri, 18 Sep 2020 05:50:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id i5sm1927930qko.86.2020.09.18.05.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:50:15 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kJFqA-000z9a-Ua; Fri, 18 Sep 2020 09:50:14 -0300
Date:   Fri, 18 Sep 2020 09:50:14 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     izur@habana.ai, Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918125014.GR8409@ziepe.ca>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca>
 <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca>
 <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 03:34:54PM +0300, Oded Gabbay wrote:
> > > Another example is that the submission of WQ is done through our QMAN
> > > mechanism and is NOT mapped to userspace (due to the restrictions you
> > > mentioned above and other restrictions).
> >
> > Sure, other RDMA drivers also require a kernel ioctl for command
> > execution.
> >
> > In this model the MR can be a software construct, again representing a
> > security authorization:
> >
> > - A 'full process' MR, in which case the kernel command excution
> >   handles dma map and pinning at command execution time
> > - A 'normal' MR, in which case the DMA list is pre-created and the
> >   command execution just re-uses this data
> >
> > The general requirement for RDMA is the same as DRM, you must provide
> > enough code in rdma-core to show how the device works, and minimally
> > test it. EFA uses ibv_ud_pingpong, and some pyverbs tests IIRC.
> >
> > So you'll want to arrange something where the default MR and PD
> > mechanisms do something workable on this device, like auto-open the
> > misc FD when building the PD, and support the 'normal' MR flow for
> > command execution.
> 
> I don't know how we can support MR because we can't support any
> virtual address on the host. Our internal MMU doesn't support 64-bits.
> We investigated in the past, very much wanted to use IBverbs but
> didn't figure out how to make it work.
> I'm adding Itay here and he can also shed more details on that.

I'm not sure what that means, if the driver intends to DMA from
process memory then it certainly has a MR concept. 

MRs can control the IOVA directly so if you say the HW needs a MR IOVA
< 2**32 then that is still OK.

Jason
