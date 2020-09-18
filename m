Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D626FF64
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgIRN7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRN7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:59:17 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21774C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:59:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 19so5020852qtp.1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iDzy1sMgIGxVws9oU0uRMBwks6chpSBoUJBA5ZAPs6Y=;
        b=dZS+Pz8uPa7xZedC6ywyuba3H9rxNa8iD2FLUWjM9LYjV/vp0Nnwuxl4sIAH/WzJmo
         Z71YmWaPcUeza3JssOVlprHU4cGQ3yjZxah7wyneWO2mh86SvelVUNGd45Cqk9Yie1oG
         617Nev2Z7twgiRUh132ng7fDDjipACTM4bU0rYD4M+AA9ZUYUyf0U4tF3fwh8UPfh7cR
         ijQl8xM6r/btbx2DzAHfRisLO48r+cfseEBb/dQ/NLLKA9FIWvNEWjokBXGDc2fndUqW
         ScKssfiqwnp2XUoY0uD9YyQ4SnhhADwwA+/HFxDHtK2d76LmBhaSyZ9tPLqOZUnoOxnr
         5sUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iDzy1sMgIGxVws9oU0uRMBwks6chpSBoUJBA5ZAPs6Y=;
        b=RXONe3ham3DmPX/Jt485lSurQ7LufDc8XDNJh3C+izToLJIr+ZR2aCkJSud3spUeCk
         Ocr047yB4n/BUB615g1PeOPwcJnLhLVBUVskFGKjUhO6inx/2Zrb47ITiiwxRN4kpFRs
         NqYyqPFa6Ip5H4d1EHnSg1NIqsL+8ZIFyNalPjwx074xe61AAmyCRG6SCizTR27gAf1l
         D33Nh2vwlwKY3UjZA4boBdoJFvlA5gxhx0SNFb2IK8Ddkvm8UKIJ4Ji2qkVDQqUJxPCP
         AKXEkoyiVI2Qv6ZjjlUmVzvHVygtz5nIC4Qt+0u07O6NuPsSu/JqXPqdVWdNzJJVpUtT
         tSTA==
X-Gm-Message-State: AOAM5305fW6zMHBuOtjoLqxLooTRMccpFw5HhxAVkrVlPvn9F+SIa55n
        SsMKAALRL0Bjc3P59GuvnkJXmQ==
X-Google-Smtp-Source: ABdhPJxJEjIjl7tbKTQubndOek+3OibCxEDhsqhs1uDEM/H/kHLq/g77HjdghQ/1oNTy7EDlsPqX1w==
X-Received: by 2002:ac8:6e90:: with SMTP id c16mr33479531qtv.17.1600437556361;
        Fri, 18 Sep 2020 06:59:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v18sm2144966qtq.15.2020.09.18.06.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 06:59:15 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kJGux-001HHG-3h; Fri, 18 Sep 2020 10:59:15 -0300
Date:   Fri, 18 Sep 2020 10:59:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, izur@habana.ai,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918135915.GT8409@ziepe.ca>
References: <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca>
 <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca>
 <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca>
 <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca>
 <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 04:49:25PM +0300, Oded Gabbay wrote:
> On Fri, Sep 18, 2020 at 4:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Sep 18, 2020 at 04:02:24PM +0300, Oded Gabbay wrote:
> >
> > > The problem with MR is that the API doesn't let us return a new VA. It
> > > forces us to use the original VA that the Host OS allocated.
> >
> > If using the common MR API you'd have to assign a unique linear range
> > in the single device address map and record both the IOVA and the MMU
> > VA in the kernel struct.
> >
> > Then when submitting work using that MR lkey the kernel will adjust
> > the work VA using the equation (WORK_VA - IOVA) + MMU_VA before
> > forwarding to HW.
> >
> We can't do that. That will kill the performance. If for every
> submission I need to modify the packet's contents, the throughput will
> go downhill.

You clearly didn't read where I explained there is a fast path and
slow path expectation.

> Also, submissions to our RDMA qmans are coupled with submissions to
> our DMA/Compute QMANs. We can't separate those to different API calls.
> That will also kill performance and in addition, will prevent us from
> synchronizing all the engines.

Not sure I see why this is a problem. I already explained the fast
device specific path. 

As long as the kernel maintains proper security when it processes
submissions the driver can allow objects to cross between the two
domains.

Jason
