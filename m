Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517FE105AD1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKUUCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:02:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52640 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUUCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:02:19 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE1E01504493F;
        Thu, 21 Nov 2019 12:02:18 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:02:18 -0800 (PST)
Message-Id: <20191121.120218.822468406949238769.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, nirranjan@chelsio.com,
        atul.gupta@chelsio.com, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 2/3] cxgb4: add UDP segmentation offload
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2ddeefa22022f3949901c96892b8bf56a369f724.1574347161.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574347161.git.rahul.lakkireddy@chelsio.com>
        <cover.1574347161.git.rahul.lakkireddy@chelsio.com>
        <2ddeefa22022f3949901c96892b8bf56a369f724.1574347161.git.rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 12:02:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Thu, 21 Nov 2019 20:50:48 +0530

> @@ -1345,6 +1355,25 @@ static inline int cxgb4_validate_skb(struct sk_buff *skb,
>  	return 0;
>  }
>  
> +static inline void *write_eo_udp_wr(struct sk_buff *skb,
> +				    struct fw_eth_tx_eo_wr *wr, u32 hdr_len)
> +{

Do not use inline in foo.c files, let the compiler decide.

I know this source file is already a rotting mess of inline function
directives, but let's not add more.
