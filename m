Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592D35F02E2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiI3Chg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3Chf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:37:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0BA17F566
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2BE7B826C8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131CBC433C1;
        Fri, 30 Sep 2022 02:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505452;
        bh=nWpRYd5jKvZHRVH+zTz0RvJiOg0OCVIGJBYtkHHyZ0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GdvNYKuSPs9LVD7J0nXZEHVzZJnsq4vFFDkF5oT6VEqNu6SkQK20Iw8BXamKQxVhR
         I0ly7Aj3DBJT/qCuBarSfTaUM3cIyescrPp6n2R8P55Sz3PGUac2+KcZcwj9t9eY0z
         9EMjaOi4XbDhQ6r1mZAhCVaPEvrTh4nYVnbFJFsl3OrW5gNYCxMHHFnRv/ru1svtC4
         jJPKvkHQ0aJP2trt/nD1pN4F2HjEQ50l0U43OuvlITQOF7wy0u7hDdyYAskvZTYnkG
         EvMiMIexijNPplj+8IrDBjOZhgnQsBf0UxW6fXNC4rqW+PAblxOc707oxuW1r0nlRi
         87qCvtxForl/g==
Date:   Thu, 29 Sep 2022 19:37:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/5] tcp: add sysctls for TCP PLB parameters
Message-ID: <20220929193731.2fa59ca9@kernel.org>
In-Reply-To: <20220929142447.3821638-2-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
        <20220929142447.3821638-2-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 14:24:43 +0000 Mubashir Adnan Qureshi wrote:
> PLB (Protective Load Balancing) is a host based mechanism for load
> balancing across switch links. It leverages congestion signals(e.g. ECN)
> from transport layer to randomly change the path of the connection
> experiencing congestion. PLB changes the path of the connection by
> changing the outgoing IPv6 flow label for IPv6 connections (implemented
> in Linux by calling sk_rethink_txhash()). Because of this implementation
> mechanism, PLB can currently only work for IPv6 traffic. For more
> information, see the SIGCOMM 2022 paper:
>   https://doi.org/10.1145/3544216.3544226
> 
> This commit adds new sysctl knobs and sets their default values for
> TCP PLB.

please try to build each individual patch, this one breaks build:

net/ipv4/tcp_ipv4.c:3225:47: error: use of undeclared identifier 'TCP_PLB_SCALE'
        net->ipv4.sysctl_tcp_plb_cong_thresh = (1 << TCP_PLB_SCALE) / 2;
                                                     ^
