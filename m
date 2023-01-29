Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24D067FCF9
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 06:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjA2Fvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 00:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjA2Fva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 00:51:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA0F21A07
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674971443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ESfJeO4v/Sc9kZuGNKusexDTFykbAPKz0X+uhnEfDU=;
        b=MLV/P/Rdubq5VcL7aPcEpSPNS8/P6co70ymJohI84/ffAPeYeKeI+9TvQ+faXRDdtoW8Le
        OlV4y0hJC0PqYecotHk+uRu3b3vxP5pqsX8XsAV5Mr+a7k2RRupJ1Ijfn03khcJEZTxtKr
        uAOMlzf6WN4AraIQeg4sRxoYxJUYYeI=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-336-aTmVsnIqOfOuCUxvs61OIA-1; Sun, 29 Jan 2023 00:50:41 -0500
X-MC-Unique: aTmVsnIqOfOuCUxvs61OIA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-15fd6d7a8d7so3069195fac.16
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ESfJeO4v/Sc9kZuGNKusexDTFykbAPKz0X+uhnEfDU=;
        b=zhwPeDvoFW32peiVsquWIyunszlV21ZFm4GEMA6TGuun+MiXpiddEz9OMy4HPMkL9S
         XXW8k9aYkpHix1ctST88jLRi1TY5CRfnW7qZNo8ERtg81+p1g3FI9rBASBUGvZ7eE9fp
         ATlIAwoj1VV3l5MAiEgnMpFhBgiwtTgEkEHsvIotYZJzH4YAP4AAhDZtWIt/RrrUpy40
         9WnYH+JJ0tDbIrZ9DT7catxJl4TlyM5h+LO3mFWIv+aXB61lI9WdIwLKUjyORorn3KZe
         oEmNIEo60zgcXPLxONQZXO3dbXECn+53G5nFu4oBWJYiCVGPt172Oskrem6amME7g25q
         nMUg==
X-Gm-Message-State: AO0yUKVRSJmqVrPkD8BJBT1oeYBjXQdRNIHlip8DFUuUedZgWAnL1T6h
        ISBnJz3ulhpbHSI3fUWg920ewrdcB0Slczcnoi+qMnl4Nf5M0C9ZEDy8GNeMsSN2/cq7YD6ald8
        dEBcmBJfic9uGZHyat5dBejo9/uTwMe71
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id k30-20020a056870959e00b001639ceaeea7mr115409oao.35.1674971440500;
        Sat, 28 Jan 2023 21:50:40 -0800 (PST)
X-Google-Smtp-Source: AK7set+UoO/1kphXCPY28/DKX9hwQUG6JjAGE74TUF7dLTKDNr1tk08D4Bhi3bKgLWdo5+0Rqlh3eus5Dyvey48IMPg=
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id
 k30-20020a056870959e00b001639ceaeea7mr115403oao.35.1674971440262; Sat, 28 Jan
 2023 21:50:40 -0800 (PST)
MIME-Version: 1.0
References: <20221128021005.232105-1-lizetao1@huawei.com> <20221128042945-mutt-send-email-mst@kernel.org>
 <20230127061055-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230127061055-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 29 Jan 2023 13:50:29 +0800
Message-ID: <CACGkMEszd0O-juD93nMQEmOA0w+rq_pE-je5xj+XkMc7nwUR4w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Fix probe failed when modprobe modules
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Li Zetao <lizetao1@huawei.com>, pbonzini@redhat.com,
        stefanha@redhat.com, axboe@kernel.dk, kraxel@redhat.com,
        david@redhat.com, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 7:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Nov 28, 2022 at 05:14:44AM -0500, Michael S. Tsirkin wrote:
> > On Mon, Nov 28, 2022 at 10:10:01AM +0800, Li Zetao wrote:
> > > This patchset fixes similar issue, the root cause of the
> > > problem is that the virtqueues are not stopped on error
> > > handling path.
> >
> > I've been thinking about this.
> > Almost all drivers are affected.
> >
> > The reason really is that it used to be the right thing to do:
> > On legacy pci del_vqs writes 0
> > into vq index and this resets the device as a side effect
> > (we actually do this multiple times, what e.g. writes of MSI vector
> >  after the 1st reset do I have no idea).
> >
> > mmio ccw and modern pci don't.
> >
> > Given this has been with us for a while I am inlined to look for
> > a global solution rather than tweaking each driver.
> >
> > Given many drivers are supposed to work on legacy too, we know del_vqs
> > includes a reset for many of them. So I think I see a better way to do
> > this:
> >
> > Add virtio_reset_device_and_del_vqs()
> >
> > and convert all drivers to that.
> >
> > When doing this, we also need to/can fix a related problem (and related
> > to the hardening that Jason Wang was looking into):
> > virtio_reset_device is inherently racy: vq interrupts could
> > be in flight when we do reset. We need to prevent handlers from firing in
> > the window between reset and freeing the irq, so we should first
> > free irqs and only then start changing the state by e.g.
> > device reset.
> >
> >
> > Quite a lot of core work here. Jason are you still looking into
> > hardening?
> >
>
> Li Zetao, Jason, any updates. You guys looking into this?

At least I will continue the work of IRQ hardening. And this work
could be done on top.

Thanks

>
>
> >
> > > Li Zetao (4):
> > >   9p: Fix probe failed when modprobe 9pnet_virtio
> > >   virtio-mem: Fix probe failed when modprobe virtio_mem
> > >   virtio-input: Fix probe failed when modprobe virtio_input
> > >   virtio-blk: Fix probe failed when modprobe virtio_blk
> > >
> > >  drivers/block/virtio_blk.c    | 1 +
> > >  drivers/virtio/virtio_input.c | 1 +
> > >  drivers/virtio/virtio_mem.c   | 1 +
> > >  net/9p/trans_virtio.c         | 1 +
> > >  4 files changed, 4 insertions(+)
> > >
> > > --
> > > 2.25.1
>

