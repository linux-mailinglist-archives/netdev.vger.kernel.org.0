Return-Path: <netdev+bounces-9150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE39F727919
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B8FD1C20FCF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D86749E;
	Thu,  8 Jun 2023 07:46:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F91C2F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:46:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEFA26B1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686210375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4jks4xbNwfyNEVL0zypzxaGA+rFgT4ZCRcn8JM16ug=;
	b=Kk+wMU9CIPPuF/9WI+QIbgj2KEAc4RaRlmEEuVhMGJRDiZpcCqGORWLeA8hfktuRf4ECQn
	wzrrbnGYXT75Eep6+Ik/G3TJZTHrFP46zL9hVUL/t4t6t9G45dxeSO5yBK6BUXcHyfXSPB
	AjCzLLkoWY9ApQTmY8z0G7Ub/vggLpE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-yxREnsO0NVufCMUUZQf0eA-1; Thu, 08 Jun 2023 03:46:14 -0400
X-MC-Unique: yxREnsO0NVufCMUUZQf0eA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f62cf0bb78so200005e87.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 00:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686210373; x=1688802373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m4jks4xbNwfyNEVL0zypzxaGA+rFgT4ZCRcn8JM16ug=;
        b=laYW68p/fv8Bi5GyOCUObpIOLDsrdnCLmtf8WmkVOhLi/ywtUew3BT3lyyxuM2D92r
         yBlQ4Vjm4RbCFSxFn2qBl8K9qqiiwNHxWunFDLdAR+u12r9aArJS3TSrNIrI32m2grch
         bjDYY1Crx5hsze4fBnKKf47NfPU1NEnmc5iQSV5DwAE/rohxLe2WRZ23RwsmLK5fDaOx
         VHC3TrOXx5udelEClzYE8YJAXfe5+0z7tvpWW8u53m+UbtGyJLiYuHmZZI+XViMKJpaO
         k9QCAP+9R3Kjyj7wbobeFnvzU7pXdApGeuqS4jLgK+EQx+Z3LQXssQPu/WNo9pE777+n
         t7Dw==
X-Gm-Message-State: AC+VfDz9py/7XnDz/AZL+BKlnehcu0Ob5osGH262fY8RLKwOf1IVeHcm
	s2ebglHVNu/TUs7x/niAJo+8+UgHPPgY4KIqjaajHq2yj6dgVJ3rCFerWZ3MoWPVKq62UG5zvOH
	fCtuxgwu54qtYQiF5RHv8t9wyuI87WD8s
X-Received: by 2002:a2e:8012:0:b0:2b2:90e:165d with SMTP id j18-20020a2e8012000000b002b2090e165dmr1082556ljg.2.1686210372777;
        Thu, 08 Jun 2023 00:46:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63Z8QuefCG7zMHV1KMGDYxy81pEGWNOWiZwJ5Vm+tBFN/LuRKfkpj4hyczsig6YB47pZpflzAsOmk9Bar5Yo4=
X-Received: by 2002:a2e:8012:0:b0:2b2:90e:165d with SMTP id
 j18-20020a2e8012000000b002b2090e165dmr1082541ljg.2.1686210372444; Thu, 08 Jun
 2023 00:46:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org> <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org> <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org> <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org> <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230608020111-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jun 2023 15:46:00 +0800
Message-ID: <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 2:03=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Thu, Jun 08, 2023 at 08:42:15AM +0800, Jason Wang wrote:
> > On Wed, Jun 7, 2023 at 5:43=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Wed, Jun 07, 2023 at 10:39:15AM +0200, Stefano Garzarella wrote:
> > > > On Tue, Jun 6, 2023 at 2:58=E2=80=AFPM Michael S. Tsirkin <mst@redh=
at.com> wrote:
> > > > >
> > > > > On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> > > > > > On Mon, Jun 5, 2023 at 10:58=E2=80=AFPM Stefano Garzarella <sga=
rzare@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin =
wrote:
> > > > > > > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella=
 wrote:
> > > > > > > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirk=
in wrote:
> > > > > > > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzar=
ella wrote:
> > > > > > > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. T=
sirkin wrote:
> > > > > > > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Ga=
rzarella wrote:
> > > > > > > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST=
_SET_VRING_BASE)
> > > > > > > >> > > > > don't support packed virtqueue well yet, so let's =
filter the
> > > > > > > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa=
_get_features().
> > > > > > > >> > > > >
> > > > > > > >> > > > > This way, even if the device supports it, we don't=
 risk it being
> > > > > > > >> > > > > negotiated, then the VMM is unable to set the vrin=
g state properly.
> > > > > > > >> > > > >
> > > > > > > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based =
backend")
> > > > > > > >> > > > > Cc: stable@vger.kernel.org
> > > > > > > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat=
.com>
> > > > > > > >> > > > > ---
> > > > > > > >> > > > >
> > > > > > > >> > > > > Notes:
> > > > > > > >> > > > >     This patch should be applied before the "[PATC=
H v2 0/3] vhost_vdpa:
> > > > > > > >> > > > >     better PACKED support" series [1] and backport=
ed in stable branches.
> > > > > > > >> > > > >
> > > > > > > >> > > > >     We can revert it when we are sure that everyth=
ing is working with
> > > > > > > >> > > > >     packed virtqueues.
> > > > > > > >> > > > >
> > > > > > > >> > > > >     Thanks,
> > > > > > > >> > > > >     Stefano
> > > > > > > >> > > > >
> > > > > > > >> > > > >     [1] https://lore.kernel.org/virtualization/202=
30424225031.18947-1-shannon.nelson@amd.com/
> > > > > > > >> > > >
> > > > > > > >> > > > I'm a bit lost here. So why am I merging "better PAC=
KED support" then?
> > > > > > > >> > >
> > > > > > > >> > > To really support packed virtqueue with vhost-vdpa, at=
 that point we would
> > > > > > > >> > > also have to revert this patch.
> > > > > > > >> > >
> > > > > > > >> > > I wasn't sure if you wanted to queue the series for th=
is merge window.
> > > > > > > >> > > In that case do you think it is better to send this pa=
tch only for stable
> > > > > > > >> > > branches?
> > > > > > > >> > > > Does this patch make them a NOP?
> > > > > > > >> > >
> > > > > > > >> > > Yep, after applying the "better PACKED support" series=
 and being
> > > > > > > >> > > sure that
> > > > > > > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we =
should revert this
> > > > > > > >> > > patch.
> > > > > > > >> > >
> > > > > > > >> > > Let me know if you prefer a different approach.
> > > > > > > >> > >
> > > > > > > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinkin=
g that the kernel
> > > > > > > >> > > interprets them the right way, when it does not.
> > > > > > > >> > >
> > > > > > > >> > > Thanks,
> > > > > > > >> > > Stefano
> > > > > > > >> > >
> > > > > > > >> >
> > > > > > > >> > If this fixes a bug can you add Fixes tags to each of th=
em? Then it's ok
> > > > > > > >> > to merge in this window. Probably easier than the elabor=
ate
> > > > > > > >> > mask/unmask dance.
> > > > > > > >>
> > > > > > > >> CCing Shannon (the original author of the "better PACKED s=
upport"
> > > > > > > >> series).
> > > > > > > >>
> > > > > > > >> IIUC Shannon is going to send a v3 of that series to fix t=
he
> > > > > > > >> documentation, so Shannon can you also add the Fixes tags?
> > > > > > > >>
> > > > > > > >> Thanks,
> > > > > > > >> Stefano
> > > > > > > >
> > > > > > > >Well this is in my tree already. Just reply with
> > > > > > > >Fixes: <>
> > > > > > > >to each and I will add these tags.
> > > > > > >
> > > > > > > I tried, but it is not easy since we added the support for pa=
cked
> > > > > > > virtqueue in vdpa and vhost incrementally.
> > > > > > >
> > > > > > > Initially I was thinking of adding the same tag used here:
> > > > > > >
> > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > >
> > > > > > > Then I discovered that vq_state wasn't there, so I was thinki=
ng of
> > > > > > >
> > > > > > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/=
get_vq_state()")
> > > > > > >
> > > > > > > So we would have to backport quite a few patches into the sta=
ble branches.
> > > > > > > I don't know if it's worth it...
> > > > > > >
> > > > > > > I still think it is better to disable packed in the stable br=
anches,
> > > > > > > otherwise I have to make a list of all the patches we need.
> > > > > > >
> > > > > > > Any other ideas?
> > > > > >
> > > > > > AFAIK, except for vp_vdpa, pds seems to be the first parent tha=
t
> > > > > > supports packed virtqueue. Users should not notice anything wro=
ng if
> > > > > > they don't use packed virtqueue. And the problem of vp_vdpa + p=
acked
> > > > > > virtqueue came since the day0 of vp_vdpa. It seems fine to do n=
othing
> > > > > > I guess.
> > > > > >
> > > > > > Thanks
> > > > >
> > > > >
> > > > > I have a question though, what if down the road there
> > > > > is a new feature that needs more changes? It will be
> > > > > broken too just like PACKED no?
> > > > > Shouldn't vdpa have an allowlist of features it knows how
> > > > > to support?
> > > >
> > > > It looks like we had it, but we took it out (by the way, we were
> > > > enabling packed even though we didn't support it):
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> > > >
> > > > The only problem I see is that for each new feature we have to modi=
fy
> > > > the kernel.
> > > > Could we have new features that don't require handling by vhost-vdp=
a?
> > > >
> > > > Thanks,
> > > > Stefano
> > >
> > > Jason what do you say to reverting this?
> >
> > I may miss something but I don't see any problem with vDPA core.
> >
> > It's the duty of the parents to advertise the features it has. For exam=
ple,
> >
> > 1) If some kernel version that is packed is not supported via
> > set_vq_state, parents should not advertise PACKED features in this
> > case.
> > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > cvq doesn't support, parents should not advertise PACKED as well
> >
> > If a parent violates the above 2, it looks like a bug of the parents.
> >
> > Thanks
>
> Yes but what about vhost_vdpa? Talking about that not the core.

Not sure it's a good idea to workaround parent bugs via vhost-vDPA.

> Should that not have a whitelist of features
> since it interprets ioctls differently depending on this?

If there's a bug, it might only matter the following setup:

SET_VRING_BASE/GET_VRING_BASE + VDUSE.

This seems to be broken since VDUSE was introduced. If we really want
to backport something, it could be a fix to filter out PACKED in
VDUSE?

Thanks

>
> > >
> > > --
> > > MST
> > >
>


