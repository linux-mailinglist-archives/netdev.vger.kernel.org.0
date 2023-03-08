Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE856B00E9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCHIYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCHIXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:23:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8348129415;
        Wed,  8 Mar 2023 00:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B28561640;
        Wed,  8 Mar 2023 08:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253BBC433D2;
        Wed,  8 Mar 2023 08:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678263776;
        bh=7l7R2JPd5pjN5M9bcebk3z9dZUb06A4xbTItl4Frs3E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hAeYsu/0aAEfgfmGJasT4mO1/g8n69St8evqqnJ+9X1EKDJn2nWi2e7eUGbzBnFGg
         sFNEyTR3MN03igDvf43VaE/PQcVfgDDq38uGn1/kpSprgm+pYF4Goa1HM1F8M6BUH0
         glzahc0L/rcWTUkY2XlYQXGmGZWMS7ILQEGWbtQ/+IGDvZ8jSbRxufa8eUjjsCuxY/
         aRMyuzePXpSz6a+nmFW0gwF6IwdI1lCTSBS9HeMmcvUYi09MDH3DCQ0xxUWGqXUFCA
         yZ+Sb8TErYHb9Ywl4kyYJsHMPEDxvqv6L+gZgnSRSFRBUun00QO8dDnN7NkQ1PKrSI
         gX2Ei8ofbA2eA==
Message-ID: <66caf88e-aaa0-26f4-ec03-597c86b99a13@kernel.org>
Date:   Wed, 8 Mar 2023 10:22:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/6] soc: ti: pruss: Add pruss_get()/put() API
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
 <20230306110934.2736465-2-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-2-danishanwar@ti.com>
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
> Add two new get and put API, pruss_get() and pruss_put() to the
> PRUSS platform driver to allow client drivers to request a handle
> to a PRUSS device. This handle will be used by client drivers to
> request various operations of the PRUSS platform driver through
> additional API that will be added in the following patches.
> 
> The pruss_get() function returns the pruss handle corresponding
> to a PRUSS device referenced by a PRU remoteproc instance. The
> pruss_put() is the complimentary function to pruss_get().
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
