Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BB538B809
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbhETUEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbhETUEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:04:50 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FF7C061574
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 13:03:28 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id v4so13742299qtp.1
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 13:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C/+vTD+2ra02aIrojfRO5PS5Iv9P0dSQotJ3idCKxkU=;
        b=SYrqldV+yrCUmxhxlnjgEL5gDTYGlJxY1AmlnUOjGwqwgbk5gYDN20NAqlcuM8Zemv
         t2F4ulXhIxtukfhNPWnXOPC9mZg3i3yz//lr9GLS9YC5glB2cfxuKOBefzlkifiAsSpU
         vEHmDeU0HcGQ1eDDP6P9/vzvU0GSwPzw+WpY6xIA4EBDnAsxtQfZkSiqwIgdxwt5MHtc
         m1h7InUqXmdnUcP11qYxtSvsXO+Hjn7QXxGNziRXyw3Wi6FQDJNJp2c0NxJ2RmswXuns
         hoUChIVzrPONVoxwHGIvwOiyJmiWjGX1RhVcjicKviOE5kRttkavMa85mVu7jhBXW0CX
         wmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C/+vTD+2ra02aIrojfRO5PS5Iv9P0dSQotJ3idCKxkU=;
        b=Rd3QtANJdXUxi6xXUP5djK00V/giweOMiRrVM4PDwqPrft7ZDrbIAxIWe50C1Cpexq
         52EAanHWwtU6Jz/i8giIjbQJ0td+PRTqrtEkYO/mOqw81BqkveqbpbANh4XxuW9GLBgC
         TvPyh7ILSFFLpRsvS+RAnR274ttixnEvQ4FqfD105Iwrgvfnb0HJLIM2+76MtNCPXUCa
         8vFu1HdgZibIW+gwlB1Zwtr/jBqQpMV++RWCh779DmDYZR2Lk7GGS6Xu3IyafHdrP9yZ
         0YQoNblj4Mkl4+/Q++MriYW60tvD0BimV1SNT7naW16d+4ua92Hf0UD24Qmqa30S9Nn9
         kBaQ==
X-Gm-Message-State: AOAM531XYoqHoIT+0mhr6GHA2zoUgSifXMpKKG0wH4FHbHJIZoU8xvRN
        pilUhFmrOIJrwMFk9V/V7Ka+5w==
X-Google-Smtp-Source: ABdhPJwu5l/r/vIA6Iz+wI2IUcU9fL/hLUSk4qsM2tr+ABwERp7VBauGL6o7RiExCuwsnuQzgRWyvg==
X-Received: by 2002:ac8:6605:: with SMTP id c5mr7356037qtp.21.1621541008165;
        Thu, 20 May 2021 13:03:28 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id z18sm2730885qki.55.2021.05.20.13.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:03:27 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1ljotC-00ByQE-CE; Thu, 20 May 2021 17:03:26 -0300
Date:   Thu, 20 May 2021 17:03:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v6 00/22] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Message-ID: <20210520200326.GX1096940@ziepe.ca>
References: <20210520143809.819-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520143809.819-1-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 09:37:47AM -0500, Shiraz Saleem wrote:

> This series is built against 5.13-rc1 and currently includes the netdev
> patches for ease of review. This includes updates to 'ice' driver to provide
> RDMA support and converts 'i40e' driver to use the auxiliary bus infrastructure.
> A shared pull request can be submitted once the community ACKs this submission.

Other than the one note I think I am fine with this now, but it is
absolutely huge.

The rdma-core part needs to be put as a PR to the github, and I
haven't looked at that yet. The current provider will work with this
driver, yes?

Next you need to get the first 6 ethernet i40e patches onto a git
branch based on v5.13-rc1 for Dave/Jakub to pull. Resend a v7 of just
the rdma parts once netdev's part is accepted and I'll sort out the
last steps for the rdma part.

Jason
