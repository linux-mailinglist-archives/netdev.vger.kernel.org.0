Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A11622C599
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgGXMzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGXMzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:55:19 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC975C0619E4;
        Fri, 24 Jul 2020 05:55:18 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b14so6756705qkn.4;
        Fri, 24 Jul 2020 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GNMerot99Zeu/Bh6VW3arO7rd3rYubmecPGy0caKX3E=;
        b=ekCsocUOSo/zo3tEgFNAi/6W0U9E4eGmnp8aB2nH98F2cOwizaiK/zEe/WYspLPre0
         MWEg+L2szqwztlPy8iCtAB/Ovhrnd80ZN68HEn6Xyu/G/o2yXGhtResbvSF8xWAISm7m
         lSY2YsmiDR9krpFghavrr7IvrSebJd83rPRz169cHD0037S7qcH4+5MaxMyMa2ms0dLW
         2zjbSwj8Qfq3HjFyi2VNDTmA6JD9O0OwNvAymW25FSDxG/L9JWzLbP8Kmc4wJl5lly4E
         oXnRbS8MdZsTyggCWnHaAQsgcJwiTbZGcBLu+OjAYOTl/lNMGsaUlmLmCKlCNqO2NI8v
         22Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GNMerot99Zeu/Bh6VW3arO7rd3rYubmecPGy0caKX3E=;
        b=hBIZCFS73genpi32X/csCoFO++vtq7DWe/ygKw7gctYDHNd1hQ9Hyh5lCLyju/0InT
         3huyHh0bVKCyfd9mPthlFb+BWzkCNXX3AzCzhBF8Tf/xlr70EgWA+0T4TL39PB5FuhuA
         JX9Sb2UKYj+UMwolPIrWA0aC/+VQJ3nQe0kBFf+coZ0TCxxlF3TRjXQzwMTmLkWxjibA
         +VwB3tfOtKWlSvdo7EXVG2IRGzFnP04/+6hg74PZCTDg4a51ZvQWrCs+kLdqxF4lLrvn
         yHYK7yoMBhDlVer8eL7zbCJEb6OgzzLfFoObARsBEKN72u/0J6hnHj8u0yL/yF7G7pEA
         A8Xg==
X-Gm-Message-State: AOAM531GYbi2E7QPFjwhgs0M3H+EbbioE8WT6Hcokr1WmnA0ijzlQD8M
        9aHQl2AD/lEug+KJF4TJtQA=
X-Google-Smtp-Source: ABdhPJyuV2Tew144v8vmayLqTAfO56JUBskXHd+e7izup1lF7JGMP/AHMj4jUcChEewEpcLrUiMmsQ==
X-Received: by 2002:a37:9987:: with SMTP id b129mr10123268qke.315.1595595317935;
        Fri, 24 Jul 2020 05:55:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a4f2:f184:dd41:1f10:d998])
        by smtp.gmail.com with ESMTPSA id g24sm1195650qta.27.2020.07.24.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 05:55:17 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9FB76C0EB8; Fri, 24 Jul 2020 09:55:14 -0300 (-03)
Date:   Fri, 24 Jul 2020 09:55:14 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: remove redundant initialization of variable status
Message-ID: <20200724125514.GD3399@localhost.localdomain>
References: <20200724121753.16721-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724121753.16721-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 01:17:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable status is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Are you willing to send another to patch to fix the var ordering in
reverse christmass tree in there?

> ---
>  net/sctp/protocol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 7ecaf7d575c0..a0448f7c64b9 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1368,7 +1368,7 @@ static struct pernet_operations sctp_ctrlsock_ops = {
>  static __init int sctp_init(void)
>  {
>  	int i;
> -	int status = -EINVAL;
> +	int status;
>  	unsigned long goal;
>  	unsigned long limit;
>  	unsigned long nr_pages = totalram_pages();
> -- 
> 2.27.0
> 
