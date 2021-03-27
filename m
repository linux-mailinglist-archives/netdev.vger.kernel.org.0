Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692E334B397
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 02:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhC0Bov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 21:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhC0Bom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 21:44:42 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B48C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 18:44:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l3so6025163pfc.7
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 18:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/CNCB1FlBgHb8BDj4LOv3eJlIjc1/tm7c3BrqDRsRc0=;
        b=B9atPwhispSgtc7SDysgIRn+23wSvl5XFaTSPQfnPEGaPJojCSevT6UGahPGyovk3p
         QJr1I94YOh0AB7QOtes+fpC9wu1UBtuqciWp18vTX6IEMkzuBcFsqHeiV9QGihxyHNc5
         5CJwq7LRNHLw+y12bS7qLwfJoppMYj/bahMc8iH+BWsFN48JfWaGPQnvy4sbNiE96y3y
         +u4ICh3TE3cLtnYbf9wZ51aqwTpBHPIuMWZHWRzHpdvFYm8zH68qmBtcVgFtuXNHGWzX
         iYg0sjRtG613QqCk5/uRmIZwmGbXY0gLQAyXu020xOGYINVMb+5so2JloFaE5++9onx2
         ficQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/CNCB1FlBgHb8BDj4LOv3eJlIjc1/tm7c3BrqDRsRc0=;
        b=p6reCBLWKmPlpQ61kfh5QIc1SXPyfN0lxjQHf7bVLyxqLx6U9ZCSFSBacOjKBXsx8e
         CjtedM/QCoM5zC/GodmPoYCKwjsld7lHweetao/IqZ5Rk6mWCpBFs4NpXuCH1Wn1p6TO
         VzSY/tdQtQ/5VirQjt3D1lGUvnV46f6uPS2a9CPvdfrDwa7mEFCon+DlcTqV2Qqcmtti
         fvYlOLNnZBB9QOLawvZvSrEaYSlCS6EhVxbDY9pxwklZ/sWXs3eCZ7Pc6f0IS6N5tJkZ
         7niQ3TCiFQMOJKAIu4DaMftFB05JXWScZU54tbrvNQKpw4zSZeOChHL76XLlK3ep0YeY
         9hLg==
X-Gm-Message-State: AOAM53104HgTPkLKKvwgbQH67VpLXZpDuDfAqoJr3XWevr5+jfDLaJ1G
        YL6wU6Ydx9BtFxaqf5Ezun8=
X-Google-Smtp-Source: ABdhPJyMWhfPSiAUZRvnznS3TboKD+l/E3JQwavhZsOG1dG2vv4P7mFNajfVhQJMffvjHG8cw9WwBA==
X-Received: by 2002:a65:53c8:: with SMTP id z8mr13555528pgr.340.1616809481549;
        Fri, 26 Mar 2021 18:44:41 -0700 (PDT)
Received: from ThinkCentre-M83 ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id g7sm9805852pgb.10.2021.03.26.18.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 18:44:41 -0700 (PDT)
Date:   Sat, 27 Mar 2021 09:44:37 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH] net:qrtr: fix allocator flag of idr_alloc_u32() in
 qrtr_port_assign()
Message-ID: <20210327014437.GA22482@ThinkCentre-M83>
References: <20210326033345.162531-1-ducheng2@gmail.com>
 <YF2qDZkNpn8va28r@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF2qDZkNpn8va28r@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 10:31:57AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 26, 2021 at 11:33:45AM +0800, Du Cheng wrote:
> > change the allocator flag of idr_alloc_u32 from GFP_ATOMIC to
> > GFP_KERNEL, as GFP_ATOMIC caused BUG: "using smp_processor_id() in
> > preemptible" as reported by syzkaller.
> > 
> > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > ---
> > Hi David & Jakub,
> > 
> > Although this is a simple fix to make syzkaller happy, I feel that maybe a more
> > proper fix is to convert qrtr_ports from using IDR to radix_tree (which is in
> > fact xarray) ? 
> > 
> > I found some previous work done in 2019 by Matthew Wilcox:
> > https://lore.kernel.org/netdev/20190820223259.22348-1-willy@infradead.org/t/#mcb60ad4c34e35a6183c7353c8a44ceedfcff297d
> > but that was not merged as of now. My wild guess is that it was probably
> > in conflicti with the conversion of radix_tree to xarray during 2020, and that
> > might cause the direct use of xarray in qrtr.c unfavorable.
> > 
> > Shall I proceed with converting qrtr_pors to use radix_tree (or just xarray)?

Hi Greg,

After more scrutiny, this is entirely unnecessary, as the idr structure is
implemented as a radix_tree, which is, you guess it, xarray :)

So I looked more closely, and this time I found the culprit of the crash. It was
due to a unprotected per_cpu access:
```
rtp = this_cpu_ptr(&radix_tree_preloads);
        if (rtp->nr) {
            ret = rtp->nodes;
            rtp->nodes = ret->parent;
            rtp->nr--;
        }
```
inside
    -> radix_tree_node_alloc()
  -> idr_get_free()
idr_alloc_u32()

I tried to wrap the idr_alloc_u32() with disable_preemption() and
enable_preemption(), and it passed my local and syzbot test.

More digging reveals that idr routines provide such utilities:
idr_preload() and idr_preload_end(). They do the exact thing but with additional
radix_tree bookkeeping. Hence I think this should be favorable than allowing
the allocation to sleep. The syzbot-passed patch is here:
https://syzkaller.appspot.com/text?tag=Patch&x=14cf5a26d00000

If it looks good to you, I will send the above patch as V2.

> 
> Try it and see.  But how would that resolve this issue?  Those other
> structures would also need to allocate memory at this point in time and
> you need to tell it if it can sleep or not.
> 
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index edb6ac17ceca..ee42e1e1d4d4 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -722,17 +722,17 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  	mutex_lock(&qrtr_port_lock);
> >  	if (!*port) {
> >  		min_port = QRTR_MIN_EPH_SOCKET;
> > -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > +		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_KERNEL);
> 
> Are you sure that you can sleep in this code path?
There are only 2 other places there the mutex is held, and they seem to be safe,
but I can't show that comprehensively.
If I *were* to go with sleeping in idr_alloc_u32, does lockdep a silverbullet to
prove lock safty?
> 
> thanks,
> 
> greg k-h

Regards,
Du Cheng
