Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4744755E2B1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiF0POa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiF0PO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:14:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D031834F
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:14:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so9739879pjv.3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BYwoGFRmE6AJx3vk5b1eUsv01u+gbswGGYdyfEpYih4=;
        b=4ciU82iDMs3oOlgIb9je5hxVT1Oyqp+w5RF/EXsNs1hqDXxe9std63TwLVxPJoOKCc
         IRcdFYVOatlB2911iYdqxBLtywXcFOcW2JmAA1+8FIXrlKmWA7fzi/cJU202tUHv9PK1
         ePPrj++Qra5BEm8KGOmh0Obb51m8GwHlfbnLJbLbXUwlXSJg7UgklXX1qdoms87SMvNA
         8DMq1IS7j3Yu9pONUogiBUhqlFHDPazgQ1hr5bFTcbWqcLdBFU5y8LJ/biiPK/SX2a2g
         fFiFrG8gfbvF7V+vhGb3JmPZesIZFLWegqrJWs6BJaZ5tciNFDtWxnqXbIx3IF75CROf
         qBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BYwoGFRmE6AJx3vk5b1eUsv01u+gbswGGYdyfEpYih4=;
        b=nzUeSdCId6cEJxNUPSwxITP8JOkwT1BoDUfGk90hOywpmL6l5efmhq/OQ6OEVhlXlo
         1QkuOh5GuYCSslhraWspF1HGRF8JWwzHTgpooOB8PweJ/rXCleLUDzaQ6WBm9uByuNTp
         ezfpig6GfEtvD8BNuIDqv1OCptt3F1v3TAqJ6VZ4QAoYhblKvXaR1wb50ZzHUr+fuxMe
         KraKwvhvVdxVSL50MG6FjVNrLd19TiqWkvRzfbMXt5qu9YuP9RiFVa9NGFkrKe969KEO
         qIYEEorXlzXCw3UNXHb1AyhCBqxhcDsRNZwgCyCMGa3EsLVFa0iTlxiJ9M/veWflSzZT
         cCZA==
X-Gm-Message-State: AJIora9Yi0iwoHm+DcxILVxtzOyuQ5naXo8MzVoxTpZmvqurorqjNIc8
        SAaAbSqs8DfneYg0aZI+X0clcQ==
X-Google-Smtp-Source: AGRyM1uSTuFL68Gk/OZikMe2hxlZlVbOuxrnGcfTe+nHQSXfrkWfzOdd75YkudXg+D7rsGadBQHQpg==
X-Received: by 2002:a17:90a:b397:b0:1ec:c9b4:29cf with SMTP id e23-20020a17090ab39700b001ecc9b429cfmr16196980pjr.134.1656342864820;
        Mon, 27 Jun 2022 08:14:24 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id k15-20020a17090a39cf00b001e880972840sm9695219pjf.29.2022.06.27.08.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:14:24 -0700 (PDT)
Date:   Mon, 27 Jun 2022 08:14:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] ip: Fix size_columns() invocation that passes
 a 32-bit quantity
Message-ID: <20220627081421.3228af32@hermes.local>
In-Reply-To: <1b8c8a3e8ae41a85f2167d94a6d7bcc4d46757f6.1656335952.git.petrm@nvidia.com>
References: <1b8c8a3e8ae41a85f2167d94a6d7bcc4d46757f6.1656335952.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 15:20:01 +0200
Petr Machata <petrm@nvidia.com> wrote:

> In print_stats64(), the last size_columns() invocation passes number of
> carrier changes as one of the arguments. The value is decoded as a 32-bit
> quantity, but size_columns() expects a 64-bit one. This is undefined
> behavior.
> 
> The reason valgrind does not cite this is that the previous size_columns()
> invocations prime the ABI area used for the value transfer. When these
> other invocations are commented away, valgrind does complain that
> "conditional jump or move depends on uninitialised value", as would be
> expected.
> 
> Fixes: 49437375b6c1 ("ip: dynamically size columns when printing stats")
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  ip/ipaddress.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 5a3b1cae..8cd76073 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -788,8 +788,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  				     s->tx_aborted_errors, s->tx_fifo_errors,
>  				     s->tx_window_errors,
>  				     s->tx_heartbeat_errors,
> -				     carrier_changes ?
> -				     rta_getattr_u32(carrier_changes) : 0);
> +				     (uint64_t)(carrier_changes ?
> +						rta_getattr_u32(carrier_changes)
> +						: 0));

Looks good, but would be clearer with a local temporary variable
which would eliminate the cast etc.
