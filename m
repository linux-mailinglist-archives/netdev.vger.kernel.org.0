Return-Path: <netdev+bounces-9154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9E6727969
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6A42815C9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F0A8C0B;
	Thu,  8 Jun 2023 08:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214DF628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:00:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625A2D44
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686211212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FNDbmGsJ3mpkLEzox86FiotwEXbzoL7gRModpMEFp+s=;
	b=egynQLebi2sH3JBGuZpLXxM6hNkNgGa+JZL4uCkdVoY7PQ4zrq3VBbRlHs5sEFvOyMGHfF
	8JNhH9sXOkbZLJ6sDZ4fP0ebqSm5YQkcirWdvSBT6TX5LBYQqJJQ6g4R+4dmc8vbpHJogs
	89Ox/7EKDAzRf1z/PlQV+J/ucc8BNh0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-bgWU8C7jP0KzN9flKGCabw-1; Thu, 08 Jun 2023 04:00:10 -0400
X-MC-Unique: bgWU8C7jP0KzN9flKGCabw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-977c516686aso50795566b.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 01:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211210; x=1688803210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNDbmGsJ3mpkLEzox86FiotwEXbzoL7gRModpMEFp+s=;
        b=Ao/5U7qf9DRS7Fe2NfdLoQWZ88NLXrL7jIMbjhjpNs/1KY1JJZPEiydbZQ7XFoQW5z
         KyXGsxhENjRIDoQH3OZZUpXNqurny8xuEKXi1jhuANL+e9Ep/KKrRE5fWJiuITZ82u+l
         bxhnbCG9tuSyuKu+LlHH4paNWSbZEgFWWxKAKoUppbCQ+joz0/Lyh//O5/WIzsdXMmxi
         eI82GIsYo2gA/iXwMKpzKDCUfI4dtHclcu/om18c68T/gPqs/bv/BBOUCksoe1ZpDJFo
         P3imoSkj+RU5ZLoYXgBRbOxks19GCMVZk2HLXOIez4WE7hcoTCZ8ghwCSolWp8wSldtF
         7WdQ==
X-Gm-Message-State: AC+VfDylyFWN/INqppmM+SeiNRRrFHJYPKrYZVRH4v46IY7F1lVYckZI
	cmRlqEla84vOdr5s99Py7lTNwlP0fl4Wd1qPcJlNTNlwMG78IsTrmwYN7auhbPR16B5oaR65aAb
	bNOn/FgAJWyrO9LzV
X-Received: by 2002:a17:907:e92:b0:978:9b09:ccaf with SMTP id ho18-20020a1709070e9200b009789b09ccafmr1684183ejc.14.1686211209897;
        Thu, 08 Jun 2023 01:00:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4iYx/Ymtxl9ZzpcCCqLWJ3wFdcVDKXynlxsTc5fgKIP2plln1Gn+TgS5Yvth3Zl/mptkx4nQ==
X-Received: by 2002:a17:907:e92:b0:978:9b09:ccaf with SMTP id ho18-20020a1709070e9200b009789b09ccafmr1684157ejc.14.1686211209532;
        Thu, 08 Jun 2023 01:00:09 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-111.business.telecomitalia.it. [87.12.25.111])
        by smtp.gmail.com with ESMTPSA id jt26-20020a170906dfda00b00978993e0d21sm351480ejc.78.2023.06.08.01.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 01:00:08 -0700 (PDT)
Date: Thu, 8 Jun 2023 09:59:49 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Shannon Nelson <shannon.nelson@amd.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
References: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:

[...]

>> > > > > I have a question though, what if down the road there
>> > > > > is a new feature that needs more changes? It will be
>> > > > > broken too just like PACKED no?
>> > > > > Shouldn't vdpa have an allowlist of features it knows how
>> > > > > to support?
>> > > >
>> > > > It looks like we had it, but we took it out (by the way, we were
>> > > > enabling packed even though we didn't support it):
>> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
>> > > >
>> > > > The only problem I see is that for each new feature we have to modify
>> > > > the kernel.
>> > > > Could we have new features that don't require handling by vhost-vdpa?
>> > > >
>> > > > Thanks,
>> > > > Stefano
>> > >
>> > > Jason what do you say to reverting this?
>> >
>> > I may miss something but I don't see any problem with vDPA core.
>> >
>> > It's the duty of the parents to advertise the features it has. For example,
>> >
>> > 1) If some kernel version that is packed is not supported via
>> > set_vq_state, parents should not advertise PACKED features in this
>> > case.
>> > 2) If the kernel has support packed set_vq_state(), but it's emulated
>> > cvq doesn't support, parents should not advertise PACKED as well
>> >
>> > If a parent violates the above 2, it looks like a bug of the parents.
>> >
>> > Thanks
>>
>> Yes but what about vhost_vdpa? Talking about that not the core.
>
>Not sure it's a good idea to workaround parent bugs via vhost-vDPA.

Sorry, I'm getting lost...
We were talking about the fact that vhost-vdpa doesn't handle
SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
that series [1], no?

The parents seem okay, but maybe I missed a few things.

[1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/

>
>> Should that not have a whitelist of features
>> since it interprets ioctls differently depending on this?
>
>If there's a bug, it might only matter the following setup:
>
>SET_VRING_BASE/GET_VRING_BASE + VDUSE.
>
>This seems to be broken since VDUSE was introduced. If we really want
>to backport something, it could be a fix to filter out PACKED in
>VDUSE?

mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
I think VDUSE works fine with packed virtqueue using virtio-vdpa
(I haven't tried), so why should we filter PACKED in VDUSE?

Thanks,
Stefano


