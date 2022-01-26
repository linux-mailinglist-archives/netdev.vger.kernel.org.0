Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EDF49CE2D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiAZP2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiAZP2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:28:09 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295FDC06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:28:09 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 71so12582468qkf.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FoWrTy2NWPKvjNHcEknybF2wtcmlUtXoCJlZwJCG5OE=;
        b=GtHWe2YVWL3jzXyS54H21ibG3LiQO5j7gUanYx5kCO6jO/JCAGeWc0rnVOCuv7fBx7
         hUDXddwyQON5gNe65uBrSPyUpXnhsHaGSQFQ1sLXd57j/JOPiUVePpvfTPFvYmkw94kG
         bARNvxZe+ptiFnWC2hCP/jfc9n2TxjVvyMPvd8yHvwG7iLP16EH0qHHbTed/nnSHL6o/
         nH0w4wa76hoQqChfUzsVyOp/Ge0UPCL47f8Hlsx7Dz304DMpKuozbHj4AGfPvaUb7+VS
         1AxidQ93Oyn5BI+mokqBol82xw5syJqX6AzHv/3DPRu3seZlIRWSz9EzxYlIgBCzboSW
         IGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FoWrTy2NWPKvjNHcEknybF2wtcmlUtXoCJlZwJCG5OE=;
        b=uruShHAWtExmiwydq0IglewMWkfVDmsf3y+C4iVApxGkzI1oXU95Zbsvsb+bPeW57l
         +Ydg0UGU1dMAPtkAxdEPCX4avN2R0Au6zJ3+ulUO+fvWSlAat9n9ma2hqYm9JzLIrCj1
         x9jH/5Q+vgK9CNyZjFdyt/xM4shxbRikNIK2ieynIfG0ygPehMDt8pO2WfAPHLqwLmS4
         gQ0XXQ5H4waSKv/Au3A27yAt0HRpf22fQP/aBm8zedPcvUZt2f5OGXIqGN/jJSUOw7W2
         ZkcaYb8YhYldL4mv9dmT/g57WdJGwWUsbxnQ1mHJ8Gp79eGST8lSYCG0ryGaXpEM+3wy
         Swkw==
X-Gm-Message-State: AOAM531lBA5z+6Q39M9gUCldUZgRhdZozJP2IR2JTZ4z7QgAaBeT6Cvn
        DUrNKLDtcQevlNj1sYrFwyfdOw==
X-Google-Smtp-Source: ABdhPJzErmrOoHL7PaptmlxZjACbWTRVC80bJyoHWddltsUtiBYAkYOaly9k+QWsLg1aqmVP99s88g==
X-Received: by 2002:a05:620a:668:: with SMTP id a8mr8261127qkh.202.1643210888346;
        Wed, 26 Jan 2022 07:28:08 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id a141sm4515686qkc.73.2022.01.26.07.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:28:07 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nCkDO-005Zah-Si; Wed, 26 Jan 2022 11:28:06 -0400
Date:   Wed, 26 Jan 2022 11:28:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Leon Romanovsky <leon@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <20220126152806.GN8034@ziepe.ca>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 03:23:22PM +0800, Tony Lu wrote:
> On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> > 
> > Please CC RDMA mailing list next time.
> > 
> > Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> > ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> > logic.
> 
> I am working on replacing with ib_cq_pool_get(), this need ib_poll_context
> to indicate the poller which provides by ib_poll_handler(). It's okay
> for now, but for the callback function. When it polled a ib_wc, it
> would call wc->wr_cqe->done(cq, wc), which is the union with wr_id. The
> wr_id is heavily used in SMC.

Part of using the new interface is converting to use wr_cqe, you
should just do that work instead of trying to duplicate a core API in
a driver.

Jason
