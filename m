Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A1629167
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKOFLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKOFLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3041DF19
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C62B810F7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BD1C433D6;
        Tue, 15 Nov 2022 05:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668489098;
        bh=wwbcULU5s2q+hpuNfP6yV3jjdUmRRsOzxk8zqSEySMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H/BOTzcMAmJSsw097LD06nAIRnBZ1l8rpc6A7UBpACccjZyfY2Ni5ddcyTduZpPXn
         HNxseLncaL2sVO1PvX+2mPcEOHdPAUcYT3FYXV+eaU5CSaWa/EX2QOYzQaIxDYoN9K
         ThEyCBkFUJcCTUkkd6K9WhUS9WZvsbALSdWX4C6SmGCwzcIsyRnadr5AweL8ps6ldZ
         OtE0j2F12/0jS4JxPF9yq/9FDkrMamukwqR8iQdOL1FR15QDZFjjlF5aGHml4g4yyV
         QsvI1Fyuvn6K5AaVgfVm5u1gUhd11lffrKQEMItcsWdytUlJcG+jUronQZWjz7cg4J
         Wi0taYoSDQ+XA==
Date:   Mon, 14 Nov 2022 21:11:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v11 08/11] ice: Implement devlink-rate API
Message-ID: <20221114211137.2852a1fe@kernel.org>
In-Reply-To: <20221114173138.165319-9-michal.wilczynski@intel.com>
References: <20221114173138.165319-1-michal.wilczynski@intel.com>
        <20221114173138.165319-9-michal.wilczynski@intel.com>
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

On Mon, 14 Nov 2022 18:31:35 +0100 Michal Wilczynski wrote:
> There is a need to support modification of Tx scheduler tree, in the
> ice driver. This will allow user to control Tx settings of each node in
> the internal hierarchy of nodes. As a result user will be able to use
> Hierarchy QoS implemented entirely in the hardware.
> 
> This patch implemenents devlink-rate API. It also exports initial
> default hierarchy. It's mostly dictated by the fact that the tree
> can't be removed entirely, all we can do is enable the user to modify
> it. For example root node shouldn't ever be removed, also nodes that
> have children are off-limits.

drivers/net/ethernet/intel/ice/ice_devlink.c:794: warning: Function parameter or member 'bw' not described in 'ice_set_object_tx_share'
drivers/net/ethernet/intel/ice/ice_devlink.c:818: warning: Function parameter or member 'bw' not described in 'ice_set_object_tx_max'
drivers/net/ethernet/intel/ice/ice_devlink.c:842: warning: Function parameter or member 'priority' not described in 'ice_set_object_tx_priority'
drivers/net/ethernet/intel/ice/ice_devlink.c:871: warning: Function parameter or member 'weight' not described in 'ice_set_object_tx_weight'

Feel free to post a v12 with these fixed, I'll review the latest
tomorrow.
