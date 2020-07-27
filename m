Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8186D22F92B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgG0Tfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgG0Tfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:35:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877CEC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:35:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E29131276E07D;
        Mon, 27 Jul 2020 12:19:08 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:35:53 -0700 (PDT)
Message-Id: <20200727.123553.1187716564951764887.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, kuba@kernel.org, hawk@kernel.org,
        shayagr@amazon.com, lorenzo@kernel.org
Subject: Re: [PATCH RFC net-next 1/2] xdp: helpers: add multibuffer support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727125653.31238-2-sameehj@amazon.com>
References: <20200727125653.31238-1-sameehj@amazon.com>
        <20200727125653.31238-2-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:19:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Mon, 27 Jul 2020 12:56:52 +0000

> diff --git a/net/core/filter.c b/net/core/filter.c
> index bdd2382e6..93e790d7b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3452,6 +3452,62 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +static inline bool __bpf_xdp_has_frags(struct  xdp_buff *xdp)
> +{
> +	return xdp->mb != 0;
> +}

Please don't use the inline keyword in foo.c files, let the compiler decide.

Thank you.
