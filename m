Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243DB53D65C
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 12:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiFDKIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 06:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiFDKIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 06:08:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0125717A9A
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 03:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB661B8013C
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 10:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE0C385B8;
        Sat,  4 Jun 2022 10:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654337285;
        bh=rzvemic7CHLLrkHDuGNJ3L+9QlCtl0fr4DZR83NbFz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WhlWXZ4VN28zZIpmpBQdx90nWUvaYPYPZN/pDcjgjqPESoN73Kup28+Uk3aO0Atb/
         I/nXUDo6krip1WvKTNEapEVeUw8AmYh9hcaQPmfq+41LXquPFUcz1j2X4Jyv/LBpHu
         imBEORvzpIgMWi5YKE4wMKZi3I+CBOdxs3nkfzGI=
Date:   Sat, 4 Jun 2022 12:08:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] Backporting "add second dif to raw, inet{6,}, udp,
 multicast sockets" to LTS 4.9
Message-ID: <YpsvAludRUxuK22U@kroah.com>
References: <YppqNtTmqjeR5cZV@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YppqNtTmqjeR5cZV@pevik>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 10:08:22PM +0200, Petr Vorel wrote:
> Hi all,
> 
> David (both), would it be possible to backport your commits from merge
> 9bcb5a572fd6 ("Merge branch 'net-l3mdev-Support-for-sockets-bound-to-enslaved-device'")
> from v4.14-rc1 to LTS 4.9?
> 
> These commits added second dif to raw, inet{6,}, udp, multicast sockets.
> The change is not a fix but a feature - significant change, therefore I
> understand if you're aginast backporting it.
> 
> My motivation is to get backported to LTS 4.9 these fixes from v5.17 (which
> has been backported to all newer stable/LTS trees):
> 2afc3b5a31f9 ("ping: fix the sk_bound_dev_if match in ping_lookup")
> 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
> cd33bdcbead8 ("ping: remove pr_err from ping_lookup")
> 
> which fix small issue with IPv6 in ICMP datagram socket ("ping" socket).
> 
> These 3 commits depend on 9bcb5a572fd6, particularly on:
> 3fa6f616a7a4d ("net: ipv4: add second dif to inet socket lookups")
> 4297a0ef08572 ("net: ipv6: add second dif to inet6 socket lookups")

Can't the fixes be backported without the larger api changes needed?

If not, how many commits are you trying to backport here?  And there's
no need for David to do this work if you need/want these fixes merged.

thanks,

greg k-h
