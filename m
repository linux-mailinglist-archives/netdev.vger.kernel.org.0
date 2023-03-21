Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80466C2DC5
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCUJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUJYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:24:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F58F16338;
        Tue, 21 Mar 2023 02:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE8361AAD;
        Tue, 21 Mar 2023 09:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1B4C433D2;
        Tue, 21 Mar 2023 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679390688;
        bh=CpzFHzfIMqVb1E4paSIQ5K4vWNYo3LEISEw5nGxfMJw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VVXxXV5ieendwlxoCh9JlFXckvOet2he4ioTS834+2Ucg9tIvdG8N1FYV61eOkbfC
         BGBOY4L7l17yYZ7oZDorWXjyUDuT2+1eZ8Zb0PQaOM6dTKg5sP7lR7f8GO8qPE8fWD
         j3IwMP6M6cIFAkUcnL4TDg5ZhSh1OayRoaBK733MOa4BjhG7AChpFvYwjTfEm96dcj
         //Yu1ldBZzTlgPHXTov3bB+WhckOmzwSPA5+bCwZxWcLjmWTpvZui7OA6JG2qLVEsQ
         DMYC6YmT15EMW4j1JvSvOM+GxPpbuv2lHOw2O0IlXVlIfJvCTs3g+ANFFuxP9tts0R
         1ocjldNqyimVA==
Message-ID: <67dd1d04-147d-0e40-c06b-6e1e0dd05f13@kernel.org>
Date:   Tue, 21 Mar 2023 11:24:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v4 2/5] soc: ti: pruss: Add
 pruss_{request,release}_mem_region() API
To:     Md Danish Anwar <a0501179@ti.com>, Andrew Davis <afd@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        Suman Anna <s-anna@ti.com>,
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
 <20230313111127.1229187-3-danishanwar@ti.com>
 <3f26b194-287c-074d-8e78-572875f9a734@kernel.org>
 <52aeb13f-1fe4-825f-9d28-ba64860ae76d@ti.com>
 <13048b01-641a-1d92-178c-02b87c5fa1b9@ti.com>
 <5b936f1b-3c5b-30ab-7074-e202fd6555b6@ti.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <5b936f1b-3c5b-30ab-7074-e202fd6555b6@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

On 21/03/2023 07:23, Md Danish Anwar wrote:
> Hi Andrew, Roger,
> 
> On 20/03/23 21:48, Andrew Davis wrote:
>> On 3/20/23 12:11 AM, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 17/03/23 14:26, Roger Quadros wrote:
>>>> Hi Andrew & Danish,
>>>>
>>>>
>>>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>>>> From: "Andrew F. Davis" <afd@ti.com>
>>>>>
>>>>> Add two new API - pruss_request_mem_region() & pruss_release_mem_region(),
>>>>> to the PRUSS platform driver to allow client drivers to acquire and release
>>>>> the common memory resources present within a PRU-ICSS subsystem. This
>>>>> allows the client drivers to directly manipulate the respective memories,
>>>>> as per their design contract with the associated firmware.
>>>>>
>>>>> Co-developed-by: Suman Anna <s-anna@ti.com>
>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>> Signed-off-by: Andrew F. Davis <afd@ti.com>
>>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>>>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>>>>> ---
>>>>>   drivers/soc/ti/pruss.c           | 77 ++++++++++++++++++++++++++++++++
>>>>>   include/linux/pruss_driver.h     | 27 +++--------
>>>>>   include/linux/remoteproc/pruss.h | 39 ++++++++++++++++
>>>>
>>>>
>>>> We have these 2 header files and I think anything that deals with
>>>> 'struct pruss' should go in include/linux/pruss_driver.h
>>>>
>>>> Anything that deals with pru_rproc (i.e. struct rproc) should go in
>>>> include/linux/remoteproc/pruss.h
>>>>
>>>> Do you agree?
>>>>
>>>
>>> I agree with you Roger but Andrew is the right person to comment here as he is
>>> the author of this and several other patches.
>>>
>>> Hi Andrew, Can you please comment on this?
>>>
>>
>> Original idea was a consumer driver (like "ICSSG Ethernet Driver" in your other
>> series) could just
>>
>> #include <linux/remoteproc/pruss.h>
>>
>> and get everything they need, and nothing they do not.
>>
> 
> If we plan on continuing the original idea, then I think keeping the header
> files as it is will be the best. Because if we move anything that deals with
> 'struct pruss' to include/linux/pruss_driver.h and anything that deals with
> pru_rproc (i.e. struct rproc) to include/linux/remoteproc/pruss.h, then the
> consumer drivers will need to do,
> 
> #include <linux/remoteproc/pruss.h>
> #include <linux/pruss_driver.h>
> 
> Roger, should I keep the header files arrangement as it is?
> 

OK but can we please rename one of them to something else so they don't
sound very similar. Maybe you could use Andrew's suggestion below.

>> pruss_driver.h (which could be renamed pruss_internal.h) exists to allow
>> comunication between the pruss core and the pru rproc driver which live
>> in different subsystems.
>>
>> Andrew
>>
>>>>>   3 files changed, 121 insertions(+), 22 deletions(-)
>>>>>
>>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>>> index a169aa1ed044..c8053c0d735f 100644
>>>>> --- a/drivers/soc/ti/pruss.c
>>>>> +++ b/drivers/soc/ti/pruss.c
>>>>> @@ -88,6 +88,82 @@ void pruss_put(struct pruss *pruss)
>>>>>   }
>>>>>   EXPORT_SYMBOL_GPL(pruss_put);
>>>>>   +/**
>>>>> + * pruss_request_mem_region() - request a memory resource
>>>>> + * @pruss: the pruss instance
>>>>> + * @mem_id: the memory resource id
>>>>> + * @region: pointer to memory region structure to be filled in
>>>>> + *
>>>>> + * This function allows a client driver to request a memory resource,
>>>>> + * and if successful, will let the client driver own the particular
>>>>> + * memory region until released using the pruss_release_mem_region()
>>>>> + * API.
>>>>> + *
>>>>> + * Return: 0 if requested memory region is available (in such case pointer to
>>>>> + * memory region is returned via @region), an error otherwise
>>>>> + */
>>>>> +int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>>>>> +                 struct pruss_mem_region *region)
>>>>> +{
>>>>> +    if (!pruss || !region || mem_id >= PRUSS_MEM_MAX)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    mutex_lock(&pruss->lock);
>>>>> +
>>>>> +    if (pruss->mem_in_use[mem_id]) {
>>>>> +        mutex_unlock(&pruss->lock);
>>>>> +        return -EBUSY;
>>>>> +    }
>>>>> +
>>>>> +    *region = pruss->mem_regions[mem_id];
>>>>> +    pruss->mem_in_use[mem_id] = region;
>>>>> +
>>>>> +    mutex_unlock(&pruss->lock);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pruss_request_mem_region);
>>>>> +
>>>>> +/**
>>>>> + * pruss_release_mem_region() - release a memory resource
>>>>> + * @pruss: the pruss instance
>>>>> + * @region: the memory region to release
>>>>> + *
>>>>> + * This function is the complimentary function to
>>>>> + * pruss_request_mem_region(), and allows the client drivers to
>>>>> + * release back a memory resource.
>>>>> + *
>>>>> + * Return: 0 on success, an error code otherwise
>>>>> + */
>>>>> +int pruss_release_mem_region(struct pruss *pruss,
>>>>> +                 struct pruss_mem_region *region)
>>>>> +{
>>>>> +    int id;
>>>>> +
>>>>> +    if (!pruss || !region)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    mutex_lock(&pruss->lock);
>>>>> +
>>>>> +    /* find out the memory region being released */
>>>>> +    for (id = 0; id < PRUSS_MEM_MAX; id++) {
>>>>> +        if (pruss->mem_in_use[id] == region)
>>>>> +            break;
>>>>> +    }
>>>>> +
>>>>> +    if (id == PRUSS_MEM_MAX) {
>>>>> +        mutex_unlock(&pruss->lock);
>>>>> +        return -EINVAL;
>>>>> +    }
>>>>> +
>>>>> +    pruss->mem_in_use[id] = NULL;
>>>>> +
>>>>> +    mutex_unlock(&pruss->lock);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>>>> +
>>>>>   static void pruss_of_free_clk_provider(void *data)
>>>>>   {
>>>>>       struct device_node *clk_mux_np = data;
>>>>> @@ -290,6 +366,7 @@ static int pruss_probe(struct platform_device *pdev)
>>>>>           return -ENOMEM;
>>>>>         pruss->dev = dev;
>>>>> +    mutex_init(&pruss->lock);
>>>>>         child = of_get_child_by_name(np, "memories");
>>>>>       if (!child) {
>>>>> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
>>>>> index 86242fb5a64a..22b4b37d2536 100644
>>>>> --- a/include/linux/pruss_driver.h
>>>>> +++ b/include/linux/pruss_driver.h
>>>>> @@ -9,37 +9,18 @@
>>>>>   #ifndef _PRUSS_DRIVER_H_
>>>>>   #define _PRUSS_DRIVER_H_
>>>>>   +#include <linux/mutex.h>
>>>>>   #include <linux/remoteproc/pruss.h>
>>>>>   #include <linux/types.h>
>>>>>   -/*
>>>>> - * enum pruss_mem - PRUSS memory range identifiers
>>>>> - */
>>>>> -enum pruss_mem {
>>>>> -    PRUSS_MEM_DRAM0 = 0,
>>>>> -    PRUSS_MEM_DRAM1,
>>>>> -    PRUSS_MEM_SHRD_RAM2,
>>>>> -    PRUSS_MEM_MAX,
>>>>> -};
>>>>> -
>>>>> -/**
>>>>> - * struct pruss_mem_region - PRUSS memory region structure
>>>>> - * @va: kernel virtual address of the PRUSS memory region
>>>>> - * @pa: physical (bus) address of the PRUSS memory region
>>>>> - * @size: size of the PRUSS memory region
>>>>> - */
>>>>> -struct pruss_mem_region {
>>>>> -    void __iomem *va;
>>>>> -    phys_addr_t pa;
>>>>> -    size_t size;
>>>>> -};
>>>>> -
>>>>>   /**
>>>>>    * struct pruss - PRUSS parent structure
>>>>>    * @dev: pruss device pointer
>>>>>    * @cfg_base: base iomap for CFG region
>>>>>    * @cfg_regmap: regmap for config region
>>>>>    * @mem_regions: data for each of the PRUSS memory regions
>>>>> + * @mem_in_use: to indicate if memory resource is in use
>>>>> + * @lock: mutex to serialize access to resources
>>>>>    * @core_clk_mux: clk handle for PRUSS CORE_CLK_MUX
>>>>>    * @iep_clk_mux: clk handle for PRUSS IEP_CLK_MUX
>>>>>    */
>>>>> @@ -48,6 +29,8 @@ struct pruss {
>>>>>       void __iomem *cfg_base;
>>>>>       struct regmap *cfg_regmap;
>>>>>       struct pruss_mem_region mem_regions[PRUSS_MEM_MAX];
>>>>> +    struct pruss_mem_region *mem_in_use[PRUSS_MEM_MAX];
>>>>> +    struct mutex lock; /* PRU resource lock */
>>>>>       struct clk *core_clk_mux;
>>>>>       struct clk *iep_clk_mux;
>>>>>   };
>>>>> diff --git a/include/linux/remoteproc/pruss.h
>>>>> b/include/linux/remoteproc/pruss.h
>>>>> index 93a98cac7829..33f930e0a0ce 100644
>>>>> --- a/include/linux/remoteproc/pruss.h
>>>>> +++ b/include/linux/remoteproc/pruss.h
>>>>> @@ -44,6 +44,28 @@ enum pru_ctable_idx {
>>>>>       PRU_C31,
>>>>>   };
>>>>>   +/*
>>>>> + * enum pruss_mem - PRUSS memory range identifiers
>>>>> + */
>>>>> +enum pruss_mem {
>>>>> +    PRUSS_MEM_DRAM0 = 0,
>>>>> +    PRUSS_MEM_DRAM1,
>>>>> +    PRUSS_MEM_SHRD_RAM2,
>>>>> +    PRUSS_MEM_MAX,
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * struct pruss_mem_region - PRUSS memory region structure
>>>>> + * @va: kernel virtual address of the PRUSS memory region
>>>>> + * @pa: physical (bus) address of the PRUSS memory region
>>>>> + * @size: size of the PRUSS memory region
>>>>> + */
>>>>> +struct pruss_mem_region {
>>>>> +    void __iomem *va;
>>>>> +    phys_addr_t pa;
>>>>> +    size_t size;
>>>>> +};
>>>>> +
>>>>>   struct device_node;
>>>>>   struct rproc;
>>>>>   struct pruss;
>>>>> @@ -52,6 +74,10 @@ struct pruss;
>>>>>     struct pruss *pruss_get(struct rproc *rproc);
>>>>>   void pruss_put(struct pruss *pruss);
>>>>> +int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>>>>> +                 struct pruss_mem_region *region);
>>>>> +int pruss_release_mem_region(struct pruss *pruss,
>>>>> +                 struct pruss_mem_region *region);
>>>>>     #else
>>>>>   @@ -62,6 +88,19 @@ static inline struct pruss *pruss_get(struct rproc
>>>>> *rproc)
>>>>>     static inline void pruss_put(struct pruss *pruss) { }
>>>>>   +static inline int pruss_request_mem_region(struct pruss *pruss,
>>>>> +                       enum pruss_mem mem_id,
>>>>> +                       struct pruss_mem_region *region)
>>>>> +{
>>>>> +    return -EOPNOTSUPP;
>>>>> +}
>>>>> +
>>>>> +static inline int pruss_release_mem_region(struct pruss *pruss,
>>>>> +                       struct pruss_mem_region *region)
>>>>> +{
>>>>> +    return -EOPNOTSUPP;
>>>>> +}
>>>>> +
>>>>>   #endif /* CONFIG_TI_PRUSS */
>>>>>     #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>>>>
>>>> cheers,
>>>> -roger
>>>
> 

cheers,
-roger
