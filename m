Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3220134FF82
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhCaLeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbhCaLdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 07:33:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CF8C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 04:32:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id o19so21903779edc.3
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 04:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vxe8If4sGcTh7st87cORvKEVNDfeE1HEe+kOjtBbATc=;
        b=BAwFJ9i/CFBCcQt1JegQRLLobf4cMOdcoFb7H1Rq0FT8zQtZt+Z9CWljFoHzizfC0K
         sslGnNwFdGN2KdwzLo7LNUs8rOYTOxevKW8u59owM3zyadRBfxnLOo1nCrya5UUTVOb+
         07ITCbMKQEwN4GDKRnrDUb/VsEu0rxCLFrrp1CvaaGnGb+ILbRtWktqd1deNW1id40cH
         /IGtO66Tah0CQfPyCjmwX18cU7Ldwwj4htsSY7tBnU8Xh4QIYrKaGjO4XS9mmd31YHEu
         /gqfNG98EncWOxpHlzi9o8k3wpLB4YELbXz9k+0MMUb/Uwn3I/KP1796ZkqZIECb66RH
         taBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vxe8If4sGcTh7st87cORvKEVNDfeE1HEe+kOjtBbATc=;
        b=MNWKompbs4fMxEhaEM5XyE34drA2g4ZdkBoTUy4qFPRKNzHahmojiKjde5gC8O/hra
         mkyb7Lat0NCmyeRQ+3tjFKw2C1MGnJ36VFSODqClZ3AWMEVN2K2n2hGL8u+70honB4BB
         7nhTQGtUlfHSPvrh2k9JkF5/Hgc3PN0gmhXgNVWiXtY+r4YGbWafkPdiH5sjRFzeKTIr
         YQYB294RiT0rSbZWyKuUIlmAPDXHhXsKyipnjDXgunw1UwGGToGJf6C99dwDbx2xYwWh
         vavWpEZ12oWoahTSl0I97/I+91lDRIYpCDF5+xClMY3+LVs9WBfdgZyrlrN6J1iF3LOh
         8RRA==
X-Gm-Message-State: AOAM531NR4bbc1HEbAW5bNjYonYS+0acCUv0FydGZ6zAnmviQ9Xsf6aO
        Ew2oomokMD0DlarEmSREUHvbXug4Hg8Um9+m6fHk
X-Google-Smtp-Source: ABdhPJxC7kwFkmRKMh9WIB1cQgo/XuAZfvdNlUh1PDULIpQBpK44t3cb1MsDQco8TwK3uStI3oHf3XwUq9RKlKShPtI=
X-Received: by 2002:a05:6402:168c:: with SMTP id a12mr3147052edv.344.1617190364701;
 Wed, 31 Mar 2021 04:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-2-xieyongji@bytedance.com>
 <20210331091545.lr572rwpyvrnji3w@wittgenstein>
In-Reply-To: <20210331091545.lr572rwpyvrnji3w@wittgenstein>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 31 Mar 2021 19:32:33 +0800
Message-ID: <CACycT3vRhurgcuNvEW7JKuhCQdy__5ZX=5m1AFnVKDk8UwUa7A@mail.gmail.com>
Subject: Re: Re: [PATCH v6 01/10] file: Export receive_fd() to modules
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 5:15 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> > Export receive_fd() so that some modules can use
> > it to pass file descriptor between processes without
> > missing any security stuffs.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
>
> Yeah, as I said in the other mail I'd be comfortable with exposing just
> this variant of the helper.

Thanks, I got it now.

> Maybe this should be a separate patch bundled together with Christoph's
> patch to split parts of receive_fd() into a separate helper.

Do we need to add the seccomp notifier into the separate helper? In
our case, the file passed to the separate helper is from another
process.

Thanks,
Yongji
