Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1140C60334E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJRTVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJRTVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E7412AE0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54205616DA
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A58C433C1;
        Tue, 18 Oct 2022 19:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666120873;
        bh=AQ4yB5Ac7ETTgAmEBRKy2WlBUrbMZ1TtZeZz1xVByU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISTTBdpU+cHma5SnbaIVWgRj+lX/ZmIkrgZHgOYkMUAC9fJHg99Eq3F/W8jw0VmoA
         9BShnifPmNRs7b6oVE3abXn3Nt1aoSgq6QkTJpmk/P1GL9B/T1qXzOwybnyQoyP3bo
         AmJzLUL4X4l+TrNMaYxWAwxqhdpSFWXYL4SO74e4EoJbyJieE8tj22coI2tmYL8BAP
         Qu4NMX6dlnGh6gZWE/igyDyQdxaIusPkaDHMUV86ggqZiyIefZhfmvl3jQF25IWHwB
         8vxT+p41V4fz7JTD4NDy+Dxm6RbqECJYDYuOI6kRzGwFPPqVSysKJMMcdDvALhT+CD
         CsNf49Z6FN1zA==
Date:   Tue, 18 Oct 2022 12:21:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 00/19] bridge: mcast: Extensions for EVPN
Message-ID: <20221018122112.7218792b@kernel.org>
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 15:04:01 +0300 Ido Schimmel wrote:
> 	[ MDBE_ATTR_SRC_LIST ]		// new
> 		[ MDBE_SRC_LIST_ENTRY ]
> 			[ MDBE_SRCATTR_ADDRESS ]
> 				struct in_addr / struct in6_addr
> 		[ ...]

nit: I found that the MDBE_ATTR_SRC_LIST level of wrapping corresponds
to how "sane" formats work, but in practice there is no need for it in
netlink. You can put the entry nests directly in the outer. Saves one
layer of parsing. Just thought I'd mention it, you can keep as is if
you prefer.
