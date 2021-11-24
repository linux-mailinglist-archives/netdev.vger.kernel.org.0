Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A9B45B131
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhKXBqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbhKXBqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:46:24 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC962C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 17:43:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b68so1025257pfg.11
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 17:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tOYRp/GV8uMdWSGvSr2/mOBrTDpDqxtUYQ/lLb5JxZo=;
        b=bA37T8tdVOGDvUI+tOFdvsMi2WJrcFIEfRGIZ3KhpHN7uUfygvJEdFAqr67fmcYo1j
         FEudfx5MFqwEnDmREczsm041ytcVuEGyuDydZUsb7O+C2mZ0tWAjx+vkznhS3AkIB/ar
         PelQXUjq20zGpgaFmKoyllkhv6zjyjmtEuDP9aSLBrQOb8KWczAnr0WEw/lMqXF0Jcvg
         n9ZvglRT7a/wjdNqiIFWUhhr4Au+pGVdo7j+ay3Pa+CzL6l0sTg1FqSJFjzhVOsUbv+x
         aRU8d820y1XoTFx3AnLWLBXKZTbw6qVWYU0gPuzyedFHwwB6eh7MgFRFWLCRKWkD6Xh6
         03xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tOYRp/GV8uMdWSGvSr2/mOBrTDpDqxtUYQ/lLb5JxZo=;
        b=NPmqsKLfW4TV5Ij9ZZVOdOW06mI6ZMVp8LLAmGG2itMgTBzLYwZqW0wdbmmBgExCew
         xgneq9O3vYi843EtfA6ZwQf82Vzr6eH8PgUC98ZH+7YxhvxftpxafIJUdohLBgIAhnRq
         v29bw1chGsaLXXVIlJjXFB9zDVkbLzP3L30HMLLjmm4G6AXDCpxz2XYPpHjGXOIpctZz
         vhRyAqhs2KkgxHdknKUcwPnjeN2T3Cn7iWhlZlYMuLSGt+5Xcb14KBneiRu0MX4Cylmn
         dupd9Kw2nDwkaRkhd/LWQ9ODPXnYfWkMjkM0xLJPe8AglAItUaiyNMmBc7PA1kossa32
         H9qQ==
X-Gm-Message-State: AOAM531ZId8TXMs+Wy4wsF6nnrKEaMrfqceYLIewxzxgV0bomlzyWiug
        m8oeKO5dM9vKM9dCP2iy4w5EzJzyTRM=
X-Google-Smtp-Source: ABdhPJx2g1EugCKbpwWdkVucXTSE+VYdECJ7b31WU32DpBXJbFwL7cyXy2bDqjqLUj2HSjpZMi6dbA==
X-Received: by 2002:a63:4745:: with SMTP id w5mr7189096pgk.320.1637718194316;
        Tue, 23 Nov 2021 17:43:14 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v25sm13819469pfg.175.2021.11.23.17.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 17:43:13 -0800 (PST)
Date:   Wed, 24 Nov 2021 09:43:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Message-ID: <YZ2YrPGJSEm8UAiv@Laptop-X1>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
 <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
 <YZR0y7J/MeYD9Hfm@Laptop-X1>
 <d83d3013-0a06-b633-fded-b563fa52b200@gmail.com>
 <CAM_iQpUHLy8mxcztVKAcRz22-VeDUHwTV5g5UgmxUhQx8hQ9Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUHLy8mxcztVKAcRz22-VeDUHwTV5g5UgmxUhQx8hQ9Gw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 05:05:14PM -0800, Cong Wang wrote:
> > > On Sun, Nov 14, 2021 at 09:08:41PM -0800, Cong Wang wrote:
> > >>> Hi Wang Cong,
> > >>>
> > >>> Have you tried this test recently? I got this test failed for a long time.
> > >>> Do you have any idea?
> > >>>
> > >>> IPv4 rp_filter tests
> > >>>     TEST: rp_filter passes local packets                                [FAIL]
> > >>>     TEST: rp_filter passes loopback packets                             [FAIL]
> > >>
> > >> Hm, I think another one also reported this before, IIRC, it is
> > >> related to ping version or cmd option. Please look into this if
> > >> you can, otherwise I will see if I can reproduce this on my side.
> > >
> > > I tried both iputils-s20180629 and iputils-20210722 on 5.15.0. All tests
> > > failed. Not sure where goes wrong.
> > >
> >
> > no idea. If you have the time can you verify that indeed the failure is
> > due to socket lookup ... ie., no raw socket found because of the bind to
> > device setting. Relax that and it should work which is indicative of the
> > cmsg bind works but SO_BINDTODEVICE does not.
> 
> My colleague Peilin is now looking into this.

Thanks Wang Cong and Peilin. Sorry I didn't get time to check on this
issue.

Thanks
Hangbin
