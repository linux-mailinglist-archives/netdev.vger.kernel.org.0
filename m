Return-Path: <netdev+bounces-11857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4637734E89
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21B211C2040B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125F5BA3E;
	Mon, 19 Jun 2023 08:50:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0472029B2
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:50:16 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82F9E60;
	Mon, 19 Jun 2023 01:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687164592; x=1718700592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U4uDbW+Uf+4W45dZBBl8ZXGzRv4EdQrMLloH/ZuNHac=;
  b=dfsTaXirnTOjd6tpwfZaBD7Q2CO7DWYIr1P6DdLGZIlNEq83K7LkrzwT
   9sTBnsVrMiViPQb7U2aHqzAqjVCaIieN6d+NyVI7pdt6CLpUhGLVoo/e3
   ARhK9FC5xvH+DuH3k6taBnoUyzE2SbWI3o0Fp/TNrz5M9Oiqro2fe2LC8
   x+CHUFYNIAbW1vtLsQyh07QnaqPY6s0Fefsy1Nj6mimy5xmglsdJi5c/P
   GD7dqJdtHER6zzuTBsvmdXQ7OrOiuMTTGd9HgyLPpu3pMIPZubvP7pCr8
   BxvOLkce03qBRpXH9JHBDH8A1W1rr26gos4ASrZqHj5BxIRMpPTF9k56R
   A==;
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="218582394"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jun 2023 01:49:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 19 Jun 2023 01:49:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 19 Jun 2023 01:49:41 -0700
Date: Mon, 19 Jun 2023 10:49:41 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sebastian.tobuschat@nxp.com>
Subject: Re: [PATCH net-next v1 12/14] net: phy: nxp-c45-tja11xx: read ext
 trig ts TJA1120
Message-ID: <20230619084941.q6c26zhf4ssnseiu@soft-dev3-1>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-13-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-13-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:

Hi Radu,

> 
>  static void nxp_c45_read_egress_ts(struct nxp_c45_phy *priv,
> @@ -628,12 +648,12 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
>         bool reschedule = false;
>         struct timespec64 ts;
>         struct sk_buff *skb;
> -       bool txts_valid;
> +       bool ts_valid;
>         u32 ts_raw;
> 
>         while (!skb_queue_empty_lockless(&priv->tx_queue) && poll_txts) {
> -               txts_valid = data->get_egressts(priv, &hwts);
> -               if (unlikely(!txts_valid)) {
> +               ts_valid = data->get_egressts(priv, &hwts);
> +               if (unlikely(!ts_valid)) {
>                         /* Still more skbs in the queue */
>                         reschedule = true;
>                         break;
> @@ -654,9 +674,9 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
>                 netif_rx(skb);
>         }
> 
> -       if (priv->extts) {
> -               nxp_c45_get_extts(priv, &ts);
> -               if (timespec64_compare(&ts, &priv->extts_ts) != 0) {
> +       if (priv->extts && data->get_extts) {

The data->get_extts can't be null. So I don't think you need this check.

> +               ts_valid = data->get_extts(priv, &ts);
> +               if (ts_valid && timespec64_compare(&ts, &priv->extts_ts) != 0) {
>                         priv->extts_ts = ts;
>                         event.index = priv->extts_index;
>                         event.type = PTP_CLOCK_EXTTS;
> @@ -1702,6 +1722,7 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
>         .ack_ptp_irq = false,
>         .counters_enable = tja1103_counters_enable,
>         .get_egressts = nxp_c45_get_hwtxts,
> +       .get_extts = nxp_c45_get_extts,
>         .ptp_init = tja1103_ptp_init,
>         .ptp_enable = tja1103_ptp_enable,
>         .nmi_handler = tja1103_nmi_handler,
> @@ -1816,6 +1837,7 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
>         .ack_ptp_irq = true,
>         .counters_enable = tja1120_counters_enable,
>         .get_egressts = tja1120_get_hwtxts,
> +       .get_extts = tja1120_get_extts,
>         .ptp_init = tja1120_ptp_init,
>         .ptp_enable = tja1120_ptp_enable,
>         .nmi_handler = tja1120_nmi_handler,
> --
> 2.34.1
> 
> 

-- 
/Horatiu

