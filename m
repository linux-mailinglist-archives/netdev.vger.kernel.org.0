Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62E336F9
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfFCRmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:42:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44853 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfFCRmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:42:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so10376234qtk.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 10:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=KVHpI4Opz4et+13Nb9iLK0X/mPngPOrWE2Uboko6Kfw=;
        b=fgdlTGUyyMDvc0byKB35dIMYIa+iVAzl6i2mRr+QlZ255/FVe7N+PWylMBuFnMb1nN
         j7lo5+t4QsONIz5SloT557tqTWA0Is35kuW9CzeQ+sRm5w0DzjboTu0k7QZsAkS7OVBq
         qUlQDQwgH8keiQxb6iwC0zxvLq2aWUC/JLHZHPV3dg6N4oeHOJ1kwE0Rog8XviRQq1ps
         P+7PeYNNfcBeYzCAZuMpw+1e0MOg0b8THyQBa++RdLjoonzer6FNg5BGvVGWhPtUAI4H
         T5zmZ4bfTFCLBdJ1YPRIw6wCNvFQWSDoqNq4R6iHdun3BRAoez4Po5if7N4sMCkJeh0i
         dOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=KVHpI4Opz4et+13Nb9iLK0X/mPngPOrWE2Uboko6Kfw=;
        b=Xt+DjTAWdAMMvCaDlEieU6l9rhpkOZwFjNmoUaZytV4yMvkWpiA3VjSmWlFJWRlryB
         zjV++khFGyk0++e5tqaAcsI+ej0rm3q7KkG4Vme43bbrKZV4GI9pKzes9889Qirh5DCD
         AkNhHcO5LhSBNWJuM5v+pdTkYaKHBYuqmZJDc/sYPrCQtILlggP7fK8EDTkUiqUsmqsW
         4mKNfZph4FFHlU3WuOGVHsKvDsTYUKX8mPezjv6fCcZW/JfvYVnKs3J2tiPz/+7x59s4
         InjbgNcyy0Gw/ytohnpal1WgTNNzeZDJPZu3nYoNeJwO7r47KH4YYsza0IbSwrzPUcaz
         iqxA==
X-Gm-Message-State: APjAAAXJW5fsHS75dDUxPWxkOKItb/mHd+bAVjSyxRWK8mRTuxzPJB8m
        nDt4+VAMdacV9lvBfBRi2aE=
X-Google-Smtp-Source: APXvYqzetaYmG8j4mhp2B1ET87exQYiUMQglxAnsYrC+CooTGRWDBX6PBW/egDHaNI82QaV52jWqRA==
X-Received: by 2002:aed:3b0c:: with SMTP id p12mr24068355qte.283.1559583742024;
        Mon, 03 Jun 2019 10:42:22 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g20sm8076872qkm.89.2019.06.03.10.42.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 10:42:20 -0700 (PDT)
Date:   Mon, 3 Jun 2019 13:42:19 -0400
Message-ID: <20190603134219.GB28927@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linville@redhat.com, f.fainelli@gmail.com
Subject: Re: [PATCH net] ethtool: fix potential userspace buffer overflow
In-Reply-To: <20190603171512.GJ15954@unicorn.suse.cz>
References: <20190531231221.29460-1-vivien.didelot@gmail.com>
 <20190603171512.GJ15954@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Mon, 3 Jun 2019 19:15:12 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Fri, May 31, 2019 at 07:12:21PM -0400, Vivien Didelot wrote:
> > ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> > and pass it to the kernel driver via ops->get_regs() for filling.
> > 
> > There is no restriction about what the kernel drivers can or cannot do
> > with the open ethtool_regs structure. They usually set regs->version
> > and ignore regs->len or set it to the same size as ops->get_regs_len().
> > 
> > Userspace may actually allocate a smaller buffer for registers dump,
> > for instance ethtool does that when dumping the raw registers directly
> > into a fixed-size file.
> 
> This is not exactly true. AFAICS ethtool always calls the ETHTOOL_GREGS
> ioctl with the size returned by ETHTOOL_GDRVINFO. Only after that it may
> replace regs->len with file length but it's a file it _reads_ and
> replaces the dump (or part of it) with it. (Which doesn't seem to make
> sense: if ethtool(8) man page says ethtool is to display registers from
> a previously saved dump, why does ethtool execute the ETHTOOL_GREGS
> request at all?)

You are correct, what ethtool does here is weird. I can remove this statement
from the commit message in a v2.

>  
> > Because the current code uses the regs.len value potentially updated
> > by the driver when copying the buffer back to userspace, we may
> > actually cause a userspace buffer overflow in the final copy_to_user()
> > call.
> > 
> > To fix this, make this case obvious and store regs.len before calling
> > ops->get_regs(), to only copy as much data as requested by userspace,
> > up to the value returned by ops->get_regs_len().
> > 
> > While at it, remove the redundant check for non-null regbuf.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com> ---
> > net/core/ethtool.c | 5 ++++- 1 file changed, 4 insertions(+), 1
> > deletion(-)
> > 
> > diff --git a/net/core/ethtool.c b/net/core/ethtool.c index
> > 43e9add58340..1a0196fbb49c 100644 --- a/net/core/ethtool.c +++
> > b/net/core/ethtool.c @@ -1338,38 +1338,41 @@ static noinline_for_stack
> > int ethtool_set_rxfh(struct net_device *dev, static int
> > ethtool_get_regs(struct net_device *dev, char __user *useraddr) {
> > struct ethtool_regs regs; const struct ethtool_ops *ops =
> > dev->ethtool_ops; void *regbuf; int reglen, ret;
> >  
> >  	if (!ops->get_regs || !ops->get_regs_len) return -EOPNOTSUPP;
> >  
> >  	if (copy_from_user(&regs, useraddr, sizeof(regs))) return
> >  	-EFAULT;
> >  
> >  	reglen = ops->get_regs_len(dev); if (reglen <= 0) return reglen;
> >  
> >  	if (regs.len > reglen) regs.len = reglen;
> >  
> >  	regbuf = vzalloc(reglen); if (!regbuf) return -ENOMEM;
> >  
> > +	if (regs.len < reglen) +		reglen = regs.len; +
> > ops->get_regs(dev, &regs, regbuf);
> >  
> >  	ret = -EFAULT; if (copy_to_user(useraddr, &regs, sizeof(regs)))
> >  	goto out; useraddr += offsetof(struct ethtool_regs, data); -
> >  	if (regbuf && copy_to_user(useraddr, regbuf, regs.len)) +
> >  	if (copy_to_user(useraddr, regbuf, reglen)) goto out; ret = 0;
> >  
> >   out: vfree(regbuf); return ret; }
> 
> Yes, this will address overflowing the userspace buffer. It will still
> either preserve regs.len or replace it with full dump length, depending
> on the driver. But to address that, we should first agree which it
> should be. I'm afraid there is no good choice, setting regs.len to size
> actually returned is IMHO less bad.

I don't think it is necessary to change the current behavior of the drivers
for the moment. regs.len is kept the same, so we don't impact userspace as
well. But what's important is to not use regs.len after ops->get_regs()
is called, because we must use the value passed by userspace (up to
ops->get_regs_len() for sure). That is what this patch focuses on.

Do you want me to change something beside rewording the commit message?


Thank you,
Vivien
