Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72633B6C79
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 04:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2C3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 22:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhF2C3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 22:29:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AC4C061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 19:26:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id v20so14950536eji.10
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 19:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=436iowW5G+3AhfaQeY6hf4XjL/XjrpmKBydXgJfyA5c=;
        b=ZgaNzCWSgvDCp3W0+7M7fWukxNa4zA3fTXV1kaarlE9zTzD1fKf8iVqwLsF89vugIC
         9dcjxKh/qW9PROxd2BblzqndRgBWoyP5PWT7Ca0ICMXU2kOiD9nPC5NZCH7Nma3nK2os
         2K/GV+jZyxe0vUCCbu/qFMoo7E6Bazc+6seVNiXIzEemn9BPky8X1/7asxp/mTgIzD1W
         CT63JHVJQej9lyEXcyVFIWegTp3xYHaOiWsZmD4lzu37ZCa2EQox0aV1EIgVm7S2D+fg
         fPQiuXCDISqeRNxnowY3Ocd+N0XVi3/L5afCqOsq3fxqaVRCugUmPevg2EzrnSIm+lMT
         GKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=436iowW5G+3AhfaQeY6hf4XjL/XjrpmKBydXgJfyA5c=;
        b=IfZqrVqjYkj5EeHxifivaHIPf+YigblFZdq4StfqliAHi+GBY24oRWy6zYXQNA56so
         ROBC8yXp+WZIlxq1WMJnlrcalSZcHRx7H2HvuXe/Vw2YJ4xisdEimIaC4nUt+LOgLQrc
         vDXsEIUiGRKd3dCJItYCP/apLoCPcXtwsowexJucC9UcfVjYopp5huhjq90TqMUbfO2k
         WqbReami7S/ldwzIYCKEHWP/k+A68t2ym2DT5LOso9gWD0k6HANXnFH1yEV2/Wp88W+U
         xRoAkynxEYiaaqsSUzLv8SGYft/dheUgYkzd4r53AUvJqoC+FVJxtNLXu3MV5sqnsp6g
         ZCBg==
X-Gm-Message-State: AOAM532okhsc9AAcR5qoyGGeB+6kFEsGatpki7SoYdo8B1ynWBopnltI
        KONfgW71R8v8hWGVbNQjGpfty2REo7cbmjNRlC7m
X-Google-Smtp-Source: ABdhPJxZ3odiQnt9cl8KrT87lSdpmglQti+N9ZByUxEwzMT+zjXAVbmRXZy8vuZGeYWwod7YWLY2hOoSJaOTu2UwbQo=
X-Received: by 2002:a17:906:a28e:: with SMTP id i14mr26931454ejz.395.1624933611032;
 Mon, 28 Jun 2021 19:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com> <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com> <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com> <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
 <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com> <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
 <b10b3916-74d4-3171-db92-be0afb479a1c@redhat.com> <CACycT3vpMFbc9Fzuo9oksMaA-pVb1dEVTEgjNoft16voryPSWQ@mail.gmail.com>
 <d7e42109-0ba6-3e1a-c42a-898b6f33c089@redhat.com>
In-Reply-To: <d7e42109-0ba6-3e1a-c42a-898b6f33c089@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 10:26:40 +0800
Message-ID: <CACycT3u9-id2DxPpuVLtyg4tzrUF9xCAGr7nBm=21HfUJJasaQ@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 12:40 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/25 =E4=B8=8B=E5=8D=8812:19, Yongji Xie =E5=86=99=E9=81=
=93:
> >> 2b) for set_status(): simply relay the message to userspace, reply is =
no
> >> needed. Userspace will use a command to update the status when the
> >> datapath is stop. The the status could be fetched via get_stats().
> >>
> >> 2b looks more spec complaint.
> >>
> > Looks good to me. And I think we can use the reply of the message to
> > update the status instead of introducing a new command.
> >
>
> Just notice this part in virtio_finalize_features():
>
>          virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>          status =3D dev->config->get_status(dev);
>          if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>
> So we no reply doesn't work for FEATURES_OK.
>
> So my understanding is:
>
> 1) We must not use noreply for set_status()
> 2) We can use noreply for get_status(), but it requires a new ioctl to
> update the status.
>
> So it looks to me we need synchronize for both get_status() and
> set_status().
>

We should not send messages to userspace in the FEATURES_OK case. So
the synchronization is not necessary.

Thanks,
Yongji
