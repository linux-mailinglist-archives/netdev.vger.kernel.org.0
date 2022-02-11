Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BF44B3191
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245294AbiBKX5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:57:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiBKX5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:57:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA6B1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D1AF61B80
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 23:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D7C340E9;
        Fri, 11 Feb 2022 23:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644623860;
        bh=hD+6UluUH5CNsByj7Rhmi+b/TAuAACuKMz4fOL9DrPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Px3IFf7FVLNAp8TCUWPS2HXbDljCBxGx8HzDdf7l322MmaZ6PjEPawsij32tdy6MS
         xmXmoa+qvl0Fl+LrJi3qXDS9lvpkwR0p5Rw/j0foirgjkKViCrijVSOt5OcDPAdSFQ
         HnZ0dRornZ7wfrqdp1URiBQ6VyVA5gDNbakgi6bd686dOC5i03g9nG8M6/TnLvTChb
         R9lOXULAz4vujaIJtZIzfIRqDnDFSQ7FHKwUkDOWz1VzcMLTxA4tXGVO5Dgf71Wm5P
         /vFl9TQd5x6xznKYlYedVA/lTMsG7qpMmsXGBCepy3kLTu9D/gLN4Y+X6ZNmqkWp+l
         UftwBbR5UrI0g==
Date:   Fri, 11 Feb 2022 15:57:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH net-next 0/4] ipv6: remove addrconf reliance on loopback
Message-ID: <20220211155739.66f5483b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 13:42:27 -0800 Eric Dumazet wrote:
> Second patch in this series removes IPv6 requirement about the netns
> loopback device being the last device being dismantled.

Great!

> This was needed because rt6_uncached_list_flush_dev()
> and ip6_dst_ifdown() had to switch dst dev to a known
> device (loopback).
> 
> Instead of loopback, we can use the (hidden) blackhole_netdev
> which is also always there.
> 
> This will allow future simplfications of netdev_run_to()

Should I take a stab at it, or is it on your todo list, anyway?

> and other parts of the stack like default_device_exit_batch().
> 
> Last two patches are optimizations for both IP families.
