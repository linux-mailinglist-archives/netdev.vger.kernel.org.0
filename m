Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728CB2B1B03
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgKMMVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgKMMV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:21:27 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D04C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:21:27 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id c128so1845141oia.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sbC1qG8zSioKW02piBldjcpBPYKEAkPTsxc9blL8pI=;
        b=M/fN4TeInKI9iIFoZhBA/B7JHbdH469VI5FMsiyxKiMz4BxiNe6GsJfpa7ao+5i807
         C7mqXZAZKiB/6pGTWy+n9S80mZ4vZKMdXMp5k8PjLyUdidRPS2TUZQcOQCYtQaWeqbUQ
         gufkcWaRsNR7ga+vVDe/1z0/Enwq/1ES8rf+Kd7JFFLAh/ZDXfjVJurIboIv+DbaGUmN
         95BuLljXrS/y6inU+bWuSgtSh8jZLKnMY60dfoDI7LAZbBn/tTcM6HhmQKYMb4Zl9uSy
         h09LqjT08nccUxXFggDn/q/JRakryn8foM3F+djhyijS/5sU4u3h9uryzWr//BvXCRVx
         7hFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sbC1qG8zSioKW02piBldjcpBPYKEAkPTsxc9blL8pI=;
        b=R5slgdQHP62/tF8Veldt9s1VvkQENy0iRnISQ1RbURs7ntLH+m50AQUVhG9ysfvEdw
         zbF1obnhwJjNoAnHtYd2wT8Sg03f0vwWonb0wn5VMzKE7OHSOXIRIBnfQ5NU3b0d+Le7
         RfYdeouj9BDiZwMRZL5HplRfl25oqjTO3lTq9FSwasQTl+tvrHGJSmw96x3pmVLL6pfh
         nSbvsre0KYFRkNxllYfm1tSakCuXZpHV5EJotK9yCWsHLLVwVmsiKDmVf3Qio2hP6LOL
         rEEkejQrmdT8A8GCGuKp9yszkJ4SR1ftsyli9RMGoGSU6F33xISUfwms/ZSS/WIIahEE
         2s2A==
X-Gm-Message-State: AOAM533L6RQSV+amHimpO2ngNzJNyOwoVAMyq3VmL++ZjxlE0k/sia8a
        OgyMVz2+HUNIXNRYhhjB4keJ9onmyMjgvApMWiM=
X-Google-Smtp-Source: ABdhPJzX9jg5cq5dG+5++Gsfi1QGmKNwlRgdiQ6mh2IDQIWp2iRDiec6us7PMVSVUT+wawA55HiWNmvuW04RTwY+Na4=
X-Received: by 2002:aca:bfc2:: with SMTP id p185mr1259388oif.60.1605270086690;
 Fri, 13 Nov 2020 04:21:26 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
 <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
In-Reply-To: <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Fri, 13 Nov 2020 13:21:16 +0100
Message-ID: <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com>
Subject: Re: Fwd: net: fec: rx descriptor ring out of order
To:     David Laight <David.Laight@aculab.com>,
        Andy Duan <fugang.duan@nxp.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 8:33 AM Kegl Rohit <keglrohit@gmail.com> wrote:
>
> > What are the addresses of the ring entries?
> > I bet there is something wrong with the cache coherency and/or
> > flushing.
> >
> > So the MAC hardware has done the write but (somewhere) it
> > isn't visible to the cpu for ages.
>
> CMA memory is disabled in our kernel config.
> So the descriptors allocated with dma_alloc_coherent() won't be CMA memory.
> Could this cause a different caching/flushing behaviour?

Yes, after tests I think it is caused by the disabled CMA.

@Andy
I could find this mail and the attached "i.MX6 dma memory bufferable
issue.pptx" in the archive
https://marc.info/?l=linux-netdev&m=140135147823760
Was this issue solved in some kernel versions later on?
Is CMA still necessary with a 5.4 Kernel?
