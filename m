Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387276CFA31
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjC3EcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3EcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:32:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D38C10D7;
        Wed, 29 Mar 2023 21:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51B7EB8258C;
        Thu, 30 Mar 2023 04:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA01C433D2;
        Thu, 30 Mar 2023 04:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680150738;
        bh=BpCkRkfg8i2crE/yPAM4A8j0OQ5LOXAgBqv/LL75Vwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WS36mhqouLME5EXpvXM6z1aFwhqzU//QhVXjalxXfvk/m6Uz4GR2TZKA5bu/Qkx6/
         nHfX6slRdxHA3zW0Xapga3Xk6m0YPbw49DuWiIjcQMgS6qNg4m/I/jVqMs85K0MXN7
         1aXpMm9RtKxnhjOZJ0CzvAZlUsPRHYOkjNfh64myejkRM2xbkJL7rahIisXextMqyV
         5fILFORu/kCIDeBYpaylop5TSfqsK03EJjNGc220yK10dNIyeEyd6DPPRhdXJL9nuU
         Sv3wVqxx/MNXh4VHSggV+KzjlftiYu4UFBoJtSLaAPic1BVu3tFLFf5iJPkOiVQcoZ
         7/d3a1XYWqlTg==
Date:   Wed, 29 Mar 2023 21:32:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sricharan R <quic_srichara@quicinc.com>
Cc:     <mani@kernel.org>, <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <20230329213216.7b0447e9@kernel.org>
In-Reply-To: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
References: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
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

On Wed, 29 Mar 2023 18:37:30 +0530 Sricharan R wrote:
> When the qrtr socket is released, qrtr_port_remove gets called, which
> broadcasts a DEL_CLIENT. After this DEL_SERVER is also additionally
> broadcasted, which becomes NOP, but triggers the below error msg.
> 
> "failed while handling packet from 2:-2", since remote node already
> acted upon on receiving the DEL_CLIENT, once again when it receives
> the DEL_SERVER, it returns -ENOENT.
> 
> Fixing it by not sending a 'DEL_SERVER' to remote when a 'DEL_CLIENT'
> was sent for that port.

You use the word "fix" so please add a Fixes tag.

> Signed-off-by: Ram Kumar D <quic_ramd@quicinc.com>
> Signed-off-by: Sricharan R <quic_srichara@quicinc.com>

Spell out full names, please.
