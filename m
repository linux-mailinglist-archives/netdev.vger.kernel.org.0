Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8665271C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiLTTgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiLTTgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:36:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4FE1021;
        Tue, 20 Dec 2022 11:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8038761583;
        Tue, 20 Dec 2022 19:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4936EC433EF;
        Tue, 20 Dec 2022 19:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671564972;
        bh=5i5tZcR0DoYMnhmB8mGmz6H6Gh3tfK0AahqQF+YC/Xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c5+XeIXTx1CrKCLLk+aJgr4h+8Hg2lGc1Oc9YmkQWfFJf9FfdhXnu8Cl89nEBYCcH
         S6/LU5Vh+Les9mngc4IY96mZXDAdvpaYOws6vYz5q2u9yLj87wPWdKB1LH1VJBhCiX
         FeYfCaCWXPPrw/C3OmzNIEgBPin6LhwVlERsO5DplWG9Y3IuUX4UlGlSqViJtCjSUD
         sCWAaqjtR4cVjiI/2XA+Yo+JTLJhWyyHQLCzk1sSsI4pcHZqtIEyzkjh7K5ByvuDOm
         l5PgDXrAniF1bnQXF4fdcvrGQSKPWfqAKkOu3QuoZaF2UY2hh+mNle7o8rRbkoTT6v
         gsxstlZNXivFg==
Date:   Tue, 20 Dec 2022 11:36:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        xiaoning.wang@nxp.com, shenwei.wang@nxp.com,
        alexander.duyck@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net] net: fec: Coverity issue: Dereference null
 return value
Message-ID: <20221220113610.77a11f25@kernel.org>
In-Reply-To: <20221219022755.1047573-1-wei.fang@nxp.com>
References: <20221219022755.1047573-1-wei.fang@nxp.com>
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

On Mon, 19 Dec 2022 10:27:55 +0800 wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The build_skb might return a null pointer but there is no check on the
> return value in the fec_enet_rx_queue(). So a null pointer dereference
> might occur. To avoid this, we check the return value of build_skb. If
> the return value is a null pointer, the driver will recycle the page and
> update the statistic of ndev. Then jump to rx_processing_done to clear
> the status flags of the BD so that the hardware can recycle the BD.

Applied but I had to change the subject because the subject should
describe the change. Mentioning the tool which found the problem
belongs in the body of the message.
