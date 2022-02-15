Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6E4B6251
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiBOFNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:13:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBOFNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:13:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5288DD04B2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 21:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0D5061331
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0486AC340F0;
        Tue, 15 Feb 2022 05:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644901990;
        bh=5G1G+iYda0ASt2hoy/703UMcV7F/fJHwIIgyIs2HQ98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MqFqeMqptslXxyLRQR+fn0lmy5fzANcj33vTrFvQIuslIPE3p7WheSnyQqIMF0Z8B
         TX4liZDUUDGGLdD8J8LxNjK3lGkNN9Sh/ICYMCnUzb4J7qwJTSNDYjg7s2GYEwZURu
         7HshVtxvfyBINL5dxW78vwy+4SAdhF6HNzMJd1vGCWcKaAGxukfbsOdSXfdU/cBMft
         yaylW0h6CX7XPBySjJSsyJuthyyFk9cPyQXs0aHF+fgoaKA5blcN+K2F7Ug5GOa8YL
         ZZrhLDtthSqP6m/hGq0TYbLnqkUFfuGTn2czrr1MtqJxw+EsC21j8rFlRHIYJO+MQ6
         s6qAfFupCaOmw==
Date:   Mon, 14 Feb 2022 21:13:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: bridge: multicast: notify switchdev driver
 whenever MC processing gets disabled
Message-ID: <20220214211309.261bd9d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
References: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 15:14:26 +0200 Oleksandr Mazur wrote:
> Whenever bridge driver hits the max capacity of MDBs, it disables
> the MC processing (by setting corresponding bridge option), but never
> notifies switchdev about such change (the notifiers are called only upon
> explicit setting of this option, through the registered netlink interface).
> 
> This could lead to situation when Software MDB processing gets disabled,
> but this event never gets offloaded to the underlying Hardware.
> 
> Fix this by adding a notify message in such case.

Any comments on this one?

We have drivers offloading mdb so presumably this should have a Fixes
tag and go to net, right?
