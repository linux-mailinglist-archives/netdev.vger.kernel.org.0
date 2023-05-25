Return-Path: <netdev+bounces-5240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D495B7105CC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C9DE28148C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABAE8F53;
	Thu, 25 May 2023 06:48:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACB75240;
	Thu, 25 May 2023 06:48:53 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2737AC0;
	Wed, 24 May 2023 23:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684997332; x=1716533332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fXnFdHMpIBK0pbiO2rn3en44HrYigxb3fY8Niaa5yX8=;
  b=gaqRJqJTVwTZ9Q2sq2+MxiQYDoGTNdwWs5dCwDSnOQ37z1c24DanVuOB
   QmOaBYGWaHwxuCoyvprdSUnZ98iK04gkrqXOYdh1qfJIrfxJqkFlVLGHk
   /dW66xFx5gJVKCFIzrlS/jtK55m1UMY+lueQqsCD9jm+Y6/ORwGE2Jw/l
   gz6zeQXICUsOyVT/KrZa7KP3Bgj8Dp9h6CeoyYACshDM1jm4qPR1CYZ43
   onBFZaaAp+JPtGS7eXAlCRNzZW5vYeQw1+DmowmkndksqDz2rpmZqeHYN
   HufSDN+4u87xwlpQ4luS5SUhzT/6TLm26a0779pt84G6kq+lELj9W7nA7
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="217198440"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 23:48:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 23:48:50 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 24 May 2023 23:48:50 -0700
Date: Thu, 25 May 2023 08:48:49 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>,
	<decui@microsoft.com>, <kys@microsoft.com>, <paulros@microsoft.com>,
	<olaf@aepfle.de>, <vkuznets@redhat.com>, <davem@davemloft.net>,
	<wei.liu@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <leon@kernel.org>, <longli@microsoft.com>,
	<ssengar@linux.microsoft.com>, <linux-rdma@vger.kernel.org>,
	<daniel@iogearbox.net>, <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
	<ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Message-ID: <20230525064849.ca5p6npej7p2luw2@soft-dev3-1>
References: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/24/2023 14:22, Haiyang Zhang wrote:

Hi Haiyang,

> 
> The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
> frequent and parallel code path of all queues. So, r/w into this
> single shared variable by many threads on different CPUs creates a
> lot caching and memory overhead, hence perf regression. And, it's
> not accurate due to the high volume concurrent r/w.

Do you have any numbers to show the improvement of this change?

> 
> Since the error path of mana_poll_rx_cq() already has warnings, so
> keeping the counter and convert it to a per-queue variable is not
> necessary. So, just remove this counter from this high frequency
> code path.
> 
> Also, remove the tx_cqes counter for the same reason. We have
> warnings & other counters for errors on that path, and don't need
> to count every normal cqe processing.

Will you not have problems with the counter 'apc->eth_stats.tx_cqe_err'?
It is not in the hot path but you will have concurrent access to it.

> 
> Cc: stable@vger.kernel.org
> Fixes: bd7fc6e1957c ("net: mana: Add new MANA VF performance counters for easier troubleshooting")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c      | 10 ----------
>  drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  2 --
>  include/net/mana/mana.h                            |  2 --
>  3 files changed, 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 06d6292e09b3..d907727c7b7a 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1279,8 +1279,6 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
>         if (comp_read < 1)
>                 return;
> 
> -       apc->eth_stats.tx_cqes = comp_read;
> -
>         for (i = 0; i < comp_read; i++) {
>                 struct mana_tx_comp_oob *cqe_oob;
> 
> @@ -1363,8 +1361,6 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
>                 WARN_ON_ONCE(1);
> 
>         cq->work_done = pkt_transmitted;
> -
> -       apc->eth_stats.tx_cqes -= pkt_transmitted;
>  }
> 
>  static void mana_post_pkt_rxq(struct mana_rxq *rxq)
> @@ -1626,15 +1622,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
>  {
>         struct gdma_comp *comp = cq->gdma_comp_buf;
>         struct mana_rxq *rxq = cq->rxq;
> -       struct mana_port_context *apc;
>         int comp_read, i;
> 
> -       apc = netdev_priv(rxq->ndev);
> -
>         comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
>         WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
> 
> -       apc->eth_stats.rx_cqes = comp_read;
>         rxq->xdp_flush = false;
> 
>         for (i = 0; i < comp_read; i++) {
> @@ -1646,8 +1638,6 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
>                         return;
> 
>                 mana_process_rx_cqe(rxq, cq, &comp[i]);
> -
> -               apc->eth_stats.rx_cqes--;
>         }
> 
>         if (rxq->xdp_flush)
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index a64c81410dc1..0dc78679f620 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -13,11 +13,9 @@ static const struct {
>  } mana_eth_stats[] = {
>         {"stop_queue", offsetof(struct mana_ethtool_stats, stop_queue)},
>         {"wake_queue", offsetof(struct mana_ethtool_stats, wake_queue)},
> -       {"tx_cqes", offsetof(struct mana_ethtool_stats, tx_cqes)},
>         {"tx_cq_err", offsetof(struct mana_ethtool_stats, tx_cqe_err)},
>         {"tx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
>                                         tx_cqe_unknown_type)},
> -       {"rx_cqes", offsetof(struct mana_ethtool_stats, rx_cqes)},
>         {"rx_coalesced_err", offsetof(struct mana_ethtool_stats,
>                                         rx_coalesced_err)},
>         {"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index cd386aa7c7cc..9eef19972845 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -347,10 +347,8 @@ struct mana_tx_qp {
>  struct mana_ethtool_stats {
>         u64 stop_queue;
>         u64 wake_queue;
> -       u64 tx_cqes;
>         u64 tx_cqe_err;
>         u64 tx_cqe_unknown_type;
> -       u64 rx_cqes;
>         u64 rx_coalesced_err;
>         u64 rx_cqe_unknown_type;
>  };
> --
> 2.25.1
> 
> 

-- 
/Horatiu

