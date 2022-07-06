Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F22567B77
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiGFBZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFBZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278F11835B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B670C615B1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 01:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FB8C341C7;
        Wed,  6 Jul 2022 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657070714;
        bh=FOCiKQY9ptUqWlgKPf4BBHEJiFm39SVkRETZWIH55gs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bWGiMx0BAqtgHTm2zIwluK4bpweprqoHBZLV92MGxC3cx5eqlXK/ZPKqcGN+pd0jy
         TBqufr7ItDiqJaOIBntDYbt0zo/LYDci38Rl9zslv6Ew8ZFf5UIbbEhp4iwV7hsVcH
         F8E/BUHTCk7b4FrIOeWs/OJ2/yN65A6T99k5MHJ+8a0oO8Tlb1n9fvn8qV00ngBOSI
         RiAPca6hfGXN0F0wQ2QxTNT+yGF9EsCmOBv9A+5wkGePCUD2QavyhJp1wzb80uRYn3
         C/Dmar3eD4sZENSTu3/Qt+dA0TsKzDdDhxB60MW+zNNFoxMM8Cp89aquxhLygwomsy
         1X8zdiRg1c+Tg==
Date:   Tue, 5 Jul 2022 18:25:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220705182512.309f205e@kernel.org>
In-Reply-To: <20220705145441.11992-1-matthias.may@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please make sure to CC folks pointed out by scripts/get_maintainer.pl

On Tue, 5 Jul 2022 16:54:42 +0200 Matthias May wrote:
> Subject: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP frames

net-next may be more appropriate, since this never worked.
Unless it did, in which case we need a Fixes tag.

> The current code allows to inherit the TOS, TTL, DF from the payload
> when skb->protocol is ETH_P_IP or ETH_P_IPV6.
> However when the payload is VLAN encapsulated (e.g because the tunnel
> is of type GRETAP), then this inheriting does not work, because the
> visible skb->protocol is of type ETH_P_8021Q.
> 
> Add a check on ETH_P_8021Q and subsequently check the payload protocol.

Do we need to check for 8021AD as well?

> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
>  net/ipv4/ip_tunnel.c | 21 +++++++++++++--------

Does ipv6 need the same treatment?
