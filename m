Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F366B00EB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCHIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCHIXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:23:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26422E0EC;
        Wed,  8 Mar 2023 00:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78679B81A3C;
        Wed,  8 Mar 2023 08:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B6C433D2;
        Wed,  8 Mar 2023 08:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678263790;
        bh=0Qi/oox3CIf4TPTIxx0QPVu4gh4NsyRVsaBArRS6wAI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=e3qvBAQC7+/lBAK80sybw78XbH5SApc74HZI4GmxKQFFxAgV7Q4cMtaVTjpgcU/Su
         yeZSy/TSEvJ5//0FV0478TMp5NDgTLOJwxYKwKdonXV0o07HKYkJRB3myqbtC0i6lD
         fi+mZyt1NastcCWgdN99zDgSlN0FDo/FqKlF7zto3mQHvrNxoOmgDjnC1Xnh8r1wmz
         t+nqcwD/4/g4zrTMutNb+LIz8drn9wsvfG1Oll12a3s4+B1AqVIa12jsrYggmm1Tau
         OKt+LqJK8gv/ZySPzj0QTY66rwsMGglJJvCHaaA/GoFI9kzF6bhRggHWmj/tYRz4w5
         gRynR+hi5o1aw==
Message-ID: <418c3de3-4868-63e5-3433-3fb3aec2d1fe@kernel.org>
Date:   Wed, 8 Mar 2023 10:23:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 2/6] soc: ti: pruss: Add
 pruss_{request,release}_mem_region() API
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
 <20230306110934.2736465-3-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-3-danishanwar@ti.com>
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



On 06/03/2023 13:09, MD Danish Anwar wrote:
> From: "Andrew F. Davis" <afd@ti.com>
> 
> Add two new API - pruss_request_mem_region() & pruss_release_mem_region(),
> to the PRUSS platform driver to allow client drivers to acquire and release
> the common memory resources present within a PRU-ICSS subsystem. This
> allows the client drivers to directly manipulate the respective memories,
> as per their design contract with the associated firmware.
> 
> Co-developed-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Andrew F. Davis <afd@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
