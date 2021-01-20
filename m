Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1649D2FC804
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbhATCbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731389AbhATC0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:26:50 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE0C0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:26:09 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id rv9so12604324ejb.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBePnOAwZBQb0dFg0gQ+d7YGVLbKQhuKKUpxdihg8xw=;
        b=LB6kDMOtqkpE7gTzQl38DEPBvXbLSTBlsbJxXoOYf8YjfF5k3es63847L/iApG8tyu
         GU79SOybW0byS1xGi1kEI42XZfpf5a4JhXNwXYGsmvehOvqkt2M9KFWzQm/uSqrVJhAj
         CaHl8G12wqKvSw5Ox8KrDo5kFWFoFzZ6TYbSCth/TKonjHa0KVF6wdLBdwnINl87uExX
         d6VMJOWD1vrRgAkrABgI/Oatatd6mW+xjawoN0FSYtgjVllaRBZCRApdd0CN+A8rqUaZ
         a2F50mlbMVLmPyeG7goZTEvELwU9kDZOzBR9f9D3VFpRZuBktM+Cm4UDvgUEU8CFnmH6
         BGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBePnOAwZBQb0dFg0gQ+d7YGVLbKQhuKKUpxdihg8xw=;
        b=fs5B8k4C+Pm1FUTRQjPXvGmrsjkhFLJ8X6d5u3yfCVJiESwdv+wLszNeIfTZ9sTJSu
         k/uKfHk7NBKE9kU2iWRjzNAEH/5HDnkjvJTXpdXHj8ZxP5es3guZXX6J11Yvu06+eqOE
         RlogBNW5q63MwXCIrOBdx8Ft/7zJavjC383i+KY3TFRATa7U5Nu/VZuE4zlexQv5uUFB
         Q3Id4O0KpX1Z8A8q1V44rPN6/9x2kvaNA//U4snDjBuZmMuWQdT2tU6PAUoUuJ0xWIJN
         PbNnvspcZgVrCfIPp9gk/ShkvFe2/PmuBhppVT4EZF2InGrZNltlwqtPthosVLOAJRx7
         X1xw==
X-Gm-Message-State: AOAM531Mqv4+mohCBqqGNmpke06BigFH5zX/AtkVQIqwdQvt2esQhthi
        ettDE6ATduGCJ2K+0j2xnW5S9TNxW6RXagxULRe9
X-Google-Smtp-Source: ABdhPJzbiYr+nq4JjIVaAfFEWXYt26uUaLS8YnaaZ4H3bL6ASL47qMuMWg0GdgC4s7ZNiHZxzUxSwnHbPEPhV9hKXNw=
X-Received: by 2002:a17:906:5254:: with SMTP id y20mr4656020ejm.174.1611109567772;
 Tue, 19 Jan 2021 18:26:07 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com> <20210119075359.00204ca6@lwn.net>
In-Reply-To: <20210119075359.00204ca6@lwn.net>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 10:25:57 +0800
Message-ID: <CACycT3uN+CJ8x_9mqA9oNzXBB+XojkMVibk_sP-ug3QGJP7yUw@mail.gmail.com>
Subject: Re: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 10:54 PM Jonathan Corbet <corbet@lwn.net> wrote:
>
> X-Gm-Spam: 0
> X-Gm-Phishy: 0
>
> On Tue, 19 Jan 2021 13:07:53 +0800
> Xie Yongji <xieyongji@bytedance.com> wrote:
>
> > diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> > new file mode 100644
> > index 000000000000..9418a7f6646b
> > --- /dev/null
> > +++ b/Documentation/driver-api/vduse.rst
> > @@ -0,0 +1,85 @@
> > +==================================
> > +VDUSE - "vDPA Device in Userspace"
> > +==================================
>
> Thanks for documenting this feature!  You will, though, need to add this
> new document to Documentation/driver-api/index.rst for it to be included
> in the docs build.
>
> That said, this would appear to be documentation for user space, right?
> So the userspace-api manual is probably a more appropriate place for it.
>

Will do it. Thanks for the reminder!

Thanks,
Yongji
