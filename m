Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F06B01CB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCHIn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCHInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:43:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDEA580DA;
        Wed,  8 Mar 2023 00:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888A0616F4;
        Wed,  8 Mar 2023 08:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8575CC433D2;
        Wed,  8 Mar 2023 08:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678265004;
        bh=0j3HfSMJczICakUlTxj6g1PB6nR3AicSUGjv7aiaZGM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oMZCEH3ask/jhqKeTpLibWmHKGD5w7f2C8IV588FGSnUBTCZb/RF3MXN0yUCEWkAd
         4AJutLrcRDF+z7SQ1M6NWXpijLh3oxNfZ4/45ZH7z6lGffwkCvYKa9tnlnCODme06Q
         uScSAseArAxNs4tl0hlneTerHWVkAgHkFAgwBVxIzvzue8FdaY8OsluGH0izusXYfE
         sEgq5+jFCvNHXQY8MaDFmUlgawtuuRjBtx5/cZiM7bry23Yw3V6DjdcjJf8JUZUJJB
         PcITZnd1DKBDEE7iiX+9/bdgIS9n++vYj/MEuFKkNnEGvYYkvijNHtNizs/cyN+EYb
         ewT2Fwm7Cq2Fw==
Message-ID: <264f0489-726d-de7f-1182-09d4e12f2fbd@kernel.org>
Date:   Wed, 8 Mar 2023 10:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 6/6] soc: ti: pruss: Add helper functions to get/set
 PRUSS_CFG_GPMUX
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
 <20230306110934.2736465-7-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-7-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/03/2023 13:09, MD Danish Anwar wrote:
> From: Tero Kristo <t-kristo@ti.com>
> 
> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
> to get and set the GP MUX mode for programming the PRUSS internal wrapper
> mux functionality as needed by usecases.
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
