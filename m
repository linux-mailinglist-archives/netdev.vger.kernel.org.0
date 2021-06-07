Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56339DD03
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhFGMyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:54:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34331 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhFGMyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:54:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id g6so13003952pfq.1;
        Mon, 07 Jun 2021 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xmmYovC5EtEDo4GPSeTQmBpIlg//mjJ3I6w+XC43ja0=;
        b=Bq2eOKGf0juabIZChZ/+yOnMyP7h1qvHbT/Px07efrRD/YnF7OEKnyU002jr3f5uoB
         bHCyqo1eVHEqpzvTTyM/YRc/aYFD90bB8d9UgJyMhho4AQHvmgOE0+wJl4lmwGHVY1yM
         /zI7CBdyV/bnRjSIb/CV/15gyzg/KpBK9/HAeOJLczfho8uxwX4mE8knOpk4b7nNQMih
         WW8HIrJhp9HKqKKIJlSBTyuSQkrOahimvJGwq8TEs2PzzL15YzqPhW7xfrSAvVNvBk43
         +pEa7QfhbY3q8FbqAZj48pVJIgILshgg2O5sN0CLXZSnEd9/riVgJ3pWRh8/eqQI6+pb
         YiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xmmYovC5EtEDo4GPSeTQmBpIlg//mjJ3I6w+XC43ja0=;
        b=Gnai/zFNaOwhzdna6jEy069/Nhe3XsXSWDvpuYYkHWd/Dy32GtjjVxdSLbW4JR+TeE
         AOctaVtkwK4S2HibdtgiHNUeMCMsgP8YNX8UNQ5NxQ9SqyKhhkhpn8bWIkBLn90hmZmS
         4cZrDWuMUHfehqqi9DrGN1dOT8YvM5zB3N5B1q85DfIHlueIeomB9S3ZkgUE34aX8vu4
         q68ddF1Jvlp7P6KXGmL9zHR9zaSHfml4p9a7588CKvmgpkBBMkvs55m4+gV1WKLf/Vsm
         sdwS+2L2o8dh4G2S81VX/KmDM/wM/I1DvPMzMHAR0haaC5RnO5GwCFe81PACc9HdUIzX
         moAA==
X-Gm-Message-State: AOAM531JbKB3jF5na6gKB7KhOM5ENqrV1Y+TmGFIPE2oMd2i2OJ/vIBl
        eGBTd83IzXCyftscDdQFccE=
X-Google-Smtp-Source: ABdhPJw+EHt62od3yVVGRBZ7//AwPLUA2aC0uun9X9dKv2rhVypvTvB9egJP8eKpQ9hCSpkdQq1lOw==
X-Received: by 2002:a63:368f:: with SMTP id d137mr17919899pga.93.1623070282661;
        Mon, 07 Jun 2021 05:51:22 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id 21sm4015254pfy.92.2021.06.07.05.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 05:51:22 -0700 (PDT)
Date:   Mon, 7 Jun 2021 05:51:20 -0700
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
Message-ID: <20210607125120.GA4262@www>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
 <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 10:25:53AM -0400, Jon Maloy wrote:
> 
> 
> On 6/4/21 9:28 PM, Menglong Dong wrote:
> > Hello Maloy,
> > 
> > On Sat, Jun 5, 2021 at 3:20 AM Jon Maloy <jmaloy@redhat.com> wrote:
> > > 
> > [...]
> > > Please don't add any extra file just for this little fix. We have enough
> > > files.
> > > Keep the macros in msg.h/c where they used to be.  You can still add
> > > your copyright line to those files.
> > > Regarding the macros kept inside msg.c, they are there because we design
> > > by the principle of minimal exposure, even among our module internal files.
> > > Otherwise it is ok.
> > > 
> > I don't want to add a new file too, but I found it's hard to define FB_MTU. I
> > tried to define it in msg.h, and 'crypto.h' should be included, which
> > 'BUF_HEADROOM' is defined in. However, 'msg.h' is already included in
> > 'crypto.h', so it doesn't work.
> > 
> > I tried to define FB_MTU in 'crypto.h', but it feels weird to define
> > it here. And
> > FB_MTU is also used in 'bcast.c', so it can't be defined in 'msg.c'.
> > 
> > I will see if there is a better solution.
> I think we can leverage the fact that this by definition is a node local
> message, and those are never encrypted.
> So, if you base FB_MTU on the non-crypto versions of BUF_HEADROOM and
> BUF_TAILROOM we should be safe.
> That will even give us better utilization of the space available.
> 

I think we misunderstanded something. If I base FB_MTU on the non-crypto
version of BUF_TAILROOM, it will eat 2 pages too. Because the
BUF_TAILROOM used in tipc_buf_acquire() is the crypto version, which is
larger than the non-crypto version:

struct sk_buff *tipc_buf_acquire(u32 size, gfp_t gfp)
{
	struct sk_buff *skb;
#ifdef CONFIG_TIPC_CRYPTO
	unsigned int buf_size = (BUF_HEADROOM + size + BUF_TAILROOM + 3) & ~3u;
#else
	unsigned int buf_size = (BUF_HEADROOM + size + 3) & ~3u;
#endif
	[..]
}

So if I use the non-crypto version, the size allocated will be:

  PAGE_SIZE - BUF_HEADROOM_non-crypto - BUF_TAILROOM_non-crypt +
    BUF_HEADROOM_crypto + BUF_TAILROOM_crypto

which is larger than PAGE_SIZE.

So, I think the simple way is to define FB_MTU in 'crypto.h'. Is this
acceptable?

Thanks!
Menglong Dong
