Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B66D2E0C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjDAEJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjDAEJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:09:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA521A964;
        Fri, 31 Mar 2023 21:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB051B83351;
        Sat,  1 Apr 2023 04:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F04C433D2;
        Sat,  1 Apr 2023 04:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680322162;
        bh=g7PnwELFRTJZzkTdRGdAbwHBGVF//Z0ISuVZjwv+YV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jN/+o7G+MH3Jrs0IkXysetWwcszpZ3+L4i+/hPw4mB61zG/82YMKlYW/GnbKp5oxJ
         RG4SB10NiUZAY0a62Vgooom3AZZVXsD6iOGT58QadQdBcOAMersMAZY6ExLm341/Kk
         GZ0thtOwF/KZ/Hle+gWQt9aLr82aLL4zS+F/YiO87hCsWkL1hLGTWqL+6Z7ezsNOA0
         TTeY5exsfQj1d5siMqhxXr9QRNXvfEmZ6gGLXXt9UAAkWVJuEYwONAspO/e1b9dYLE
         kBfH6ad/zrkIOZyvloToCZrYVGntYJXfEAqmwfkvAl9AG6XMbindoNQTsPFtOw13n5
         gKv4v2o7seSIw==
Date:   Fri, 31 Mar 2023 21:09:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230331210920.399e3483@kernel.org>
In-Reply-To: <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 16:55:23 -0700 Anjali Kulkarni wrote:
> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
> +			       __u32 portid, __u32 group, gfp_t allocation,
> +			       int (*filter)(struct sock *dsk,
> +					     struct sk_buff *skb, void *data),
> +			       void *filter_data);

> -int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
> -		      u32 group, gfp_t allocation)
> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
> +			       u32 portid,
> +			       u32 group, gfp_t allocation,
> +			       int (*filter)(struct sock *dsk,
> +					     struct sk_buff *skb, void *data),
> +			       void *filter_data)

nit: slight divergence between __u32 and u32 types, something to clean
up if you post v5
