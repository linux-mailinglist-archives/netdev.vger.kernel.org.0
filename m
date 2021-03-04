Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC90D32CE4C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbhCDIUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhCDIT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:19:58 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61558C06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 00:19:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w9so17429968edt.13
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 00:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H3NNNzQtUvXt5Fye8sZNpucfc9FPlOfifbnnwnh2RMc=;
        b=ZoNG+FOvrEGHS/G3iAhwPINVlJ00oFmpga62+C65qKMJLCK4lSbZFux+QNQ8qcgoLI
         2Pjybn3zmN9ufzyxe+II872P6eW3hasLTfs1yAW7HjxrxeYpDk7mgOpHgQhwBtTR9UnX
         120J1MYC7h8BiR2cv0B3NBxL5kBA3hQdNerlmAn+uu7tr0QaIo6HREKBcyAts+hf4EFL
         AXpwqIU4unILaT5VN1PbiiyWAo4EsgeSAq/HTdr9Xs9VIxzE8MyPt6MbL2SB78rjnUM8
         vPKsXhynMiDIkKHlYSa6ASqoHyJHCgDQGWK77SWBDp/vpkM8MSgYz0CBNGLjynfHBBjG
         O3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H3NNNzQtUvXt5Fye8sZNpucfc9FPlOfifbnnwnh2RMc=;
        b=kAow9yBnsZvDE2X2rZwUBvu0XaltNFwdwlZ2sZtZjuk3reuVjVBHJsomLxmk61vP4m
         1Xflo4E2fe2dPNjeIqmFEGFSwyC+EZ2LTpYhiN0SI0VmWCjuMBGX2Rulv3d88fDKTmCd
         VVdD0QEVX4iAxzNjkGCX/VNWaJj4TW3j46woXexbrmE+KviVKsBzUfxbIwE8utiuvcFS
         NwpeXlxWU2lSNbqD2BH1Sx14JYYhh7iaiW4aBtaFwIrDqXI1OZoV5/hdZqouYA9q0Rj9
         cr1XFxPkM03ltCqfx20Q6Kxxw+A8ocGqcbJzVeFZQFvhk7smi8GWJ7+WBPhtc+odaoPa
         q/YQ==
X-Gm-Message-State: AOAM530Q6UO86yFEMzFSO9O7nURqCfaJrzdyG0KANqaGF8CskjhB/Bsl
        s6LvYlobOyndtlrRQyaiOycrBM4KHrlo29M13VnY
X-Google-Smtp-Source: ABdhPJw7SQ5FmCmRVMs4bNdd9alpNsZzQvjSqli5sYS72PmhDvyRbtBr1jsItQcl4lUj1MuiSdZrKEphdwvmCULLauo=
X-Received: by 2002:a05:6402:3122:: with SMTP id dd2mr2975252edb.253.1614845957202;
 Thu, 04 Mar 2021 00:19:17 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-12-xieyongji@bytedance.com>
 <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com>
In-Reply-To: <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 4 Mar 2021 16:19:06 +0800
Message-ID: <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
Subject: Re: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
> > injecting virtqueue's interrupt to the specified cpu.
>
>
> How userspace know which CPU is this irq for? It looks to me we need to
> do it at different level.
>
> E.g introduce some API in sys to allow admin to tune for that.
>
> But I think we can do that in antoher patch on top of this series.
>

OK. I will think more about it.

Thanks,
Yongji
