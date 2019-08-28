Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128D4A0604
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfH1PSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:18:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44522 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfH1PSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:18:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id y22so38108qkb.11
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZZj0Vw8g8acx3uGEEU339ohn0wxG5BPORUI3lZ8CKRM=;
        b=Ay3bKy7BSVw2wL/PIX3Ej6dlMZ25ti5cVqZgO8d00Tf3qrtMKJDmfDrap8bnGymTQF
         Vdc38Y+6u+5rxi7JSTjFIh821e2giTqEDtwh1YJxIAgGJnN0RCi+pAWEvBJA0ehv5Lx7
         yPT/RHIkb1zAQauDDWu5DKQy0SSTNXQKlnyi3ULmd8ebFlUxiRQRzu28EdDGRv8BCfqG
         a0c10BXF7rGpSs96KMN1snj05mvMuPqz3AgRgMJsOVQXMrp20Tr7HoSBIjiHzbKPZF04
         OxbwXCNI85Itz2G0HzFWxyLBObs/4o/E7oN57+XXgXwPiq3CDoJNzYrp1FjJD6/aTS96
         PvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZZj0Vw8g8acx3uGEEU339ohn0wxG5BPORUI3lZ8CKRM=;
        b=o7M/JTnLmB51sXgk3QLUg2Qbv0qo/pIXvryVdXY6SeT7Cr7kfiIlNI6ybFSPohuKts
         g16poW5diKJ8Nx6qM6YHFJsGQLIu3E6FepRfkoGUMWaw3m7XcFeHqA3cHovoPJrN5paW
         5IXr3tc0MY+tO+zXwHWaq2CmMYIL3jaJX/m/PJLMEUz98o6YMIaLqOmusUFp+W64PhYa
         KlzQxaqU+bReQr1HXRDrQJ5nCsMAP1BXFTlDFDhHA3ZKFY0X/e02Ig4CiI2zAM5YZPJS
         Zn6JwaZMilyD0DsbxA2uj7Npu1zBq9jFlLx/w7HXLHSPTWfX9ImiKrQK01eH4eihmxvz
         ZuVQ==
X-Gm-Message-State: APjAAAWUt92yQc6mHbaOvjNRZAo7k2wWM4vwZiGseAVBtJXH4uIeirGz
        HDtkeVggecWnTun38XThDuho0Q==
X-Google-Smtp-Source: APXvYqy7fnnGgNjMHr05W5MKWV+LZ6g68ac2ky+vaGukCPjBSOWvxfeUt0EuUxqf6zP54k7gpruPjw==
X-Received: by 2002:a37:e208:: with SMTP id g8mr4599967qki.237.1567005512247;
        Wed, 28 Aug 2019 08:18:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-216-168.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.216.168])
        by smtp.gmail.com with ESMTPSA id q28sm1573277qtk.34.2019.08.28.08.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Aug 2019 08:18:31 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1i2ziR-0004FG-5B; Wed, 28 Aug 2019 12:18:31 -0300
Date:   Wed, 28 Aug 2019 12:18:31 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 0/3] ODP support for mlx5 DC QPs
Message-ID: <20190828151831.GB933@ziepe.ca>
References: <20190819120815.21225-1-leon@kernel.org>
 <20190827155140.GA15153@ziepe.ca>
 <20190828070620.GD4725@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828070620.GD4725@mtr-leonro.mtl.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 10:06:20AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 27, 2019 at 12:51:40PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 19, 2019 at 03:08:12PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Changelog
> > >  v3:
> > >  * Rewrote patches to expose through DEVX without need to change mlx5-abi.h at all.
> > >  v2: https://lore.kernel.org/linux-rdma/20190806074807.9111-1-leon@kernel.org
> > >  * Fixed reserved_* field wrong name (Saeed M.)
> > >  * Split first patch to two patches, one for mlx5-next and one for  rdma-next. (Saeed M.)
> > >  v1: https://lore.kernel.org/linux-rdma/20190804100048.32671-1-leon@kernel.org
> > >  * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
> > >  v0: https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.org
> > >
> > > >From Michael,
> > >
> > > The series adds support for on-demand paging for DC transport.
> > >
> > > As DC is mlx-only transport, the capabilities are exposed
> > > to the user using DEVX objects and later on through mlx5dv_query_device.
> > >
> > > Thanks
> > >
> > > Michael Guralnik (3):
> > >   net/mlx5: Set ODP capabilities for DC transport to max
> > >   IB/mlx5: Remove check of FW capabilities in ODP page fault handling
> > >   IB/mlx5: Add page fault handler for DC initiator WQE
> >
> > This seems fine, can you put the commit on the shared branch?
> 
> Thanks, applied to mlx5-next
> 00679b631edd net/mlx5: Set ODP capabilities for DC transport to max

Done, thanks

Jason
