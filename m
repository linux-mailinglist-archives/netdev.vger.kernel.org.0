Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DED12F224
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgACAWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:22:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgACAWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:22:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A56D3157204A1;
        Thu,  2 Jan 2020 16:22:49 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:22:49 -0800 (PST)
Message-Id: <20200102.162249.948673283541180133.davem@davemloft.net>
To:     wgong@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191231093242.6320-1-wgong@codeaurora.org>
References: <20191231093242.6320-1-wgong@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:22:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 31 Dec 2019 17:32:42 +0800

> From: Carl Huang <cjhuang@codeaurora.org>
> 
> The len used for skb_put_padto is wrong, it need to add len of hdr.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
 ...
> @@ -196,7 +196,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  	hdr->size = cpu_to_le32(len);
>  	hdr->confirm_rx = 0;
>  
> -	skb_put_padto(skb, ALIGN(len, 4));
> +	skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));

I don't think this is correct.

The 'hdr' was already "pushed" earlier in this file.

Here we are padding the area after the header, which is being "put".

I'm not applying this.  If you still think it is correct, you must explain
in detail why it is and add that description to the commit log message.

Thank you.

