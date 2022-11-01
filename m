Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312E9614E9D
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiKAPul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiKAPuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:50:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A4313F20
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9856DB81E8A
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 15:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E523DC433D6;
        Tue,  1 Nov 2022 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667317836;
        bh=PtPX8q+3b0OlrqSIDQVkGDKII4RVrfJQzfjeJpwq+Ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PLQVjz+31ysSK4IJ95v5nbaSAsaFFfKabASDb7w9b/kyRmECHjv8xe4xYxRIgDGif
         8vaN8PNZfTmcZsBXMVeq4VGN7qQU49d8862yxTsfzpgmlQM9gkMG/bhuRqdCQhcXCH
         ZLmd2aoDZa2R3ZFPzpI6H8QafRkpklbJXOnwincax+hTVT4nSbEIZnDZEi+nhwJ3dy
         RUdY7MkfU/omkc9VofdXjxUqsTkW8LFYN7cRDnfL//1UR41CaHjsWK+7SLZ8gEshKa
         Dk5jOtLWHPtEn2dOy3/akJWlWyWGgHlkpMU1mGiCFebrvz5xdYr5u/ZkkQ76O8dKGH
         NZHZ/AL1SPLyw==
Date:   Tue, 1 Nov 2022 08:50:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE
 offload
Message-ID: <20221101085034.44b94d10@kernel.org>
In-Reply-To: <279a6644-4f3e-2ef3-2aa4-4463fbb9b8fc@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
        <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
        <20221025194035.7eb96c0a@kernel.org>
        <958764a5-8b2d-fe99-c59d-fbdddd53e0bc@gmail.com>
        <20221101082152.25b19c17@kernel.org>
        <279a6644-4f3e-2ef3-2aa4-4463fbb9b8fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Nov 2022 15:41:13 +0000 Edward Cree wrote:
> > Can you describe the current behavior is? Isn't the driver accepting
> > rules it can't correctly offload?  
> 
> The rule will pass the checks here, but then when we make the MCDI call
>  to install it in hardware, MC_CMD_MAE_ACTION_RULE_INSERT will evoke an
>  error response from the firmware, so the TC_SETUP_CLSFLOWER callback
>  will ultimately return an error to the kernel as it should.
> The advantage of having these checks in the driver is that we get a
>  useful error message rather than just "Failed to insert rule in hw",
>  and also save the round trip across the PCIe bus to firmware.

I see, net-next sounds good then. Do put this info into the commit
message, please.
