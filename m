Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8252D9F1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbiESQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241874AbiESQMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539A9C6E5F;
        Thu, 19 May 2022 09:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C5361C50;
        Thu, 19 May 2022 16:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A769C385AA;
        Thu, 19 May 2022 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652976746;
        bh=PLx3iUUZ7laxx5o2O5313UEeec1L4dfiFRAgBbsJ7ig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZP8oZmEet8O8mjGO0MyRU3bVx4+QfoncrK2vEoIRmghpw3nzt4F04TJNhsxpcjFwW
         f0eZhvofHUTgRFCOLat9M+vlg1vjqVx1RwpZizfO0jodO7C2S0NCP4u79XNqd/CXr1
         u70yvkF4xyQnp8lwiUXYGA+nAUtoO6xC168qme2XspynnCQ9fjiW2mY5asrSGR8czl
         j0VfgpR3wYFfr8kldMyji0p6qQgliU+xDKy/nbYCysRgZaJGd9rU0gGSwDdosOi0Vj
         iCx4M83llWXmeYiLcOsv417GH7nYqmlxmu9nOK+yH34VOZb3z8CY53EE2Aso7jQJoB
         Dp6h0GRwcgBsQ==
Date:   Thu, 19 May 2022 09:12:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 11/15] net: ethernet: mtk_eth_soc: introduce
 device register map
Message-ID: <20220519091224.4409b54d@kernel.org>
In-Reply-To: <YoX3AMlBFfDcl69o@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
        <20220517184122.522ed708@kernel.org>
        <YoTA+5gLC4zhoQ0F@lore-desk>
        <20220518084431.66aa1737@kernel.org>
        <YoX3AMlBFfDcl69o@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 09:51:28 +0200 Lorenzo Bianconi wrote:
> > I don't think there's a best known practice, you'll have to exercise
> > your judgment. Taking a look at a random example of MTK_PDMA_INT_STATUS.
> > Looks like that one is already assigned to eth->tx_int_status_reg.
> > Maybe that can be generalized? Personally I'd forgo the macros
> > completely and just use eth->soc->register_name in the code.  
> 
> I personally think the code is easier to read if we use macros in this case.
> Let's consider MTK_LRO_CTRL_DW1_CFG(), it depends on the particular soc based
> on the register map and even on the ring index. I guess the best trade-off we
> can get is to explicitly pass eth to the macros as parameter when needed.

Yeah, do you, I was just sharing what my knee jerk direction would be.
You know the code better.
