Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6416BE3A8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjCQIdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCQIdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D93DFB43;
        Fri, 17 Mar 2023 01:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A206BB824F6;
        Fri, 17 Mar 2023 08:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06C8C433D2;
        Fri, 17 Mar 2023 08:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679041919;
        bh=oomZDnVxdHZtUJnlVWXEtuwr3xT++1ZZD4/CrL6Q6KA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oZHAbvzuggGsV0kFkw//uH222iU6B2cdqfqqS+WMOBSAcPPZ36sGeR6ZWQlBe5V5/
         xl53mRL8CXa4lKX89H74MVRR9BjfRDJtyYG/+/PL25S8TSBvJyPEMBleVfkNdCZt4U
         7WcHsxKsMVkZokb42IE2Jfg1uM7+9/PFPN6V1mDeOcB5PRS8A43l1ETq53+1phO3ZG
         7dFzutQO3OEq4gbTBoSjGIDsAgjDqwdN++zZ4fE8RlGRbKo+hEQM2tVOBLKgld7biN
         OkAD9y39ug72oyhRCzeCg8lf2mnXmAAI52tvlcrlffTnCfuTuw6MUYlTDYmxenVx2s
         LCn2hfN6fFrCg==
Message-ID: <d8776be3-75a2-02fd-3702-79169675e4f6@kernel.org>
Date:   Fri, 17 Mar 2023 10:31:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 4/5] soc: ti: pruss: Add
 helper functions to set GPI mode, MII_RT_event and XFR
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
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-5-danishanwar@ti.com>
 <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
 <b1409f34-86b5-14e8-f352-5032aa57ca46@ti.com>
 <60e73395-f670-6eaa-0eb7-389553320a71@kernel.org>
 <20718115-7606-a77b-7e4d-511ca9c1d798@ti.com>
 <e49b9a78-5e35-209e-7ecc-2333478b98b0@kernel.org>
 <468f85ad-e4b0-54e1-a5b9-4692ae8a1445@ti.com>
 <455440f4-7f2b-366e-53ec-700c3bb98534@kernel.org>
 <22b8860c-12bd-384d-41af-93f1dde9a0fd@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <22b8860c-12bd-384d-41af-93f1dde9a0fd@ti.com>
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



On 17/03/2023 07:02, Md Danish Anwar wrote:
> 
> 
> On 16/03/23 19:34, Roger Quadros wrote:
>>
>> Hi,
>>
>> On 16/03/2023 15:11, Md Danish Anwar wrote:
>>>
>>>
>>> On 16/03/23 17:49, Roger Quadros wrote:
>>>>
>>>>
>>>> On 16/03/2023 13:44, Md Danish Anwar wrote:
>>>>>
>>>>> On 16/03/23 17:06, Roger Quadros wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 16/03/2023 13:05, Md Danish Anwar wrote:
>>>>>>> Hi Roger,
>>>>>>>
>>>>>>> On 15/03/23 17:52, Roger Quadros wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>>>>>>>> From: Suman Anna <s-anna@ti.com>
>>
> 
> [..]
> 
>>> Sure, then I will use the existing enum pru_type.
>>>
>>> The enum pru_type is currently in drivers/remoteproc/pruss.c I will move this
>>> enum definition from there to include/linux/remoteproc/pruss.h
>>
>> There are 2 public pruss.h files.
>> 	include/linux/remoteproc/pruss.h
>> and
>> 	include/linux/pruss_driver.h
>>
>> Why is that and when to use what?
>>
> 
> The include/linux/remoteproc/pruss.h file was introduced in series [1] as a
> public header file for PRU_RPROC driver (drivers/remoteproc/pru_rproc.c)
> 
> The second header file include/linux/pruss_driver.h was introduced much earlier
> as part of [2] , "soc: ti: pruss: Add a platform driver for PRUSS in TI SoCs".
> 
> As far as I can see, seems like pruss_driver.h was added as a public header
> file for PRUSS platform driver (drivers/soc/ti/pruss.c)
> 
> [1] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/
> [2] https://lore.kernel.org/all/1542886753-17625-7-git-send-email-rogerq@ti.com/

Thanks. "include/linux/remoteproc/pruss.h" seems appropriate for enum pru_type.

cheers,
-roger
