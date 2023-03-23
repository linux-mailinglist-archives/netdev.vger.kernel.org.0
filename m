Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFB96C63AF
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjCWJdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWJdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D213C10;
        Thu, 23 Mar 2023 02:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8846B82034;
        Thu, 23 Mar 2023 09:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19A8C433EF;
        Thu, 23 Mar 2023 09:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679563829;
        bh=iXUTHYeeegFCFaox+RMWiD1WuxysTWL+ixcGPGIX85s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DjeglNNoAulTCNb3qaWXJMChNxF8gKu3b+j0NIj2hcbnuHcTgUYIBDdIPCbLtKoQr
         u8tfRnp3AWdCaM+ubHXF63bsc8YzisXeUNFoXS/NC5ITrDTE03dAjitCo28pN1TI3/
         n8N1lBF8aS1m5JWakrNp5UcFFOfwmmrCPLTjQWH59Expu+U6zIJZ/l3pXsIjjEWqkH
         Jo2SyfMkj3vqrf+sdIK1CccocHBEh0NPyos+ukOfmWFKEgXPnhsny386nGmIVW6ukj
         P0PSG6+tWgijE4C+3zoCudtNN4h3JVjJRUUeZDTbijbyB0JUyJ7zDgHDIGEK7cc7vx
         cDngE23EP677w==
Message-ID: <0315a3e5-ec6c-9a46-7eca-5d112b624d94@kernel.org>
Date:   Thu, 23 Mar 2023 11:30:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 3/5] soc: ti: pruss: Add pruss_cfg_read()/update() API
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
 <20230323062451.2925996-4-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230323062451.2925996-4-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
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
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to read and program respectively a register
> within the PRUSS CFG sub-module represented by a syscon driver.
> 
> These APIs are internal to PRUSS driver. Various useful registers
> and macros for certain register bit-fields and their values have also
> been added.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
