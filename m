Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A048955027E
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiFRDas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiFRDar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:30:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7B6A018
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B78AEB82D1F
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0F5C3411B;
        Sat, 18 Jun 2022 03:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655523044;
        bh=GqBOMWBxIpMGlpl+R+6LQY1vab0BuyKpNz8DkCl5pV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVtDMyt1SC+SSYyDSBhgsXXb6RmslvNpmGMz37WE2AMEXjDKj/v22RmAVEX8rZHAL
         McRSBkREzR9j/NbeeTsNFufqQxKkOXXnG5aJN427Daivebk7AniurPRwLgVOIvxQ5Q
         rO+AB9kDq9gd9tTFG5WV1YL1+gYubU/YtQE4/GhPS/qpAwwr4Lx5lo653EqFqzMcw4
         7nhDI+WeR9062/UTuXJmmeQukFb8lNlzl5EWD6fsyYZgupNWVVoC2Rk54J81isiba8
         WYy1ayVUzJvBWShhNCGIQ4YHOAuczd4i8htUAkAUF3mkd+Gn4ApWELlYhFQKzqsM42
         b/Djr8hh598Uw==
Date:   Fri, 17 Jun 2022 20:30:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        brouer@redhat.com, anthony.l.nguyen@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        magnus.karlsson@intel.com, sven.auhagen@voleatech.de
Subject: Re: [PATCH net] igb: fix a use-after-free issue in
 igb_clean_tx_ring
Message-ID: <20220617203042.33d3a124@kernel.org>
In-Reply-To: <20220617201644.368bab1b@kernel.org>
References: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
        <f137891f-eb33-b32b-5a16-912eb524ddef@intel.com>
        <108bf94b-85a6-98d4-175b-2c0d43e17b11@redhat.com>
        <20220617201644.368bab1b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 20:16:44 -0700 Jakub Kicinski wrote:
> It got marked as Awaiting Upstream so the bot won't respond.

Ooo, the bot got changed!
