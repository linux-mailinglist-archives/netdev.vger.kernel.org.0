Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B3152F1C3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352323AbiETRhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352327AbiETRhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFA9134E2A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F5760ACE
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC364C385A9;
        Fri, 20 May 2022 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653068233;
        bh=lw34SgutUkdb6HBuRNaQR/doSeV2e8rerzrwHw2AB6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HqsXrr4vdNPiX6ewkVdjbYk4I6QM+lv6vnH4clVZwB6leXdJQim35nHDPJSrsB/DW
         R2ltJQ/Yr3CbknmTUy6Sczw4M39LDRSP012W81lx2gFmUjMLZq3HOIBPooQeEJmqsl
         ZNFBV3XPoWLzJL1uwQIkkmYqcMtviLG8nRvSE1wUI8iV6nKA7KRm+zvpEpa8uUKSvr
         uVCSF910lGf65AwebT6SFgB4pGGfpRNRtEAway9Y9elwg0oMptWbEwPrK64vdes8qG
         kf7p1L/A6GIO8RVUBEDK6xmaAFVhwGckn02A9/Hhoo02gvB4UqJEM0vRnc33RvS2Zl
         II36SNcVZChmg==
Date:   Fri, 20 May 2022 10:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        sreehari.kancharla@intel.com, dinesh.sharma@intel.com
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem
 logging
Message-ID: <20220520103711.5f7f5b45@kernel.org>
In-Reply-To: <20220519182703.27056-1-moises.veleta@linux.intel.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
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

On Thu, 19 May 2022 11:27:03 -0700 Moises Veleta wrote:
> +	ret = copy_from_user(skb_put(skb, actual_len), buf, actual_len);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto err_out;
> +	}
> +
> +	ret = t7xx_port_send_skb(port, skb, 0, 0);
> +	if (ret)
> +		goto err_out;

We don't allow using debugfs to pass random data from user space 
to firmware in networking. You need to find another way.
