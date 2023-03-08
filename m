Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7366B0636
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCHLme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCHLm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:42:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF13BD7A2;
        Wed,  8 Mar 2023 03:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5475C61773;
        Wed,  8 Mar 2023 11:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A627C433D2;
        Wed,  8 Mar 2023 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678275735;
        bh=GS6tRvkGtq0vN1+iQ6FDOaBDA0r4jEk4oIYueLCnWjM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=B9MDF729gBqxZMwvSLxjfF6grvy4mczrvvUSqhv/h12vJpU+USUDlVrKhuoMSSbwz
         Vw0m/ZG3u0Mp26dt24EXuoyLX4w+OnhsVsLmWJGc5jL3L2elEToDIIa9ZC3bb2hLqK
         79DewjzU5TQfEMTg/jNuBHPmUEcPmF47/bTobCiKUQNsCfjsSzJFkcw965FuWd3Vky
         5qerDjXTfatAcCCFQ8zurcAGa9yj4WdT1vj7YxttFoYhodV2ogK8RWAgLFohfD54I+
         e2etU3CoSsglY+pOURvphF3O92nfpAibR7a0mrzUZ8Fv7sD+gDSa4Ur3CK56OLMWIq
         UlBEVYR5T59Jw==
Message-ID: <a74e5079-d89d-2420-b6af-d630c4f04380@kernel.org>
Date:   Wed, 8 Mar 2023 13:42:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v3 3/6] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
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
 <7076208d-7dca-6980-5399-498e55648740@kernel.org>
 <afd6cd8a-8ba7-24b2-d7fc-c25a9c5f3c42@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <afd6cd8a-8ba7-24b2-d7fc-c25a9c5f3c42@ti.com>
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



On 08/03/2023 13:36, Md Danish Anwar wrote:
> Hi Roger,
> 
> On 08/03/23 13:57, Roger Quadros wrote:
>> Hi,
>>
>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>> From: Suman Anna <s-anna@ti.com>
>>>
>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>> the PRUSS platform driver to allow other drivers to read and program
>>> respectively a register within the PRUSS CFG sub-module represented
>>> by a syscon driver. This interface provides a simple way for client
>>
>> Do you really need these 2 functions to be public?
>> I see that later patches (4-6) add APIs for doing specific things
>> and that should be sufficient than exposing entire CFG space via
>> pruss_cfg_read/update().
>>
>>
> 
> I think the intention here is to keep this APIs pruss_cfg_read() and
> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
> when needed.

Where are these other drivers? If they don't exist then let's not make provision
for it now.
We can provide necessary API helpers when needed instead of letting client drivers
do what they want as they can be misused and hard to debug.

> 
> The later patches (4-6) add APIs to do specific thing, but those APIs also
> eventually call pruss_cfg_read/update().

They can still call them but they need to be private to pruss.c

> 
>>> drivers without having them to include and parse the CFG syscon node
>>> within their respective device nodes. Various useful registers and
>>> macros for certain register bit-fields and their values have also
>>> been added.
>>>
>>> It is the responsibility of the client drivers to reconfigure or
>>> reset a particular register upon any failures.
>>>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>> ---
>>>  drivers/soc/ti/pruss.c           |  41 +++++++++++++
>>>  include/linux/remoteproc/pruss.h | 102 +++++++++++++++++++++++++++++++
>>>  2 files changed, 143 insertions(+)
>>>
>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>> index c8053c0d735f..537a3910ffd8 100644
>>> --- a/drivers/soc/ti/pruss.c
>>> +++ b/drivers/soc/ti/pruss.c
>>> @@ -164,6 +164,47 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>  }
>>>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>
>> cheers,
>> -roger
> 
