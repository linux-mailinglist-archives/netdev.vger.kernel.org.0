Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D837A3550AC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbhDFKTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245051AbhDFKTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 06:19:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB87C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 03:19:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f6so7507339wrv.12
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 03:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IN4iWDpwIoW/geXUgD19n4BmDi3+Huz5BgzH8rQnEJY=;
        b=qfpDyvBWpReaQR8CKhH2jY4SIL3IpltYqpE4ozjvKakYmTCJ50DLv87jcMoRnaRRFB
         hFkVzJvYYTdTiZQPErGHFZc4KXxc3RJvJCxHkTYsGpDII/ykAqT+A7ejrRmabkumudB3
         FTG7d+i/Ek2e0FOvkrWpEmUSPO/69kJJCQdGRKrXC/dZ7qD689u9+kRmJCkdbWftxUzI
         NnTzIX0HIUrkBE0+CRHaxcjA7amNsEJ4DYjG829dKDqY4qEFpyPK57i20R9wNLC6PThu
         Rx76T4V4A1ohUv/fAN+VMWpkw4V5aYQdFC5aiz+hiPDl0buTtYMR9gluV7u1Y6NehuMq
         s2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IN4iWDpwIoW/geXUgD19n4BmDi3+Huz5BgzH8rQnEJY=;
        b=iXmbfR9IOJdmxTSbSINFC+Dq0lre7eTWIxHbJWjoA62HpE9k/uY0QvSEjcjIMfx1c3
         9RUxQpG+6U2qvcMEkMdrh1ubsbFJOOAXS2F5b4fKQCX0KfKjwJR3/laOblR27a5vhuO4
         5ipkhm+5jB/VY1QtejLIMgljwTDR19gNgfMxkLP9Xb1xsctJkAnoqV6qcXL4EZHk2JHt
         MlPcbSQ1tnfYP/e84jsomAmsRkrZYPE+RO9H+BRt9sj38nf1tPZ3Mdgj9iMTSyMg2rI5
         xto4EXubBWTcxu8MRBvZPa4W6vllYHE5t2kKwLbdQbIhZIISIZPl5zowSfGoxwH2Z3xn
         Ossw==
X-Gm-Message-State: AOAM532jA/vau6PI9J5tnwAO6CqoMjDdCgBmQW0jvE4guvFd54VHq6zc
        NoGnqxgwfsWXz8p8dkUoSfN0JyDpbZ9rvA==
X-Google-Smtp-Source: ABdhPJzqJZrY42Rylpo/GVf1q3uBhqwGtJVMnDDrQ90UI6eEGZAOtjPaBMaUrAPJ706RQr37Si8SQA==
X-Received: by 2002:adf:ec88:: with SMTP id z8mr16009553wrn.315.1617704339631;
        Tue, 06 Apr 2021 03:18:59 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id k3sm11523998wrc.67.2021.04.06.03.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:18:58 -0700 (PDT)
Date:   Tue, 6 Apr 2021 11:18:55 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tun: set tun->dev->addr_len during TUNSETLINK
 processing
Message-ID: <YGw1jx5zO4+Wz5Md@equinox>
References: <20210405113555.9419-1-phil@philpotter.co.uk>
 <20210405.145921.1248097047641627556.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405.145921.1248097047641627556.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 02:59:21PM -0700, David Miller wrote:
> From: Phillip Potter <phil@philpotter.co.uk>
> Date: Mon,  5 Apr 2021 12:35:55 +0100
> 
> > When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
> > to match the appropriate type, using new tun_get_addr_len utility function
> > which returns appropriate address length for given type. Fixes a
> > KMSAN-found uninit-value bug reported by syzbot at:
> > https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> > 
> > Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  drivers/net/tun.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> > 
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 978ac0981d16..56c26339ee3b 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -69,6 +69,14 @@
> >  #include <linux/bpf.h>
> >  #include <linux/bpf_trace.h>
> >  #include <linux/mutex.h>
> > +#include <linux/ieee802154.h>
> > +#include <linux/if_ltalk.h>
> > +#include <uapi/linux/if_fddi.h>
> > +#include <uapi/linux/if_hippi.h>
> > +#include <uapi/linux/if_fc.h>
> > +#include <net/ax25.h>
> > +#include <net/rose.h>
> > +#include <net/6lowpan.h>
> >  
> >  #include <linux/uaccess.h>
> >  #include <linux/proc_fs.h>
> > @@ -2925,6 +2933,45 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
> >  	return __tun_set_ebpf(tun, prog_p, prog);
> >  }
> >  
> > +/* Return correct value for tun->dev->addr_len based on tun->dev->type. */
> > +static inline unsigned char tun_get_addr_len(unsigned short type)
> > +{
> 
> Please do not use inline in foo.c files, let the compiler decide.
> 
> Thanks.

Dear David,

Thank you for the feedback, I will resend.

Regards,
Phil
