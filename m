Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77203FEB3A
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbhIBJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245569AbhIBJ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:29:34 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9B3C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 02:28:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b6so1815048wrh.10
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 02:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7iuvIPC9bhl1LolffJ5qHRSpgVqBB1R5gXFvaIS5FRg=;
        b=WQNKLYacQ4cIyYIVZRSotKDLK1414LXzQHMb0w1wiRxd74Wq6UETgkv4F7VOEsWNK7
         aipp40iW3G9TrZBO0Xo5TkgoELEXT+JE2ammE8cf6KbFpCWb3MGkR9S6zeLSRy33AKAe
         SjvVu5V6l3dRzn0GrzoNEXFWAPWcVLabg8yaYF/yIyMWb5Fi0DEWW3xOZVBS0yrA5ZD9
         hh1zPCEIg3HpciJM6VUk0eNvNH9W7FhrOLIbLrioyIHdLU4CIjKd2zsdtD/tHdmUkupV
         qGO1aeIwk7Fkhu17qca0dl5rjHotoSClnu8IuLVhPJyqa95BCPBYWA+DvsWDjxiIEjGU
         7G3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7iuvIPC9bhl1LolffJ5qHRSpgVqBB1R5gXFvaIS5FRg=;
        b=CZdEJVcOhtE7K2S89LRuhWdtd3tm1nHvwg9aVqo0AXYvpiGjvyrmv/E/XY5H8RPKWg
         1j1hYLTjAMIk0OwMx14o6mrB7tGiqxqaRb44UTiicGnTrsC0fRszOvQFB4oXq7f3D/gR
         5bEny//RdDY4eU8iTZjveRwfwhI/uaBWSByn5z8nKWaXFSU+F/yYbmW4NUFuNmNmfg3o
         +l/TxeLIhWBM1980Q6IvC9Og7GZ6JV+puT8ES1bVC1yRwdqa2SbV7iM7GQ1fT5fuqvDK
         OebpD/VvNtdXQkIB12EqzLjKG25Z+twGp+iCSDNPCK79kIt+YyK2xwz/Lsy7TfGTMbeo
         a0NA==
X-Gm-Message-State: AOAM533WSJC9x9ixoRKXBEQq9Ov1UDZzR3aFcJkJ9pjsFrk4zm7kiYIj
        cF41YPOdS7a2jQufIrfcs01elA==
X-Google-Smtp-Source: ABdhPJyFFvmQ0LXhQUxzUVktEFAfLypsGuwgbx7ulszxx6AHS1Hg+73IilpVUv5hUAQau5RwPPNtlQ==
X-Received: by 2002:adf:cd0f:: with SMTP id w15mr2562154wrm.346.1630574914954;
        Thu, 02 Sep 2021 02:28:34 -0700 (PDT)
Received: from ?IPv6:2001:861:44c0:66c0:98:6312:3c8:6531? ([2001:861:44c0:66c0:98:6312:3c8:6531])
        by smtp.gmail.com with ESMTPSA id h11sm1557349wrx.9.2021.09.02.02.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 02:28:34 -0700 (PDT)
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Marc Zyngier <maz@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Lee Jones <lee.jones@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
References: <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org>
 <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
 <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
 <YQuZ2cKVE+3Os25Z@google.com> <YRpeVLf18Z+1R7WE@google.com>
 <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com>
 <YRtkE62O+4EiyzF9@google.com>
 <CAGETcx-FS_88nQuF=xN4iJJ-nGnaeTnO-iiGpZuNELqE42FtoA@mail.gmail.com>
 <87o89vroec.wl-maz@kernel.org>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <44e56b25-acbb-ce3c-3f99-53a809309250@baylibre.com>
Date:   Thu, 2 Sep 2021 11:28:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87o89vroec.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 18/08/2021 13:19, Marc Zyngier wrote:
> On Tue, 17 Aug 2021 19:12:34 +0100,
> Saravana Kannan <saravanak@google.com> wrote:
>>
>> On Tue, Aug 17, 2021 at 12:24 AM Lee Jones <lee.jones@linaro.org> wrote:
>>>
>>> On Mon, 16 Aug 2021, Saravana Kannan wrote:
>>>>>>> I sent out the proper fix as a series:
>>>>>>> https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T/#t
>>>>>>>
>>>>>>> Marc, can you give it a shot please?
>>>>>>>
>>>>>>> -Saravana
>>>>>>
>>>>>> Superstar!  Thanks for taking the time to rectify this for all of us.
>>>>>
>>>>> Just to clarify:
>>>>>
>>>>>   Are we waiting on a subsequent patch submission at this point?
>>>>
>>>> Not that I'm aware of. Andrew added a "Reviewed-by" to all 3 of my
>>>> proper fix patches. I didn't think I needed to send any newer patches.
>>>> Is there some reason you that I needed to?
>>>
>>> Actually, I meant *this* patch.
>>
>> I think it'll be nice if Neil addresses the stuff Marc mentioned
>> (ideally) using the macros I suggested. Not sure if Marc is waiting on
>> that though. Marc also probably wants my mdio-mux series to merge
>> first before he takes this patch. So that it doesn't break networking
>> in his device.
> 
> Yup. Two things need to happen here:
> 
> - the MDIO fixes must be merged (I think they are queued, from what I
>   can see)
> 
> - the irqchip patch must be fixed so that the driver cannot be
>   unloaded (Saravana did explain what needs to be done).

I'll post a re-spin of this serie with the suggested fixes.

Neil

> 
> Once these two condition are met, I'll happily take this patch.
> 
> 	M.
> 

