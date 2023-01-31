Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D83682C37
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjAaMIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjAaMIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:08:47 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DEB28850;
        Tue, 31 Jan 2023 04:08:45 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso4305386wms.0;
        Tue, 31 Jan 2023 04:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LXDBZJ6DQUY8q0H3Hr2CjoKCJTKegFU0gvkcrKVlUm8=;
        b=Um/QK2syyNaHd7z4OL6702+EXwRz/T348pEAcYiLDPND5wbYyUCRQWtALLMmvDsQBU
         p3K+wshyt/lzFH/IT7nZfMUB4pQFvB3HErxjx9k80jlaggnW2rbN9edy+SMgKXhqIGs4
         TVM2YZOLas0Oc0aQds8izYzC3kLT2qEM9Qk7jUte2gysk2ypf/qteviErx6YR90BOShr
         g4a+IQEJ+PsETuML4+u2aMK+NZo8jEygaB4rsMihUHMem0887YOgx0YtuJJKt8OrozpT
         tl9uXjXSJ6zSxup91ZPJhXZ6m2ATUrvgc4gDFWk+CWBO5mCIXf/gzlce8aw2FU1Ov74S
         cZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXDBZJ6DQUY8q0H3Hr2CjoKCJTKegFU0gvkcrKVlUm8=;
        b=tjXzbPxK6v+3jFmC76u8JwZYloK38GQc81x1Pl1nIrLrvm0yaHGoU8OhGoZAK7NLWS
         Qz74iUxzkJkF7vLCgvib2ebfSKsqcLr80yE6BCW08MNklCbSRTlommrGNVcYZe6BPdub
         y6U9AoeRNRWbvXkxgvuSYqnGeWg1js8U+lf25Rob1dETi3VMer/Rx4r98kpdXoQ9YyTY
         UNrR17FTJr7mtp4JHiucZ/SGHkUyy4xnOTqJvjK3DTn1bQJ+8ZLR/4h630Ur43eqgP7l
         +izzHRayDiUrG2o3Q1vjzN+Ws/0pYR9SzQ8hPI1STuJgFFAq0LCHPUfYZ4uGUo38nozE
         OZFQ==
X-Gm-Message-State: AFqh2krWH9JV0urE3tpEa03yocfa1eb/HE9JHPvqo3i/hZNUqSJZwE/6
        XB0zmYXkwy8jtitXkSZc8Aw=
X-Google-Smtp-Source: AMrXdXsaZQUdGmic2BZ6FMNOzUuZgIOqj5Q3IsiAqEobxr97IKLkl5nS3Yi9qN7VSdO2D+GCSMjslA==
X-Received: by 2002:a05:600c:1da6:b0:3da:107e:a1e6 with SMTP id p38-20020a05600c1da600b003da107ea1e6mr53003349wms.17.1675166924182;
        Tue, 31 Jan 2023 04:08:44 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8ba:6a00:a5c0:1088:ecf4:92db? (dynamic-2a01-0c23-b8ba-6a00-a5c0-1088-ecf4-92db.c23.pool.telefonica.de. [2a01:c23:b8ba:6a00:a5c0:1088:ecf4:92db])
        by smtp.googlemail.com with ESMTPSA id d11-20020a05600c3acb00b003db30be4a54sm18918566wms.38.2023.01.31.04.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 04:08:43 -0800 (PST)
Message-ID: <74963e76-e417-c044-bd1b-7c6d53fc6994@gmail.com>
Date:   Tue, 31 Jan 2023 13:08:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
To:     Jerome Brunet <jbrunet@baylibre.com>, cphealy@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
References: <20230130231402.471493-1-cphealy@gmail.com>
 <1jbkmf2ewn.fsf@starbuckisacylon.baylibre.com>
 <671d564e-db1c-ed61-3538-97dd1916714d@gmail.com>
 <1j7cx32c4y.fsf@starbuckisacylon.baylibre.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1j7cx32c4y.fsf@starbuckisacylon.baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.2023 11:59, Jerome Brunet wrote:
> 
> On Tue 31 Jan 2023 at 11:38, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 31.01.2023 11:05, Jerome Brunet wrote:
>>>
>>> On Mon 30 Jan 2023 at 15:14, Chris Healy <cphealy@gmail.com> wrote:
>>>
>>>> From: Chris Healy <healych@amazon.com>
>>>>
>>>> The Meson G12A Internal PHY does not support standard IEEE MMD extended
>>>> register access, therefore add generic dummy stubs to fail the read and
>>>> write MMD calls. This is necessary to prevent the core PHY code from
>>>> erroneously believing that EEE is supported by this PHY even though this
>>>> PHY does not support EEE, as MMD register access returns all FFFFs.
>>>
>>> This is definitely something that should be done, Thx !
>>>
>>>>
>>>> Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
>>>
>>> This commit does not seems appropriate, especially since only the GXL ops
>>> are changed, not the g12a variant.
>>>
>> The diff is a little bit misleading. The patch affects the G12A PHY.
>>
>>> This brings a 2nd point, any reason for not changing the g12 variant ?
>>> I'm fairly confident it does support EEE either.
>>>
>> Supposedly it's a typo and you mean "doesn't". Neither Chris nor me
> 
> Indeed ;)
> 
>> have GXL HW and we didn't want to submit a patch just based on speculation.
>>
> 
> Ah - Ok.
> I've tested something similar recently while working on the PHY.
> I confirm that both GXL and G12a should stub those calls.
> 
> ... maybe in separate patches to help stable backports.
> 
> Do you want to handle this or should I ?
> 
I can take it, will add your Suggested-by.

>>>> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> Signed-off-by: Chris Healy <healych@amazon.com>
>>>>
> 
> Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
> 
>>>> ---
>>>>
>>>> Changes in v3:
>>>> * Add reviewed-by
>>>> Change in v2:
>>>> * Add fixes tag
>>>>
>>>>  drivers/net/phy/meson-gxl.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
>>>> index c49062ad72c6..5e41658b1e2f 100644
>>>> --- a/drivers/net/phy/meson-gxl.c
>>>> +++ b/drivers/net/phy/meson-gxl.c
>>>> @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
>>>>  		.handle_interrupt = meson_gxl_handle_interrupt,
>>>>  		.suspend        = genphy_suspend,
>>>>  		.resume         = genphy_resume,
>>>> +		.read_mmd	= genphy_read_mmd_unsupported,
>>>> +		.write_mmd	= genphy_write_mmd_unsupported,
>>>>  	},
>>>>  };
>>>
> 

