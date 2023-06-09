Return-Path: <netdev+bounces-9437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B162972901B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF4E6281866
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 06:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD851866;
	Fri,  9 Jun 2023 06:38:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF17E185A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:38:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DCBE46
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686292705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I2nflsVh64afjMM2yppXccKKLmfabW2Q5XeEAVIOfFI=;
	b=aF59+UpB1DGuFroxPdnSQvHhCQohz2U8FthIJPh8j9U+y8aTHuNdFxKaZXJ7ZW1/qVTy66
	KcbY3+fklFtOeacN5qCtmMe9QCXPuUQZVsF5fR6FpDQY4vxTjruWAeYNfn9skiOzWFnpz+
	ZIKi/cK5lk3pJT3Ta3CUqtc2Hz81E/o=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-5fQTQvryMEeb-dFemyisnQ-1; Fri, 09 Jun 2023 02:38:21 -0400
X-MC-Unique: 5fQTQvryMEeb-dFemyisnQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75eb82ada06so33591785a.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 23:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686292700; x=1688884700;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2nflsVh64afjMM2yppXccKKLmfabW2Q5XeEAVIOfFI=;
        b=b85A8IaljwNDLymuIlAiVJ/FHgHlO4CFD4SsNaxvbIaO9IBoxygbnFMSC6iCS/pxAm
         hErBnV4XrSv1oBIW3v+9aQbT7/XAk2asSF/wJCSBNddb9XXN2PwRi5Tu04O/imzk9TRU
         LTjFPnopmIS+Q6OhEueTYwG10MqRlOIY/WAv/OuC5dq/DsP84k3cbupCZmYX1mujkPAm
         8CDYwczx9iEKM4ndu6ZHD5E+QEMzScfeoXn2CecA/meODKlCE25TTgOwu50D3VjNi57O
         HRiIG7ra4RUlDSERhZmivQWmPiriffhSCsTsiFJRnoiZJGl/U/tol5s7Dmm3JzOwv8/o
         FLvg==
X-Gm-Message-State: AC+VfDzHV3T8EcCAblOZiZGp7YuKtGcToMsmMIfXoK0dQjwc9qUM+rsj
	jl9GjyIErOTdrpLqNHN3j0Ze6qYqy01QpfRAxfDHcdOwqhmmasaxWmtO3BZxwhWi6WfYEun6xyB
	30w4ul8ldxA6FDqA4
X-Received: by 2002:a05:620a:628a:b0:75d:5357:78a0 with SMTP id ov10-20020a05620a628a00b0075d535778a0mr274491qkn.6.1686292700593;
        Thu, 08 Jun 2023 23:38:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kGhpigUCro4cCJDXKL6w+HPzJ1YQcg5AcwCRz+yQJ6hLkTt0Fl2BbB0yiX1EoVLWU3YflOQ==
X-Received: by 2002:a05:620a:628a:b0:75d:5357:78a0 with SMTP id ov10-20020a05620a628a00b0075d535778a0mr274482qkn.6.1686292700329;
        Thu, 08 Jun 2023 23:38:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-250-244.dyn.eolo.it. [146.241.250.244])
        by smtp.gmail.com with ESMTPSA id y1-20020a37e301000000b00759495bb52fsm849483qki.39.2023.06.08.23.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 23:38:20 -0700 (PDT)
Message-ID: <3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
From: Paolo Abeni <pabeni@redhat.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jacob
 Keller <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>, Tariq
 Toukan <tariqt@nvidia.com>,  Saeed Mahameed <saeed@kernel.org>, Richard
 Cochran <richardcochran@gmail.com>, Vincent Cheng
 <vincent.cheng.xh@renesas.com>
Date: Fri, 09 Jun 2023 08:38:11 +0200
In-Reply-To: <87r0r4l1v6.fsf@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	 <20230523205440.326934-8-rrameshbabu@nvidia.com>
	 <3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	 <1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	 <87r0r4l1v6.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I'm sorry for the late reply. This fell under my radar.

On Thu, 2023-05-25 at 11:09 -0700, Rahul Rameshbabu wrote:
> On Thu, 25 May, 2023 14:11:51 +0200 Paolo Abeni <pabeni@redhat.com> wrote=
:
> > On Thu, 2023-05-25 at 14:08 +0200, Paolo Abeni wrote:
> > > > diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockm=
atrix.c
> > > > index c9d451bf89e2..f6f9d4adce04 100644
> > > > --- a/drivers/ptp/ptp_clockmatrix.c
> > > > +++ b/drivers/ptp/ptp_clockmatrix.c
> > > > @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(st=
ruct idtcm_channel *channel)
> > > >  /* PTP Hardware Clock interface */
> > > > =20
> > > >  /*
> > > > - * Maximum absolute value for write phase offset in picoseconds
> > > > - *
> > > > - * @channel:  channel
> > > > - * @delta_ns: delta in nanoseconds
> > > > + * Maximum absolute value for write phase offset in nanoseconds
> > > >   *
> > > >   * Destination signed register is 32-bit register in resolution of=
 50ps
> > > >   *
> > > > - * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350
> > > > + * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350 ps
> > > > + * Represent 107374182350 ps as 107374182 ns
> > > > + */
> > > > +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_u=
nused)
> > > > +{
> > > > +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
> > > > +}
> > >=20
> > > This introduces a functional change WRT the current code. Prior to th=
is
> > > patch ClockMatrix tries to adjust phase delta even above
> > > MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
> > > After this patch it will error out.
>=20
> My understanding is the syscall for adjphase, clock_adjtime, cannot
> represent an offset granularity smaller than nanoseconds using the
> struct timex offset member.=C2=A0

Ok.

> To me, it seems that adjusting a delta above
> MAX_ABS_WRITE_PHASE_NANOSECONDS (due to support for higher precision
> units by the device), while supported by the device driver, would not be
> a capability utilized by any interface that would invoke the .adjphase
> callback implemented by ClockMatrix.

Here I don't follow. I must admit I know the ptp subsystem very little,
but AFAICS, we could have e.g.

clock_adjtime() // offset > 200 secs (200000000 usec)
 -> do_clock_adjtime
    -> kc->clock_adj
       -> clock_posix_dynamic
          -> pc_clock_adjtime
             -> ptp_clock_adjtime
                -> _idtcm_adjphase // delta land unmodified up here

I guess the user-space could pass such large delta (e.g. at boot
time?!?). If so, with this patch we change an user-space observable
behavior, and I think we should avoid that.

Thanks

Paolo


