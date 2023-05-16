Return-Path: <netdev+bounces-2936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F294704A4A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D981C20DB4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA6C1952D;
	Tue, 16 May 2023 10:17:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0632C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:17:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB881A5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684232223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqxJLzKeVgDfxW/O/MlRjFX8Z/NjSTCk+joJBpoORLc=;
	b=FbmyGhPZlgtwKuIlVC/1iq97Jo2vWxWXDG482mLxW+KG3nNkEImUKxXEr6oaEDUrViop/Q
	b7q0otI4bbyTpmjlGG9yuM28IQcP9buzPOGINAE9CLsE0TZPSQ5jras4uGLgqLbd6tyGyY
	R2Z6GX17EoHUIW2cSuct4Q0Ay3HAycc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232--xnYMgL-PN679lCnopGWdA-1; Tue, 16 May 2023 06:17:02 -0400
X-MC-Unique: -xnYMgL-PN679lCnopGWdA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7576864caf7so95715185a.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684232220; x=1686824220;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IqxJLzKeVgDfxW/O/MlRjFX8Z/NjSTCk+joJBpoORLc=;
        b=U7mGrJ5mgT4qjr2BMktFuAumyHk4jm4mLpyPAfCptvI+cJ1Z96oOBOKJkF0llprYPe
         IvI1s9BDC+KZ4s8UQarHkclZ5DvfN4SDDn73tfeyG26c5eRTlyyKXKTv/34uQ5Av7mKZ
         Hk6kkYejchUiCGcCN17QPEpmUPNoiTHMMRUq2F9FtE0fY7zMzI/vt2gEJPEH9jT3qX/U
         i/nxTHsIHUZCEZ4BXkKXDkckwM1TkjxarvXURx21J92PCgxG63gTx/f5EIxxYR+khj9A
         DX1LFC8eC0Uek04YqRPKjkeJK7U2Vz+cuB0GiLI80soviLn66caNoT0VFR2fFNIwZTiH
         Nr3Q==
X-Gm-Message-State: AC+VfDwXLHZ4P6MEpQJHf/Vtc+yoVQZb70zs6USSLPaG5A83qCf/Su1D
	DoPLqcf+VuoD8jMyZ2IGKCn8JQimsBAfW1pUcYWUZusBe8kFCTqAp9VDSjw+cblE7Bgp2/fdQe7
	7Ttgqs/aLhBVRkIPMwCTiRTp0
X-Received: by 2002:a05:622a:181d:b0:3f4:41e:efc1 with SMTP id t29-20020a05622a181d00b003f4041eefc1mr3580981qtc.6.1684232220078;
        Tue, 16 May 2023 03:17:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4K2qE7uO1UpFVDo8UVr7XT300zEIfy0Rr215JWw4Uy6WobtXF0QeP+HsLc+ZLoWJQq3kX4fg==
X-Received: by 2002:a05:622a:181d:b0:3f4:41e:efc1 with SMTP id t29-20020a05622a181d00b003f4041eefc1mr3580949qtc.6.1684232219729;
        Tue, 16 May 2023 03:16:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id e29-20020ac8011d000000b003d7e923736asm6113525qtg.6.2023.05.16.03.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 03:16:59 -0700 (PDT)
Message-ID: <9fc12fe1b3a6bd5c65d9c885bc39920e89437a61.camel@redhat.com>
Subject: Re: Performance regression on lan966x when extracting frames
From: Paolo Abeni <pabeni@redhat.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>, Eric Dumazet
	 <edumazet@google.com>
Cc: netdev@vger.kernel.org
Date: Tue, 16 May 2023 12:16:56 +0200
In-Reply-To: <20230516092714.wresm662w54zs226@soft-dev3-1>
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
	 <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
	 <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1>
	 <CANn89i+QT3nfE-nN9b6eeyMBp93CVHZYteuH6N9ErKYqF8PA=A@mail.gmail.com>
	 <20230516092714.wresm662w54zs226@soft-dev3-1>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-16 at 11:27 +0200, Horatiu Vultur wrote:
> The 05/16/2023 10:04, Eric Dumazet wrote:
> >=20
> > On Tue, May 16, 2023 at 9:45=E2=80=AFAM Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
> > >=20
> > > The 05/15/2023 14:30, Eric Dumazet wrote:
> > > >=20
> > > > On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
> > > > <horatiu.vultur@microchip.com> wrote:
> > >=20
> > > Hi Eric,
> > >=20
> > > Thanks for looking at this.
> > >=20
> > > > >=20
> > > > > Hi,
> > > > >=20
> > > > > I have noticed that on the HEAD of net-next[0] there is a perform=
ance drop
> > > > > for lan966x when extracting frames towards the CPU. Lan966x has a=
 Cortex
> > > > > A7 CPU. All the tests are done using iperf3 command like this:
> > > > > 'iperf3 -c 10.97.10.1 -R'
> > > > >=20
> > > > > So on net-next, I can see the following:
> > > > > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
> > > > > And it gets around ~97000 interrupts.
> > > > >=20
> > > > > While going back to the commit[1], I can see the following:
> > > > > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
> > > > > And it gets around ~1000 interrupts.
> > > > >=20
> > > > > I have done a little bit of searching and I have noticed that thi=
s
> > > > > commit [2] introduce the regression.
> > > > > I have tried to revert this commit on net-next and tried again, t=
hen I
> > > > > can see much better results but not exactly the same:
> > > > > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
> > > > > And it gets around ~700 interrupts.
> > > > >=20
> > > > > So my question is, was I supposed to change something in lan966x =
driver?
> > > > > or is there a bug in lan966x driver that pop up because of this c=
hange?
> > > > >=20
> > > > > Any advice will be great. Thanks!
> > > > >=20
> > > > > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_recor=
d_encap_match()")
> > > > > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > > > > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid ext=
ra NET_RX_SOFTIRQ")
> > > > >=20
> > > > >=20
> > > >=20
> > > > Hmmm... thanks for the report.
> > > >=20
> > > > This seems related to softirq (k)scheduling.
> > > >=20
> > > > Have you tried to apply this recent commit ?
> > > >=20
> > > > Commit-ID:     d15121be7485655129101f3960ae6add40204463
> > > > Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f396=
0ae6add40204463
> > > > Author:        Paolo Abeni <pabeni@redhat.com>
> > > > AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> > > > Committer:     Thomas Gleixner <tglx@linutronix.de>
> > > > CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> > > >=20
> > > > Revert "softirq: Let ksoftirqd do its job"
> > >=20
> > > I have tried to apply this patch but the results are the same:
> > > [  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
> > > And it gets just a little bit bigger number of interrupts ~11000
> > >=20
> > > >=20
> > > >=20
> > > > Alternative would be to try this :
> > > >=20
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0e605=
178715f90bae17b86f071
> > > > 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -6713,8 +6713,8 @@ static __latent_entropy void
> > > > net_rx_action(struct softirq_action *h)
> > > >         list_splice(&list, &sd->poll_list);
> > > >         if (!list_empty(&sd->poll_list))
> > > >                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > > > -       else
> > > > -               sd->in_net_rx_action =3D false;
> > > > +
> > > > +       sd->in_net_rx_action =3D false;
> > > >=20
> > > >         net_rps_action_and_irq_enable(sd);
> > > >  end:;
> > >=20
> > > I have tried to use also this change with and without the previous pa=
tch
> > > but the result is the same:
> > > [  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
> > > And it is the same number of interrupts.
> > >=20
> > > Is something else that I should try?
> >=20
> > High number of interrupts for a saturated receiver seems wrong.
> > (Unless it is not saturating the cpu ?)
>=20
> The CPU usage seems to be almost at 100%. This is the output of top
> command:
> 149   132 root     R     5032   0%  96% iperf3 -c 10.97.10.1 -R
>  12     2 root     SW       0   0%   3% [ksoftirqd/0]
> 150   132 root     R     2652   0%   1% top
> ...

Sorry for the dumb question, is the above with fdma =3D=3D false? (that is,
no napi?) Why can't lan966x_xtr_irq_handler() be converted to the napi
model regardless of fdma ?!?

Thanks,

Paolo


