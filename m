Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDD3673584
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjASKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjASKa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:30:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CE81715C;
        Thu, 19 Jan 2023 02:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 035786150E;
        Thu, 19 Jan 2023 10:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F0C433D2;
        Thu, 19 Jan 2023 10:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674124226;
        bh=vqOBLxIix8agYyJCUe57zrHZuDz3W1dqgfbKszEXMp4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IrDZpi7RNhRpg08IjCtsxja0wZ8BXeMaaTrSTWAzIYW7zRqJaqUUMn96i5UoF/cgb
         hGZMFGwv/gBA811iC1JHpgR3FzPJ6Z4d7mijNQgIUOI6WjQCmAGUqemmAebS+OTctM
         CLNIKOBs/2nYfxF3/KnX1PhqU8ShisReATUE3EHr2i/wMXxlLmFSoXB7GDTJk7xK4T
         X9KmOVcO9FnxiVdPEthwE9kxXS/HE+Betfx5eeLY52uOZNGbYlx/9/OQx5vincEPTd
         YeRtvBrWRXC4b1EZ3O17WoSmnOWN2GaVDlqBE0NOSCY1Jjss2rj2sqggxJacLeGgGR
         K3UFMtnaJp2vA==
Message-ID: <d498d873-13a2-c516-17cd-af21e1d9de3b@kernel.org>
Date:   Thu, 19 Jan 2023 12:30:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: Handle
 -EPROBE_DEFER for Serdes PHY
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, geert@linux-m68k.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230118112136.213061-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230118112136.213061-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 13:21, Siddharth Vadapalli wrote:
> In the am65_cpsw_init_serdes_phy() function, the error handling for the
> call to the devm_of_phy_get() function misses the case where the return
> value of devm_of_phy_get() is ERR_PTR(-EPROBE_DEFER). Proceeding without
> handling this case will result in a crash when the "phy" pointer with
> this value is dereferenced by phy_init() in am65_cpsw_enable_phy().
> 
> Fix this by adding appropriate error handling code.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
