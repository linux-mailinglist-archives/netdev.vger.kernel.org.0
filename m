Return-Path: <netdev+bounces-5310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0473D710BB9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 717561C20E8F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4DAFC13;
	Thu, 25 May 2023 12:08:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD9EDF52
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:08:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346D59C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685016529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRdaiz7BgX4nrDo0xACeN/AVj5qlfy4qMp2Za8aRgOc=;
	b=avSIX+znsVbdFD1fKgWPdYO7fEN1XcmFku22qO2FeRHgS6GEIXW6hbLign2F80nTMJM0Gx
	bOLSX1I/1Fzd5f7slOgmEpZqhmGijvjuRCJXsU13+wtxuwVWElc/XsA1cZdvU6hawJJHKr
	fJqFsCdVlkGLtUhXY5NwyjiD6HX39ds=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-uKj3_XYtNKG3x9RvDcM9Vg-1; Thu, 25 May 2023 08:08:48 -0400
X-MC-Unique: uKj3_XYtNKG3x9RvDcM9Vg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-623a54565e6so3713606d6.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685016527; x=1687608527;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iRdaiz7BgX4nrDo0xACeN/AVj5qlfy4qMp2Za8aRgOc=;
        b=kewhwa44ywUOTErY5UIPMBPrlLbUDDXf+tKOFioNJgK8dBZrjQIj802wV7MYTjnRky
         f/N/JJMurvXobaALYGbqwARf6ONpca5HN2GtTvAcn8aX4lOj3WcFcJMpnHt11CR0MJc9
         nFWeCMiIRICz0VM3qZUndLbmNUW3lVg1YARFULgnnxkjqGJRP43Vdi3ZYts2HQgxFdR1
         iChXZSNQlPOt2IMubiDeWURP10qqlXgpW1IcgA9jqz0lDgCJfpz0RLUVnpoosnnMt2Nk
         fgt58Mm8yppPssx8i8jbncGdYfb4g9tCTKrXpu9WpLq5JPBDJ+4M6fj/zpjTaXBye0v3
         pXdQ==
X-Gm-Message-State: AC+VfDzaMeGUripX0+aC+bKIU4BvEKT/4i7LqO7n8fdiqQmusucf1UkC
	04mfejIswgMzcdMYLW8pj6WZ/HdbLFja3VG6TytWyu8ERuyfnKs7twvuffNfxAzg2bAqmNBsJeU
	MzBg4P1GcdMd1evsO
X-Received: by 2002:a05:620a:9494:b0:75b:23a1:82a3 with SMTP id sn20-20020a05620a949400b0075b23a182a3mr4670276qkn.4.1685016527563;
        Thu, 25 May 2023 05:08:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7/iP7qlAaoPU1m/nwwD8C27ed9pV+utSGetYTAuxjbAj0cxbzQWUy8gdPDSZYDFLBUZQaQmw==
X-Received: by 2002:a05:620a:9494:b0:75b:23a1:82a3 with SMTP id sn20-20020a05620a949400b0075b23a182a3mr4670258qkn.4.1685016527236;
        Thu, 25 May 2023 05:08:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id x20-20020a05620a01f400b007591e82a673sm320118qkn.131.2023.05.25.05.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 05:08:46 -0700 (PDT)
Message-ID: <3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
From: Paolo Abeni <pabeni@redhat.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jacob Keller
	 <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	 <tariqt@nvidia.com>, Saeed Mahameed <saeed@kernel.org>, Richard Cochran
	 <richardcochran@gmail.com>, Vincent Cheng <vincent.cheng.xh@renesas.com>
Date: Thu, 25 May 2023 14:08:43 +0200
In-Reply-To: <20230523205440.326934-8-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	 <20230523205440.326934-8-rrameshbabu@nvidia.com>
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

On Tue, 2023-05-23 at 13:54 -0700, Rahul Rameshbabu wrote:
> Advertise the maximum offset the .adjphase callback is capable of
> supporting in nanoseconds for IDT ClockMatrix devices.
>=20
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 36 +++++++++++++++++------------------
>  drivers/ptp/ptp_clockmatrix.h |  2 +-
>  2 files changed, 18 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.=
c
> index c9d451bf89e2..f6f9d4adce04 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(struct i=
dtcm_channel *channel)
>  /* PTP Hardware Clock interface */
> =20
>  /*
> - * Maximum absolute value for write phase offset in picoseconds
> - *
> - * @channel:  channel
> - * @delta_ns: delta in nanoseconds
> + * Maximum absolute value for write phase offset in nanoseconds
>   *
>   * Destination signed register is 32-bit register in resolution of 50ps
>   *
> - * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350
> + * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350 ps
> + * Represent 107374182350 ps as 107374182 ns
> + */
> +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_unused)
> +{
> +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
> +}

This introduces a functional change WRT the current code. Prior to this
patch ClockMatrix tries to adjust phase delta even above
MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
After this patch it will error out.

Perhaps a more conservative approach would be keeping the existing
logic in _idtcm_adjphase and let idtcm_getmaxphase return =20
S32_MAX?

Note that even that will error out for delta =3D=3D S32_MIN so perhaps an
API change to allow the driver specify unlimited delta would be useful
(possibly regardless of the above).

Cheers,

Paolo


