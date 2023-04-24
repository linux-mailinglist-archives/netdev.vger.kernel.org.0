Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED056ED6C0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjDXV2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjDXV2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0701761A4
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96ADC61C12
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3819C433EF;
        Mon, 24 Apr 2023 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682371681;
        bh=TbcvORIahzTgLz3kHT93WfnWCDehULA/wN2t4cFpWu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fKCN800jVi4eb9DDyPNBVyG1nVaxWg8SobzwUe9FY691TiFhtJm9hkMxHEOwlgTZU
         35O9gfDi7RRePr3N4hRuha7B/lmVQcNLeuptx760LJpoegnA5n6pK5fP1I4pCK2aBo
         QNIxAZtIcbS3y+HLydEkj0I1KxVtezePqGZBStrLJMlN6BS1b0aXb84pfim3R5eiUO
         +XElV9jbuHXzvV4LDKB7de7f23Cz5bGWIq3BhwbtEYfrfoFfyXPv31ex57QzA7RD+e
         HNxFZ+iVjRRdY8iJ7yao0pi4NhQh1IbP/2X7jdCxhPw+LhhSzn3afLHGu1XXrHVU97
         5972nIC3ZEwdQ==
Date:   Mon, 24 Apr 2023 14:28:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [Question] Any plan to write/update the bridge doc?
Message-ID: <20230424142800.3d519650@kernel.org>
In-Reply-To: <ZEZK9AkChoOF3Lys@Laptop-X1>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 17:25:08 +0800 Hangbin Liu wrote:
> Maybe someone already has asked. The only official Linux bridge document I
> got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
> many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
> document about each parameter? The parameter showed in ip link page seems
> a little brief.
> 
> I'd like to help do this work. But apparently neither my English nor my
> understanding of the code is good enough. Anyway, if you want, I can help
> write a draft version first and you (bridge maintainers) keep working on this.
> 
> [1] https://wiki.linuxfoundation.org/networking/bridge
> [2] https://man7.org/linux/man-pages/man8/bridge.8.html
> [3] https://man7.org/linux/man-pages/man8/ip-link.8.html

Sounds like we have 2 votes for the CLI man pages but I'd like to
register a vote for in-kernel documentation.

I work at a large company so my perspective may differ but from what 
I see:

 - users who want to call the kernel API should not have to look at 
   the CLI's man
 - man pages use archaic and arcane markup, I'd like to know how many
   people actually know how it works and how many copy / paste / look;
   ReST is prevalent, simple and commonly understood
 - in-kernel docs are rendered on the web as soon as they hit linux-next
 - we can make sure documentation is provided with the kernel changes,
   in an ideal world it doesn't matter but in practice the CLI support
   may never happen (no to mention that iproute does not hold all CLI)

Obviously if Stephen and Ido prefer to document the bridge CLI that's
perfectly fine, it's their call :) For new sections of uAPI, however,
I personally find in-kernel docs superior.
