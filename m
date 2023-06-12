Return-Path: <netdev+bounces-10138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C67B72C81F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E457728115C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EF81B8FC;
	Mon, 12 Jun 2023 14:22:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776BC19E79
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:22:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD272127
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686579699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mXsF/zv+kh/vYHv24go2gI5Kc5kXKPUUHOcPEgPZb+w=;
	b=FinN6CuPW57iXDH68YlwB8b9CILL7pII30i0FnREf512Jx+Lqt2xSSYqNoN1DF+86lsKhR
	mx/eNY660Z17EYEq6t3OVD/tIvv083luNzJn2fg3Qg0Q16TLCv5vTeUlAO5EgHliFDTK6N
	Y37ozsUmgnXoqe8oti8u6WSCtueYaVA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-uAiQXGqqPWu8WQhqNaI9qQ-1; Mon, 12 Jun 2023 10:15:32 -0400
X-MC-Unique: uAiQXGqqPWu8WQhqNaI9qQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7f3333b2bso6672895e9.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686579331; x=1689171331;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mXsF/zv+kh/vYHv24go2gI5Kc5kXKPUUHOcPEgPZb+w=;
        b=aZCU0o8h2TwcgBR7g2lTZGJ70C7rNuNRM4D7APV7NihmrblNq6E89Yp4CieRYbcwWx
         KAp8uBR25zWdyn9VgmGQpm3OVx0Sy0Ds2yS3yCUS5S7+JW2uhJFaEUll1dD/l6GYRRQP
         Zkf5/tb3KqXWUmjRC4RWoYnTRHifFq1MqOhi+D3hi+7RcUkAiEIgQ+euRnjRAU2lyf+0
         dKgrD6Wiim0d7SMOml51DELvUzQJG9xOqJAAMro6qct/kzfNzvu/lwPVDXkkjgOK5pnr
         CcoljEWlAWl1SB8T7ZzHl83BlwloNvwfXkgtnznB/smFyZfrcH6hXVE950YEWG7Uh26C
         1DtA==
X-Gm-Message-State: AC+VfDwhPts1FWH3+yFHJH3JwBiTzizkvXYrSnd9QwM5n0i8sG6MmN/n
	ALLsh/0+cJK+TkCntpN8SvxnVelgx3KAZpaUFY165JOIa1283mIQUZtSw619DTB+bwpIz+Z/TfV
	jhFm79yZlIXKXBjLK
X-Received: by 2002:a05:600c:3501:b0:3f5:f543:d81f with SMTP id h1-20020a05600c350100b003f5f543d81fmr7662297wmq.3.1686579331401;
        Mon, 12 Jun 2023 07:15:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7twnSes+MFOJDhF/O6V/wqwUw7rgA4+5895AcNk2iGdUurJp8deDyMmRW/z7LJ5u4Gd5MMrQ==
X-Received: by 2002:a05:600c:3501:b0:3f5:f543:d81f with SMTP id h1-20020a05600c350100b003f5f543d81fmr7662269wmq.3.1686579330975;
        Mon, 12 Jun 2023 07:15:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-250-244.dyn.eolo.it. [146.241.250.244])
        by smtp.gmail.com with ESMTPSA id i1-20020adfefc1000000b0030647449730sm12756866wrp.74.2023.06.12.07.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 07:15:30 -0700 (PDT)
Message-ID: <13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
From: Paolo Abeni <pabeni@redhat.com>
To: "Keller, Jacob E" <jacob.e.keller@intel.com>, Rahul Rameshbabu
	 <rrameshbabu@nvidia.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller"
	 <davem@davemloft.net>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	 <tariqt@nvidia.com>, Saeed Mahameed <saeed@kernel.org>, Richard Cochran
	 <richardcochran@gmail.com>, Vincent Cheng <vincent.cheng.xh@renesas.com>
Date: Mon, 12 Jun 2023 16:15:29 +0200
In-Reply-To: <CO1PR11MB5089C523373812F3AE708A3FD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	 <20230523205440.326934-8-rrameshbabu@nvidia.com>
	 <3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	 <1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	 <87r0r4l1v6.fsf@nvidia.com>
	 <3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
	 <87fs70wh7n.fsf@nvidia.com>
	 <CO1PR11MB5089C523373812F3AE708A3FD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
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

On Mon, 2023-06-12 at 05:16 +0000, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> > Sent: Friday, June 9, 2023 12:48 PM
> > To: Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org; David S. Miller <davem@davemloft.net>; Kell=
er,
> > Jacob E <jacob.e.keller@intel.com>; Gal Pressman <gal@nvidia.com>; Tari=
q
> > Toukan <tariqt@nvidia.com>; Saeed Mahameed <saeed@kernel.org>; Richard
> > Cochran <richardcochran@gmail.com>; Vincent Cheng
> > <vincent.cheng.xh@renesas.com>
> > Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxp=
hase
> > ptp_clock_info callback
> >=20
> > On Fri, 09 Jun, 2023 08:38:11 +0200 Paolo Abeni <pabeni@redhat.com> wro=
te:
> > > On Thu, 2023-05-25 at 11:09 -0700, Rahul Rameshbabu wrote:
> > > > On Thu, 25 May, 2023 14:11:51 +0200 Paolo Abeni <pabeni@redhat.com>=
 wrote:
> > > >=20
> > >=20
> > > I guess the user-space could pass such large delta (e.g. at boot
> > > time?!?). If so, with this patch we change an user-space observable
> > > behavior, and I think we should avoid that.
> >=20
> > The point that you bring up here is about clamping (which is done by
> > idtcm_adjphase previously) versus throwing an error when out of range
> > (what is now done in ptp_clock_adjtime in this patch series). This was
> > something I was struggling with deciding on a unified behavior across
> > all drivers. For example, the mlx5_core driver chooses to return -ERANG=
E
> > when the delta landed on it is out of the range supported by the PHC of
> > the device. We chose to return an error because there was no mechanism
> > previously for the userspace to know what was the supported offset when
> > using ADJ_OFFSET with different PHC devices. If a user provides an
> > offset and no error is returned, the user would assume that offset had
> > been applied (there was no way to know that it was clamped from the
> > userspace). This patch series now adds the query for maximum supported
> > offset in the PTP_CLOCK_GETCAPS ioctl. In my opinion, I think we will
> > see an userspace observable behavior change either way unfortunately du=
e
> > to the inconsistency among device drivers, which was one of the main
> > issues this patch submission targets. I am ok with making the common
> > behavior in ptp_clock_adjtime clamp the provided offset value instead o=
f
> > throwing an error when out of range. In both cases, userspace programs
> > can handle the out-of-range case explicitly with a check against the
> > maximum offset value now advertised in PTP_CLOCK_GETCAPS. My personal
> > opinion is that since we have this inconsistency among device drivers
> > for handling out of range offsets that are currently provided as-is to
> > the driver-specific callback implementations, it makes sense to converg=
e
> > to a version that returns an error when the userspace provides
> > out-of-range values rather than silently clamping these values. However=
,
> > I am open to either version as long as we have consistency and do not
> > leave this up to individual device-drivers to dictate since this adds
> > further complexity in the userspace when working with this syscall.
>=20
> I'm in favor of throwing an error, since userspace that *doesn't*
> check for the max value and assumes it will apply without a clamp may
> be surprised when it starts clamping. Userspace which previously
> supplied a large value and it clamps now gets an error, which might
> be concerning, but they got driver defined behavior before, where it
> might error or it might clamp, so I think we're in a no-win scenario
> there.
>=20
> I don't really see the value in clamping because that makes it hard
> to tell if an update was fully applied or not. Now software has to
> know to check the range in advance. I wouldn't view a partially
> applied update as a successful behavior in a timing application.
> Thus, on the principle of least surprise I would avoid clamping. I'm
> open to other opinions, and I think standardizing is much better than
> letting it be driver behavior.

Given that this is general agreement on throwing an error, I'll be ok
with that. Perhaps mention the behaviour change in the commit message?

Thanks!

Paolo


