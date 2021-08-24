Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB84D3F6A04
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhHXTnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhHXTnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:43:09 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33196C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 12:42:25 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id a5so4285290qvq.0
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 12:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hde1shT/OxB+qRx2Xq9vmaKrjDQveqoWsvLQBY2Xh40=;
        b=CnYzRaCW/jLAojTXLb8SRLO4puqDphVJJ8F1SZ39CWuq8Dj6v5/Bd8tMS9XBQDAeF3
         K64S6HfQb4gOeMqZlEviCwGbh3tP9In0S0HBHJne0bm+uVTOelvdwl3dZdlvQPgagche
         oEznP9oX6pkgXwExbPIS3bZFXkWyEERHoOj2TnJg7WNHYL2KI73gN4NJjI7sOxS8Ut2c
         808yNq2bR/pm10C8wnC18+l2UqZayDtiTcxQR744S8sp8PkEDi7EOJNowF4TwXs8CJMB
         VkHDJSOH0dnnSguiZV7MhAX4IgjaIwjgyVAwbD57vg1Z11dw8S8HAsS2F+bPndNk60PQ
         XUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hde1shT/OxB+qRx2Xq9vmaKrjDQveqoWsvLQBY2Xh40=;
        b=QN/7uxgONDVlQgJ9WsHQbavjUN6qPDC3umC2tnFgzmcZ0eksP9mj9CfLJGjYQKuN4B
         jIsMyIEkdaQj+Q/PlI+F7XVYw3aIXB3Y6QXYGQbuDtfhYBfF+nbhGNR+TbYKK5OK2swJ
         v7Wt2r5LowQASyyNZenSd/YiNsFmq2ZI2YZ9qD/OxcAU/1HXR83d/Qwn9dBIoGLSKVp5
         txiTSYk+EzmFaEa9G3N79eh7GzE05yhWV9NdmJGntmByYdYW8BiKh2wrHpzfY9M/XRVd
         2/p3z1yd7sh3LXitUYNbkAlbi/uzLmIs75HSt28uE5lcpww9857jxjrcS/WwWjtD46wS
         UXbQ==
X-Gm-Message-State: AOAM533mx1TPEkTqnMImQ0h1gYb3I/Zwr6Jx0i8nzosYTns1TqSjphIW
        M3cSULUjt03cT1CEVy2m86vfUg==
X-Google-Smtp-Source: ABdhPJxQrsLdTCt9F6IciUJnekUbnM3vc9RgLEAykna2FApDLInpVgWoDQI3aw0UK+PFaQ02WUtKMQ==
X-Received: by 2002:ad4:5c68:: with SMTP id i8mr40510515qvh.54.1629834144423;
        Tue, 24 Aug 2021 12:42:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id i67sm11555872qkd.90.2021.08.24.12.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 12:42:23 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIcJT-004ZYj-Cs; Tue, 24 Aug 2021 16:42:23 -0300
Date:   Tue, 24 Aug 2021 16:42:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <20210824194223.GG543798@ziepe.ca>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal>
 <20210823133340.GC543798@ziepe.ca>
 <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
 <20210823151742.GD543798@ziepe.ca>
 <YSTlGlnDYjI/VhNB@unreal>
 <BY3PR18MB4641E80F8ABF42A5621B7573C4C59@BY3PR18MB4641.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB4641E80F8ABF42A5621B7573C4C59@BY3PR18MB4641.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 07:16:41PM +0000, Ariel Elior wrote:

> In our view the qed/qede/qedr/qedi/qedf are separate drivers, hence we used
> function pointer structures for the communication between them. We use
> hierarchies of structures of function pointers to group toghether those which
> have common purposes (dcbx, ll2, Ethernet, rdma). Changing that to flat exported
> functions for the RDMA protocol is no problem if it is preferred by you.

I wouldn't twist the driver into knots, but you definately should not
be using function pointers when there is only one implementation,
eliminating that would be a fine start and looks straightforward.

Many of the functions in the rdma ops do not look complicated to move,
yes, it moves around the layering a bit, but that is OK and probably
more maintainable in the end. eg modify_qp seems fairly disconnected
at the first couple layers of function calls.

> In summary - we got the message and will work on it, but this is no small task
> and may take some time, and will likely not result in total removal of any
> mention whatsoever of rdma from the core module (but will reduce it
> considerably).

I wouldn't go for complete removal, you just need to have a core
driver with an exported API that makes some sense for the device.

eg looking at a random op

qed_iwarp_set_engine_affin()

Is an "rdma" function but all it does is call
qed_llh_set_ppfid_affinity()

So export qed_llh and move the qed_iwarp to the rdma driver

etc

Jason
