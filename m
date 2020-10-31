Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802DC2A1340
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 04:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgJaDER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 23:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgJaDEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 23:04:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20505C0613D8
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 20:04:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s35so170646pjd.1
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 20:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dOaiRG7nzOcew4Z/xa4Y9xhaCfEOzzX+L3+jYCW8uRY=;
        b=DMAwc6lK6ZUTOXaQLELuJb+DLulnLu/TsWegaajGm8rDAtlcvhxuJl1EYsOxRgJK4L
         l/OVWkCKS7qxsdxQ1U+ryuVkJdqO4HLjatwwu2Mcz0AsfY1ZVaKdN61cnWnodQTsw0vW
         C8ONCAMQ9/JH2jR8SNL5mGZpx7n1AfO7pE9/2SX4QssIgCmNzaVJSzrjTASk6EyXRrA9
         4J9tlWmXfQfKSts8AhH+O3O76q/lMHF+9tnJy11zK11B74LYHixhLk1puRbVBgg4+sev
         dheLcfIYTDi8yIVsP5Ir8k4a3p5MZsjQyd0z+Hhbxp9Q4Zc3T/06Xe9XR+fhlR6NDMcK
         laVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dOaiRG7nzOcew4Z/xa4Y9xhaCfEOzzX+L3+jYCW8uRY=;
        b=YgfSUL8nLI3V1Ryr/6gSWnvtF6MTqO/Wkjy9vcONFqeIpuP4Jart4MvMKTP/fimzpg
         H8/P2OBVksuEUSzpl2xFXQvcvj3ExWloZ894Ni0iAl+llF0VnDsOohfltmPVyYzjxArZ
         6j7bUy/0IoByomUa+cqQ7EZHdHuBqCdVJQ/Vn4YAMngY7EBBgHG3eQqbaf+y8hlBTFUp
         8PfVbZTHRpkGFSYELJQn23pizI8soXvB9pYeM5lcTNE4VDZNoOSguj2KHPJKeIFN+47g
         cJwsN2UE7peeeb/HJJLcCSuUPKp34+8VBPHggmZuGlmDJhJeJyGWfTQRLoAOOkfybswc
         clcQ==
X-Gm-Message-State: AOAM532Uv/FzQqiCwuSj/FziDZk4WgbvDngqv1y04hrBr/pYTvQ36zvw
        Nj2GwPEUWbd4YM1nLE1Xn3dR
X-Google-Smtp-Source: ABdhPJzjVcvaGvc+ZvZMF2wQLN0gJBl5ruQ7dMt0KnAS41Bf5OA37Aed06fGLQnAGelK7iHJFRfjZw==
X-Received: by 2002:a17:90a:8d08:: with SMTP id c8mr6308573pjo.33.1604113452797;
        Fri, 30 Oct 2020 20:04:12 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:6097:a88a:8051:aa6b:aaa2:8d63])
        by smtp.gmail.com with ESMTPSA id i123sm7096266pfc.13.2020.10.30.20.04.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Oct 2020 20:04:11 -0700 (PDT)
Date:   Sat, 31 Oct 2020 08:34:05 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v11 4/4] bus: mhi: Add userspace client interface driver
Message-ID: <20201031030405.GA4664@Mani-XPS-13-9360>
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
 <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
 <20201030103410.GD3818@Mani-XPS-13-9360>
 <5cfbcc14-5fd2-b1ae-8a3d-ac28d567a74d@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cfbcc14-5fd2-b1ae-8a3d-ac28d567a74d@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Hemant,

On Fri, Oct 30, 2020 at 06:26:38PM -0700, Hemant Kumar wrote:
> Hi Mani,
> 
> On 10/30/20 3:34 AM, Manivannan Sadhasivam wrote:
> > Hi Hemant,
> > 
> > On Thu, Oct 29, 2020 at 07:45:46PM -0700, Hemant Kumar wrote:
> > > This MHI client driver allows userspace clients to transfer
> > > raw data between MHI device and host using standard file operations.
> > > Driver instantiates UCI device object which is associated to device
> > > file node. UCI device object instantiates UCI channel object when device
> > > file node is opened. UCI channel object is used to manage MHI channels
> > > by calling MHI core APIs for read and write operations. MHI channels
> > > are started as part of device open(). MHI channels remain in start
> > > state until last release() is called on UCI device file node. Device
> > > file node is created with format
> > > 
> > > /dev/mhi_<controller_name>_<mhi_device_name>
> > > 
> > > Currently it supports LOOPBACK channel.
> > > 
> > > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > 
> > Thanks for continuously updating the series based on reviews, now the locking
> > part looks a _lot_ cleaner than it used to be. I just have one query (inline)
> > regarding the usage of refcount for uci_chan and uci_dev. Once you fix that,
> > I think this is good to go in.
> Thanks for reviewing my changes.
> 
> [..]
> 
> > > +#define DEVICE_NAME "mhi"
> > > +#define MHI_UCI_DRIVER_NAME "mhi_uci"
> > > +#define MAX_UCI_MINORS 128
> > 
> > Prefix MHI for these.
> Done.
> 
> > 
> > > +
> > > +static DEFINE_IDR(uci_idr);
> > > +static DEFINE_MUTEX(uci_drv_mutex);
> > > +static struct class *uci_dev_class;
> > > +static int uci_dev_major;
> > > +
> > > +/**
> > > + * struct uci_chan - MHI channel for a UCI device
> > > + * @udev: associated UCI device object
> > > + * @ul_wq: wait queue for writer
> > > + * @write_lock: mutex write lock for ul channel
> > > + * @dl_wq: wait queue for reader
> > > + * @read_lock: mutex read lock for dl channel
> > > + * @dl_pending_lock: spin lock for dl_pending list
> > > + * @dl_pending: list of dl buffers userspace is waiting to read
> > > + * @cur_buf: current buffer userspace is reading
> > > + * @dl_size: size of the current dl buffer userspace is reading
> > > + * @ref_count: uci_chan reference count
> > > + */
> > > +struct uci_chan {
> > > +	struct uci_dev *udev;
> > > +	wait_queue_head_t ul_wq;
> > > +
> > > +	/* ul channel lock to synchronize multiple writes */
> > 
> > I asked you to move these comments to Kdoc in previous iteration.
> There are multiple revisions of UCI pushed after i responded on this one. On
> V7 i responded to your comment  :)
> 
> "This was added because checkpatch --strict required to add a comment when
> lock is added to struct, after adding inline comment, checkpatch error was
> gone."
> 
> i was sticking to --strict option. Considering it is best to address what
> --strict is complaining for.

Ah okay.

> > 
> > > +	struct mutex write_lock;
> > > +
> > > +	wait_queue_head_t dl_wq;
> > > +
> > > +	/* dl channel lock to synchronize multiple reads */
> > > +	struct mutex read_lock;
> > > +
> > > +	/*
> > > +	 * protects pending list in bh context, channel release, read and
> > > +	 * poll
> > > +	 */
> > > +	spinlock_t dl_pending_lock;
> > > +
> > > +	struct list_head dl_pending;
> > > +	struct uci_buf *cur_buf;
> > > +	size_t dl_size;
> > > +	struct kref ref_count;
> > 
> > I'm now thinking that instead of having two reference counts for uci_chan and
> > uci_dev, why can't you club them together and just use uci_dev's refcount to
> > handle the channel management also.
> > 
> > For instance in uci_open, you are incrementing the refcount for uci_dev before
> > starting the channel and then doing the same for uci_chan in
> > mhi_uci_dev_start_chan(). So why can't you just use a single refcount once the
> > mhi_uci_dev_start_chan() succeeds? The UCI device is useless without a channel,
> > isn't it?
> Main idea is to have the uci driver probed (uci device object is
> instantiated) but it is possible that device node is not opened or if it was
> opened before and release() was called after that. So UCI channel is not
> active but device node would continue to exist. Which can be opened again
> and channel would move to start state. So we dont want to couple mhi driver
> probe with starting of channels. We start channels only when it is really
> needed. This would allow MHI device to go to lower power state when channels
> are disabled.
> 

Okay, makes sense! Please make sure you add it in Documentation.

> [..]
> 
> > > +
> > > +static int mhi_queue_inbound(struct uci_dev *udev)
> > > +{
> > > +	struct mhi_device *mhi_dev = udev->mhi_dev;
> > > +	struct device *dev = &mhi_dev->dev;
> > > +	int nr_trbs, i, ret = -EIO;
> > 
> > s/nr_trbs/nr_desc
> Done.
> > 
> > > +	size_t dl_buf_size;
> > > +	void *buf;
> > > +	struct uci_buf *ubuf;
> > > +
> > > +	/* dont queue if dl channel is not supported */
> > > +	if (!udev->mhi_dev->dl_chan)
> > > +		return 0;
> > 
> > Not returning an error?
> Here we dont need to return error because when open is called it would call
> this function and if dl_chan is not supported we still want to return
> success for a uci device which only supports UL channel.
> Keeping this check inside function looks clean so i am not adding this check
> in open().
> 

Hmm, okay. Please add a comment regarding this.

Thanks,
Mani
