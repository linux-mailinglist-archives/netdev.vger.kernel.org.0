Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9F633447
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiKVD6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVD6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:58:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97AFFD2C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C082FCE1B0E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849D2C433C1;
        Tue, 22 Nov 2022 03:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669089491;
        bh=ixZWujkQ/yRUQY7MyRV4oWkapzIVFXvITTN/WUveFak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RRj0cIzQp7sx2rVyxuFHrOpNZl0K2dYkIpmt7DDNxqcg5vMzTuuT57IjJwP8n5z8A
         36Ha6oUmJ5OpGO86+gkt/RI8e8ogfdAdi5HQcjCauVRDselkj6tt7R6kreBMTqRl6f
         o49Fqhbn7lKP6ljnH/bf1vdbjttxMfyEaF11qPu4pfzMLnZa5b1URG3/8PaEwHnrdg
         1zrOgy/zQ4KK2Wdnaeonomxdgrgn/vrIY17IIluYzJrqI804c0bGvWkaNjvgrVWLVL
         ZbXk/1X6xLQYoQcTstm+I1gjBLk3MEiBAKNC7lXjSoCpsipDBj1NaM1Ndfpn4ls1DZ
         3EGvdw4vccpOQ==
Date:   Mon, 21 Nov 2022 19:58:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com,
        vladimir.oltean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <20221121195810.3f32d4fd@kernel.org>
In-Reply-To: <20221118232639.13743-1-steve.williams@getcruise.com>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 15:26:39 -0800 Steve Williams wrote:
> This is a virtual device that implements support for 802.1cb R-TAGS
> and duplication and deduplication. The hanic nic itself is not a device,
> but enlists ethernet nics to act as parties in a high-availability
> link. Outbound packets are duplicated and tagged with R-TAGs, then
> set out the enlisted links. Inbound packets with R-TAGs have their
> R-TAGs removed, and duplicates are dropped to complete the link. The
> algorithm handles links being completely disconnected, sporadic packet
> loss, and out-of-order arrivals.
> 
> To the extent possible, the link is self-configuring: It detects and
> brings up streams as R-TAG'ed packets are detected, and creates streams
> for outbound packets unless explicitly filtered to skip tagging.

Superficially pattern matching on the standard - there has been 
a discussion about 802.1cb support in the HW offload context:

https://lore.kernel.org/netdev/20210928114451.24956-1-xiaoliang.yang_1@nxp.com/

Would be great if the two effort could align.
