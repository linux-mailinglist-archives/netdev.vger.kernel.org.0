Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD67160ED65
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiJ0BYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiJ0BYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:24:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A305FAE
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 18:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C903C620EE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC033C433C1;
        Thu, 27 Oct 2022 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666833868;
        bh=VkD9IU0Jd4FBojtXNYs9uQcoKw7tHbgBC4eBiz1pmz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHL7jVTUMuDbiTOhQy/FoidGRcEMaR/GRT1JGxIaEe0W0gfcBY3Ws92zGDjHBNYuJ
         iSDjQ7AJYj20sToolMcvmEC8vhlEJuFbDZu8UM0FRxbO8jEDbsfv43dOqx3q2/Ywap
         J8t0LlWZ7v/FXV4K+4WhYgXHG5JgK/rKoI6izZ588yNKgGZD0i2DiKxEWu+FewIvXv
         hPtzuvmSt18Hi1GcUih7PY8McoEsgoFOgSNxyAgle/jb4CMB3lIwZKVpZifeAUJ6UU
         D099xA68GBtilN4ICFERwMGMC5OE31AgBr1ArrfLO/Mq0rtAaR3ZP7tSyc7OxRku/H
         hymya/NIfHEfQ==
Date:   Wed, 26 Oct 2022 18:24:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <20221026182426.2173105d@kernel.org>
In-Reply-To: <CAHo-Ooy5JB-0R5ZNMmEXaPfGjWKBw8VdXVp0d-XW2CNeO6u34A@mail.gmail.com>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
        <CAHo-Ooy5JB-0R5ZNMmEXaPfGjWKBw8VdXVp0d-XW2CNeO6u34A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 17:42:37 +0900 Maciej =C5=BBenczykowski wrote:
> I'll admit that so far I've only tested that the code builds.

For _a_ definition of builds ;)

ERROR: modpost: "xfrm4_udp_encap_rcv" [net/ipv6/ipv6.ko] undefined!
