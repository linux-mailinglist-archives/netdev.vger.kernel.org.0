Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26F25A074F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiHYChH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHYChH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C7785B4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE02B82731
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5979EC433C1;
        Thu, 25 Aug 2022 02:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395023;
        bh=UdTUT4gPg8bTrUEOlzuRwwP84GRDowMqWLe30HATU8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dWo3tJW+9H0W7tpfWlVRunmYLt2N6FYG9w2B4vw4ldqjL3u+FUxI4xzLywIJH2c8u
         r+7l3yLI0rInQ5l+j/i4Wz1QzPSpA/5lrQI2pCqdXzeUjKB6sNdSje8HzbngypbQEk
         xLn4lltcrP5MJaqP3FpYjzy9f3ztK3NgNLS/RioPpcpP9CyuP/ijIsvQiGEe0RakEE
         BXZ5aYFdgcD9iDcsq5O29dv0olgaAel343q6QDHCl50O3XiK4AIaDr8GQERnvNIBcU
         +DIIQxskdZ/45gWOnG6iybon2wxKBZFvBNEeE8/9w9Xggt/z1LxnimhF/nClmFFSv9
         ZTxlK1jnW3DsA==
Date:   Wed, 24 Aug 2022 19:37:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH V2] octeontx2-pf: Add egress PFC support
Message-ID: <20220824193702.21b14336@kernel.org>
In-Reply-To: <20220824060006.1430587-1-sumang@marvell.com>
References: <20220824060006.1430587-1-sumang@marvell.com>
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

On Wed, 24 Aug 2022 11:30:06 +0530 Suman Ghosh wrote:
> As of now all transmit queues transmit packets out of same scheduler
> queue hierarchy. Due to this PFC frames sent by peer are not handled
> properly, either all transmit queues are backpressured or none.
> To fix this when user enables PFC for a given priority map relavant
> transmit queue to a different scheduler queue hierarcy, so that
> backpressure is applied only to the traffic egressing out of that TXQ.

clang says:

drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c:129:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
        int err;
            ^
