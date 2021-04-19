Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10767363D1F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhDSIGo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Apr 2021 04:06:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35960 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhDSIGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 04:06:43 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C36A063E49;
        Mon, 19 Apr 2021 10:05:42 +0200 (CEST)
Date:   Mon, 19 Apr 2021 10:06:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/net/ethernet/mediatek/mtk_ppe_offload.c - suspicious
 code?
Message-ID: <20210419080610.GA24040@salvia>
References: <526789.1618794132@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <526789.1618794132@turing-police>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 09:02:12PM -0400, Valdis Klētnieks wrote:
> While doing some code auditing for -Woverride_init, I spotted some questionable code
> 
> commit 502e84e2382d92654a2ecbc52cdbdb5a11cdcec7
> Author: Felix Fietkau <nbd@nbd.name>
> Date:   Wed Mar 24 02:30:54 2021 +0100
> 
>     net: ethernet: mtk_eth_soc: add flow offloading support
> 
> In drivers/net/ethernet/mediatek/mtk_ppe_offload.c:
> 
> +static const struct rhashtable_params mtk_flow_ht_params = {
> +       .head_offset = offsetof(struct mtk_flow_entry, node),
> +       .head_offset = offsetof(struct mtk_flow_entry, cookie),
> +       .key_len = sizeof(unsigned long),
> +       .automatic_shrinking = true,
> +};
> 
> What's intended for head_offset here?

It's a bug, there's a fix here:

https://www.spinics.net/lists/netdev/msg736368.html
