Return-Path: <netdev+bounces-2934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 659777049F3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:00:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20AE028154D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750BF182DC;
	Tue, 16 May 2023 09:59:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6264E2C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:59:59 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF28A9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:59:57 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f51ea3a062so502341cf.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684231197; x=1686823197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uwvvfqIY4Wa8JT2UVgn21nSq2EsPNQIXKtwZyDJ0R4=;
        b=BvcJeYCr1S1l2STCCqm9ikgNdM/nwaIxlvMLz0vFiwdgDmsVtjJs10gWPpc9W2ZEqj
         +qp5ZcvU42gbn9FJjdpC1kcwr1QsZwHqTQ0Qeq9VIqbQIZETn5DBl6lPBOrFlZCEPFeH
         4+SUIedKn7ZxBrySYLL826Bo18k1kHgcwuSkcNQ6C/cyyPsiZyQHnivOgEg0ReJLNG4X
         1o8LbQ8Mr1qADa2mHXLnXOBTYqQQsTWwXn2VCkthh2DnpjMZIiFLNJTzbTkqyUkvb+Q4
         QCa+kZQ2VGMQj5x555YAWW+HHWy9u8+zjnDq9TUpQTl1agOAbpiJXUS/QwKOVn2UmBgs
         58kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684231197; x=1686823197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uwvvfqIY4Wa8JT2UVgn21nSq2EsPNQIXKtwZyDJ0R4=;
        b=PRXgD4tUfwNvDKXDyKxPPnYQL5qVCOR/L9VOtgBHz+u8+LkEHeegxk5YD563+EcCkD
         ZY1IVZ+3bzwizKsrU4wWAzkvVDeRFpgL9cf4Heo1P8a3lCLDPxoNBkRLwFYecdBPNEqC
         Hkz94RvsTapkx84xUNGeY30wVkoc0rg5Q/n3Po81HX6tcZ1vA8Wi1cWsGkhoRXsivgX9
         hTJzjfEAwlVDPO17VJBs8HexPludhTaVAsn1JzUWiDAvxcJCbD6OyjDOJJ4e2jCLsJPz
         i4a7qlIPHwfiqnqgJ9yhsNUj0YEBWtLKBKcxgNx73aCJdTfy4WT6l/+0HzpACOBG3XLJ
         +RNw==
X-Gm-Message-State: AC+VfDwAAP82q452euD0IGYoXEGjHCeeqYqN3Y8dFFfU+aZfrZDijnca
	p1Qu2rGoW3DLdKiLZr1a/BgOqS22GMHMWqbx08TC4gX2XEjpF+L/wgc=
X-Google-Smtp-Source: ACHHUZ7MtKp5hl3ONHfCjVM85uqiEfuvNB51G1S1ZgLJB97APhb7oJyepUr6P69UAOnpUNFgwaj0C1SAfH8dOUUCnTs=
X-Received: by 2002:a05:622a:13cd:b0:3f3:a373:c9d5 with SMTP id
 p13-20020a05622a13cd00b003f3a373c9d5mr109900qtk.13.1684231196823; Tue, 16 May
 2023 02:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1> <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
 <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1> <CANn89i+QT3nfE-nN9b6eeyMBp93CVHZYteuH6N9ErKYqF8PA=A@mail.gmail.com>
 <20230516092714.wresm662w54zs226@soft-dev3-1>
In-Reply-To: <20230516092714.wresm662w54zs226@soft-dev3-1>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 16 May 2023 11:59:45 +0200
Message-ID: <CANn89iL83K13OZvKLR41LS-bTjoFtn_1L7PGe6qNxHjzg-zLJQ@mail.gmail.com>
Subject: Re: Performance regression on lan966x when extracting frames
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:27=E2=80=AFAM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 05/16/2023 10:04, Eric Dumazet wrote:
> >
> > On Tue, May 16, 2023 at 9:45=E2=80=AFAM Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
> > >
> > > The 05/15/2023 14:30, Eric Dumazet wrote:
> > > >
> > > > On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
> > > > <horatiu.vultur@microchip.com> wrote:
> > >
> > > Hi Eric,
> > >
> > > Thanks for looking at this.
> > >
> > > > >
> > > > > Hi,
> > > > >
> > > > > I have noticed that on the HEAD of net-next[0] there is a perform=
ance drop
> > > > > for lan966x when extracting frames towards the CPU. Lan966x has a=
 Cortex
> > > > > A7 CPU. All the tests are done using iperf3 command like this:
> > > > > 'iperf3 -c 10.97.10.1 -R'
> > > > >
> > > > > So on net-next, I can see the following:
> > > > > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
> > > > > And it gets around ~97000 interrupts.
> > > > >
> > > > > While going back to the commit[1], I can see the following:
> > > > > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
> > > > > And it gets around ~1000 interrupts.
> > > > >
> > > > > I have done a little bit of searching and I have noticed that thi=
s
> > > > > commit [2] introduce the regression.
> > > > > I have tried to revert this commit on net-next and tried again, t=
hen I
> > > > > can see much better results but not exactly the same:
> > > > > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
> > > > > And it gets around ~700 interrupts.
> > > > >
> > > > > So my question is, was I supposed to change something in lan966x =
driver?
> > > > > or is there a bug in lan966x driver that pop up because of this c=
hange?
> > > > >
> > > > > Any advice will be great. Thanks!
> > > > >
> > > > > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_recor=
d_encap_match()")
> > > > > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > > > > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid ext=
ra NET_RX_SOFTIRQ")
> > > > >
> > > > >
> > > >
> > > > Hmmm... thanks for the report.
> > > >
> > > > This seems related to softirq (k)scheduling.
> > > >
> > > > Have you tried to apply this recent commit ?
> > > >
> > > > Commit-ID:     d15121be7485655129101f3960ae6add40204463
> > > > Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f396=
0ae6add40204463
> > > > Author:        Paolo Abeni <pabeni@redhat.com>
> > > > AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> > > > Committer:     Thomas Gleixner <tglx@linutronix.de>
> > > > CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> > > >
> > > > Revert "softirq: Let ksoftirqd do its job"
> > >
> > > I have tried to apply this patch but the results are the same:
> > > [  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
> > > And it gets just a little bit bigger number of interrupts ~11000
> > >
> > > >
> > > >
> > > > Alternative would be to try this :
> > > >
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
> > > >
> > > >         net_rps_action_and_irq_enable(sd);
> > > >  end:;
> > >
> > > I have tried to use also this change with and without the previous pa=
tch
> > > but the result is the same:
> > > [  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
> > > And it is the same number of interrupts.
> > >
> > > Is something else that I should try?
> >
> > High number of interrupts for a saturated receiver seems wrong.
> > (Unless it is not saturating the cpu ?)
>
> The CPU usage seems to be almost at 100%. This is the output of top
> command:
> 149   132 root     R     5032   0%  96% iperf3 -c 10.97.10.1 -R
>  12     2 root     SW       0   0%   3% [ksoftirqd/0]
> 150   132 root     R     2652   0%   1% top

Strange... There might be some scheduling artifacts in TCP stack for
your particular workload.
Perhaps leading to fewer ACK packets being sent, and slowing down the sende=
r.

It is unclear where cpu cycles are eaten. Normally the kernel->user
copy should be the limiting factor.

Please try
perf record -a -g sleep 10
perf report --no-children --stdio


I do not see obvious problems with my commit

