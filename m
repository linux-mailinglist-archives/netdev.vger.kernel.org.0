Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA306517A6
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiLTBO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiLTBOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:14:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C7175B6;
        Mon, 19 Dec 2022 17:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC2EDB80F9B;
        Tue, 20 Dec 2022 01:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE75C433F0;
        Tue, 20 Dec 2022 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671498803;
        bh=GhvR/+DG+rgM08a/7XAG0bKpkCNp0hJgF6NxkYUzmDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kHHwVJlX7XGbfdBf/t7Y6+zrIB5I/9waRcwcxJaY91y93RDnYJgwsudGZbuLbbAv4
         ZoDGqKe+m+WaGVO2aixhOlNDH2wTBVGL0KCIU12TVOhubLPgET+Kih+UEn+B7Snx+v
         dy3a2L2yrYdiBdrsI3n9Hdkp2YRUFGBE0VY7OZGz2TX1rpG6g6bx18AIrsh9VmrT/D
         b3WW5GykoiDyk3cHupelEHHoax6frsLvY0T5wJqBm+AeBp3SH79SkcUsCr0/hrungq
         oFoWkbgpERG8hzXa4qxTSHmX4iGsrICDhQRD4c4NKiWNe80ZeqZuWtv/9sBfqcBJlq
         Ki5bdWysGMj9w==
Date:   Mon, 19 Dec 2022 17:13:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
Message-ID: <20221219171321.7a67002b@kernel.org>
In-Reply-To: <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
References: <cover.1671462950.git.lorenzo@kernel.org>
        <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
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

On Mon, 19 Dec 2022 16:41:31 +0100 Lorenzo Bianconi wrote:
> +=====================
> +Netdev XDP features
> +=====================
> +
> + * XDP FEATURES FLAGS
> +
> +Following netdev xdp features flags can be retrieved over route netlink
> +interface (compact form) - the same way as netdev feature flags.

How likely is it that I'll be able to convince you that cramming more
stuff in rtnl is a bad idea? I can convert this for you to a YAML-
-compatible genetlink family for you in a jiffy, just say yes :S

rtnl is hard to parse, and already overloaded with random stuff.
And the messages are enormous.

> +These features flags are read only and cannot be change at runtime.
> +
> +*  XDP_ABORTED
> +
> +This feature informs if netdev supports xdp aborted action.
> +
> +*  XDP_DROP
> +
> +This feature informs if netdev supports xdp drop action.
> +
> +*  XDP_PASS
> +
> +This feature informs if netdev supports xdp pass action.
> +
> +*  XDP_TX
> +
> +This feature informs if netdev supports xdp tx action.
> +
> +*  XDP_REDIRECT
> +
> +This feature informs if netdev supports xdp redirect action.
> +It assumes the all beforehand mentioned flags are enabled.
> +
> +*  XDP_SOCK_ZEROCOPY
> +
> +This feature informs if netdev driver supports xdp zero copy.
> +It assumes the all beforehand mentioned flags are enabled.

Why is this "assumption" worth documenting?

> +*  XDP_HW_OFFLOAD
> +
> +This feature informs if netdev driver supports xdp hw oflloading.
> +
> +*  XDP_TX_LOCK
> +
> +This feature informs if netdev ndo_xdp_xmit function requires locking.

Why is it relevant to the user?

> +*  XDP_REDIRECT_TARGET
> +
> +This feature informs if netdev implements ndo_xdp_xmit callback.

Does it make sense to rename XDP_REDIRECT -> XDP_REDIRECT_SOURCE then?

> +*  XDP_FRAG_RX
> +
> +This feature informs if netdev implements non-linear xdp buff support in
> +the driver napi callback.

Who's the target audience? Maybe FRAG is not the best name?
Scatter-gather or multi-buf may be more widely understood.

> +*  XDP_FRAG_TARGET
> +
> +This feature informs if netdev implements non-linear xdp buff support in
> +ndo_xdp_xmit callback. XDP_FRAG_TARGET requires XDP_REDIRECT_TARGET is properly
> +supported.
