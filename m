Return-Path: <netdev+bounces-9173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66860727B6B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEDC61C20F59
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7541EA942;
	Thu,  8 Jun 2023 09:31:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63160947D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:31:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7402226B1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686216613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C7hoCCHwyZ78t8MhfigepGi6we5dYHokO9yNVTkJZRY=;
	b=B4P9xSgzi8QwL2203PYq4eIMMtd2TUHAjvZTIUYBRGxS0+GrTr6w0KOOgzGyU6yEMs0GVx
	f01277F1IAyM2svyN25j+34TBGfmYuLMsmrkW43T4fCpvIcsPTy9LrhzZhzdveHCK8D1QM
	z3hy55Tlb1+JDZx58rbq8kGo/CW2D7Q=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-YR-2CN_RPtWir-enF8lCog-1; Thu, 08 Jun 2023 05:30:11 -0400
X-MC-Unique: YR-2CN_RPtWir-enF8lCog-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b1fa7c9f06so1964421fa.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 02:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686216609; x=1688808609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7hoCCHwyZ78t8MhfigepGi6we5dYHokO9yNVTkJZRY=;
        b=Rsz7v2bIcIEh+/5hKTTPj3axSkfavDQGqcBvxX61RIrDmwQosHdTI0SxV2WkJh96XO
         im8jX/gppd4BdeWyiRLUj/Qg8EDxkO3BagDFaFjfF+MQoxXMHc4ALAvPRyLCnzkXgsrH
         gviQePoaD/X2EiXcVj2eSy+fDm3ji+K9rvQrXMBSD0j2raPbdfJfB3ADNxCXFb1uzm7D
         sjVwB4JLQtE1dseJX4IA9UFVvqH/Ur0nCiQo+eWEfB6GZS4nf1y8S7OoYM17ANYJMG8Y
         Tg1UwfS9bGXO9PYsGDXwFnmAIgLGBkTBoc9uoA3l0cdffQJzt5U0VSCEHibzLTMlHXHK
         xTgA==
X-Gm-Message-State: AC+VfDxACmmKgYzNX9/ggbZ0bb8RByKyt3R0H5vs7DDvyJ+2VDFezbAw
	CrO49D3n55IxnR7QrzaRbHoAqbycUaqyAPXy+mfDDY3VZ52VgI/d6sAUmetZkCuLs385GegmWMG
	/Vr49w6gbKZxGRhf3YvDSr1ziu8jmLwh+
X-Received: by 2002:a2e:7c01:0:b0:2b0:45ff:7952 with SMTP id x1-20020a2e7c01000000b002b045ff7952mr2937340ljc.46.1686216609603;
        Thu, 08 Jun 2023 02:30:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UZCodSXe8QJG9qyQ8hxilMfqcB032BMizZjc3X/xA2bZal/+MGVVGoUXxdh3KL+1mGFUZIjOMQh01hn/DswI=
X-Received: by 2002:a2e:7c01:0:b0:2b0:45ff:7952 with SMTP id
 x1-20020a2e7c01000000b002b045ff7952mr2937333ljc.46.1686216609317; Thu, 08 Jun
 2023 02:30:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org> <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org> <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org> <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com> <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
In-Reply-To: <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jun 2023 17:29:58 +0800
Message-ID: <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Shannon Nelson <shannon.nelson@amd.com>, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 5:21=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> >On Thu, Jun 8, 2023 at 4:00=E2=80=AFPM Stefano Garzarella <sgarzare@redh=
at.com> wrote:
> >>
> >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> >>
> >> [...]
> >>
> >> >> > > > > I have a question though, what if down the road there
> >> >> > > > > is a new feature that needs more changes? It will be
> >> >> > > > > broken too just like PACKED no?
> >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> >> >> > > > > to support?
> >> >> > > >
> >> >> > > > It looks like we had it, but we took it out (by the way, we w=
ere
> >> >> > > > enabling packed even though we didn't support it):
> >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linu=
x.git/commit/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> >> >> > > >
> >> >> > > > The only problem I see is that for each new feature we have t=
o modify
> >> >> > > > the kernel.
> >> >> > > > Could we have new features that don't require handling by vho=
st-vdpa?
> >> >> > > >
> >> >> > > > Thanks,
> >> >> > > > Stefano
> >> >> > >
> >> >> > > Jason what do you say to reverting this?
> >> >> >
> >> >> > I may miss something but I don't see any problem with vDPA core.
> >> >> >
> >> >> > It's the duty of the parents to advertise the features it has. Fo=
r example,
> >> >> >
> >> >> > 1) If some kernel version that is packed is not supported via
> >> >> > set_vq_state, parents should not advertise PACKED features in thi=
s
> >> >> > case.
> >> >> > 2) If the kernel has support packed set_vq_state(), but it's emul=
ated
> >> >> > cvq doesn't support, parents should not advertise PACKED as well
> >> >> >
> >> >> > If a parent violates the above 2, it looks like a bug of the pare=
nts.
> >> >> >
> >> >> > Thanks
> >> >>
> >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> >> >
> >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> >>
> >> Sorry, I'm getting lost...
> >> We were talking about the fact that vhost-vdpa doesn't handle
> >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> >> that series [1], no?
> >>
> >> The parents seem okay, but maybe I missed a few things.
> >>
> >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shan=
non.nelson@amd.com/
> >
> >Yes, more below.
> >
> >>
> >> >
> >> >> Should that not have a whitelist of features
> >> >> since it interprets ioctls differently depending on this?
> >> >
> >> >If there's a bug, it might only matter the following setup:
> >> >
> >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> >> >
> >> >This seems to be broken since VDUSE was introduced. If we really want
> >> >to backport something, it could be a fix to filter out PACKED in
> >> >VDUSE?
> >>
> >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> >> (I haven't tried), so why should we filter PACKED in VDUSE?
> >
> >I don't think we need any filtering since:
> >
> >PACKED features has been advertised to userspace via uAPI since
> >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> >would be very hard to restrict it again. For the userspace that tries
> >to negotiate PACKED:
> >
> >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works wel=
l
> >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break sile=
ntly
> >
> >If we backport the fixes to -stable, we may break the application at
> >least in the case 1).
>
> Okay, I see now, thanks for the details!
>
> Maybe instead of "break silently", we can return an explicit error for
> SET_VRING_BASE/GET_VRING_BASE in stable branches.
> But if there are not many cases, we can leave it like that.

A second thought, if we need to do something for stable. is it better
if we just backport Shannon's series to stable?

>
> I was just concerned about how does the user space understand that it
> can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
> kernel or not.

My understanding is that if packed is advertised, the application
should assume SET/GET_VRING_BASE work.

Thanks

>
> Thanks,
> Stefano
>


