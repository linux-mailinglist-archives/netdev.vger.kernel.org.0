Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528CE297DE3
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 20:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762854AbgJXSCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 14:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762132AbgJXSCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 14:02:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5ACC0613CE;
        Sat, 24 Oct 2020 11:02:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m16so5141544ljo.6;
        Sat, 24 Oct 2020 11:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e3qfUNlTf5j+hx93raLpxJtzCNjvPp5WaZuFx7cHG10=;
        b=R+y+bEllHzXmVbwJRhfPomtc7tH0XqDafxBv3PGnEAnqPOlfSS5VKFJe9l//L/VRhF
         Q9uQzvTj1c8mCTuFNbjcPDbCXRiyklEXcqRcH9nglOxy/FdEdPWMf7a88a73jIG26lg9
         jcQ8piO5kD5hAFCBYLU0nBES6Xnf6ExLaMXSKucA6bjyiXaMZ/2emHOMnr0XkZhoDjPg
         ztmuXiI6I1d0/zgoY12qI6yLFyglVv3BV38Ghsy9yHXAsvmtmLob9z2WdMPuRPTfv5N5
         AguReLjwBNL0PASwRwXmGSsJgko1GQlgnwP5Ez6S7mugLzUKsOQG8W3dwV8+WuOEm5Cw
         zfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3qfUNlTf5j+hx93raLpxJtzCNjvPp5WaZuFx7cHG10=;
        b=oKghZ6lBvLhgeWw34kVagMbcqpebMae838dyetWXQqCMfE6kCDoMZKAIu5H1SHK6in
         Yx0iZsF2fuubraILQExSVE9SXyfCGiRpwAwpLMjW1uOtf9K5ymdMoubT6nwW5K8PSA32
         vtMkDWjeq1pKz0VFUzcIPom1anE94sp9enE6MJ+5lw6akEtel9jUlvgVqc5Q+rx1JUkN
         c1EPoMdHT2gm+25bnTJz0ZoJp4VMNmsDZdTFZH463esbSovXkAYo/Mq0u3bH4OLHz2wG
         yShLqHeah5ADwdfWaajLqnWXLXW87ofkjmFITr2bxYJGVkJSmsizwnSBmaUGJd4DfpG2
         C3Rw==
X-Gm-Message-State: AOAM532nlDSjG+kluO3taUXPBADq9zcLo2Ao5I32SEJ+j/hkSPdJEoBW
        9i1Z1ksQARN0XAVhOOo6rHV58HA1DWc=
X-Google-Smtp-Source: ABdhPJzeZ8ZvofUSvA0B+xmIlnWLumPGU/DhJsSj2aQC+rFE5mjfSqy/k7FmBDAoXXrGv1P623JMxA==
X-Received: by 2002:a2e:8e2a:: with SMTP id r10mr3140344ljk.344.1603562529927;
        Sat, 24 Oct 2020 11:02:09 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:2e4:31cf:c47:21a0:adde:4748? ([2a00:1fa0:2e4:31cf:c47:21a0:adde:4748])
        by smtp.gmail.com with ESMTPSA id p21sm558008lji.106.2020.10.24.11.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 11:02:09 -0700 (PDT)
Subject: Re: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, geert+renesas@glider.be,
        Julia Lawall <julia.lawall@inria.fr>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
 <000001d697c2$71651d70$542f5850$@mentor.com>
 <2819a14d-500c-561b-337e-417201eb040f@gmail.com>
 <000001d6a5ea$16fe8e80$44fbab80$@mentor.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ead79908-7abd-93da-f943-2387f4137875@gmail.com>
Date:   Sat, 24 Oct 2020 21:02:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <000001d6a5ea$16fe8e80$44fbab80$@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/19/20 10:32 AM, Andrew Gabbasov wrote:

   Sorry for the delay again, I keep forgetting about the mails I' couldn't reply
quickly. :-|

[...]
>>    The patch was set to the "Changes Requested" state -- most probably because of this
>> mail. Though unintentionally, it served to throttle actions on this patch. I did only
>> remember about this patch yesterday... :-)
>>
>> [...]
>>>> In the function ravb_hwtstamp_get() in ravb_main.c with the existing values
>>>> for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL (0x6)
>>>>
>>>> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
>>>> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>>>> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
>>>> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
>>>>
>>>> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true, it will never be
>>>> reached.
>>>>
>>>> This issue can be verified with 'hwtstamp_config' testing program
>>>> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type to ALL
>>>> and subsequent retrieving it gives incorrect value:
>>>>
>>>> $ hwtstamp_config eth0 OFF ALL
>>>> flags = 0
>>>> tx_type = OFF
>>>> rx_filter = ALL
>>>> $ hwtstamp_config eth0
>>>> flags = 0
>>>> tx_type = OFF
>>>> rx_filter = PTP_V2_L2_EVENT
>>>>
>>>> Correct this by converting if-else's to switch.
>>>
>>> Earlier you proposed to fix this issue by changing the value
>>> of RAVB_RXTSTAMP_TYPE_ALL constant to 0x4.
>>> Unfortunately, simple changing of the constant value will not
>>> be enough, since the code in ravb_rx() (actually determining
>>> if timestamp is needed)
>>>
>>> u32 get_ts = priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE;
>>> [...]
>>> get_ts &= (q == RAVB_NC) ?
>>>                 RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
>>>                 ~RAVB_RXTSTAMP_TYPE_V2_L2_EVENT;
>>>
>>> will work incorrectly and will need to be fixed too, making this
>>> piece of code more complicated.

   Judging on the above code, we can only stamp RAVB_RXTSTAMP_TYPE_V2_L2_EVENT
on the NC queue, and the rest only on the BE queue, right?

>>> So, it's probably easier and safer to keep the constant value and
>>> the code in ravb_rx() intact, and just fix the get ioctl code,
>>> where the issue is actually located.
>>
>>    We have one more issue with the current driver: bit 2 of priv->tstamp_rx_ctrl
>> can only be set as a part of the ALL mask, not individually. I'm now thinking we
>> should set RAVB_RXTSTAMP_TYPE[_ALL] to 2 (and probably just drop the ALL mask)...
> 
> [skipped]
> 
>>    Yeah, that's better. But do we really need am anonymous bit 2 that can't be
>> toggled other than via passing the ALL mask?
> 
> The driver supports setting timestamps either for all packets or for some
> particular kind of packets (events). Bit 1 in internal mask corresponds
> to this selected kind. Bit 2 corresponds to all other packets, and ALL mask 
> combines both variants. Although bit 2 can't be controlled individually
> (since there is no much sense to Request stamping of only packets, other than
> events, moreover, there is no user-visible filter constant to represent it),
> and that's why is anonymous, it provides a convenient way to handle stamping
> logic in ravb_rx(), so I don't see an immediate need to get rid of it.

    OK, you convinced me. :-)
    I suggest that you repost the patch since it's now applying with a large offset.

[...]
> Best regards,
> Andrew

MBR, Sergei
