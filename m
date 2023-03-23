Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4E6C63C3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjCWJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjCWJeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:34:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83358A7C;
        Thu, 23 Mar 2023 02:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75BE6B82036;
        Thu, 23 Mar 2023 09:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93981C433EF;
        Thu, 23 Mar 2023 09:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679563946;
        bh=Hhy7WuzLK0H5CFmm3nRt36ALQDxIq2M+fRN4Kq6Pg3s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oYcRlOX5UAFY0OAUdarLh7XLm2gdMbV9BAJ8mt8GSqQBZSrS/TFAtIxzu03lWdwRx
         Id2EZ7RX0W+Qr8XGb4EVywe5hO/UQOhY0KFWBJp0Rynb9UfyfKqbV5UHs9TjCuDZTF
         /y0Z5xa1OWQPwyYh/+TuvTPup37QXztJ7H5oHrZWgB265Egbtam+sgit8IxWKKrQKg
         ZRui47ErGDzYZYKLXy0YdzE2UwEQ+X/JGGV9z9yZayR2OfsjwGWv/nJTncDhsQ2neM
         pyaFcKOFKg38qSl4o5qbeNzgVBSHOy4U4F8rhac43CjuzayjqHAIGJZVikW2iUC69Q
         sPK9DQiK/x1hA==
Message-ID: <dfb8a129-acc0-ef49-f8cd-b56b41bf4c64@kernel.org>
Date:   Thu, 23 Mar 2023 11:32:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 4/5] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-5-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230323062451.2925996-5-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/03/2023 08:24, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The PRUSS CFG module is represented as a syscon node and is currently
> managed by the PRUSS platform driver. Add easy accessor functions to set
> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
> to enable the PRUSS Ethernet usecase. These functions reuse the generic
> pruss_cfg_update() API function.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
