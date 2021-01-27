Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36A305632
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhA0I4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhA0Iwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 03:52:55 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B622C06178A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:52:03 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id r12so1500034ejb.9
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f/BR3uffwCyKx030EOkRgzSWxdzdCXfeE28wpSAa58Y=;
        b=QUJYhXbNodk+o63FOmt+aJqQNARu3xF051Xgap7AiAsac2APyzh3C2V4XjdpABL06q
         TS+0E224fGJUvGffdSfvcXPhq2h2Wmc5MuoGU5W8wMX17dFHeTIp/zMhPQPqCLeMqZz1
         I6u7jM8fgFC4YJ4sqi6KEqjZF+ZavubKCelXuoORBwRsVmaCa3gxuN2f+KT1nm5nvEb8
         mAmKw8WnSHcwVykR20t4VOK32WvXPtaHi/su3FeL6B2JwFtKuQoOaDEefx/jAIdR4MiW
         L/wDiCprEQ/ddM70E/Lev/DyIv46vkcEJOXMbxWf18n64dBBPulTDNUvUJtp7jV0At9G
         ikKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f/BR3uffwCyKx030EOkRgzSWxdzdCXfeE28wpSAa58Y=;
        b=p6NsZLsfcfUuiZXWovQNvzhpjBhHnU0pbqAZ8O+KfOjSJiMpefw4L/r6HOt/Lf5DiY
         ptNZ8tbrbmY2HRtU1xm5rIfkuAZfJw4Z3M5dCDVjmp4yAGjQr0wfA9lxcfin/E8mHWgX
         vQCLXSGwUpVeJWfGuxHKe2KYVZC8O/XlTve5vAp1uMDw2cdRcwS2LxjStxoyYRn5o88t
         TNpL77fR103BcIZTEel3UyluJEk+0kYH6ezlaGAnpRWnSxNGs6AOefqS4PzbBn3UglYN
         tyax8MdTJ/hJrREeGds7T5HAno1ZhTUsp5/pzEMscvRFepnxfRITdu48w9TfYbXPzMkU
         ahZQ==
X-Gm-Message-State: AOAM533jKbebbujwMj2CsIS+SGFzYWkdc4rfc1KHRrSUemOdjOL6IV+i
        mYVU/UR5C22bTiNS3PjfU6qDphuu08Y3BUbSRb/Q
X-Google-Smtp-Source: ABdhPJy8QImyO/JV79mc2tjpskMBQbjCVHOC5cdkEvkwAJ6kHk13J3Oa6D7gnCZsrqApWB+pINgU3unV/iSbuPna1vA=
X-Received: by 2002:a17:906:128e:: with SMTP id k14mr5870557ejb.427.1611737522225;
 Wed, 27 Jan 2021 00:52:02 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-4-xieyongji@bytedance.com> <406479e4-a4f8-63f3-38f5-b1c3bb6e31ab@redhat.com>
In-Reply-To: <406479e4-a4f8-63f3-38f5-b1c3bb6e31ab@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 27 Jan 2021 16:51:51 +0800
Message-ID: <CACycT3vFafH=-KrVu6_ypCR1bnyVwziOmFO552JSkq4fk+6yHw@mail.gmail.com>
Subject: Re: Re: [RFC v3 10/11] vduse: grab the module's references until
 there is no vduse device
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 4:10 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=881:07, Xie Yongji wrote:
> > The module should not be unloaded if any vduse device exists.
> > So increase the module's reference count when creating vduse
> > device. And the reference count is kept until the device is
> > destroyed.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> Looks like a bug fix. If yes, let's squash this into patch 8.
>

Will do it.

Thanks,
Yongji
