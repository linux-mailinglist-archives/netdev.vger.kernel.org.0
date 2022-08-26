Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6F5A1F24
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbiHZCzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiHZCzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219846DB8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49E69B82F6F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91241C433C1;
        Fri, 26 Aug 2022 02:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661482545;
        bh=I5N79F7+BLf82xHhIb4vxpnjgYawbxi0wnEfhL28cQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/HgFtyxb1P8Q6BI7QcK8mQQutQ4vL1YsSbi0tOJl4p5neP/B2zhIGjEjoBcXhfgK
         rlcQ7IGU2hoLYkVxo8NwSpwxNMlAlEGDvrhalGKCGxZN2ul7WvqArko3VvWi4B3KhX
         vXcvYIJ8dVDepqy0b3G/2GAPwOb3R9oET/LBIPMQbpXxY58FCCbZDaaGjgQI1qn3LA
         Z0YtaBrSEj+xIflIvR5HmveWQ6R3dO0mQJLZ2INsw7PPcPjkQCZ/sxc2W8pziIaJ41
         UgubSag2Fz9getV++ZMf8rVm0BB90FNwFKrOA+254sNVMkCpfGvj7DZL5TMqNiYuq2
         D1OIxpgD2Uwvw==
Date:   Thu, 25 Aug 2022 19:55:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH V3] octeontx2-pf: Add egress PFC support
Message-ID: <20220825195544.391577b2@kernel.org>
In-Reply-To: <20220825044242.1737126-1-sumang@marvell.com>
References: <20220825044242.1737126-1-sumang@marvell.com>
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

On Thu, 25 Aug 2022 10:12:42 +0530 Suman Ghosh wrote:
> As of now all transmit queues transmit packets out of same scheduler
> queue hierarchy. Due to this PFC frames sent by peer are not handled
> properly, either all transmit queues are backpressured or none.
> To fix this when user enables PFC for a given priority map relavant
> transmit queue to a different scheduler queue hierarcy, so that
> backpressure is applied only to the traffic egressing out of that TXQ.

Does not build at all now:

ERROR: modpost: drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf: 'otx2_pfc_txschq_update' exported twice. Previous export was in drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicpf.ko
ERROR: modpost: "otx2_txschq_config" [drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
ERROR: modpost: "otx2_smq_flush" [drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
