Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439CB1A2B66
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDHVst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:48:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgDHVss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:48:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D33C1127D6209;
        Wed,  8 Apr 2020 14:48:46 -0700 (PDT)
Date:   Wed, 08 Apr 2020 14:48:45 -0700 (PDT)
Message-Id: <20200408.144845.783523592365109446.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     sameehj@amazon.com, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, toke@redhat.com,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com,
        john.fastabend@gmail.com, dsahern@gmail.com,
        willemdebruijn.kernel@gmail.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH RFC v2 26/33] i40e: add XDP frame size to driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158634676645.707275.7536684877295305696.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634676645.707275.7536684877295305696.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 14:48:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 08 Apr 2020 13:52:46 +0200

> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index b8496037ef7f..1fb6b1004dcb 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1507,6 +1507,23 @@ static inline unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
>  	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
>  }
>  
> +static inline unsigned int i40e_rx_frame_truesize(struct i40e_ring *rx_ring,
> +						  unsigned int size)

Please don't use inline in foo.c files.  I noticed you properly elided this in
the ice changes so I wonder why it showed up here :-)
