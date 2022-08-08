Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1114C58CE81
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243357AbiHHTXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiHHTXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65595D113
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 12:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA266612B8
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 19:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9DDC433C1;
        Mon,  8 Aug 2022 19:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659986600;
        bh=MutqD9XayjZYEYajQtIu00gcvAhJJ/5IPMeksWbZoVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e7ERJ7+JYi5jJGLHoGgSPd5EwXPXAbXGunUG9m9dFGlDUfc5xts1ygLYc122D5gDt
         5MGWJut1J5rhRGLJSqlJxIBX3WD+jCXu1JpXFUooqkYArVZwHhVLuq2Q8Scq07QZVa
         V2rStJzU5My34d1hpL7Szkjr8yydzpjMY0vo/hjhqWCamefWUtJQwRdyizJ3HWQO67
         USLcdU1b/B68/UQVtO34Pd0o57Yx0FyJqcxNeT+I5GJbCaYwP8tAHUgPeMZ47RkJHv
         5gRJAMeHZETLNGELNfXH/66AFDg756UCrvWict5A+Ht5/tqJ0VqPFAAAub+eNeSdzC
         02Ic+3+4BgiiA==
Date:   Mon, 8 Aug 2022 12:23:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] tsnep: Fix tsnep_tx_unmap() error path
 usage
Message-ID: <20220808122319.4164b5c6@kernel.org>
In-Reply-To: <20220804183935.73763-3-gerhard@engleder-embedded.com>
References: <20220804183935.73763-1-gerhard@engleder-embedded.com>
        <20220804183935.73763-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Aug 2022 20:39:35 +0200 Gerhard Engleder wrote:
> If tsnep_tx_map() fails, then tsnep_tx_unmap() shall start at the write
> index like tsnep_tx_map(). This is different to the normal operation.
> Thus, add an additional parameter to tsnep_tx_unmap() to enable start at
> different positions for successful TX and failed TX.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Is this correct:

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")

?
