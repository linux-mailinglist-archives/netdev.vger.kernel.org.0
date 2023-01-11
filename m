Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B39665EBB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbjAKPFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbjAKPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:04:56 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF3DF64
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:04:53 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qk9so37555539ejc.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wSndVBDlN4JUzHCG4iLF5UhWZTMXbKyI15vPIo6KiSU=;
        b=WTmIT17URH/10jxaZkCFZ/Su0dMdGH7NE5GghquSvWPPwpJd+6ILKuWlyNMm4H395e
         xxxRl10u9LGTOQaXpIKBxLC/FDqshM9cN589y9hVEsHgEwYnPXHEwK6qVD8FG6hH+pvE
         wrAlS2DiweSE7pAwI7neVmyozpz2rRA6hxUwmw7ztiGv1D2Dv/asvYg19Fk6VHhGU5NV
         IxjGNcfhzCgvP/n0ENrWZ705Nu0rcm2BPJBsia+jXMN3hBjfkPPUGskM4RMbnoc1blBr
         Z3Ts5KMdNCbIMyjPXfmrcsGDEEca7L/7CLtupaHeINXXkQRtV2U4OiVaG38GK2j+1ExM
         i1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSndVBDlN4JUzHCG4iLF5UhWZTMXbKyI15vPIo6KiSU=;
        b=OBTzVFWk4BL7KaDunCkBErC7Nqhr/rQEOAQ77NHxxadWOLt7IAlO2+IXMAeiu8VL9f
         5/XVL9DDVJIT6IMuPfpJBvFGEYK8gKjeCvqbcHxvf2R55P+zU9zU/GillDDArJe5bOr+
         6ztPPIFOsp6WDowQBHdoCPkA21YabSAty5LvnFsJp2wpW2Ug4egSAo/nXZd3DZG/kHmV
         5pKNouDGxEq4+igwwHV8rEB8uJAe7bxlFmGKVeIzCSDmAV/zA5b45j0NJqJKr+I5RarB
         o1r8SYLNoFOeHp+ULI67kOsICEg5Ql5UOEEXNRz7tDsgli+qupuvhwAk/OjWqDONncwb
         bOJw==
X-Gm-Message-State: AFqh2kquS+vJgAHdoPkEezLBABByhd8LNBVNNDyxwq9bjtI7B5mj2Rcp
        /2TkE99ogUZgUZbYoOd9hz3kGA==
X-Google-Smtp-Source: AMrXdXsAzLI1Zlu5S4eptp/SXJsEAFI0xjbkUEdexBFitl92UPyIF9Z09CaOEcx6v3MsIYc8oMHD7w==
X-Received: by 2002:a17:906:184a:b0:78d:f456:1ed0 with SMTP id w10-20020a170906184a00b0078df4561ed0mr70252597eje.33.1673449491869;
        Wed, 11 Jan 2023 07:04:51 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id ka13-20020a170907990d00b0073c10031dc9sm6196545ejc.80.2023.01.11.07.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 07:04:50 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:04:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y77QEajGlJewGKy1@nanopsycho>
References: <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org>
 <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org>
 <Y75xFlEDCThGtMDq@nanopsycho>
 <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 11, 2023 at 03:16:59PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, January 11, 2023 9:20 AM
>>
>>Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>>>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>>>> This is a simplified network switch board example.
>>>> It has 2 synchronization channels, where each channel:
>>>> - provides clk to 8 PHYs driven by separated MAC chips,
>>>> - controls 2 DPLLs.
>>>>
>>>> Basically only given FW has control over its PHYs, so also a control
>>over it's
>>>> MUX inputs.
>>>> All external sources are shared between the channels.
>>>>
>>>> This is why we believe it is not best idea to enclose multiple DPLLs
>>with one
>>>> object:
>>>> - sources are shared even if DPLLs are not a single synchronizer chip,
>>>> - control over specific MUX type input shall be controllable from
>>different
>>>> driver/firmware instances.
>>>>
>>>> As we know the proposal of having multiple DPLLs in one object was a try
>>to
>>>> simplify currently implemented shared pins. We fully support idea of
>>having
>>>> interfaces as simple as possible, but at the same time they shall be
>>flexible
>>>> enough to serve many use cases.
>>>
>>>I must be missing context from other discussions but what is this
>>>proposal trying to solve? Well implemented shared pins is all we need.
>>
>>There is an entity containing the pins. The synchronizer chip. One
>>synchronizer chip contains 1-n DPLLs. The source pins are connected
>>to each DPLL (usually). What we missed in the original model was the
>>synchronizer entity. If we have it, we don't need any notion of somehow
>>floating pins as independent entities being attached to one or many
>>DPLL refcounted, etc. The synchronizer device holds them in
>>straightforward way.
>>
>>Example of a synchronizer chip:
>>https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-
>>frequency-translation/8a34044-multichannel-dpll-dco-four-eight-
>>channels#overview
>
>Not really, as explained above, multiple separated synchronizer chips can be
>connected to the same external sources.
>This is why I wrote this email, to better explain need for references between
>DPLLs and shared pins.
>Synchronizer chip object with multiple DPLLs would have sense if the pins would
>only belong to that single chip, but this is not true.

I don't understand how it is physically possible that 2 pins belong to 2
chips. Could you draw this to me?


>As the pins are shared between multiple DPLLs (both inside 1 integrated circuit
>and between multiple integrated circuits), all of them shall have current state
>of the source or output.
>Pins still need to be shared same as they would be inside of one synchronizer
>chip.

Do I understand correctly that you connect one synchronizer output to
the input of the second synchronizer chip?

>
>BR,
>Arkadiusz
