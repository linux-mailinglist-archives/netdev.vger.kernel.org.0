Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6740D666695
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbjAKW57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbjAKW5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:57:44 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A69320A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 14:57:43 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s5so24514310edc.12
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 14:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+9nOsn7BiCYB2MUXq3VEbiap68N8gpzJ4Z9lQ+51IX8=;
        b=PmnYeDSlR2J5WStYPwks5FN5kxY2E1UXOtCA1pt24xpmVx+cHNhGSgIP0n90TvlqfM
         MCHtpPFW7vHTNjN7ZMVPt3uejwH2JFqSIvMZkPvMJj9CJbHAxPKqf54drz7vUCsyX7wd
         bVE61aS9XXVTubgIX42gmcSOFYYVEHg26ZJk4TLKWAvpjh/aj/jYwR8KeuNQLOf7PONP
         IbQNif65hwzImWjbQYKMMcR83wF27l1muZp63RRKoXvIFBvLEIrAr5p5gsMk8dyXe6sM
         oaLaKbleBEBrfBKEv7AzEbrvx49plVrJ4Q8uESwRzseLu/VijKy0uBao8ZZCMOl3eVOa
         KHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+9nOsn7BiCYB2MUXq3VEbiap68N8gpzJ4Z9lQ+51IX8=;
        b=4HSz91Eb4ESF4UqzX0ZKWlLKfrAQG9H4DI+dyWxNgcvB15XLLFNiKNjezHR1ZTiclA
         q6KXzVDRUJlYh0cemRHh0K8N/8YlYfRoI5SY8s1i83BxECTz/xdfjjLzeVfk095MjT1J
         /cKHOHvV67g4eUw4s3ml6AKcDFWwh4HRwbq65z/92CMCsqtTMOVbE8cLdKa+vH7GHrdP
         +3cp5z3xET60La4ZW5bWnu198JLG+XyPiyQp0nZgWCgtTffKdlc8b6rL3LhCikPX6aYz
         WtsSwO2qSY0F1iOmbE0q3ENkYu7xTHY5fKEVhC6mmYPLJr4GB7dJU5b5GaG5alaZP1X3
         AAxA==
X-Gm-Message-State: AFqh2kp6t/yNsYzUsOZ0Lq7xaqszP3YEknw/acPH/k7P9Kio+fOTezJe
        mxqBdUxNtMdeTIG4dy8H1qY=
X-Google-Smtp-Source: AMrXdXudTb5Twk2/YGVcTpp5E/FMOsZkcdTIy6Ep5f02t3+qk+bfUfUEiVI/nRZLqGTHV+PGWorflQ==
X-Received: by 2002:a05:6402:370:b0:492:bf3d:1a15 with SMTP id s16-20020a056402037000b00492bf3d1a15mr20914620edw.1.1673477861696;
        Wed, 11 Jan 2023 14:57:41 -0800 (PST)
Received: from ?IPV6:2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd? (dynamic-2a01-0c22-76e4-3a00-509b-51f2-b41a-a9cd.c22.pool.telefonica.de. [2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd])
        by smtp.googlemail.com with ESMTPSA id l15-20020aa7c3cf000000b00467481df198sm6556335edr.48.2023.01.11.14.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:57:41 -0800 (PST)
Message-ID: <20392974-d830-1ef5-9dd2-b83b82cfa263@gmail.com>
Date:   Wed, 11 Jan 2023 23:57:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx
 timeout
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
 <a709b727f117fbcad7bdd5abccfaa891775dbc65.camel@gmail.com>
 <fc80b42a-e488-e8a2-9669-d33a5150ac9b@gmail.com>
 <CAKgT0UewG-nfgd3mz6GPy=KLk8gkerToyapg4R+=g4wUo5fMWQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <CAKgT0UewG-nfgd3mz6GPy=KLk8gkerToyapg4R+=g4wUo5fMWQ@mail.gmail.com>
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

On 11.01.2023 23:38, Alexander Duyck wrote:
> On Wed, Jan 11, 2023 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 11.01.2023 17:16, Alexander H Duyck wrote:
>>> On Tue, 2023-01-10 at 23:03 +0100, Heiner Kallweit wrote:
>>>> There are still single reports of systems where ASPM incompatibilities
>>>> cause tx timeouts. It's not clear whom to blame, so let's disable
>>>> ASPM in case of a tx timeout.
>>>>
>>>> v2:
>>>> - add one-time warning for informing the user
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>
>>> >From past experience I have seen ASPM issues cause the device to
>>> disappear from the bus after failing to come out of L1. If that occurs
>>> this won't be able to recover after the timeout without resetting the
>>> bus itself. As such it may be necessary to disable the link states
>>> prior to using the device rather than waiting until after the error.
>>> That can be addressed in a follow-on patch if this doesn't resolve the
>>> issue.
>>>
>>
>> Interesting, reports about disappearing devices I haven't seen yet.
>> Symptoms I've seen differ, based on combination of more or less faulty
>> NIC chipset version, BIOS bugs, PCIe mainboard chipset.
>> Typically users experienced missed rx packets, tx timeouts or NIC lockups.
>> Disabling ASPM resulted in complaints of notebook users about reduced
>> system runtime on battery.
>> Meanwhile we found a good balance and reports about ASPM issues
>> became quite rare.
>> Just L1.2 still causes issues under load even with newer chipset versions,
>> therefore L1.2 is disabled per default.
> 
> Does your driver do any checking for MMIO failures on reads? Basically
> when the device disappears it should start returning ~0 on mmio reads.

Not yet, good idea.

> The device itself doesn't disappear, but it doesn't respond to
> requests anymore so it might be the "NIC lockups" case you mentioned.
> The Intel parts would disappear as they would trigger their "surprise
> removal" logic which would detach the netdevice. I have seen that
> issue on some platforms. It is kind of interesting when you can
> actually watch it happen as the issue was essentially a marginal PCIe
> connection so it would start out at x4, then renegotiate down with
> each ASPM L1 link bounce, and eventually it would end up at x1 before
> just dropping off the bus.
> 
> I agree pro-actively disabling ASPM is bad for power savings. So if
> this approach can resolve it then I am more than willing to give it a
> try. My main concern is if MMIO is already borked, updating the ASPM
> settings may not be enough to bring it back and it may require a
> secondary bus reset.

I'll think about how to further improve recovery in case of ASPM issues.

