Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8398461FA5F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiKGQst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiKGQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:48:47 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F411D8D
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:48:45 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2A7Gmb6d636217;
        Mon, 7 Nov 2022 17:48:37 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2A7Gmb6d636217
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1667839718;
        bh=0dxGU8ZPgud1rLiAsOLvm3UVyF8KJb29SeTbBtLLeoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nKDjxuebwUt3X+blnJd1SWmCK4WdavUeA9qA+T2GHpBIji4NZsjxHTk6se4eJ5NHl
         0tmrZbpvMcnRvIm8/qpHoXVLg1zvWQsAIyf6WzVe+h3mO0s64aMnQ56/RRo8VhOX20
         tR9VYBFTqh1Tj3BAQN4+PelotrpqU3wNc89hcUe4=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2A7GmbGu636216;
        Mon, 7 Nov 2022 17:48:37 +0100
Date:   Mon, 7 Nov 2022 17:48:37 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     netdev@vger.kernel.org
Subject: Re: NET_RX_DROP question
Message-ID: <Y2k25U/KkF1HKox3@electric-eye.fr.zoreil.com>
References: <7dceaec046d54e8db9cefb2e3b198f25765f6d8e.camel@infinera.com>
 <db2af4c2d70fb2582fbf5e27a31052d9d9c57953.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db2af4c2d70fb2582fbf5e27a31052d9d9c57953.camel@infinera.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joakim Tjernlund <Joakim.Tjernlund@infinera.com> :
[...]
> Looking into drivers/net/ethernet is seems just a few checks if (netif_receive_skb(skb) == NET_RX_DROP),
> the majority does not which makes me this I should just drop this check.
> 
> Confirmation more than welcome.

The driver should not maintain stats for packets dropped by
the core network. They are already accounted for in core stats
(include/linux/netdevice.c::struct net_device.core_stats).

-- 
Ueimor
