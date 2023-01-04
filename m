Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBBB65CB44
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjADBNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjADBNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:13:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF13C764D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 17:13:15 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so202688pjb.1
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 17:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hIyLc4dyPkXfsevHYfCR8hcxUQC7oXgxLFpaOxvgL3A=;
        b=Z1nT2rJVfw14qKx09CXR+bHhDlwZtDv00v8GubIACTHXAo9/qZrQeUFNDcCe9vUJ21
         iRSoypU8GfbOgeABcWN+b6D+fAz5jSzEznX+VJC+X2VTO24am4B5oZsTkSAgRs61TBTk
         CGcbLAmLLj2wmmnwLgLTgJGSTiqPSH/NsdjiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIyLc4dyPkXfsevHYfCR8hcxUQC7oXgxLFpaOxvgL3A=;
        b=vncm6RWtSJRRf0QY7a2dDyzkkgNtGTKzYtv7EJ6PF0CNRGzLZRthFHyZ4QjUb0do69
         OJazv/xB2gQxD0mOmCblIKRHNOLKKFGdadfVdf7MFgPKGkzkYBXnEnzv0SoLx602ZEXW
         +6uISP/LHlBOkD6Wrs9K4Pn0W/WLNGGdYO3fl7VuBErCGgfbv9SiCwszdTEEA16bhZ0m
         4KB4H+XJ4f+w7FOZrvYhmIDXsiZraDR/eYzpK3TkRSiLL7YP21tue7BCYoOVwzPlNDj/
         WT3sZmAQEamusravR1fzCIEXlMRi0M3LMbQ8Qcb2E3bpCXLNOYlQRRJ3yFLenCbRabbI
         rzdA==
X-Gm-Message-State: AFqh2kqhOpXZGP90z/B/oPjpU75M2XDKLdvAa1MNFBfyxqxI5TM1dxM8
        VZjF0wXq+Ras7sJaJpBk+phk+w==
X-Google-Smtp-Source: AMrXdXtnqpa+fEUNJnxX8JUcQMQnBKyvMNuamX6NzYhp56+YodSn/GJNc2vCzANK5oaOeqT4bGb6Hg==
X-Received: by 2002:a17:90a:7404:b0:219:a8e5:79f5 with SMTP id a4-20020a17090a740400b00219a8e579f5mr49818675pjg.43.1672794794986;
        Tue, 03 Jan 2023 17:13:14 -0800 (PST)
Received: from [192.168.1.33] ([192.183.212.197])
        by smtp.googlemail.com with ESMTPSA id a14-20020a65640e000000b0049c8aa4211asm11304836pgv.8.2023.01.03.17.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 17:13:14 -0800 (PST)
Message-ID: <cc785f92-587c-c260-6369-c2dde9a392ca@schmorgal.com>
Date:   Tue, 3 Jan 2023 17:13:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230102234714.169831-1-doug@schmorgal.com>
 <657adc8e514d4486853ef90cdf97bd75f55b44fa.camel@redhat.com>
From:   Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH] wifi: libertas: return consistent length in
 lbs_add_wpa_tlv()
In-Reply-To: <657adc8e514d4486853ef90cdf97bd75f55b44fa.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Thanks for reviewing my patch! Comments below:

On 1/3/2023 9:47 AM, Dan Williams wrote:
> On Mon, 2023-01-02 at 15:47 -0800, Doug Brown wrote:
>> The existing code only converts the first IE to a TLV, but it returns
>> a
>> value that takes the length of all IEs into account. When there is
>> more
>> than one IE (which happens with modern wpa_supplicant versions for
>> example), the returned length is too long and extra junk TLVs get
>> sent
>> to the firmware, resulting in an association failure.
>>
>> Fix this by returning a length that only factors in the single IE
>> that
>> was converted. The firmware doesn't seem to support the additional
>> IEs,
>> so there is no value in trying to convert them to additional TLVs.
>>
>> Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
>> Signed-off-by: Doug Brown <doug@schmorgal.com>
>> ---
>>   drivers/net/wireless/marvell/libertas/cfg.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c
>> b/drivers/net/wireless/marvell/libertas/cfg.c
>> index 3e065cbb0af9..fcc5420ec7ea 100644
>> --- a/drivers/net/wireless/marvell/libertas/cfg.c
>> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
>> @@ -432,10 +432,9 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8
>> *ie, u8 ie_len)
>>          *tlv++ = 0;
>>          tlv_len = *tlv++ = *ie++;
>>          *tlv++ = 0;
>> -       while (tlv_len--)
>> -               *tlv++ = *ie++;
>> -       /* the TLV is two bytes larger than the IE */
>> -       return ie_len + 2;
>> +       memcpy(tlv, ie, tlv_len);
>> +       /* the TLV has a four-byte header */
>> +       return tlv_len + 4;
> 
> Since you're removing ie_len usage in the function, you might as well
> remove it from the function's arguments.

That's an excellent point. Thinking about it further after your
questions below, maybe we should keep it around and use it to validate
how far we are allowed to go into "ie" though...technically the existing
code could overflow the buffer with a malformed IE.

> Can you also update the comments to say something like "only copy the
> first IE into the command buffer".

Will do.

> Lastly, should you check the IE to make sure you're copying the WPA or
> WMM IE that the firmware expects? What other IEs does
> wpa_supplicant/cfg80211 add these days?

I was wondering about that too. I wasn't sure exactly which potential
IEs are the ones I should be looking for during this check. I've seen
"RSN Information" = 48 during my testing with WPA2, and assume based on
the old Marvell driver code that "Vendor Specific" = 221 would be used
with WPA. Going through the entire IE list and finding a match seems
safer than just blindly grabbing the first one. This would also be a
good time to add some bounds checking to make sure not to overrun "ie"
as well...

The other two IEs that are being added by modern wpa_supplicant are
"Extended Capabilities" (127) with SCS and mirrored SCS set:

7f 0b 00 00 00 00 00 00 40 00 00 00 20

...and "Supported Operating Classes" (59) with current = 81 and
supported = 81 and 82:

3b 03 51 51 52

I tried converting these additional IEs to TLVs. It resulted in a
successful connection, but the firmware didn't pass on these two IEs in
the association request -- I verified by sniffing packets. So I was
concerned about passing them onto the firmware if it's not making use of
them, in case it's interpreting them in some other unexpected way.

Do you have any guidance on which possible IEs I should be looking for
other than 48 and 221, or where I could find that out?

BTW, modern wpa_supplicant also doesn't work with libertas for one
additional reason: it violates NL80211_ATTR_MAX_SCAN_IE_LEN on some
older drivers including this one. But I believe that's a wpa_supplicant
problem that I can't really address in the kernel...

http://lists.infradead.org/pipermail/hostap/2022-January/040185.html

Thanks!
Doug
