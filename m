Return-Path: <netdev+bounces-2886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8DA7046CF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBF8B28156C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690451E528;
	Tue, 16 May 2023 07:45:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576C81E521
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:45:40 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B351BF0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684223139; x=1715759139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=RukK+0L/4X9csOT6mHo1rGQesDVApAfxAzTqB4Pui74=;
  b=1C+CJQTagHtJGwo9lAcqZ1o+5QNKGPfwoGxwzmj2WabWlvBGmbqHhPGy
   5bd9hNX9zkDOlgOhNoLYskG9J1lconmQSsPZ4kfx6PxwCZXax+zh3iGNf
   jbRV0errGzvVJEC34W5hD0go1x/EyDPK4qMp+ZkHorYg1HF3YViMC2vQf
   ulponcyw25C+QnM0k+WPyKmX5SuRtkLQ6OWmd+hPpcBOMg0LCDUO9at7d
   YkYmw2Q34EdbqeNg5mCMPlMUM3DlRyND+ORFxmxv8fcXcb8xKpdZhOskZ
   8/YAvoj6IkfSHro9YTMjM1Aort71wYCNRBxQA1emer6VbKYVFqGjcchhC
   A==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="211467903"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 00:45:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 00:45:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 16 May 2023 00:45:34 -0700
Date: Tue, 16 May 2023 09:45:33 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Eric Dumazet <edumazet@google.com>
CC: <netdev@vger.kernel.org>
Subject: Re: Performance regression on lan966x when extracting frames
Message-ID: <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1>
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
 <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/15/2023 14:30, Eric Dumazet wrote:
> 
> On Mon, May 15, 2023 at 11:12 AM Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:

Hi Eric,

Thanks for looking at this.

> >
> > Hi,
> >
> > I have noticed that on the HEAD of net-next[0] there is a performance drop
> > for lan966x when extracting frames towards the CPU. Lan966x has a Cortex
> > A7 CPU. All the tests are done using iperf3 command like this:
> > 'iperf3 -c 10.97.10.1 -R'
> >
> > So on net-next, I can see the following:
> > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
> > And it gets around ~97000 interrupts.
> >
> > While going back to the commit[1], I can see the following:
> > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
> > And it gets around ~1000 interrupts.
> >
> > I have done a little bit of searching and I have noticed that this
> > commit [2] introduce the regression.
> > I have tried to revert this commit on net-next and tried again, then I
> > can see much better results but not exactly the same:
> > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
> > And it gets around ~700 interrupts.
> >
> > So my question is, was I supposed to change something in lan966x driver?
> > or is there a bug in lan966x driver that pop up because of this change?
> >
> > Any advice will be great. Thanks!
> >
> > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_encap_match()")
> > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ")
> >
> >
> 
> Hmmm... thanks for the report.
> 
> This seems related to softirq (k)scheduling.
> 
> Have you tried to apply this recent commit ?
> 
> Commit-ID:     d15121be7485655129101f3960ae6add40204463
> Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f3960ae6add40204463
> Author:        Paolo Abeni <pabeni@redhat.com>
> AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> Committer:     Thomas Gleixner <tglx@linutronix.de>
> CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> 
> Revert "softirq: Let ksoftirqd do its job"

I have tried to apply this patch but the results are the same:
[  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
And it gets just a little bit bigger number of interrupts ~11000

> 
> 
> Alternative would be to try this :
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0e605178715f90bae17b86f071
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6713,8 +6713,8 @@ static __latent_entropy void
> net_rx_action(struct softirq_action *h)
>         list_splice(&list, &sd->poll_list);
>         if (!list_empty(&sd->poll_list))
>                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> -       else
> -               sd->in_net_rx_action = false;
> +
> +       sd->in_net_rx_action = false;
> 
>         net_rps_action_and_irq_enable(sd);
>  end:;

I have tried to use also this change with and without the previous patch
but the result is the same:
[  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
And it is the same number of interrupts.

Is something else that I should try?

-- 
/Horatiu

