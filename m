Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAE1EA8AD
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 19:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgFARxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 13:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgFARxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 13:53:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C74EC05BD43;
        Mon,  1 Jun 2020 10:53:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD2D811D69C3B;
        Mon,  1 Jun 2020 10:53:42 -0700 (PDT)
Date:   Mon, 01 Jun 2020 10:53:39 -0700 (PDT)
Message-Id: <20200601.105339.1821963108388271707.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v5] hinic: add set_channels ethtool_ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601105748.27511-1-luobin9@huawei.com>
References: <20200601105748.27511-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 10:53:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Mon, 1 Jun 2020 18:57:48 +0800

> @@ -470,6 +470,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  	struct hinic_txq *txq;
>  	struct hinic_qp *qp;
>  
> +	if (unlikely(!netif_carrier_ok(netdev))) {
> +		dev_kfree_skb_any(skb);
> +		return NETDEV_TX_OK;
> +	}

As stated by another reviewer, this change is unrelated to adding
set_channels support.  Please remove it from this patch.
