Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCA3926A7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhE0E6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbhE0E6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:58:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855C5C061763
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:57:20 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s6so4146466edu.10
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YJ0dWA2LN7YqfF1ySTSNQvt81ovDnTZhfscP6j/isLs=;
        b=gKB8fvK0cCWN4lEkm4wDH6rz4Sa0FsxRwsg5F16JeFZeSk5+GIGcIQz76DqI7jCKna
         1n5SBDwT2tPkv3xz9FZpqyHuntur92hGyhaJqhPLvrxOpxjMAwWwnzEI+ond1RyDNj2M
         hSKTWiLfyXawwcHjtm/qvhYeQS3O4ky+w5QeGyceqwSLyP/TheaH2Ne18IVUbd8qIt3/
         KCdb3Z51nRn7l+3Pmv10fGurtavWFZ1jh73TQbyQtJqZwO5c78iH8kmQAAcbOJ6mGvgX
         3uDqtsAOrG8BYjKnqsMxPZMs+PQNCK4Ce6nPSunMJjOob1tFMqZxwaa9xuHBoDSMyEVR
         hSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YJ0dWA2LN7YqfF1ySTSNQvt81ovDnTZhfscP6j/isLs=;
        b=LdeNO4frtFhCOl/YzsWcw76Knd5WRS962SFw+iAbcoGSxLxzLcOouIZA4e4IDaiKOl
         t7q0Ro/ofgqu4l3hR5kEWKybqLbV75wH/feNQnvXKWc6TfSZGx9HO/8/+0RG9wb5JiHX
         tOX3/tMJVKd6/wOJpKihX1uZTD1cFzSDwuSyZsP+iJnd97gh1pKmVCCpDKE81LM2+q09
         MCo/bHfFcin2Fqg2DVu6APM6REq8RqJSJsH0WFJbLIAfWXVa/4KlxB2zMMnf04TQqFtY
         5azGjoU7UF3O4/7+6nWTSeNDRjDA3JWn9eUDgL3JzkvfqAWvAcESY8p5ts5I7YR4Sp9x
         KFxg==
X-Gm-Message-State: AOAM533s49gkbuj9a4mOpXJLUA8Wtr0iVepUzjP7zUzZ2hAxsnvBoCsz
        Y5ivwLX8BqXadImk9tLrAFO/P0gEswkJh3cCTIoW
X-Google-Smtp-Source: ABdhPJz7HIu5MQLRpH/FbPdTqRTue+3JMybVC+vY85i/I/de3bl/zvWYSVdjNKEUlXy6fDXCcVP8dUSaDhAFYIw47Ng=
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr1953908edb.195.1622091439123;
 Wed, 26 May 2021 21:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
In-Reply-To: <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 27 May 2021 12:57:08 +0800
Message-ID: <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
Subject: Re: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/17 =E4=B8=8B=E5=8D=885:55, Xie Yongji =E5=86=99=E9=81=93=
:
> > +
> > +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> > +                           struct vduse_dev_msg *msg)
> > +{
> > +     init_waitqueue_head(&msg->waitq);
> > +     spin_lock(&dev->msg_lock);
> > +     vduse_enqueue_msg(&dev->send_list, msg);
> > +     wake_up(&dev->waitq);
> > +     spin_unlock(&dev->msg_lock);
> > +     wait_event_killable(msg->waitq, msg->completed);
>
>
> What happens if the userspace(malicous) doesn't give a response forever?
>
> It looks like a DOS. If yes, we need to consider a way to fix that.
>

How about using wait_event_killable_timeout() instead?

Thanks,
Yongji
