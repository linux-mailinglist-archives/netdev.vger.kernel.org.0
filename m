Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905BA879ED
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406765AbfHIMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfHIMaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:30:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C3F208C3;
        Fri,  9 Aug 2019 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353830;
        bh=Bw7AdXnBl1lMBPJ0u0aAWoxjb3sn7FEDyZSxw+JKNz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLBAtJE5sMOg/BJ8T7dpgn+IC5zXSrS/vtXGmNCl/cvj7plc2DFmD4lU/WKIONWo7
         v3+pQo7wyAjIX+HXFYwS0GkqU9cIXV83wwKw4eRHXWLkWKgzMmrkXYpfzHsVnh473J
         qtHXMHDgYDCGk2D4nt1g/2RkeIlxizqzjluik08U=
Date:   Fri, 9 Aug 2019 14:30:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Networking driver debugfs cleanups
Message-ID: <20190809123027.GA26943@kroah.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
 <20190808.183756.2198405327467483431.davem@davemloft.net>
 <20190808.184237.1532563308186831482.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808.184237.1532563308186831482.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 06:42:37PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 08 Aug 2019 18:37:56 -0700 (PDT)
> 
> > I applied this without patch #17 which you said you would respin in order
> > to get rid of the now unused local variable.
> 
> Actually, there is a bunch of fallout still:
> 
> drivers/net/wimax/i2400m/debugfs.c: In function ‘i2400m_debugfs_add’:
> drivers/net/wimax/i2400m/debugfs.c:192:17: warning: unused variable ‘dev’ [-Wunused-variable]
>   struct device *dev = i2400m_dev(i2400m);
>                  ^~~
> drivers/net/wimax/i2400m/usb.c: In function ‘i2400mu_debugfs_add’:
> drivers/net/wimax/i2400m/usb.c:375:17: warning: unused variable ‘fd’ [-Wunused-variable]
>   struct dentry *fd;
>                  ^~
> drivers/net/wimax/i2400m/usb.c:373:17: warning: unused variable ‘dev’ [-Wunused-variable]
>   struct device *dev = &i2400mu->usb_iface->dev;
>                  ^~~
> drivers/net/wimax/i2400m/usb.c:372:6: warning: unused variable ‘result’ [-Wunused-variable]
>   int result;
>       ^~~~~~
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c: In function ‘i40e_dbg_pf_init’:
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:1736:23: warning: unused variable ‘dev’ [-Wunused-variable]
>   const struct device *dev = &pf->pdev->dev;
>                        ^~~
> 
> This is with:
> 
> [davem@localhost net-next]$ gcc --version
> gcc (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2)
> Copyright (C) 2018 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> [davem@localhost net-next]$ 
> 
> So I'm reverting.
> 
> Please respin the series with this stuff fixed, thanks Greg.

Ugh, that sucks, it looks like I never even built this series.  My
apologies for wasting people's time.

Let me fix this all up, properly build it, and resend.

thanks,

greg k-h
