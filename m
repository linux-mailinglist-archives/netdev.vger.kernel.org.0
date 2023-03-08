Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC026B0165
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCHIaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjCHI3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:29:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CE8B32B8;
        Wed,  8 Mar 2023 00:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3DDB81BFC;
        Wed,  8 Mar 2023 08:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C758C433D2;
        Wed,  8 Mar 2023 08:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678264085;
        bh=hHAJ1zXtYZn9AD+oMdKn2rsolKX4a1QC16QjAldjP9E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=C1RZzVymTrF2+zLGhfB2byPuJKAsUHR907RRBJtq8WwaTJPipeLBF7jGzqsNwSjsg
         W3HpF0PHJMF7AfXyNe+YwUbrU3GGm4F7XLS+WgANAFtSoj5iMq/xetFEsK0Ea/e62h
         r5MsxpfJsirJUzTVbA9gGDmlosiNn0jvX7BNHpSstrH4FmcSAGMNMS8lTxoPt8fkyG
         JBhbSKxulvpPbqJbslLZOdEZ6mR2kkfrs3Y5Azkp2eYe1A6YK/3SJe11z34hmBDgc6
         6t1o6vUe2Z78IFW4Akna6FEdnXOVmY6mm3NdruQKjvVZNf5KDY0t1AbFkPbO1eM1cF
         DkGakNZWXxJCQ==
Message-ID: <7076208d-7dca-6980-5399-498e55648740@kernel.org>
Date:   Wed, 8 Mar 2023 10:27:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 3/6] soc: ti: pruss: Add pruss_cfg_read()/update() API
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-4-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-4-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 06/03/2023 13:09, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to allow other drivers to read and program
> respectively a register within the PRUSS CFG sub-module represented
> by a syscon driver. This interface provides a simple way for client

Do you really need these 2 functions to be public?
I see that later patches (4-6) add APIs for doing specific things
and that should be sufficient than exposing entire CFG space via
pruss_cfg_read/update().


> drivers without having them to include and parse the CFG syscon node
> within their respective device nodes. Various useful registers and
> macros for certain register bit-fields and their values have also
> been added.
> 
> It is the responsibility of the client drivers to reconfigure or
> reset a particular register upon any failures.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  drivers/soc/ti/pruss.c           |  41 +++++++++++++
>  include/linux/remoteproc/pruss.h | 102 +++++++++++++++++++++++++++++++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index c8053c0d735f..537a3910ffd8 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -164,6 +164,47 @@ int pruss_release_mem_region(struct pruss *pruss,
>  }
>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);

cheers,
-roger
