Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E473DE925
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhHCJCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbhHCJCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:02:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1AAC0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:02:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p21so28063408edi.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3wZFhZTC8zZY+D9UvhMcL30+qrKHqoBqQtpm1vOADzM=;
        b=JKe8MBo/Q/9jJiWfNFv7/6FozVELAtit9lfH9d5TxXXMYzq/K+Pmkq5MZfy0MK2cFu
         cx6FhhWxNDc+0E1xzGVvot63Tu4Ur8FkAtBApXV5HGWA7B6YAue4z52aDqp2cPeuObcM
         NbvLlt0iETqmIH/loBFX6RmK5lnhTeVCMIO5KKZH9Z5CWgGXEldHbQTMQQrf9uJEnfFB
         86l/PEM0xk2vAai/1RJXq5azCxa1fJfFP2bTdkelMNkruzkW1VP4XZZrR/YihWu8I9cm
         wPq3kJhM7XQVmw7qPL2HCPQ0a2PjgZxJc4l7AroO/DlUf8xZiD0v/CMDlg12kwVoA4f6
         XDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3wZFhZTC8zZY+D9UvhMcL30+qrKHqoBqQtpm1vOADzM=;
        b=Rt0ABDrjzCumNalEis2mgSatF77jDnegPX3MlCyDFdpH5+5uj/nYVVTRGqc+n6Ao/q
         ib7gRTppH5HJITO1MvNAEgPmpycIyD3YFWdW1q2uLF9Z6a8av0JARzsPKLOSCl5m+qiO
         vL77nxgwHX3jl3FBl2KH3Sxz2hMiz3dqHXYS3u6XBB/GU7kMkMwMlRuV+YffEB/HTZIQ
         dqQpHJweDQmkKHH8VwuMUgrLNi/Ak+wHhCiJhrRXHpD6BLKAyMf4HR0VAqn1wbPjcBTD
         PNV1NY45upRpiG5esw7dEJSXReMiMGWoTr+wNIPR1sPFWq1zMtNXUgNVVvhR9bp3NNtX
         Q41g==
X-Gm-Message-State: AOAM533hJs08kycwj0mDlgPWXk2zVsCwCcG6BLR5DMVj+zXXpFSGXBJQ
        P4tz6JjsSgB3aKHV6AFeYR0F43NVGuo48huv+pMc
X-Google-Smtp-Source: ABdhPJyS6bOrWfuvjmdwVRGONpMTv6Y0zVE0kh7I9sjtSTBg5XbDmv85P6yS8Pkoi3kNsB54rx4AF9ZFKn4Qu8vMSM8=
X-Received: by 2002:aa7:c50a:: with SMTP id o10mr23739559edq.118.1627981328237;
 Tue, 03 Aug 2021 02:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-3-xieyongji@bytedance.com>
 <a0ab081a-db06-6b7a-b22e-4ace96a5c7db@redhat.com>
In-Reply-To: <a0ab081a-db06-6b7a-b22e-4ace96a5c7db@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 17:01:57 +0800
Message-ID: <CACycT3sdx8nA8fh3pjO_=pbiM+Bs5y+h4fuGkFQEsRSaBnph7Q@mail.gmail.com>
Subject: Re: [PATCH v10 02/17] file: Export receive_fd() to modules
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
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:46 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=93=
:
> > Export receive_fd() so that some modules can use
> > it to pass file descriptor between processes without
> > missing any security stuffs.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   fs/file.c            | 6 ++++++
> >   include/linux/file.h | 7 +++----
> >   2 files changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/file.c b/fs/file.c
> > index 86dc9956af32..210e540672aa 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *=
file, unsigned int o_flags)
> >       return new_fd;
> >   }
> >
> > +int receive_fd(struct file *file, unsigned int o_flags)
> > +{
> > +     return __receive_fd(file, NULL, o_flags);
>
>
> Any reason that receive_fd_user() can live in the file.h?
>

Since no modules use it.

Thanks,
Yongji
