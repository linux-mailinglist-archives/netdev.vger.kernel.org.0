Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7186A3B6D37
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhF2D7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhF2D7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:59:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A089BC061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:56:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id o11so20669838ejd.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D86WnvUg/Gf6HvI1cRKKP6mYttXzkG9si4A9EUDsAM8=;
        b=ktycy0u3fd2n2LkkSyJRlmSxqWEZlI+BMvbBCygDsyL4bIVPtYgv5F3+OlCovp8IE5
         YdPYVKSMPNv8K2fsE7c+BMChTcNAl5zpMojzsBvnVkL4PPrg7fnB0m/BFLGeBU0lzU1m
         MU7KsdUKUmnRFvYuD/eV+6Db6BPIOkjzmSt9osG/AWuczpiHFJ2Bu4tU+ciassk5Ffh/
         eGTomGEeKsvnc7O2JYvkMtm4pMXolMCXY87xsSrpS765Ssqow1gwNrBX4Dxq/qiRbqeG
         izQopD22vjrMYv+U6MDcAo2FarGQHBrWmq+Nm6+vmwbR1xRB/et+FjzeuFqj2ugygP0H
         WDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D86WnvUg/Gf6HvI1cRKKP6mYttXzkG9si4A9EUDsAM8=;
        b=XuGNlnAnWqmohzDMUtF0IiziLvHtX/DB84amC5uM3VfBpAOd5fe/2262m+5LA2OMNy
         fey9FS4AmheJTsa0yqsCbVMwD3gdAwmbRG2vAuOwNtdI+kRm8jVvlN02WBMYrEkek2hE
         1Xi9ZE0lUTdA21Og5b4zQPiI+zd0BsdMOl98JEa+yfvqL285iax+vqE0QLhQ4TBVS0vz
         hoe7BDGHZ+JOw2441p5wZsaFeUbAcJvEiNCcbGYiMTPxxAXYJQUA1jCJXowPYxm6llBL
         ybIkEfDnWIl2hnpqe3GAeaYCvDhMxyHA/Fcd1UtIZYUgkBNtNNOOcm5rfJ5jw8V+eSAm
         pIpg==
X-Gm-Message-State: AOAM533TjrhJRFS6prGYwttLZuQWjrfnZX4VgPWaT9ho7fbEQYk0se9s
        kbCNhdmZ3MzajWZUL2L3MCRPzCtDdXXRr4T5M9le
X-Google-Smtp-Source: ABdhPJwtp85h6QY/GJlNTdlYZ5BUszc1XLhwmkDVnzLYJaYJYGPEVbGPDY3rOdmLE4oNkfRjGeiuf2gOtKcicAsxgrk=
X-Received: by 2002:a17:906:7142:: with SMTP id z2mr27152930ejj.427.1624938998259;
 Mon, 28 Jun 2021 20:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com> <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com> <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com> <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
 <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com> <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
 <b10b3916-74d4-3171-db92-be0afb479a1c@redhat.com> <CACycT3vpMFbc9Fzuo9oksMaA-pVb1dEVTEgjNoft16voryPSWQ@mail.gmail.com>
 <d7e42109-0ba6-3e1a-c42a-898b6f33c089@redhat.com> <CACycT3u9-id2DxPpuVLtyg4tzrUF9xCAGr7nBm=21HfUJJasaQ@mail.gmail.com>
 <e82766ff-dc6b-2cbb-3504-0ef618d538e2@redhat.com>
In-Reply-To: <e82766ff-dc6b-2cbb-3504-0ef618d538e2@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 11:56:27 +0800
Message-ID: <CACycT3ucVz3D4Tcr1C6uzWyApZy7Xk4o17VH2gvLO3w1Ra+skg@mail.gmail.com>
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

On Tue, Jun 29, 2021 at 11:29 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/29 =E4=B8=8A=E5=8D=8810:26, Yongji Xie =E5=86=99=E9=81=
=93:
> > On Mon, Jun 28, 2021 at 12:40 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/6/25 =E4=B8=8B=E5=8D=8812:19, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>> 2b) for set_status(): simply relay the message to userspace, reply i=
s no
> >>>> needed. Userspace will use a command to update the status when the
> >>>> datapath is stop. The the status could be fetched via get_stats().
> >>>>
> >>>> 2b looks more spec complaint.
> >>>>
> >>> Looks good to me. And I think we can use the reply of the message to
> >>> update the status instead of introducing a new command.
> >>>
> >> Just notice this part in virtio_finalize_features():
> >>
> >>           virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> >>           status =3D dev->config->get_status(dev);
> >>           if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> >>
> >> So we no reply doesn't work for FEATURES_OK.
> >>
> >> So my understanding is:
> >>
> >> 1) We must not use noreply for set_status()
> >> 2) We can use noreply for get_status(), but it requires a new ioctl to
> >> update the status.
> >>
> >> So it looks to me we need synchronize for both get_status() and
> >> set_status().
> >>
> > We should not send messages to userspace in the FEATURES_OK case. So
> > the synchronization is not necessary.
>
>
> As discussed previously, there could be a device that mandates some
> features (VIRTIO_F_RING_PACKED). So it can choose to not accept
> FEATURES_OK is packed virtqueue is not negotiated.
>
> In this case we need to relay the message to userspace.
>

OK, I see. If so, I prefer to only use noreply for set_status(). We do
not set the status bit if the message is failed. In this way, we don't
need to change lots of virtio core codes to handle the failure of
set_status()/get_status().

Thanks,
Yongji
