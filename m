Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34CD35A48B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhDIRUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbhDIRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:20:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6D2C061760;
        Fri,  9 Apr 2021 10:19:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r9so9840136ejj.3;
        Fri, 09 Apr 2021 10:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DleQ7VeK2meirvzYzHUPaLLy20dHNBvI8Mjkq4A3H1s=;
        b=j22BykHfFoyhwXi6yVO9ewnjs4GZk3+4853WEzYDBBJ4lEQHhs0VYUwbgMq8AO3SE3
         aQPpLFn75NHmz+AOIAiK5UBPomT6w5Mty5DuPTIsVuT3HQSBu7liBGHu/6nhgZcg1PQY
         ZkpMYGHo7MTD+ZVXWS7QScEjZoFAs8JQjWj/WK6ebfROWhNPxUaqTwvNPMZi9+q3cM5+
         HrL/iIe/6B+RmyrjqO6V02GNnl5KVcK3g49+Fc6DuVED4oAYy36ZrFT/GnIfEzL4srs0
         L27TR5myLoiStV72W5TnIlyHGLXhrE/hQ0Uakz/tFSje2vR9DzUxlM1T7xOLR2jSh4cD
         eiSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DleQ7VeK2meirvzYzHUPaLLy20dHNBvI8Mjkq4A3H1s=;
        b=AHBhNDHAMJL4b45Ht9Qu9YVZzljBXTlEZmNqLl2Ki2qnjse/4UaQ+fopCryAQI5ZxD
         ILInWCiisqHkSuBsG78S0/9vwmmvz7/0PnPF8/DzM79t0Gn6CgB1kODFuxZDpmg/xbzw
         rwA33LTKYDyTGNqwTjDUEizjAQVlcQ9ICD80tzh0sigKPBgyqPqjfUXDm+vaDzQjlj4x
         zfbhRF07ZzCo7HS6k74q7uQDuEGASwyF4U8efd8PNiegfEwoAPcEcAeldgOV5aYDEN0t
         9kpZbsnCDsYCnOYG1J+wqKhMa3pHikdGTZ3SWb4RF/QpNoroAUmrR97iGK+2qq1tkPC7
         05EQ==
X-Gm-Message-State: AOAM532GtWYC7n3Jmv08SUR3vsXr5y4PSVGr/1bEwUol2SYdBFGyqIvh
        MX96C6fdWMU2DoiJt21EdvY=
X-Google-Smtp-Source: ABdhPJw59Urs+Bg3MLQeNl4rjtDBFUthpekCWV6+UGY8tQ7Zf18ebh1qO3qx2QEL1SmMzS4ngh0yew==
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr17174327ejx.450.1617988789377;
        Fri, 09 Apr 2021 10:19:49 -0700 (PDT)
Received: from anparri ([151.76.116.20])
        by smtp.gmail.com with ESMTPSA id k12sm1762352edo.50.2021.04.09.10.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 10:19:49 -0700 (PDT)
Date:   Fri, 9 Apr 2021 19:19:40 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>
Subject: Re: [PATCH hyperv-next] Drivers: hv: vmbus: Copy packets sent by
 Hyper-V out of the ring buffer
Message-ID: <20210409171940.GA3468@anparri>
References: <20210408161439.341988-1-parri.andrea@gmail.com>
 <MWHPR21MB1593B81DEB6428DC3FD6085ED7739@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB1593B81DEB6428DC3FD6085ED7739@MWHPR21MB1593.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:49:00PM +0000, Michael Kelley wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, April 8, 2021 9:15 AM
> > 
> > Pointers to ring-buffer packets sent by Hyper-V are used within the
> > guest VM. Hyper-V can send packets with erroneous values or modify
> > packet fields after they are processed by the guest. To defend
> > against these scenarios, return a copy of the incoming VMBus packet
> > after validating its length and offset fields in hv_pkt_iter_first().
> > In this way, the packet can no longer be modified by the host.
> 
> Andrea -- has anything changed in this version of this patch, except
> the value of NETVSC_MAX_XFER_PAGE_RANGES?  It used to be a
> fixed 375, but now is NVSP_RSC_MAX, which is 562.
> 
> If that's the only change, then
> 
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>

The only change here is indeed the value of NETVSC_MAX_XFER_PAGE_RANGES,
apologies for the omission of the changelog.

Thanks for the review.

  Andrea
