Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0931075
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfEaOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:46:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41675 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEaOqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:46:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id s57so1122237qte.8;
        Fri, 31 May 2019 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=AlWkwSCpkPEVFSEpOfzdH3Er9kTK/1PW/mTDdgqzwlA=;
        b=WzyficwVn7kiOwetvIxD3d4k3UMk5QNxLSjDEBisMkGx5qKk34xpgmEaVrX6kw/M+d
         xNt9j/FyNAlIdnjR1zvjPLCzsjGmAD9OQZwinntDcuo/kq73B5UGyAK4IDJjmVfcA+7e
         Ppi/tf1KBBuWLMiQRuQrNh3wVH3NVOdj2yYCNC1Ime85gSzG6vWuUcpUNczbAzpIUzug
         xgCWixwZfsrqqB4+eFgYu57edR6Po9lUSvNrr4xr+0eSRXsEtI4teL7n4UdM0JLAqQhv
         IUYM/JEGV4H7Rsz77RSLK5zrAXWzp7IYPi5WTzpeOX49bym9m8HzRl/GYgaF/9IZkmqp
         GHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=AlWkwSCpkPEVFSEpOfzdH3Er9kTK/1PW/mTDdgqzwlA=;
        b=qLayojC/RbJc9lHRx3Kn0V+35YNzXWd5sxkWFGjTUwKOcxGVIFcB6UE1YODyCKg7d2
         saEtZVwVNNb2081dzNqBbeRoj6DICgm/7P+Ns+4rP7dgkNWWJRgSaoIAjo7CeL0k3UxK
         Q2v6oFOXFVKVbSOrHXtEHagOWUQONycWYO9BPYKG6zVInn0S0vaOOQm2Up4OI6Ic4DLv
         dwP6hTEyULU77rnQ5aGZ4cfMpEsEb9Srl1zqmNXMFpPSuPI/HiJ59W8q8bt2BYCUhIlC
         XRkzXN8i8JqFGXgvzzHrFXBAlKhmTskFeDmxCXq3wZFxcvGNXE1aolGqpvFDKhive0X+
         C7yQ==
X-Gm-Message-State: APjAAAV+zr2P083JZDJeQRpHwyRRUVKribnuF10TnYMHZP081UI5KwvP
        1p8+hF6v+S7Ns+Qra6sFk+E=
X-Google-Smtp-Source: APXvYqwEGVMlQ+w2G4oWVHHzGfIG8NHQ8q6Z4tWKALPHt/1W8leI+jw3Oo0seS9AhsnG26tEWJ2zqw==
X-Received: by 2002:aed:2961:: with SMTP id s88mr9473633qtd.120.1559313980580;
        Fri, 31 May 2019 07:46:20 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x6sm2589457qti.88.2019.05.31.07.46.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 07:46:20 -0700 (PDT)
Date:   Fri, 31 May 2019 10:46:19 -0400
Message-ID: <20190531104619.GB29863@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: do not use regs->len after
 ops->get_regs
In-Reply-To: <20190531142750.GE15954@unicorn.suse.cz>
References: <20190530235450.11824-1-vivien.didelot@gmail.com>
 <20190531065432.GB15954@unicorn.suse.cz>
 <20190531101501.GB23464@t480s.localdomain>
 <20190531142750.GE15954@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Fri, 31 May 2019 16:27:50 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Fri, May 31, 2019 at 10:15:01AM -0400, Vivien Didelot wrote:
> > Hi Michal,
> > 
> > On Fri, 31 May 2019 08:54:32 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> > > On Thu, May 30, 2019 at 07:54:50PM -0400, Vivien Didelot wrote:
> > > > The kernel allocates a buffer of size ops->get_regs_len(), and pass
> > > > it to the kernel driver via ops->get_regs() for filling.
> > > > 
> > > > There is no restriction about what the kernel drivers can or cannot
> > > > do with the regs->len member. Drivers usually ignore it or set
> > > > the same size again. However, ethtool_get_regs() must not use this
> > > > value when copying the buffer back to the user, because userspace may
> > > > have allocated a smaller buffer. For instance ethtool does that when
> > > > dumping the raw registers directly into a fixed-size file.
> > > > 
> > > > Software may still make use of the regs->len value updated by the
> > > > kernel driver, but ethtool_get_regs() must use the original regs->len
> > > > given by userspace, up to ops->get_regs_len(), when copying the buffer.
> > > > 
> > > > Also no need to check regbuf twice.
> > > > 
> > > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > > > ---
> > > >  net/core/ethtool.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > > > index 4a593853cbf2..8f95c7b7cafe 100644
> > > > --- a/net/core/ethtool.c
> > > > +++ b/net/core/ethtool.c
> > > > @@ -1338,38 +1338,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
> > > >  static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
> > > >  {
> > > >  	struct ethtool_regs regs;
> > > >  	const struct ethtool_ops *ops = dev->ethtool_ops;
> > > >  	void *regbuf;
> > > >  	int reglen, ret;
> > > >  
> > > >  	if (!ops->get_regs || !ops->get_regs_len)
> > > >  		return -EOPNOTSUPP;
> > > >  
> > > >  	if (copy_from_user(&regs, useraddr, sizeof(regs)))
> > > >  		return -EFAULT;
> > > >  
> > > >  	reglen = ops->get_regs_len(dev);
> > > >  	if (reglen <= 0)
> > > >  		return reglen;
> > > >  
> > > >  	if (regs.len > reglen)
> > > >  		regs.len = reglen;
> > > > +	else
> > > > +		reglen = regs.len;
> > > 
> > > This seems wrong. Most drivers do not check regs.len in their get_regs()
> > > handler (I'm not sure if there are any that do) and simply write as much
> > > data as they have. Thus if userspace passes too short regs.len, this
> > > would replace overflow of a userspace buffer for few drivers by overflow
> > > of a kernel buffer for (almost) all drivers.
> > > 
> > > So while we should use the original regs.len from userspace for final
> > > copy_to_user(), we have to allocate the buffer for driver ->get_regs()
> > > callback with size returned by its ->get_regs_len() callback.
> > 
> > Either I've completely screwed my patch, or you have misread it. This patch
> > actually just stores the original value of regs.len passed by userspace to
> > the kernel into reglen, before calling ops->get_regs().
> > 
> > But the kernel still allocates ops->get_regs_len() and passes that to the
> > kernel drivers, as this is the only size drivers must care about.
> > 
> > Then the kernel only copies what the userspace (originally) requested,
> > up to ops->get_regs_len().
> > 
> > In other words, if userspace requested a bigger buffer only ops->get_regs_len()
> > get copied, if the userspace requested a smaller buffer only that length
> > get copied.
> 
> The problem with this patch is not with what gets copied to userspace
> but with the buffer allocated for driver callback. With this patch, the
> code looks like this:
> 
> 	reglen = ops->get_regs_len(dev);
> 	if (reglen <= 0)
> 		return reglen;
> 
> Here we get actual dump size from driver and put it into reglen.
> 
> 	if (regs.len > reglen)
> 		regs.len = reglen;
> 	else
> 		reglen = regs.len;
> 
> If userspace buffer is insufficient, i.e. regs.len < reglen, we shrink
> reglen to regs.len.
> 
> 	regbuf = vzalloc(reglen);
> 	if (!regbuf)
> 		return -ENOMEM;
> 
> Here we allocate a buffer of size reglen (which has been shrunk to
> regs.len from userspace).
> 
> 	ops->get_regs(dev, &regs, regbuf);
> 
> And pass that buffer to driver's ->get_regs() callback. But these
> callbacks mostly ignore regs.len and simply write as much data as they
> have (size equal to what ->get_regs_len() returned). So if regs.len
> provided by userspace is strictly shorter than actual dump size, driver
> writes past the buffer allocated above.

I've screwed my patch, the reglen assignment must go after the allocation
for sure... sorry about that. What my fix was supposed to be was:

    diff --git a/net/core/ethtool.c b/net/core/ethtool.c
    index 4a593853cbf2..36057ec807f4 100644
    --- a/net/core/ethtool.c
    +++ b/net/core/ethtool.c
    @@ -1359,13 +1359,16 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
            if (!regbuf)
                    return -ENOMEM;
     
    +       if (regs.len < reglen)
    +               reglen = regs.len;
    +
            ops->get_regs(dev, &regs, regbuf);
     
            ret = -EFAULT;
            if (copy_to_user(useraddr, &regs, sizeof(regs)))
                    goto out;
            useraddr += offsetof(struct ethtool_regs, data);
    -       if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
    +       if (copy_to_user(useraddr, regbuf, reglen))
                    goto out;
            ret = 0;
 
So that we simply store the original regs.len (up to ops->get_regs_len())
before calling ops->get_regs().


Thanks,
Vivien
