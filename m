Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2771F6102B5
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiJ0UbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiJ0UbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC02E8E7BC;
        Thu, 27 Oct 2022 13:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 687FB624B7;
        Thu, 27 Oct 2022 20:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F86C433D6;
        Thu, 27 Oct 2022 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666902670;
        bh=AJNndJ91MPb3zq8Ma62RsePdrRlbwPk1VLx6LAAUzpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eGymNsA4vtA/K8wl+H1jrKiIuStFKSxZS1DxD5GlU2Cw/dfonwWKq81dSHmjmCbAw
         wZTIQe0kOKYtk4Rrd/qIIGoF2avZIw3ohmilqWNQrORPK4A524SJUbyFpTJR9cDT0k
         CE2Nf+OMAsQRBN84CWtZnJ63gPIjg0yh7eVuBfHaCj14u9ngZpvOjFh7APi3nltEg0
         jnF+JvEeIO7Bt/5j/5OhDc37XdBMYZi76vpeZeRt8x3EwSr/rZKKY+ssequKp+i+Jl
         Pw/Ksh24Bot64jpxCcRjKgMTE+H51jMx+WhOl8s8cewphU79dZFeEeeb1aKXfE7V2h
         o2u8TEKMUBLkg==
Date:   Thu, 27 Oct 2022 13:31:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Message-ID: <20221027133109.590bd74f@kernel.org>
In-Reply-To: <20220905100937.11459-2-fw@strlen.de>
References: <20220905100937.11459-1-fw@strlen.de>
        <20220905100937.11459-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Sep 2022 12:09:36 +0200 Florian Westphal wrote:
>  		struct {
>  			s16 min, max;
> +			u8 network_byte_order:1;
>  		};

This makes the union 64bit even on 32bit systems.
Do we care? Should we accept that and start using
full 64bits in other validation members?

We can quite easily steal a bit elsewhere, which
I reckon may be the right thing to do, but I thought
I'd ask.
