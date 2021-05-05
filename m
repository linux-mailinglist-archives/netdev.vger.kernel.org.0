Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60B437366B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhEEIki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhEEIkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:40:37 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BDDC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 01:39:41 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FZqrp66c4zQk1d;
        Wed,  5 May 2021 10:39:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1620203977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=26ji62X+HEHeeLTbUwspE0nMgVw9SoHaWqg5Pn2tGIU=;
        b=bvaDpANSckAXrs7iHoKodLvRKHgHgcEy4z9c7KByndu+CHaDfFXNR6IxCN8e/eoHRgTkn7
        qJF3NmNMHVKjDtDxnTJsouJYsIMIYz2r1sZVUr68XWUV+WfSNCdCbAONgnZ2yLQvMiGxX+
        zLlKQJlM0aXDRg5Cf4HIeDIR0yVu4ClnfH4MqFEV1J0Fv7yOtxs9VrysXcohBrHcXR+yiW
        tcYY9PrCb1wKvAs2w7kMxIZWTunB8AucA6t8dgG5K7aXpX6zuKHt6VR3y6GApKom1w/R0Y
        ZaQZWkwBRmGIMpayqjb8rLCul+/c9WshvDkh3unVYcq0kEPZAF1Jr72GxY9Kcg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id i2GpFXRbDm4i; Wed,  5 May 2021 10:39:35 +0200 (CEST)
References: <cover.1619886883.git.aclaudi@redhat.com>
 <d2475b23f31e8cb1eb19d51d8bb10866a06a418c.1619886883.git.aclaudi@redhat.com>
From:   Petr Machata <me@pmachata.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/2] dcb: fix return value on dcb_cmd_app_show
In-reply-to: <d2475b23f31e8cb1eb19d51d8bb10866a06a418c.1619886883.git.aclaudi@redhat.com>
Date:   Wed, 05 May 2021 10:39:33 +0200
Message-ID: <877dkd60ca.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.45 / 15.00 / 15.00
X-Rspamd-Queue-Id: EFFCF1404
X-Rspamd-UID: c4699e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrea Claudi <aclaudi@redhat.com> writes:

> dcb_cmd_app_show() is supposed to return EINVAL if an incorrect argument
> is provided.
>
> Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  dcb/dcb_app.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index c4816bc2..28f40614 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -667,7 +667,7 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>  out:
>  	close_json_object();
>  	dcb_app_table_fini(&tab);
> -	return 0;
> +	return ret;
>  }
>  
>  static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **argv)

Nice catch. Looks good,

Reviewed-by: Petr Machata <me@pmachata.org>
