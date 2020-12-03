Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978DD2CE10D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388388AbgLCVqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388162AbgLCVqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:46:51 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E664C061A53
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 13:46:11 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4Cn8XR1ybBzQlRP;
        Thu,  3 Dec 2020 22:45:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607031941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8ImIdvypi5sFXOVf0RGSKS25PG4zFNE+jSFp0Npd9A=;
        b=L3mPGtUl0kwF/6vb0PRPCboBYoqwZgaHsJhxVC9KZ5p9yqw4t208uSuRREs9n5lmIVr3fv
        weKFFAZ/ZrfsX7G8k02YIVzexAg4ku2bm/HxQvBsvf1yNyhEOztumfEdtxXSyjIxWM2NW1
        J1JwfvcGnLCwhgJpeFfu+laAJZUZPuodNN6zTbxXgDLhtQlyKxQ7RF/FMLtqd/RUYHB2cI
        /LXCm+MOJ21Kx0UL017f9yEtkhmQWTvdOwsSThQA3rETHU8e2R8fYvdMdnDqeBYDZYokzk
        9DB2126e4Xvh0pnQg2VY8CSTEhME6/TW648dFr+xNYuUHeekyud9A/zgHdqIcw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id gLjrdGvgIB5v; Thu,  3 Dec 2020 22:45:40 +0100 (CET)
References: <20201203041101.11116-1-dsahern@kernel.org>
From:   Petr Machata <me@pmachata.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, me@pmachata.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] Only compile mnl_utils when HAVE_LIBMNL is defined
In-reply-to: <20201203041101.11116-1-dsahern@kernel.org>
Date:   Thu, 03 Dec 2020 22:45:38 +0100
Message-ID: <87o8jamum5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.90 / 15.00 / 15.00
X-Rspamd-Queue-Id: 49E6F1478
X-Rspamd-UID: da0229
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@kernel.org> writes:

> diff --git a/lib/Makefile b/lib/Makefile
> index e37585c6..603ea83e 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -13,7 +13,10 @@ UTILOBJ += bpf_libbpf.o
>  endif
>  endif
>  
> -NLOBJ=libgenl.o libnetlink.o mnl_utils.o
> +NLOBJ=libgenl.o libnetlink.o
> +ifeq ($(HAVE_LIBMNL),y)

This should test HAVE_MNL, not HAVE_LIBMNL.
