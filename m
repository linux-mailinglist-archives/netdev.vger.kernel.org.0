Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60EF32B374
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349773AbhCCDzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349600AbhCBKmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:42:37 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F33C06178B
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 02:32:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s8so24539148edd.5
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 02:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aHiivO66cBlvi2omwE76dmO7GHvGNT96Cj5+nu42PGg=;
        b=I3uOr+q0RQRgiQgCS80GYwUSkTQnW9aaq4gmyDrvqidORji3JQgKK5Gk6gXKJx4JN6
         Kdw/xd8w7zZL+nnUxuSZdMOnoz9eiyotnG5IKpT+Ud7NlWqTrt6YooiYlRRVi02JJMMr
         4VYaUBZaNWsU4GxWuGvtyzk3NIV5/ZljDQKPkS7H3te3Wt54mTXFOXDjC2JdrQuaoHhI
         QtV+wrlNU3ReiikOrRqrSIVv+puzwruHdJKxH4oXnS6xb8gPwknLRq7pC4a/EOpknuQO
         +skcqqGEbtLCSfYhVvBfpY3tTCreILgdD5pwsxFpWM3+87sOSq+Bypy84M9wCvwAd7bE
         Twvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aHiivO66cBlvi2omwE76dmO7GHvGNT96Cj5+nu42PGg=;
        b=hItwfooYEgkNxhfvJPGJqlEETCs/EAHSz4cCe53hiagJnF32X2Fp5fWcwcbv02aMLc
         149XZRMGhwXPkHYOYqZiqVqhEDyPeYfDKWwx5bV/pKqXMTMR3Ta5E3KVFBtQ1Vbi7X9A
         lR5waIiQO599OygXERevuJ/Gl3vvib15vl6zUOg8lgrguoixUwbXB1i9LMPd9L9CsPMz
         DMYwmJe3iFPUBVdTel40sCWKtS0HB91lkcrFxgHuhv5O/tMo3pgRR/0NNOBO2PVO5iW6
         H4jmsWkovLnbabyuZQECuNu6VJC12WzzP960jMdKxVILTOXRyoS+7giKZNOC3l+55Djm
         8QWA==
X-Gm-Message-State: AOAM531cW6IOi9jR4G0TuIkgIhqAxjwuV5Gez6Y0hEiqwPTn8+t5ib0d
        WmLyWrY4Up0arB8vVh0grLCOQeyiAb9/RjOxjM1R
X-Google-Smtp-Source: ABdhPJzlkbp8GXrzTY+Abm6IQL/bSnnCkhRKckW2ZUkdVHBw9ERA3un1YwUAbOK+Sq4gG6u3AkoG0LR4jYRsbg5g92Q=
X-Received: by 2002:a05:6402:180b:: with SMTP id g11mr10194555edy.195.1614681131866;
 Tue, 02 Mar 2021 02:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-2-xieyongji@bytedance.com>
 <22e96bd6-0113-ef01-376e-0776d7bdbcd8@redhat.com>
In-Reply-To: <22e96bd6-0113-ef01-376e-0776d7bdbcd8@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 2 Mar 2021 18:32:01 +0800
Message-ID: <CACycT3vYA-2ut31KqzL2osGHDxRB_fTJBGyt4M7FvNkfv7zu7w@mail.gmail.com>
Subject: Re: Re: [RFC v4 01/11] eventfd: Increase the recursion depth of eventfd_signal()
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

On Tue, Mar 2, 2021 at 2:44 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > Increase the recursion depth of eventfd_signal() to 1. This
> > is the maximum recursion depth we have found so far.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> It might be useful to explain how/when we can reach for this condition.
>

Fine.

Thanks,
Yongji
