Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A74D54FD
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbiCJXGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344517AbiCJXGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:06:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5169184B73
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F8BAB82918
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA1C340E9;
        Thu, 10 Mar 2022 23:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646953501;
        bh=s09R21M7zXz2E8tlrMCv+0W4gUBqIAa4O6HDi9tYH7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DQTd+lByYqZzRooQSmFnyoRCSLIdeoiXac8B37xt4OKtKOLFTLfvcPP2KiPv6KUED
         /XCcPTVA3yFH2xS8koM4myq4l3HHbQeCsCPqyTBBzltfvylNRGZAEqAhySb9MS8XQx
         5Bma/1RWIP8X1lgZl4eF5YywKmGeRi7u4XeYqtPoTlqed3OhFt4tWlQ9cL+RHaI6rT
         IcMY7Vk+3rypHsdbQJiSxb3Vx2OB1YIC4VA2BSbb1hV769m6lnb2tK6NFSl24P+tE+
         KBDssvIOHpcRDSNQbBPNF7lRbO4Zux4uI6x9axbIns4qP3YskdoOYl40UezWV4I0JL
         aJsrol1jBsQ5w==
Date:   Thu, 10 Mar 2022 15:05:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] alx: acquire mutex for alx_reinit in alx_change_mtu
Message-ID: <20220310150500.38ae567c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310161313.43595-1-dossche.niels@gmail.com>
References: <20220310161313.43595-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 17:13:16 +0100 Niels Dossche wrote:
> alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
> alx_reinit is called from two places: alx_reset and alx_change_mtu.
> alx_reset does acquire alx->mtx before calling alx_reinit.
> alx_change_mtu does not acquire this mutex, nor do its callers or any
> path towards alx_change_mtu.
> Acquire the mutex in alx_change_mtu.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

What's the Fixes tag?
