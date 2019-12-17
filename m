Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F20123845
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfLQVEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:04:09 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39226 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbfLQVEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:04:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id c16so5736515qko.6
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6basBJ6bM0j6BIPp8FG95aWLrLObNXSRO6/Wx7nPGjY=;
        b=MqyUdMfDcn1codoO31HcLME2le2sLXyLFynO1aor9WdcSUUHFJj8e7WJ1wlScWOt8V
         ds9acIoM8rNyPBicQN1yW3twnBov9xjL32hPtQQebZF+vSHvcSonwS/aTmamMuPP47t7
         x6TvFdqpQIpBKUp0sUj+10F71lrKsyoBu/brC+NpWN9TqOZuPZzIf/FcAa942WpjiWo8
         xI1xwP8SHgi20M+kLpmTcZ3pxmDS61XuYw4dxQJBuJOGGwStQMbbstPcTCpyV1wwnP4h
         md45sLBNYkiJ/E3Sj0/nhHn859WhF+7XFog3lmxGbfSxwhvIgdIJAqG3qnhNBCc035Y2
         e/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6basBJ6bM0j6BIPp8FG95aWLrLObNXSRO6/Wx7nPGjY=;
        b=k4zxMcHVbwse+WItzHeRkf1aJ/81HEqP2LY/uy1H1xVZCLRu8zrcpH9KwUI/vPg2+a
         Y7yK+SPojrLVNSDFmJLfhfXKxZVBB/3mcUMKwIgrzGEGgUGUdxOKPmHud/1nI8Nci579
         X/02fy1V3kMBEsvrVO2GUbPreWghS7/LAyy8EV9HW64z7kvZ3VcdVmsAtJESNf2K4H/B
         lpPwPaoD10+Iz9I+Ko/SP87sXmXrBAAOU/RAMzUwrliqXYJWK+iN8yZ6h7I5We2vDl9B
         3PVrCsxLajycczCBzU1j8J4FTTqvtCOPdPwUD7QV0JGVMeYQO0jd1f+zKInjw+1seNqL
         YHyQ==
X-Gm-Message-State: APjAAAU4JK6teOSDYyEqX3FfDT9Rtuyoph3b28PxJRPjNO3tIufM0vG6
        Mx0Xd0pvy7TRSnMA4MLMvu7rJQ==
X-Google-Smtp-Source: APXvYqyzYJJV+qjvB1KgzPsRbFym4uUi8J69hEABpIIEYSve0pHQPh+4NJELcoakOoShpzx0k97Ukw==
X-Received: by 2002:a37:b93:: with SMTP id 141mr7106576qkl.54.1576616648005;
        Tue, 17 Dec 2019 13:04:08 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id g18sm4128qtc.83.2019.12.17.13.04.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 13:04:07 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ihK0k-0002IT-KH; Tue, 17 Dec 2019 17:04:06 -0400
Date:   Tue, 17 Dec 2019 17:04:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20191217210406.GC17227@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 11:06:45PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
> > i40iw
> > 
> > On Mon, Dec 09, 2019 at 02:49:34PM -0800, Jeff Kirsher wrote:
> > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > >
> > > Add Kconfig and Makefile to build irdma driver.
> > >
> > > Remove i40iw driver. irdma is the replacement driver that supports
> > > X722.
> > 
> > I looked through this for a litle while, it is very very big. I'd like some of the other
> > people who have sent drivers lately to give it a go over as well..
> > 
> > A few broad comments
> >  - Do not use the 'err1', 'err2', etc labels for goto unwind
> >  - Please check all uses of rcu, I could not see why some existed
> >  - Use the new rdma mmap api. The whole mmap flow looked wonky to me
> Presume your referring to this series?
> https://github.com/jgunthorpe/linux/commits/rdma_mmap

Yes, it is merged now

> At the time it was published, I didn't think it applied to irdma, but rather
> benefit those drivers that keyed off an mmap database in their mmap function.

All drivers using mmap should be using it.

New drivers should not be using mmap via hard coded keys. The offset
to pass to mmap should always be returned from a system call.

For compatibility insert the hard coded key with the mmap stuff and
use the APIs for lifetime management.

> In irdma, there is a doorbell and a push page that are mapped. 

Pretty much all hardware requires these to be per-security domain, so
you have a lifecycle model that matches what the mmap API is now
providing.

> >  - New drivers should use the ops->driver_unregister flow
> https://www.spinics.net/lists/linux-rdma/msg75466.html
> "These APIs are intended to support drivers that exist outside the usual
> driver core probe()/remove() callbacks. Normally the driver core will
> prevent remove() from running concurrently with probe(), once this safety
> is lost drivers need more support to get the locking and lifetimes right."
> 
> As per this description, it seems ib_unregister_driver() would be
> redundant for irdma to use in module exit? 

Yes, this driver doesn't need that call

> Or did you mean just instrument ops->dealloc_driver?

Yes

> >  - The whole cqp_compl_thread thing looks really weird
> What is the concern?

It looks like an open coded work queue

Jason
