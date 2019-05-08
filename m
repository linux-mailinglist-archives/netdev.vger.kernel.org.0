Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE34317E4C
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfEHQlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:41:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbfEHQlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:41:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E826614051AFC;
        Wed,  8 May 2019 09:41:38 -0700 (PDT)
Date:   Wed, 08 May 2019 09:41:38 -0700 (PDT)
Message-Id: <20190508.094138.1398128604024649557.davem@davemloft.net>
To:     bjorn.andersson@linaro.org
Cc:     aneela@codeaurora.org, clew@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/5] net: qrtr: Implement outgoing flow control
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508060643.30936-3-bjorn.andersson@linaro.org>
References: <20190508060643.30936-1-bjorn.andersson@linaro.org>
        <20190508060643.30936-3-bjorn.andersson@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:41:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Tue,  7 May 2019 23:06:40 -0700

> +static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
> +{
> +	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
> +	struct qrtr_tx_flow *flow;
> +	unsigned long key;
> +	u64 remote_node = le32_to_cpu(pkt->client.node);
> +	u32 remote_port = le32_to_cpu(pkt->client.port);

Reverse christmas tree for the local variables please.

> +static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
> +			int type)
> +{
> +	struct qrtr_tx_flow *flow;
> +	unsigned long key = (u64)dest_node << 32 | dest_port;
> +	int confirm_rx = 0;
> +	int ret;

Likewise.

>  /* Pass an outgoing packet socket buffer to the endpoint driver. */
>  static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  			     int type, struct sockaddr_qrtr *from,
>  			     struct sockaddr_qrtr *to)
>  {
>  	struct qrtr_hdr_v1 *hdr;
> +	int confirm_rx;
>  	size_t len = skb->len;
>  	int rc = -ENODEV;

Likewise.
