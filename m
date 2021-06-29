Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EC23B6CE4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhF2DRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhF2DRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:17:48 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D36C061768
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:15:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nd37so33734574ejc.3
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSP9MnxtnkwaBaqFffC1/G5CwF9yGzg9W9Q6U/eCMio=;
        b=trz9EZjpzzDlN+qvVOvq7umsssDF2IXsOdePgArPhNfrFD+HeoNYw9g9xzyAhb8MKk
         mmpCQPnoQeSyx8U2dU/uHBBXJuxYujR+dpmYpf3Zajl9fTas6kctAJkBbjgRzfivg2OB
         yj1qDXf69FF6HUXTycchd0vTemH3qRAeHyMtHGpVClkd54HdkzVoehXk+f8vp1TZ2hPu
         9dQqlEUIafRa41+2OmLox/HCo9ezTTkzCk0hQDZRSKY6n10tM+7jdPeJBHXWWcYvV132
         Wwywql7RSG4MI6Ib23cSV71szhrFJRImsg2bQDJXmui0IrqcBxD8391lxzBVfzYZTccD
         E6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSP9MnxtnkwaBaqFffC1/G5CwF9yGzg9W9Q6U/eCMio=;
        b=BIodd8G+rzDS673viq+fiG+IhZH3qBa0ZkjIxR8g/6yJ0es2R921HeDsAnRiaFJAgH
         FJG+eA9hrNYwf2myj/sTF06ej4fpXRWetVqu9+G8mG0tVtYn5uG+CX71N7aOC5ut/BLw
         dkydKkDy/fabTsRzgKkLCT0G9QNZs4buLIBUbI/axrpFPfW4mcMewR9nVEJ0CbS9RIi9
         hj+uGgzr6yOJ4/ToZfXre6W5rSgDMWwmxLrnVx6bIz8SLp18kMukQUfvj16Cye9slSXc
         dDd0l+qLAury8N+SfPm5l6+J0PQsJV0UyzS53XcsvctnrL7cY4bj8MdA7bRye6EmdtoY
         v4pg==
X-Gm-Message-State: AOAM5338f/BOGmshuZafiQA0mObq+IqXSJqbmyMyMtM3gy1TdVhwRhM2
        A6AyR4vJdBajCcTb4DPAsX3e6FCZN6Kc5EWTP0c3
X-Google-Smtp-Source: ABdhPJygNTq8Wi5J8lQUEA69a0KDIXQbdUPLuUv1X7DgdTJUivR6hqFwxAoue0nTaAaGcU1j++UWvcm4NWY1mqaUomU=
X-Received: by 2002:a17:906:3c4a:: with SMTP id i10mr26893189ejg.372.1624936520374;
 Mon, 28 Jun 2021 20:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <YNSgyTHpNjxdKLLR@stefanha-x1.localdomain>
In-Reply-To: <YNSgyTHpNjxdKLLR@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 11:15:09 +0800
Message-ID: <CACycT3tDpK+eHatDKRkvt1qyA5cO6g4qGN+0nfm3EhFA1OwPww@mail.gmail.com>
Subject: Re: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 15, 2021 at 10:13:21PM +0800, Xie Yongji wrote:
> > This series introduces a framework that makes it possible to implement
> > software-emulated vDPA devices in userspace. And to make it simple, the
> > emulated vDPA device's control path is handled in the kernel and only the
> > data path is implemented in the userspace.
>
> This looks interesting. Unfortunately I don't have enough time to do a
> full review, but I looked at the documentation and uapi header file to
> give feedback on the userspace ABI.
>

OK. Thanks for your comments. It's helpful!

Thanks,
Yongji
