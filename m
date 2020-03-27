Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2629195A9C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgC0QIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:08:09 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46758 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbgC0QIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:08:09 -0400
Received: by mail-qv1-f65.google.com with SMTP id m2so5113589qvu.13
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 09:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6d7CjkKwOJ6/75cMo6cG150E0b5j4qklpYgJXNLC6is=;
        b=fogSYuttuQ89mf6Se0Gm/eq3Q5j806h3/yEOlVqgNWwxtrqnuFK9sCyGiF50X43D0i
         2lLF30thWJzXcWNWmf0kbr1hhVV+n3fyccKllre7eNb8MD8fYvh9RmlPaXIbQeFdcmvB
         Mi9E3pkM7fR9QkC/BMKREY0PBhtpSfdlJdh6SUD8LotH2TtS3QGm1V8uz7OBYIKWYckM
         xcKv1YpvlmtDdteOs/FZ8SadaSHRZfI+kRrxD5mWC73nrj9CJ+HYswX9oacLwBXQ8oU1
         HWa9+ljzm6eaFPBKpEQDUQT6YKGAvYayaBrzm87Zw2ui98cFQgXsDBeZRFggRc7twVjk
         yy2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6d7CjkKwOJ6/75cMo6cG150E0b5j4qklpYgJXNLC6is=;
        b=DycznZb8JY/bWua9VmejL3XDw7u9W2xAGa+c1pSzkUxCSS7BJd+4sSNX6ED9Y2JRbr
         m6gPqn+NsGYceEWJjDpud0ccdn3y9QpE4t1FEAwg79rSse9hEbM5coTpI9cxG2qL236V
         QBEVTFPxDSGTgCeSOgnAd5S68P8kQdB6lgKDY6NmA1Qk6nvWTNZ+abUNhKRJAgyS8NqZ
         YxQFjvgFwQayHsNiSS5LzhBCNh7O+GKbBPFYF4t/C/b41YgrAhzCmst8gvLUPzcTOfRB
         7ILUtYYqwSBVoNLV1v976/5TQhOMYKMSHql4t7pyCPZPoSE4QJEz/RpyXTAOAZ+wy/5u
         eyPg==
X-Gm-Message-State: ANhLgQ3cJvtaQbKxEYMqX+LW+S83z9sBmR5H33DyIZ/6NLE3UBYo2skG
        9P3FE6GYvRXaMKULrtbVbq1nSUYmFIcDSQ==
X-Google-Smtp-Source: ADFU+vtNjGH2j2KjqdN1B464a5k7E/2Bo0HG17gxirwAirXD4vOznGQ1x4vOEDCunyE8HVmhnCEadw==
X-Received: by 2002:a05:6214:1863:: with SMTP id eh3mr14444312qvb.71.1585325287800;
        Fri, 27 Mar 2020 09:08:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 17sm3945919qkm.105.2020.03.27.09.08.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Mar 2020 09:08:06 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jHrWg-0006Jy-17; Fri, 27 Mar 2020 13:08:06 -0300
Date:   Fri, 27 Mar 2020 13:08:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/5] Introduce dynamic UAR allocation mode
Message-ID: <20200327160806.GA24265@ziepe.ca>
References: <20200324060143.1569116-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200324060143.1569116-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:01:38AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v1: * Added patch that moved mlx5_bfreg_info from global header to the mlx5_ib.h
>     * No other changes.
> v0: * https://lore.kernel.org/linux-rdma/20200318124329.52111-1-leon@kernel.org
> 
> ----------------------------------------------------------------------------------
> 
> >From Yishai,
> 
> This series exposes API to enable a dynamic allocation and management of a
> UAR which now becomes to be a regular uobject.
> 
> Moving to that mode enables allocating a UAR only upon demand and drop the
> redundant static allocation of UARs upon context creation.
> 
> In addition, it allows master and secondary processes that own the same command
> FD to allocate and manage UARs according to their needs, this can’t be achieved
> today.
> 
> As part of this option, QP & CQ creation flows were adapted to support this
> dynamic UAR mode once asked by user space.
> 
> Once this mode is asked by mlx5 user space driver on a given context, it will
> be mutual exclusive, means both the static and legacy dynamic modes for using
> UARs will be blocked.
> 
> The legacy modes are supported for backward compatible reasons, looking
> forward we expect this new mode to be the default.
> 
> Thanks
> 
> Leon Romanovsky (1):
>   IB/mlx5: Limit the scope of struct mlx5_bfreg_info to mlx5_ib
> 
> Yishai Hadas (4):
>   IB/mlx5: Expose UAR object and its alloc/destroy commands
>   IB/mlx5: Extend CQ creation to get uar page index from user space
>   IB/mlx5: Extend QP creation to get uar page index from user space
>   IB/mlx5: Move to fully dynamic UAR mode once user space supports it

Applied to for-next, thanks

Jason
