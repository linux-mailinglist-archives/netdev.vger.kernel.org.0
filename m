Return-Path: <netdev+bounces-6709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A5A71782D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F260E280A96
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D532CA947;
	Wed, 31 May 2023 07:28:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EE9A93D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:28:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2D197
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685518088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/jcj1p+dPSX4LPtsNzKmq9GtWWjgKaTvB7WD/Tt27U=;
	b=RYO+BX4XX3EvuqiVeJsxz6VaPTU+Wdl7Sc8TVz2xEvetWlsntNu0aKAIWlJaCblRguMdaU
	xe9AKwzSL4BQWiEyqZ8PHp8RTfOhUfupOVP9og8YAhf2RWzmU0A7fk/lPGAnb2XboCxcy0
	M1DrUtet1zeg6Qx3nbQLZG+nXIDp5fM=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-74Q1GRtbNb682PNQtv8X8g-1; Wed, 31 May 2023 03:28:07 -0400
X-MC-Unique: 74Q1GRtbNb682PNQtv8X8g-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-bb0d11a56abso2511593276.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685518086; x=1688110086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/jcj1p+dPSX4LPtsNzKmq9GtWWjgKaTvB7WD/Tt27U=;
        b=U1FlTGw5j7FvQhAvoZk3ESkVBeh0Z5zRlitR4uFzjryXvtog2Rn8LpAeypk0Jrzk6K
         x8lPlHUO8yZyQoWgbNY5QVIcBnrKWi7JALHM08o/gKFlZ7tXKrrZfIDaaa2SVITU5TIq
         cjMYVn2T6IKaNx/m5w5+DJFfOQHHu8OwhSLKNcYNUfuDnEoLyZrT4qRoLiqNuo/iM04p
         IpPWltJqUpVhycDnBpCZ0ogw0yB9tD/jn+LfWdBoOC1UVTEWzc2CHRPPZGZ1JDet2SC8
         IJywVgcP9jttAp4q2b9lY2226XT4kbi70PZdfpq731F2yc9bCmvpX3QYw3olnsapDiXm
         iepA==
X-Gm-Message-State: AC+VfDy2fLqfUrC9K+e9EPsltxmTxBC7ok29NMgj69Dak68caL7AG1os
	DvixSuVtkx0Iru2LC8QcPisOYlHSb+FXxS5HucllXmY8RajOMMxjQ6SzS4uc/kLbpeVvktzGjdy
	GPm5pKqPnF+6DCawAtuGWqjGoBAwKhgjh
X-Received: by 2002:a25:e74a:0:b0:ba8:c000:3da8 with SMTP id e71-20020a25e74a000000b00ba8c0003da8mr5501237ybh.32.1685518086709;
        Wed, 31 May 2023 00:28:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Plgt9hmPFiSDXc0oeLAkYKsykTTqd4B5pwE2g+dpW8bCb+6KVSnOeDacyokQkuQP23w/NyGAste2scW2tm4Y=
X-Received: by 2002:a25:e74a:0:b0:ba8:c000:3da8 with SMTP id
 e71-20020a25e74a000000b00ba8c0003da8mr5501224ybh.32.1685518086460; Wed, 31
 May 2023 00:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000001777f605fce42c5f@google.com> <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com> <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
In-Reply-To: <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 31 May 2023 09:27:54 +0200
Message-ID: <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in vhost_work_queue
To: michael.christie@oracle.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux-foundation.org, 
	stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 6:30=E2=80=AFPM <michael.christie@oracle.com> wrote=
:
>
> On 5/30/23 11:17 AM, Stefano Garzarella wrote:
> > On Tue, May 30, 2023 at 11:09:09AM -0500, Mike Christie wrote:
> >> On 5/30/23 11:00 AM, Stefano Garzarella wrote:
> >>> I think it is partially related to commit 6e890c5d5021 ("vhost: use
> >>> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: mov=
e
> >>> worker thread fields to new struct"). Maybe that commits just
> >>> highlighted the issue and it was already existing.
> >>
> >> See my mail about the crash. Agree with your analysis about worker->vt=
sk
> >> not being set yet. It's a bug from my commit where I should have not s=
et
> >> it so early or I should be checking for
> >>
> >> if (dev->worker && worker->vtsk)
> >>
> >> instead of
> >>
> >> if (dev->worker)
> >
> > Yes, though, in my opinion the problem may persist depending on how the
> > instructions are reordered.
>
> Ah ok.
>
> >
> > Should we protect dev->worker() with an RCU to be safe?
>
> For those multiple worker patchsets Jason had asked me about supporting
> where we don't have a worker while we are swapping workers around. To do
> that I had added rcu around the dev->worker. I removed it in later patchs=
ets
> because I didn't think anyone would use it.
>
> rcu would work for your case and for what Jason had requested.

Yeah, so you already have some patches?

Do you want to send it to solve this problem?

Thanks,
Stefano


