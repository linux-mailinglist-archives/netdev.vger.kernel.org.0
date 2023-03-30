Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020696CF967
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjC3DEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3DEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4524EFC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A63661EBB
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BD2C433D2;
        Thu, 30 Mar 2023 03:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680145444;
        bh=bmOrKU/nzFYLkXC2fA27BNW1yuYm9r77HWjhle3CrAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YoDFjHHD96B33DUsd/+FglmrrIlYJ4qjXXN/3GPOZGuaR4z8+ECGxJsoEip8rsn8z
         /J4/HgHLKM5cZ0sLvL7L7ckrMSZXM2NRrKoO3mN7mDeoWre/RIsEnPj0Qy5yCqOIOy
         31iJzDjRRnrvUGY1NveMo+Y4CTmaC8CCrgMEstfP1KBJdRfdzGqJ3Ac8fbhQyb7Xhd
         L4j+gTCcX+2/u4Wawb/NdUDQPTcPm+Nzh8gJt6cknPmgCV2lO8U7+9gaee5rdgKNwD
         3BnYNpaMi9m9ZWmJB1k5z+D/IUdI9BcXP1hq6w3IEBkqlCC8vWEpewfBmeDGtXgq/H
         Kn775qtrMpSzA==
Date:   Wed, 29 Mar 2023 20:04:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Message-ID: <20230329200403.095be0f7@kernel.org>
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
References: <20230328235021.1048163-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 23:50:17 +0000 Eric Dumazet wrote:
> Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> invocations.

small clarification on the testing:

invocations == calls to net_rx_action()
or
invocations == calls to __raise_softirq_irqoff(NET_RX_SOFTIRQ)

?
