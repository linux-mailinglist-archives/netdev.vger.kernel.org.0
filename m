Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467CF30FC0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfEaOPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:15:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33574 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaOPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:15:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id 14so1053705qtf.0;
        Fri, 31 May 2019 07:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=+we0rEnollOzHDZRaFs+7oQEsf4okdwYqHNgTuYpojo=;
        b=HzoyLoY6Q/unT73ZNSJo7xswlOPng81Pi3JnGP5sJQLih/0rGLjKsR2UQfqpybyvVx
         ytaO1HSmiOMn9VRtxvnGjCNo3BYYfqrbCUk0QJzf+n/QdsGCNxSIQ+rpfxt8bySmvdwe
         w7Ft77iI4+OAHCcdWr4ROjNROyaKiLSkK7gM4toabq5nMX//x+kMA1dVXhQWTcJFq3PK
         WiwQ1krsmx1o2vcdW3P+VhVCdg1gpvxANLWcQ6pceS0bpZnyB9pL/vWgnxACa3ameSfO
         6NOUr2hdNo6sH5ZkGuNDG/NUSD/RL1GGyuHnOtCl4xKzrBzpdB4KonXVcoO0AhVR7hS1
         jiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=+we0rEnollOzHDZRaFs+7oQEsf4okdwYqHNgTuYpojo=;
        b=uHvfTLcGCxdu06TL+8WVlR6ok+kJHIYNlLtv1ww+BPLLjnzeSjoAMl5uY4oXCsC1Fy
         NAcnxkrvE50K+GhNqBXtQygB6GsreTRfs5G5OdtVL12X/B7XjWFm2Ffn+5/Hy5HMwe/V
         xwDnI5UmnQE6D6gKFj7bNh1c0mRNTHwP0ZOW8SvKaiIRhDv+dVMrr6Ey1dYX5BIpIR/5
         zBvi5Y0bO8gzdyHXjEWAoBADy5ZdH4xke7gh4dFKyzER/kc3SwzFC1TaDyWuRyB7lT6B
         kaAF+YON00DTgyKLjPaA1t0cee/STjKRINxBdjGw8QXxAu3vb+ZJNjqumrmRTwg1OjGM
         PuBw==
X-Gm-Message-State: APjAAAWr00iM0U4DszoaZ3fq9/P9mso9DqXvqYWLLOgvKWZ96/VD4Uek
        djjLB7XFPetXkF0m3R4eJeM=
X-Google-Smtp-Source: APXvYqzr4qmadMuyFHKk+Snq02K/E9QOHtxIv1CJU+kRspuJBZgseKReRXYpBzVLPE73QxiJN40NKw==
X-Received: by 2002:ac8:4982:: with SMTP id f2mr8533662qtq.213.1559312102835;
        Fri, 31 May 2019 07:15:02 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z12sm2701994qkl.66.2019.05.31.07.15.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 07:15:02 -0700 (PDT)
Date:   Fri, 31 May 2019 10:15:01 -0400
Message-ID: <20190531101501.GB23464@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: do not use regs->len after
 ops->get_regs
In-Reply-To: <20190531065432.GB15954@unicorn.suse.cz>
References: <20190530235450.11824-1-vivien.didelot@gmail.com>
 <20190531065432.GB15954@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Fri, 31 May 2019 08:54:32 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Thu, May 30, 2019 at 07:54:50PM -0400, Vivien Didelot wrote:
> > The kernel allocates a buffer of size ops->get_regs_len(), and pass
> > it to the kernel driver via ops->get_regs() for filling.
> > 
> > There is no restriction about what the kernel drivers can or cannot
> > do with the regs->len member. Drivers usually ignore it or set
> > the same size again. However, ethtool_get_regs() must not use this
> > value when copying the buffer back to the user, because userspace may
> > have allocated a smaller buffer. For instance ethtool does that when
> > dumping the raw registers directly into a fixed-size file.
> > 
> > Software may still make use of the regs->len value updated by the
> > kernel driver, but ethtool_get_regs() must use the original regs->len
> > given by userspace, up to ops->get_regs_len(), when copying the buffer.
> > 
> > Also no need to check regbuf twice.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > ---
> >  net/core/ethtool.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > index 4a593853cbf2..8f95c7b7cafe 100644
> > --- a/net/core/ethtool.c
> > +++ b/net/core/ethtool.c
> > @@ -1338,38 +1338,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
> >  static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
> >  {
> >  	struct ethtool_regs regs;
> >  	const struct ethtool_ops *ops = dev->ethtool_ops;
> >  	void *regbuf;
> >  	int reglen, ret;
> >  
> >  	if (!ops->get_regs || !ops->get_regs_len)
> >  		return -EOPNOTSUPP;
> >  
> >  	if (copy_from_user(&regs, useraddr, sizeof(regs)))
> >  		return -EFAULT;
> >  
> >  	reglen = ops->get_regs_len(dev);
> >  	if (reglen <= 0)
> >  		return reglen;
> >  
> >  	if (regs.len > reglen)
> >  		regs.len = reglen;
> > +	else
> > +		reglen = regs.len;
> 
> This seems wrong. Most drivers do not check regs.len in their get_regs()
> handler (I'm not sure if there are any that do) and simply write as much
> data as they have. Thus if userspace passes too short regs.len, this
> would replace overflow of a userspace buffer for few drivers by overflow
> of a kernel buffer for (almost) all drivers.
> 
> So while we should use the original regs.len from userspace for final
> copy_to_user(), we have to allocate the buffer for driver ->get_regs()
> callback with size returned by its ->get_regs_len() callback.

Either I've completely screwed my patch, or you have misread it. This patch
actually just stores the original value of regs.len passed by userspace to
the kernel into reglen, before calling ops->get_regs().

But the kernel still allocates ops->get_regs_len() and passes that to the
kernel drivers, as this is the only size drivers must care about.

Then the kernel only copies what the userspace (originally) requested,
up to ops->get_regs_len().

In other words, if userspace requested a bigger buffer only ops->get_regs_len()
get copied, if the userspace requested a smaller buffer only that length
get copied.


Thanks,
Vivien
