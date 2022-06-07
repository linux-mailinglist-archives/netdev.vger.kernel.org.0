Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76153F466
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 05:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiFGDTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 23:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFGDTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 23:19:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B7C56227
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 20:19:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id y187so14615767pgd.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 20:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LTE3G0kpl/LjR7abNouZaQzrDoV1Svzb3FVq/9cBUNA=;
        b=RxQcG0/CayLCRfIbILHzpdC8dv7284cJWnVeQiJAVE7fYTga0jQW/XcfTMoAsjEKgn
         4X1n+NmXR75EdUQdTzs/CYN1IBa7+n9bdLHlnrsQhl71Ltk5NdwSc4sO74TPM0dut6+T
         Q+eS/mkZQ137t+gCDOjso8wn2+vKnhpTKJdr6fiHzOJUmfpJKAIRdoQfkrBVozDs54Kq
         C1SgJ410M3Pf767AIocv5qWBYjo0WMEqWwsRf6H5MsCDWpFONhYpT7PYvr9uhr0RcarD
         oE4fEpW6nZ+mWEYFq8MJDh3T4kPi+sH1vlGzuL+IFTXYzlxrYnwaTY845VzFWx+/UTsg
         purQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LTE3G0kpl/LjR7abNouZaQzrDoV1Svzb3FVq/9cBUNA=;
        b=sNQgUniHtkRRyQmKHhawHdabBLuXymXONwmaB9DWk4/DXJ2jrBYWINmTwGI0R6z8N3
         v9+lgL7Zz9QIDxzPicxqEYgKNOMatMZW5c21uC44Au+gsHOu55smZ7LvY7euxhLbxmaX
         2sQtbWD68/6V9sMPmvSkieHYbswcderqQmw3YKu+uXsNKh4U+MOWsvKAWPCnoOFJypbZ
         4QKb5lk1qroG9x9tGyevboS8xqyWRteuCFA3/Y4NjkVvOTcXi/4ziYhW0mi2/u5dOtzx
         F6jprxqwN1GbIeOVObkra5/H0sHeohKh4ppuethaPMJ6iXFq4eEKwHplmEjdsFCELXdh
         f0vA==
X-Gm-Message-State: AOAM531jfGBEExvZ9p4w2CiSTLJeCpPE7MJlKFdtP8CKP9RKoP4d+5H/
        oU0s1+Ykns8nKvkNJ5Sw71FwjA==
X-Google-Smtp-Source: ABdhPJw1hV/E50RBF2YmAbzKIemphrCVLWO29VjwaqUq/p5gdfdZdusjOJneCPLJfhEP+ZWyGHtP2Q==
X-Received: by 2002:a05:6a00:1acd:b0:51c:242d:b611 with SMTP id f13-20020a056a001acd00b0051c242db611mr6808066pfv.2.1654571954279;
        Mon, 06 Jun 2022 20:19:14 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id i4-20020aa787c4000000b0051bc581b62asm9395551pfo.121.2022.06.06.20.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 20:19:13 -0700 (PDT)
Date:   Mon, 6 Jun 2022 20:19:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     fruggeri@arista.com, netdev@vger.kernel.org
Subject: Re: neighbour netlink notifications delivered in wrong order
Message-ID: <20220606201910.2da95056@hermes.local>
In-Reply-To: <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
        <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
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

On Mon, 6 Jun 2022 19:07:04 -0700
Andy Roulin <aroulin@nvidia.com> wrote:

> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 54625287ee5b..a91dfcbfc01c 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb, 
> struct neighbour *neigh,
>   	if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
>   		goto nla_put_failure;
> 
> -	read_lock_bh(&neigh->lock);
>   	ndm->ndm_state	 = neigh->nud_state;

Accessing neighbor state outside of lock is not safe.

But you should be able to use RCU here??
