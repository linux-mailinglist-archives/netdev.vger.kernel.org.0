Return-Path: <netdev+bounces-9241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D0C728293
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 675B32816E7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4761114A80;
	Thu,  8 Jun 2023 14:23:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE1B12B7F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 14:23:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8405D2D4B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686234208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ylaz4EsLWG8gT+tyBhiFM3PeWqHKsVLZz02Gzuw52i8=;
	b=EaLxz5znkAt7QD29ztMwfoVWWngwbnK73ZU6q56DAavPhe9RjpqfZ2Pb28Zr5SZlgfeimG
	atkGErWJ0f9i0kBsYbJmb5B0LoIlzma3Mv0JHgAIyf/KPEW7fBSp17btl5tnVQHE89Zi7b
	kJk6sNiavM4rULxggZyKGHKIjr1+pQY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-TOm3yEdzPuGcqPJ2PHH0gA-1; Thu, 08 Jun 2023 10:23:27 -0400
X-MC-Unique: TOm3yEdzPuGcqPJ2PHH0gA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30e3fb5d1a4so308026f8f.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 07:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686234206; x=1688826206;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylaz4EsLWG8gT+tyBhiFM3PeWqHKsVLZz02Gzuw52i8=;
        b=lCcGzBXxOVblCegd5yP5CLgneB0DMYImHCleErqQGOOO/UNJ6ijymtmM6LjGzqqRlq
         H1LsTmYPNCGyp/QaPFjlaniNFL8/vhZJDdPrKu0ETJVZWjc2g7i0jnFdXFB8b4qQG4Cr
         SGmWEDVXdKFu6jPl2Z32nY1YM6JFYZo6t4bMNGoz3wkBTq70mS++iU1I0cT4/Of8ELuo
         Rn624drbHcos3/kgKhg2UBikHOeOfxKUKni3gWu5XnPp8uCfMlkxjvhm5Ut3PLdYvf4o
         hpY5pKrXgZQdKcE47Rh4SiWCGINgeus/NgckMXoYQvt4j1aJKDcn9AEWOKzzeGu3gII5
         860g==
X-Gm-Message-State: AC+VfDw+rDBYzJGC/tjozuaJzSkVPusdrpCOw6tQG0dtnuAxO1l5Z/Fr
	OKaewsRndgjNCYn5juWg2jICGLKQpp5Nf1rI4xbFVpRQ6zhCYA4RaIt8MuF5KJATpdjZmjnnz0H
	fs7H1VfGZyv2ctJus
X-Received: by 2002:adf:dfc1:0:b0:30e:4886:3533 with SMTP id q1-20020adfdfc1000000b0030e48863533mr7800343wrn.34.1686234206023;
        Thu, 08 Jun 2023 07:23:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6c9mr4sGROJv3wpcDBq+xuHW3beEKuX1wsKDRXlb1F7uOxTNYgZiIdVFsqG1xx2NOA7F1/fA==
X-Received: by 2002:adf:dfc1:0:b0:30e:4886:3533 with SMTP id q1-20020adfdfc1000000b0030e48863533mr7800329wrn.34.1686234205650;
        Thu, 08 Jun 2023 07:23:25 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c021a00b003f7f475c3c7sm2175514wmi.8.2023.06.08.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 07:23:25 -0700 (PDT)
Date: Thu, 8 Jun 2023 10:23:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230608102259-mutt-send-email-mst@kernel.org>
References: <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
> On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> > >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >>
> > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> > >>
> > >> [...]
> > >>
> > >> >> > > > > I have a question though, what if down the road there
> > >> >> > > > > is a new feature that needs more changes? It will be
> > >> >> > > > > broken too just like PACKED no?
> > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> > >> >> > > > > to support?
> > >> >> > > >
> > >> >> > > > It looks like we had it, but we took it out (by the way, we were
> > >> >> > > > enabling packed even though we didn't support it):
> > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > >> >> > > >
> > >> >> > > > The only problem I see is that for each new feature we have to modify
> > >> >> > > > the kernel.
> > >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
> > >> >> > > >
> > >> >> > > > Thanks,
> > >> >> > > > Stefano
> > >> >> > >
> > >> >> > > Jason what do you say to reverting this?
> > >> >> >
> > >> >> > I may miss something but I don't see any problem with vDPA core.
> > >> >> >
> > >> >> > It's the duty of the parents to advertise the features it has. For example,
> > >> >> >
> > >> >> > 1) If some kernel version that is packed is not supported via
> > >> >> > set_vq_state, parents should not advertise PACKED features in this
> > >> >> > case.
> > >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > >> >> > cvq doesn't support, parents should not advertise PACKED as well
> > >> >> >
> > >> >> > If a parent violates the above 2, it looks like a bug of the parents.
> > >> >> >
> > >> >> > Thanks
> > >> >>
> > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> > >> >
> > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> > >>
> > >> Sorry, I'm getting lost...
> > >> We were talking about the fact that vhost-vdpa doesn't handle
> > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> > >> that series [1], no?
> > >>
> > >> The parents seem okay, but maybe I missed a few things.
> > >>
> > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > >
> > >Yes, more below.
> > >
> > >>
> > >> >
> > >> >> Should that not have a whitelist of features
> > >> >> since it interprets ioctls differently depending on this?
> > >> >
> > >> >If there's a bug, it might only matter the following setup:
> > >> >
> > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> > >> >
> > >> >This seems to be broken since VDUSE was introduced. If we really want
> > >> >to backport something, it could be a fix to filter out PACKED in
> > >> >VDUSE?
> > >>
> > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> > >> (I haven't tried), so why should we filter PACKED in VDUSE?
> > >
> > >I don't think we need any filtering since:
> > >
> > >PACKED features has been advertised to userspace via uAPI since
> > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> > >would be very hard to restrict it again. For the userspace that tries
> > >to negotiate PACKED:
> > >
> > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
> > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
> > >
> > >If we backport the fixes to -stable, we may break the application at
> > >least in the case 1).
> >
> > Okay, I see now, thanks for the details!
> >
> > Maybe instead of "break silently", we can return an explicit error for
> > SET_VRING_BASE/GET_VRING_BASE in stable branches.
> > But if there are not many cases, we can leave it like that.
> 
> A second thought, if we need to do something for stable. is it better
> if we just backport Shannon's series to stable?
> 
> >
> > I was just concerned about how does the user space understand that it
> > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
> > kernel or not.
> 
> My understanding is that if packed is advertised, the application
> should assume SET/GET_VRING_BASE work.
> 
> Thanks


Let me ask you this. This is a bugfix yes? What is the appropriate Fixes
tag?

> >
> > Thanks,
> > Stefano
> >


