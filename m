Return-Path: <netdev+bounces-3020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AF27050D5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EFA31C20EBE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F0D2770B;
	Tue, 16 May 2023 14:33:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1CE34CD5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:33:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3840195
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684247578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4I+210dG+khaJaCz40jbUqtcRUNhOL7vYydtKp3oCE8=;
	b=I7SIhp6xHFqQSPii7I9LsE0RgtTRznp5fdDlEFThpSnB+Fpqq3ia3CgdipDZACaEIn1p4p
	cvnc7F5d8xQZIx09v9p7wmsSbwrGPIH70VXO7i92YiogKkucXXBAkHTi8slH3r+pbIklRd
	ra47EIhMqo1I/aE1eCiz6ct6fEa+bds=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-5tHw6B0SOsGSfzlwNpXNDg-1; Tue, 16 May 2023 10:32:56 -0400
X-MC-Unique: 5tHw6B0SOsGSfzlwNpXNDg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f46d5ef776so10192985e9.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247575; x=1686839575;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4I+210dG+khaJaCz40jbUqtcRUNhOL7vYydtKp3oCE8=;
        b=ZVRSIjsZ0p/yeaUtZBYvPSrbBJqvMxLIBdlTcUTo3znBpBUmf+iV0xvIDqTbly9av8
         kxGx4m3/Z2ZeIWxeYfc/Xu7Nbn10yV5Vfm9ItjkwWoFkrYT1Jw6iA2pyRvsLxAu3qt4v
         IzBLcr5Qd4qo79txO+OBxeYjeiQH2uA8yf7mUvUtHIEopp5Bba/1DoRDqu9iJ8Tgfwi/
         Mfz5VrBATWUTfnNOGLjpVdamx2G+YURog9rdi4TmEUOLxyNqQXaQFuE7G9+igBAfguZe
         BcfsOswd5BZJvBd5A18UUR0QYEPYj+NqhgZg5KT4JpWuzhZWnLyi7d08Vw81NbTEx1/B
         TCgg==
X-Gm-Message-State: AC+VfDwcMlgcpZtYWdnn4i9TPUJknboxke+bvK4NgrZa0CGDQeDADpKO
	SLtSvyrILEpF0aIzokRQtyiiWIfWWuyGNVb6sVjjnUmXJK6CSmbeDdFX/f28/XbGGZREV8v2JDE
	UBDjqfMwi5g4AwBS2HuEoYKwS
X-Received: by 2002:adf:e9d2:0:b0:306:343c:c409 with SMTP id l18-20020adfe9d2000000b00306343cc409mr6854308wrn.0.1684247574914;
        Tue, 16 May 2023 07:32:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5HYUlJ/sWHZO9BKZYM4mtJJpa52H0gfnW2OHThPGrjigFf+4nrvcKvDDdipyn9hXQposTCXA==
X-Received: by 2002:adf:e9d2:0:b0:306:343c:c409 with SMTP id l18-20020adfe9d2000000b00306343cc409mr6854297wrn.0.1684247574557;
        Tue, 16 May 2023 07:32:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id a15-20020adfeecf000000b003093946ea60sm1459889wrp.46.2023.05.16.07.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 07:32:54 -0700 (PDT)
Message-ID: <877419667aa827cc5843f7ae22658686af22515f.camel@redhat.com>
Subject: Re: Performance regression on lan966x when extracting frames
From: Paolo Abeni <pabeni@redhat.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Date: Tue, 16 May 2023 16:32:52 +0200
In-Reply-To: <20230516141152.zqac5siwmxrxusme@soft-dev3-1>
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
	 <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
	 <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1>
	 <CANn89i+QT3nfE-nN9b6eeyMBp93CVHZYteuH6N9ErKYqF8PA=A@mail.gmail.com>
	 <20230516092714.wresm662w54zs226@soft-dev3-1>
	 <9fc12fe1b3a6bd5c65d9c885bc39920e89437a61.camel@redhat.com>
	 <20230516141152.zqac5siwmxrxusme@soft-dev3-1>
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

On Tue, 2023-05-16 at 16:11 +0200, Horatiu Vultur wrote:
> The 05/16/2023 12:16, Paolo Abeni wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know =
the content is safe
> >=20
> > On Tue, 2023-05-16 at 11:27 +0200, Horatiu Vultur wrote:
> > > The 05/16/2023 10:04, Eric Dumazet wrote:
> > > >=20
> > > > On Tue, May 16, 2023 at 9:45=E2=80=AFAM Horatiu Vultur
> > > > <horatiu.vultur@microchip.com> wrote:
> > > > >=20
> > > > > The 05/15/2023 14:30, Eric Dumazet wrote:
> > > > > >=20
> > > > > > On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
> > > > > > <horatiu.vultur@microchip.com> wrote:
> > > > >=20
> > > > > Hi Eric,
> > > > >=20
> > > > > Thanks for looking at this.
> > > > >=20
> > > > > > >=20
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > I have noticed that on the HEAD of net-next[0] there is a per=
formance drop
> > > > > > > for lan966x when extracting frames towards the CPU. Lan966x h=
as a Cortex
> > > > > > > A7 CPU. All the tests are done using iperf3 command like this=
:
> > > > > > > 'iperf3 -c 10.97.10.1 -R'
> > > > > > >=20
> > > > > > > So on net-next, I can see the following:
> > > > > > > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sen=
der
> > > > > > > And it gets around ~97000 interrupts.
> > > > > > >=20
> > > > > > > While going back to the commit[1], I can see the following:
> > > > > > > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sen=
der
> > > > > > > And it gets around ~1000 interrupts.
> > > > > > >=20
> > > > > > > I have done a little bit of searching and I have noticed that=
 this
> > > > > > > commit [2] introduce the regression.
> > > > > > > I have tried to revert this commit on net-next and tried agai=
n, then I
> > > > > > > can see much better results but not exactly the same:
> > > > > > > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sen=
der
> > > > > > > And it gets around ~700 interrupts.
> > > > > > >=20
> > > > > > > So my question is, was I supposed to change something in lan9=
66x driver?
> > > > > > > or is there a bug in lan966x driver that pop up because of th=
is change?
> > > > > > >=20
> > > > > > > Any advice will be great. Thanks!
> > > > > > >=20
> > > > > > > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_r=
ecord_encap_match()")
> > > > > > > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > > > > > > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid=
 extra NET_RX_SOFTIRQ")
> > > > > > >=20
> > > > > > >=20
> > > > > >=20
> > > > > > Hmmm... thanks for the report.
> > > > > >=20
> > > > > > This seems related to softirq (k)scheduling.
> > > > > >=20
> > > > > > Have you tried to apply this recent commit ?
> > > > > >=20
> > > > > > Commit-ID:     d15121be7485655129101f3960ae6add40204463
> > > > > > Gitweb:        https://git.kernel.org/tip/d15121be7485655129101=
f3960ae6add40204463
> > > > > > Author:        Paolo Abeni <pabeni@redhat.com>
> > > > > > AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> > > > > > Committer:     Thomas Gleixner <tglx@linutronix.de>
> > > > > > CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> > > > > >=20
> > > > > > Revert "softirq: Let ksoftirqd do its job"
> > > > >=20
> > > > > I have tried to apply this patch but the results are the same:
> > > > > [  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
> > > > > And it gets just a little bit bigger number of interrupts ~11000
> > > > >=20
> > > > > >=20
> > > > > >=20
> > > > > > Alternative would be to try this :
> > > > > >=20
> > > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > > index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0=
e605178715f90bae17b86f071
> > > > > > 100644
> > > > > > --- a/net/core/dev.c
> > > > > > +++ b/net/core/dev.c
> > > > > > @@ -6713,8 +6713,8 @@ static __latent_entropy void
> > > > > > net_rx_action(struct softirq_action *h)
> > > > > >         list_splice(&list, &sd->poll_list);
> > > > > >         if (!list_empty(&sd->poll_list))
> > > > > >                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > > > > > -       else
> > > > > > -               sd->in_net_rx_action =3D false;
> > > > > > +
> > > > > > +       sd->in_net_rx_action =3D false;
> > > > > >=20
> > > > > >         net_rps_action_and_irq_enable(sd);
> > > > > >  end:;
> > > > >=20
> > > > > I have tried to use also this change with and without the previou=
s patch
> > > > > but the result is the same:
> > > > > [  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
> > > > > And it is the same number of interrupts.
> > > > >=20
> > > > > Is something else that I should try?
> > > >=20
> > > > High number of interrupts for a saturated receiver seems wrong.
> > > > (Unless it is not saturating the cpu ?)
> > >=20
> > > The CPU usage seems to be almost at 100%. This is the output of top
> > > command:
> > > 149   132 root     R     5032   0%  96% iperf3 -c 10.97.10.1 -R
> > >  12     2 root     SW       0   0%   3% [ksoftirqd/0]
> > > 150   132 root     R     2652   0%   1% top
> > > ...
> >=20
> > Sorry for the dumb question, is the above with fdma =3D=3D false? (that=
 is,
> > no napi?) Why can't lan966x_xtr_irq_handler() be converted to the napi
> > model regardless of fdma ?!?
>=20
> No, this is with fdma =3D=3D true. Where we use napi.
>=20
> Will it be any advantage to use NAPI for lan966x_xtr_irq_handler()?

Using NAPI you will avoid extra queuing and will gain GRO. Should make
quite a difference.

> Because for lan966x_xtr_irq_handler() we will still need to read each
> word of the frame, which I think will be a big drawback compared with
> lan966x_fdma_irq_handler().

I guess/hope all the lan966x_rx_frame_word() work could be moved into
the napi poll callback.

In any case the fdma =3D=3D false code path will be likely quite slower
then the fdma =3D=3D true path - and hopefully faster then the current
code.

> Or did I misunderstand the question?

I think you didn't ;)

Cheers,

Paolo


