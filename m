Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B372113DC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgGATsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgGATsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:48:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E3BC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 12:48:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 676BE13AE7192;
        Wed,  1 Jul 2020 12:48:00 -0700 (PDT)
Date:   Wed, 01 Jul 2020 12:47:59 -0700 (PDT)
Message-Id: <20200701.124759.594794808175916495.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, mcroce@linux.microsoft.com,
        lorenzo@kernel.org, brouer@redhat.com, stefanc@marvell.com,
        mw@semihalf.com, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH 1/1] mvpp2: xdp ethtool stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701153044.qlzcnh7ve56o2ata@SvensMacBookAir.sven.lan>
References: <20200701153044.qlzcnh7ve56o2ata@SvensMacBookAir.sven.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 12:48:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Wed, 1 Jul 2020 17:30:44 +0200

>  static void mvpp2_read_stats(struct mvpp2_port *port)
>  {
>  	u64 *pstats;
> +	const struct mvpp2_ethtool_counter *s;
> +	struct mvpp2_pcpu_stats xdp_stats = {};
>  	int i, q;

Reverse christmas tree ordering here, please.
> @@ -3166,6 +3271,7 @@
>  	       struct xdp_frame **frames, u32 flags)
>  {
>  	struct mvpp2_port *port = netdev_priv(dev);
> +	struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
>  	int i, nxmit_byte = 0, nxmit = num_frame;
>  	u32 ret;
>  	u16 txq_id;

Likewise.

> @@ -3258,11 +3374,10 @@
>  	enum dma_data_direction dma_dir;
>  	struct bpf_prog *xdp_prog;
>  	struct xdp_buff xdp;
> +	struct mvpp2_pcpu_stats ps = {};
>  	int rx_received;
>  	int rx_done = 0;
>  	u32 xdp_ret = 0;
> -	u32 rcvd_pkts = 0;
> -	u32 rcvd_bytes = 0;

Likewise.

