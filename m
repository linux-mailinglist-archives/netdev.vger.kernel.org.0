Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F9C687028
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjBAUze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjBAUzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:55:11 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D157C704;
        Wed,  1 Feb 2023 12:54:46 -0800 (PST)
Received: from [IPV6:2003:e9:d70f:e348:e684:710d:4017:e1c4] (p200300e9d70fe348e684710d4017e1c4.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:e348:e684:710d:4017:e1c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C7B1CC0149;
        Wed,  1 Feb 2023 21:54:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1675284883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWQe8ddurgsjYuPYrNczj6KquCmyVn8EYAjajevyWqk=;
        b=jzHraYIKHzx4BETD/IDmd0PAaBBTHUKw9vvbq44WX2fM5Js567KGnWWJw2bTC3Rd5D1rf5
        PzwN4donRPjc4xqKvv/oyyTRiS3mEv/aIZzuAP5YDm9FcxxJVc49V7uypUuMcowo4tcQT4
        Zd1b9MDgAmLl6oqV5M6CnLJf6m/VhKZXqcVMwl+xequORUbnR8KC9/87oiv1azp8ADa36B
        7JntKdm3zh0G+IYukVOstNpv7GREuCLOFm69Ms2A49xXCTuFUQ1uTqDn0L7xmTKeEm/6xs
        ZgwFJslnOPlt/Ux6BhGFR49wMkU5wtdY6FI/BnM35ADCkZ9kL4H+3rzt0BzZTw==
Message-ID: <274d24c0-67e1-cc33-4bf4-0072b97d7e36@datenfreihafen.org>
Date:   Wed, 1 Feb 2023 21:54:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20230126162323.2986682-1-arnd@kernel.org>
 <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
 <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
 <77b78287-a352-85ae-0c3d-c3837be9bf1d@datenfreihafen.org>
 <Y9qRC2qz7ZbKslnb@google.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <Y9qRC2qz7ZbKslnb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 01.02.23 17:19, Dmitry Torokhov wrote:
> On Wed, Feb 01, 2023 at 01:42:37PM +0100, Stefan Schmidt wrote:
>> Hello Dmitry.
>>
>> On 01.02.23 01:50, Dmitry Torokhov wrote:
>>> On Tue, Jan 31, 2023 at 3:52 PM Dmitry Torokhov
>>> <dmitry.torokhov@gmail.com> wrote:
>>>>
>>>> Hi Arnd,
>>>>
>>>> On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote:
>>>>>
>>>>>           /* Reset */
>>>>> -       if (gpio_is_valid(rstn)) {
>>>>> +       if (rstn) {
>>>>>                   udelay(1);
>>>>> -               gpio_set_value_cansleep(rstn, 0);
>>>>> +               gpiod_set_value_cansleep(rstn, 0);
>>>>>                   udelay(1);
>>>>> -               gpio_set_value_cansleep(rstn, 1);
>>>>> +               gpiod_set_value_cansleep(rstn, 1);
>>>>
>>>> For gpiod conversions, if we are not willing to chase whether existing
>>>> DTSes specify polarities
>>>> properly and create workarounds in case they are wrong, we should use
>>>> gpiod_set_raw_value*()
>>>> (my preference would be to do the work and not use "raw" variants).
>>>>
>>>> In this particular case, arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
>>>> defines reset line as active low,
>>>> so you are leaving the device in reset state.
>>>>
>>>> Please review your other conversion patches.
>>>
>>> We also can not change the names of requested GPIOs from "reset-gpio"
>>> to "rstn-gpios" and expect
>>> this to work.
>>>
>>> Stefan, please consider reverting this and applying a couple of
>>> patches I will send out shortly.
>>
>> Thanks for having another look at these patches. Do you have the same
>> concern for the convesion patch to cc2520 that has been posted and applied
>> as well?
> 
> There are no DT users of cc2520 in the tree, so while ideally reset line
> should not be left in "logical active" state at the end of the probe, we
> can deal with this in a follow up patch, I doubt it will lead to
> regressions as it is.
> 
> If I were really nitpicky I would adjust error messages when we fail to
> get GPIOs, but again, can be done as a followup.

Feel free to send patches if you are in the mood on fixing this as well. :-)

>> Arnd, if you have any concerns about the revert please speak up soon as I am
>> going to revert your patch and get these patches into my tree later today.
>>
> 
> Thanks.

Reverted and pushed now. Your patches are applied as well. Thanks again 
for catching this early on.

regards
Stefan Schmidt

