Return-Path: <netdev+bounces-2893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E46D704749
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED261C20D7A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DB71F95C;
	Tue, 16 May 2023 08:04:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EAC19518
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:04:48 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B104693
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:04:45 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3f396606ab0so1728961cf.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684224284; x=1686816284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymG9rXKQX74KxEckjwgBY3K7NGepxlJBgVG5eT5News=;
        b=jb+nREVSXUogMXoT939DG0M6mkHjjtdNgXR1xW65myJHUPsvuE7UlYTTyltOg9Rgam
         kyYfSs41xrm7IAIdSOxWJsqj2G27CIjiHlTUEGkewxVMeYNzbif7166sAxpsyysI/zv6
         NmzbkvIoeACfD+Go5T6TZqcZPhDnZURFTzBB3908Q1uDhnnCwFxw07zMvC1YzcUPAMuI
         swT/Y8W70E+LD7vfFLtg4zAYXk4puGsysRiPP4ACsWXpY7/5dwhkXfog+Yt10oY19I2v
         8hbca6vK5LqC17Hh5gcSt6bXFBuTMVZkpZi7picxstYxqFMdiJ0ypcwqRmM8IWO6vRKU
         rTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684224284; x=1686816284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymG9rXKQX74KxEckjwgBY3K7NGepxlJBgVG5eT5News=;
        b=cwngVQ1zsRdJKtbHX6sjgwhnrhS3QA9oqfXAigHIVYYnDyqqAAYNhH8AV3FazROZ/W
         xNmaF/BBQmEU+q+JDyyLPzbWyIHTd2oLpFu2kco3oWtdFB1t4n9PizNgFbZs5IJrv6Uv
         dViua4LSFCcZ+kLp0xNgDjGehexfL8qCsxLVyG/KPVVIbT8I6uh0kD4oBt1MPaghTDEG
         g8wuGAWJFAcEVMb0h0oJnUcaqBEIDSV1DtmJa71+yoV4oJ71xrXt+ptxwAQz3NzTHMZ8
         KHpRXu7Eijm8m1EP6i/v+HzyzINVDSyUGPG7bYTpppy8u2n2zfyIO64WXyyNS0mqqjFL
         YTtQ==
X-Gm-Message-State: AC+VfDwSjtXrcYHcL/iUqS2B4wn5sLXMvDyLFrFc7r6vifVyDnLHXncT
	sFR1On3Lt0MMAL7FUPJEsXczbUlNlQNffzxb3omTNdQlDzms0gpXeN/iFg==
X-Google-Smtp-Source: ACHHUZ5OkoeGj3LU7GOtXARCq0Sd4+iuBzdk2pf1uhTXftuRy34alUHsWsBMpYw1SiB5jQ85kMEKtjbWxQthmCAR06Y=
X-Received: by 2002:a05:622a:1789:b0:3f4:f841:df89 with SMTP id
 s9-20020a05622a178900b003f4f841df89mr101077qtk.1.1684224283986; Tue, 16 May
 2023 01:04:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1> <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
 <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1>
In-Reply-To: <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 16 May 2023 10:04:32 +0200
Message-ID: <CANn89i+QT3nfE-nN9b6eeyMBp93CVHZYteuH6N9ErKYqF8PA=A@mail.gmail.com>
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

On Tue, May 16, 2023 at 9:45=E2=80=AFAM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 05/15/2023 14:30, Eric Dumazet wrote:
> >
> > On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
>
> Hi Eric,
>
> Thanks for looking at this.
>
> > >
> > > Hi,
> > >
> > > I have noticed that on the HEAD of net-next[0] there is a performance=
 drop
> > > for lan966x when extracting frames towards the CPU. Lan966x has a Cor=
tex
> > > A7 CPU. All the tests are done using iperf3 command like this:
> > > 'iperf3 -c 10.97.10.1 -R'
> > >
> > > So on net-next, I can see the following:
> > > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
> > > And it gets around ~97000 interrupts.
> > >
> > > While going back to the commit[1], I can see the following:
> > > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
> > > And it gets around ~1000 interrupts.
> > >
> > > I have done a little bit of searching and I have noticed that this
> > > commit [2] introduce the regression.
> > > I have tried to revert this commit on net-next and tried again, then =
I
> > > can see much better results but not exactly the same:
> > > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
> > > And it gets around ~700 interrupts.
> > >
> > > So my question is, was I supposed to change something in lan966x driv=
er?
> > > or is there a bug in lan966x driver that pop up because of this chang=
e?
> > >
> > > Any advice will be great. Thanks!
> > >
> > > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_en=
cap_match()")
> > > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid extra N=
ET_RX_SOFTIRQ")
> > >
> > >
> >
> > Hmmm... thanks for the report.
> >
> > This seems related to softirq (k)scheduling.
> >
> > Have you tried to apply this recent commit ?
> >
> > Commit-ID:     d15121be7485655129101f3960ae6add40204463
> > Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f3960ae6=
add40204463
> > Author:        Paolo Abeni <pabeni@redhat.com>
> > AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> > Committer:     Thomas Gleixner <tglx@linutronix.de>
> > CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> >
> > Revert "softirq: Let ksoftirqd do its job"
>
> I have tried to apply this patch but the results are the same:
> [  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
> And it gets just a little bit bigger number of interrupts ~11000
>
> >
> >
> > Alternative would be to try this :
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0e6051787=
15f90bae17b86f071
> > 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6713,8 +6713,8 @@ static __latent_entropy void
> > net_rx_action(struct softirq_action *h)
> >         list_splice(&list, &sd->poll_list);
> >         if (!list_empty(&sd->poll_list))
> >                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > -       else
> > -               sd->in_net_rx_action =3D false;
> > +
> > +       sd->in_net_rx_action =3D false;
> >
> >         net_rps_action_and_irq_enable(sd);
> >  end:;
>
> I have tried to use also this change with and without the previous patch
> but the result is the same:
> [  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
> And it is the same number of interrupts.
>
> Is something else that I should try?

High number of interrupts for a saturated receiver seems wrong.
(Unless it is not saturating the cpu ?)

Perhaps hard irqs are not properly disabled by this driver.

You also could try using napi_schedule_prep(), just in case it helps.

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index bd72fbc2220f3010afd8b90f3704e261b9d0a98f..4694f4f34e6caf5cf540ada17a4=
72c3c57f10823
100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -628,10 +628,12 @@ irqreturn_t lan966x_fdma_irq_handler(int irq, void *a=
rgs)
        err =3D lan_rd(lan966x, FDMA_INTR_ERR);

        if (db) {
-               lan_wr(0, lan966x, FDMA_INTR_DB_ENA);
-               lan_wr(db, lan966x, FDMA_INTR_DB);
+               if (napi_schedule_prep(&lan966x->napi)) {
+                       lan_wr(0, lan966x, FDMA_INTR_DB_ENA);
+                       lan_wr(db, lan966x, FDMA_INTR_DB);

-               napi_schedule(&lan966x->napi);
+                       __napi_schedule(&lan966x->napi);
+               }
        }

        if (err) {

