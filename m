Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74ED651ADF
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLTGpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiLTGpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:45:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73757638B
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671518671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwzbCVxJgzqh/hZntLgZPVw/8F+zWvpGjiJvEA/MIXQ=;
        b=g7f9dw17uiMoSzCQBgBXmrtkfvyZRV+QT7AZ0Sf06rnrJElvibaQiAIqUpZLBVVR2q3F0m
        hZARrdU6TF1kjog6kByW6/useRKLkVKBx1tCA8998MnO+ss5Uk5+GzApxAZdzbO2r2k8Eg
        AMP2txTGTlwdV9BI67a+Ro/F3gXaFdk=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-252-ffIlrTFpPgCxyJ4MrL0_7g-1; Tue, 20 Dec 2022 01:44:28 -0500
X-MC-Unique: ffIlrTFpPgCxyJ4MrL0_7g-1
Received: by mail-oo1-f71.google.com with SMTP id w18-20020a4a6d52000000b0049f209d84bbso5241003oof.7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:44:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IwzbCVxJgzqh/hZntLgZPVw/8F+zWvpGjiJvEA/MIXQ=;
        b=JVPQcNRzvAR/wy6spr2qReyODFoYijEojDW7kvv5iUt1zsaslWm+Bf9/tpvEKaiJbD
         hEz7LjvseBrkySIsaYR+fNpkBLBvNLAD8TxzxC1Q2VnEOmy75YNoQ1W/H86myAFFA2Zi
         waLwul8rj0u0KCSAUt8kkugM828Klm3J5cZxFCIcMEhk283DBExVi4+GR//ABCAPyIH8
         52+3aEElzRvrRU6747VnIDAAyUBaNCnpW9kLOMsx5YCF+bErQpZuzj5tnSKOYu2cWLtn
         Vtc3V4JV/js71QJmKILHy68tmNUduukdQynyF3epkrWvWDHS4mHiHPpLTiDTBQE/JrNv
         2amA==
X-Gm-Message-State: ANoB5plUJlyMzpqkeqM4ErAdcawI6KfOYFPeag7OgCXJ9caKbO0HpFnq
        ehHD0YU2HtQMzyQ3CyhmgW/YoosP8bz9uIblVWdltdo5toKpm/ayRu6xNZE5e3U9og0yjyk5ET1
        z+bCRQggyzRWXPOalnt1QmhiYX6ebMH2V
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id u12-20020a056808114c00b0035e7a427ab5mr1228657oiu.280.1671518667327;
        Mon, 19 Dec 2022 22:44:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7jGysDqwGrWJu197Nisc2Stp5MBJuSZWK+fp7URpsNdbjTOdPL95/ws7E6NNNRPis0ciTrq34bL9g/AETi3fk=
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id
 u12-20020a056808114c00b0035e7a427ab5mr1228649oiu.280.1671518667107; Mon, 19
 Dec 2022 22:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20221128021005.232105-1-lizetao1@huawei.com> <20221128042945-mutt-send-email-mst@kernel.org>
 <CACGkMEtuOk+wyCsvY0uayGAvy926G381PC-csoXVAwCfiKCZQw@mail.gmail.com> <20221219050716-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221219050716-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Dec 2022 14:44:16 +0800
Message-ID: <CACGkMEsHojBVQWUDH4L1xiVTjNm3JgkYBppyOHKr8QLUg3=FsQ@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 6:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Nov 29, 2022 at 11:37:09AM +0800, Jason Wang wrote:
> > >
> > >
> > > Quite a lot of core work here. Jason are you still looking into
> > > hardening?
> >
> > Yes, last time we've discussed a solution that depends on the first
> > kick to enable the interrupt handler. But after some thought, it seems
> > risky since there's no guarantee that the device work in this way.
> >
> > One example is the current vhost_net, it doesn't wait for the kick to
> > process the rx packets. Any more thought on this?
> >
> > Thanks
>
> Specifically virtio net is careful to call virtio_device_ready
> under rtnl lock so buffers are only added after DRIVER_OK.

Right but it only got fixed this year after some code audit.

>
> However we do not need to tie this to kick, this is what I wrote:
>
> > BTW Jason, I had the idea to disable callbacks until driver uses the
> > virtio core for the first time (e.g. by calling virtqueue_add* family of
> > APIs). Less aggressive than your ideas but I feel it will add security
> > to the init path at least.
>
> So not necessarily kick, we can make adding buffers allow the
> interrupt.

Some questions:

1) It introduces a code defined behaviour other than depending on the
spec defined behavior like DRIVER_OK, this will lead extra complexity
in auditing
2) there's no guarantee that the interrupt handler is ready before
virtqueue_add(), or it requires barriers before virtqueue_add() to
make sure the handler is commit

So it looks to me the virtio_device_ready() should be still the
correct way to go:

1) it depends on spec defined behaviour like DRIVER_OK, and it then
can comply with possible future security requirement of drivers
defined in the spec
2) choose to use a new boolean instead of reusing vq->broken
3) enable the harden in driver one by one

Does it make sense?

Thanks

>
>
>
> --
> MST
>

