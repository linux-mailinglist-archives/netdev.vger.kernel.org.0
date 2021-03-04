Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEBD32CF1E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbhCDI7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbhCDI6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:58:54 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86923C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 00:58:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d13so28699122edp.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 00:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WcsXXXbrDSVn9JnL1kI4tSiyWOxm9D+WqcuRuZ8ZPPY=;
        b=SgIJQX+v/dAp6zKtCoUdKvxd747j/oIsOOlWt3BXoINpvb8gM2GUvlCR5DCRqwiLzx
         qanElF3lR5Fr1/bcxvlAMjAdzVuPop19Ck5lylT/XrIhZ3r2rle5OmJX8PxYEU9XKxuu
         Iw6L1WE502mtn0lYP9httAirkVvwVutnvdqLR0+0sBBVZsjZd2vA/zVcYpTZI5p/MXAR
         +tsVCNpQxU53RtJ4KyP79ztx2eVInM9T5VemFzBVpaRDtn5ogkX3Y6iMsEL6on25AwGM
         QzTayVrZ5DCL6nhyaK0As2yq9bQ2XY7aGG4uM3iZbe2E67jW4p4yj4D7UlTLfDhQXcNl
         Au8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WcsXXXbrDSVn9JnL1kI4tSiyWOxm9D+WqcuRuZ8ZPPY=;
        b=M1opbV6zMPK2NSU79m1SNY3BzpD7Qb6L5PSDQixxkVE4MLZgrD9qtLeRPbYlX4V4x4
         sZBvIzDTWJbAsoSbwQKnMahKdhtvJMjz5O3f3FpugLLw3ebtKnEmtXd75yv5glzzG3wN
         x3yZES4ofx8YJJf2jxoYDJ1vXUS2aKJDnyhahUEhpEe2eq6KC2wgtN2I089Wt5u9bF15
         I+8iduiWMnXyKUB8n8IOHsV2yqDnroEHiSg9Ksgh9fpEVLDF/87uDZiYdDfZOO2j47Bx
         KOEHPWpxPknVOfeNVvtB+c5DF5wM0XSMYVrxpHhjGSM1bB2f04iUrOZUYbh+VqU2hN3Y
         /Gzw==
X-Gm-Message-State: AOAM531Y37BZV/1SdDE5gwOaC7j2WBym8jN4o0egYohOVlxRNF2QzcPH
        M5odV+WoIA6dyasfGsFMUH55H1MxPDByGTQZS7n8
X-Google-Smtp-Source: ABdhPJz1yhS4bpogbrj7802vVThEsweuzWygoO16SS4Sm5PZ+sHcuk5hH2T4ZXUpPr/tI/5DOjViugXNCjqXBngk2S0=
X-Received: by 2002:a05:6402:6ca:: with SMTP id n10mr3201074edy.312.1614848318350;
 Thu, 04 Mar 2021 00:58:38 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com>
In-Reply-To: <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 4 Mar 2021 16:58:27 +0800
Message-ID: <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
Subject: Re: Re: [RFC v4 10/11] vduse: Introduce a workqueue for irq injection
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

On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > This patch introduces a workqueue to support injecting
> > virtqueue's interrupt asynchronously. This is mainly
> > for performance considerations which makes sure the push()
> > and pop() for used vring can be asynchronous.
>
>
> Do you have pref numbers for this patch?
>

No, I can do some tests for it if needed.

Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useless
if we call irq callback in ioctl context. Something like:

virtqueue_push();
virtio_notify();
    ioctl()
-------------------------------------------------
        irq_cb()
            virtqueue_get_buf()

The used vring is always empty each time we call virtqueue_push() in
userspace. Not sure if it is what we expected.

Thanks,
Yongji
