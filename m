Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46C368A1E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhDWBCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWBCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:02:01 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACB5C061574
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 18:01:26 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id v13so2977361ilj.8
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 18:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N7LELpfTXNe57pVO8AH6kzjWOzVc47YUkaNy7rVneco=;
        b=cbQ9IuGiN3KSPTx1P3UZNi6kK498Oi0s8MDiMaic1xhrYfsPxJcq/fSOaJbYmQyvB9
         em8NJYuSwO98dssqLeOOvtTqLDPmP3aVLmbGmAieADt3N7Ztr/eCjnDbTk7aNipxQULX
         EIY0eC7/MbOJdD5sl/99mtZLhaWNEG6UIhS+xcq+W17kcAW02/iQwEXRDaGtMS5rsjqO
         Xx8Jc2cMRVL6plrz9HpY8MlB2LXV13iZnwoJE7/QHpNAxroSfIY/jOg7klkP/9+RdzM6
         DROZrjEvhVKrb2F3KuUF4qsJJVZR5cALN1Sp+GlaeQmTgJBKdgNQcssh3xS3d9XjJEgZ
         2uXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N7LELpfTXNe57pVO8AH6kzjWOzVc47YUkaNy7rVneco=;
        b=hMq2pQT+ynrFjDYTF0GZ2MXKozaJ3eB5zqw17jJf4mC1NPMSFRoZRLrniGeb/mJ18N
         bJyQbds0QSCFzKq3oOobu7RyuPETVAwtg0dz+a0vBhC1wS/y7VbxTBLuUeTh1JK0fdYZ
         qYOdS1Ssz0KZuRDngI0QfZnuiTjNgplJRe8RumtmPEta8XPjfUcVdlwauN2lhdv37oph
         AiT0wT9n/2TQfA00Xd9kA8dE9mnMVus6o2GwCaudSzyWxBdyvgqo5Rf+YZ3sr38jmtRt
         s+gYTFbBk9YdWnF+GCv8g5PxACcyBdIQXJrnfDaG/eQ77pKZsuR32FymXp3SRYZjDKGc
         tVaQ==
X-Gm-Message-State: AOAM532lc/Yj+0wlpQtVxFSpVjmoUhpG8YSLi7imdabTF6URLs3Bi2uz
        UddBfi2jtN1NE2+lj+rwSi0pTg==
X-Google-Smtp-Source: ABdhPJyeFZ8zOg4fxW4fc+MFxQ4tzei5UPsAm3K/IiKORlzQ/ghVtAX/DsSRZkwSwT2sp25r+8P7zA==
X-Received: by 2002:a05:6e02:c6b:: with SMTP id f11mr901139ilj.260.1619139685399;
        Thu, 22 Apr 2021 18:01:25 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id a7sm1841254iln.57.2021.04.22.18.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:01:24 -0700 (PDT)
Subject: Re: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
To:     subashab@codeaurora.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
References: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
 <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
 <89526b9845cc86143da2221fc2445557@codeaurora.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <32488f5d-c493-c8c4-fbf7-4370d6460f44@linaro.org>
Date:   Thu, 22 Apr 2021 20:01:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <89526b9845cc86143da2221fc2445557@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 6:28 PM, subashab@codeaurora.org wrote:
> On 2021-04-22 12:29, Alex Elder wrote:
>> On 4/22/21 1:20 PM, Bjorn Andersson wrote:
>>> The idiomatic way to handle the changelink flags/mask pair seems to be
>>> allow partial updates of the driver's link flags. In contrast the rmnet
>>> driver masks the incoming flags and then use that as the new flags.
>>>
>>> Change the rmnet driver to follow the common scheme, before the
>>> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
>>
>> I like this a lot.  It should have been implemented this way
>> to begin with; there's not much point to have the mask if
>> it's only applied to the passed-in value.
>>
>> KS, are you aware of *any* existing user space code that
>> would not work correctly if this were accepted?
>>
>> I.e., the way it was (is), the value passed in *assigns*
>> the data format flags.  But with Bjorn's changes, the
>> data format flags would be *updated* (i.e., any bits not
>> set in the mask field would remain with their previous
>> value).
>>
>> Reviewed-by: Alex Elder <elder@linaro.org>
> 
> What rmnet functionality which was broken without this change.
> That doesnt seem to be listed in this patch commit text.

The broken functionality is that RMNet is not using the
value/flag pair in the proper way.

Currently, the RMNet driver assigns the flags value,
and (strangly) applies the mask to that value.

The intent of the value/flag pair interface is to allow
a value to be provided, with a mask of bits that indicate
which bits in the value should be *updated* in the target
field stored in the kernel.

That way, one can *assign* a value (by providing a value
with flag value 0xffffffff), but one can also update one
or any number of bits, preserving existing values.

It means, for example, that a request can preserve
existing settings, while *adding* a receive checksum
offload.

> If this is an enhancement, then patch needs to be targeted to net-next
> instead of net

Bjorn targeted neither net nor net-next.  He just posted
the patch.  I think it could be either.

					-Alex
