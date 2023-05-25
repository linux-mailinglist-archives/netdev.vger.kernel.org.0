Return-Path: <netdev+bounces-5311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 030FF710BCF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73C57281491
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C08FC16;
	Thu, 25 May 2023 12:12:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94111FC01
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:12:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926F2195
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685016716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6OnbKb556S3YIlVc0PJ91+BPkevG+Frsflk58JALYvs=;
	b=jSi97UAeRSNaxLoTTIVXpVoa469SzxpAT7HKjqXkzeu914mK/tO4aaRHJoEzxmTs0WdIfg
	CbQLKg+F46RAwP1ZLFTuJMBQ/DFii4biPkb7aH7NBswD+8tMw4BDWPJhTxHhZnnFZ21tQr
	sMgh5oCL2E9ieA/+TCEGq1hwnyqut9E=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-NUc5ggffPMqkLoIT_NjyXA-1; Thu, 25 May 2023 08:11:55 -0400
X-MC-Unique: NUc5ggffPMqkLoIT_NjyXA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f6b1853e80so2521521cf.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685016714; x=1687608714;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6OnbKb556S3YIlVc0PJ91+BPkevG+Frsflk58JALYvs=;
        b=UOKOnzhGcYGe6bVPHIJzjuFRkJcVsL7c1Jj7IUEHHWzwn0usjGGSH7RisIoU9yGXil
         TtBk9dnc57pYJUpIYpNpcbuBsgrKg08hJ3vAFcYi5EnawpR5x5kziqtJzrMhDEFuG9+M
         x0LRKMYxzWnQDt3EEvF5qp0triGmvsV1dzrGfLPV81pO6szGqTTguxJIMVGp2hR0bgSV
         IG/SNCekNnO/yI1o7v7TNudyZ/OZjWCw77ZCjTRU+vnLZoJpKLfagmRFHPd42ez9o5Ok
         aUVGcFq3utqvNDD4ibcw99AJ5UfvhCpBr5J63A7+p3+ekUc7ypH1HjF/7SojIdZ2/Tvo
         kh/Q==
X-Gm-Message-State: AC+VfDxZpjZyyj1yMtlY07E3b2yqWQuti3kU51f/Ou70fH4QKfSS36Eu
	+mixJQW1P4cJdppneFN32iaYSFRaiW86/4HWZGNtCeeQV40NTkpqbezcLV0HEgREfP0N9hwrl68
	MKezwEDT0H8lGxm9I
X-Received: by 2002:a05:622a:1447:b0:3ef:3dc3:4a3e with SMTP id v7-20020a05622a144700b003ef3dc34a3emr30368436qtx.0.1685016714695;
        Thu, 25 May 2023 05:11:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NWuDJ1FOzC01H+O67Hsp/M74SqLWaewUPjrJyP/7hEGu1k1nyHp/ny7KkbqMf3MtqjM10GQ==
X-Received: by 2002:a05:622a:1447:b0:3ef:3dc3:4a3e with SMTP id v7-20020a05622a144700b003ef3dc34a3emr30368407qtx.0.1685016714403;
        Thu, 25 May 2023 05:11:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id h12-20020ac8138c000000b003f0a79e6a8bsm348511qtj.28.2023.05.25.05.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 05:11:54 -0700 (PDT)
Message-ID: <1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
From: Paolo Abeni <pabeni@redhat.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jacob Keller
	 <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	 <tariqt@nvidia.com>, Saeed Mahameed <saeed@kernel.org>, Richard Cochran
	 <richardcochran@gmail.com>, Vincent Cheng <vincent.cheng.xh@renesas.com>
Date: Thu, 25 May 2023 14:11:51 +0200
In-Reply-To: <3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	 <20230523205440.326934-8-rrameshbabu@nvidia.com>
	 <3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
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

On Thu, 2023-05-25 at 14:08 +0200, Paolo Abeni wrote:
> On Tue, 2023-05-23 at 13:54 -0700, Rahul Rameshbabu wrote:
> > Advertise the maximum offset the .adjphase callback is capable of
> > supporting in nanoseconds for IDT ClockMatrix devices.
> >=20
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
> > Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> > ---
> >  drivers/ptp/ptp_clockmatrix.c | 36 +++++++++++++++++------------------
> >  drivers/ptp/ptp_clockmatrix.h |  2 +-
> >  2 files changed, 18 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatri=
x.c
> > index c9d451bf89e2..f6f9d4adce04 100644
> > --- a/drivers/ptp/ptp_clockmatrix.c
> > +++ b/drivers/ptp/ptp_clockmatrix.c
> > @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(struct=
 idtcm_channel *channel)
> >  /* PTP Hardware Clock interface */
> > =20
> >  /*
> > - * Maximum absolute value for write phase offset in picoseconds
> > - *
> > - * @channel:  channel
> > - * @delta_ns: delta in nanoseconds
> > + * Maximum absolute value for write phase offset in nanoseconds
> >   *
> >   * Destination signed register is 32-bit register in resolution of 50p=
s
> >   *
> > - * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350
> > + * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350 ps
> > + * Represent 107374182350 ps as 107374182 ns
> > + */
> > +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_unuse=
d)
> > +{
> > +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
> > +}
>=20
> This introduces a functional change WRT the current code. Prior to this
> patch ClockMatrix tries to adjust phase delta even above
> MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
> After this patch it will error out.
>=20
> Perhaps a more conservative approach would be keeping the existing
> logic in _idtcm_adjphase and let idtcm_getmaxphase return =20
> S32_MAX?
>=20
> Note that even that will error out for delta =3D=3D S32_MIN so perhaps an
> API change to allow the driver specify unlimited delta would be useful
> (possibly regardless of the above).

What about allowing drivers with no getmaxphase() callback, meaning
such drivers allow adjusting unlimited phase delta?=20

Thanks!

Paolo


