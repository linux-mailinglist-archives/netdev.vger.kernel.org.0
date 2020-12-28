Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438882E3553
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgL1JNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 04:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgL1JNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 04:13:36 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5235AC061794
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 01:12:56 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d17so13344109ejy.9
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 01:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9lkawC7Fz3z0KmisaP79BxDG0EuYhifxKaeCSif+IJ8=;
        b=No5ZA7fdLz904gM1QjDqzfnM6H9sYP8u2SawxRpVGtan2jKKNJtXgRZsTlJKN/o0Ri
         6IWBtNp/3MawVTr4wCOIDEl5RG6G6qzSWrLfd4SsMwBd195EiXXX5YoIWjiU46CVt7lv
         PwPrpo2/uR1dKKWYHG5/USG4zU64YwxfnB4H6p+EdmcIH1N0uXblRhB6o1R9E/tfgtA4
         48ngDgyPYqw/ueOsoFH213WtJ9oJ6QKayfQZmHfkWlR7/dctxsc1vEUuPc+zKezqUXme
         C3NSsMVqZh/InqxzvmlyrOXOyu7/IKBDvtkj3KtFiMzOZqbH/ws5cedXoEZQjgcHSS1t
         zdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lkawC7Fz3z0KmisaP79BxDG0EuYhifxKaeCSif+IJ8=;
        b=rAmJcCOlkb2cl9sDcc6wuvwXiUXXO+u5y0+DBE73b3SVO8A6O42NrnmuejZV4E57N4
         fG/Qd0nSLUHrtafY7EpJyy88EEHBGYtyfcgPAdoneEWOipPZhI19yz7Hm1vp30FRM3Qk
         dILQc02M9WEZmRNB5HBjsDyT45N73ii7S5iVUxTL7ZXTY3vrdeSzk5hu6Q5XcNIrtVlj
         FBkKy8uN53eiSN/4pa1mMe40tXfXbZlXSJd8Aplpmoa7ZqkpGGqtwpBR2o1tklHW4ntv
         oH4TdAnS1GsUp9+HflLHU4ny+VnMd+qvlPsF49bWVgWc7DSCEcOjuvh8OikxTPHFsH7k
         HS/A==
X-Gm-Message-State: AOAM53223QK1qYNu4uMaN+Y81H4T5iK1AyPHfT7gSsfukXsAxef8odiq
        cAsJvQDQE6bEIb0oId0J6vPpacBjF2hickxXV8kQ
X-Google-Smtp-Source: ABdhPJwVbVkrlQalbTU6/h7VmiDK65ALhll1PK+HA8rICskwXreVpZDshXBbymnOf5bR1grgNYEKm9Zjmxa6xzgVyrk=
X-Received: by 2002:a17:906:878d:: with SMTP id za13mr40480318ejb.395.1609146774881;
 Mon, 28 Dec 2020 01:12:54 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com> <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com>
In-Reply-To: <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 28 Dec 2020 17:12:44 +0800
Message-ID: <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
Subject: Re: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb message
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> >> I see. So all the above two questions are because VHOST_IOTLB_INVALIDA=
TE
> >> is expected to be synchronous. This need to be solved by tweaking the
> >> current VDUSE API or we can re-visit to go with descriptors relaying f=
irst.
> >>
> > Actually all vdpa related operations are synchronous in current
> > implementation. The ops.set_map/dma_map/dma_unmap should not return
> > until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replied
> > by userspace. Could it solve this problem?
>
>
>   I was thinking whether or not we need to generate IOTLB_INVALIDATE
> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
>
> If we don't, we're probably fine.
>

It seems not feasible. This message will be also used in the
virtio-vdpa case to notify userspace to unmap some pages during
consistent dma unmapping. Maybe we can document it to make sure the
users can handle the message correctly.

Thanks,
Yongji
