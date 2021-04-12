Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E500835BB98
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbhDLIDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhDLIDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:03:13 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11509C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:02:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g17so15961620ejp.8
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p6jHxvinR4oy1/faml5c1RePikeItP2Kvd2rZJWrTiQ=;
        b=lBqfXWeW37pd7NVUT+Uk9TzwfyGZg7ekKVZcL+rLzd38GksZBKR7JgS6SVbsrGW39X
         6ZQm8GNiZW6mio9p5jZdsLmscZVYaQofpMHy25hgF5Fb/qN9hrLt4VCW+2+Uo21CZy+8
         g3M3iRgDWKppnOeVow7mBfNQjxGDyDBNVRnuZFyDbRSLT5wqkwDbmN+y540tFVwD9SQ5
         hF8wbyI2J28YY73Rx3X4feBz2fKnwz5xghVxWzDMDLzbiyG2SK+nlXToWtL0Pd4QksMZ
         mVm/zIkwrIYMFJh8mZhUSIbnUq+vU+5wfLBADVijL1Z0Q4jHChPqjIGIK7Ro2tgQP9gs
         K8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p6jHxvinR4oy1/faml5c1RePikeItP2Kvd2rZJWrTiQ=;
        b=Cx57oe9K7ucL9lQHWRpNcXQyu1ERe1djsxukaYSGxV8foQAunGt+fpSzkU7hXmQQVs
         K8cuN3eWINnwKvWIMSOASl8xU5DOcSf/BWfCx2RihffWCNDohrKuT2Pk438F863Ag61O
         ACIJK8os0d+DJ0nEYiOQW4SQASC159l8ADAv/R0lA0j947zk7nLL6FUa0bEXwxmurfI6
         j2gIGkthoi2cUmmLReMwVihIWAcOu33JzE/p7L4L58803qTve6GzOgbo2cVfVVwql/BX
         PQ3gpQAsv4dTpD7grUJQX51kfBEFyFwEUFAAbi9on8V1Tqz+JAFQa2IoubIbjdYCMnCa
         za9A==
X-Gm-Message-State: AOAM532Q9v2AqqjqkjEW3MDzacj6bpHCbuASlN6JidOP2Wn2s6BAYA0m
        LdC7ZQWUMUY0GKlBJ6/K79Fhqj4xdGWzxP2clwWH
X-Google-Smtp-Source: ABdhPJzxBC6arRGRGNDZDQU74O/wINTe0uOldAk5rkZ3ldemXaFDnYdXEXoqOxA7hneHBKXEwp5mvfq2QIMmiuXk118=
X-Received: by 2002:a17:906:36ce:: with SMTP id b14mr22328852ejc.395.1618214574855;
 Mon, 12 Apr 2021 01:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-10-xieyongji@bytedance.com>
 <c817178a-2ac8-bf93-1ed3-528579c657a3@redhat.com> <CACycT3v_KFQXoxRbEj8c0Ve6iKn9RbibtBDgBFs=rf0ZOmTBBQ@mail.gmail.com>
 <091dde74-449b-385c-0ec9-11e4847c6c4c@redhat.com> <CACycT3vwATp4+Ao0fjuyeeLQN+xHH=dXF+JUyuitkn4k8hELnA@mail.gmail.com>
 <dc9a90dd-4f86-988c-c1b5-ac606ce5e14b@redhat.com>
In-Reply-To: <dc9a90dd-4f86-988c-c1b5-ac606ce5e14b@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 12 Apr 2021 16:02:44 +0800
Message-ID: <CACycT3vxO21Yt6+px2c2Q8DONNUNehdo2Vez_RKQCKe76CM2TA@mail.gmail.com>
Subject: Re: Re: [PATCH v6 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 3:16 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/9 =E4=B8=8B=E5=8D=884:02, Yongji Xie =E5=86=99=E9=81=93:
> >>>>> +};
> >>>>> +
> >>>>> +struct vduse_dev_config_data {
> >>>>> +     __u32 offset; /* offset from the beginning of config space */
> >>>>> +     __u32 len; /* the length to read/write */
> >>>>> +     __u8 data[VDUSE_CONFIG_DATA_LEN]; /* data buffer used to read=
/write */
> >>>> Note that since VDUSE_CONFIG_DATA_LEN is part of uAPI it means we ca=
n
> >>>> not change it in the future.
> >>>>
> >>>> So this might suffcient for future features or all type of virtio de=
vices.
> >>>>
> >>> Do you mean 256 is no enough here=EF=BC=9F
> >> Yes.
> >>
> > But this request will be submitted multiple times if config lengh is
> > larger than 256. So do you think whether we need to extent the size to
> > 512 or larger?
>
>
> So I think you'd better either:
>
> 1) document the limitation (256) in somewhere, (better both uapi and doc)
>

But the VDUSE_CONFIG_DATA_LEN doesn't mean the limitation of
configuration space. It only means the maximum size of one data
transfer for configuration space. Do you mean document this?

Thanks,
Yongji
