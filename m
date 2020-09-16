Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D226BB37
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 06:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIPEFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 00:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgIPEFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 00:05:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47203C06174A;
        Tue, 15 Sep 2020 21:05:17 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d9so3201413pfd.3;
        Tue, 15 Sep 2020 21:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J5hBLNAeKi7sYZ3kBhjD3Odx80a8hnn7AnndRx+Ra8w=;
        b=JI6cl06/ZTc9Eqe4z9EIUEoq8cN7ktx+bhfqFUaPKb9qD4Ftz8EmjiAa+6pJH5y3kl
         ztEPpr9a1qYIM+MxU7OIaCWSrLAn6Hzepv3g/YbrWuHmSjKpLd8Rt5rUt6eMBjsdNONV
         dLbulSM55aHScKGon+ECfE7K9eZe0Z73KvnepSSaL+TZGp4KbsU2uUrFbiPpBw6rfAS0
         mBg+hUuCgaQ47Ff1pw2L6aYIG/Xo2k9pz8Ewjkt5WcQlOrzyfv/ZnD9WD/WR1z/sGosJ
         hVEa2uaTzJs7A5PM3RoUzHdPa1FTViY0ptVCFcwXRpX0m5e7xyVcYF1DxxC7qCr5SOli
         iwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J5hBLNAeKi7sYZ3kBhjD3Odx80a8hnn7AnndRx+Ra8w=;
        b=C5lPEGj0N7h+oaoNMX0HM4fqBiZj5axM/4nucMTqxslpcufKKQhGmd1+l7WlVyjWeN
         igBORQJAZS1PrPDVw0QvZceb4Z/160OPwDTHx5T7WCcI0d+BHXckX4HRNDvyYB3lnXqm
         jWzomRh2P6UdHC9O0tMtombzEYlmvenCFF0i4kKDB/QK52zrWAWtXMzQxDjNyLJGS0c0
         jWyhSKT7Y2LPyQDCGi02LZ3D9rN8Ld8SdzDcXeviIiwguti+6ejfL0Xg88ef4APpUB4o
         PchgbXgDHcgWIO7Yr0QZzTAfzLOn3Sf8hK2fHpD2TNKkG13mI59+PzUR5uqIFl8dJiAt
         jAkQ==
X-Gm-Message-State: AOAM532ZUPfawu5z+HRj/yP/viG/nl/po4EAawnt7d274/KDd/kJEk/O
        bI+HsFG+dWD6YAC/2yKBv2o=
X-Google-Smtp-Source: ABdhPJwuBQJfISTIpXKH+vrbO4W1krC4th+wfsmwkF0zsNhfMBFZefvLS0SVIQPZr+pLCQ+S2HXWGw==
X-Received: by 2002:a63:521c:: with SMTP id g28mr10130802pgb.43.1600229114515;
        Tue, 15 Sep 2020 21:05:14 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id d25sm7586887pgl.23.2020.09.15.21.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 21:05:13 -0700 (PDT)
Date:   Tue, 15 Sep 2020 21:05:11 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org
Subject: Re: [PATCH v4 08/11] Input: hyperv-keyboard: Use VMBUS_RING_SIZE()
 for ringbuffer sizes
Message-ID: <20200916040511.GH1681290@dtor-ws>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
 <20200916034817.30282-9-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916034817.30282-9-boqun.feng@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:48:14AM +0800, Boqun Feng wrote:
> For a Hyper-V vmbus, the size of the ringbuffer has two requirements:
> 
> 1)	it has to take one PAGE_SIZE for the header
> 
> 2)	it has to be PAGE_SIZE aligned so that double-mapping can work
> 
> VMBUS_RING_SIZE() could calculate a correct ringbuffer size which
> fulfills both requirements, therefore use it to make sure vmbus work
> when PAGE_SIZE != HV_HYP_PAGE_SIZE (4K).
> 
> Note that since the argument for VMBUS_RING_SIZE() is the size of
> payload (data part), so it will be minus 4k (the size of header when
> PAGE_SIZE = 4k) than the original value to keep the ringbuffer total
> size unchanged when PAGE_SIZE = 4k.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Please feel free to merge through whatever tree the rest of the patches
will go.

Thanks.

-- 
Dmitry
