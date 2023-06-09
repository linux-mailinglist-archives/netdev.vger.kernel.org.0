Return-Path: <netdev+bounces-9441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCB27290C1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85C821C210CF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD29749F;
	Fri,  9 Jun 2023 07:17:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494083B407
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:17:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB07F3595
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686295047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15kZRnaZwPiIUtkudYdawd69yNtpyzsjo2sikqV4oqc=;
	b=QzPLPBXgRgryd1xGQuNIjJXhnFbLjaPVr8/Pge65yJ6h/33uTZpyb11Y670tIAbRlD6RDL
	HX6jzgKgGy5lnbLcSuzz26rjo6NcMET7Sq/3IBAT2uTEKIyFcrWLV1eVscWuPFJ/N1OGl1
	KBkdzZKDpsPWA3kexsLO07uJGF2WG6I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-KwRmV46ON4y0xCch7Ofjng-1; Fri, 09 Jun 2023 03:17:26 -0400
X-MC-Unique: KwRmV46ON4y0xCch7Ofjng-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7ecfccf2eso7059225e9.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 00:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686295045; x=1688887045;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15kZRnaZwPiIUtkudYdawd69yNtpyzsjo2sikqV4oqc=;
        b=laRZvNSqtv25qgyDii2skQwdfda4+QwAOCRL9Lp1dQzdcZIkWvpHfDvX9F22wvmFka
         sZLTgVtWeih0ZASPD7kbQfw3jUOvyIhB0vbpSTEJ09Idhr9xZunYGk4pCirLhbvaNkuO
         7jEkrUpAIMh4CVFvu0cLVHTDC54kw6JOQFh4ghiYTM6hqU6T59IHMG4F/rEJ7Y5vc20n
         OnmRHlBD8lbzM9xem+ca/6O15EdH4415HnhSXnWj3Gjz4mE4y1IUOnEpHTg5zxxQ5BRC
         LDXqlgCdn/KoTWsjMcutNr1UWcff6jdhvLGWFa3Jt6SCfNogwjBcFgb4JHW/POhz09rr
         /cfQ==
X-Gm-Message-State: AC+VfDyvPIfr9ss0yCOV4uaUYCN7ddDSJWsYm98zYn2nIS/23HC61Qe8
	N/BCBZWX/E1tvdEWQiXJcMfxSqH0dl7t47nReZXtMlU1b3tbSS+AWYSLrfXW3qdwAJFIO7mFbvV
	4JhXd4CtcbFsSgGrF
X-Received: by 2002:a05:600c:c2:b0:3f7:30c0:c6a with SMTP id u2-20020a05600c00c200b003f730c00c6amr433287wmm.25.1686295045441;
        Fri, 09 Jun 2023 00:17:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7waRKCvgqgJoAjOYyIenyGhdYJn4/2vpRsAbVkjBZW18/rDXsC3rXgUmARtFQATJ5s/wzvLA==
X-Received: by 2002:a05:600c:c2:b0:3f7:30c0:c6a with SMTP id u2-20020a05600c00c200b003f730c00c6amr433267wmm.25.1686295045075;
        Fri, 09 Jun 2023 00:17:25 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id k15-20020a7bc40f000000b003f7f1b3aff1sm1711774wmi.26.2023.06.09.00.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 00:17:24 -0700 (PDT)
Date: Fri, 9 Jun 2023 03:17:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230609031610-mutt-send-email-mst@kernel.org>
References: <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
 <20230608102259-mutt-send-email-mst@kernel.org>
 <CACGkMEvirfb8g0ev=b0CjpL5_SPJabqiQKxdwuRNqG2E=N7iGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvirfb8g0ev=b0CjpL5_SPJabqiQKxdwuRNqG2E=N7iGA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:16:50AM +0800, Jason Wang wrote:
> On Thu, Jun 8, 2023 at 10:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
> > > On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > >
> > > > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> > > > >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > > >>
> > > > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> > > > >>
> > > > >> [...]
> > > > >>
> > > > >> >> > > > > I have a question though, what if down the road there
> > > > >> >> > > > > is a new feature that needs more changes? It will be
> > > > >> >> > > > > broken too just like PACKED no?
> > > > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> > > > >> >> > > > > to support?
> > > > >> >> > > >
> > > > >> >> > > > It looks like we had it, but we took it out (by the way, we were
> > > > >> >> > > > enabling packed even though we didn't support it):
> > > > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > > > >> >> > > >
> > > > >> >> > > > The only problem I see is that for each new feature we have to modify
> > > > >> >> > > > the kernel.
> > > > >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
> > > > >> >> > > >
> > > > >> >> > > > Thanks,
> > > > >> >> > > > Stefano
> > > > >> >> > >
> > > > >> >> > > Jason what do you say to reverting this?
> > > > >> >> >
> > > > >> >> > I may miss something but I don't see any problem with vDPA core.
> > > > >> >> >
> > > > >> >> > It's the duty of the parents to advertise the features it has. For example,
> > > > >> >> >
> > > > >> >> > 1) If some kernel version that is packed is not supported via
> > > > >> >> > set_vq_state, parents should not advertise PACKED features in this
> > > > >> >> > case.
> > > > >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > > > >> >> > cvq doesn't support, parents should not advertise PACKED as well
> > > > >> >> >
> > > > >> >> > If a parent violates the above 2, it looks like a bug of the parents.
> > > > >> >> >
> > > > >> >> > Thanks
> > > > >> >>
> > > > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> > > > >> >
> > > > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> > > > >>
> > > > >> Sorry, I'm getting lost...
> > > > >> We were talking about the fact that vhost-vdpa doesn't handle
> > > > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> > > > >> that series [1], no?
> > > > >>
> > > > >> The parents seem okay, but maybe I missed a few things.
> > > > >>
> > > > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > >
> > > > >Yes, more below.
> > > > >
> > > > >>
> > > > >> >
> > > > >> >> Should that not have a whitelist of features
> > > > >> >> since it interprets ioctls differently depending on this?
> > > > >> >
> > > > >> >If there's a bug, it might only matter the following setup:
> > > > >> >
> > > > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> > > > >> >
> > > > >> >This seems to be broken since VDUSE was introduced. If we really want
> > > > >> >to backport something, it could be a fix to filter out PACKED in
> > > > >> >VDUSE?
> > > > >>
> > > > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> > > > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> > > > >> (I haven't tried), so why should we filter PACKED in VDUSE?
> > > > >
> > > > >I don't think we need any filtering since:
> > > > >
> > > > >PACKED features has been advertised to userspace via uAPI since
> > > > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> > > > >would be very hard to restrict it again. For the userspace that tries
> > > > >to negotiate PACKED:
> > > > >
> > > > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
> > > > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
> > > > >
> > > > >If we backport the fixes to -stable, we may break the application at
> > > > >least in the case 1).
> > > >
> > > > Okay, I see now, thanks for the details!
> > > >
> > > > Maybe instead of "break silently", we can return an explicit error for
> > > > SET_VRING_BASE/GET_VRING_BASE in stable branches.
> > > > But if there are not many cases, we can leave it like that.
> > >
> > > A second thought, if we need to do something for stable. is it better
> > > if we just backport Shannon's series to stable?
> > >
> > > >
> > > > I was just concerned about how does the user space understand that it
> > > > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
> > > > kernel or not.
> > >
> > > My understanding is that if packed is advertised, the application
> > > should assume SET/GET_VRING_BASE work.
> > >
> > > Thanks
> >
> >
> > Let me ask you this. This is a bugfix yes?
> 
> Not sure since it may break existing user space applications which
> make it hard to be backported to -stable.

Sorry, I was actually referring to 
    vhost_vdpa: support PACKED when setting-getting vring_base
and friends.

These are bugfixes yes?  What is the appropriate Fixes tag?


> Before the fix, PACKED might work if SET/GET_VRING_BASE is not used.
> After the fix, PACKED won't work at all.
> 
> Thanks
> 
> What is the appropriate Fixes
> > tag?
> >
> > > >
> > > > Thanks,
> > > > Stefano
> > > >
> >


