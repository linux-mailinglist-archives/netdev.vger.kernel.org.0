Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C19239CC9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgHBW2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgHBW2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:28:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6742C061756
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 15:28:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h7so33644885qkk.7
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 15:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X2bYgTX4K3EZYIeQDAN4hcSO5LdesUSG+q6mG9kn4ys=;
        b=lIf6/YNuL/fGjujaZaoNWqjOsE+V2SxqHpXstZJx+0q2hXtLpUFUTz5JX8XdrjIX84
         nHNBhu4B25HP4PjS2WRfH/wBVJnp15ux7/z2PJT4SEWunVT30EfxZztzctwXk7QW0gTo
         9Nl0wqW9uhY/cOlHKkY2bAxXtZ8oU22wXRgsHJkYugvcXjiHns5QhPw+INH4KWhRatZ0
         Zb9IgHQCzuejMB4jCfe0cnBMXT0o2vTT+BoP48ROWLDHm99aMCb15cx9yTnjG0xA+izp
         1a2shGvPVx/c3qIncZKuA2cCSdiHnxQ4E8gu8ODnEPo0jl+X8CW+q5BGj0a6F6cDfN43
         G5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X2bYgTX4K3EZYIeQDAN4hcSO5LdesUSG+q6mG9kn4ys=;
        b=Ojt58aOpkMmVvh01m8HMxYxh/CYCggAKK8XExc+H7oUPCvuDHz1niWOfwSiwVIvObs
         xpJGZgADWmnobVJbHq7EmzeY8E0/pqoG4uDCf3t0fNhza2jst7DzK7tSLswoe1VVDIhj
         fxGQ2FMZl8NIuvpWhFmU5cfTNZ0FTfk98qRZ2l5+8ahvSA797GW16h4iLYFj9zIvp2wz
         WW7J/6G17XmowP9UVhHBGiw8x4v5Ku4dgGImpMw1wCVXKgLhZDzilMPRck7x9LZmwrea
         b0V4aXZjE3a2Rk0qsfiF46CDjG+/cHTeVT6EJPruHivBKq2xIvqjyRLf+ZpJe9rYNzh4
         BrPg==
X-Gm-Message-State: AOAM533zQhDlEo9fo3qySFmLh82JT4BtT6yPlCzMXg5JbcWRrydbM6HT
        ZwEoV2QHJB1xr5uCew7c0bYqGA==
X-Google-Smtp-Source: ABdhPJy4eXa0DseBVUfptK+ZJ5ECzRMJW3DLsqYCv1XNOKBUDhbP4IqCmIWvuu9UONvVig+CWSFdDQ==
X-Received: by 2002:a37:4c9:: with SMTP id 192mr13359614qke.125.1596407324789;
        Sun, 02 Aug 2020 15:28:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id p33sm18333547qtp.49.2020.08.02.15.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 15:28:44 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1k2MTD-002q9U-LB; Sun, 02 Aug 2020 19:28:43 -0300
Date:   Sun, 2 Aug 2020 19:28:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joe Perches <joe@perches.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200802222843.GP24045@ziepe.ca>
References: <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal>
 <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 03:23:58PM -0700, Joe Perches wrote:
> On Sun, 2020-08-02 at 19:10 -0300, Jason Gunthorpe wrote:
> > On Sat, Aug 01, 2020 at 08:38:33AM +0300, Leon Romanovsky wrote:
> > 
> > > I'm using {} instead of {0} because of this GCC bug.
> > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
> > 
> > This is why the {} extension exists..
> 
> There is no guarantee that the gcc struct initialization {}
> extension also zeros padding.

We just went over this. Yes there is, C11 requires it.

Jason
