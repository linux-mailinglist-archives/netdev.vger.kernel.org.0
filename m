Return-Path: <netdev+bounces-5535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABB1712067
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33D3A2815AD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D0153B5;
	Fri, 26 May 2023 06:45:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1771720E6;
	Fri, 26 May 2023 06:45:36 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F7DBC;
	Thu, 25 May 2023 23:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685083534; x=1716619534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IJu7yRqmaECoG+aUqI9gqOkbcGWsi1NNfVI1riIMsLk=;
  b=jnvGkXV2jj7ELXJylaWO2oE/vW6V8LmVSo/Bs39Vj2SR/Dsxfp+E/lED
   e+8GHyzXw/PrTx7iXpKtYuUA43VzCG3u7op8Pd1ZMoe7xuPXfiNZ1ktMG
   x0XvZOwlkCkRImqxxTYAe3GC4+8GkrwWvMcQ3HkBl1wZmXUrBYR6DrjVq
   5thcfyCW3jCkHMb2k7Sm80tKGZUv2++x26E+54HnN6+Co7yBw+2JKzrVJ
   HW0ytnoCF/fKbuI908kxFwXSjCVFGc22yMdBmbBliDUVHrZYfyfijTwm5
   p5p8jfLTDGmWdcrLk7J6Y5uKJEJRTG2yGZ+I5a96nqkXyVCq9JrCOzBel
   A==;
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="217418416"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 23:45:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 23:45:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 23:45:32 -0700
Date: Fri, 26 May 2023 08:45:31 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Dexuan Cui
	<decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Paul Rosswurm
	<paulros@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>, Long Li <longli@microsoft.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"ast@kernel.org" <ast@kernel.org>, Ajay Sharma <sharmaajay@microsoft.com>,
	"hawk@kernel.org" <hawk@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Message-ID: <20230526064531.zohcgjbaraq7c2ui@soft-dev3-1>
References: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
 <20230525064849.ca5p6npej7p2luw2@soft-dev3-1>
 <PH7PR21MB31161F3291FF951877355DA9CA46A@PH7PR21MB3116.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <PH7PR21MB31161F3291FF951877355DA9CA46A@PH7PR21MB3116.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/25/2023 14:34, Haiyang Zhang wrote:
> 
> > -----Original Message-----
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Sent: Thursday, May 25, 2023 2:49 AM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> > <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> > davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; leon@kernel.org; Long Li
> > <longli@microsoft.com>; ssengar@linux.microsoft.com; linux-
> > rdma@vger.kernel.org; daniel@iogearbox.net; john.fastabend@gmail.com;
> > bpf@vger.kernel.org; ast@kernel.org; Ajay Sharma
> > <sharmaajay@microsoft.com>; hawk@kernel.org; linux-
> > kernel@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
> > tx_cqes counters
> >
> > [Some people who received this message don't often get email from
> > horatiu.vultur@microchip.com. Learn why this is important at
> > https://aka.ms/LearnAboutSenderIdentification ]
> >
> > The 05/24/2023 14:22, Haiyang Zhang wrote:
> >
> > Hi Haiyang,
> >
> > >
> > > The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
> > > frequent and parallel code path of all queues. So, r/w into this
> > > single shared variable by many threads on different CPUs creates a
> > > lot caching and memory overhead, hence perf regression. And, it's
> > > not accurate due to the high volume concurrent r/w.
> >
> > Do you have any numbers to show the improvement of this change?
> 
> The numbers are not published. The perf regression of the previous
> patch is very significant, and this patch eliminates the regression.
> 
> >
> > >
> > > Since the error path of mana_poll_rx_cq() already has warnings, so
> > > keeping the counter and convert it to a per-queue variable is not
> > > necessary. So, just remove this counter from this high frequency
> > > code path.
> > >
> > > Also, remove the tx_cqes counter for the same reason. We have
> > > warnings & other counters for errors on that path, and don't need
> > > to count every normal cqe processing.
> >
> > Will you not have problems with the counter 'apc->eth_stats.tx_cqe_err'?
> > It is not in the hot path but you will have concurrent access to it.
> 
> Yes, but that error happens rarely, so a shared variable is good enough. So, I
> don't change it in this patch.

OK, I understand.
Maybe this can be fixed in a different patch at a later point. Thanks.

Reviwed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Thanks,
> - Haiyang
> 

-- 
/Horatiu

