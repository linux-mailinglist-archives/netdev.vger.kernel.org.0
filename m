Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3235D677
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhDME2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 00:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhDME2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 00:28:54 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A26AC06175F
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 21:28:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g17so17001610edm.6
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 21:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KgX9vitQLsw/fJL+KP8I/opZHLQIHCxWsZWMUb2jijc=;
        b=eFRlFPRnxba6eXyWbDP4eUAP/8qETyj5QilhvrMDxqow9MKkPtjWWn5nKiuVjqrpkv
         BoNi0dhY+1eyDZLRsWmnQz7FsRI0GLPTaSvD5S6Nalm0QjKZ8LzS3XB1m/pI8zmgJ1Pz
         I2YA00fULsrV5BC6TbbvXbwwvZAcZ2gR+WuRjl4tJKWFuzSK2mUlQZBiqTi6CEbOIkFO
         sLOJkUheEo2WXa/FBLisAtNwE6JGx44fFsT4NAQRGb0u9MSeVR59huKxKvvrLZ6XhkWl
         32bc/LrM4GhJ56+2MsnmB1/WkQCVsGpNBxuH6ZFSqodIMwLj28XAKOOyka489ZugEhXC
         9hng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KgX9vitQLsw/fJL+KP8I/opZHLQIHCxWsZWMUb2jijc=;
        b=RlfvmIjWYY253K+nN+kOkKfBxH6ryObUS/Og4gRwg9LH6DGntrDJ+TDeBgE1jh54Dj
         XRwzVedpDabr7/W1XDrS7RV9xhp7d4of9h4R2AejnvY0F9pwdtLDNMPvPuvwk5AjTuP3
         Bnwh08lZUO92U7QHFESFh6jHiBx8cvVAGgKWfZyf3wtQm3fF4xkkaOiHlLPRwJ7vDh3T
         X0NBPb1A8YhKr6GoTP/FnlyWiHdvleo4cEOFV48dIVzNMcGnAdym5krVZVtzjAFsf5TN
         LNkhuvZaWxDwMlhJpxVmAA477S2XQL6qHdS0r5FXTSLddFpcPyhAXARdNzEPZBNK0mPb
         7lfQ==
X-Gm-Message-State: AOAM530Xfd40b0ZStSWvBHHHzUQPPzQpBgOQwRcf9ps5psAifs25RJr9
        Y5qee0U1cmH9L55YWGoJBoZcvOIbSD+MKQybobJA
X-Google-Smtp-Source: ABdhPJxFsbFTwB0q0pNAp17qZJqIqm6vYW6whW2nB86LPbKviA3Z1PMbmmSz/1gnXoDoaJMm9C847RmTUrmsQNZTmWo=
X-Received: by 2002:a05:6402:6ca:: with SMTP id n10mr32891030edy.312.1618288112971;
 Mon, 12 Apr 2021 21:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-10-xieyongji@bytedance.com>
 <c817178a-2ac8-bf93-1ed3-528579c657a3@redhat.com> <CACycT3v_KFQXoxRbEj8c0Ve6iKn9RbibtBDgBFs=rf0ZOmTBBQ@mail.gmail.com>
 <091dde74-449b-385c-0ec9-11e4847c6c4c@redhat.com> <CACycT3vwATp4+Ao0fjuyeeLQN+xHH=dXF+JUyuitkn4k8hELnA@mail.gmail.com>
 <dc9a90dd-4f86-988c-c1b5-ac606ce5e14b@redhat.com> <CACycT3vxO21Yt6+px2c2Q8DONNUNehdo2Vez_RKQCKe76CM2TA@mail.gmail.com>
 <0f386dfe-45c9-5609-55f7-b8ab2a4abf5e@redhat.com> <CACycT3vbDhUKM0OX-zo02go09gh2+EEdyZ_YQuz8PXzo3EngXw@mail.gmail.com>
 <a85c0a66-ad7f-a344-f8ed-363355f5e283@redhat.com>
In-Reply-To: <a85c0a66-ad7f-a344-f8ed-363355f5e283@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 13 Apr 2021 12:28:21 +0800
Message-ID: <CACycT3tHxtfgQhQgv0VyF_U523qASEv1Ydc4XuX43MFRzGVbfw@mail.gmail.com>
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

On Tue, Apr 13, 2021 at 11:35 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/12 =E4=B8=8B=E5=8D=885:59, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Mon, Apr 12, 2021 at 5:37 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/4/12 =E4=B8=8B=E5=8D=884:02, Yongji Xie =E5=86=99=E9=81=
=93:
> >>> On Mon, Apr 12, 2021 at 3:16 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> =E5=9C=A8 2021/4/9 =E4=B8=8B=E5=8D=884:02, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>>>>>>> +};
> >>>>>>>>> +
> >>>>>>>>> +struct vduse_dev_config_data {
> >>>>>>>>> +     __u32 offset; /* offset from the beginning of config spac=
e */
> >>>>>>>>> +     __u32 len; /* the length to read/write */
> >>>>>>>>> +     __u8 data[VDUSE_CONFIG_DATA_LEN]; /* data buffer used to =
read/write */
> >>>>>>>> Note that since VDUSE_CONFIG_DATA_LEN is part of uAPI it means w=
e can
> >>>>>>>> not change it in the future.
> >>>>>>>>
> >>>>>>>> So this might suffcient for future features or all type of virti=
o devices.
> >>>>>>>>
> >>>>>>> Do you mean 256 is no enough here=EF=BC=9F
> >>>>>> Yes.
> >>>>>>
> >>>>> But this request will be submitted multiple times if config lengh i=
s
> >>>>> larger than 256. So do you think whether we need to extent the size=
 to
> >>>>> 512 or larger?
> >>>> So I think you'd better either:
> >>>>
> >>>> 1) document the limitation (256) in somewhere, (better both uapi and=
 doc)
> >>>>
> >>> But the VDUSE_CONFIG_DATA_LEN doesn't mean the limitation of
> >>> configuration space. It only means the maximum size of one data
> >>> transfer for configuration space. Do you mean document this?
> >>
> >> Yes, and another thing is that since you're using
> >> data[VDUSE_CONFIG_DATA_LEN] in the uapi, it implies the length is alwa=
ys
> >> 256 which seems not good and not what the code is wrote.
> >>
> > How about renaming VDUSE_CONFIG_DATA_LEN to VDUSE_MAX_TRANSFER_LEN?
> >
> > Thanks,
> > Yongji
>
>
> So a question is the reason to have a limitation of this in the uAPI?
> Note that in vhost-vdpa we don't have such:
>
> struct vhost_vdpa_config {
>          __u32 off;
>          __u32 len;
>          __u8 buf[0];
> };
>

If so, we need to call read()/write() multiple times each time
receiving/sending one request or response in userspace and kernel. For
example,

1. read and check request/response type
2. read and check config length if type is VDUSE_SET_CONFIG or VDUSE_GET_CO=
NFIG
3. read the payload

Not sure if it's worth it.

Thanks,
Yongji
