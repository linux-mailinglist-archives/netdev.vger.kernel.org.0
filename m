Return-Path: <netdev+bounces-9414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47489728DB1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597D32818AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF541113;
	Fri,  9 Jun 2023 02:17:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9AC10F9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:17:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD205269A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686277026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kgOrLEw+CGqbzexB3hSoqE0ZkI0YLrxw+EejRuKoWQE=;
	b=DDdQ6g3thzDeogfCxVvo1+vUjEY6WC971ikUaNIGDq619mZC5VVbUC3tFmWOoB96QxPgJW
	FnodVIZwIouWrMaIzVkzYYjxPNzNa9YoP6CVFAKwgVQDy+tjQMtS+1K7crb1cbn2Q7rCuJ
	d6fzVjv6K7i1FipERF+ltvKt6ZVmGxU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-gaB2M0qeMIaJDlW-EmUj2g-1; Thu, 08 Jun 2023 22:17:05 -0400
X-MC-Unique: gaB2M0qeMIaJDlW-EmUj2g-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b1b44bec2bso8975201fa.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 19:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686277024; x=1688869024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgOrLEw+CGqbzexB3hSoqE0ZkI0YLrxw+EejRuKoWQE=;
        b=KgVokjUZhIk4QVPtVjWaz45d1rner5+GFaufGVNanNgp3kJ5CynmCah998HHVVM8dP
         aFq/KYR1gJu+ZjasKLpONDNuEH05C4cvK569vmWsku0r3xgHeuQP9omqZsiE68hnRXI8
         KLx6tmdm/89kZ7C/6K3PMAooJLEPPezCx9IJzuJjYR0YF1q/bhYJIEHjCSI+Nn0eDWjN
         S5HS6ejFVGCbVY+VSlf/rF/BDMmmztkQK1potTFWlhb3Q+ypKbqUEgyBmS1rf8fsKlPI
         y8uNH2haIsCe2VVMFPsNMDuE/rDPPN4ggvAb78lCXK2pxxFJuF6ed1tL/iFktS9NYxwf
         TPrA==
X-Gm-Message-State: AC+VfDx34k4WS6naF22sjRbyCx+8175PemhytwGAi28f8CEld6MWHYP/
	vmLtWFtdeQ2rkAvd0qpfzEd+ZKyujJY27D6e0LMHZdpC9uVnTwCmU74YynrLPcS/nIRH+HW8Lel
	193+/BTNsAJa+Tmeb6scAwFKuXXwjHNag
X-Received: by 2002:a2e:b163:0:b0:2b0:a4b1:df6 with SMTP id a3-20020a2eb163000000b002b0a4b10df6mr123917ljm.49.1686277023827;
        Thu, 08 Jun 2023 19:17:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/8wdm9HnZ2Nlq0u+xmMq+q13VRX7hsdmKW7Maw8V8eVTx/FWCzW2thzAyQ/MvYC6Xa3LumlbBLVc0Z0sDrGE=
X-Received: by 2002:a2e:b163:0:b0:2b0:a4b1:df6 with SMTP id
 a3-20020a2eb163000000b002b0a4b10df6mr123915ljm.49.1686277023521; Thu, 08 Jun
 2023 19:17:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org> <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org> <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com> <20230608102259-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230608102259-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 9 Jun 2023 10:16:50 +0800
Message-ID: <CACGkMEvirfb8g0ev=b0CjpL5_SPJabqiQKxdwuRNqG2E=N7iGA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Shannon Nelson <shannon.nelson@amd.com>, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 10:23=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
> > On Thu, Jun 8, 2023 at 5:21=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> > >
> > > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> > > >On Thu, Jun 8, 2023 at 4:00=E2=80=AFPM Stefano Garzarella <sgarzare@=
redhat.com> wrote:
> > > >>
> > > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> > > >>
> > > >> [...]
> > > >>
> > > >> >> > > > > I have a question though, what if down the road there
> > > >> >> > > > > is a new feature that needs more changes? It will be
> > > >> >> > > > > broken too just like PACKED no?
> > > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows h=
ow
> > > >> >> > > > > to support?
> > > >> >> > > >
> > > >> >> > > > It looks like we had it, but we took it out (by the way, =
we were
> > > >> >> > > > enabling packed even though we didn't support it):
> > > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/=
linux.git/commit/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> > > >> >> > > >
> > > >> >> > > > The only problem I see is that for each new feature we ha=
ve to modify
> > > >> >> > > > the kernel.
> > > >> >> > > > Could we have new features that don't require handling by=
 vhost-vdpa?
> > > >> >> > > >
> > > >> >> > > > Thanks,
> > > >> >> > > > Stefano
> > > >> >> > >
> > > >> >> > > Jason what do you say to reverting this?
> > > >> >> >
> > > >> >> > I may miss something but I don't see any problem with vDPA co=
re.
> > > >> >> >
> > > >> >> > It's the duty of the parents to advertise the features it has=
. For example,
> > > >> >> >
> > > >> >> > 1) If some kernel version that is packed is not supported via
> > > >> >> > set_vq_state, parents should not advertise PACKED features in=
 this
> > > >> >> > case.
> > > >> >> > 2) If the kernel has support packed set_vq_state(), but it's =
emulated
> > > >> >> > cvq doesn't support, parents should not advertise PACKED as w=
ell
> > > >> >> >
> > > >> >> > If a parent violates the above 2, it looks like a bug of the =
parents.
> > > >> >> >
> > > >> >> > Thanks
> > > >> >>
> > > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> > > >> >
> > > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDP=
A.
> > > >>
> > > >> Sorry, I'm getting lost...
> > > >> We were talking about the fact that vhost-vdpa doesn't handle
> > > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue bef=
ore
> > > >> that series [1], no?
> > > >>
> > > >> The parents seem okay, but maybe I missed a few things.
> > > >>
> > > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-=
shannon.nelson@amd.com/
> > > >
> > > >Yes, more below.
> > > >
> > > >>
> > > >> >
> > > >> >> Should that not have a whitelist of features
> > > >> >> since it interprets ioctls differently depending on this?
> > > >> >
> > > >> >If there's a bug, it might only matter the following setup:
> > > >> >
> > > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> > > >> >
> > > >> >This seems to be broken since VDUSE was introduced. If we really =
want
> > > >> >to backport something, it could be a fix to filter out PACKED in
> > > >> >VDUSE?
> > > >>
> > > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> > > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> > > >> (I haven't tried), so why should we filter PACKED in VDUSE?
> > > >
> > > >I don't think we need any filtering since:
> > > >
> > > >PACKED features has been advertised to userspace via uAPI since
> > > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> > > >would be very hard to restrict it again. For the userspace that trie=
s
> > > >to negotiate PACKED:
> > > >
> > > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works=
 well
> > > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break =
silently
> > > >
> > > >If we backport the fixes to -stable, we may break the application at
> > > >least in the case 1).
> > >
> > > Okay, I see now, thanks for the details!
> > >
> > > Maybe instead of "break silently", we can return an explicit error fo=
r
> > > SET_VRING_BASE/GET_VRING_BASE in stable branches.
> > > But if there are not many cases, we can leave it like that.
> >
> > A second thought, if we need to do something for stable. is it better
> > if we just backport Shannon's series to stable?
> >
> > >
> > > I was just concerned about how does the user space understand that it
> > > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a give=
n
> > > kernel or not.
> >
> > My understanding is that if packed is advertised, the application
> > should assume SET/GET_VRING_BASE work.
> >
> > Thanks
>
>
> Let me ask you this. This is a bugfix yes?

Not sure since it may break existing user space applications which
make it hard to be backported to -stable.

Before the fix, PACKED might work if SET/GET_VRING_BASE is not used.
After the fix, PACKED won't work at all.

Thanks

What is the appropriate Fixes
> tag?
>
> > >
> > > Thanks,
> > > Stefano
> > >
>


